Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3652C5739
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 15:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390463AbgKZOgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 09:36:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389558AbgKZOgo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 09:36:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606401403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NrB+lMSLj+Fdrrp2wJGqC8XL5+BZOKP4iK+YINRbCi0=;
        b=NphEbx+fBGUiVCVKgHn4mPBucEferDjOZIo6apwHJCJvHtcBAFQaPc/sYHxxdrZlN2+EAC
        3z0xJd7TcgXcDkIsEwfylS7+vBbHBbqA4WugUHD6g+s+qsiCEtgr21DRuWbz616on07/7A
        CkrJzoA8Z8Dc7YCIKfkltLOIhZR2fjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-8DsSDpbjNMCvhHgfLNBmTw-1; Thu, 26 Nov 2020 09:36:40 -0500
X-MC-Unique: 8DsSDpbjNMCvhHgfLNBmTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C38341005E61;
        Thu, 26 Nov 2020 14:36:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 525845D6AC;
        Thu, 26 Nov 2020 14:36:38 +0000 (UTC)
Date:   Thu, 26 Nov 2020 15:36:35 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [PATCH 1/2] KVM: arm64: CSSELR_EL1 max is 13
Message-ID: <20201126143635.hsp6l74fon62p47t@kamzik.brq.redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
 <20201126134641.35231-2-drjones@redhat.com>
 <163d00024402dbb518a6f8d669579bfa@kernel.org>
 <20201126143200.eezs474ks3xdlnsl@kamzik.brq.redhat.com>
 <5106d82b42174b86dd62bc9637b2b6a4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5106d82b42174b86dd62bc9637b2b6a4@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 26, 2020 at 02:34:05PM +0000, Marc Zyngier wrote:
> On 2020-11-26 14:32, Andrew Jones wrote:
> > On Thu, Nov 26, 2020 at 02:13:44PM +0000, Marc Zyngier wrote:
> > > On 2020-11-26 13:46, Andrew Jones wrote:
> > > > Not counting TnD, which KVM doesn't currently consider, CSSELR_EL1
> > > > can have a maximum value of 0b1101 (13), which corresponds to an
> > > > instruction cache at level 7. With CSSELR_MAX set to 12 we can
> > > > only select up to cache level 6. Change it to 14.
> > > >
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > ---
> > > >  arch/arm64/kvm/sys_regs.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index c1fac9836af1..ef453f7827fa 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -169,7 +169,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64
> > > > val, int reg)
> > > >  static u32 cache_levels;
> > > >
> > > >  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
> > > > -#define CSSELR_MAX 12
> > > > +#define CSSELR_MAX 14
> > > >
> > > >  /* Which cache CCSIDR represents depends on CSSELR value. */
> > > >  static u32 get_ccsidr(u32 csselr)
> > > 
> > > Huh, nice catch. Do we need a CC: stable tag for this?
> > > 
> > 
> > Hi Marc,
> > 
> > I wasn't thinking so, because I'm not expecting there to actually
> > be hardware with seven cache levels in the wild any time soon. You
> > have more knowledge about what's out there and coming, though, so
> > feel free CC stable if needed.
> 
> That's actually what I was wondering, whether you had seen that in the
> wild already. Since you haven't (and I'm not aware of such a monstrosity),
> I'll queue it for 5.11.
> 
> Do you want me to take the selftest stuff at the same time?
>

Yes, please :)

Thanks,
drew 

