Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40C06B69B6
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjCLSGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjCLSFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE2750FA4;
        Sun, 12 Mar 2023 11:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644056; x=1710180056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=npBo1zGxoXjGG9lsG1lBGkqt9AVcqhT2g6XsYO2ooHg=;
  b=VfVDfhAWrwgOPr73DWCwevm9BPTe5HUfIiLMQvfOGtx/WGO14UNvWcMI
   wJv6O979DM+lDEQXph1WE6UO8IfjqeGJDUm42+Pv2okweAl0RdIgKruNB
   G60BoC0MGlqj4IrAxSogX9wfgQiWkU5xckAL1bu3rlq1fievWQMiWFTEI
   vIhCfcU5yIBBNYBq0CGezzafqjIuY6s6TuOtqx6ebeaMVQabNlpP4nFm1
   2Nzu18Bgt78Ocle5/CznW91YrVsxAXPIIF+a4duWv+Yg0ttZPGXwN4Y8D
   0Oo5vgwYC0PINS9qwYBuGrYEIPq8NhuTvlMORBUp5uQav4+x2KGYYimpW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660078"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660078"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596811"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596811"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v13 094/113] KVM: TDX: Handle TDX PV MMIO hypercall
Date:   Sun, 12 Mar 2023 10:56:58 -0700
Message-Id: <a45e09c51d1edafb88a3ea7098580cac1d114d9d.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 12cc670eddf7..5f873fef9cb5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1069,6 +1069,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
+{
+	unsigned long val = 0;
+	gpa_t gpa;
+	int size;
+
+	KVM_BUG_ON(vcpu->mmio_needed != 1, vcpu->kvm);
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
+	KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
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
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1081,6 +1193,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_hlt(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_emulate_mmio(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f8eee8c0f2b..d18b6300b8d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13604,6 +13604,7 @@ bool kvm_arch_dirty_log_supported(struct kvm *kvm)
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e9f8225f3406..79e3c228bedf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2683,6 +2683,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
@@ -5839,6 +5840,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
+EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
 /* Caller must hold slots_lock. */
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
-- 
2.25.1

