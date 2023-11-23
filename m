Return-Path: <kvm+bounces-2343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEB07F55BD
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 02:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8D992816E4
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 01:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86B81FB8;
	Thu, 23 Nov 2023 01:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx310.baidu.com [180.101.52.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF03F1B2
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 17:04:25 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 38EF07F003A5;
	Thu, 23 Nov 2023 09:04:24 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: x86@kernel.org,
	kvm@vger.kernel.org,
	mlevitsk@redhat.com,
	yilun.xu@linux.intel.com
Subject: [PATCH v2] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to create vcpu
Date: Thu, 23 Nov 2023 09:04:24 +0800
Message-Id: <20231123010424.10274-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Static key kvm_has_noapic_vcpu should be reduced when fail to create
vcpu, opportunistically change to call kvm_free_lapic only when LAPIC
is in kernel in kvm_arch_vcpu_destroy

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff v1: call kvm_free_lapic conditionally in kvm_arch_vcpu_destroy

 arch/x86/kvm/x86.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c92407..3cadf28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12079,7 +12079,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.mci_ctl2_banks);
 	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
-	kvm_free_lapic(vcpu);
+	if (lapic_in_kernel(vcpu))
+		kvm_free_lapic(vcpu);
+	else
+		static_branch_dec(&kvm_has_noapic_vcpu);
 fail_mmu_destroy:
 	kvm_mmu_destroy(vcpu);
 	return r;
@@ -12122,14 +12125,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
 	kfree(vcpu->arch.mci_ctl2_banks);
-	kvm_free_lapic(vcpu);
+
+	if (lapic_in_kernel(vcpu))
+		kvm_free_lapic(vcpu);
+	else
+		static_branch_dec(&kvm_has_noapic_vcpu);
+
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
-	if (!lapic_in_kernel(vcpu))
-		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
-- 
2.9.4


