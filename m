Return-Path: <kvm+bounces-38935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69398A404DA
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15CF03B45AA
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554FF2054FE;
	Sat, 22 Feb 2025 01:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrbjoOdZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878DC204F7E;
	Sat, 22 Feb 2025 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188487; cv=none; b=FVs/9tA+5FU2rifp4HsFD53C77DabrzlHo8lt6gZFTfiiTa6Vvg5nPl/r3Ad/Bj4wnXWEHV3Fj8JyVlncJ8WRaKQvC70QSMNL/Y/ITFXVqtU51qwnT+DFWlvYuBy2nVIUl7WaFfZu5aOhSxnBnJ/vkiVGFVvK3WKIbvZahFKOvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188487; c=relaxed/simple;
	bh=2DEd476Bpk+oX75xhAgahoRfnU3DcwQcOYOgDaGwJS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI3TtJoYjrHCOQhJ6JqJZlRdTSb7VS/FWnd5cBZhMeU4AdWoZnZO9ubjNcDfauR3x8npo1VIy6Fk/CWpG0ZmpCKydvZ+r/8DPeaPoCbe2/tWWYhnWy3IYqWe3V2a5ciyQ93lgBB50pqa+N6cGsu8IHa3BNkO1qd/APpg5QHEyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrbjoOdZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188485; x=1771724485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2DEd476Bpk+oX75xhAgahoRfnU3DcwQcOYOgDaGwJS8=;
  b=PrbjoOdZSGUfhT7gNt07pGGZdPVnMV5AD392M9GcgG4HNCvf8O+aEqXI
   jhtKdAezdX6CZ28IRD1j3SHzvk+ET4saZ01KFXTi8wuFwYdrKY71sD8/+
   xDzu5qLfNwhT0RzY+sI+lrJOvjDb/LNJNTQ3Gh2ayLQgtXFMUajrWon9y
   t0pg6fO32JeQ8X+LRLzlm0Ue/8Fja1BEI6Rq4oBI0qolMZvuxQMKLmjL5
   mDf8WxaZHb/C5+vk3t+qaO8djpT+UrUI77m4zWeGkooCgqmgqcQ6IAQJN
   MIU4PfVmLk7lxrNf2LKJ+0B9xAAxL9Fi/2fTh8e+f8RGZ+ukHruDTKrkK
   Q==;
X-CSE-ConnectionGUID: bjx9645oSSSjNZkHaytM7w==
X-CSE-MsgGUID: tttUJF1gSzKZvWh9TKqZsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893312"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893312"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:25 -0800
X-CSE-ConnectionGUID: XhRuXY38Q2W432JcNuKAQA==
X-CSE-MsgGUID: 4L9cjS1yRaeZOcagpXJmLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370281"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:22 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 9/9] KVM: TDX: Handle TDX PV MMIO hypercall
Date: Sat, 22 Feb 2025 09:42:25 +0800
Message-ID: <20250222014225.897298-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Handle TDX PV MMIO hypercall when TDX guest calls TDVMCALL with the
leaf #VE.RequestMMIO (same value as EXIT_REASON_EPT_VIOLATION) according
to TDX Guest Host Communication Interface (GHCI) spec.

For TDX guests, VMM is not allowed to access vCPU registers and the private
memory, and the code instructions must be fetched from the private memory.
So MMIO emulation implemented for non-TDX VMs is not possible for TDX
guests.

In TDX the MMIO regions are instead configured by VMM to trigger a #VE
exception in the guest.  The #VE handling is supposed to emulate the MMIO
instruction inside the guest and convert it into a TDVMCALL with the
leaf #VE.RequestMMIO, which equals to EXIT_REASON_EPT_VIOLATION.

The requested MMIO address must be in shared GPA space.  The shared bit
is stripped after check because the existing code for MMIO emulation is
not aware of the shared bit.

The MMIO GPA shouldn't have a valid memslot, also the attribute of the GPA
should be shared.  KVM could do the checks before exiting to userspace,
however, even if KVM does the check, there still will be race conditions
between the check in KVM and the emulation of MMIO access in userspace due
to a memslot hotplug, or a memory attribute conversion.  If userspace
doesn't check the attribute of the GPA and the attribute happens to be
private, it will not pose a security risk or cause an MCE, but it can lead
to another issue. E.g., in QEMU, treating a GPA with private attribute as
shared when it falls within RAM's range can result in extra memory
consumption during the emulation to the access to the HVA of the GPA.
There are two options: 1) Do the check both in KVM and userspace.  2) Do
the check only in QEMU.  This patch chooses option 2, i.e. KVM omits the
memslot and attribute checks, and expects userspace to do the checks.

Similar to normal MMIO emulation, try to handle the MMIO in kernel first,
if kernel can't support it, forward the request to userspace.  Export
needed symbols used for MMIO handling.

Fragments handling is not needed for TDX PV MMIO because GPA is provided,
if a MMIO access crosses page boundary, it should be continuous in GPA.
Also, the size is limited to 1, 2, 4, 8 bytes.  No further split needed.
Allow cross page access because no extra handling needed after checking
both start and end GPA are shared GPAs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
Hypercalls exit to userspace v3:
 - Rebased to use tdcall_to_vmx_exit_reason()

Hypercalls exit to userspace v2:
- Morph PV MMIO hypercall to EXIT_REASON_EPT_MISCONFIG. (Sean)
- Skip setting return code as TDVMCALL_STATUS_SUCCESS, as a result, the
  complete_userspace_io() callback for write is not needed. (Sean)
- Remove the code for reading/writing APIC mmio,since TDX guest supports x2APIC only.
- Use vp_enter_args directly instead of helpers.

Hypercalls exit to userspace v1:
- Update the changelog.
- Remove the check of memslot for GPA.
- Allow MMIO access crossing page boundary.
- Move the tracepoint for KVM_TRACE_MMIO_WRITE earlier so the tracepoint handles
  the cases both for kernel and userspace. (Isaku)
- Set TDVMCALL return code when back from userspace, which is missing in v19.
- Move fast MMIO write into tdx_mmio_write()
- Check GPA is shared GPA. (Binbin)
- Remove extra check for size > 8u. (Binbin)
- Removed KVM_BUG_ON() in tdx_complete_mmio() and tdx_emulate_mmio()
- Removed vcpu->mmio_needed code since it's not used after removing
  KVM_BUG_ON().
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
- Use vt_is_tdx_private_gpa()
---
 arch/x86/kvm/vmx/tdx.c | 105 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |   1 +
 virt/kvm/kvm_main.c    |   1 +
 3 files changed, 107 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3a4437520868..c023e99de294 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -826,6 +826,8 @@ static __always_inline u32 tdcall_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdvmcall_leaf(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return EXIT_REASON_EPT_MISCONFIG;
 	default:
 		break;
 	}
@@ -1179,6 +1181,107 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int tdx_complete_mmio_read(struct kvm_vcpu *vcpu)
+{
+	unsigned long val = 0;
+	gpa_t gpa;
+	int size;
+
+	gpa = vcpu->mmio_fragments[0].gpa;
+	size = vcpu->mmio_fragments[0].len;
+
+	memcpy(&val, vcpu->run->mmio.data, size);
+	tdvmcall_set_return_val(vcpu, val);
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	return 1;
+}
+
+static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
+				 unsigned long val)
+{
+	if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
+		trace_kvm_fast_mmio(gpa);
+		return 0;
+	}
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
+	if (kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
+{
+	unsigned long val;
+
+	if (kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	tdvmcall_set_return_val(vcpu, val);
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	return 0;
+}
+
+static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int size, write, r;
+	unsigned long val;
+	gpa_t gpa;
+
+	size = tdx->vp_enter_args.r12;
+	write = tdx->vp_enter_args.r13;
+	gpa = tdx->vp_enter_args.r14;
+	val = write ? tdx->vp_enter_args.r15 : 0;
+
+	if (size != 1 && size != 2 && size != 4 && size != 8)
+		goto error;
+	if (write != 0 && write != 1)
+		goto error;
+
+	/*
+	 * TDG.VP.VMCALL<MMIO> allows only shared GPA, it makes no sense to
+	 * do MMIO emulation for private GPA.
+	 */
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) ||
+	    vt_is_tdx_private_gpa(vcpu->kvm, gpa + size - 1))
+		goto error;
+
+	gpa = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
+
+	if (write)
+		r = tdx_mmio_write(vcpu, gpa, size, val);
+	else
+		r = tdx_mmio_read(vcpu, gpa, size);
+	if (!r)
+		/* Kernel completed device emulation. */
+		return 1;
+
+	/* Request the device emulation to userspace device model. */
+	vcpu->mmio_is_write = write;
+	if (!write)
+		vcpu->arch.complete_userspace_io = tdx_complete_mmio_read;
+
+	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.len = size;
+	vcpu->run->mmio.is_write = write;
+	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+
+	if (write) {
+		memcpy(vcpu->run->mmio.data, &val, size);
+	} else {
+		vcpu->mmio_fragments[0].gpa = gpa;
+		vcpu->mmio_fragments[0].len = size;
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
+	}
+	return 0;
+
+error:
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1558,6 +1661,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_emulate_vmcall(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		return tdx_emulate_mmio(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8877d6db9b84..7b5f5f603ceb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14012,6 +14012,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3187b2ae0e5b..da5ef7773b05 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5843,6 +5843,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
+EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
-- 
2.46.0


