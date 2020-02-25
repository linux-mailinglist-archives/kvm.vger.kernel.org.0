Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AD516C34A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgBYOHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:07:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgBYOHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582639622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nsLsuFeIQPYcnkAa/VDzmAJLH88gjRW8GgyCncxisZ4=;
        b=MlVXDp2U9lqENvySWKuHTpHMY67dPAG7F2Mi/4yOjo9iHeY+j9Z4wlrj1Galvw/t/jVndb
        amWmjSaydPXdRlYnz3nEoZdiK6nnipe5psWWyl+tn5ICSvE/DDI1JtqvG7MXjYTPLMQUKI
        IvAnAUlYx7zvWhrKe72mwuH5xBUS2jw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-hkqz88GgN1eRs217IfAJuQ-1; Tue, 25 Feb 2020 09:06:59 -0500
X-MC-Unique: hkqz88GgN1eRs217IfAJuQ-1
Received: by mail-wm1-f70.google.com with SMTP id g138so902944wmg.8
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:06:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nsLsuFeIQPYcnkAa/VDzmAJLH88gjRW8GgyCncxisZ4=;
        b=HBz7gH/Sn6yVqDS1OArMBvnrRQKBeszBodIs0KWM9MAaGYe/zd2FUq1XBAGjPkNO6P
         FrQnPg3q4BnB4Y/dMQnVmQi0/bu7wXLIQAWJWqqfSv9URvxq2ZC2Pd2w+6eKrfiOa0k+
         AfGmPGwfbH2vSngg8OuKK8+5G8ErCcvozKNWRBNXYfIwPfvNY5LX8uNuKOwofI58aNBR
         O93xG78SIzKjFB/azt3IG33zKHtncpUFjrm/PF9W4gq1j4GhwTRuOpeZcKcHs8zrukui
         7Yy9mVa1FVHiOB1V6zkXHI8+F7j2HTJTxiY0yDMUXThb+1jthDCU6mVY2xEnMSAnIbDI
         Mj3g==
X-Gm-Message-State: APjAAAXHgGJHKsl6m7/DasDdCHQ44qUPn9Lb8Q9DIrXbBWhoAfNqFZXs
        W/KJYH76T0e/mErF6eM/iBGC08r6mtWN0TF92Jb/eCJSRK3YeYe8f74G1/QlNc3TK0j9x7bHhXr
        Rfq+RUj7Bg9CZ
X-Received: by 2002:a1c:f008:: with SMTP id a8mr5388828wmb.81.1582639618476;
        Tue, 25 Feb 2020 06:06:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqwaifqeoSZjnYk4Mg1qtEqaTG7voewFuaRxLLbNZc17nvAEuudygfkwayhsT4aeCSe1PaUqaw==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr5388814wmb.81.1582639618233;
        Tue, 25 Feb 2020 06:06:58 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j66sm4400946wmb.21.2020.02.25.06.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:06:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 51/61] KVM: x86: Use kvm_cpu_caps to detect Intel PT support
In-Reply-To: <20200201185218.24473-52-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-52-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 15:06:56 +0100
Message-ID: <87v9nulq0v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Check for Intel PT using kvm_cpu_cap_has() to pave the way toward
> eliminating ->pt_supported().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a37cb6fda979..3d287fc6eb6e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -507,7 +507,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  {
>  	struct kvm_cpuid_entry2 *entry;
>  	int r, i, max_idx;
> -	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  
>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
> @@ -687,7 +686,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	/* Intel PT */
>  	case 0x14:
> -		if (!f_intel_pt) {
> +		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
>  			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>  			break;
>  		}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

