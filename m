Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A37816B393
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgBXWIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:08:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbgBXWIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582582115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yiv6p60zYp+Qyy2Kc45wJ/cRh4L2UEHjFJ31xKlgI6M=;
        b=Z8SLawThe3jibFXGNYnC7U/HcNeA7Xbaqccgu4NXK8YtW2mLt5GftnAEdJ91FykN3E0ZhJ
        EZ+hbMh7NHOiwk6ZXWkO2U4PX1t766sHqsSFYnph3z0u9wqW/WSssUZcOAPasW1nX81UFu
        sEeCE6fDJt9+/EWrFusKQRzBUFEHLks=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-QT3zmBV6MIaJsw_8zPzzVw-1; Mon, 24 Feb 2020 17:08:34 -0500
X-MC-Unique: QT3zmBV6MIaJsw_8zPzzVw-1
Received: by mail-wm1-f72.google.com with SMTP id t17so296193wmi.7
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 14:08:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yiv6p60zYp+Qyy2Kc45wJ/cRh4L2UEHjFJ31xKlgI6M=;
        b=Oj8dpho96whda5ars0eOUxBTAgo49TZIWzs0k4foQVr3n3//VaAtgUexAPPjMIfo5+
         hEwtzxyEmWJi37iKeNpO1l5EHia12lUYHfAiEokTcS0T3IiDPULZQWJDtR7elMIvjkRq
         6OHfc5TXdrllpVliM0gcxqfJWm92YRvvdYi1dcdp9/4aD+ttjL64XTPoBNevAUhhthHu
         vS96vQlUncfWuP8N9RVPo1EH9hGBZy80dThZ3sN4lW80SjTQtqlRxUWYjWskclv53Cz0
         YmRL7vPnKaXSU9GblfDNyLJfCB40kL4j1cmmHZzKkhwZxMM+wQvsP2PDuQ9Jq1LJQIaz
         C0pg==
X-Gm-Message-State: APjAAAXnFdt2yQYHJ7dg0QmEU+d6jTOCflDcWY338gh8J9xQxknqqYxZ
        tW9uXzs6XKYorUS/jS29OvPEaPIOW7+brwa7iV0Wk1wkaPmBTBLvxVNnRcLWrEkvmUMZWnN0qPE
        FElpTt4kHd3VF
X-Received: by 2002:a5d:6406:: with SMTP id z6mr68381190wru.294.1582582112741;
        Mon, 24 Feb 2020 14:08:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzfFk7h1ch3NYlC+Q8VgeC+gtxfRrR33906xmlvcXnnYg09j3WXEMEzqudyeX8MUceimK3BTg==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr68381172wru.294.1582582112451;
        Mon, 24 Feb 2020 14:08:32 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m68sm1081837wme.48.2020.02.24.14.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:08:31 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as not-reserved
In-Reply-To: <20200201185218.24473-44-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-44-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 23:08:30 +0100
Message-ID: <8736azocyp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add accessor(s) for KVM cpu caps and use said accessor to detect
> hardware support for LA57 instead of manually querying CPUID.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.h | 13 +++++++++++++
>  arch/x86/kvm/x86.c   |  2 +-
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 7b71ae0ca05e..5ce4219d465f 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -274,6 +274,19 @@ static __always_inline void kvm_cpu_cap_set(unsigned x86_feature)
>  	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>  }
>  
> +static __always_inline u32 kvm_cpu_cap_get(unsigned x86_feature)
> +{
> +	unsigned x86_leaf = x86_feature / 32;
> +
> +	reverse_cpuid_check(x86_leaf);
> +	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
> +}
> +
> +static __always_inline bool kvm_cpu_cap_has(unsigned x86_feature)
> +{
> +	return kvm_cpu_cap_get(x86_feature);
> +}

I know this works (and I even checked C99 to make sure that it works not
by accident) but I have to admit that explicit '!!' conversion to bool
always makes me feel safer :-)

> +
>  static __always_inline void kvm_cpu_cap_check_and_set(unsigned x86_feature)
>  {
>  	if (boot_cpu_has(x86_feature))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5ed199d6cd9..cb40737187a1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -912,7 +912,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
>  {
>  	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
>  
> -	if (cpuid_ecx(0x7) & feature_bit(LA57))
> +	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
>  		reserved_bits &= ~X86_CR4_LA57;
>  
>  	if (kvm_x86_ops->umip_emulated())

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

