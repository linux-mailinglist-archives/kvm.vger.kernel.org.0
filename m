Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1BA84BC0C0
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 20:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiBRT5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 14:57:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiBRT5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 14:57:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46A1318
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 11:57:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so13270508pja.3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 11:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/d01CJlns18fAcM0cp103UJoAjW6bWMPgEloVoBqqiE=;
        b=ELKF7KNp6d62FxW6L3SC3x2tKGiZYjTfylArFhV7/fM7T7Vu1t05UkqE21q/vtUX7h
         z1PSWwaIN5vDsZH44ZT0sfbt7lITvTU4KMJkBuBZ+ssPqkTk8i/B+q6J1Dnu4NUrdOKx
         j365P6n9vsuR22N3K3EkVs0VpU47Pkm6bPkOA1yHxkvBR7m/yoFEczX8F/YegilHz+Ni
         7rxglZqpGxLGq43GrM57BHyMpd9jpz1WP55W37gARf43uvA7Mm2BKX5koySCTbHSoIcv
         JPTW4bLJqTvbfa74ON97JFzPTxHjme+feLU6erQ9FFgdquWIkVuxQ6VIg2MLVX5AlNKW
         GplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/d01CJlns18fAcM0cp103UJoAjW6bWMPgEloVoBqqiE=;
        b=QPt7jtg3Rcd3sdbou8Fx2nR7DXp6nY8cSuT/rIpqX/fHkv4Tfz3QiCdBdeXiKKuvuA
         doz01Jq0JKCi5QU2zj/39DwOyEMvGNbqFq0gPdtTVzbHuwHQjOrc+NSd8X6wwGzyVGto
         B7kfXtfBIx2jz+CQXqeGQBxMOyJP0OB/AIf11cXw0Kzbp0LElUoMtr64F8o0wDdNKNwM
         WYHaAtb/eL7CzlcygmkZNB3hLOlGTFWbKVXinIAYTxXGVn6oLFkfwt4YSwb8Lyt9WsWr
         uUkDar9INLsowm/r4dGtcLURh+z77LnMek4jBSbE+ZVtuq6KWTbH5XGwJrameF54Rq+P
         5fkA==
X-Gm-Message-State: AOAM5331bYcbCfZ8eyXO7cMW/eOHVqoSEYC9C2BS20lLRTb+dS1+xWJ7
        g0Qkqrm3ptScfXOg8lNtHs03mw==
X-Google-Smtp-Source: ABdhPJyWjCxMpEZlIFnsQ1K63vSKo2lhtcqU7+K2gRvE8CBIn8UVv8VNsAO9FbHEE88M3JkMKOaU5A==
X-Received: by 2002:a17:902:ced2:b0:14f:88da:5dc with SMTP id d18-20020a170902ced200b0014f88da05dcmr1011702plg.62.1645214234136;
        Fri, 18 Feb 2022 11:57:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z21sm11444014pgv.21.2022.02.18.11.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:57:13 -0800 (PST)
Date:   Fri, 18 Feb 2022 19:57:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: Re: [PATCH v0 02/15] KVM: x86/xen: Use gfn_to_pfn_cache for runstate
 area
Message-ID: <Yg/6FoL9dH1/lTOS@google.com>
References: <20220210002721.273608-1-dwmw2@infradead.org>
 <20220210002721.273608-3-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210002721.273608-3-dwmw2@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>

RFC, or lazy? :-D

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> -		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
> +		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
>  					      &vcpu->arch.xen.runstate_cache,
> -					      data->u.gpa,
> -					      sizeof(struct vcpu_runstate_info));
> -		if (!r) {
> -			vcpu->arch.xen.runstate_set = true;
> -		}
> +					      NULL, false, true, data->u.gpa,
> +					      sizeof(struct vcpu_runstate_info),
> +					      false);

Now that I'm all too aware of the subtle importants of @guest_uses_pa and
@kernel_map, before the pfn cache code gains more users, can you slot this in at
the beginning of the series?  It'd be quite easy to mess up and pass "false, false"
and completely mishandle cases where the PFN is mapped into the guest.


From: Sean Christopherson <seanjc@google.com>
Date: Fri, 18 Feb 2022 11:45:47 -0800
Subject: [PATCH] KVM: Use enum to track if cached PFN will be used in guest
 and/or host

Replace the guest_uses_pa and kernel_map booleans in the PFN cache code
with a unified enum/bitmask.  Using explicit names makes it easier to
review and audit call sites.

Opportunstically add a WARN to prevent passing garbage, instantating a
cache without declaring its usage is either buggy or pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/xen.c        |  2 +-
 include/linux/kvm_host.h  | 11 +++++------
 include/linux/kvm_types.h | 10 ++++++++--
 virt/kvm/pfncache.c       | 14 +++++++-------
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4aa0f2b31665..5be1c9227105 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -39,7 +39,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	}

 	do {
-		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true,
+		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, KVM_HOST_USES_PFN,
 						gpa, PAGE_SIZE, false);
 		if (ret)
 			goto out;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..d044e328046a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1222,9 +1222,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @vcpu:	   vCPU to be used for marking pages dirty and to be woken on
  *		   invalidation.
- * @guest_uses_pa: indicates that the resulting host physical PFN is used while
- *		   @vcpu is IN_GUEST_MODE so invalidations should wake it.
- * @kernel_map:    requests a kernel virtual mapping (kmap / memremap).
+ * @usage:	   indicates if the resulting host physical PFN is used while
+ *		   the @vcpu is IN_GUEST_MODE and/or if the PFN used directly
+ *		   by KVM (and thus needs a kernel virtual mapping).
  * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
  * @dirty:         mark the cache dirty immediately.
@@ -1240,9 +1240,8 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * to ensure that the cache is valid before accessing the target page.
  */
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
-			      bool kernel_map, gpa_t gpa, unsigned long len,
-			      bool dirty);
+			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+			      gpa_t gpa, unsigned long len, bool dirty);

 /**
  * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index dceac12c1ce5..784f37cbf33e 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -18,6 +18,7 @@ struct kvm_memslots;

 enum kvm_mr_change;

+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/spinlock_types.h>

@@ -46,6 +47,12 @@ typedef u64            hfn_t;

 typedef hfn_t kvm_pfn_t;

+enum pfn_cache_usage {
+	KVM_GUEST_USES_PFN = BIT(0),
+	KVM_HOST_USES_PFN  = BIT(1),
+	KVM_GUEST_AND_HOST_USE_PFN = KVM_GUEST_USES_PFN | KVM_HOST_USES_PFN,
+};
+
 struct gfn_to_hva_cache {
 	u64 generation;
 	gpa_t gpa;
@@ -64,11 +71,10 @@ struct gfn_to_pfn_cache {
 	rwlock_t lock;
 	void *khva;
 	kvm_pfn_t pfn;
+	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
 	bool dirty;
-	bool kernel_map;
-	bool guest_uses_pa;
 };

 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ce878f4be4da..9b3a192cb18c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -42,7 +42,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 			 * If a guest vCPU could be using the physical address,
 			 * it needs to be woken.
 			 */
-			if (gpc->guest_uses_pa) {
+			if (gpc->usage & KVM_GUEST_USES_PFN) {
 				if (!wake_vcpus) {
 					wake_vcpus = true;
 					bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
@@ -219,7 +219,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			goto map_done;
 		}

-		if (gpc->kernel_map) {
+		if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
@@ -299,10 +299,11 @@ EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);


 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
-			      bool kernel_map, gpa_t gpa, unsigned long len,
-			      bool dirty)
+			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+			      gpa_t gpa, unsigned long len, bool dirty)
 {
+	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
+
 	if (!gpc->active) {
 		rwlock_init(&gpc->lock);

@@ -310,8 +311,7 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
 		gpc->vcpu = vcpu;
-		gpc->kernel_map = kernel_map;
-		gpc->guest_uses_pa = guest_uses_pa;
+		gpc->usage = usage;
 		gpc->valid = false;
 		gpc->active = true;


base-commit: f6ae04ddb347f526b4620d1053690ecf1f87d77f
--

