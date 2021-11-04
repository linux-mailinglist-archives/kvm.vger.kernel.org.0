Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7EA444C60
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhKDAaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhKDA27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:59 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F57C061205
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso2348407pgi.21
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/RvGHTt4E3c4iVv3wsterupSlbh/I++vTjsd+nrbZTE=;
        b=HyykrtCCmq3kCamMD/Tm7VvDgqmDnoEsE+g1eeqH4NbqmVOGEIPXEF0p44V12K+tKv
         cuhUnPrZGQP5wZ3hLK+/1RKT0txi5xKCd+JuqAuxM/FmVqFBME7pAC+KWpd37Sadnmeu
         lG6JAvLtVSbJb1He7sVTN3iqT2jXaXZ9aCFU0nSIjt20mOePuQMygvc8lEwJBvVIqi6I
         K5uhrd/Mr5VKCjgNFfaDRg+gQDzGFZRQLuV3piNS1sOT1VVHqP+YMJNc8a7c9S8QvZA6
         4wHieFDZfoFTOKF1jdxfARHJJ/0OEyKmgNBjIBCXoaMWWRQ2moanjPbmOrNTixvUNha5
         SCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/RvGHTt4E3c4iVv3wsterupSlbh/I++vTjsd+nrbZTE=;
        b=cBC0SOtES/MYDxq0j2bk+l67ESyETPAvtCZnVYQy37diBNS65xbEgQg4yXX7U3nCOp
         j7bf8A3xrz+himhGYAD3nhDKetZ2SmtXdRbyMaXsBKY9HhOqPryFw48AIKWiNPih3kvI
         vMoygnH6qTjWCNM8vACk7xNfhL4S6dBE0VE3vsBQOloeRVtUFOoxMbtOB95pGNHGFJol
         e29Rpy12HE8/AsnNyBMGxU5aGozOp/ERaI8XL3DYwc3YtLlkkLQdOMhh2kPXILbNcoN9
         PbZpxHcGiipyPfWnUJl+mptMAx7JAtFatzBAbsQ4G7PBHTlmiUZr0VhzZ6WZcepjx/dz
         0xwA==
X-Gm-Message-State: AOAM533IboNBIpkX/5GcsZqqU2PpgbVfXDK8wrSnB4AneWmdrpkfKtsv
        sxsreD/OCR/YVjmQJdQt1OZ1y5/roOs=
X-Google-Smtp-Source: ABdhPJzUTstetgr7LfAz4PUuI3fkJrGKDFjmFGhXU/D+Ufl0+b4ADI76LnvXO52LyVNOIFV+GAz+aYo+l4Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9348:b0:141:5862:28b4 with SMTP id
 g8-20020a170902934800b00141586228b4mr41368996plp.17.1635985582257; Wed, 03
 Nov 2021 17:26:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:15 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-15-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 14/30] KVM: Stop passing kvm_userspace_memory_region to
 arch memslot hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the @mem param from kvm_arch_{prepare,commit}_memory_region() now
that its use has been removed in all architectures.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c       | 2 --
 arch/mips/kvm/mips.c       | 2 --
 arch/powerpc/kvm/powerpc.c | 2 --
 arch/riscv/kvm/mmu.c       | 2 --
 arch/s390/kvm/kvm-s390.c   | 2 --
 arch/x86/kvm/x86.c         | 2 --
 include/linux/kvm_host.h   | 2 --
 virt/kvm/kvm_main.c        | 9 ++++-----
 8 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 21213cba7c47..a76718388cbd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,7 +1463,6 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -1486,7 +1485,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b7aa8fa4a5fb..47b7dc149032 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -233,7 +233,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -242,7 +241,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 59342237e046..52ab1782b257 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -706,7 +706,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -715,7 +714,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index db5230ec6951..0732867d398c 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -456,7 +456,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
@@ -471,7 +470,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e69ad13612d9..81f90891db0f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5016,7 +5016,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -5044,7 +5043,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c68e7de9f116..80e726f73dd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11727,7 +11727,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -11831,7 +11830,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f8e79cf7584f..2ef946e94a73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -826,12 +826,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 389243120435..9c75691b98ba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1535,7 +1535,6 @@ static void kvm_copy_memslots_arch(struct kvm_memslots *to,
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
-			   const struct kvm_userspace_memory_region *mem,
 			   struct kvm_memory_slot *new,
 			   enum kvm_mr_change change)
 {
@@ -1621,7 +1620,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		old.as_id = new->as_id;
 	}
 
-	r = kvm_arch_prepare_memory_region(kvm, mem, &old, new, change);
+	r = kvm_arch_prepare_memory_region(kvm, &old, new, change);
 	if (r)
 		goto out_slots;
 
@@ -1637,7 +1636,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 	else if (change == KVM_MR_CREATE)
 		kvm->nr_memslot_pages += new->npages;
 
-	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
+	kvm_arch_commit_memory_region(kvm, &old, new, change);
 
 	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
 	if (change == KVM_MR_DELETE)
@@ -1722,7 +1721,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		new.id = id;
 		new.as_id = as_id;
 
-		return kvm_set_memslot(kvm, mem, &new, KVM_MR_DELETE);
+		return kvm_set_memslot(kvm, &new, KVM_MR_DELETE);
 	}
 
 	new.as_id = as_id;
@@ -1785,7 +1784,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &new, change);
+	r = kvm_set_memslot(kvm, &new, change);
 	if (r)
 		goto out_bitmap;
 
-- 
2.33.1.1089.g2158813163f-goog

