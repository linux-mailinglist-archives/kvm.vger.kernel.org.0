Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA22416147
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbhIWOpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:19 -0400
Received: from foss.arm.com ([217.140.110.172]:35470 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241670AbhIWOpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDEEC113E;
        Thu, 23 Sep 2021 07:43:46 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8F323F718;
        Thu, 23 Sep 2021 07:43:45 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 01/10] builtin-run: Treat specifying both --kernel and --firmware as an error
Date:   Thu, 23 Sep 2021 15:44:56 +0100
Message-Id: <20210923144505.60776-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the user specifies both the --kernel and the --firmware arguments,
--firmware takes precedence and --kernel is silently ignored. Since kvmtool
has no way of knowing what the user really intended, and guessing that
--firmware is the right argument might prove to be quite unexpected for the
user, be vocal about the incompatibility and refuse to create the VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 7f93b9d9312c..8bb8051680b1 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -513,6 +513,9 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	kvm->nr_disks = kvm->cfg.image_count;
 
+	if (kvm->cfg.kernel_filename && kvm->cfg.firmware_filename)
+		die("Only one of --kernel or --firmware can be specified");
+
 	if (!kvm->cfg.kernel_filename && !kvm->cfg.firmware_filename) {
 		kvm->cfg.kernel_filename = find_kernel();
 
-- 
2.31.1

