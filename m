Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8E585591
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 21:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiG2T2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiG2T2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 15:28:20 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA705C362
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 12:28:18 -0700 (PDT)
Date:   Fri, 29 Jul 2022 19:28:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659122895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hGAAQQims/x+aVkjeXh2pO3zuX49eGIs7h2PdGd4m9k=;
        b=rQXuzbUlhy1H2pl2MLh/fFzXumhLDJ1JmxPLp9XsRjxgk5EM2up8wOI94Wy6GEXKWBDCOu
        uqX9RQF/oULzk6hI2zFHjlgwyY+Yl6wrh35P6gVDjBNPYihBnycuHu99Gdw2aX1LmHSHiE
        Q6O8rTbFdMTQpb4uya6GSPgXVbjxsEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/24] KVM: arm64: Unify identifiers used to
 distinguish host and hypervisor
Message-ID: <YuQ0ypCVgfMjJOew@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-7-will@kernel.org>
 <YtgbCEOMze8N4TPW@google.com>
 <20220720181406.GA16603@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720181406.GA16603@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

Sorry, I didn't see your reply til now.

On Wed, Jul 20, 2022 at 07:14:07PM +0100, Will Deacon wrote:
> Hi Oliver,
> 
> Thanks for having a look.
> 
> On Wed, Jul 20, 2022 at 03:11:04PM +0000, Oliver Upton wrote:
> > On Thu, Jun 30, 2022 at 02:57:29PM +0100, Will Deacon wrote:
> > > The 'pkvm_component_id' enum type provides constants to refer to the
> > > host and the hypervisor, yet this information is duplicated by the
> > > 'pkvm_hyp_id' constant.
> > > 
> > > Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
> > > type definition to 'mem_protect.h' so that it can be used outside of
> > > the memory protection code.
> > > 
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
> > >  arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
> > >  3 files changed, 6 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > index 80e99836eac7..f5705a1e972f 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > @@ -51,7 +51,11 @@ struct host_kvm {
> > >  };
> > >  extern struct host_kvm host_kvm;
> > >  
> > > -extern const u8 pkvm_hyp_id;
> > > +/* This corresponds to page-table locking order */
> > > +enum pkvm_component_id {
> > > +	PKVM_ID_HOST,
> > > +	PKVM_ID_HYP,
> > > +};
> > 
> > Since we have the concept of PTE ownership in pgtable.c, WDYT about
> > moving the owner ID enumeration there? KVM_MAX_OWNER_ID should be
> > incorporated in the enum too.
> 
> Interesting idea... I think we need the definition in a header file so that
> it can be used by mem_protect.c, so I'm not entirely sure where you'd like
> to see it moved.
> 
> The main worry I have is that if we ever need to distinguish e.g. one guest
> instance from another, which is likely needed for sharing of memory
> between more than just two components, then the pgtable code really cares
> about the number of instances ("which guest is it?") whilst the mem_protect
> cares about the component type ("is it a guest?").
> 
> Finally, the pgtable code is also used outside of pKVM so, although the
> concept of ownership doesn't yet apply elsewhere, keeping the concept
> available without dictacting the different types of owners makes sense to
> me.

Sorry, it was a silly suggestion to wedge the enum there. I don't think
it matters too much where it winds up, but something like:

  enum kvm_pgtable_owner_id {
  	OWNER_ID_PKVM_HOST,
	OWNER_ID_PKVM_HYP,
	NR_PGTABLE_OWNER_IDS,
  }

And put it somewhere that both pgtable.c and mem_protect.c can get at
it. That way bound checks (like in kvm_pgtable_stage2_set_owner())
organically work as new IDs are added.

--
Thanks,
Oliver
