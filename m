Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07E03322A1
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 11:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCIKKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 05:10:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhCIKJv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 05:09:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615284591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E7+PqvKTFHdaKCmM0AiAKUNzRu+ZOxj1wno09Cr/Az0=;
        b=Gfjn7pEB3NvEmzpoN1dxvWcXIlXUuKqiAB/ozMa9mzwxe0cRyLDInLbm/TJZDgl4+D/Qp8
        +m+hhwHY4budqdUfpKORDqz51bbrg06QvOfSvsgDqaxBlbiwFAepDoSW6Kj1+dbm53VCAg
        fdqrrqg5CoImzEQ+c1bQeBtoUn51/eY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-BGkCS5InMzyjBBKcXi9jAA-1; Tue, 09 Mar 2021 05:09:47 -0500
X-MC-Unique: BGkCS5InMzyjBBKcXi9jAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59DB11005D45;
        Tue,  9 Mar 2021 10:09:46 +0000 (UTC)
Received: from starship (unknown [10.35.206.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB0935D6D7;
        Tue,  9 Mar 2021 10:09:43 +0000 (UTC)
Message-ID: <785c17c307e66b9d7b422cc577499d284cfb6e7b.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO
 SPTE's generation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Tue, 09 Mar 2021 12:09:41 +0200
In-Reply-To: <20210309021900.1001843-3-seanjc@google.com>
References: <20210309021900.1001843-1-seanjc@google.com>
         <20210309021900.1001843-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-08 at 18:19 -0800, Sean Christopherson wrote:
> Drop bit 11, used for the MMU_PRESENT flag, from the set of bits used to
> store the generation number in MMIO SPTEs.  MMIO SPTEs with bit 11 set,
> which occurs when userspace creates 128+ memslots in an address space,
> get false positives for is_shadow_present_spte(), which lead to a variety
> of fireworks, crashes KVM, and likely hangs the host kernel.
> 
> Fixes: b14e28f37e9b ("KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs")
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/spte.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index b53036d9ddf3..bca0ba11cccf 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -101,11 +101,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>  #undef SHADOW_ACC_TRACK_SAVED_MASK
>  
>  /*
> - * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
> + * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
>   * the memslots generation and is derived as follows:
>   *
> - * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
> - * Bits 9-19 of the MMIO generation are propagated to spte bits 52-62
> + * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
> + * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
>   *
>   * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
>   * the MMIO generation number, as doing so would require stealing a bit from
> @@ -116,7 +116,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>   */
>  
>  #define MMIO_SPTE_GEN_LOW_START		3
> -#define MMIO_SPTE_GEN_LOW_END		11
> +#define MMIO_SPTE_GEN_LOW_END		10
>  
>  #define MMIO_SPTE_GEN_HIGH_START	52
>  #define MMIO_SPTE_GEN_HIGH_END		62
> @@ -125,12 +125,14 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>  						    MMIO_SPTE_GEN_LOW_START)
>  #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
>  						    MMIO_SPTE_GEN_HIGH_START)
> +static_assert(!(SPTE_MMU_PRESENT_MASK &
> +		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
>  
>  #define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
>  #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
>  
>  /* remember to adjust the comment above as well if you change these */
> -static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 11);
> +static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>  
>  #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
>  #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
I bisected this and I reached the same conclusion that bit 11 has to be removed from mmio generation mask.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
 
I do wonder, why do we need 19 (and now 18 bits) for the mmio generation:

What happens if mmio generation overflows (e.g if userspace keeps on updating the memslots)? 
In theory if we have a SPTE with a stale generation, it can became valid, no?

I think that we should in the case of the overflow zap all mmio sptes.
What do you think?

Best regards,
	Maxim Levitsky

