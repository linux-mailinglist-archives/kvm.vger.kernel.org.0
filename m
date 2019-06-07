Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA946392AB
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfFGRBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:01:40 -0400
Received: from foss.arm.com ([217.140.110.172]:44506 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbfFGRBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:01:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCA33499;
        Fri,  7 Jun 2019 10:01:39 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51ED43F71A;
        Fri,  7 Jun 2019 10:01:39 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 1/2] list: Clean up ghost socket files
Date:   Fri,  7 Jun 2019 18:01:20 +0100
Message-Id: <20190607170121.16557-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190607170121.16557-1-andre.przywara@arm.com>
References: <20190607170121.16557-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kvmtool (or the host kernel) crashes or gets killed, we cannot
automatically remove the socket file we created for that VM.
A later call of "lkvm list" iterates over all those files and complains
about those "ghost socket files", as there is no one listening on
the other side. Also sometimes the automatic guest name generation
happens to generate the same name again, so an unrelated "lkvm run"
later complains and stops, which is bad for automation.

As the only code doing a listen() on this socket is kvmtool upon VM
*creation*, such an orphaned socket file will never come back to life,
so we can as well unlink() those sockets in the code. This spares the
user from doing it herself.
We keep the message in the code to notify the user of this.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 kvm-ipc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kvm-ipc.c b/kvm-ipc.c
index e07ad105..29ea498a 100644
--- a/kvm-ipc.c
+++ b/kvm-ipc.c
@@ -101,9 +101,9 @@ int kvm__get_sock_by_instance(const char *name)
 
 	r = connect(s, (struct sockaddr *)&local, len);
 	if (r < 0 && errno == ECONNREFUSED) {
-		/* Tell the user clean ghost socket file */
-		pr_err("\"%s\" could be a ghost socket file, please remove it",
-				sock_file);
+		/* Clean up the ghost socket file */
+		unlink(local.sun_path);
+		pr_info("Removed ghost socket file \"%s\".", sock_file);
 		return r;
 	} else if (r < 0) {
 		return r;
-- 
2.17.1

