Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F32B4FD3
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732864AbgKPSd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:33:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:20622 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732785AbgKPS16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:58 -0500
IronPort-SDR: yhg1fiw3CbmMNVHaBEu2VK2zkh3FB7sjxF2YOUXqi/gSB4x9WMbyeijou1D/F8tDHHlclbDibo
 tvBkzWczsxWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410006"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410006"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:57 -0800
IronPort-SDR: FDxCEs86/sddN4PTr74F/9WjZ2LYpH7tc8hfsQk0wh4Eq34vCxhMuTua4zNzMvpsBe80j78bOX
 rFOrWcE62biw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527831"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:56 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 10/67] KVM: Export kvm_make_all_cpus_request() for use in marking VMs as bugged
Date:   Mon, 16 Nov 2020 10:25:55 -0800
Message-Id: <9f779ee86c4c69f806616bc05e8f865628c538eb.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
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
---
 include/linux/kvm_host.h | 18 +++++++++---------
 virt/kvm/kvm_main.c      |  1 +
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03c016ff1715..ad9b6963d19d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -155,6 +155,15 @@ static inline bool is_error_page(struct page *page)
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
 
@@ -874,15 +883,6 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
 
-bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 struct kvm_vcpu *except,
-				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
-bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
-				      struct kvm_vcpu *except);
-bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
-				unsigned long *vcpu_bitmap);
-
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 21af4f083674..b29b6c3484dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -304,6 +304,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	return kvm_make_all_cpus_request_except(kvm, req, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
-- 
2.17.1

