Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B13230B32
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 15:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgG1NN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 09:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbgG1NN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 09:13:57 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B95206D4;
        Tue, 28 Jul 2020 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595942036;
        bh=+uFhf2g9FNicnPqh1uSvAdwl71+frJOQtcY4UF0hIUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IsEw8Oui0Zre8d8keY1EFRlqWEfMehhUzMcSQ1MFq6CZ1Tf4wk2Kxhdpmk1QoUEHS
         mEtPp5Ck7NoKyNfNMtfXQu3z1i+5nucGGdLfzum25kmu+gtMFfjT0OJC5NaufyH331
         Gxb6j38at+xhywhsMCY71go95sCOajjYIAL7eaco=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k0PQZ-00Ff63-1K; Tue, 28 Jul 2020 14:13:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 28 Jul 2020 14:13:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported when
 configured
In-Reply-To: <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
 <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
 <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <ef8a19e07a2735d0d684ef54f8600d66@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-28 13:55, Andrew Jones wrote:
> On Mon, Jul 27, 2020 at 06:25:50PM +0100, Marc Zyngier wrote:
>> Hi Andrew,
>> 
>> On 2020-07-11 11:04, Andrew Jones wrote:
>> > Don't confuse the guest by saying steal-time is supported when
>> > it hasn't been configured by userspace and won't work.
>> >
>> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > ---
>> >  arch/arm64/kvm/pvtime.c | 5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
>> > index f7b52ce1557e..2b22214909be 100644
>> > --- a/arch/arm64/kvm/pvtime.c
>> > +++ b/arch/arm64/kvm/pvtime.c
>> > @@ -42,9 +42,12 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>> >
>> >  	switch (feature) {
>> >  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
>> > -	case ARM_SMCCC_HV_PV_TIME_ST:
>> >  		val = SMCCC_RET_SUCCESS;
>> >  		break;
>> > +	case ARM_SMCCC_HV_PV_TIME_ST:
>> > +		if (vcpu->arch.steal.base != GPA_INVALID)
>> > +			val = SMCCC_RET_SUCCESS;
>> > +		break;
>> >  	}
>> >
>> >  	return val;
>> 
>> I'm not so sure about this. I have always considered the
>> discovery interface to be "do you know about this SMCCC
>> function". And if you look at the spec, it says (4.2,
>> PV_TIME_FEATURES):
>> 
>> <quote>
>> If PV_call_id identifies PV_TIME_FEATURES, this call returns:
>> • NOT_SUPPORTED (-1) to indicate that all
>> paravirtualized time functions in this specification are not
>> supported.
>> • SUCCESS (0) to indicate that all the paravirtualized time
>> functions in this specification are supported.
>> </quote>
>> 
>> So the way I understand it, you cannot return "supported"
>> for PV_TIME_FEATURES, and yet return NOT_SUPPORTED for
>> PV_TIME_ST. It applies to *all* features.
>> 
>> Yes, this is very bizarre. But I don't think we can deviate
>> from it.
> 
> Ah, I see your point. But I wonder if we should drop this patch
> or if we should change the return of ARM_SMCCC_HV_PV_TIME_FEATURES
> to be dependant on all the pv calls?
> 
> Discovery would look like this
> 
> IF (SMCCC_ARCH_FEATURES, PV_TIME_FEATURES) == 0; THEN
>   IF (PV_TIME_FEATURES, PV_TIME_FEATURES) == 0; THEN
>     PV_TIME_ST is supported, as well as all other PV calls
>   ELIF (PV_TIME_FEATURES, PV_TIME_ST) == 0; THEN
>     PV_TIME_ST is supported
>   ELIF (PV_TIME_FEATURES, <another-pv-call>) == 0; THEN
>     <another-pv-call> is supported
>   ...
>   ENDIF
> ELSE
>   No PV calls are supported
> ENDIF
> 
> I believe the above implements a reasonable interpretation of the
> specification, but the all feature (PV_TIME_FEATURES, PV_TIME_FEATURES)
> thing is indeed bizarre no matter how you look at it.

It it indeed true to the spec. Thankfully we only support PV_TIME
as a feature for now, so we are (sort of) immune to the braindead
aspect of the discovery protocol.

I think returning a failure when PV_TIME isn't setup is a valid thing
to do, as long as it applies to all functions (i.e. something like
the below patch).

Thanks,

         M.

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index f7b52ce1557e..c3ef4ebd6846 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -43,7 +43,8 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
  	switch (feature) {
  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
  	case ARM_SMCCC_HV_PV_TIME_ST:
-		val = SMCCC_RET_SUCCESS;
+		if (vcpu->arch.steal.base != GPA_INVALID)
+			val = SMCCC_RET_SUCCESS;
  		break;
  	}


-- 
Jazz is not dead. It just smells funny...
