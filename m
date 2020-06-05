Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4621F01E7
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgFEVjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:39:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:49312 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728430AbgFEVjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:10 -0400
IronPort-SDR: FgRI+HSH1GkyhhIzWvk460hY2SYP/uvQn4p2OqVE5DPPT0+LJH55GeX+1Ji3hPrI2EPs+eJCJ6
 9JaxJKmr1i9A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: /DIB9oiqYI2Fg3zD1AVI7xOqUEPZThNOBLFZjDo1clHWgdOMBdzQcqRgIJ9S8j4GwRp7A7TrVS
 UbqM0qM5y0jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860880"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU memory cache is empty
Date:   Fri,  5 Jun 2020 14:38:37 -0700
Message-Id: <20200605213853.14959-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attempt to allocate a new object instead of crashing KVM (and likely the
kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
allocation as the caches are used while holding mmu_lock.  The immediate
BUG_ON() makes the code unnecessarily explosive and led to confusing
minimums being used in the past, e.g. allocating 4 objects where 1 would
suffice.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba70de24a5b0..5e773564ab20 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1060,6 +1060,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
+static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
+					       gfp_t gfp_flags)
+{
+	if (mc->kmem_cache)
+		return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
+	else
+		return (void *)__get_free_page(gfp_flags);
+}
+
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	void *obj;
@@ -1067,10 +1076,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	if (mc->nobjs >= min)
 		return 0;
 	while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
-		if (mc->kmem_cache)
-			obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
-		else
-			obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
 		if (!obj)
 			return mc->nobjs >= min ? 0 : -ENOMEM;
 		mc->objects[mc->nobjs++] = obj;
@@ -1118,8 +1124,11 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
 	void *p;
 
-	BUG_ON(!mc->nobjs);
-	p = mc->objects[--mc->nobjs];
+	if (WARN_ON(!mc->nobjs))
+		p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
+	else
+		p = mc->objects[--mc->nobjs];
+	BUG_ON(!p);
 	return p;
 }
 
-- 
2.26.0

