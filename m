Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B456A636
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbiGGOyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiGGOyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:54:17 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C645A468
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 07:53:22 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id i190so6363030pge.7
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 07:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OBfA/tOWKDH/d0iqDHWzbMXJjftxH/MH3t5WvdViZQQ=;
        b=pR+rIGsD+r3vX4OQrOKl3UZS4iF8E+D8BKUI/weNfW+PGopIXCDdZPjksfjWd8gHWJ
         BGhOtvNRX7kCy3R7cgJlcljqi+gnkzxAoh5WSZR0HT9FNGdqZT+EazoE4HHnN8Bm1P1R
         X0+52AYO3dKbRIK9Dx/ib4b2Vck4z+rBp9YkPG5A06r/1k8ZwKU9xL/q5t8VApGbfTBU
         PcXFkE/8ooEAc4YqajR0WqTNd9ntjZq+Hl9rMObxWFZmbAA4Ak5JqFsxVVOhl7VsHf5v
         3rSwa+sFPSVJJNm+Czd1o2iiK+2J6k0G6jjdQQZ3o5Q2eKasp44QJ1G+qFNAB8A0/bhV
         cp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OBfA/tOWKDH/d0iqDHWzbMXJjftxH/MH3t5WvdViZQQ=;
        b=DRMtomL+SETsarzcem+YYJqGx5gLKgyiqD9uIq25z/BnExpHHiFo0HKQAU3szkpmAT
         caATtKKNk6G5z63sUwqw/5fpwvPqTmrveK6XC8IZ+qd8UTMfudrxKTiM1x5OunYEvOWO
         CDxd5sKZZ9Pprc+9jxSRizOjt9vtTSjEqR1xmbOCWg9xSSTK5BZ9kKq9NT/EJTLMd0vA
         ZK9zurFSgkVX5D+fMc/mQZwHAGW5Rx3sY36w7yKh+qOuD7l9fabvCXNZcUmTecJh23Im
         EsSc8ZFSMURkc+vXupPCNeYE/NMsukL4mPt2P/jqi9qvanOe5Qb62KOM2AUW+AkIkBDw
         harg==
X-Gm-Message-State: AJIora+CXlio8gWDhHsdC6aEHMjXkh0VaB9XBvYz50x8TfMhhCQvlEt9
        a4ArqN3czKZWp6P59rpAuL4fow==
X-Google-Smtp-Source: AGRyM1ubhD1vChakXi7/pBwgcLNQlIVivSTCug4iXuVCxFRInKz9e2YqixdPqeB+1osa1FkcEcoIxQ==
X-Received: by 2002:a17:90b:3504:b0:1ec:d246:f02d with SMTP id ls4-20020a17090b350400b001ecd246f02dmr5706687pjb.46.1657205601346;
        Thu, 07 Jul 2022 07:53:21 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([223.226.40.162])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7951a000000b0052535e7c489sm27144231pfp.114.2022.07.07.07.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:53:20 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/5] KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
Date:   Thu,  7 Jul 2022 20:22:44 +0530
Message-Id: <20220707145248.458771-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707145248.458771-1-apatel@ventanamicro.com>
References: <20220707145248.458771-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_mmu_topup_memory_cache() always uses GFP_KERNEL_ACCOUNT for
memory allocation which prevents it's use in atomic context. To address
this limitation of kvm_mmu_topup_memory_cache(), we add gfp_custom flag
in struct kvm_mmu_memory_cache. When the gfp_custom flag is set to some
GFP_xyz flags, the kvm_mmu_topup_memory_cache() will use that instead of
GFP_KERNEL_ACCOUNT.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kvm_types.h | 1 +
 virt/kvm/kvm_main.c       | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ac1ebb37a0ff..1dcfba68076a 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -87,6 +87,7 @@ struct gfn_to_pfn_cache {
 struct kvm_mmu_memory_cache {
 	int nobjs;
 	gfp_t gfp_zero;
+	gfp_t gfp_custom;
 	struct kmem_cache *kmem_cache;
 	void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a49df8988cd6..e3a6f7647474 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -386,7 +386,9 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	if (mc->nobjs >= min)
 		return 0;
 	while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
-		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
+		obj = mmu_memory_cache_alloc_obj(mc, (mc->gfp_custom) ?
+						 mc->gfp_custom :
+						 GFP_KERNEL_ACCOUNT);
 		if (!obj)
 			return mc->nobjs >= min ? 0 : -ENOMEM;
 		mc->objects[mc->nobjs++] = obj;
-- 
2.34.1

