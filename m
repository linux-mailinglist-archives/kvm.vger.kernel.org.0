Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA41821027E
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 05:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGADYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 23:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGADYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 23:24:33 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B3FC061755
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 20:24:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j4so9340622plk.3
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 20:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNqc15jZbIj9okPqq1dG85vtgZ8ilG78W0ctJX2WFx0=;
        b=s/lDvbN02+aakg/+DjaWMDhXJp0XpghVKtSvUkdTArjq2q1UC2Vxmc0DRhJ/006C+w
         96TsZmkx+IZDmHmMWgju2pkJ95thx7DhmlaXXl36+QBDCVER3uBEfs911/l3pBt8Vva8
         MKtzAXfGWTKESA4MedE1syIk5WaPFmeJa1K+Qu9R2HGEui56+lVgF25VuD4LyqQgiln5
         oVI9ba4Y8cgzXZCISFs3LS4eFRYAwCCcL8kh1fihZecDSe5Pe2FRux9fSEJB3aC1Rn+U
         4HxLaWOUtGRKC78pFIUSRtgvZQrX/kiv+qLeJswaf00r8mIrEJBcRQ7PdaBNTcqCkFFF
         ebqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eNqc15jZbIj9okPqq1dG85vtgZ8ilG78W0ctJX2WFx0=;
        b=VMBHVCcsUt6r51wZ1RivIx/7B5OMagS5eVxdakTIjKygsxK/Qu3LpvDhF7qEnyR0Hn
         B19tveHarikaHHt0D8AqcyTWWMB8xOuhCAG/WZExlIckXT4qm0yuwwhAZBeBNm+QROMU
         cnLgW5MAVJf6QFh7oY0wX2Ni15jHhSZhDiedZW9mngr2wRoLH6L3K2KaEGGVsDQ9gFgW
         apGUxhHFMYxHyWNcmjZ64LdvewqVHuIGzZVwaKf9/OG7BgvJrgf/3T1nGSuTqZf/Uyys
         fA+uFqpdbpclScD9F05uDlZceSYKdQhFzen5jKogwk1Ufuq5ykAm3X0Ns5mgW+KI9k0d
         YKTA==
X-Gm-Message-State: AOAM5319bqHkZle5RMVAUCgUvWAz+OJjZSgpzbO3S8mA8XM0JrUxm3+D
        n4vF1YbVngQDJsfzJu1oLbtl7QpQ8gM=
X-Google-Smtp-Source: ABdhPJxlR8VJesnyu3CdUJ0p2z8jkP3lv8JInaC85a2LUTF0dFGC/tzRzQpcI5/etaHV9v9bXilFmA==
X-Received: by 2002:a17:90a:8c96:: with SMTP id b22mr27296839pjo.88.1593573871958;
        Tue, 30 Jun 2020 20:24:31 -0700 (PDT)
Received: from ?IPv6:2601:646:8200:a9b8::494? ([2601:646:8200:a9b8::494])
        by smtp.gmail.com with ESMTPSA id u23sm4176376pgn.26.2020.06.30.20.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 20:24:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: drop erroneous mmu_check_root() from
 fast_pgd_switch()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200630100742.1167961-1-vkuznets@redhat.com>
From:   Junaid Shahid <junaids@google.com>
Organization: Google
Message-ID: <a8f60652-c419-58bc-fe78-67954fc6d4c1@google.com>
Date:   Tue, 30 Jun 2020 20:24:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630100742.1167961-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/20 3:07 AM, Vitaly Kuznetsov wrote:
> Undesired triple fault gets injected to L1 guest on SVM when L2 is
> launched with certain CR3 values. It seems the mmu_check_root()
> check in fast_pgd_switch() is wrong: first of all we don't know
> if 'new_pgd' is a GPA or a nested GPA and, in case it is a nested
> GPA, we can't check it with kvm_is_visible_gfn().
> 
> The problematic code path is:
> nested_svm_vmrun()
>    ...
>    nested_prepare_vmcb_save()
>      kvm_set_cr3(..., nested_vmcb->save.cr3)
>        kvm_mmu_new_pgd()
>          ...
>          mmu_check_root() -> TRIPLE FAULT
> 
> The mmu_check_root() check in fast_pgd_switch() seems to be
> superfluous even for non-nested case: when GPA is outside of the
> visible range cached_root_available() will fail for non-direct
> roots (as we can't have a matching one on the list) and we don't
> seem to care for direct ones.
> 
> Also, raising #TF immediately when a non-existent GFN is written to CR3
> doesn't seem to mach architecture behavior.
> 
> Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - The patch fixes the immediate issue and doesn't seem to break any
>    tests even with shadow PT but I'm not sure I properly understood
>    why the check was there in the first place. Please review!
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 76817d13c86e..286c74d2ae8d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4277,8 +4277,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>   	 */
>   	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
>   	    mmu->root_level >= PT64_ROOT_4LEVEL)
> -		return !mmu_check_root(vcpu, new_pgd >> PAGE_SHIFT) &&
> -		       cached_root_available(vcpu, new_pgd, new_role);
> +		return cached_root_available(vcpu, new_pgd, new_role);
>   
>   	return false;
>   }
> 

The check does seem superfluous, so should be ok to remove. Though I think that fast_pgd_switch() really should be getting only L1 GPAs. Otherwise, there could be confusion between the same GPAs from two different L2s.

IIUC, at least on Intel, only L1 CR3s (including shadow L1 CR3s for L2) or L1 EPTPs should get to fast_pgd_switch(). But I am not familiar enough with SVM to see why an L2 GPA would end up there. From a cursory look, it seems that until "978ce5837c7e KVM: SVM: always update CR3 in VMCB", enter_svm_guest_mode() was calling kvm_set_cr3() only when using shadow paging, in which case I assume that nested_vmcb->save.cr3 would have been an L1 CR3 shadowing the L2 CR3, correct? But now kvm_set_cr3() is called even when not using shadow paging, which I suppose is how we are getting the L2 CR3. Should we skip calling fast_pgd_switch() in that particular case?

Thanks,
Junaid
