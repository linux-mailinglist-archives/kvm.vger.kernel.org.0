Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D833E728636
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 19:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbjFHRVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 13:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjFHRVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 13:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE587E59;
        Thu,  8 Jun 2023 10:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AC5664FAA;
        Thu,  8 Jun 2023 17:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBADC433EF;
        Thu,  8 Jun 2023 17:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686244878;
        bh=+1JMZudb5uniaYe3Y3wFcz2tkfuMGhPDOo6QPhGbJeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hvsQRNBUpffh2bzrvN4vsPMPOZ/NuzUw6AHwjYs+TmO/+5bq/B1NLn/y9DvjM3vhD
         qSYXcAB1x479VEs7sJKgWqnpn1IxrjyvRCEHsQpzVJ2wAtqfyTdzWnp2kqDYhndLTF
         7lNh5AlZn4b7Gp1kiAVotShPo4PJIvxx5SJexnBt7DGohA6CcKd2HCSbS0Y09VYk6M
         y5iOpEOFO7lRNIFm9ZNMfqWzNmIBEOylkDaVyxyf5C+GS0RZkmTx2ywWbtBx80IMXu
         aFRCzIeUuHSohx/8P4St1qor5bg+AYU8lVoMceWtUHz66aZlJ1OC/N/AgBafHJP/j1
         +WU4ndAfymBuA==
Date:   Thu, 8 Jun 2023 18:21:13 +0100
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: Skip break phase when we have FEAT_BBM
 level 2
Message-ID: <20230608172112.GA1606@willie-the-truck>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-4-coltonlewis@google.com>
 <87sfb7octw.wl-maz@kernel.org>
 <ZH5VQMEoiHEITmF4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH5VQMEoiHEITmF4@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:36:00PM -0700, Oliver Upton wrote:
> On Sun, Jun 04, 2023 at 09:23:39AM +0100, Marc Zyngier wrote:
> > On Fri, 02 Jun 2023 18:01:47 +0100, Colton Lewis <coltonlewis@google.com> wrote:
> > > +static bool stage2_try_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu, kvm_pte_t new)
> > >  {
> > >  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > > 
> > > -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > > +	if (!stage2_has_bbm_level2())
> > > +		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > > +
> > > +	if (!stage2_try_set_pte(ctx, new))
> > > +		return false;
> > > +
> > > +	if (kvm_pte_table(ctx->old, ctx->level))
> > > +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > > +	else if (kvm_pte_valid(ctx->old) && !stage2_pte_perms_equal(ctx->old, new))
> > > +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, mmu, ctx->addr, ctx->level);
> > 
> > Why a non-shareable invalidation? Nothing in this code captures the
> > rationale for it. What if the permission change was a *restriction* of
> > the permission? It should absolutely be global, and not local.
> 
> IIRC, Colton was testing largely with permission relaxation, and had
> forward progress issues b.c. the stale TLB entry was never invalidated
> in response to a permission fault.

Would the series at:

https://lore.kernel.org/r/5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com

help with that?

Will
