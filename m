Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8699660105
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 08:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfGEGaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 02:30:35 -0400
Received: from mx57.baidu.com ([61.135.168.57]:33648 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726004AbfGEGae (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jul 2019 02:30:34 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jul 2019 02:30:34 EDT
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 898451EBA003;
        Fri,  5 Jul 2019 14:24:49 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: [PATCH][resend] KVM: fix error handling in svm_hardware_setup
Date:   Fri,  5 Jul 2019 14:24:49 +0800
Message-Id: <1562307889-4133-1-git-send-email-lirongqing@baidu.com>
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
 arch/x86/kvm/svm.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a69eff0aa40b..b9e83a21e35f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1292,6 +1292,20 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 				    control->pause_filter_count, old);
 }
 
+static void svm_hardware_teardown(void)
+{
+	int cpu;
+
+	if (svm_sev_enabled())
+		bitmap_free(sev_asid_bitmap);
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
@@ -1398,25 +1412,10 @@ static __init int svm_hardware_setup(void)
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
-	if (svm_sev_enabled())
-		bitmap_free(sev_asid_bitmap);
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
@@ -7151,7 +7150,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
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

