Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B6644EA96
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhKLPmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:42:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:34624 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235253AbhKLPmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:42:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093252"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093252"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:38:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182171"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:38:17 -0800
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
Subject: [PATCH 11/11] KVM: Disallow dirty logging for x86 TDX
Date:   Fri, 12 Nov 2021 23:37:33 +0800
Message-Id: <20211112153733.2767561-12-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX doesn't support dirty logging for now.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---

Do we need to introduce a VM-scope CAP to report if dirty log is supported?
since in the future, next generation of TDX will support live migration.
---
 arch/x86/kvm/x86.c       |  5 +++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 +++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f091a4d3c8f2..c30933289b54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12611,6 +12611,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type != KVM_X86_TDX_VM;
+}
+
 bool kvm_arch_support_readonly_mem(struct kvm *kvm)
 {
 	return kvm->arch.vm_type != KVM_X86_TDX_VM;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1dbabf199c13..5f3debcd4295 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1071,6 +1071,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 bool kvm_arch_support_readonly_mem(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c288c92a9c82..4c9d1e7834eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1421,6 +1421,11 @@ static void update_memslots(struct kvm_memslots *slots,
 	}
 }
 
+bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return true;
+}
+
 bool __weak kvm_arch_support_readonly_mem(struct kvm *kvm)
 {
 #ifdef __KVM_HAVE_READONLY_MEM
@@ -1433,7 +1438,10 @@ bool __weak kvm_arch_support_readonly_mem(struct kvm *kvm)
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = 0;
+
+	if (kvm_arch_dirty_log_supported(kvm))
+		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
 
 	if (kvm_arch_support_readonly_mem(kvm))
 		valid_flags |= KVM_MEM_READONLY;
-- 
2.27.0

