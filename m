Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93C33BA5B7
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhGBWJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:51168 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233074AbhGBWH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951899"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951899"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:22 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814728"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:22 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 18/69] KVM: Export kvm_make_all_cpus_request() for use in marking VMs as bugged
Date:   Fri,  2 Jul 2021 15:04:24 -0700
Message-Id: <1d8cbbc8065d831343e70b5dcaea92268145eef1.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Export kvm_make_all_cpus_request() and hoist the request helper
declarations of request up to the KVM_REQ_* definitions in preparation
for adding a "VM bugged" framework.  The framework will add KVM_BUG()
and KVM_BUG_ON() as alternatives to full BUG()/BUG_ON() for cases where
KVM has definitely hit a bug (in itself or in silicon) and the VM is all
but guaranteed to be hosed.  Marking a VM bugged will trigger a request
to all vCPUs to allow arch code to forcefully evict each vCPU from its
run loop.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 09618f8a1338..e87f07c5c601 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -158,6 +158,15 @@ static inline bool is_error_page(struct page *page)
 })
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
 
+bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
+				 struct kvm_vcpu *except,
+				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
+bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
+				      struct kvm_vcpu *except);
+bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
+				unsigned long *vcpu_bitmap);
+
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
 
@@ -616,7 +625,6 @@ struct kvm {
 #define vcpu_err(vcpu, fmt, ...)					\
 	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
 
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 static inline void kvm_vm_bugged(struct kvm *kvm)
 {
 	kvm->vm_bugged = true;
@@ -955,14 +963,6 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
 
-bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 struct kvm_vcpu *except,
-				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
-bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
-				      struct kvm_vcpu *except);
-bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
-				unsigned long *vcpu_bitmap);
-
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
-- 
2.25.1

