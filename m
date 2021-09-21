Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223B44134E1
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhIUN5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 09:57:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232981AbhIUN5G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 09:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632232538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hQA2iZmoG8rc7T5ZAkl2Bo9gs+c2W6PH/5qvslbTWg8=;
        b=iSIGKav7BjnLB7pzW3QDf5x2uU7j/NqCMIdyZFSZxQfptwKFB1/b6BzQ4QdSndIWRJFHSd
        EcaZiNNp5S8IlXoJgLAIEIoJg2nTiYIDWsIMnnkkFpQhJlbQISlCVASGtSNhm6fxC50TOS
        I7vUb22yPQ1f8gIpigZtVfitgIqQPMU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-ZfYgzku8MiytJtZbSitLxw-1; Tue, 21 Sep 2021 09:55:37 -0400
X-MC-Unique: ZfYgzku8MiytJtZbSitLxw-1
Received: by mail-wr1-f70.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso7542862wrb.20
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 06:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hQA2iZmoG8rc7T5ZAkl2Bo9gs+c2W6PH/5qvslbTWg8=;
        b=SonfotF8nhHxEo9OqwydaKWGIQpdt+wA+BX12UBz1bQYYVad5JK777fumKJHFJgaV4
         DdddfIAfyhw/tOMzlq4P5WCTqDTjwco6abFxJao8LBNqUQSlIX9mjiHOXb5Br436s5xU
         heoiNU/mcNv2wZ0Y5wRKwT05+NP+CFEhtGFv/5mR6xUUjFAgsC0n5TOcWnfmWhS72Mac
         m6siWRlgC4pobb2JPE/5IcsWWkzAWd2AoXXF9FqAJjixscH175IyaUh188GyYal49NDM
         p5AmgXix4qmVf3mIka+5SD9OrgWTCezzaVid2CabbAnDbp81qzn7wXIV7LHSm+cmEJ5o
         6ZSQ==
X-Gm-Message-State: AOAM532o+a/gPtPCVeaMYjC22/k7LpVSxqhHg7BXVcpyqh4ao0EDMrz9
        kg/jBDfnmwiALXDyqxmsJEqEkvm0vWVAOkfn9SEAY4LnOPDOg6fl5P/fGCD/RQenmIwDNORosF4
        +XZARJKRDuBXM
X-Received: by 2002:adf:ef02:: with SMTP id e2mr34633563wro.401.1632232535250;
        Tue, 21 Sep 2021 06:55:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyMKNkhwCL+W2v5q/hOPNTyhTF55HWavsNXVXZsMneIaIOxpjh23ykSVXLyy3cooWwlJx6Yw==
X-Received: by 2002:adf:ef02:: with SMTP id e2mr34633547wro.401.1632232535047;
        Tue, 21 Sep 2021 06:55:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f19sm3021316wmf.11.2021.09.21.06.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:55:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 02/10] KVM: x86: Clear KVM's cached guest CR3 at
 RESET/INIT
In-Reply-To: <878rzq9gte.fsf@vitty.brq.redhat.com>
References: <20210921000303.400537-1-seanjc@google.com>
 <20210921000303.400537-3-seanjc@google.com>
 <878rzq9gte.fsf@vitty.brq.redhat.com>
Date:   Tue, 21 Sep 2021 15:55:33 +0200
Message-ID: <875yuu9goa.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> Explicitly zero the guest's CR3 and mark it available+dirty at RESET/INIT.
>> Per Intel's SDM and AMD's APM, CR3 is zeroed at both RESET and INIT.  For
>> RESET, this is a nop as vcpu is zero-allocated.  For INIT, the bug has
>> likely escaped notice because no firmware/kernel puts its page tables root
>> at PA=0, let alone relies on INIT to get the desired CR3 for such page
>> tables.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/x86/kvm/x86.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e77a5bf2d940..2cb38c67ed43 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10899,6 +10899,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>  	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>>  	kvm_rip_write(vcpu, 0xfff0);
>>  
>> +	vcpu->arch.cr3 = 0;
>> +	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>
> kvm_register_mark_dirty() is redundant here as PATCH1 does
>
>       vcpu->arch.regs_avail = ~0;
>       vcpu->arch.regs_dirty = ~0;
>
> just a few lines above. The dependency is, however, implicit and this
> patch is marked for stable@ (well, PATCH1 has 8 Fixes: tags so I'd
> expect it to get picked by everyone too, especially by robots) and
> flipping two bits is cheap.

Scratch that, kvm_vcpu_reset() and kvm_arch_vcpu_create() got mixed up
in my head :-(

>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
>> +
>>  	/*
>>  	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
>>  	 * of Intel's SDM list CD/NW as being set on INIT, but they contradict

-- 
Vitaly

