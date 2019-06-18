Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212034A7D0
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 19:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfFRREE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 13:04:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35195 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRREE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 13:04:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so345701wrv.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 10:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qrCyxA69hfMGjqWzMkMbDQLaGAhqxPfbk8m8a3N9/HM=;
        b=IXoHWm1/LJ+REZ5zNCbwOuhm1GO2XKAtvMw2TT9wvjWzl5XTh9CFJ56pWQl4C8gZIs
         2WUt3u0SowDzDKkHaSgOcSDn3MmYF3gUqZbzkolHZorlIvGs5BWeAduMGEwntPzgFzZr
         GP2/L07sBST7JWCXNpPMspHCKX4EnevRS0RtcvbGl0Do5Ipf+IeeugdnApniM6bezQTM
         NoWSrIF2MLPnhQH8tJf/KdNEsDo2P0RzwgASWyTo7yjnG0C8QMTG0yD8QWvHdxCzKl6r
         NOBAoTQNiSaEJfOJxPaQwQMGfYa3u3CHQoR61tKUXrMM2wiwdtXqQ8rEs4TpRKKGcyCE
         4TjA==
X-Gm-Message-State: APjAAAVWIlYB8vGi+O81Nu/G7Sayhr5Sa8ymzNdqq3TotWLSam4OJs8x
        X5V+s1RWvGsyQ7PXAqvNQAQCFg==
X-Google-Smtp-Source: APXvYqwoh49LYqbiQCIgeUW+nwL7FsoIMvi5VBfapXNO2HXukjq5gXzEwWJRrDWzxLNCxrEUbUQTwQ==
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr38563325wrs.2.1560877442360;
        Tue, 18 Jun 2019 10:04:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id o20sm17699558wrh.8.2019.06.18.10.04.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 10:04:01 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's
 32-bit NPT
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jiri Palecek <jpalecek@web.de>
References: <20190613172223.17119-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cdb1cf80-ae30-6a14-4088-6b30b6bb588c@redhat.com>
Date:   Tue, 18 Jun 2019 19:04:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190613172223.17119-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/06/19 19:22, Sean Christopherson wrote:
> SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
> page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
> is enabled, i.e. the PAE root array needs to be allocated.
> 
> Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
> Cc: stable@vger.kernel.org
> Reported-by: Jiri Palecek <jpalecek@web.de>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Jiri, can you please test this patch?  I haven't actually verified this
> fixes the bug due to lack of SVM hardware.
> 
>  arch/x86/kvm/mmu.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 1e9ba81accba..d3c3d5e5ffd4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5602,14 +5602,18 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
>  	struct page *page;
>  	int i;
>  
> -	if (tdp_enabled)
> -		return 0;
> -
>  	/*
> -	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
> -	 * Therefore we need to allocate shadow page tables in the first
> -	 * 4GB of memory, which happens to fit the DMA32 zone.
> +	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
> +	 * while the PDP table is a per-vCPU construct that's allocated at MMU
> +	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
> +	 * x86_64.  Therefore we need to allocate the PDP table in the first
> +	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
> +	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
> +	 * skip allocating the PDP table.
>  	 */
> +	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
> +		return 0;
> +
>  	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
>  	if (!page)
>  		return -ENOMEM;
> 

Queued, thanks.

Paolo
