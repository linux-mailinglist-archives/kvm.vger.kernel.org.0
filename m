Return-Path: <kvm+bounces-49991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E9AAE0CB3
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 20:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53C69189F7AB
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 18:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECC029DB6C;
	Thu, 19 Jun 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNQJ1qOn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C8129A301
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750356136; cv=none; b=q00nqRUVnVyYj7tw86WdAqH+nHjcgWLfgnSakk6fRB16wLHUJuve2E4k/utZGEHXyfPa8bEQjH7LqLoflsTwhbp3GdFfTCFgGFgBEtrk8r7Oh99yoQwphfclDDmUCVXUdCNjDEvprOS5VZD8PSA3WbrrySq5V9+s8cG6GDanGQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750356136; c=relaxed/simple;
	bh=2WJJgFVI2Asm1hwJexARSJkhBcYXiMkH46qjCg0b/AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b66uNwLg3nYpdkrPoQBvQpHRHjc+I5rsEBS8c7Oy6uO/QVVSETtZwtL1jUeDKnL+ResI00tFBEOjvU/CGQUsttXi7RSi50FxpiUPCwGl8yXn3aMqvjZ1I1MfAWuEN/sdbbEtsbfsvZ/qNVoTsZFXGNvCmiNM469CEBSjxZdJdwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNQJ1qOn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750356134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y3yGI/REawfvozidhqQ719FMejsDZOoInzLw3LgOJD0=;
	b=jNQJ1qOnS6jeuAch02XwRBpQgGYzOF5j/xwxGsJBmVlOCbntWn4GDtmXnw+SooGGrxHo7q
	xHM+Zk1RgA1ggu3ZLEG88ex93waxJcN1OIgHT10sN51LBESuG7T8eGvx5vi6RdYHOKi/df
	pZ2OQG2tJe7ksvw+ODtiyTkfaqIyjlw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-158-SyP_E2_ZOvuvzgxiXv1_fA-1; Thu,
 19 Jun 2025 14:02:11 -0400
X-MC-Unique: SyP_E2_ZOvuvzgxiXv1_fA-1
X-Mimecast-MFC-AGG-ID: SyP_E2_ZOvuvzgxiXv1_fA_1750356129
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE32319560AA;
	Thu, 19 Jun 2025 18:02:08 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7B70180035C;
	Thu, 19 Jun 2025 18:02:06 +0000 (UTC)
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
Subject: [PATCH 2/3] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Date: Thu, 19 Jun 2025 14:01:58 -0400
Message-ID: <20250619180159.187358-3-pbonzini@redhat.com>
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

Handle TDVMCALL for GetQuote to generate a TD-Quote.

GetQuote is a doorbell-like interface used by TDX guests to request VMM
to generate a TD-Quote signed by a service hosting TD-Quoting Enclave
operating on the host.  A TDX guest passes a TD Report (TDREPORT_STRUCT) in
a shared-memory area as parameter.  Host VMM can access it and queue the
operation for a service hosting TD-Quoting enclave.  When completed, the
Quote is returned via the same shared-memory area.

KVM only checks the GPA from the TDX guest has the shared-bit set and drops
the shared-bit before exiting to userspace to avoid bleeding the shared-bit
into KVM's exit ABI.  KVM forwards the request to userspace VMM (e.g. QEMU)
and userspace VMM queues the operation asynchronously.  KVM sets the return
code according to the 'ret' field set by userspace to notify the TDX guest
whether the request has been queued successfully or not.  When the request
has been queued successfully, the TDX guest can poll the status field in
the shared-memory area to check whether the Quote generation is completed
or not.  When completed, the generated Quote is returned via the same
buffer.

Add KVM_EXIT_TDX as a new exit reason to userspace. Userspace is
required to handle the KVM exit reason as the initial support for TDX,
by reentering KVM to ensure that the TDVMCALL is complete.  While at it,
add a note that KVM_EXIT_HYPERCALL also requires reentry with KVM_RUN.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Mikko Ylinen <mikko.ylinen@linux.intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
[Adjust userspace API. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 49 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c         | 31 +++++++++++++++++++++
 include/uapi/linux/kvm.h       | 17 ++++++++++++
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424..3643d853a634 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6645,7 +6645,8 @@ to the byte array.
 .. note::
 
       For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN,
-      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
+      KVM_EXIT_EPR, KVM_EXIT_HYPERCALL, KVM_EXIT_TDX,
+      KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
       operations are complete (and guest state is consistent) only after userspace
       has re-entered the kernel with KVM_RUN.  The kernel side will first finish
       incomplete operations and then check for pending signals.
@@ -7174,6 +7175,52 @@ The valid value for 'flags' is:
   - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
     in VMCS. It would run into unknown result if resume the target VM.
 
+::
+
+		/* KVM_EXIT_TDX */
+		struct {
+			__u64 flags;
+			__u64 nr;
+			union {
+				struct {
+					u64 ret;
+					u64 data[5];
+				} unknown;
+				struct {
+					u64 ret;
+					u64 gpa;
+					u64 size;
+				} get_quote;
+			};
+		} tdx;
+
+Process a TDVMCALL from the guest.  KVM forwards select TDVMCALL based
+on the Guest-Hypervisor Communication Interface (GHCI) specification;
+KVM bridges these requests to the userspace VMM with minimal changes,
+placing the inputs in the union and copying them back to the guest
+on re-entry.
+
+Flags are currently always zero, whereas ``nr`` contains the TDVMCALL
+number from register R11.  The remaining field of the union provide the
+inputs and outputs of the TDVMCALL.  Currently the following values of
+``nr`` are defined:
+
+* ``TDVMCALL_GET_QUOTE``: the guest has requested to generate a TD-Quote
+signed by a service hosting TD-Quoting Enclave operating on the host.
+Parameters and return value are in the ``get_quote`` field of the union.
+The ``gpa`` field and ``size`` specify the guest physical address
+(without the shared bit set) and the size of a shared-memory buffer, in
+which the TDX guest passes a TD Report.  The ``ret`` field represents
+the return value of the GetQuote request.  When the request has been
+queued successfully, the TDX guest can poll the status field in the
+shared-memory area to check whether the Quote generation is completed or
+not. When completed, the generated Quote is returned via the same buffer.
+
+KVM may add support for more values in the future that may cause a userspace
+exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
+it will enter with output fields already valid; in the common case, the
+``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED``.
+Userspace need not do anything if it does not wish to support a TDVMCALL.
 ::
 
 		/* Fix the size of the union. */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5d100c240ab3..6878a76069f8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1465,6 +1465,36 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_simple(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, vcpu->run->tdx.unknown.ret);
+	return 1;
+}
+
+static int tdx_get_quote(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 gpa = tdx->vp_enter_args.r12;
+	u64 size = tdx->vp_enter_args.r13;
+
+	/* The gpa of buffer must have shared bit set. */
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX;
+	vcpu->run->tdx.flags = 0;
+	vcpu->run->tdx.nr = TDVMCALL_GET_QUOTE;
+	vcpu->run->tdx.get_quote.ret = TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED;
+	vcpu->run->tdx.get_quote.gpa = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
+	vcpu->run->tdx.get_quote.size = size;
+
+	vcpu->arch.complete_userspace_io = tdx_complete_simple;
+
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1474,6 +1503,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_report_fatal_error(vcpu);
 	case TDVMCALL_GET_TD_VM_CALL_INFO:
 		return tdx_get_td_vm_call_info(vcpu);
+	case TDVMCALL_GET_QUOTE:
+		return tdx_get_quote(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d00b85cb168c..6708bc88ae69 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX              40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -447,6 +448,22 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX */
+		struct {
+			__u64 flags;
+			__u64 nr;
+			union {
+				struct {
+					__u64 ret;
+					__u64 data[5];
+				} unknown;
+				struct {
+					__u64 ret;
+					__u64 gpa;
+					__u64 size;
+				} get_quote;
+			};
+		} tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.43.5



