Return-Path: <kvm+bounces-37786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6325AA301C4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0234E1691AC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DCE1E5B8D;
	Tue, 11 Feb 2025 02:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R9ufVTh7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88C1E5B79;
	Tue, 11 Feb 2025 02:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242416; cv=none; b=uj4d0IRtUhm7JUVHe++xJDEytx3a3OX8aueTYq+WPBYxFsC5aJ8MRi2P0PEgA68a8tg4BmfvEsmFAAYQ5h3V+tQI9ML6mmdazbC/gJ7s9dj9G7uEXvu+U6UxzvT98o1aFmn0nBy38QStF75fzGlsrlvtHsAeplW4pGmNlwQTK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242416; c=relaxed/simple;
	bh=PBkOidVvwMnLVO//k87I99vI11Ujgs8DjnLQYbKjFDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfRv1isux9d0HAfGuXGEM6bjvL7azaQLbTze9O9Qi1gSGkd6cI1ABxQOHhALLNVvVJHBufxwBUeZdPjoxuFeAnYw7Pcsc4ITfn/3CTNcCzQrZYec77vSxZ4A3yQmDocedk4meguLqa2bPnGl9GKjXKrPELU9oN4M84NwK6FVj74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R9ufVTh7; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242415; x=1770778415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PBkOidVvwMnLVO//k87I99vI11Ujgs8DjnLQYbKjFDQ=;
  b=R9ufVTh7S5wFuHk2RvVq+qNkON4plC5laWfGZQFN9Kwe9q4vQsdUpo1w
   eOK0GmHsA7ZW/lyZ0WJzsPSn4x+78nzT12VqjpH4jCoo+oX+T2iXOZQCu
   Sv5qPBokufqScA8Nt8X3ubVfAxEFyk+FEInrk3QgtAlZmKtpRhqkqtd0Y
   rQXifLrphH4Oq++biJysPqUl+Y5prsN8OXm/ByjP4khDZav27k8lr5L/P
   se5Je2VXOUcHDNEm5TCUNxwcYY+WkEGw7TReD/j5JZwGOlXYfNakCqeNK
   TthAAMuDNo+to6qlj4ffumVaacpknFJW8Xrf9I3HtHrW5b2U5AMroxnDg
   g==;
X-CSE-ConnectionGUID: n5qQ0PZITxqj9qkD6/wJaA==
X-CSE-MsgGUID: uLWSxCyyTCG5ZGvFXD5nqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506635"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506635"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:35 -0800
X-CSE-ConnectionGUID: BZF9QDQsRsmuCQBy1vST/A==
X-CSE-MsgGUID: iW+nfzdCQo+53y494+avMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236484"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:31 -0800
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
Subject: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
Date: Tue, 11 Feb 2025 10:54:42 +0800
Message-ID: <20250211025442.3071607-9-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
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
 arch/x86/kvm/vmx/tdx.c | 109 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c     |   1 +
 virt/kvm/kvm_main.c    |   1 +
 3 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f13da28dd4a2..8f3147c6e602 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -849,8 +849,12 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 		if (tdvmcall_exit_type(vcpu))
 			return EXIT_REASON_VMCALL;
 
-		if (tdvmcall_leaf(vcpu) < 0x10000)
+		if (tdvmcall_leaf(vcpu) < 0x10000) {
+			if (tdvmcall_leaf(vcpu) == EXIT_REASON_EPT_VIOLATION)
+				return EXIT_REASON_EPT_MISCONFIG;
+
 			return tdvmcall_leaf(vcpu);
+		}
 		break;
 	default:
 		break;
@@ -1193,6 +1197,107 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
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
@@ -1546,6 +1651,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_emulate_vmcall(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		return tdx_emulate_mmio(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29f33f7c9da9..a41d57ba4a86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14010,6 +14010,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 836e0c69f53b..783683d04939 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5835,6 +5835,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
+EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
-- 
2.46.0


