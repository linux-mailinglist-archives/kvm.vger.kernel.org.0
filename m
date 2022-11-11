Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D541462628A
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 21:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiKKUI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 15:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiKKUIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 15:08:55 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767DB1D64C
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 12:08:53 -0800 (PST)
Date:   Fri, 11 Nov 2022 20:08:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668197331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CR/BgVwe7HxMaTNopzcYpQIyocAwzhPLTHwWe8JX9Gw=;
        b=OM7owYX06RCsWyr3GpCAaL643zHY+VuwSmSnrlYjCjLQ61BDWMzV5BxFBxTxGP2IW/CEW9
        oK2VL8hw8Vil+G29J6pG+qEaAGCCooA3ymhNAFp9cqj1wbQO4OaE80xeUPkhiqc5xfu9dr
        a9fHq9pK7su/PInOw+OmYLq4keyUK/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Vincent Donnefort <vdonnefort@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH v6 00/26] KVM: arm64: Introduce pKVM hyp VM and vCPU
 state at EL2
Message-ID: <Y26rzvyLQ/1juAAz@google.com>
References: <20221110190259.26861-1-will@kernel.org>
 <166819337067.3836113.13147674500457473286.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166819337067.3836113.13147674500457473286.b4-ty@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 07:06:14PM +0000, Marc Zyngier wrote:
> On Thu, 10 Nov 2022 19:02:33 +0000, Will Deacon wrote:
> > This is version six of the pKVM EL2 state series, extending the pKVM
> > hypervisor code so that it can dynamically instantiate and manage VM
> > data structures without the host being able to access them directly.
> > These structures consist of a hyp VM, a set of hyp vCPUs and the stage-2
> > page-table for the MMU. The pages used to hold the hypervisor structures
> > are returned to the host when the VM is destroyed.
> > 
> > [...]
> 
> As for Oliver's series, I've tentatively applied this to -next.
> I've dropped Oliver's patch for now, but kept the RFC one. Maybe I'll
> change my mind.
> 
> Anyway, there was an interesting number of conflicts between the two
> series, which I tried to resolve as well as I could, but it is likely
> I broke something (although it compiles, so it must be perfect).
> 
> Please have a look and shout if/when you spot something.

Here is where you and I diverged on the conflict resolution, neither
amounts to a whole lot but feel free to squash in. Hoping that Will + co
can test the pKVM side of this.

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index f2c4672697c2..318298eb3d6b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -265,7 +265,7 @@ static int __create_fixmap_slot_cb(const struct kvm_pgtable_visit_ctx *ctx,
 {
 	struct hyp_fixmap_slot *slot = per_cpu_ptr(&fixmap_slots, (u64)ctx->arg);
 
-	if (!kvm_pte_valid(*ctx->ptep) || ctx->level != KVM_PGTABLE_MAX_LEVELS - 1)
+	if (!kvm_pte_valid(ctx->old) || ctx->level != KVM_PGTABLE_MAX_LEVELS - 1)
 		return -EINVAL;
 
 	slot->addr = ctx->addr;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index b47d969ae4d3..110f04627785 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -190,7 +190,7 @@ static void hpool_put_page(void *addr)
 }
 
 static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
-					 enum kvm_pgtable_walk_flags visit)
+				     enum kvm_pgtable_walk_flags visit)
 {
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;

--
Thanks,
Oliver
