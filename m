Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C83BD93A
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhGFO7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232215AbhGFO7q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ajXTV150imp5i5LHBYKTJZiAWY9kq7YZNMi3S09CEc=;
        b=fGDKpVfc6i8KBxmmKgJjXr0dAxUpEy1Y4PBqcRW47neBYA+TEXbQo5SbnUjhJxg6MHAmAj
        ffM+kvK49pR8QcDIk75I7ZSCZaA5IuyaCD8v7n5Ng4LK44GoxaL2XupytUTZKJot4IQzyM
        +XKhk561WUHEJA8pbmeJ9oP/1RTZ+Tk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-G3TxuqzINpGaXQUNoj91Mg-1; Tue, 06 Jul 2021 10:57:04 -0400
X-MC-Unique: G3TxuqzINpGaXQUNoj91Mg-1
Received: by mail-ed1-f70.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so10944122edt.13
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ajXTV150imp5i5LHBYKTJZiAWY9kq7YZNMi3S09CEc=;
        b=de6kNsTJ5CazR4eY4281rJK3O7jU1gd0Z+6tA4f3h0Zp7SBk1bry670XZ/dgDi06to
         kgKDETvcCt3RO/OXnoJmKJJIa7IuFQ+zMBXD8K85iePwwiZMFrUtJBhVO1pc4WbFb51f
         DAGF4THeU3J8ECa5hP4QPucEUnZv/dD7b9WJqyf4Ul09IJ/U1cxAYHpr+Qy+uY76I+26
         vGziOvzQmMMCwtSStZhHTstIUxdeiv1+ZKvYdXCz9r5zmV4/qV9bf+kHKtpkkFpC40mc
         c4YBngUXt0xvbCrrVeExhrolxV07TkZtWgNCWKApWWaM7sxQ3a9M2MFm1DNjsV06iW+E
         /CGw==
X-Gm-Message-State: AOAM531iA1SzwT7lcGJnrlclvZSlkh1/VUEbM+jixIAteAAsA5/4KDKG
        26yEgJVIyOaBa9IzBFqUuIjTM5Wb13OZAXUhxCc1+D63QwxOP4RIFrNQeWGO3R+1nV91dJNK38o
        ELzNlKQgZBQ2V
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr19060882ejy.221.1625583423480;
        Tue, 06 Jul 2021 07:57:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl9/fA/olglusnGZGiD3rJjGLlUSaaVEshCNmI4RzJe3uvRHHhn4YU+Yo/ba5lt6Hy/ncYtQ==
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr19060862ejy.221.1625583423322;
        Tue, 06 Jul 2021 07:57:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i18sm7610877edc.7.2021.07.06.07.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:56:58 -0700 (PDT)
Subject: Re: [RFC PATCH v2 45/69] KVM: x86/mmu: Return old SPTE from
 mmu_spte_clear_track_bits()
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
 <b16bac1fd1357aaf39e425aab2177d3f89ee8318.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ca5f199-3fd8-34b0-14e4-2d9259b6fb6e@redhat.com>
Date:   Tue, 6 Jul 2021 16:56:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b16bac1fd1357aaf39e425aab2177d3f89ee8318.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Return the old SPTE when clearing a SPTE and push the "old SPTE present"
> check to the caller.  Private shadow page support will use the old SPTE
> in rmap_remove() to determine whether or not there is a linked private
> shadow page.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0259781cee6a..6b0c8c84aabe 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -542,9 +542,9 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>    * Rules for using mmu_spte_clear_track_bits:
>    * It sets the sptep from present to nonpresent, and track the
>    * state bits, it is used to clear the last level sptep.
> - * Returns non-zero if the PTE was previously valid.
> + * Returns the old PTE.
>    */
> -static int mmu_spte_clear_track_bits(u64 *sptep)
> +static u64 mmu_spte_clear_track_bits(u64 *sptep)
>   {
>   	kvm_pfn_t pfn;
>   	u64 old_spte = *sptep;
> @@ -555,7 +555,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
>   		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
>   
>   	if (!is_shadow_present_pte(old_spte))
> -		return 0;
> +		return old_spte;
>   
>   	pfn = spte_to_pfn(old_spte);
>   
> @@ -572,7 +572,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
>   	if (is_dirty_spte(old_spte))
>   		kvm_set_pfn_dirty(pfn);
>   
> -	return 1;
> +	return old_spte;
>   }
>   
>   /*
> @@ -1104,7 +1104,9 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
>   
>   static void drop_spte(struct kvm *kvm, u64 *sptep)
>   {
> -	if (mmu_spte_clear_track_bits(sptep))
> +	u64 old_spte = mmu_spte_clear_track_bits(sptep);
> +
> +	if (is_shadow_present_pte(old_spte))
>   		rmap_remove(kvm, sptep);
>   }
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

