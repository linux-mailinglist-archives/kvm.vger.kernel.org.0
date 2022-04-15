Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC725030F4
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356159AbiDOWCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355788AbiDOWBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:54 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB7DFD3B
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:25 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id p10-20020a056e02104a00b002caa828f7b1so5432447ilj.7
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jzvc81PBGj4bV/jHUjtzPtFNqWylMffaehwRBxD6iIE=;
        b=aWkRKsBqnouPuu0iRgQFmbdZNwM6u65S9STgd8WzLazymunDNq+F/2LV041lFacxkX
         sH2au5CIL4U6btbR36TcgERHcBL5JA8T93pnN1zy/vCBpJyTdEx4s8aDOU+JwJD7FEgH
         EDuCMiJ2lKlmqCfo2HCyFA8YBpzh+0As1Im7YSg7MivXDgsyltO1HdVbeLv+yGFmNIPi
         O5p8sXbUH14m1SBo2J0fuW1TDCouol/p3zaCmN7Pb1tclO6RjKEsMyqqJ0eOLp38uD1h
         AbzgBBIOOsbBeQk1WFRiKNO/0k6ugAlDvMy5k+FqVLVzTLXvQl7QmS1J6MjDvDSfP9W4
         9n1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jzvc81PBGj4bV/jHUjtzPtFNqWylMffaehwRBxD6iIE=;
        b=2kYp3lXJQnCS/TUV5BYxYxtdLECtPFj4/a03o/57xYQd7oRAIfsB+o1hOohd8/2nwj
         c/n6FKpK0a2Isz4bNe8hySob7GVzzH2JhMDCJX+EeSQdY8SiCrDcQRADfv1uaAfxszri
         eX25F6OeuBxM3ht5H16Qu5Usj2gU0/IF2qXY7NxVpgxHNeecFrG4jVwyNu4Jl863Slln
         JJNRH04eNWsk0MmCLVdqx/befZqIfZUgRvYggDTCqNyRrERKZOuSuctpcnHRpMRosamW
         nINWz0RQS7tkDh2clabjaH2zqhpVEJorfQbORbH7NdtBYQvGb94RopivnsTwxtLD4pLX
         lKfw==
X-Gm-Message-State: AOAM530WZaYoNfso+nnQm/jvMK6Q5uOmnkF3cHBWXJ6CPwvqXK9GrDEb
        IRV6RXA87OEaCn7tt831Cqmp7XTFoDo=
X-Google-Smtp-Source: ABdhPJy0T0D9tPSOS2fkDjAWGdXFAsgYKiBOBw6Vv9SkS2qbIf2KOV78tziChH3+cjdCnnpihxhBubRLicI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b0f:b0:2c7:9a3f:6e84 with SMTP id
 i15-20020a056e021b0f00b002c79a3f6e84mr312271ilv.32.1650059964470; Fri, 15 Apr
 2022 14:59:24 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:59:01 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-18-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 17/17] TESTONLY: KVM: arm64: Add super lazy accounting of
 stage 2 table pages
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't use this please. I was just being lazy but wanted to make sure
tables are all accounted for.

There's a race here too, do you see it? :)

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2881051c3743..68ea7f0244fe 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -95,6 +95,8 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 	return !pfn_is_map_memory(pfn);
 }
 
+static atomic_t stage2_pages = ATOMIC_INIT(0);
+
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_caches *mmu_caches = arg;
@@ -112,6 +114,8 @@ static void *stage2_memcache_zalloc_page(void *arg)
 		return NULL;
 	}
 
+	atomic_inc(&stage2_pages);
+
 	hdr->page = virt_to_page(addr);
 	set_page_private(hdr->page, (unsigned long)hdr);
 	return addr;
@@ -121,6 +125,8 @@ static void stage2_free_page_now(struct stage2_page_header *hdr)
 {
 	WARN_ON(page_ref_count(hdr->page) != 1);
 
+	atomic_dec(&stage2_pages);
+
 	__free_page(hdr->page);
 	kmem_cache_free(stage2_page_header_cache, hdr);
 }
@@ -662,6 +668,8 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.icache_inval_pou	= invalidate_icache_guest_page,
 };
 
+static atomic_t stage2_mmus = ATOMIC_INIT(0);
+
 /**
  * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
@@ -699,6 +707,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	atomic_inc(&stage2_mmus);
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
@@ -796,6 +806,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		kvm_pgtable_stage2_destroy(pgt);
 		kfree(pgt);
 	}
+
+	if (atomic_dec_and_test(&stage2_mmus))
+		WARN_ON(atomic_read(&stage2_pages));
 }
 
 /**
-- 
2.36.0.rc0.470.gd361397f0d-goog

