Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C8416343F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBRVJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:09:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:6399 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgBRVHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:07:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:07:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="253856426"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:45 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 10/22] KVM: Drop "const" attribute from old memslot in commit_memory_region()
Date:   Tue, 18 Feb 2020 13:07:24 -0800
Message-Id: <20200218210736.16432-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the "const" attribute from @old in kvm_arch_commit_memory_region()
to allow arch specific code to free arch specific resources in the old
memslot without having to cast away the attribute.  Freeing resources in
kvm_arch_commit_memory_region() paves the way for simplifying
kvm_free_memslot() by eliminating the last usage of its @dont param.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       | 2 +-
 arch/powerpc/kvm/powerpc.c | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/x86/kvm/x86.c         | 2 +-
 include/linux/kvm_host.h   | 2 +-
 virt/kvm/arm/mmu.c         | 2 +-
 virt/kvm/kvm_main.c        | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b3243d87097f..c7536aa341d2 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -224,7 +224,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
-				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 48abf1b9ad58..768c4a9269be 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -701,7 +701,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
-				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6638024e440d..78f92c005f93 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4532,7 +4532,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dfca4d9edea7..4f1da1712a61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10003,7 +10003,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2fd0cf4ac03d..1807feef26a3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -678,7 +678,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 bool kvm_largepages_enabled(void);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1d97410b3470..97b87037aff3 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2251,7 +2251,7 @@ int kvm_mmu_init(void)
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
-				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84c03fb60d40..f84bb0442a1b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -985,7 +985,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
-			   const struct kvm_memory_slot *old,
+			   struct kvm_memory_slot *old,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-- 
2.24.1

