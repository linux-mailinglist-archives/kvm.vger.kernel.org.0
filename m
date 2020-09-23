Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178DD276410
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIWWpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:45:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:41185 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgIWWpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:45:33 -0400
IronPort-SDR: 1CLFeOuXlndzv/a71UJbQaxILER9dtcyZ1+LszpAHnc/NNLi7ehfQSYlMSDf0jlLh5sSENMyQa
 akbgWk+f4GwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148698558"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="148698558"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:45:32 -0700
IronPort-SDR: u+HZL/FRvN5hFKQCaIsv/2670WJRfryOYunFtJVpVNRHMY+2OpH2Z6iXvqLoZlxPrdxJO4Oga5
 RBRJrIvxzjuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335660062"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:45:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [RFC PATCH 1/3] KVM: Export kvm_make_all_cpus_request() for use in marking VMs as bugged
Date:   Wed, 23 Sep 2020 15:45:28 -0700
Message-Id: <20200923224530.17735-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923224530.17735-1-sean.j.christopherson@intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 05e3c2fb3ef7..1d70aeeb7ec3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -154,6 +154,15 @@ static inline bool is_error_page(struct page *page)
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
 
@@ -845,15 +854,6 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
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
index cf88233b819a..bf3f333c7a19 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -306,6 +306,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	return kvm_make_all_cpus_request_except(kvm, req, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
-- 
2.28.0

