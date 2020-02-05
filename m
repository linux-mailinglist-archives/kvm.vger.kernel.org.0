Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540A6153368
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBEOxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:53:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726334AbgBEOxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580914434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MNWZsAt0GakYeHHsh62uWNt42TPtqTAAamgIIzZgO4=;
        b=L+Xd/i8I5yQhw1ZXsTy2U9OZ2lrHjYvWLC3PcgqNaWzQRAu05g228CbMWOoUOKr0Qw4TfU
        +GuDYZFNoILl89yk1SBymgGuHi3VyJmUawShZgcRYlQ86d3zg3J7CuMW4rJ3xLEfR74dyl
        Zro4YSJZp2lbJBSjkfIzG+fSZ/HQQYk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-MrjKYCIvMSuViY6ikYzhJQ-1; Wed, 05 Feb 2020 09:53:52 -0500
X-MC-Unique: MrjKYCIvMSuViY6ikYzhJQ-1
Received: by mail-wm1-f72.google.com with SMTP id u11so1102146wmb.4
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/MNWZsAt0GakYeHHsh62uWNt42TPtqTAAamgIIzZgO4=;
        b=m5NC6YlEJV3Z99/Xh4nVl1xaXIFyiSxiT3EyUllkJBdb1xcdRHZ9t8qvzq1a4p0vNI
         hD4bbUm1aUlPzK4YVx6h7PwmPZvyyNDuPJcrt2nyO4c731znMmmi4HNMLz4JYJOF6kzH
         cNV71vPBeOXYjv9cIRzozvyOXOM7DGOH7G1SzDnDG1pyXnD2XfmAaSv+Ym9OMmxZ0jLQ
         Wqf/AWdAC6UjQ1DYtR0bvJ4vkaxDhxenkPm2o4paPzzSjZ3idnQPEak66EEev1bNriEd
         qSg0QHVAb2VfJIqs9MtDqy0jMAEjvQwWji70qlQ/7P48JlEzXsSmsk/6BZlIN9M6j0Rs
         nZ/w==
X-Gm-Message-State: APjAAAXx+mpjcgFbdD/FdgTL0Dem14bUi7sai+lblyeijU4h4qkOoEic
        o9ngua9J/qzWBn304dn/PaOI0EXhmdaqdYMI8AEjn/ECnsYQAhneX8m7ieE5o+iXS5aq2jpTZsQ
        UTy0Oi4DZ60sJ
X-Received: by 2002:a1c:8055:: with SMTP id b82mr6336222wmd.127.1580914426503;
        Wed, 05 Feb 2020 06:53:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhZKTW1RLaMrrkjkmXabRUb8UDiYlj7WTwbn0+/m2H2anJq6Rbw1Sd2Y0z5J7gS8UI/cyr8Q==
X-Received: by 2002:a1c:8055:: with SMTP id b82mr6336207wmd.127.1580914426221;
        Wed, 05 Feb 2020 06:53:46 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm9302750wmh.3.2020.02.05.06.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 06:53:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/26] KVM: x86: Move MSR_IA32_BNDCFGS existence checks into vendor code
In-Reply-To: <20200129234640.8147-7-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-7-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 15:53:45 +0100
Message-ID: <878slhkruu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the MSR_IA32_BNDCFGS existence check into vendor code by way of
> ->has_virtualized_msr().  AMD does not support MPX, and given that Intel
> is in the process of removing MPX, it's extremely unlikely AMD will ever
> support MPX.
>
> Note, invoking ->has_virtualized_msr() requires an extra retpoline, but
> kvm_init_msr_list() is not a hot path.  As alluded to above, the
> motivation is to quarantine MPX as much as possible.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c     | 2 ++
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  arch/x86/kvm/x86.c     | 4 ----
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 4c8427f57b71..504118c49f46 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5990,6 +5990,8 @@ static bool svm_has_virtualized_msr(u32 index)
>  	switch (index) {
>  	case MSR_TSC_AUX:
>  		return boot_cpu_has(X86_FEATURE_RDTSCP);
> +	case MSR_IA32_BNDCFGS:
> +		return false;
>  	default:
>  		break;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9588914e941e..dbeef64f7409 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6279,6 +6279,8 @@ static bool vmx_has_virtualized_msr(u32 index)
>  	switch (index) {
>  	case MSR_TSC_AUX:
>  		return cpu_has_vmx_rdtscp();
> +	case MSR_IA32_BNDCFGS:
> +		return kvm_mpx_supported();
>  	default:
>  		break;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a8619c52ea86..70cbb9164088 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5237,10 +5237,6 @@ static void kvm_init_msr_list(void)
>  		 * to the guests in some cases.
>  		 */
>  		switch (msr_index) {
> -		case MSR_IA32_BNDCFGS:
> -			if (!kvm_mpx_supported())
> -				continue;
> -			break;
>  		case MSR_IA32_RTIT_CTL:
>  		case MSR_IA32_RTIT_STATUS:
>  			if (!kvm_x86_ops->pt_supported())

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

