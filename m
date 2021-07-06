Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA3B3BD870
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhGFOlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:41:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232434AbhGFOlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ooFOmAwzy+HfFOyvCt29aszDpkZZys9ivsOeIkFxqM=;
        b=a12eOlEf/m1Ev+gCa60zKrtM8IKl1WL07w73Rixn63Zp+zQYhQ45nwbnBCub0AK4k+adjQ
        xoc1+c/lFVVKrh27x64Ck9PNArASV6dmvc/JzhVH1esFar583gf1xRkReeIZhzGZk1pzMk
        UFwjqUcGV9AGcN27Mr/TUkM6r4fmUk0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-XjzYRi4SNhmPOwTNLidImw-1; Tue, 06 Jul 2021 09:48:18 -0400
X-MC-Unique: XjzYRi4SNhmPOwTNLidImw-1
Received: by mail-ed1-f71.google.com with SMTP id i8-20020a50fc080000b02903989feb4920so5362845edr.1
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ooFOmAwzy+HfFOyvCt29aszDpkZZys9ivsOeIkFxqM=;
        b=YUvH6mex7YZHv1KVV/viOtsf8WsAiWuWZezVAvTEXoSfUn3m5uTcgyQZwmwA7AO8V6
         BEUchhBYZJt+HbKJaRGkfCqXeBzF15TmpfBsL8wkyhbFuWISnn5mf75Ey+EzHxGF90Tn
         2Gk66lidNZJy3K/vVziHtftrgWloi9XISWT+0lkP812bezmneuHjSVzuN1OB30d9QgO0
         K6xQO/yBFXBa8tH8lnlM2HxcTzJ/AY+mQOMtbrb5bIDPEhWzO1Rk2X0cBzjPLODjywkS
         2CLV0OWRZMF+aALZ8tIgD+fohe1LtfpcETWBaoh2lBK5H/a50Q4q6aaOk3HtzusgXepx
         jzyA==
X-Gm-Message-State: AOAM532M75BniLgEgN7n+xa29kI2YNFYkVnoADbXVfu138Per/oXFpZ7
        wZRXWXERsdT03VrBGMCz/QJ6XQ6yLNVNKUFk7dwVcVL8onlPtgRJVW6bAokkVJUXo4zHGaGRk4n
        ntmQJE2UrUOZn
X-Received: by 2002:a05:6402:406:: with SMTP id q6mr23046866edv.149.1625579296983;
        Tue, 06 Jul 2021 06:48:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGgl9DEawCZx7xuCpsoeuxmG5yr+usrtKWM4tItXUuTZW4Yz4Wcnjt/dgpWkDPxPJymUOcEA==
X-Received: by 2002:a05:6402:406:: with SMTP id q6mr23046835edv.149.1625579296860;
        Tue, 06 Jul 2021 06:48:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g8sm7282271edv.84.2021.07.06.06.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:48:15 -0700 (PDT)
Subject: Re: [RFC PATCH v2 20/69] KVM: x86/mmu: Mark VM as bugged if page
 fault returns RET_PF_INVALID
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <298980aa5fc5707184ac082287d13a800cd9c25f.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a5337d79-8503-0343-11d8-207bd929b2ff@redhat.com>
Date:   Tue, 6 Jul 2021 15:48:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <298980aa5fc5707184ac082287d13a800cd9c25f.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5b8a640f8042..0dc4bf34ce9c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5091,7 +5091,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>   	if (r == RET_PF_INVALID) {
>   		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
>   					  lower_32_bits(error_code), false);
> -		if (WARN_ON_ONCE(r == RET_PF_INVALID))
> +		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
>   			return -EIO;
>   	}
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

