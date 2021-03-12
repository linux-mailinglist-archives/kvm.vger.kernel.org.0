Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6A3395EF
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 19:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhCLSMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 13:12:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232686AbhCLSMT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 13:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615572739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FEwm7dbFA9YEtIy6iLHK/1/1xLzzzQXYHGmPoA51kGY=;
        b=Z6xWg19dCUVYQWfzWDdNkaNCXeOG2uvNmCX3I9TE3x1c/plBsnqiG3ZkRpfFurUhfVoUUW
        zGI2vG1CR57vIaus8tfmVuSrtPTozbS0S1wn8MQ7cx9N6cdxPwhTG0opz0iYVNd2sh5KqE
        JLesZW+lpDg8VFSpNvbrUtZaS78FVUE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-3ImRkeclMmKkgplX4k4p6w-1; Fri, 12 Mar 2021 13:12:17 -0500
X-MC-Unique: 3ImRkeclMmKkgplX4k4p6w-1
Received: by mail-wm1-f72.google.com with SMTP id n17so2247965wmi.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 10:12:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FEwm7dbFA9YEtIy6iLHK/1/1xLzzzQXYHGmPoA51kGY=;
        b=ereL8UnjPl4j3bWr5mzBz+4kS8YaPBImUg5OlMhOI6qdlcvi6GVx2QIWKokDbsiQyJ
         yylu5ckcZWXBESYIiWznTfATxleZIRULdCaoA27dEgXMNVJlEsDls6AobPeYhb36HSpo
         w+m84al0aaSl3wmFldZus0w13WJoCsuQBcslNiVl8tDQ6ccEpzS6ELVMf3uVHJNdOUTG
         iq7SZoQyAEldIgZ1KFqSSkrBeqH6eUQxfCtwNIFLhhgw39pDf9DSX9k+wwapeP1efXeK
         6gXWFEQvZ8JAOsY0tv+iesHFXg3QcODkb6r32oD1V2kIYspznhkEkhy0Th6TZHbIFQtS
         ORmg==
X-Gm-Message-State: AOAM530jozSVskG8dyP2G0bSEFuWPHNIDIdnjIRaiQZUuWE/EqRE6KcK
        HDxT8dYfHGVmeI1ed1CBqF3kTH5LIkx/Nz67+kLSnoA1efsPYncb3dygSYkwW9s6H21fnqcxB8C
        gtt4MIVdb2F0l
X-Received: by 2002:a7b:cc84:: with SMTP id p4mr14411435wma.10.1615572736320;
        Fri, 12 Mar 2021 10:12:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztaR9pls6kz3Lfs5bJVbE2dnEL9uu98jcGBYdpHNScOrUa5G4QFWGNdLiPxHzLFm5fa/OULw==
X-Received: by 2002:a7b:cc84:: with SMTP id p4mr14411425wma.10.1615572736164;
        Fri, 12 Mar 2021 10:12:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q4sm3154713wma.20.2021.03.12.10.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:12:15 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Skip !MMU-present SPTEs when removing SP in
 exclusive mode
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210310003029.1250571-1-seanjc@google.com>
 <07cf7833-c74a-9ae0-6895-d74708b97f68@redhat.com>
 <YEk2kBRUriFlCM62@google.com>
 <CANgfPd9WS+ntjdh87Gk97MQq6FYNUk8KVE3jQYfmgr2mFb3Stw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c62c7635-48a8-dbc8-748e-188d402fd241@redhat.com>
Date:   Fri, 12 Mar 2021 19:12:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9WS+ntjdh87Gk97MQq6FYNUk8KVE3jQYfmgr2mFb3Stw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/21 23:24, Ben Gardon wrote:
> On Wed, Mar 10, 2021 at 1:14 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Mar 10, 2021, Paolo Bonzini wrote:
>>> On 10/03/21 01:30, Sean Christopherson wrote:
>>>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>>>> index 50ef757c5586..f0c99fa04ef2 100644
>>>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>>>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>>>> @@ -323,7 +323,18 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
>>>>                              cpu_relax();
>>>>                      }
>>>>              } else {
>>>> +                   /*
>>>> +                    * If the SPTE is not MMU-present, there is no backing
>>>> +                    * page associated with the SPTE and so no side effects
>>>> +                    * that need to be recorded, and exclusive ownership of
>>>> +                    * mmu_lock ensures the SPTE can't be made present.
>>>> +                    * Note, zapping MMIO SPTEs is also unnecessary as they
>>>> +                    * are guarded by the memslots generation, not by being
>>>> +                    * unreachable.
>>>> +                    */
>>>>                      old_child_spte = READ_ONCE(*sptep);
>>>> +                   if (!is_shadow_present_pte(old_child_spte))
>>>> +                           continue;
>>>>                      /*
>>>>                       * Marking the SPTE as a removed SPTE is not
> 
> This optimization also makes me think we could also skip the
> __handle_changed_spte call in the read mode case if the SPTE change
> was !PRESENT -> REMOVED.
> 
Yes, I think so.  It should be a separate patch anyway, so I've queued 
this one.

Paolo

