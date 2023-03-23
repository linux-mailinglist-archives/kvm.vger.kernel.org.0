Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085CF6C607E
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCWHSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjCWHSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:18:13 -0400
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 074BD26B1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:18:06 -0700 (PDT)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 86A2A7F0005D;
        Thu, 23 Mar 2023 15:18:04 +0800 (CST)
From:   lirongqing@baidu.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
Date:   Thu, 23 Mar 2023 15:18:04 +0800
Message-Id: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
is not needed to create

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8354262..be98c69 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6667,6 +6667,11 @@ static bool get_nx_auto_mode(void)
 	return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT) && !cpu_mitigations_off();
 }
 
+static bool cpu_has_itlb_multihit(void)
+{
+	return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT);
+}
+
 static void __set_nx_huge_pages(bool val)
 {
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
@@ -6677,6 +6682,11 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	bool old_val = nx_huge_pages;
 	bool new_val;
 
+	if (!cpu_has_itlb_multihit()) {
+		__set_nx_huge_pages(false);
+		return 0;
+	}
+
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
 	if (sysfs_streq(val, "off"))
 		new_val = 0;
@@ -6816,6 +6826,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	uint old_period, new_period;
 	int err;
 
+	if (!cpu_has_itlb_multihit())
+		return 0;
+
 	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
 
 	err = param_set_uint(val, kp);
@@ -6971,6 +6984,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	int err;
 
+	if (!cpu_has_itlb_multihit())
+		return 0;
+
 	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_huge_page_recovery_thread);
@@ -6982,6 +6998,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 {
+	if (!cpu_has_itlb_multihit())
+		return;
+
 	if (kvm->arch.nx_huge_page_recovery_thread)
 		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
-- 
2.9.4

