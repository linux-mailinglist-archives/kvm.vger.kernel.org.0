Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827996476B1
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLHTko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiLHTkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:16 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBCA1AA16
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:40:01 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b4eb124be5so24666057b3.19
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XV6plMeF8MwFNJz3HbB05g+syGBZZ4afzsZVPB1fNOM=;
        b=Or/+tQ35VJl1emV0K4s+0pZ6UBajubG9tq8FrCH/hA3kAwbcecTNaCZrvYWvTtsU9g
         5JZnVfab3n41kCOJL7IiSST4+aKZY4JSEhz9//xqRqAsRUBEKxw9xl8ylX8pwq0BwIdV
         I/Xh88N0cUIemHf3DBiDhLCAmUuyGnaY5gTHAU4MfbG4ILGutMlede6Fq/e7cS9eVM31
         nHh094v1U0MR6DFbL/HmUOOC1ZS2/Zm3j4YdatXU4M2l2wqxp12xCNyRytDsAZdWIiVJ
         2+SDuw6pj88vz17PG6Z8Q+mIQbHf2BO5E5P+E5Z5Z6J+LaEFzERjkL2lFcMUz4dZZ5j1
         PSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XV6plMeF8MwFNJz3HbB05g+syGBZZ4afzsZVPB1fNOM=;
        b=h1wewyv76RGoTRTp6gmMmhWKLzgZm9igN/JikNkkfAwY03NTIcxYREPjxTFDHhP1Bv
         LHVnKgSYpjksZiUsvKuqas0La4t+oOS4iSRT4elaRDylDtgm5TKXjcWDlDUCWuR3qG7D
         B52dCVeGi+H9rECEteoHPe+ciI3wVxINvntV1gBs0NlTEIh0KwEpR++9d51AsT45VJ0n
         hzlPihcHk2Rw3gp8DSI/FQjG/rHxGsBlLS78G/uFn9lM+kve7KBSENfM7ARLQEjn/IGi
         a28DqruWkaWHk+u5tRf+15BOplAo2kXbPCtv4jZILIfJGOr6Kilz6y3k1MBsWozWamjJ
         PbfQ==
X-Gm-Message-State: ANoB5plSnuZHf9NHHrbEeHjUT+tyhrXMkqrns6/RQ0VSj0xb9V2Bpz6h
        RUY6HsqquZ/Dh1N2mEMnzgnE+dMjl/Gneg==
X-Google-Smtp-Source: AA0mqf6Wkh0OUy4PlZrJU9hOTo3IInMenz2jMKiaSBByUieGZ1GCpj8vRhZKagSo80e6dZu+mbM8OPIkZWhBWg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:230b:0:b0:6f9:b1b0:67f5 with SMTP id
 j11-20020a25230b000000b006f9b1b067f5mr28607189ybj.471.1670528401185; Thu, 08
 Dec 2022 11:40:01 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:52 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-33-dmatlack@google.com>
Subject: [RFC PATCH 32/37] KVM: Allow range-based TLB invalidation from common code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make kvm_flush_remote_tlbs_range() visible in common code and create a
default implementation that just invalidates the whole TLB. This will be
used in future commits to clean up kvm_arch_flush_remote_tlbs_memslot()
and to move the KVM/x86 TDP MMU to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 1 -
 include/linux/kvm_host.h        | 1 +
 virt/kvm/kvm_main.c             | 9 +++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e44fe7ad3cfb..df815cb84bd2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,6 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ec3a6de6d54e..d9a7f559d2c5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1365,6 +1365,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f1d48ed7d57..662ca280c0cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -379,6 +379,15 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
 
+/*
+ * Architectures that support range-based TLB invalidation can override this
+ * function.
+ */
+void __weak kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
+
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

