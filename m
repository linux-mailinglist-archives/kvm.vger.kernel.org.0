Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BD39DB67
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 03:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfH0ByP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 21:54:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44028 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbfH0ByP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 21:54:15 -0400
Received: by mail-pg1-f194.google.com with SMTP id k3so11673717pgb.10
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 18:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vzn0oeIxhKURQAJjXmT1q9CBhvDkEjEIwdqYU1NIxq8=;
        b=HqUWM6HMhGyIcdyKNG5qgcEHvVptV9noooaLt3c3tg0COWTaQKGVRxH8+0QDsswwTZ
         Lp4/M4nzN/j0tOXtOjrhfHZit3dwihS4P5IQMewOfjuayw96zQT+OvZa6PDbB7Wu7uT+
         Zf28Qn3x/Hn1hgBJpD5EN9as8REwU8Dw7Fa4qAkYvRcFOmGhiqXNFXHKEOwrZeu2AfUk
         KAalq7t/voBkl3dRNyddguw288O5QJllX/jON3I0k4AhcAyiB4flKk6L26pZ1YyPY9MZ
         WXUicfmmNVANxABYvPd74pLJdUFWC6PcZJ1T7Fo1lpC26NYypFSQzMjeYDOqy/+Y23dB
         kYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vzn0oeIxhKURQAJjXmT1q9CBhvDkEjEIwdqYU1NIxq8=;
        b=AoD/v6Z7upLT98w5Fye0HCWOTl5D/qNw17JoPexSV7mlJ32d+jDt4vXGkJZImfJiOZ
         SOxCtnsMWDgT51dFOtCqNyGwSgThH3pwI+McA2IWt5TghGhc7zFSXxH4ALND70nQ9QI4
         18VzllAqMdZ3rPZgXXe4B8lU9zfv+OwILFmmYIPeGVqjLbn+MlT37bsNynsYvar0jhjW
         10DNIs20nN/5xYRfIyWDNupIProbtYi8MWgx4CoiPhgouWeT9Ofwv0fxedS9CrFU+oRW
         EVPfuiNwoFe7uDrfbBU9vwMM+PlHeBNaO31/YIiNeN/Wn/w7MNAIiCdN8P8sxO5z0lAC
         gftw==
X-Gm-Message-State: APjAAAUz4cWZG70kfYLFhTwCpoLSUbelwE5IPt691PjtU23n4ocUWmK9
        mjMsx2Lb9JJizwmQ+gF8JyLqB/1kgw0=
X-Google-Smtp-Source: APXvYqwdrhialGk/1+Sza8/5mAXKp3W6yGMa90H7aCGoa2hIHsDgMjCzDhMDoBMFXaxhb2fj0CXOtg==
X-Received: by 2002:a63:e948:: with SMTP id q8mr18469394pgj.93.1566870854301;
        Mon, 26 Aug 2019 18:54:14 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id k5sm646082pjs.1.2019.08.26.18.54.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 18:54:13 -0700 (PDT)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Don't lose pending doorbell request
 on migration on P9
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20190827013540.GC16075@blackberry>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <ea270027-58e6-b891-0873-8651202904c8@ozlabs.ru>
Date:   Tue, 27 Aug 2019 11:54:10 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827013540.GC16075@blackberry>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/08/2019 11:35, Paul Mackerras wrote:
> On POWER9, when userspace reads the value of the DPDES register on a
> vCPU, it is possible for 0 to be returned although there is a doorbell
> interrupt pending for the vCPU.  This can lead to a doorbell interrupt
> being lost across migration.  If the guest kernel uses doorbell
> interrupts for IPIs, then it could malfunction because of the lost
> interrupt.
> 
> This happens because a newly-generated doorbell interrupt is signalled
> by setting vcpu->arch.doorbell_request to 1; the DPDES value in
> vcpu->arch.vcore->dpdes is not updated, because it can only be updated
> when holding the vcpu mutex, in order to avoid races.
> 
> To fix this, we OR in vcpu->arch.doorbell_request when reading the
> DPDES value.
> 
> Cc: stable@vger.kernel.org # v4.13+
> Fixes: 579006944e0d ("KVM: PPC: Book3S HV: Virtualize doorbell facility on POWER9")
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>



Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> ---
>   arch/powerpc/kvm/book3s_hv.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index ca6c6ec..88c42e7 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1678,7 +1678,14 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
>   		*val = get_reg_val(id, vcpu->arch.pspb);
>   		break;
>   	case KVM_REG_PPC_DPDES:
> -		*val = get_reg_val(id, vcpu->arch.vcore->dpdes);
> +		/*
> +		 * On POWER9, where we are emulating msgsndp etc.,
> +		 * we return 1 bit for each vcpu, which can come from
> +		 * either vcore->dpdes or doorbell_request.
> +		 * On POWER8, doorbell_request is 0.
> +		 */
> +		*val = get_reg_val(id, vcpu->arch.vcore->dpdes |
> +				   vcpu->arch.doorbell_request);
>   		break;
>   	case KVM_REG_PPC_VTB:
>   		*val = get_reg_val(id, vcpu->arch.vcore->vtb);
> 

-- 
Alexey
