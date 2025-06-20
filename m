Return-Path: <kvm+bounces-50152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B846EAE2248
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8E661881B41
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93F62ED148;
	Fri, 20 Jun 2025 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxGIr10v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498DF2ECE90
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750444409; cv=none; b=ZBlhlydjqZaJjWWdMoPgUiXePujqzpO/4qDo3VaPQ9VNIM6ToXDnHtOA5MHwwNdaP/01fam42JsuyVX2Xr1X2FsHXVF5JSVEFc3JJEcy4MU0pcrX4DgZtY3UNNRybnA8/f40vLOMcJoG4SPOQ1pSYxhO4T7tK8Cod2T9ea0j2FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750444409; c=relaxed/simple;
	bh=8cVPpSr+mU5S9qcFTSUXu67cECcT35LV1GY6aRl8nZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eDp8zsl251xyWRKVxQAFzp4HGHuG6aOmRmo52jL+99zXvGr5ik6m7Ax4icK4hn0XkuLJX/wDsl3dpwOXX+DeREcMCccRPmTHwX1tfQovzilnYIf0cAvXOaZHVpethe6FHJEq7mySQ5Ft6KAa8RaY/CIwB3dwiQ4TohZtHUCwLsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxGIr10v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750444406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpXRTC8ElKaQS5y8IzEdVna0lTiUycxLE9BUUGVG3ys=;
	b=TxGIr10vB8XxSf/iC6vnhugfxNdmhmyHIU2eaGpxSJ5HcUk8kCREzUsIcdDB8na0zILAOe
	vR7xDJQIMLnkpoAkWP/6cZ9DT7yRKEXQdzj3DtaiB78PqNVZ9gt66uOrZ7u7iwCScLMk4a
	x98cuUILxobUpSYgE0SVpUlJvKup/l4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-UkjG2CVcNSumYHnuofQ6Bw-1; Fri,
 20 Jun 2025 14:33:22 -0400
X-MC-Unique: UkjG2CVcNSumYHnuofQ6Bw-1
X-Mimecast-MFC-AGG-ID: UkjG2CVcNSumYHnuofQ6Bw_1750444400
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD9CE195608F;
	Fri, 20 Jun 2025 18:33:19 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B18DD180045B;
	Fri, 20 Jun 2025 18:33:17 +0000 (UTC)
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
Date: Fri, 20 Jun 2025 14:33:08 -0400
Message-ID: <20250620183308.197917-4-pbonzini@redhat.com>
In-Reply-To: <20250620183308.197917-1-pbonzini@redhat.com>
References: <20250620183308.197917-1-pbonzini@redhat.com>
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
 Documentation/virt/kvm/api.rst | 10 ++++++++
 arch/x86/kvm/vmx/tdx.c         | 43 ++++++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h       |  5 ++++
 3 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 115ec3c2b641..9abf93ee5f65 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7191,6 +7191,11 @@ The valid value for 'flags' is:
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
 
@@ -7216,6 +7221,11 @@ queued successfully, the TDX guest can poll the status field in the
 shared-memory area to check whether the Quote generation is completed or
 not. When completed, the generated Quote is returned via the same buffer.
 
+* ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
+status of TDVMCALLs.  The output values for the given leaf should be
+placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
+field of the union.
+
 KVM may add support for more values in the future that may cause a userspace
 exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
 it will enter with output fields already valid; in the common case, the
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b619a3478983..1ad20c273f3b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1451,18 +1451,53 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
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
+	case 0:
 		tdx->vp_enter_args.r11 = 0;
+		tdx->vp_enter_args.r12 = 0;
 		tdx->vp_enter_args.r13 = 0;
 		tdx->vp_enter_args.r14 = 0;
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+		return 1;
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
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
 	}
-	return 1;
 }
 
 static int tdx_complete_simple(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e23e7286ad1a..37891580d05d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -462,6 +462,11 @@ struct kvm_run {
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


