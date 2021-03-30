Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4787334EF38
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhC3RTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231952AbhC3RSi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 13:18:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617124717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v01LT6NR53cw5ltbY90YAxlkn9C/Al8ezBEHKqiEtxk=;
        b=hjnhhvXIFxmbn1WP4ORQutZN1aPmi2o6Sd0laT7QHIKBTAH0GKmSB3ZtCcVDxZfZ9GGBMA
        /WtSwsZL7BrLEP1Gj8LFULP+uiZg17iVRqKogxUqBUTEf9EldjZgQFebWo4TTjm2wjMesR
        juCFNC/wDCVlzle8L62wiBNf9PKOuls=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-YJwCosvUOFmCC8menX8-hQ-1; Tue, 30 Mar 2021 13:18:35 -0400
X-MC-Unique: YJwCosvUOFmCC8menX8-hQ-1
Received: by mail-wr1-f71.google.com with SMTP id 75so10589020wrl.3
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 10:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v01LT6NR53cw5ltbY90YAxlkn9C/Al8ezBEHKqiEtxk=;
        b=cpCI+z7rVBSGWpqSOjUUJp/hXgD+/LKuu3wqq2MrMqTAgGMoTdAOcUkl5PbmuK03Tx
         5t/+4A9JraPhwqIqkbaTJomom/rw12Hqf4I3fcAfLJ0qSbPtr8PdI1v9mIFJOXFDSLWx
         +6+uAC5JsOO6Jq/bSTYKyxIe981QJZGuqmg8zmeNcXTgr7Cw+9F8cnqzes6cLzfSAhnI
         SRpKAVb9iZIq4PJNPqBZdFj9uqCuHj3k247RR6BUNpx/ANFsUkkOl5VL2TLowtB+kX1/
         MQZ33Xz4AgHkPQcfrsdnlgkyPZM1G2prAl6akB4QyBmNV6N23Jwrqz5VIa8jmCsbDrA3
         3fcA==
X-Gm-Message-State: AOAM530AntTMrOpUsZKR7AZzjW31jOXZDjJeRnVs2rHwBwimfyWULMGj
        NuJwWPLUv9LjcB7noQt2rePbGmzjDPzbS297SyToeDjd3pR2aKdk9tmP4ft954FquS4lS9+72ki
        E5HUYUVhLkKsO
X-Received: by 2002:a1c:bb0b:: with SMTP id l11mr5270249wmf.150.1617124714277;
        Tue, 30 Mar 2021 10:18:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCgrqFHCV65hZmQBKReOEhWl2TarHaFUoCpyJfa8RmI3uvG2gKmdlGvSuGviKXh2hJCKSgnA==
X-Received: by 2002:a1c:bb0b:: with SMTP id l11mr5270230wmf.150.1617124714070;
        Tue, 30 Mar 2021 10:18:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t1sm42307238wry.90.2021.03.30.10.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 10:18:33 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Don't allow TDP MMU to yield when
 recovering NX pages
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210325200119.1359384-1-seanjc@google.com>
 <20210325200119.1359384-4-seanjc@google.com>
 <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com>
 <YF0N5/qsmsNHQeVy@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <addaedc2-2050-06a1-e241-047c6e4c94c3@redhat.com>
Date:   Tue, 30 Mar 2021 19:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YF0N5/qsmsNHQeVy@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 23:25, Sean Christopherson wrote:
> On Thu, Mar 25, 2021, Ben Gardon wrote:
>> On Thu, Mar 25, 2021 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
>>> +static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
>>> +                                            gfn_t end)
>>> +{
>>> +       return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
>>> +}
>>> +static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>>
>> I'm a little leary of adding an interface which takes a non-root
>> struct kvm_mmu_page as an argument to the TDP MMU.
>> In the TDP MMU, the struct kvm_mmu_pages are protected rather subtly.
>> I agree this is safe because we hold the MMU lock in write mode here,
>> but if we ever wanted to convert to holding it in read mode things
>> could get complicated fast.
>> Maybe this is more of a concern if the function started to be used
>> elsewhere since NX recovery is already so dependent on the write lock.
> 
> Agreed.  Even writing the comment below felt a bit awkward when thinking about
> additional users holding mmu_lock for read.  Actually, I should remove that
> specific blurb since zapping currently requires holding mmu_lock for write.
> 
>> Ideally though, NX reclaim could use MMU read lock +
>> tdp_mmu_pages_lock to protect the list and do reclaim in parallel with
>> everything else.
> 
> Yar, processing all legacy MMU pages, and then all TDP MMU pages to avoid some
> of these dependencies crossed my mind.  But, it's hard to justify effectively
> walking the list twice.  And maintaining two lists might lead to balancing
> issues, e.g. the legacy MMU and thus nested VMs get zapped more often than the
> TDP MMU, or vice versa.
> 
>> The nice thing about drawing the TDP MMU interface in terms of GFNs
>> and address space IDs instead of SPs is that it doesn't put
>> constraints on the implementation of the TDP MMU because those GFNs
>> are always going to be valid / don't require any shared memory.
>> This is kind of innocuous because it's immediately converted into that
>> gfn interface, so I don't know how much it really matters.
>>
>> In any case this change looks correct and I don't want to hold up
>> progress with bikeshedding.
>> WDYT?
> 
> I think we're kind of hosed either way.  Either we add a helper in the TDP MMU
> that takes a SP, or we bleed a lot of information about the details of TDP MMU
> into the common MMU.  E.g. the function could be open-coded verbatim, but the
> whole comment below, and the motivation for not feeding in flush is very
> dependent on the internal details of TDP MMU.
> 
> I don't have a super strong preference.  One thought would be to assert that
> mmu_lock is held for write, and then it largely come future person's problem :-)

Queued all three, with lockdep_assert_held_write here.

Paolo

