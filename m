Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796BB1696C2
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2020 09:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgBWIN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 03:13:26 -0500
Received: from mx59.baidu.com ([61.135.168.59]:25356 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726386AbgBWIN0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 23 Feb 2020 03:13:26 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 82DE111C0034;
        Sun, 23 Feb 2020 16:13:12 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][resend] KVM: fix error handling in svm_hardware_setup
Date:   Sun, 23 Feb 2020 16:13:12 +0800
Message-Id: <1582445592-732-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rename svm_hardware_unsetup as svm_hardware_teardown, move
it before svm_hardware_setup, and call it to free all memory
if fail to setup in svm_hardware_setup, otherwise memory will
be leaked

remove __exit attribute for it since it is called in __init
function

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
original patch: https://patchwork.kernel.org/patch/10852055/ 


 arch/x86/kvm/svm.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a3e32d61d60c..7cde582fb624 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1350,6 +1350,24 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
+static void svm_hardware_teardown(void)
+{
+	int cpu;
+
+	if (svm_sev_enabled()) {
+		bitmap_free(sev_asid_bitmap);
+		bitmap_free(sev_reclaim_asid_bitmap);
+
+		sev_flush_asids();
+	}
+
+	for_each_possible_cpu(cpu)
+		svm_cpu_uninit(cpu);
+
+	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
+	iopm_base = 0;
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1463,29 +1481,10 @@ static __init int svm_hardware_setup(void)
 	return 0;
 
 err:
-	__free_pages(iopm_pages, IOPM_ALLOC_ORDER);
-	iopm_base = 0;
+	svm_hardware_teardown();
 	return r;
 }
 
-static __exit void svm_hardware_unsetup(void)
-{
-	int cpu;
-
-	if (svm_sev_enabled()) {
-		bitmap_free(sev_asid_bitmap);
-		bitmap_free(sev_reclaim_asid_bitmap);
-
-		sev_flush_asids();
-	}
-
-	for_each_possible_cpu(cpu)
-		svm_cpu_uninit(cpu);
-
-	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
-	iopm_base = 0;
-}
-
 static void init_seg(struct vmcb_seg *seg)
 {
 	seg->selector = 0;
@@ -7378,7 +7377,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
-	.hardware_unsetup = svm_hardware_unsetup,
+	.hardware_unsetup = svm_hardware_teardown,
 	.check_processor_compatibility = svm_check_processor_compat,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
-- 
2.16.2

