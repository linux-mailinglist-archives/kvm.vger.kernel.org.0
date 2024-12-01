Return-Path: <kvm+bounces-32797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8789DF49C
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:54:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87C48B227D9
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A455C15531B;
	Sun,  1 Dec 2024 03:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UMceMb5w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E4714A4F7;
	Sun,  1 Dec 2024 03:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025144; cv=none; b=j911RVWQUKgmDT5Bph3GVRf0hN3J6zrl9ugDq+iOvsnER4/Sikurq73fsj3KoxlJKfv9wTfvfscmflRVEaPJaEOJ9MYvy3S0yFOWzvRFvFPQFkwgLDi8ZhA+V8FiR7N4qhk2XQi3EBEj6d9dlGP4YGjeGZpkvvVGYXIjMetDCoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025144; c=relaxed/simple;
	bh=yf44A6rzGuTuDWAveUzXPHC/R2LKy+bxmXhtN5uqMNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS6N7KN9durPXgVdBJm9esnhbfN/XKzlfqjXeuhBAC5a2TDRimpkCjTuhUJ8JE+KU3QVvjqB0DauG92wVlzOZLi2T/MYwhfZbl+rryO9Gsd+taRxKpqEnmEMgyPv4ck6uRp54p0wCXhTiTRbSvmlAS5YxrB9y+PtIV70jWBquYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UMceMb5w; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025143; x=1764561143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yf44A6rzGuTuDWAveUzXPHC/R2LKy+bxmXhtN5uqMNo=;
  b=UMceMb5wwn84BGoIWWxQhv5KOir0lJ3DDY9YNnWPt9tORAC2Qzuc1ImB
   CulWxDKXMCT3v/JjsCIAxk9b0SiiKx0MZihljf/j0nqqo4d+DCMUbKdD7
   /rbbs5LVNzVp3i1UEZSXuHvoeG2FDwo3FnrUDrQ7VStyb0CyoSb1HsXHc
   2oxmlcQu0ChOvkaf3OA2zplW/iec2ZjuyieaD8sMbhx9PFN8pDutQeVV5
   YKmjWUh5unEsx+EhCagWx13rA8VXOF3JP4nVWIaGXtwDY9Fb+9P2VHE1Q
   FLOGncTTCVNphtJnNSR20g+CD9+GemK///AfrlOBek+FgxrOe0R5Nr38Y
   w==;
X-CSE-ConnectionGUID: g0URkc8SRCeIgQbwYmjKqw==
X-CSE-MsgGUID: lsKbN4KgRsySC9z7MJ3pXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725125"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725125"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:22 -0800
X-CSE-ConnectionGUID: YNRCVP2bSNSSLuSGTyocDg==
X-CSE-MsgGUID: Sj3gc2scQwWhpPyfCJyN2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257538"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:19 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 7/7] KVM: TDX: Handle TDX PV MMIO hypercall
Date: Sun,  1 Dec 2024 11:53:56 +0800
Message-ID: <20241201035358.2193078-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
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

For TDX, VMM is not allowed to access vCPU registers or TD's private
memory, where all executed instruction are.  So MMIO emulation implemented
for non-TDX VMs is not possible for TDX guest.

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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
Hypercalls exit to userspace breakout:
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
 arch/x86/kvm/vmx/tdx.c | 109 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |   1 +
 virt/kvm/kvm_main.c    |   1 +
 3 files changed, 111 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 495991407a95..50cfc795f01f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1205,6 +1205,113 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
+{
+	unsigned long val = 0;
+	gpa_t gpa;
+	int size;
+
+	if (!vcpu->mmio_is_write) {
+		gpa = vcpu->mmio_fragments[0].gpa;
+		size = vcpu->mmio_fragments[0].len;
+
+		memcpy(&val, vcpu->run->mmio.data, size);
+		tdvmcall_set_return_val(vcpu, val);
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	}
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
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
+	if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
+	    kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
+{
+	unsigned long val;
+
+	if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
+	    kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	tdvmcall_set_return_val(vcpu, val);
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	return 0;
+}
+
+static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
+{
+	int size, write, r;
+	unsigned long val;
+	gpa_t gpa;
+
+	size = tdvmcall_a0_read(vcpu);
+	write = tdvmcall_a1_read(vcpu);
+	gpa = tdvmcall_a2_read(vcpu);
+	val = write ? tdvmcall_a3_read(vcpu) : 0;
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
+	if (!r) {
+		/* Kernel completed device emulation. */
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+		return 1;
+	}
+
+	/* Request the device emulation to userspace device model. */
+	vcpu->mmio_is_write = write;
+	vcpu->arch.complete_userspace_io = tdx_complete_mmio;
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
 	if (tdvmcall_exit_type(vcpu))
@@ -1217,6 +1324,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_report_fatal_error(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_emulate_mmio(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2eb660fed754..e155ae90e9fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13987,6 +13987,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5901d03e372c..dc735d7b511b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5803,6 +5803,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
+EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
-- 
2.46.0


