Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF43622F68F
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgG0RZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbgG0RZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:25:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68F120714;
        Mon, 27 Jul 2020 17:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595870752;
        bh=vvXv3MqStMqM3NJh9jNTJpPY13GTNJPkpotn8K9FhpE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IP1gtyvvlK0+39RXufLMg06D6Mr2c4oupeOaksv4EiPfYKokBVfaFqw0kUMQWw56U
         +6sRjM1XbMUQaROfF+kju2j7zhv8IiXnuQqZLT+0PRUprsHSdEUnvCWSpmNNcx82uA
         YcgeonMt4LoEnwkzP4fF6xhV7hkzU9vk1IwHEcys=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k06sp-00FNbL-02; Mon, 27 Jul 2020 18:25:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 27 Jul 2020 18:25:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported when
 configured
In-Reply-To: <20200711100434.46660-2-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2020-07-11 11:04, Andrew Jones wrote:
> Don't confuse the guest by saying steal-time is supported when
> it hasn't been configured by userspace and won't work.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/pvtime.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index f7b52ce1557e..2b22214909be 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -42,9 +42,12 @@ long kvm_hypercall_pv_features(struct kvm_vcpu 
> *vcpu)
> 
>  	switch (feature) {
>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -	case ARM_SMCCC_HV_PV_TIME_ST:
>  		val = SMCCC_RET_SUCCESS;
>  		break;
> +	case ARM_SMCCC_HV_PV_TIME_ST:
> +		if (vcpu->arch.steal.base != GPA_INVALID)
> +			val = SMCCC_RET_SUCCESS;
> +		break;
>  	}
> 
>  	return val;

I'm not so sure about this. I have always considered the
discovery interface to be "do you know about this SMCCC
function". And if you look at the spec, it says (4.2,
PV_TIME_FEATURES):

<quote>
If PV_call_id identifies PV_TIME_FEATURES, this call returns:
• NOT_SUPPORTED (-1) to indicate that all
paravirtualized time functions in this specification are not
supported.
• SUCCESS (0) to indicate that all the paravirtualized time
functions in this specification are supported.
</quote>

So the way I understand it, you cannot return "supported"
for PV_TIME_FEATURES, and yet return NOT_SUPPORTED for
PV_TIME_ST. It applies to *all* features.

Yes, this is very bizarre. But I don't think we can deviate
from it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
