Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1002441614F
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbhIWOpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:31 -0400
Received: from foss.arm.com ([217.140.110.172]:35536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241766AbhIWOp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A2B6113E;
        Thu, 23 Sep 2021 07:43:56 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3402D3F718;
        Thu, 23 Sep 2021 07:43:55 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 08/10] Add --nocompat option to disable compat warnings
Date:   Thu, 23 Sep 2021 15:45:03 +0100
Message-Id: <20210923144505.60776-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit e66942073035 ("kvm tools: Guest kernel compatability") added the
functionality that enables devices to print a warning message if the device
hasn't been initialized by the time the VM is destroyed. The purpose of
these messages is to let the user know if the kernel hasn't been built with
the correct Kconfig options to take advantage of the said devices (all
using virtio).

Since then, kvmtool has evolved and now supports loading different payloads
(like firmware images), and having those warnings even when it is entirely
intentional for the payload not to touch the devices can be confusing for
the user and makes the output unnecessarily verbose in those cases.

Add the --nocompat option to disable the warnings; the warnings are still
enabled by default.

Reported-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c            | 5 ++++-
 guest_compat.c           | 1 +
 include/kvm/kvm-config.h | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1fa6fb..a736b63ce7e5 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -111,6 +111,8 @@ void kvm_run_set_wrapper_sandbox(void)
 	OPT_BOOLEAN('\0', "nodefaults", &(cfg)->nodefaults, "Disable"   \
 			" implicit configuration that cannot be"	\
 			" disabled otherwise"),				\
+	OPT_BOOLEAN('\0', "nocompat", &(cfg)->nocompat, "Disable"	\
+			" compat warnings"),				\
 	OPT_CALLBACK('\0', "9p", NULL, "dir_to_share,tag_name",		\
 		     "Enable virtio 9p to share files between host and"	\
 		     " guest", virtio_9p_rootdir_parser, kvm),		\
@@ -709,7 +711,8 @@ static int kvm_cmd_run_work(struct kvm *kvm)
 
 static void kvm_cmd_run_exit(struct kvm *kvm, int guest_ret)
 {
-	compat__print_all_messages();
+	if (!kvm->cfg.nocompat)
+		compat__print_all_messages();
 
 	init_list__exit(kvm);
 
diff --git a/guest_compat.c b/guest_compat.c
index fd4704b20b16..a413c12ccd2e 100644
--- a/guest_compat.c
+++ b/guest_compat.c
@@ -88,6 +88,7 @@ int compat__print_all_messages(void)
 
 		printf("\n  # KVM compatibility warning.\n\t%s\n\t%s\n",
 			msg->title, msg->desc);
+		printf("\tTo stop seeing this warning, use the --nocompat option.\n");
 
 		list_del(&msg->list);
 		compat__free(msg);
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 6a5720c4c7d4..329aa46e6eda 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -28,6 +28,7 @@ struct kvm_config {
 	u64 vsock_cid;
 	bool virtio_rng;
 	bool nodefaults;
+	bool nocompat;
 	int active_console;
 	int debug_iodelay;
 	int nrcpus;
-- 
2.31.1

