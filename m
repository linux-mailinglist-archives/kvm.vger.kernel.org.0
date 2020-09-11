Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F8B265B13
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 10:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKIFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 04:05:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgIKIFi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 04:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599811536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5FVC6JBs5pEyCffka1qMbmQH5dlGqqvYYQ8DzdI2d6I=;
        b=O6mXhrzhK0zZGHDQHk2nYe0I6E7Tv0VUb3vKuDSBSAlsZ584ujwydFXGPoXfZ8Ufyap6gr
        2zEl6HbuKzrtyu32TANxU+klUl2MrR46WO0wFknkLz/WaG4qEQc+SPiK5dbddHZDkwsxpL
        gaJruvTepfZeN9rHa66lICd5lSy5uqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-IFxqhDBcMVGTXVj5Q8AcUw-1; Fri, 11 Sep 2020 04:05:32 -0400
X-MC-Unique: IFxqhDBcMVGTXVj5Q8AcUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAF8D10BBECE;
        Fri, 11 Sep 2020 08:05:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC4E97E8FB;
        Fri, 11 Sep 2020 08:05:24 +0000 (UTC)
Date:   Fri, 11 Sep 2020 10:05:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across
 reset
Message-ID: <20200911080521.nzqbe6o3dwvbkxvp@kamzik.brq.redhat.com>
References: <20200910164243.29253-1-graf@amazon.com>
 <20200910173609.niujn2ngnjzvx7ub@kamzik.brq.redhat.com>
 <2938f7ef-a723-2ee3-0a87-25cbde177d23@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2938f7ef-a723-2ee3-0a87-25cbde177d23@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 09:40:04AM +0200, Alexander Graf wrote:
> 
> 
> On 10.09.20 19:36, Andrew Jones wrote:
> > 
> > On Thu, Sep 10, 2020 at 06:42:43PM +0200, Alexander Graf wrote:
> > > We allow user space to set the PMCR register to any value. However,
> > > when time comes for a vcpu reset (for example on PSCI online), PMCR
> > > is reset to the hardware capabilities.
> > > 
> > > I would like to explicitly expose different PMU capabilities (number
> > > of supported event counters) to the guest than hardware supports.
> > > Ideally across vcpu resets.
> > > 
> > > So this patch adopts the reset path to only populate the immutable
> > > PMCR register bits from hardware when they were not initialized
> > > previously. This effectively means that on a normal reset, only the
> > > guest settable fields are reset, while on vcpu creation the register
> > > gets populated from hardware like before.
> > > 
> > > With this in place and a change in user space to invoke SET_ONE_REG
> > > on the PMCR for every vcpu, I can reliably set the PMU event counter
> > > number to arbitrary values.
> > > 
> > > Signed-off-by: Alexander Graf <graf@amazon.com>
> > > ---
> > >   arch/arm64/kvm/sys_regs.c | 9 ++++++++-
> > >   1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 20ab2a7d37ca..28f67550db7f 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > >   {
> > >        u64 pmcr, val;
> > > 
> > > -     pmcr = read_sysreg(pmcr_el0);
> > > +     /*
> > > +      * If we already received PMCR from a previous ONE_REG call,
> > > +      * maintain its immutable flags
> > > +      */
> > > +     pmcr = __vcpu_sys_reg(vcpu, r->reg);
> > > +     if (!__vcpu_sys_reg(vcpu, r->reg))
> > > +             pmcr = read_sysreg(pmcr_el0);
> > > +
> > >        /*
> > >         * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
> > >         * except PMCR.E resetting to zero.
> > > --
> > > 2.16.4
> > > 
> > 
> > Aha, a much simpler patch than I expected. With this approach we don't
> > need a get_user() function, or to use 'val', but don't we still want to
> > add sanity checks with a set_user() function? At least to ensure immutable
> > flags match and that PMCR_EL0.N isn't too big?
> 
> We don't check for any flags today, so in a way adding checks would be ABI
> breakage.
> 
> And as Marc pointed out, all of the counters are basically virtual through
> perf. So if you report 31 counters, you end up spawning 31 perf counters
> which get multiplexed, so it would work (albeit not be terribly accurate).
> 
> That leaves identification bits as something we can check for. But do we
> really have to? What's the worst thing that can happen? KVM user space can
> shoot themselves in the foot. Well, they can also set PC to an invalid
> value. If you do bad things you get bad results :). As long as it's not a
> security risk, I'm not sure the benefits of checking outweigh the risks.

That's a reasonable justification.

Thanks,
drew

> 
> > Silently changing the user's input, which I see we also do for e.g. MPIDR,
> > isn't super user friendly.
> 
> Yes :).
> 
> 
> Alex
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
> 

