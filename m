Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDD02CF865
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 02:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgLEAtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 19:49:03 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:42454 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgLEAtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 19:49:02 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1klLkE-0003Bx-1N; Sat, 05 Dec 2020 01:48:14 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half
Date:   Sat,  5 Dec 2020 01:48:08 +0100
Message-Id: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
cleaned up the computation of MMIO generation SPTE masks, however it
introduced a bug how the upper part was encoded:
SPTE bits 52-61 were supposed to contain bits 10-19 of the current
generation number, however a missing shift encoded bits 1-10 there instead
(mostly duplicating the lower part of the encoded generation number that
then consisted of bits 1-9).

In the meantime, the upper part was shrunk by one bit and moved by
subsequent commits to become an upper half of the encoded generation number
(bits 9-17 of bits 0-17 encoded in a SPTE).

In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
has changed the SPTE bit range assigned to encode the generation number and
the total number of bits encoded but did not update them in the comment
attached to their defines, nor in the KVM MMU doc.
Let's do it here, too, since it is too trivial thing to warrant a separate
commit.

Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
    The easiest way to reproduce the issue is to apply the patch
    below to the existing code and observe how memslots generations
    are mis-decoded from the SPTEs:
    diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
    --- a/arch/x86/kvm/mmu/spte.c
    +++ b/arch/x86/kvm/mmu/spte.c
    @@ -42,6 +42,9 @@ static u64 generation_mmio_spte_mask(u64 gen)
    
            mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
            mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
    +
    +       pr_notice("Gen %llx -> mask %llx\n", gen, mask);
    +
            return mask;
     }
    
    diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
    --- a/arch/x86/kvm/mmu/spte.h
    +++ b/arch/x86/kvm/mmu/spte.h
    @@ -230,6 +230,9 @@ static inline u64 get_mmio_spte_generation(u64 spte)
    
            gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
            gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
    +
    +       pr_notice("Mask %llx -> gen %llx\n", spte, gen);
    +
            return gen;
     }
    
    diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
    --- a/virt/kvm/kvm_main.c
    +++ b/virt/kvm/kvm_main.c
    @@ -766,7 +766,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
                    if (!slots)
                            goto out_err_no_arch_destroy_vm;
                    /* Generations must be different for each address space. */
    -               slots->generation = i;
    +               slots->generation = i + 0x1234;
                    rcu_assign_pointer(kvm->memslots[i], slots);
            }

 Documentation/virt/kvm/mmu.rst |  2 +-
 arch/x86/kvm/mmu/spte.c        |  4 ++--
 arch/x86/kvm/mmu/spte.h        | 10 ++++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 1c030dbac7c4..5bfe28b0728e 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -455,7 +455,7 @@ If the generation number of the spte does not equal the global generation
 number, it will ignore the cached MMIO information and handle the page
 fault through the slow path.
 
-Since only 19 bits are used to store generation-number on mmio spte, all
+Since only 18 bits are used to store generation-number on mmio spte, all
 pages are zapped when there is an overflow.
 
 Unfortunately, a single memory access might access kvm_memslots(kvm) multiple
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fcac2cac78fe..c51ad544f25b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -40,8 +40,8 @@ static u64 generation_mmio_spte_mask(u64 gen)
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
 	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
 
-	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
-	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
+	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
+	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
 	return mask;
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5c75a451c000..c4b70fe6b6ae 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -56,11 +56,11 @@
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
+ * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -73,11 +73,13 @@
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
+#define MMIO_SPTE_GEN_LOW_SHIFT	(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
 
 #define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
 #define MMIO_SPTE_GEN_HIGH_END		62
+#define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - 9)
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
 
@@ -228,8 +230,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
 
-	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
-	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
+	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_SHIFT;
+	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_SHIFT;
 	return gen;
 }
 
