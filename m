Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B5E1E65E8
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 17:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404371AbgE1PXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 11:23:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404364AbgE1PXF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 11:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590679383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuC/L4LcDUQosJwmTOJaBouUsy+HI9M3EMosoVjkVI8=;
        b=gksvw/FEIzdKF4ao8tkRcpUK54atbT553rXIlaSAZMzZQHTPOsG5abPALzyKiFpPf0qeyS
        uCzJ+eewaoKskRbgOK3Gk4X06TT8s+fKpiTqp6R8fOAVnJxt24zyV/pxQYVZgPj7CaqjRb
        FHuLp+0Y4y345vc5A/n4bLbMhPmt+j0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-lOM0Yk3vP3e63KHpzSdbMA-1; Thu, 28 May 2020 11:22:59 -0400
X-MC-Unique: lOM0Yk3vP3e63KHpzSdbMA-1
Received: by mail-wm1-f72.google.com with SMTP id t145so79518wmt.2
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 08:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZuC/L4LcDUQosJwmTOJaBouUsy+HI9M3EMosoVjkVI8=;
        b=tjMmd8ZcMqq9cjd9W5ZG26UW+QFr5nfX6NE4xQbDuyMEit4zYZJEZqVmj1K4bON4vA
         S4yEmpz7DjD7zdpTRVmubgduAR/DguMubztpYDfxIk0s3QIsnmb81tpjByjdhvjwIvje
         AgRtjv21esht58mBn3QQi01eCIsphTpEkaRHIOGOAAERXspgarybZspZmt9OS6BCAMRs
         b01Oxl1MgH+1dnlqjeVhIBrSemOn8OknM+kfpsSNjVXraFU5VFoum8Aflx0jl/TmbvV2
         wAbVk4P+hiNkt1dDy5Y4UyUdfundALBt6yu8z5JfXZYD4m/MYN/F+Rbtg0mJxIA7t/Y7
         YX8g==
X-Gm-Message-State: AOAM533L1/OSXN4SbybxA1v38bFF29HaK1vjL/f5+IcC29ghArTP14dR
        VAYI7Q4Hpc5mE+8LI/Umt8PntQEyFlNYXRCKS9mc5NHoDdEQOf3EWfpEtCo0ItSDSpQExYOFcoA
        oN2Uw47OsC8CA
X-Received: by 2002:a7b:cc06:: with SMTP id f6mr3841203wmh.119.1590679378714;
        Thu, 28 May 2020 08:22:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTmSSMQgVYva8gWo2WxK+oGBmB8n1AVJ05WziwKhiiGjicjbvjOqXX3JnAd8Eg83WQtxqINA==
X-Received: by 2002:a7b:cc06:: with SMTP id f6mr3841178wmh.119.1590679378459;
        Thu, 28 May 2020 08:22:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id o10sm3583419wrj.37.2020.05.28.08.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 08:22:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Call kvm_x86_ops.cpuid_update() after CPUIDs
 fully updated
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200528151927.14346-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b639a333-d7fe-74fd-ee11-6daede184676@redhat.com>
Date:   Thu, 28 May 2020 17:22:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528151927.14346-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 17:19, Xiaoyao Li wrote:
> kvm_x86_ops.cpuid_update() is used to update vmx/svm settings based on
> updated CPUID settings. So it's supposed to be called after CPUIDs are
> fully updated, not in the middle stage.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Are you seeing anything bad happening from this?

Paolo

> ---
>  arch/x86/kvm/cpuid.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index cd708b0b460a..753739bc1bf0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -208,8 +208,11 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  	vcpu->arch.cpuid_nent = cpuid->nent;
>  	cpuid_fix_nx_cap(vcpu);
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops.cpuid_update(vcpu);
>  	r = kvm_update_cpuid(vcpu);
> +	if (r)
> +		goto out;
> +
> +	kvm_x86_ops.cpuid_update(vcpu);
>  
>  out:
>  	vfree(cpuid_entries);
> @@ -231,8 +234,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  		goto out;
>  	vcpu->arch.cpuid_nent = cpuid->nent;
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops.cpuid_update(vcpu);
>  	r = kvm_update_cpuid(vcpu);
> +	if (r)
> +		goto out;
> +
> +	kvm_x86_ops.cpuid_update(vcpu);
>  out:
>  	return r;
>  }
> 

