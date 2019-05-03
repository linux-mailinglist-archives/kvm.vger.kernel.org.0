Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30E7132DF
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfECRIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:08:31 -0400
Received: from foss.arm.com ([217.140.101.70]:37506 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfECRIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:08:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC7D015AD;
        Fri,  3 May 2019 10:08:30 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0796B3F557;
        Fri,  3 May 2019 10:08:29 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH kvmtool 1/2] list: Clean up ghost socket files
Date:   Fri,  3 May 2019 18:08:20 +0100
Message-Id: <20190503170821.260705-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503170821.260705-1-andre.przywara@arm.com>
References: <20190503170821.260705-1-andre.przywara@arm.com>
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
user the messages and the burden of doing it herself.
We keep a message in the code to notify the user of this.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 kvm-ipc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kvm-ipc.c b/kvm-ipc.c
index e07ad105..d9a07595 100644
--- a/kvm-ipc.c
+++ b/kvm-ipc.c
@@ -101,9 +101,8 @@ int kvm__get_sock_by_instance(const char *name)
 
 	r = connect(s, (struct sockaddr *)&local, len);
 	if (r < 0 && errno == ECONNREFUSED) {
-		/* Tell the user clean ghost socket file */
-		pr_err("\"%s\" could be a ghost socket file, please remove it",
-				sock_file);
+		/* Clean up the ghost socket file */
+		unlink(local.sun_path);
 		return r;
 	} else if (r < 0) {
 		return r;
@@ -140,6 +139,7 @@ int kvm__enumerate_instances(int (*callback)(const char *name, int fd))
 	struct dirent *entry;
 	int ret = 0;
 	const char *path;
+	int cleaned = 0;
 
 	path = kvm__get_dir();
 
@@ -164,8 +164,11 @@ int kvm__enumerate_instances(int (*callback)(const char *name, int fd))
 
 			*p = 0;
 			sock = kvm__get_sock_by_instance(entry->d_name);
-			if (sock < 0)
+			if (sock < 0) {
+				if (errno == ECONNREFUSED)
+					cleaned++;
 				continue;
+			}
 			ret = callback(entry->d_name, sock);
 			close(sock);
 			if (ret < 0)
@@ -175,6 +178,9 @@ int kvm__enumerate_instances(int (*callback)(const char *name, int fd))
 
 	closedir(dir);
 
+	if (cleaned)
+		pr_info("Removed %d ghost socket files", cleaned);
+
 	return ret;
 }
 
-- 
2.17.1

