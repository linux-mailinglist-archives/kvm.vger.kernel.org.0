Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E25E6476B4
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiLHTkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLHTkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:19 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A6E1AA27
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:40:07 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3b5da1b3130so24916577b3.5
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4nLMUWhCbgygsyxQ4LP+FBPYpvg+KdNjD6AAx7BEWII=;
        b=rW1pkR31ur5/8vzbX6I0g9dHa5ieQLfxMNHl7/CiYy31x1gmEotFcgfb6bMg1XD9l4
         cVrOC8CHqZzC+Gd2V/LwvTlYuSZNohfxzCXcTVs+DyirYljuXOWNIY4uY7CZr2a2YKF5
         72eri2VmsAQGQbk2L3oKVAoFTeSQShiiqL6JV3UiQ4QZOs2UwURjWE1AFC0PhC62yXox
         X0dKf4S1b8a4rdREripCobtwsSCC9MJx4k5wGRfNkLSnee4Y5BiQ4yQ0Og5S8kz28vfk
         0som8w77mpuwlpN/KA9+tJzi+pYWYZboOtEkERDzhNWA7MhWTNWQZafjFT2UdiruzKAQ
         QPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4nLMUWhCbgygsyxQ4LP+FBPYpvg+KdNjD6AAx7BEWII=;
        b=KLzbzMhOXNSjxoKHCWrFqKzXKhax//71aB0QNfivrMkhPCa+LiFXkeMmGwphv3xOwQ
         aAIyEb7We6ufEgUJRAq9Vf4I2CFVQizm9edOCOZpJmtSyPcKFAhRrVDkSCVSlqzbXKOp
         1IohrfTDPsTz35/WtNvswh/mfm15OlXc2aOQhWf+3Di05of9NfG8Q+L/Jp+SvtqUhfZU
         f2RkrM86zqHiwG/Fr6PdM/3MbREbIeQzaOkMd9O7xy7vC7CwW15l0ZlNOOx/42WpcM7r
         S3rVZ7ywRntv9QZVJmX7kU2PQxMNYEKfU4Z0XxdYTylzX0cmDbaCbq8VizJfGCmGwiYJ
         7HEQ==
X-Gm-Message-State: ANoB5plf8pxHNOh9S59xfqk8e1l5J2dLy15PEaCiid3b6DpvPHdS+wTt
        TCGjtJhC3wckDNJVAkzf6AxSSdqCXIlsLg==
X-Google-Smtp-Source: AA0mqf5kUDO3Tr6gk/fzW/ARrxEhzmkAXRSHhWoL0H7mQ0gz5ri8bxcSR3iro0wxy+7xhENFLIaYZergQrtKPg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:5:0:b0:6fc:8f88:813b with SMTP id
 5-20020a250005000000b006fc8f88813bmr27601586yba.629.1670528399532; Thu, 08
 Dec 2022 11:39:59 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:51 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-32-dmatlack@google.com>
Subject: [RFC PATCH 31/37] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
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

Use gfn_t instead of u64 for the start_gfn parameter to
kvm_flush_remote_tlbs_range(), since that is the standard type for GFNs
throughout KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a28adaa92b4..19963ed83484 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,7 +244,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d35a5b408b98..e44fe7ad3cfb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

