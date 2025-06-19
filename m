Return-Path: <kvm+bounces-49992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B8AAE0C63
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 20:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE38D1BC7C30
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 18:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47892BE7A2;
	Thu, 19 Jun 2025 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHzZY46Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB042BCF4C
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750356139; cv=none; b=QpWBpmBDpDFQwnzFY8Ymqt2n65gpahiCsxkczzfYVGRX6FRN5AtEpoDuuL/cL+EQ8bPnineOZwHhiBOp/NbIoyKbcriW1WwztkNX1H33TeyslA8t1LV19ssIQLwiuLog9T38y2E3jsRsknObPa7o+JnTm6FeKYnZJHfaFqJmiLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750356139; c=relaxed/simple;
	bh=8KdtUH3AI61SKWEXYQnewnEKs9oM/zzAo+vZ6Sa/fOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imaagkBQjRFX4TEXX/eCam8JSdoKbkpHl5xg9L9H+NWR7KPKjpa0wFrWb3Niulwd8SbVgQ4UmmtVf/ASGt49BS5mEqUfhfqp9AG5Yht5D4iwn4WnArwI9m6pkDjupjSPyW2rPyz5Kbk39XBQBEBtbz6HPclLWB6qp40o1IJuKdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cHzZY46Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750356137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykIHLd1yRqJfZAp8JVQ3Zglijy0kzIzJbvRaR5fla/g=;
	b=cHzZY46Y+mnw/HIDnIbDdMW89ehsQKH+ldkzP30rW0ndn+5cCBrpdjYskTrW9UfHRifll9
	3q8guzvhBe/+5LFhkOry53nxs19WEyfKqJf9fzzYE8J10RE7NdKW0X5icIIlWQlmNzrp4D
	Hw08KAbAf2xveww8T+Qnr3dG5l7DQ2U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-petRG1UGOvCLVAYykkWEpw-1; Thu,
 19 Jun 2025 14:02:13 -0400
X-MC-Unique: petRG1UGOvCLVAYykkWEpw-1
X-Mimecast-MFC-AGG-ID: petRG1UGOvCLVAYykkWEpw_1750356131
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C03D180034E;
	Thu, 19 Jun 2025 18:02:11 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E934180035C;
	Thu, 19 Jun 2025 18:02:09 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	mikko.ylinen@linux.intel.com,
	kirill.shutemov@intel.com,
	jiewen.yao@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH 3/3] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Date: Thu, 19 Jun 2025 14:01:59 -0400
Message-ID: <20250619180159.187358-4-pbonzini@redhat.com>
In-Reply-To: <20250619180159.187358-1-pbonzini@redhat.com>
References: <20250619180159.187358-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Binbin Wu <binbin.wu@linux.intel.com>

Exit to userspace for TDG.VP.VMCALL<GetTdVmCallInfo> via KVM_EXIT_TDX,
to allow userspace to provide information about the support of
TDVMCALLs when r12 is 1 for the TDVMCALLs beyond the GHCI base API.

GHCI spec defines the GHCI base TDVMCALLs: <GetTdVmCallInfo>, <MapGPA>,
<ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
<Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
<Instruction.WRMSR>. They must be supported by VMM to support TDX guests.

For GetTdVmCallInfo
- When leaf (r12) to enumerate TDVMCALL functionality is set to 0,
  successful execution indicates all GHCI base TDVMCALLs listed above are
  supported.

  Update the KVM TDX document with the set of the GHCI base APIs.

- When leaf (r12) to enumerate TDVMCALL functionality is set to 1, it
  indicates the TDX guest is querying the supported TDVMCALLs beyond
  the GHCI base TDVMCALLs.
  Exit to userspace to let userspace set the TDVMCALL sub-function bit(s)
  accordingly to the leaf outputs.  KVM could set the TDVMCALL bit(s)
  supported by itself when the TDVMCALLs don't need support from userspace
  after returning from userspace and before entering guest. Currently, no
  such TDVMCALLs implemented, KVM just sets the values returned from
  userspace.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
[Adjust userspace API. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 15 +++++++++++++-
 arch/x86/kvm/vmx/tdx.c         | 38 ++++++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h       |  5 +++++
 3 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3643d853a634..2b1656907356 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7190,6 +7190,11 @@ The valid value for 'flags' is:
 					u64 gpa;
 					u64 size;
 				} get_quote;
+				struct {
+					u64 ret;
+					u64 leaf;
+					u64 r11, r12, r13, r14;
+				} get_tdvmcall_info;
 			};
 		} tdx;

@@ -7216,9 +7221,17 @@ queued successfully, the TDX guest can poll the status field in the
 shared-memory area to check whether the Quote generation is completed or
 not. When completed, the generated Quote is returned via the same buffer.
 
+* ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
+status of TDVMCALLs.  The output values for the given leaf should be
+placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
+field of the union.  This TDVMCALL must succeed, therefore KVM leaves
+``ret`` equal to ``TDVMCALL_STATUS_SUCCESS`` and ``r11`` to ``r14``
+equal to zero on entry.
+
 KVM may add support for more values in the future that may cause a userspace
 exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
-it will enter with output fields already valid; in the common case, the
+it will enter with output fields already valid as mentioned for
+``TDVMCALL_GET_TD_VM_CALL_INFO`` above; in the common case, the
 ``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED``.
 Userspace need not do anything if it does not wish to support a TDVMCALL.
 ::
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6878a76069f8..5804d1b1ea0e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1451,18 +1451,49 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_get_td_vm_call_info(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	tdvmcall_set_return_code(vcpu, vcpu->run->tdx.get_tdvmcall_info.ret);
+
+	/*
+	 * For now, there is no TDVMCALL beyond GHCI base API supported by KVM
+	 * directly without the support from userspace, just set the value
+	 * returned from userspace.
+	 */
+	tdx->vp_enter_args.r11 = vcpu->run->tdx.get_tdvmcall_info.r11;
+	tdx->vp_enter_args.r12 = vcpu->run->tdx.get_tdvmcall_info.r12;
+	tdx->vp_enter_args.r13 = vcpu->run->tdx.get_tdvmcall_info.r13;
+	tdx->vp_enter_args.r14 = vcpu->run->tdx.get_tdvmcall_info.r14;
+
+	return 1;
+}
+
 static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-	if (tdx->vp_enter_args.r12)
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
-	else {
+	switch (tdx->vp_enter_args.r12) {
+	case 1:
+		vcpu->run->tdx.get_tdvmcall_info.leaf = tdx->vp_enter_args.r12;
+		vcpu->run->exit_reason = KVM_EXIT_TDX;
+		vcpu->run->tdx.flags = 0;
+		vcpu->run->tdx.nr = TDVMCALL_GET_TD_VM_CALL_INFO;
+		vcpu->run->tdx.get_tdvmcall_info.ret = TDVMCALL_STATUS_SUCCESS;
+		vcpu->run->tdx.get_tdvmcall_info.r11 = 0;
+		vcpu->run->tdx.get_tdvmcall_info.r12 = 0;
+		vcpu->run->tdx.get_tdvmcall_info.r13 = 0;
+		vcpu->run->tdx.get_tdvmcall_info.r14 = 0;
+		vcpu->arch.complete_userspace_io = tdx_complete_get_td_vm_call_info;
+		return 0;
+	default:
 		tdx->vp_enter_args.r11 = 0;
+		tdx->vp_enter_args.r12 = 0;
 		tdx->vp_enter_args.r13 = 0;
 		tdx->vp_enter_args.r14 = 0;
+		return 1;
 	}
-	return 1;
 }
 
 static int tdx_complete_simple(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6708bc88ae69..fb3b4cd8d662 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -461,6 +461,11 @@ struct kvm_run {
 					__u64 gpa;
 					__u64 size;
 				} get_quote;
+				struct {
+					__u64 ret;
+					__u64 leaf;
+					__u64 r11, r12, r13, r14;
+				} get_tdvmcall_info;
 			};
 		} tdx;
 		/* Fix the size of the union. */
-- 
2.43.5


