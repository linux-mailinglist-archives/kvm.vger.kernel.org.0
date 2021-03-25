Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D46348E5F
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 11:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCYKwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 06:52:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230155AbhCYKwk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 06:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616669560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bpc7MIQzDWxL2dXyalkYoq9pW+R2aTSeVpfg3G/26SY=;
        b=D35uavNMQ09Db0czNUlMi/k+IFDc7V+dPDDPSbE+alHBK6GzAU8dOikmgTv3+6WeBwf9ia
        R7aE5A+4/sizUKvGZYvmMHn8oA7ajpaXW4SurxppJ/Zr/8hGcUkXBw8YNVvs5mfL5z4ObI
        vTyHwmzajMGW3wJ9bCHykvO5R+rQbLs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-PAi-T16FPDyyggM7BuXoPw-1; Thu, 25 Mar 2021 06:52:37 -0400
X-MC-Unique: PAi-T16FPDyyggM7BuXoPw-1
Received: by mail-wm1-f70.google.com with SMTP id j8so1100539wmq.6
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 03:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bpc7MIQzDWxL2dXyalkYoq9pW+R2aTSeVpfg3G/26SY=;
        b=GI/e8Rt0cKUxozPn3xicZUGdY/eT0Lwxaol8bWk+93wMTzeyBfIgLpADVK+3yF9De4
         b5YxIpFV0lytlEl5VoirqrYl4Mf+0CjebN/zanLRiwStZzF/MzqsR6oortAKOYQ6/xVx
         COcohkJCf6JxmJde2P/fqBF88Wx/PhZ7ZMC/bbawXBAlFObZ2HVbNirOFJBTqDzzGi+m
         H1ybqLLpdXz5uhcCOn9Usc7vF2dKYpzITvR57pOHuRHKpAWqXoQfJgv7vJL2xsTwJ4Zc
         AEanWVSwDvD7Fv86aEHv1VZ4IZ8sWVgSLElbyYu0IKnPhwklITNjic/ApAfjF+nrxvdA
         1snA==
X-Gm-Message-State: AOAM532eOlHk603MtxS01eh2fZFXbvJGlzQRUh8t/JX3fkZ5I8uMl+lN
        ZX/AK1ZoWv6rC3t2fVRZaiC9gdGNBKTI4pHJfIU0KTtRBLQIRz2EDDni/8eNCjQIfrKt8TTU4CO
        AqZczm/CP4VmA
X-Received: by 2002:adf:edc3:: with SMTP id v3mr7986361wro.79.1616669556759;
        Thu, 25 Mar 2021 03:52:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsUgct9zaROKZvtJ/6Sc0qgVzQx3QyxP9sxC9MzKk2U3lH3e1Vx2J/tCBc9a2L2dFxBbcUfg==
X-Received: by 2002:adf:edc3:: with SMTP id v3mr7986338wro.79.1616669556579;
        Thu, 25 Mar 2021 03:52:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b65sm5957962wmh.4.2021.03.25.03.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 03:52:36 -0700 (PDT)
Subject: Re: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
To:     Borislav Petkov <bp@alien8.de>, Hugh Dickins <hughd@google.com>
Cc:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
 <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
 <20210325095619.GC31322@zn.tnic> <20210325102959.GD31322@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <757ba616-c2df-1ae8-5682-1059b33c78f9@redhat.com>
Date:   Thu, 25 Mar 2021 11:52:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210325102959.GD31322@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 11:29, Borislav Petkov wrote:
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index f5ca15622dc9..2bfa4deb8cae 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -245,12 +245,15 @@ static inline void __native_flush_tlb_single(unsigned long addr)
>   	 * ASID.  But, userspace flushes are probably much more
>   	 * important performance-wise.
>   	 *
> -	 * Make sure to do only a single invpcid when KAISER is
> -	 * disabled and we have only a single ASID.
> +	 * In the KAISER disabled case, do an INVLPG to make sure
> +	 * the mapping is flushed in case it is a global one.
>   	 */
> -	if (kaiser_enabled)
> +	if (kaiser_enabled) {
>   		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> -	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> +		invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> +	} else {
> +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> +	}
>   }
>   
>   static inline void __flush_tlb_all(void)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

