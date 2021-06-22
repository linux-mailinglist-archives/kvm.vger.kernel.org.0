Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF63B0A8A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhFVQpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:45:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbhFVQpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624380202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqggAYJUg6fHbEAdVvsWBfgBtGxc+6Jb/H8dZhUKvv8=;
        b=N4CUTBlsW7+6wpiWr6d/RNzJHr0Zl90TncirN4t4lYyMK4kH0tOlQQVLck4sv7vazNVNGq
        Sr7U714ifZnFMVQQKMGHLgZpVVyc8oCYpK1L54CDBDN9g+f9rSAo3UQw+9kSdbvt9/wjn/
        v60X/kPGATtuxEsy9cOazjAk5cKCtss=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-m7Nt7sfWMC6ZsC3r1j0bjg-1; Tue, 22 Jun 2021 12:43:21 -0400
X-MC-Unique: m7Nt7sfWMC6ZsC3r1j0bjg-1
Received: by mail-wr1-f69.google.com with SMTP id n2-20020adfb7420000b029010e47b59f31so9891880wre.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vqggAYJUg6fHbEAdVvsWBfgBtGxc+6Jb/H8dZhUKvv8=;
        b=mqM/VQ0e/bztRTaNujALQD67/ZRBxw6SOap4wNYvSXq8WA8smBF/nT+vhr1m7+HR+R
         iH8C9cpr8DW+6N7C403K0OS/bB64DT9FtQfUPpzsATleSeUro5/NMrS+4OiRGfFqFHMl
         uhm1xGKHr43BSYV3vmKVOvO3pRGPJWEg4mpLR6OAI5wujVJYOb+Hj1HLFVx1U5VQBKmd
         ngKUlAehhZ0lNBP4oaGOsRCMiOgmdbE9vZejEK+80M8OUMri0j1An6lABpaFNnnLUpw6
         rMuFodiSAiTWYFvqglEex9Ie5heNPVIKvwjiakC7IeirVLPUMcSHPzjVqQ+bDQKPSb8s
         H9+w==
X-Gm-Message-State: AOAM531jp7KQYRFJirvkzLkTgvLUMwWyQeTtrTOpMSfJFSrj9GwYS3uD
        jvPhTPuFcF9Iyu3WXe8TColsD+5GLHLZI+6b6WJldWiyqlYZ0uNPuhVkucojKFRmwgRI76wREPe
        A0LRzp7OvFOcs
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr5846244wrr.188.1624380199401;
        Tue, 22 Jun 2021 09:43:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxnu8M4DnxUd81kSwud6iw4Qb+iSUsFgoPTMed1pHs74o/m6tG3gCAKZjSKtKUt82B1iJw/Q==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr5846216wrr.188.1624380199230;
        Tue, 22 Jun 2021 09:43:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 2sm2868252wmk.24.2021.06.22.09.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 09:43:18 -0700 (PDT)
Subject: Re: [PATCH][next] KVM: x86/mmu: Fix uninitialized boolean variable
 flush
To:     Colin King <colin.king@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210622150912.23429-1-colin.king@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a8f9ef7-03f7-08e3-61b2-548aa54328e3@redhat.com>
Date:   Tue, 22 Jun 2021 18:43:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622150912.23429-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 17:09, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where kvm_memslots_have_rmaps(kvm) is false the boolean
> variable flush is not set and is uninitialized.  If is_tdp_mmu_enabled(kvm)
> is true then the call to kvm_tdp_mmu_zap_collapsible_sptes passes the
> uninitialized value of flush into the call. Fix this by initializing
> flush to false.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: e2209710ccc5 ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ed24e97c1549..b8d20f139729 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5689,7 +5689,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   {
>   	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
>   	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
> -	bool flush;
> +	bool flush = false;
>   
>   	if (kvm_memslots_have_rmaps(kvm)) {
>   		write_lock(&kvm->mmu_lock);
> 

Queued, thanks.

Paolo

