Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0126F58F185
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiHJRXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiHJRXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:23:42 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413DA7C776
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:23:40 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660152218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=63Gw+QB8vRS1+zYg8ibY6LGRmceSmZAbiOInDTS2pJo=;
        b=fLhuFpjBq/Aj72N9srr+JxCLmQlfAhvoommxDwsCiGyQrcjEv9sa2/IhNJgqnPYWGHscaE
        FHEgBi+DNTT1zkIzBtMIsAQpaFewHMbypa5ScBM6ExQRlkgsnPw81EvyA55+AKbzY/TG0G
        5TkHmoZ+EVJ4AnDHcqMiQvL0FlYv5VU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kernel-team@android.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/9] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Message-ID: <YvPplp8qRpWpzL3o@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-5-maz@kernel.org>
 <YvNboA7nla0NcKwa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvNboA7nla0NcKwa@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 02:17:52AM -0500, Oliver Upton wrote:
> On Fri, Aug 05, 2022 at 02:58:08PM +0100, Marc Zyngier wrote:
> > In order to reduce the boilerplate code, add two helpers returning
> > the counter register index (resp. the event register) in the vcpu
> > register file from the counter index.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 27 +++++++++++++++------------
> >  1 file changed, 15 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 0ab6f59f433c..9be485d23416 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -75,6 +75,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> >  	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> >  }
> >  
> > +static u32 counter_index_to_reg(u64 idx)
> > +{
> > +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> > +}
> > +
> > +static u32 counter_index_to_evtreg(u64 idx)
> > +{
> > +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> > +}
> > +

After reading the series, do you think these helpers could be applied to
kvm_pmu_counter_increment() as well?

--
Thanks,
Oliver
