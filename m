Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29884142D4
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhIVHmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233059AbhIVHmq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632296476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FwUnLWRxBbFGXqrWK0WVzYlF4ZD1jUKaBikzITPlQE=;
        b=EQSDpL485IsR3Dxnaws4/jmcwRjuAJEhx8y8UdEuNPchSIVe4Se5bqmspgUkwup3G183GQ
        20wUPRccJzTM4SvqiOPFYdto06JYhfyrAMYmP5VfiS7QqUPiTfXhYo1mnBvXovTFYymNsT
        8MaWLi4yP5/rtQcQg6n3rKqrkyUV9SE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-JqKxcMxbOA2K2mWOZ00h-g-1; Wed, 22 Sep 2021 03:41:15 -0400
X-MC-Unique: JqKxcMxbOA2K2mWOZ00h-g-1
Received: by mail-ed1-f69.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so1990872ede.16
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 00:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4FwUnLWRxBbFGXqrWK0WVzYlF4ZD1jUKaBikzITPlQE=;
        b=rBDcyetVhfEv2MYUxSw/4Sw4zrp/5pkedxlDD1tLp6WLrH0sVCnmbnn1tBKnfBVHFa
         Vby4TV/wbFY5DFg3Iy5aW6TDiRnKfTqU7escVHSxitIpeBygkQ1DRZ3vwZNXfR/0VlOQ
         XkLQpOu4y33X3sD3WzxMYBplnR1HnLa9ocbck6IYksdfM6H6A9lr/IAcNFyW5TA5cyzE
         Kf92Wp6aAwlk7oyEUoIvy8G5UZLCKWWBOMWj5t/PbSVoKi3aELxmrjdieIC+4SdljAUp
         B03Ed/1TjMse+qoiXXPm04GaiNColHyObMC64qayx8SIuykiBOTaa9wq1sQmnw6xyHU+
         Qz7w==
X-Gm-Message-State: AOAM533ReoZgeg12VuNZSrWiXZkTrZu36LfETcr9Pasc6UQ9cd//FWOn
        PhRhhkMBodWMC+qie3VGCKrs333Ugpd/+dvGFe7qqI8GLGdsA/bACItnr+W6Nx3w5z97ohbCbAU
        iSARUXKnUe+3i
X-Received: by 2002:a05:6402:319a:: with SMTP id di26mr40876771edb.84.1632296474118;
        Wed, 22 Sep 2021 00:41:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyDEBgD+rpfIilbzK6lXOJWrkiDbxO9FAIi9c8hMpfth1/eCUhnpGKo4zS/VIS9j2MT2qk3Q==
X-Received: by 2002:a05:6402:319a:: with SMTP id di26mr40876756edb.84.1632296473936;
        Wed, 22 Sep 2021 00:41:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o15sm640446ejj.10.2021.09.22.00.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:41:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Identify vCPU0 by its vcpu_idx instead of
 walking vCPUs array
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210910183220.2397812-1-seanjc@google.com>
 <20210910183220.2397812-3-seanjc@google.com>
 <87czpd2bsi.fsf@vitty.brq.redhat.com> <YUihS9CcTh9m53J6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c12a4ef0-5b20-a81a-26bd-7d29c59ece8d@redhat.com>
Date:   Wed, 22 Sep 2021 09:41:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUihS9CcTh9m53J6@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/21 16:57, Sean Christopherson wrote:
> On Mon, Sep 13, 2021, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>>> Use vcpu_idx to identify vCPU0 when updating HyperV's TSC page, which is
>>> shared by all vCPUs and "owned" by vCPU0 (because vCPU0 is the only vCPU
>>> that's guaranteed to exist).  Using kvm_get_vcpu() to find vCPU works,
>>> but it's a rather odd and suboptimal method to check the index of a given
>>> vCPU.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 86539c1686fa..6ab851df08d1 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>>   				       offsetof(struct compat_vcpu_info, time));
>>>   	if (vcpu->xen.vcpu_time_info_set)
>>>   		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
>>> -	if (v == kvm_get_vcpu(v->kvm, 0))
>>> +	if (!v->vcpu_idx)
>>>   		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>>>   	return 0;
>>>   }
>>
>> " ... instead of walking vCPUs array" in the Subject line is a bit
>> confusing because kvm_get_vcpu() doesn't actually walk anything, it just
>> returns 'kvm->vcpus[i]' after checking that we actually have that many
>> vCPUs. The patch itself is OK, so
> 
> Argh, yes, I have a feeling I wrote the changelog after digging into the history
> of kvm_get_vcpu().
> 
> Paolo, can you tweak the shortlog to:
> 
>    KVM: x86: Identify vCPU0 by its vcpu_idx instead of its vCPUs array entry
> 

Done and queued.  Patch 1 required some further s390 changes.

Paolo

