Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A218B153332
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgBEOjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:39:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55502 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgBEOjO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:39:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580913553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SoydEapPcnWnsyykjUkOlfTYQqJiOhpLPIh1rU1g+ZM=;
        b=THWJtdULO7acwRNjSzQVMxx+dCL+MvgXrTZ4YyyzmKosCrnlocFn5Ldi6TzekU/9kY6YOA
        B+Kavzs9FJ48SlseFLMZa2vYwUFFpvb0Q/OBpn4jlhYFh1F9iHS+YwLRcjFkOQ1TPrOHk5
        TUdFL0rgDX/rHgOIiZCn1AWS+phZwR4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-rqAzj5MXNa-tta_AXUKQ_Q-1; Wed, 05 Feb 2020 09:39:11 -0500
X-MC-Unique: rqAzj5MXNa-tta_AXUKQ_Q-1
Received: by mail-wr1-f72.google.com with SMTP id v17so1264350wrm.17
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:39:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SoydEapPcnWnsyykjUkOlfTYQqJiOhpLPIh1rU1g+ZM=;
        b=lTZOWSRlKUTGyIE/DExriFQ4v4P7r5OhIB2Ib3BsrlkQDRmhtC3eTdmqCq4LQeH2VZ
         ZpeCJkahBHans0+kDgjGfLns7CQJEuTf2q0o9P4OZVwxWY/ZTs8XyLTH6byrOE53sy2b
         OxhRA0/CW+yVUiirKIt9NsyU4rM8H6cLrjehWHxTvxwppxc9SqexG7XRKpe/WlNCJHso
         GM/ya7FYJH9Y6FLrTc+DR/IFkug8DIwSiWYra4sUABDScJJC0hsZehh/EQgr0HVilcqn
         VvadmXfbyJe+67lqYmcORcF7pEB5NU7SVeHZBbo9/lSaNzGJMsmlvHFW6Zlsfk3XfYtl
         rIMw==
X-Gm-Message-State: APjAAAU7p4R+7HnS9LTEhGDa04N1FSNfksLqfzBs5JgjbbzhKK0VjMVj
        XatR2OxXhAZE/eYU7J/JQkTGd1BDA5d+u3FG0rK45Hx4N4KKOf8oquCi2Q7XeRIzfZDlFjm0KWj
        97INY4AdKxwNb
X-Received: by 2002:a7b:c759:: with SMTP id w25mr6027146wmk.15.1580913550657;
        Wed, 05 Feb 2020 06:39:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZ2+MUSKIq0bFGeGsEl8yDAXhtSQNMDtk5nz9iHlEYoHTTiNkrjIeGzfVkfAlpNl/KZdLkuQ==
X-Received: by 2002:a7b:c759:: with SMTP id w25mr6027129wmk.15.1580913550452;
        Wed, 05 Feb 2020 06:39:10 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k13sm21684wrx.59.2020.02.05.06.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 06:39:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 05/26] KVM: x86: Move MSR_TSC_AUX existence checks into vendor code
In-Reply-To: <20200129234640.8147-6-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-6-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 15:39:08 +0100
Message-ID: <87blqdksj7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the MSR_TSC_AUX existence check into vendor code using the newly
> introduced ->has_virtualized_msr() hook to help pave the way toward the
> removal of ->rdtscp_supported().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c     | 7 +++++++
>  arch/x86/kvm/vmx/vmx.c | 7 +++++++
>  arch/x86/kvm/x86.c     | 4 ----
>  3 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f9323fbad81..4c8427f57b71 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5987,6 +5987,13 @@ static bool svm_cpu_has_accelerated_tpr(void)
>  
>  static bool svm_has_virtualized_msr(u32 index)
>  {
> +	switch (index) {
> +	case MSR_TSC_AUX:
> +		return boot_cpu_has(X86_FEATURE_RDTSCP);
> +	default:
> +		break;
> +	}
> +
>  	return true;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3f2c094434e8..9588914e941e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6276,6 +6276,13 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
>  
>  static bool vmx_has_virtualized_msr(u32 index)
>  {
> +	switch (index) {
> +	case MSR_TSC_AUX:
> +		return cpu_has_vmx_rdtscp();
> +	default:
> +		break;
> +	}
> +
>  	return true;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 94f90fe1c0de..a8619c52ea86 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5241,10 +5241,6 @@ static void kvm_init_msr_list(void)
>  			if (!kvm_mpx_supported())
>  				continue;
>  			break;
> -		case MSR_TSC_AUX:
> -			if (!kvm_x86_ops->rdtscp_supported())
> -				continue;
> -			break;
>  		case MSR_IA32_RTIT_CTL:
>  		case MSR_IA32_RTIT_STATUS:
>  			if (!kvm_x86_ops->pt_supported())

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

