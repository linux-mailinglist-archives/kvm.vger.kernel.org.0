Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC29155A8F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBGPVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:21:12 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33910 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726974AbgBGPVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:21:12 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4BA45BAC8A096D99EEDA;
        Fri,  7 Feb 2020 23:21:07 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 7 Feb 2020
 23:20:57 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2] KVM: nVMX: Fix some comment typos and coding style
Date:   Fri, 7 Feb 2020 23:22:45 +0800
Message-ID: <1581088965-3334-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix some typos in the comments. Also fix coding style.
[Sean Christopherson rewrites the comment of write_fault_to_shadow_pgtable
field in struct kvm_vcpu_arch.]

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
v1->v2:
Use Sean Christopherson' comment for write_fault_to_shadow_pgtable
---
 arch/x86/include/asm/kvm_host.h | 16 +++++++++++++---
 arch/x86/kvm/vmx/nested.c       |  5 +++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..40a0c0fd95ca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -781,9 +781,19 @@ struct kvm_vcpu_arch {
 	u64 msr_kvm_poll_control;
 
 	/*
-	 * Indicate whether the access faults on its page table in guest
-	 * which is set when fix page fault and used to detect unhandeable
-	 * instruction.
+	 * Indicates the guest is trying to write a gfn that contains one or
+	 * more of the PTEs used to translate the write itself, i.e. the access
+	 * is changing its own translation in the guest page tables.  KVM exits
+	 * to userspace if emulation of the faulting instruction fails and this
+	 * flag is set, as KVM cannot make forward progress.
+	 *
+	 * If emulation fails for a write to guest page tables, KVM unprotects
+	 * (zaps) the shadow page for the target gfn and resumes the guest to
+	 * retry the non-emulatable instruction (on hardware).  Unprotecting the
+	 * gfn doesn't allow forward progress for a self-changing access because
+	 * doing so also zaps the translation for the gfn, i.e. retrying the
+	 * instruction will hit a !PRESENT fault, which results in a new shadow
+	 * page and sends KVM back to square one.
 	 */
 	bool write_fault_to_shadow_pgtable;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2eda357c..e7faebccd733 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -544,7 +544,8 @@ static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
 	}
 }
 
-static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap) {
+static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
+{
 	int msr;
 
 	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
@@ -1981,7 +1982,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 	}
 
 	/*
-	 * Clean fields data can't de used on VMLAUNCH and when we switch
+	 * Clean fields data can't be used on VMLAUNCH and when we switch
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
 	if (from_launch || evmcs_gpa_changed)
-- 
2.19.1

