Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36282A845B
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKERCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:02:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgKERCD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 12:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604595722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmUrszs7ygYBk7Uq1aFt2Z2enFg107wO2Q0GI3rq5Cc=;
        b=EgVyxghpmH45CycWl8GKpx+MNbdb0P2jkbgHCUaGoExlkWTqE6V33i5UkCkmgvO4FW3TiH
        XlAu/hB3lzKBvltzN8Yd0AQ8E0FWlQcfUP7dS7ZfEhfhVcLJIOp4dXjfwxCPfnQPWt6UuE
        kOQal0S0pm2BqFtd87N/SvWc1tMT+XY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-b29krx6zNweYtWGaALDh6g-1; Thu, 05 Nov 2020 12:01:59 -0500
X-MC-Unique: b29krx6zNweYtWGaALDh6g-1
Received: by mail-wm1-f70.google.com with SMTP id l16so599876wmh.1
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 09:01:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FmUrszs7ygYBk7Uq1aFt2Z2enFg107wO2Q0GI3rq5Cc=;
        b=J2csbJuZoehm7ihhlVBBWeT5tGcPcizjkMXnjOYyZpSLyHDcm1rOejevJB3+guYinZ
         IA8FIXvVFIUstWF4Zq1thgQEsk5EGztDnbk0/QS4EB8L5IRAsfAnDuSk0vnz60hyiRU/
         xDz4KSDi7zz0x2Nqb9TVgiYIb3ksBBTEXv10m/ZLx9P7C0mDV/57HQny1vrwWmhIxyXO
         9WC9lb43AFpkpN3O3KncJ+a29B9sa+IEqD76CX5fD/KgmCRBUDcDQaguM1/8gV7ruETc
         ZvEXiGpZRf2S9xOePngDr2g2cdxS5k4MY8NamXmhZlL0pw1Lfvf2TuoFTDj3buvp3MMH
         i+8g==
X-Gm-Message-State: AOAM532fRSjZmggU/H6aLrbac/bDi+KnMAZh8Y+Hxu480M7T8O+XrK9z
        2j0/GbF6gPEKXNTSAHCPQ6VjzOPbEESrphPOfsiy5sWIuNmTNwmiHzcp4kORJc/g9T54Rccr+xa
        4P+Hnms4QLvR0
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr3790609wmo.143.1604595718261;
        Thu, 05 Nov 2020 09:01:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPcJwqCfKQgzKk0PBctjnEsOB1L9CyVIjT2oZcLsGS9/33+509jnrZ1dGCachNTKYUFhkdpA==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr3790576wmo.143.1604595718053;
        Thu, 05 Nov 2020 09:01:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u5sm3117988wml.13.2020.11.05.09.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 09:01:57 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: handle MSR_IA32_DEBUGCTLMSR with
 report_ignored_msrs
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        oro@8bytes.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
References: <20201105153932.24316-1-pankaj.gupta.linux@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <36be2860-9ef9-db0f-ad8b-1089bd258dbc@redhat.com>
Date:   Thu, 5 Nov 2020 18:01:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201105153932.24316-1-pankaj.gupta.linux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/20 16:39, Pankaj Gupta wrote:
> From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> 
>   Guest tries to enable LBR (last branch/interrupt/exception) repeatedly,
>   thus spamming the host kernel logs. As MSR_IA32_DEBUGCTLMSR is not emulated by
>   KVM, its better to add the error log only with "report_ignored_msrs".
>   
> Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> ---
>   arch/x86/kvm/x86.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f5ede41bf9e6..99c69ae43c69 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3063,9 +3063,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			/* Values other than LBR and BTF are vendor-specific,
>   			   thus reserved and should throw a #GP */
>   			return 1;
> -		}
> -		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
> -			    __func__, data);
> +		} else if (report_ignored_msrs)
> +			vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
> +				    __func__, data);
>   		break;
>   	case 0x200 ... 0x2ff:
>   		return kvm_mtrr_set_msr(vcpu, msr, data);
> 

Which guest it is?  (Patch queued, but I'd like to have a better 
description).

Paolo

