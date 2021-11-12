Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8006644EA94
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhKLPmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:42:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:34487 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhKLPmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:42:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093246"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093246"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:38:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182164"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:38:13 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 10/11] KVM: Disallow read-only memory for x86 TDX
Date:   Fri, 12 Nov 2021 23:37:32 +0800
Message-Id: <20211112153733.2767561-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't expose permission bits to the VMM in the SEPT tables, i.e.,
doesn't support read-only private memory.

Introduce kvm_arch_support_readonly_mem(), which returns true except for
x86. x86 has its own implementation based on vm_type that returns faluse
for TDX VM.

Propagate it to KVM_CAP_READONLY_MEM to allow reporting on a per-VM
basis.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c       |  9 ++++++++-
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 19 ++++++++++++++-----
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d06ee07bd486..f091a4d3c8f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4079,7 +4079,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
@@ -4202,6 +4201,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
 			r |= BIT(KVM_X86_TDX_VM);
 		break;
+	case KVM_CAP_READONLY_MEM:
+		r = kvm && !kvm_arch_support_readonly_mem(kvm) ? 0 : 1;
+		break;
 	default:
 		break;
 	}
@@ -12609,6 +12611,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_arch_support_readonly_mem(struct kvm *kvm)
+{
+	return kvm->arch.vm_type != KVM_X86_TDX_VM;
+}
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..1dbabf199c13 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1071,6 +1071,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_support_readonly_mem(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..c288c92a9c82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1421,13 +1421,22 @@ static void update_memslots(struct kvm_memslots *slots,
 	}
 }
 
-static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
+bool __weak kvm_arch_support_readonly_mem(struct kvm *kvm)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
-
 #ifdef __KVM_HAVE_READONLY_MEM
-	valid_flags |= KVM_MEM_READONLY;
+	return true;
+#else
+	return false;
 #endif
+}
+
+static int check_memory_region_flags(struct kvm *kvm,
+				     const struct kvm_userspace_memory_region *mem)
+{
+	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+
+	if (kvm_arch_support_readonly_mem(kvm))
+		valid_flags |= KVM_MEM_READONLY;
 
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
@@ -1664,7 +1673,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
-	r = check_memory_region_flags(mem);
+	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
 
-- 
2.27.0

