Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED7442F799
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbhJOQEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:04:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhJOQEW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 12:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634313735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=699f+9o27CaSy+d/5EA2EABTaD/xyiI7eDXQXNgUQcg=;
        b=SwejX5+8DLRpaUMfiPq4HBfg0grZft1zoDuRdDY2gaVXHuTkp4QPolJhmPAVsi4VswKqxU
        z4bWJ78LX/9ni3wkQUL2r6vwtg8zaO8xcofw1vGVWXtqJpAayUhyATdSDNgTd+t51jvfK4
        xnlQsxzluyYQHq5GMwdJ+6JmlNcjO3k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171---XBY2blMNK8hLn6O1Gj2g-1; Fri, 15 Oct 2021 12:02:14 -0400
X-MC-Unique: --XBY2blMNK8hLn6O1Gj2g-1
Received: by mail-ed1-f69.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso8587541edj.20
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=699f+9o27CaSy+d/5EA2EABTaD/xyiI7eDXQXNgUQcg=;
        b=hBNPJhz0UGAX4X8HsnPIJ+EFFt3Qi3Aze1QgiiJaBZEliZNzYca/akAWvC1i3STSUr
         7W9DsNW1SWq4pKpgD/Uqs4WWfBeXHaKIySo2HQ+Klzu02uhQuYcLuD9lG3brByzarb/l
         KQnJKH3l7IzzryQfQv9dZ1+SIegta+Se7BNlFpVp3jK9jSPznKkRFXRZ16KT1nuBSXpx
         03vowZAu1sslf7d5n3jlgJQdf/yZR41H80s5eH/GcxWbI3gG658Kfl6yfJ+UNBu5fCMV
         ZZ1UmdGqwIzas97dntskmuTT+oqwT5v9ODGl6KKTDybe9tQrADSdAc+b3iS9uuSD3e2g
         PAUg==
X-Gm-Message-State: AOAM530e1gjBu7Ca8ttD7JPQUUOf2f4dq6eQzDbqeEu3Un3OS1YHsHXc
        ZknCUsRIicuVxCxH/1cVTnukefqHQC81baItMh64zbT/W3E7WvzUivXsVAQn2x5eS9bFXykq74s
        mfFugvlTOlI6l
X-Received: by 2002:a05:6402:35d1:: with SMTP id z17mr19175817edc.174.1634313733074;
        Fri, 15 Oct 2021 09:02:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqp+j9bpOYpwYZKAs+Ei0eJjowegexu/k6je51phECReV1K/H2oUuvlvSgKHt9YptqWThiXQ==
X-Received: by 2002:a05:6402:35d1:: with SMTP id z17mr19175792edc.174.1634313732847;
        Fri, 15 Oct 2021 09:02:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y22sm5566150edc.76.2021.10.15.09.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:02:12 -0700 (PDT)
Message-ID: <d2a735cc-4d08-7b87-48b3-5e803f1fdec7@redhat.com>
Date:   Fri, 15 Oct 2021 18:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/2] KVM: X86: Don't reset mmu context when changing PGE
 or PCID
Content-Language: en-US
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
References: <20210919024246.89230-1-jiangshanlai@gmail.com>
 <506c12c4-4a56-bcbf-a566-a3e75c0814aa@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <506c12c4-4a56-bcbf-a566-a3e75c0814aa@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 18:03, Lai Jiangshan wrote:
> Ping
> 
> On 2021/9/19 10:42, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> This patchset uses kvm_vcpu_flush_tlb_guest() instead of 
>> kvm_mmu_reset_context()
>> when X86_CR4_PGE is changed or X86_CR4_PCIDE is changed 1->0.
>>
>> Neither X86_CR4_PGE nor X86_CR4_PCIDE participates in kvm_mmu_role, so
>> kvm_mmu_reset_context() is not required to be invoked.  Only flushing tlb
>> is required as SDM says.
>>
>> The patchset has nothing to do with performance, because the overheads of
>> kvm_mmu_reset_context() and kvm_vcpu_flush_tlb_guest() are the same.  And
>> even in the [near] future, kvm_vcpu_flush_tlb_guest() will be optimized,
>> the code is not in the hot path.
>>
>> This patchset makes the code more clear when to reset the mmu context.
>> And it makes KVM_MMU_CR4_ROLE_BITS consistent with kvm_mmu_role.
>>
>> Lai Jiangshan (2):
>>    KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
>>    KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
>>
>>   arch/x86/kvm/mmu.h | 5 ++---
>>   arch/x86/kvm/x86.c | 7 +++++--
>>   2 files changed, 7 insertions(+), 5 deletions(-)
>>
> 

Queued with kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu) replacement, 
thanks.

Paolo

