Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA0C149425
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 10:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgAYJcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 04:32:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbgAYJcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jan 2020 04:32:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579944727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4aVPwT+ullXbV9ZGelAsF2ZlUzo01e9ol8SPKMVndpw=;
        b=Of2AhvTnZpik7dhPmb37Ryh2IrPZ2XH6xNPAEgxDeW1jEuVGNdjkuiE6kS6BCmcpmRDQvs
        xvhvMb9TLArRxFmNf2pnNZM5TYQSe7OjlYt0nkxKhTeuf/MibS26/P3QNmz7KiQKQ/QPvp
        BZJIk/iPg/CInRAMqoHOoUxjKUoWR+Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-elHhnXMtM9mPmiJNIdHQeg-1; Sat, 25 Jan 2020 04:32:05 -0500
X-MC-Unique: elHhnXMtM9mPmiJNIdHQeg-1
Received: by mail-wr1-f70.google.com with SMTP id j4so2746733wrs.13
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2020 01:32:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4aVPwT+ullXbV9ZGelAsF2ZlUzo01e9ol8SPKMVndpw=;
        b=WjxqzR+kVUsOdqpFarfNIc1sM78800WkPcffAXpyFN/JFAH5OsT92hsrZPJizYt9Di
         +0cnfHPVbs4Q5ZGBqZzxjk5wzWjaWc28DJ6I6XPi2Nt9zj2JMP1pN7jERczetBAboc0S
         VRPXQX/K/SkqMmpNFCKieFq2BrOQjqVDkPIB0gOLCYZGfQpgfm/jrofJBIZG95/hSNFW
         mhDdYVpMiNVLlBVI0Xh6BGBKcuprdVAUq88DpAMmOrIrFFzTAIczqiqWrvglMvULB5+5
         fIYFdmW+vgSBRgJnmYkRRdGBbOP9KZEAx8N5SAHgGYPnRJT/0ItV6itZLmJp8DG6OOZh
         sRhw==
X-Gm-Message-State: APjAAAXmTzMNdj+ZPKL3wc5zh9U7GJLQc6LFaF6X6+p9oRPdS6kTzF2y
        FALWwouqkJLVwPF5C/tVVqNF9bL4tWP3+7AxCXiIdXHRnYWrqYm1VkKtyYbZ07W9zu9KGbR29ah
        mpMCIXiRFR/RR
X-Received: by 2002:a05:6000:11c3:: with SMTP id i3mr9377041wrx.244.1579944724475;
        Sat, 25 Jan 2020 01:32:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6XvOgjU6V9Wv3zn93Ex1jpxLzeOnJ89MIAzXJBVajO5ULnjaciehkCA0EPTt32FXxUHMtbg==
X-Received: by 2002:a05:6000:11c3:: with SMTP id i3mr9377021wrx.244.1579944724231;
        Sat, 25 Jan 2020 01:32:04 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b67sm10500968wmc.38.2020.01.25.01.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 01:32:03 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Take a u64 when checking for a valid dr7 value
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>
References: <20200124230722.8964-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <118ad0a6-b190-80ee-98fa-615466d2bf12@redhat.com>
Date:   Sat, 25 Jan 2020 10:32:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200124230722.8964-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/20 00:07, Sean Christopherson wrote:
> Take a u64 instead of an unsigned long in kvm_dr7_valid() to fix a build
> warning on i386 due to right-shifting a 32-bit value by 32 when checking
> for bits being set in dr7[63:32].
> 
> Alternatively, the warning could be resolved by rewriting the check to
> use an i386-friendly method, but taking a u64 fixes another oddity on
> 32-bit KVM.  Beause KVM implements natural width VMCS fields as u64s to
> avoid layout issues between 32-bit and 64-bit, a devious guest can stuff
> vmcs12->guest_dr7 with a 64-bit value even when both the guest and host
> are 32-bit kernels.  KVM eventually drops vmcs12->guest_dr7[63:32] when
> propagating vmcs12->guest_dr7 to vmcs02, but ideally KVM would not rely
> on that behavior for correctness.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Fixes: ecb697d10f70 ("KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2d2ff855773b..3624665acee4 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -357,7 +357,7 @@ static inline bool kvm_pat_valid(u64 data)
>  	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>  }
>  
> -static inline bool kvm_dr7_valid(unsigned long data)
> +static inline bool kvm_dr7_valid(u64 data)
>  {
>  	/* Bits [63:32] are reserved */
>  	return !(data >> 32);
> 

Queued, thanks.

Paolo

