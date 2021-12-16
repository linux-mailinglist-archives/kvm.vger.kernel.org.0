Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A564766E1
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 01:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhLPASi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 19:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhLPASh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 19:18:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9507C061574
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 16:18:37 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p18so3095662pld.13
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 16:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=12acYCetQRkadXAt78bNPDY/1yEzc/dIJkzGEchLwxU=;
        b=aaofHOLcUncS2SNXU31rMljIYTAYT/QugTajTX8ZCo7Eu7WbNZLKHMB2sSBHpRwV2M
         RYMcea2wxzA0ZD+cj+2NwDQtpZ5Y00L+RvdSqYX6NfpzgvPv8yVKCJ2Q6JMnR0Yk+5sr
         drTWQsRJzLSLu70wIG1Y90lboIfT3+UYm6YnTxFXG6PMdImbE6Ud+4BM+YQufY2BDuit
         /pNyLlNuZr812a5WNZN8WseStado5YOY7dHS4JrXJ4HHzSLN9nPLeE2CEH2taGbjpm4A
         UvMCU2zoyd8xg3ys6rGRFAHmTw6Dk7ZNxxG9iAUQGOzRzCeFE4zHiAvVSG4w5FZGm5Ch
         8KDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=12acYCetQRkadXAt78bNPDY/1yEzc/dIJkzGEchLwxU=;
        b=M8jF9SGwsqHret/vMoSEnzzdgg86f0nWnkUX3zcv12wnDVIw4/mtFl1mLZae5lSYOH
         9CgyALznq4m1NBIGlaAu5ffjAgPkgJZGu09zSGYcL1OBbMVk2eFJTUhlCAapTJ1WuWJx
         FwSugYCKw5xmUCQhc5vLu0KDLXhb1W+u56VyU3hkgNnhioMxvutzjTNhpfVGH3vw7wJB
         n9tW585LPRMio8bm1ruXS4wcChubWJH/lXw+DsLbotcg74FIztSMx/hsEeBwWLdKp7Va
         Wgh+dL3FiAZAtS0/vmiQfgeBX/A7oBJDE9BI7O6SIPr7SRhUVgpcSAe0PQ+AupXfil0t
         eSig==
X-Gm-Message-State: AOAM532ruXP1DuljIoBHeSkVbHBc7FhHk6oNpzzIVzBZpcN8NZc0iL/5
        u6wVXNSuWNObYmOq6ODcxo+9vA==
X-Google-Smtp-Source: ABdhPJzPNxK1oq85AH/hqP+Om1O8IvgIkG2eeQhRQWk+8WHMmAp8DBpO7W2sP6qjHBFhpa2IhWm59g==
X-Received: by 2002:a17:90b:1e45:: with SMTP id pi5mr2835967pjb.146.1639613917373;
        Wed, 15 Dec 2021 16:18:37 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id 63sm3703763pfz.119.2021.12.15.16.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 16:18:37 -0800 (PST)
Message-ID: <d7f13a46-b560-5943-22d2-123b698d88c6@linaro.org>
Date:   Wed, 15 Dec 2021 16:18:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
References: <20211214232039.851405-1-tadeusz.struk@linaro.org>
 <Ybp0naX/ZTG9FNEa@google.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <Ybp0naX/ZTG9FNEa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 15:05, Sean Christopherson wrote:
>> @@ -174,7 +174,7 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>   		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> Isn't this code flat out wrong?  vm_pgoff is usually the offset relative to the
> file and has nothing to do with the pfn.  I see that remap_pfn_range_notrack()
> stuffs "vma->vm_pgoff = pfn", but that's a weird quirk of that particular usage
> of VM_PFNMAP that I'm guessing happened to align with the original usage of this
> mess.  But unless there's magic I'm missing, vm_pgoff is not guaranteed to have
> any relation to the pfn for any ol' VM_PFNMAP vma.
> 
> In other words, I suspect pfn and paddr are complete garbage, and adding the
> access_ok() check masks that.
> 

The answer to your question might be in the commit message of the original
commit that added this code:

bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")

-- 
Thanks,
Tadeusz
