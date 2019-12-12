Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC211C705
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 09:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbfLLITO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 03:19:14 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7222 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728201AbfLLITO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 03:19:14 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 077BD20775CFDA10E796;
        Thu, 12 Dec 2019 16:19:12 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 16:19:03 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2 1/4] KVM: VMX: Fix some typos and out-dated function names in comments
Date:   Thu, 12 Dec 2019 16:18:35 +0800
Message-ID: <1576138718-32728-2-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
References: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix some comment typos and out-dated function names in comments. Since
commit b1346ab2afbe ("KVM: nVMX: Rename prepare_vmcs02_*_full to
prepare_vmcs02_*_rare"), prepare_vmcs02_full has been renamed to
prepare_vmcs02_rare.
nested_vmx_merge_msr_bitmap is renamed to nested_vmx_prepare_msr_bitmap
since commit c992384bde84 ("KVM: vmx: speed up MSR bitmap merge").

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/nested.c             | 2 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c                | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7b01ef1d87e6..63ab49de324d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3427,7 +3427,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 
 /*
  * On a nested exit from L2 to L1, vmcs12.guest_cr0 might not be up-to-date
- * because L2 may have changed some cr0 bits directly (CRO_GUEST_HOST_MASK).
+ * because L2 may have changed some cr0 bits directly (CR0_GUEST_HOST_MASK).
  * This function returns the new value we should put in vmcs12.guest_cr0.
  * It's not enough to just return the vmcs02 GUEST_CR0. Rather,
  *  1. Bits that neither L0 nor L1 trapped, were set directly by L2 and are now
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index eb1ecd16fd22..cad128d1657b 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -23,12 +23,12 @@ BUILD_BUG_ON(1)
  *
  * When adding or removing fields here, note that shadowed
  * fields must always be synced by prepare_vmcs02, not just
- * prepare_vmcs02_full.
+ * prepare_vmcs02_rare.
  */
 
 /*
  * Keeping the fields ordered by size is an attempt at improving
- * branch prediction in vmcs_read_any and vmcs_write_any.
+ * branch prediction in vmcs12_read_any and vmcs12_write_any.
  */
 
 /* 16-bits */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51e3b27f90ed..dae712c8785e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1922,7 +1922,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 
 /*
- * Writes msr value into into the appropriate "register".
+ * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
@@ -2016,7 +2016,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 *
 		 * For nested:
 		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_merge_msr_bitmap. We should not touch the
+		 * nested_vmx_prepare_msr_bitmap. We should not touch the
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
@@ -2052,7 +2052,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 *
 		 * For nested:
 		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_merge_msr_bitmap. We should not touch the
+		 * nested_vmx_prepare_msr_bitmap. We should not touch the
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
@@ -6720,7 +6720,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	 * If PML is turned on, failure on enabling PML just results in failure
 	 * of creating the vcpu, therefore we can simplify PML logic (by
 	 * avoiding dealing with cases, such as enabling PML partially on vcpus
-	 * for the guest, etc.
+	 * for the guest), etc.
 	 */
 	if (enable_pml) {
 		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-- 
2.19.1

