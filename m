Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA1313CBFD
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAOSUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:20:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47151 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgAOSUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:20:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579112449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2pSzV3135kt1xAEMdD0lnuf56mdsl9W1OFUiXIzWzQw=;
        b=VmwaUBXY0u1nMxOsENfiPG/PzK4+SJO1DIbb1fpvRgOMIRwugr5rASy6C/S7U9LFv/mOVF
        yiXDsLrT9sSsihA2NzVhoCcJbWfwrfS/Mn63gt8UgDAJ3wL4rurNgPHISpGCTv0xuBWUCa
        D5n4WSwQJtsKatrUBXZJv+eowpBrlms=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-ycULebc6PP-FT6SD-uaWNQ-1; Wed, 15 Jan 2020 13:20:48 -0500
X-MC-Unique: ycULebc6PP-FT6SD-uaWNQ-1
Received: by mail-wr1-f70.google.com with SMTP id d8so8250032wrq.12
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:20:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2pSzV3135kt1xAEMdD0lnuf56mdsl9W1OFUiXIzWzQw=;
        b=sGnvnfQewKgaKCzxoi6QflG2kn/xAyXNCKYpaXRCur13bCsfteyfCiuSYyrTG6f4jF
         o2LZcjegAlwIFmD0lbUqIWeH3XxA38CVYUKzsGPVLFsmHTUZTU8jTT/xdcn4nkAX3Mxv
         4rKD1yZzEfQS6uUWKamIkXtt7ws/9BsHmKflmQsh12rtYSllEbWLDWdVojm0N1mLxDr3
         pk11UAG1i48+NcPOaRh2q5pV/E/zTyrLCLpR0rwXbMakPoazZqoLhJOczG31FQv0LLsd
         Xxg6IUHsZh+gtVMN5jNNoqED5xg2//o9aIeCdThKQgvlay0Jl1bjE8uGMnXoI1Q6LkiE
         sMHw==
X-Gm-Message-State: APjAAAX0iN8h2rTvWmzp0xaQ1/6uiCA6KBJAiWDGWKHREx6cX27aZ4vs
        bsJF+/ZxFapf1wsjldl3pPUIaPDq0fGbNUfrad8lsGpGhf3QLReyYsERLxItIfdBfmjwS0BcFtx
        zGm0WpYyO4ydp
X-Received: by 2002:adf:f10a:: with SMTP id r10mr32616297wro.202.1579112446881;
        Wed, 15 Jan 2020 10:20:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqwBkPmaHaQlwJtrKOBkm5Wwx2xyAD5D7Reaob9mWT3wqgNC2NGOwvxBa3uDNWP79k3b55/ffA==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr32616279wro.202.1579112446663;
        Wed, 15 Jan 2020 10:20:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id c5sm922497wmb.9.2020.01.15.10.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:20:46 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit
 KVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200108001210.12913-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2f8c8d5-39d2-6982-a4ae-eeaf4bf42658@redhat.com>
Date:   Wed, 15 Jan 2020 19:20:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108001210.12913-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 01:12, Sean Christopherson wrote:
> Remove the bogus 64-bit only condition from the check that disables MMIO
> spte optimization when the system supports the max PA, i.e. doesn't have
> any reserved PA bits.  32-bit KVM always uses PAE paging for the shadow
> MMU, and per Intel's SDM:
> 
>   PAE paging translates 32-bit linear addresses to 52-bit physical
>   addresses.
> 
> The kernel's restrictions on max physical addresses are limits on how
> much memory the kernel can reasonably use, not what physical addresses
> are supported by hardware.
> 
> Fixes: ce88decffd17 ("KVM: MMU: mmio page fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7269130ea5e2..d9c07343d979 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6191,7 +6191,7 @@ static void kvm_set_mmio_spte_mask(void)
>  	 * If reserved bit is not supported, clear the present bit to disable
>  	 * mmio page fault.
>  	 */
> -	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
> +	if (shadow_phys_bits == 52)
>  		mask &= ~1ull;
>  
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
> 

Queued, thanks.

Paolo

