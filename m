Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B2604540
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiJSM2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 08:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJSM1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 08:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2631A83B
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C40060E89
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C0C433C1;
        Wed, 19 Oct 2022 12:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666180880;
        bh=+YxEMHGjFNX/fMgJ7XtobqHhQhBy4sl/qF3hgM/FXHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJMUZVgcE81dR7vcUZH2grOThP6TRaOGmIq1CjMDNsQ0bfvbJFRfQLUlz8w9xX89B
         cLFOiVNw7fbZEqPhDa5KCEXrFq39MMbEPF20zxjgUIb0tsHthvYNK2Fv3/FWrae0zt
         ar2m07Woki4kuX1ErljedL+e6Z9vkPQEOTAjzPkzgFLaUXAhWxaaxLcxYwgkcIQ1fM
         fhSXKkXa1apkhqzaa2qwrYi7z/z/xXrIQOR5KTdiP2+0L2bVW1muNiJjiVSI1slQIH
         rKfbIZnpZ1xxYuevjHVu74Pzevjda7/xW2eU5r7biBwDez9VuKUJUCo+jYQUTJ+W6W
         cYeRV7R56EgKA==
Date:   Wed, 19 Oct 2022 13:01:13 +0100
From:   Will Deacon <will@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 14/25] KVM: arm64: Add per-cpu fixmap infrastructure
 at EL2
Message-ID: <20221019120110.GB4067@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-15-will@kernel.org>
 <Y06Iihi/RPAOMuwR@FVFF77S0Q05N>
 <20221018140514.GA3323@willie-the-truck>
 <Y07Zwsn+oFbMWeKI@lakrids>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07Zwsn+oFbMWeKI@lakrids>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 05:52:18PM +0100, Mark Rutland wrote:
> On Tue, Oct 18, 2022 at 03:05:14PM +0100, Will Deacon wrote:
> > On Tue, Oct 18, 2022 at 12:06:14PM +0100, Mark Rutland wrote:
> > > If the tables are shared, you need broadcast maintenance and ISH barriers here,
> > > or you risk the usual issues with asynchronous MMU behaviour.
> > 
> > Can you elaborate a bit, please? What we're trying to do is reserve a page
> > of VA space for each CPU, which is only ever accessed explicitly by that
> > CPU using a normal memory mapping. The fixmap code therefore just updates
> > the relevant leaf entry for the CPU on which we're running and the TLBI
> > is there to ensure that the new mapping takes effect.
> > 
> > If another CPU speculatively walks another CPU's fixmap slot, then I agree
> > that it could access that page after the slot had been cleared. Although
> > I can see theoretical security arguments around avoiding that situation,
> > there's a very real performance cost to broadcast invalidation that we
> > were hoping to avoid on this fast path.
> 
> The issue is that any CPU could walk any of these entries at any time
> for any reason, and without broadcast maintenance we'd be violating the
> Break-Before-Make requirements. That permits a number of things,
> including "amalgamation", which would permit the CPU to consume some
> arbitrary function of the old+new entries. Among other things, that can
> permit accesses to entirely bogus physical addresses that weren't in
> either entry (e.g. making speculative accesses to arbitrary device
> addresses).
> 
> For correctness, you need the maintenance to be broadcast to all PEs
> which could observe the old and new entries.

Urgh, I had definitely purged that one. Thanks for the refresher.

> > Of course, in the likely event that I've purged "the usual issues" from
> > my head and we need broadcasting for _correctness_, then we'll just have
> > to suck it up!
> 
> As above, I believe you need this for correctness.
> 
> I'm not sure if FEAT_BBM level 2 gives you the necessary properties to
> relax this on some HW.

I'll seek clarification on this, as that amalgamation text feels a bit
over-reaching to me (particularly when combined with the fact that the
CPU still has to respect things like the NS bit) and I suspect that we
wouldn't see it in practice for this case.

But for now, I'll add the broadcasting so we don't block the series.

Will
