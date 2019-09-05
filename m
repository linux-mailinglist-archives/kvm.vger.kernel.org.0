Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E2AADC7
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391840AbfIEVXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 17:23:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:37535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389651AbfIEVW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 17:22:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 14:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="383038927"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 05 Sep 2019 14:22:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Refactor up kvm_{g,s}et_msr() to simplify callers
Date:   Thu,  5 Sep 2019 14:22:54 -0700
Message-Id: <20190905212255.26549-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190905212255.26549-1-sean.j.christopherson@intel.com>
References: <20190905212255.26549-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the top-level MSR accessors to take/return the index and value
directly instead of requiring the caller to dump them into a msr_data
struct.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/svm.c              |   7 +--
 arch/x86/kvm/vmx/nested.c       |  22 ++-----
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/x86.c              | 103 ++++++++++++++++----------------
 5 files changed, 61 insertions(+), 81 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44a5ce57a905..649d80b5cd6f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1326,8 +1326,8 @@ int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
-int kvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
-int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
 
 struct x86_emulate_ctxt;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..030bc9f7b7a7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4425,15 +4425,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 static int wrmsr_interception(struct vcpu_svm *svm)
 {
-	struct msr_data msr;
 	u32 ecx = kvm_rcx_read(&svm->vcpu);
 	u64 data = kvm_read_edx_eax(&svm->vcpu);
 
-	msr.data = data;
-	msr.index = ecx;
-	msr.host_initiated = false;
-
-	if (kvm_set_msr(&svm->vcpu, &msr)) {
+	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..34f3051092be 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -864,9 +864,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 {
 	u32 i;
 	struct vmx_msr_entry e;
-	struct msr_data msr;
 
-	msr.host_initiated = false;
 	for (i = 0; i < count; i++) {
 		if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
 					&e, sizeof(e))) {
@@ -881,9 +879,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		msr.index = e.index;
-		msr.data = e.value;
-		if (kvm_set_msr(vcpu, &msr)) {
+		if (kvm_set_msr(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
 				__func__, i, e.index, e.value);
@@ -897,11 +893,11 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 
 static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 {
+	u64 data;
 	u32 i;
 	struct vmx_msr_entry e;
 
 	for (i = 0; i < count; i++) {
-		struct msr_data msr_info;
 		if (kvm_vcpu_read_guest(vcpu,
 					gpa + i * sizeof(e),
 					&e, 2 * sizeof(u32))) {
@@ -916,9 +912,7 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			return -EINVAL;
 		}
-		msr_info.host_initiated = false;
-		msr_info.index = e.index;
-		if (kvm_get_msr(vcpu, &msr_info)) {
+		if (kvm_get_msr(vcpu, e.index, &data)) {
 			pr_debug_ratelimited(
 				"%s cannot read MSR (%u, 0x%x)\n",
 				__func__, i, e.index);
@@ -927,10 +921,10 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 		if (kvm_vcpu_write_guest(vcpu,
 					 gpa + i * sizeof(e) +
 					     offsetof(struct vmx_msr_entry, value),
-					 &msr_info.data, sizeof(msr_info.data))) {
+					 &data, sizeof(data))) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
-				__func__, i, e.index, msr_info.data);
+				__func__, i, e.index, data);
 			return -EINVAL;
 		}
 	}
@@ -3889,7 +3883,6 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_msr_entry g, h;
-	struct msr_data msr;
 	gpa_t gpa;
 	u32 i, j;
 
@@ -3949,7 +3942,6 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 * from the guest value.  The intent is to stuff host state as
 	 * silently as possible, not to fully process the exit load list.
 	 */
-	msr.host_initiated = false;
 	for (i = 0; i < vmcs12->vm_entry_msr_load_count; i++) {
 		gpa = vmcs12->vm_entry_msr_load_addr + (i * sizeof(g));
 		if (kvm_vcpu_read_guest(vcpu, gpa, &g, sizeof(g))) {
@@ -3979,9 +3971,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			msr.index = h.index;
-			msr.data = h.value;
-			if (kvm_set_msr(vcpu, &msr)) {
+			if (kvm_set_msr(vcpu, h.index, h.value)) {
 				pr_debug_ratelimited(
 					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
 					__func__, j, h.index, h.value);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 570a233e272b..f4f4114e756f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4886,14 +4886,10 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu)
 
 static int handle_wrmsr(struct kvm_vcpu *vcpu)
 {
-	struct msr_data msr;
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
 
-	msr.data = data;
-	msr.index = ecx;
-	msr.host_initiated = false;
-	if (kvm_set_msr(vcpu, &msr) != 0) {
+	if (kvm_set_msr(vcpu, ecx, data) != 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd786d0b6..a67730600803 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1358,19 +1358,23 @@ void kvm_enable_efer_bits(u64 mask)
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
 /*
- * Writes msr value into into the appropriate "register".
+ * Write @data into the MSR specified by @index.  Select MSR specific fault
+ * checks are bypassed if @host_initiated is %true.
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
+			 bool host_initiated)
 {
-	switch (msr->index) {
+	struct msr_data msr;
+
+	switch (index) {
 	case MSR_FS_BASE:
 	case MSR_GS_BASE:
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
-		if (is_noncanonical_address(msr->data, vcpu))
+		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
@@ -1387,9 +1391,46 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * value, and that something deterministic happens if the guest
 		 * invokes 64-bit SYSENTER.
 		 */
-		msr->data = get_canonical(msr->data, vcpu_virt_addr_bits(vcpu));
+		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
 	}
-	return kvm_x86_ops->set_msr(vcpu, msr);
+
+	msr.data = data;
+	msr.index = index;
+	msr.host_initiated = host_initiated;
+
+	return kvm_x86_ops->set_msr(vcpu, &msr);
+}
+
+/*
+ * Read the MSR specified by @index into @data.  Select MSR specific fault
+ * checks are bypassed if @host_initiated is %true.
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+			 bool host_initiated)
+{
+	struct msr_data msr;
+	int ret;
+
+	msr.index = index;
+	msr.host_initiated = host_initiated;
+
+	ret = kvm_x86_ops->get_msr(vcpu, &msr);
+	if (!ret)
+		*data = msr.data;
+	return ret;
+}
+
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	return __kvm_get_msr(vcpu, index, data, false);
+}
+EXPORT_SYMBOL_GPL(kvm_get_msr);
+
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	return __kvm_set_msr(vcpu, index, data, false);
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
@@ -1398,27 +1439,12 @@ EXPORT_SYMBOL_GPL(kvm_set_msr);
  */
 static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	struct msr_data msr;
-	int r;
-
-	msr.index = index;
-	msr.host_initiated = true;
-	r = kvm_get_msr(vcpu, &msr);
-	if (r)
-		return r;
-
-	*data = msr.data;
-	return 0;
+	return __kvm_get_msr(vcpu, index, data, true);
 }
 
 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	struct msr_data msr;
-
-	msr.data = *data;
-	msr.index = index;
-	msr.host_initiated = true;
-	return kvm_set_msr(vcpu, &msr);
+	return __kvm_set_msr(vcpu, index, *data, true);
 }
 
 #ifdef CONFIG_X86_64
@@ -2757,18 +2783,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr_common);
 
-
-/*
- * Reads an msr value (of 'msr_index') into 'pdata'.
- * Returns 0 on success, non-0 otherwise.
- * Assumes vcpu_load() was already called.
- */
-int kvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
-{
-	return kvm_x86_ops->get_msr(vcpu, msr);
-}
-EXPORT_SYMBOL_GPL(kvm_get_msr);
-
 static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
 	u64 data;
@@ -5972,28 +5986,13 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	struct msr_data msr;
-	int r;
-
-	msr.index = msr_index;
-	msr.host_initiated = false;
-	r = kvm_get_msr(emul_to_vcpu(ctxt), &msr);
-	if (r)
-		return r;
-
-	*pdata = msr.data;
-	return 0;
+	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
 }
 
 static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 data)
 {
-	struct msr_data msr;
-
-	msr.data = data;
-	msr.index = msr_index;
-	msr.host_initiated = false;
-	return kvm_set_msr(emul_to_vcpu(ctxt), &msr);
+	return kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
 }
 
 static u64 emulator_get_smbase(struct x86_emulate_ctxt *ctxt)
-- 
2.22.0

