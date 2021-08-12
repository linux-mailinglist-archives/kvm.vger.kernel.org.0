Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959813EA7A7
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbhHLPi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:38:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235631AbhHLPi0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 11:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628782680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByUoQOtxeYxFzmcMgIXeMfGeccgiL3xQnZZbAvg/590=;
        b=JEgCoVzjHYKo5xzMVmEBrJdriuTaQuq12M+paEVGiIB0bogkXScjfe1AcLJ/rdGyZllDwY
        NT+9fjTyr44N7UTSObOeElYPi8YDdrCtoDSIym06hb0WS95bIbQacivE845rZjB00UNybc
        aIDnsyb/l+tnd6wR9T/STV/1m05zoo4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-QIPt6lTTNJqQMx4IkKC6LQ-1; Thu, 12 Aug 2021 11:37:59 -0400
X-MC-Unique: QIPt6lTTNJqQMx4IkKC6LQ-1
Received: by mail-ej1-f70.google.com with SMTP id k22-20020a1709061596b02905a370b2f477so1973612ejd.17
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 08:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ByUoQOtxeYxFzmcMgIXeMfGeccgiL3xQnZZbAvg/590=;
        b=HYA0HDprCcI0EIvTAVgLKuOmo0jg4yf1O7Xa2EwvVw3RnYtPvvy/pBt+ugazfTcZwQ
         Iz81L2Hiaor8PctMCZ6JbDzu7XZdAN/PaUCekQ6krWfT8w1LEO81E4q/QYsRMa8Minnp
         yx1PjYAZLYawVOaV0Q9bPEBmS1/XVlqeZikKuILIqy5JNbiE9snaa54epAohvH3az/sq
         3XlvoYGaGfP3ZsZnLFS9PxSDrI4/1NXrh/36MDH5G8spzX1WI2PxPEWUiZtXh7HZj1h0
         MuozmspQG5yKip+0b851DXq4X7MsetbXda3fEEELJceEHuyrNwYB8QCWeXqg0VWu6uV2
         T5pw==
X-Gm-Message-State: AOAM531hAa2BG9mdRhBYYOLh3Yf/HW5u8CozuZtsxVz77Vb3gQyGtxtW
        qtE+X+zKJz3mcaVAbmo3o8Oqf5ZVtf/mAZB/uJRZ6PqS4n3X7Xlt5iWK4CbvOfm2ntclJ1NRUjl
        8Ro4Wq8xddk65
X-Received: by 2002:aa7:d40f:: with SMTP id z15mr6179057edq.113.1628782678030;
        Thu, 12 Aug 2021 08:37:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+3q2i97Ek3hR3UQ1VhW4AN51TdDvstEeNblLjcEoh3VkQBDKRob9YTlUFKgqA+9J1ZKEHdA==
X-Received: by 2002:aa7:d40f:: with SMTP id z15mr6179026edq.113.1628782677771;
        Thu, 12 Aug 2021 08:37:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v1sm1282779edx.69.2021.08.12.08.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:37:56 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Protect marking SPs unsync when using
 TDP MMU with spinlock
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210810224554.2978735-1-seanjc@google.com>
 <20210810224554.2978735-2-seanjc@google.com>
 <74bb6910-4a0c-4d2f-e6b5-714a3181638e@redhat.com>
 <YRPyLagRbw5QKoNc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <591a0b05-da95-3782-0a71-2b9bb7875b7f@redhat.com>
Date:   Thu, 12 Aug 2021 17:37:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRPyLagRbw5QKoNc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/21 17:52, Sean Christopherson wrote:
> All that said, I do not have a strong preference.  Were you thinking something
> like this?

Yes, pretty much this.

Paolo

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d574c68cbc5c..b622e8a13b8b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2595,6 +2595,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
>   {
>          struct kvm_mmu_page *sp;
> +       bool locked = false;
> 
>          /*
>           * Force write-protection if the page is being tracked.  Note, the page
> @@ -2617,9 +2618,34 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
>                  if (sp->unsync)
>                          continue;
> 
> +               /*
> +                * TDP MMU page faults require an additional spinlock as they
> +                * run with mmu_lock held for read, not write, and the unsync
> +                * logic is not thread safe.  Take the spinklock regardless of
> +                * the MMU type to avoid extra conditionals/parameters, there's
> +                * no meaningful penalty if mmu_lock is held for write.
> +                */
> +               if (!locked) {
> +                       locked = true;
> +                       spin_lock(&kvm->arch.mmu_unsync_pages_lock);
> +
> +                       /*
> +                        * Recheck after taking the spinlock, a different vCPU
> +                        * may have since marked the page unsync.  A false
> +                        * positive on the unprotected check above is not
> +                        * possible as clearing sp->unsync_must_  hold mmu_lock
> +                        * for write, i.e. unsync cannot transition from 0->1
> +                        * while this CPU holds mmu_lock for read.
> +                        */
> +                       if (READ_ONCE(sp->unsync))
> +                               continue;
> +               }
> +
>                  WARN_ON(sp->role.level != PG_LEVEL_4K);
>                  kvm_unsync_page(vcpu, sp);
>          }
> +       if (locked)
> +               spin_unlock(&kvm->arch.mmu_unsync_pages_lock);

