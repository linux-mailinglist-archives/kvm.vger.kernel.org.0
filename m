Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9C435890D
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhDHP6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:58:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231923AbhDHP6K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 11:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617897479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACCpYNy34LXQczCbdAnQ7GVKiaThMHFtlrJymfX8bwY=;
        b=SLrALUhaza8cAteLysI47iBGndKAOWVCyjDuE5QkB3gfFYtv2/GzzbknpXjyNLsdZoGqkC
        cLYd1wSt9svJl/kNzX20kghscCFuid8aG5ccig5p6w/jS9cLcoM+Itb4XbuMX9wxMUqGf4
        HFmdzlARCRit50cs0AzqBHttnRPUleg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-Ml_GowOgNFiVoKaIgQDXAQ-1; Thu, 08 Apr 2021 11:57:57 -0400
X-MC-Unique: Ml_GowOgNFiVoKaIgQDXAQ-1
Received: by mail-ej1-f71.google.com with SMTP id gj5so397820ejb.19
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 08:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ACCpYNy34LXQczCbdAnQ7GVKiaThMHFtlrJymfX8bwY=;
        b=HwEJs5RjsGSAoEIWyQeDT+BH01eTet8KZPwhjPf/Y85T3hO1NYPDsTiSyCQOBNETyl
         ZIbMljBwsciYi4Ow0M/idKk+19L+j5QZ9IBgCJ6rzwB73bmSwxmpI2k/nWmt2sO2Xsv4
         gbMYtQju08yMd64bDkGKB7mbw8rFyoYlThYBZmJ+i83yYtqMImB9rpC88NaAIqWNHHDx
         pPGyNBHaHScapnGX6wqMLYeu+HhiJcalekFp/Rd/4dBMsSImUZp7lhcwOnm2L8B2FYH3
         V9s8BOUhXgfru3QPcE3aWZSeahVvjojCaKx8kcTlWaeVPGq3XHUy2wDlCPntjsDviwnt
         BeSQ==
X-Gm-Message-State: AOAM5324zcAPAuo/fBF5vW5la57lyQiifJqRvWieVrFMZqygY3iwwWSB
        0Z+4sxhBvpD3vwCnKK0pnYDtOcJCYYaOpHsbEGlAtVMMjb0U887qxJQ/ONdPjQBiNVXCCRvQkFR
        VIrpFRpIo2Wlj
X-Received: by 2002:a05:6402:549:: with SMTP id i9mr12650714edx.379.1617897476539;
        Thu, 08 Apr 2021 08:57:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV6NWwN+mXHIeXUGOfCO9TR6I7joRCTF+lo5s5DG8sC41x6ccsTzvpalgBRd3zqbwvECvRWg==
X-Received: by 2002:a05:6402:549:: with SMTP id i9mr12650694edx.379.1617897476305;
        Thu, 08 Apr 2021 08:57:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id eo22sm14566576ejc.0.2021.04.08.08.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:57:55 -0700 (PDT)
Subject: Re: [PATCH v2 07/17] KVM: x86/mmu: Check PDPTRs before allocating PAE
 roots
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-8-seanjc@google.com>
 <CANRm+CzUAzR+D3BtkYpe71sHf_nmtm_Qmh4neqc=US2ETauqyQ@mail.gmail.com>
 <f6ae3dbb-cfa5-4d8b-26bf-92db6fc9eab1@redhat.com>
 <YG8lzKqL32+JhY0Z@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b7129ed-0377-7b91-c741-44ac2202081a@redhat.com>
Date:   Thu, 8 Apr 2021 17:57:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YG8lzKqL32+JhY0Z@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 17:48, Sean Christopherson wrote:
> Freaking PDPTRs.  I was really hoping we could keep the lock and pages_available()
> logic outside of the helpers.  What if kvm_mmu_load() reads the PDPTRs and
> passes them into mmu_alloc_shadow_roots()?  Or is that too ugly?

The patch I have posted (though untested) tries to do that in a slightly 
less ugly way by pushing make_mmu_pages_available down to mmu_alloc_*_roots.

Paolo

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index efb41f31e80a..e3c4938cd665 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3275,11 +3275,11 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>          return 0;
>   }
> 
> -static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> +static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu, u64 pdptrs[4])
>   {
>          struct kvm_mmu *mmu = vcpu->arch.mmu;
> -       u64 pdptrs[4], pm_mask;
>          gfn_t root_gfn, root_pgd;
> +       u64 pm_mask;
>          hpa_t root;
>          int i;
> 
> @@ -3291,11 +3291,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> 
>          if (mmu->root_level == PT32E_ROOT_LEVEL) {
>                  for (i = 0; i < 4; ++i) {
> -                       pdptrs[i] = mmu->get_pdptr(vcpu, i);
> -                       if (!(pdptrs[i] & PT_PRESENT_MASK))
> -                               continue;
> -
> -                       if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> +                       if ((pdptrs[i] & PT_PRESENT_MASK) &&
> +                           mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
>                                  return 1;
>                  }
>          }
> @@ -4844,21 +4841,33 @@ EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
> 
>   int kvm_mmu_load(struct kvm_vcpu *vcpu)
>   {
> -       int r;
> +       struct kvm_mmu *mmu = vcpu->arch.mmu;
> +       u64 pdptrs[4];
> +       int r, i;
> 
> -       r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
> +       r = mmu_topup_memory_caches(vcpu, !mmu->direct_map);
>          if (r)
>                  goto out;
>          r = mmu_alloc_special_roots(vcpu);
>          if (r)
>                  goto out;
> +
> +       /*
> +        * On SVM, reading PDPTRs might access guest memory, which might fault
> +        * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
> +        */
> +       if (!mmu->direct_map && mmu->root_level == PT32E_ROOT_LEVEL) {
> +               for (i = 0; i < 4; ++i)
> +                       pdptrs[i] = mmu->get_pdptr(vcpu, i);
> +       }
> +
>          write_lock(&vcpu->kvm->mmu_lock);
>          if (make_mmu_pages_available(vcpu))
>                  r = -ENOSPC;
>          else if (vcpu->arch.mmu->direct_map)
>                  r = mmu_alloc_direct_roots(vcpu);
>          else
> -               r = mmu_alloc_shadow_roots(vcpu);
> +               r = mmu_alloc_shadow_roots(vcpu, pdptrs);
>          write_unlock(&vcpu->kvm->mmu_lock);
>          if (r)
>                  goto out;
> 

