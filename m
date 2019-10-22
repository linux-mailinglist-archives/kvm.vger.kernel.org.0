Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413A6DFA85
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387671AbfJVB75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:61609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387650AbfJVB74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293875"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/45] KVM: Unexport kvm_vcpu_cache and kvm_{un}init_vcpu()
Date:   Mon, 21 Oct 2019 18:59:11 -0700
Message-Id: <20191022015925.31916-32-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unexport kvm_vcpu_cache and kvm_{un}init_vcpu() and make them static
now that they are referenced only in kvm_main.c.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/linux/kvm_host.h | 4 ----
 virt/kvm/kvm_main.c      | 9 +++------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8559d0448d0b..c36379824408 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -157,8 +157,6 @@ static inline bool is_error_page(struct page *page)
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
 
-extern struct kmem_cache *kvm_vcpu_cache;
-
 extern struct mutex kvm_lock;
 extern struct list_head vm_list;
 
@@ -585,8 +583,6 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
 		memslot++)
 
-int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
-void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb526bd55664..1d84ae0e3893 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,8 +103,7 @@ static cpumask_var_t cpus_hardware_enabled;
 static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
 
-struct kmem_cache *kvm_vcpu_cache;
-EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
+static struct kmem_cache *kvm_vcpu_cache;
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 
@@ -288,7 +287,7 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
-int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
 	int r;
@@ -326,9 +325,8 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 fail:
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 
-void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * no need for rcu_read_lock as VCPU_RUN is the only place that
@@ -339,7 +337,6 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-- 
2.22.0

