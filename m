Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329F055C924
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbiF0V61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241279AbiF0Vzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:51 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB915FCB;
        Mon, 27 Jun 2022 14:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366908; x=1687902908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kre3hou4c8iwWYuA9xha+AMgq+XxEWwaU/LMEQly1uw=;
  b=b50ZJsr8pggBNivYrceUZTNi8MxqciVcKpfq10RiceWCslL+nMEnskck
   G74ZZCEKAiRwz0e9O4MFSX2Cq8UnnlVzytoFB6M5Lj59HH9XpvVaC5gAL
   HmV0bGdh+G/IgmpM471XPAw8xNQ3bo8OE93PlZEB59FrVBJzF4qxlhKIZ
   c+amQBHORaykXXymqtUfgjYqX5ycBIhug/a7PT7KPW5KIrKHYskE7Iqt5
   Z09PSGxVYmQ97OmIGVTAf2tsHugc0bNp8ovTd+dV/knlALnba+cqYdx3P
   GPcRcG4qOf9hYKaRidhTeNB6erD3w7o1VGWcPlxAztDQcU7ODRx5MUHam
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116143"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116143"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863742"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 092/102] KVM: TDX: Handle TDX PV MMIO hypercall
Date:   Mon, 27 Jun 2022 14:54:24 -0700
Message-Id: <daa13609758e7c300a992272075f32e89a3c8806.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
hypercall to the KVM backend functions.

kvm_io_bus_read/write() searches KVM device emulated in kernel of the given
MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, export
kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
emulates some of MMIO itself.  To add trace point consistently with x86
kvm, export kvm_mmio tracepoint.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |   1 +
 virt/kvm/kvm_main.c    |   2 +
 3 files changed, 117 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a62586a83b80..3a955a2a4f0b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1058,6 +1058,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
+{
+	unsigned long val = 0;
+	gpa_t gpa;
+	int size;
+
+	WARN_ON(vcpu->mmio_needed != 1);
+	vcpu->mmio_needed = 0;
+
+	if (!vcpu->mmio_is_write) {
+		gpa = vcpu->mmio_fragments[0].gpa;
+		size = vcpu->mmio_fragments[0].len;
+
+		memcpy(&val, vcpu->run->mmio.data, size);
+		tdvmcall_set_return_val(vcpu, val);
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	}
+	return 1;
+}
+
+static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
+				 unsigned long val)
+{
+	if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
+	    kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
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
+	struct kvm_memory_slot *slot;
+	int size, write, r;
+	unsigned long val;
+	gpa_t gpa;
+
+	WARN_ON(vcpu->mmio_needed);
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
+	/* Strip the shared bit, allow MMIO with and without it set. */
+	gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
+
+	if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
+		goto error;
+
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
+	if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
+		goto error;
+
+	if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
+		trace_kvm_fast_mmio(gpa);
+		return 1;
+	}
+
+	if (write)
+		r = tdx_mmio_write(vcpu, gpa, size, val);
+	else
+		r = tdx_mmio_read(vcpu, gpa, size);
+	if (!r) {
+		/* Kernel completed device emulation. */
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+		return 1;
+	}
+
+	/* Request the device emulation to userspace device model. */
+	vcpu->mmio_needed = 1;
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
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1070,6 +1182,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_hlt(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_emulate_mmio(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a68a917ebdff..ccb1670adfbc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13208,6 +13208,7 @@ bool kvm_arch_dirty_log_supported(struct kvm *kvm)
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 703c1d0c98da..753442bddd96 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2303,6 +2303,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
@@ -5185,6 +5186,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
+EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
 /* Caller must hold slots_lock. */
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
-- 
2.25.1

