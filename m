Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028296476A4
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLHTk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLHTkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7DF1AA01
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:53 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368994f4bc0so24896387b3.14
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PeJRMD1iiEfAcW0wse8YvMRXDysx/LxLCpDqGqOGbOE=;
        b=it3ha/1H2vQVcMvrwLK2XI6kFW9SfZwdQ0HxxUSc3Ag107nHhiqTSUqlouPQ69hlpA
         gVlMznc/cXRCFulmlBil4kKdWgDSAUCR93SntgLaDJWCpUTB7FzwaETswPW9lX1yNG07
         0tWWOwYFihDwyLqkpiOMrsIryZ3SjYTTI8b4R1X9oFZnj7/UyRLh3XP6ECDzERPz2C+i
         B3prUkRr3KEH0wVuRrtyBo09IY2F7MxhaUoLo7LOK5D3eYUuVBFYj36vL7P7ZiNQEA7c
         1QUJk9A2erTf8dkQPtJhbcBzs55NBkUNAK3ruLZHLQeHsz23ls2YGKCDBr5v8J7edZjj
         uhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PeJRMD1iiEfAcW0wse8YvMRXDysx/LxLCpDqGqOGbOE=;
        b=DxUAGGaE9p8NIKypSwB5BRnU9XP21Az1LJNkISpjvIPl+yXnBbRNbEu4dsT0nsOh4i
         qIbjdz7nsURDQDBfnZAriA9w26L0ZZytvy5QdCDHMMxEcvirejF3JETtcfZnDkDG7rkP
         CTJRCL3Hkz8ACdjas2oEZiEizenzSusvVSf1t3PAgNlwMHIpCLdiyGJqbauYh5yATkoH
         ub5ip5Hc3Bih5KYe0AimNfxlG+Bz0rY/N+Xj68af42IiWLNCejWx4+SaC1JRiKGSnDaq
         Wl/GUooAodOFoteOy4OmcDTkWGIt7mUpMS6kNUVjUFwHazF7lVIhsQHN8kbh+exP4Gwk
         EAZQ==
X-Gm-Message-State: ANoB5plX5GyMIMsdtTIijS3RDXjfyjEODAuGsnBMAGQ0CFNHlxhNADqI
        pZ3WFHAbohAmc3pm6vMIZPkpQ6Ex/LdL8g==
X-Google-Smtp-Source: AA0mqf42i4HuA7nX3hyDm6T4qhjEe3EzuwVfCeNTiMqXBDpZ0EVA3TMnNfFvR5iVyImke8GmCkOtSd5OsKu+oA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6602:0:b0:6f9:890c:6468 with SMTP id
 a2-20020a256602000000b006f9890c6468mr39021311ybc.610.1670528389040; Thu, 08
 Dec 2022 11:39:49 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:45 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-26-dmatlack@google.com>
Subject: [RFC PATCH 25/37] KVM: x86/mmu: Pass root role to kvm_tdp_mmu_get_vcpu_root_hpa()
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

Pass the root role from the caller rather than grabbing it from
vcpu->arch.mmu. This will enable the TDP MMU to be moved to common code
in a future commit by removing a dependency on vcpu->arch.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9307608ae975..aea7df3c2dcb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3612,7 +3612,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 
 	if (tdp_mmu_enabled) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, mmu->root_role);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e6708829714c..c5d1c9010d21 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -301,9 +301,9 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu,
+				    union kvm_mmu_page_role role)
 {
-	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index e6a929089715..897608be7f75 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,8 @@
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu,
+				    union kvm_mmu_page_role role);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.39.0.rc1.256.g54fd8350bd-goog

