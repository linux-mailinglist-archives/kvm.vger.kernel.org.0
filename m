Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FD4230AB9
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgG1M4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 08:56:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729334AbgG1M4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 08:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595940968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5V0t0GXMya6+gO7R5IUe7YZ/97/s6ZAsI0sAaujI+I=;
        b=Y0BSe/3SYT4qYNvipbHyAPiamuP3uz0V3HtwGCoMuTsAZyptxbXFTWinO/6c90OyfeoHWc
        cTHgD/CAuDh1KCuq9a6e4MmAC8+QmCFpLpekzk5mp5rkqxZO2K2IUeHqrDE0/xsKqDg4ph
        JiD3KH9SV523x/pUbUFFo0HepogjqkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-dHA4XqSMMsC-o1tUNrqHBw-1; Tue, 28 Jul 2020 08:56:05 -0400
X-MC-Unique: dHA4XqSMMsC-o1tUNrqHBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86ACBA3485F;
        Tue, 28 Jul 2020 12:56:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA8C8612AB;
        Tue, 28 Jul 2020 12:55:58 +0000 (UTC)
Date:   Tue, 28 Jul 2020 14:55:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported
 when configured
Message-ID: <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
 <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 06:25:50PM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-07-11 11:04, Andrew Jones wrote:
> > Don't confuse the guest by saying steal-time is supported when
> > it hasn't been configured by userspace and won't work.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm64/kvm/pvtime.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> > index f7b52ce1557e..2b22214909be 100644
> > --- a/arch/arm64/kvm/pvtime.c
> > +++ b/arch/arm64/kvm/pvtime.c
> > @@ -42,9 +42,12 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
> > 
> >  	switch (feature) {
> >  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> > -	case ARM_SMCCC_HV_PV_TIME_ST:
> >  		val = SMCCC_RET_SUCCESS;
> >  		break;
> > +	case ARM_SMCCC_HV_PV_TIME_ST:
> > +		if (vcpu->arch.steal.base != GPA_INVALID)
> > +			val = SMCCC_RET_SUCCESS;
> > +		break;
> >  	}
> > 
> >  	return val;
> 
> I'm not so sure about this. I have always considered the
> discovery interface to be "do you know about this SMCCC
> function". And if you look at the spec, it says (4.2,
> PV_TIME_FEATURES):
> 
> <quote>
> If PV_call_id identifies PV_TIME_FEATURES, this call returns:
> • NOT_SUPPORTED (-1) to indicate that all
> paravirtualized time functions in this specification are not
> supported.
> • SUCCESS (0) to indicate that all the paravirtualized time
> functions in this specification are supported.
> </quote>
> 
> So the way I understand it, you cannot return "supported"
> for PV_TIME_FEATURES, and yet return NOT_SUPPORTED for
> PV_TIME_ST. It applies to *all* features.
> 
> Yes, this is very bizarre. But I don't think we can deviate
> from it.

Ah, I see your point. But I wonder if we should drop this patch
or if we should change the return of ARM_SMCCC_HV_PV_TIME_FEATURES
to be dependant on all the pv calls?

Discovery would look like this

IF (SMCCC_ARCH_FEATURES, PV_TIME_FEATURES) == 0; THEN
  IF (PV_TIME_FEATURES, PV_TIME_FEATURES) == 0; THEN
    PV_TIME_ST is supported, as well as all other PV calls
  ELIF (PV_TIME_FEATURES, PV_TIME_ST) == 0; THEN
    PV_TIME_ST is supported
  ELIF (PV_TIME_FEATURES, <another-pv-call>) == 0; THEN
    <another-pv-call> is supported
  ...
  ENDIF
ELSE
  No PV calls are supported
ENDIF

I believe the above implements a reasonable interpretation of the
specification, but the all feature (PV_TIME_FEATURES, PV_TIME_FEATURES)
thing is indeed bizarre no matter how you look at it.

Thanks,
drew

