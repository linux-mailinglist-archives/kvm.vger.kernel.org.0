Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757FC7DA02A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbjJ0SY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbjJ0SXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:23:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F501BC8
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc281f1214so4820825ad.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430983; x=1699035783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X28f2VSZ9uWGkcVQfgyyaL29edWIecAA+BgvPUM1/nQ=;
        b=TAsoyKwQrRhBkC2T0BV9UzlM42kysMX9+ACqmd/QXr1ijh4RLJ1VlJ4hQPZ4OoCnoP
         nbCZYhY6pekvlLoUCyZzAwSa+yMc1r43rJfCUAkFISwOFZGHtBAGnEcZa02h/8wBwJdx
         jSrpIw1Kf0BksuhGm6AkW1SBhu460Fukx/mJT79P4oAo+yp88qo3Bx+q6fn13Zixczmv
         bT3sGPjIm5mhwuwIz88+7+mCTJmQ/nnl5aiv/qhMojHS9SHHhTZ2DnajDqD5h8uBX8V8
         l6DnOXn656nXWd1FKXoRCbrVr+m2oqTQ9B+oMX0yOUdPnYAe4dCLtk6BYZW/7PjKBCdh
         yrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430983; x=1699035783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X28f2VSZ9uWGkcVQfgyyaL29edWIecAA+BgvPUM1/nQ=;
        b=o3x5qLFMHfaG1VqnldQlABBW2F+Qd0ZTpak0YW123R/L+IgdEk0NeeqRkCd6/EBEC/
         koswb1GCEKLB5C599/9NEfit4nRNLlrEf5aqylwSLPc6I2UTKBfldhZUdP1gFN+8CT1t
         TnKBszICs1YdWxi+2Q1BbAzjAujqCRMEoFTrqzJ7eO+Nha3jUsAKzAY3zD3qGyGw1IoK
         gyhOb2+nlJp18rkZ3+ID4OwDI1UN9+I1DwqahfgeCapkbnY5yfjvpaof+c4WrG8QOyLz
         +ilM2Hme9LBYWJYGwu1xvIEiRpDgaQSm4EPUjT6s7BlVS4LlA7PZSEkvCCdpIvHf/J0/
         VVlg==
X-Gm-Message-State: AOJu0YwJPKU7OcZRj7PXUXT15FnaS+kBAHITQYFRZfHrY9iuVc+5K1J6
        t9TK8MyxP58ALGn/7ZwpOjrHmvPyq8A=
X-Google-Smtp-Source: AGHT+IERP39eT1EKIW0o0w4FIDOku618XMvV1N7KQCMi55hnYoVKlxflcru5UfA66foRhtHASvLd2ndsc5U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4cc:b0:1cc:1900:28d7 with SMTP id
 o12-20020a170902d4cc00b001cc190028d7mr82404plg.12.1698430983359; Fri, 27 Oct
 2023 11:23:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:01 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-20-seanjc@google.com>
Subject: [PATCH v13 19/35] KVM: x86: Disallow hugepages when memory attributes
 are mixed
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

Disallow creating hugepages with mixed memory attributes, e.g. shared
versus private, as mapping a hugepage in this case would allow the guest
to access memory with the wrong attributes, e.g. overlaying private memory
with a shared hugepage.

Tracking whether or not attributes are mixed via the existing
disallow_lpage field, but use the most significant bit in 'disallow_lpage'
to indicate a hugepage has mixed attributes instead using the normal
refcounting.  Whether or not attributes are mixed is binary; either they
are or they aren't.  Attempting to squeeze that info into the refcount is
unnecessarily complex as it would require knowing the previous state of
the mixed count when updating attributes.  Using a flag means KVM just
needs to ensure the current status is reflected in the memslots.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu/mmu.c          | 154 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   4 +
 3 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 31e84668014e..8d60e4745e8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1836,6 +1836,9 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu);
 void kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
+void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
+					    struct kvm_memory_slot *slot);
+
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d33657d61d80..4167d557c577 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -795,16 +795,26 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
 	return &slot->arch.lpage_info[level - 2][idx];
 }
 
+/*
+ * The most significant bit in disallow_lpage tracks whether or not memory
+ * attributes are mixed, i.e. not identical for all gfns at the current level.
+ * The lower order bits are used to refcount other cases where a hugepage is
+ * disallowed, e.g. if KVM has shadow a page table at the gfn.
+ */
+#define KVM_LPAGE_MIXED_FLAG	BIT(31)
+
 static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 					    gfn_t gfn, int count)
 {
 	struct kvm_lpage_info *linfo;
-	int i;
+	int old, i;
 
 	for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		linfo = lpage_info_slot(gfn, slot, i);
+
+		old = linfo->disallow_lpage;
 		linfo->disallow_lpage += count;
-		WARN_ON_ONCE(linfo->disallow_lpage < 0);
+		WARN_ON_ONCE((old ^ linfo->disallow_lpage) & KVM_LPAGE_MIXED_FLAG);
 	}
 }
 
@@ -7161,3 +7171,143 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_huge_page_recovery_thread)
 		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
+
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+				int level)
+{
+	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
+}
+
+static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+				 int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
+}
+
+static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+			       int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
+}
+
+static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       gfn_t gfn, int level, unsigned long attrs)
+{
+	const unsigned long start = gfn;
+	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
+
+	if (level == PG_LEVEL_2M)
+		return kvm_range_has_memory_attributes(kvm, start, end, attrs);
+
+	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
+		if (hugepage_test_mixed(slot, gfn, level - 1) ||
+		    attrs != kvm_get_memory_attributes(kvm, gfn))
+			return false;
+	}
+	return true;
+}
+
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range)
+{
+	unsigned long attrs = range->arg.attributes;
+	struct kvm_memory_slot *slot = range->slot;
+	int level;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	lockdep_assert_held(&kvm->slots_lock);
+
+	/*
+	 * Calculate which ranges can be mapped with hugepages even if the slot
+	 * can't map memory PRIVATE.  KVM mustn't create a SHARED hugepage over
+	 * a range that has PRIVATE GFNs, and conversely converting a range to
+	 * SHARED may now allow hugepages.
+	 */
+	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+		return false;
+
+	/*
+	 * The sequence matters here: upper levels consume the result of lower
+	 * level's scanning.
+	 */
+	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
+		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
+		gfn_t gfn = gfn_round_for_level(range->start, level);
+
+		/* Process the head page if it straddles the range. */
+		if (gfn != range->start || gfn + nr_pages > range->end) {
+			/*
+			 * Skip mixed tracking if the aligned gfn isn't covered
+			 * by the memslot, KVM can't use a hugepage due to the
+			 * misaligned address regardless of memory attributes.
+			 */
+			if (gfn >= slot->base_gfn) {
+				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+					hugepage_clear_mixed(slot, gfn, level);
+				else
+					hugepage_set_mixed(slot, gfn, level);
+			}
+			gfn += nr_pages;
+		}
+
+		/*
+		 * Pages entirely covered by the range are guaranteed to have
+		 * only the attributes which were just set.
+		 */
+		for ( ; gfn + nr_pages <= range->end; gfn += nr_pages)
+			hugepage_clear_mixed(slot, gfn, level);
+
+		/*
+		 * Process the last tail page if it straddles the range and is
+		 * contained by the memslot.  Like the head page, KVM can't
+		 * create a hugepage if the slot size is misaligned.
+		 */
+		if (gfn < range->end &&
+		    (gfn + nr_pages) <= (slot->base_gfn + slot->npages)) {
+			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+				hugepage_clear_mixed(slot, gfn, level);
+			else
+				hugepage_set_mixed(slot, gfn, level);
+		}
+	}
+	return false;
+}
+
+void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
+					    struct kvm_memory_slot *slot)
+{
+	int level;
+
+	if (!kvm_arch_has_private_mem(kvm))
+		return;
+
+	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
+		/*
+		 * Don't bother tracking mixed attributes for pages that can't
+		 * be huge due to alignment, i.e. process only pages that are
+		 * entirely contained by the memslot.
+		 */
+		gfn_t end = gfn_round_for_level(slot->base_gfn + slot->npages, level);
+		gfn_t start = gfn_round_for_level(slot->base_gfn, level);
+		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
+		gfn_t gfn;
+
+		if (start < slot->base_gfn)
+			start += nr_pages;
+
+		/*
+		 * Unlike setting attributes, every potential hugepage needs to
+		 * be manually checked as the attributes may already be mixed.
+		 */
+		for (gfn = start; gfn < end; gfn += nr_pages) {
+			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
+
+			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+				hugepage_clear_mixed(slot, gfn, level);
+			else
+				hugepage_set_mixed(slot, gfn, level);
+		}
+	}
+}
+#endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f41dbb1465a0..824b58b44382 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12607,6 +12607,10 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	kvm_mmu_init_memslot_memory_attributes(kvm, slot);
+#endif
+
 	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
-- 
2.42.0.820.g83a721a137-goog

