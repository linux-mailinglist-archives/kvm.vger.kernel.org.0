Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEE42DD2F3
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgLQOWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:22:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgLQOWs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 09:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608214881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q3zX9nGma2sc+foBdiZDz1vjiexa9yeL6J3v7SV/DL0=;
        b=Dgs1flo/0pD0D0NCfRLs3jz8oe4/wmsILf2qJobE+iG3nHVrVTO1h+TdYIiMdT3U+qqkS9
        oU+ASn23KnPqI2xJ1vodiWngmImD3P3dmXSwKBPh8lX8cEcMcqL5Kf8umU8D1PsWyLIc6O
        vFq18qhBvPz63Hk4f5lksdgRZf/aDXU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-qxpasQ8-O1-FAuE7exYUAg-1; Thu, 17 Dec 2020 09:21:19 -0500
X-MC-Unique: qxpasQ8-O1-FAuE7exYUAg-1
Received: by mail-ej1-f72.google.com with SMTP id t17so8720217ejd.12
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 06:21:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3zX9nGma2sc+foBdiZDz1vjiexa9yeL6J3v7SV/DL0=;
        b=EpOion3LjUf/gGEBqFHdZ4hPtqA3xKYEZTGvEtfxF/CHEUawp14D4hvj/rFds9DuGn
         IMTqYr4tTCzpukmsUcHuqPpkFoeJosvAVAyuRqKapSmlq6UoMX1xPODyRKmfI8lP7dpc
         +c0jj3VYq6LVjgBr28ZzoiojVv9z7tpjiooz0sx4Wp7NESvYTpuEitZ0elIIXbRhJCwu
         HGpBkusEvI/U4chKHSfDBiA7nFcinTeJDXAvO3fTEHPBzEefLgpvxbSxHiyf5P58eIO3
         tmY3lQf9ZSVrjjI8o+OCXpEFC5Zp2u8U3hKbC8r5ktooScps4yONNfKpDqaLBrQSGcu5
         uJNg==
X-Gm-Message-State: AOAM533XIS8aHS7ZJ/Oi0Pi5NP2YOPShJKDtijxNXaz9DIZDwbEvedXy
        zIAvYe8oNxa3kY/7F3NRobaAEQpjla0p5vplyGgrtBTyvbQ2F5Iz76v1CDAqnrZ9TX+TS81apM8
        cYtt1LG+pHnaExA/NQ9olJ5y32LAvcy1PLfchLsH3lq4XhDGlnbA1uOeLbzqA3BTG
X-Received: by 2002:a17:906:9250:: with SMTP id c16mr36252418ejx.355.1608214877787;
        Thu, 17 Dec 2020 06:21:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBtuAn/5oKnQJimo74RKWwWmYaG5Jtmtqkhyj0v4zAd/vGeoPQ6Ib4nnTFsSMeyLfi3tLVrw==
X-Received: by 2002:a17:906:9250:: with SMTP id c16mr36252384ejx.355.1608214877492;
        Thu, 17 Dec 2020 06:21:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dd18sm3881873ejb.53.2020.12.17.06.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 06:21:16 -0800 (PST)
Subject: Re: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org
References: <1607955408254166@kroah.com>
 <8bf9d5caf338d705744764c60256ace1d3f1d252.1608168540.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41d60554-ba04-b877-1189-6cb33bc3600b@redhat.com>
Date:   Thu, 17 Dec 2020 15:21:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <8bf9d5caf338d705744764c60256ace1d3f1d252.1608168540.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/20 14:46, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> cleaned up the computation of MMIO generation SPTE masks, however it
> introduced a bug how the upper part was encoded:
> SPTE bits 52-61 were supposed to contain bits 10-19 of the current
> generation number, however a missing shift encoded bits 1-10 there instead
> (mostly duplicating the lower part of the encoded generation number that
> then consisted of bits 1-9).
> 
> In the meantime, the upper part was shrunk by one bit and moved by
> subsequent commits to become an upper half of the encoded generation number
> (bits 9-17 of bits 0-17 encoded in a SPTE).
> 
> In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
> has changed the SPTE bit range assigned to encode the generation number and
> the total number of bits encoded but did not update them in the comment
> attached to their defines, nor in the KVM MMU doc.
> Let's do it here, too, since it is too trivial thing to warrant a separate
> commit.
> 
> This is a backport of the upstream commit for 5.4.x stable series, which
> has KVM docs still in a raw text format and the x86 KVM MMU isn't yet split
> into separate files under "mmu" directory.
> Other than that, it's a straightforward port.
> 
> Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [Reorganize macros so that everything is computed from the bit ranges. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (cherry picked from commit 34c0f6f2695a2db81e09a3ab7bdb2853f45d4d3d)
> Cc: stable@vger.kernel.org # 5.4.x
> ---
>   Documentation/virt/kvm/mmu.txt |  2 +-
>   arch/x86/kvm/mmu.c             | 29 ++++++++++++++++++++---------
>   2 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/mmu.txt b/Documentation/virt/kvm/mmu.txt
> index dadb29e8738f..ec072c6bc03f 100644
> --- a/Documentation/virt/kvm/mmu.txt
> +++ b/Documentation/virt/kvm/mmu.txt
> @@ -420,7 +420,7 @@ If the generation number of the spte does not equal the global generation
>   number, it will ignore the cached MMIO information and handle the page
>   fault through the slow path.
>   
> -Since only 19 bits are used to store generation-number on mmio spte, all
> +Since only 18 bits are used to store generation-number on mmio spte, all
>   pages are zapped when there is an overflow.
>   
>   Unfortunately, a single memory access might access kvm_memslots(kvm) multiple
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b90e8fd2f6ce..47c27c6e3842 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -407,11 +407,11 @@ static inline bool is_access_track_spte(u64 spte)
>   }
>   
>   /*
> - * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
> + * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
>    * the memslots generation and is derived as follows:
>    *
>    * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
> - * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
> + * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
>    *
>    * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
>    * the MMIO generation number, as doing so would require stealing a bit from
> @@ -420,18 +420,29 @@ static inline bool is_access_track_spte(u64 spte)
>    * requires a full MMU zap).  The flag is instead explicitly queried when
>    * checking for MMIO spte cache hits.
>    */
> -#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
>   
>   #define MMIO_SPTE_GEN_LOW_START		3
>   #define MMIO_SPTE_GEN_LOW_END		11
> -#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
> -						    MMIO_SPTE_GEN_LOW_START)
>   
>   #define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
>   #define MMIO_SPTE_GEN_HIGH_END		62
> +
> +#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
> +						    MMIO_SPTE_GEN_LOW_START)
>   #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
>   						    MMIO_SPTE_GEN_HIGH_START)
>   
> +#define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
> +#define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
> +
> +/* remember to adjust the comment above as well if you change these */
> +static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 9);
> +
> +#define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
> +#define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
> +
> +#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
> +
>   static u64 generation_mmio_spte_mask(u64 gen)
>   {
>   	u64 mask;
> @@ -439,8 +450,8 @@ static u64 generation_mmio_spte_mask(u64 gen)
>   	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
>   	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
>   
> -	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
> -	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
> +	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
> +	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
>   	return mask;
>   }
>   
> @@ -448,8 +459,8 @@ static u64 get_mmio_spte_generation(u64 spte)
>   {
>   	u64 gen;
>   
> -	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
> -	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
> +	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_SHIFT;
> +	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_SHIFT;
>   	return gen;
>   }
>   
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

