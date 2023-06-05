Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F682723257
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 23:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjFEVgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 17:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjFEVgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 17:36:10 -0400
Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [IPv6:2001:41d0:203:375::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6B1D9
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 14:36:08 -0700 (PDT)
Date:   Mon, 5 Jun 2023 14:36:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686000966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F3VFFG2jfkJ+ZSun0OC3Y7zPGm32YzSkJrZqM1qWhVA=;
        b=AKtHFvLGYetRZ3XpqKzpBdah7sAcjqnBOU9TjP+acvw6U7AEqPZzbNU8j0dzPdjoAOsS4W
        B5VR1VGKyhepBc014ps58qYlAdvQeKgRmg7rz7j46+XH3+ZRyG02WE1+na6gQc17CfWhL4
        ScwjexcMx1YV6lOv4klwEW1R+9shFfI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: Skip break phase when we have FEAT_BBM
 level 2
Message-ID: <ZH5VQMEoiHEITmF4@linux.dev>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-4-coltonlewis@google.com>
 <87sfb7octw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfb7octw.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 04, 2023 at 09:23:39AM +0100, Marc Zyngier wrote:
> On Fri, 02 Jun 2023 18:01:47 +0100, Colton Lewis <coltonlewis@google.com> wrote:
> > +static bool stage2_try_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu, kvm_pte_t new)
> >  {
> >  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > 
> > -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > +	if (!stage2_has_bbm_level2())
> > +		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > +
> > +	if (!stage2_try_set_pte(ctx, new))
> > +		return false;
> > +
> > +	if (kvm_pte_table(ctx->old, ctx->level))
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +	else if (kvm_pte_valid(ctx->old) && !stage2_pte_perms_equal(ctx->old, new))
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, mmu, ctx->addr, ctx->level);
> 
> Why a non-shareable invalidation? Nothing in this code captures the
> rationale for it. What if the permission change was a *restriction* of
> the permission? It should absolutely be global, and not local.

IIRC, Colton was testing largely with permission relaxation, and had
forward progress issues b.c. the stale TLB entry was never invalidated
in response to a permission fault.

Nonetheless, I very much agree with your suggestion. Non-Shareable
invalidations should only be applied after exhausting all other
invalidation requirements for a particular manipulation to the stage-2
tables.

> >
> >  	if (stage2_pte_is_counted(new))
> >  		mm_ops->get_page(ctx->ptep);
> > 
> > -	smp_store_release(ctx->ptep, new);
> > +	return true;
> >  }
> > 
> >  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> > @@ -879,7 +917,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  	    stage2_pte_executable(new))
> >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> > 
> > -	stage2_make_pte(ctx, new);
> > +	if (!stage2_try_make_pte(ctx, data->mmu, new))
> > +		return -EAGAIN;
> 
> So we don't have forward-progress guarantees anymore? I'm not sure
> this is a change I'm overly fond of.

I'll take the blame for the clunky wording here, though I do not believe
there are any real changes to our forward progress guarantees relative to
the existing code.

Previously, we did the CAS on the break side of things to have a fault
handler 'take ownership' of a PTE. The CAS now needs to move onto the
make end when doing a BBM=2 style manipulation.

Would you rather see something explicitly keyed on the BBM capability
here? Then we could use a helper that implies unconditional success for
BBM!=2 systems.

--
Thanks,
Oliver
