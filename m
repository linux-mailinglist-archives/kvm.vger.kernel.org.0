Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670823504FD
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 18:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhCaQr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 12:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234003AbhCaQrs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 12:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617209267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ix2mfUcEg/DOypNDwaacoOT966lSJ+UT8pzFrJ6uHI=;
        b=VTPeHIDD/uPp9CsY4tysGMAe6xtFzZpTYWx0dq2IW5mjsKc0ik6xI/z80di2ozirgxoLIx
        yRy7fPZdZLv0MHj0BeVxgg0rTjImk8q2TzW2nIoG+JogbTZMW5Upyg4IW1FOVXn1mtZR2J
        /3ZEI6JPQoVRtn39GxAzebkkrjrwRM4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-1R0oN_EROkG3nLeeI2OIiQ-1; Wed, 31 Mar 2021 12:47:45 -0400
X-MC-Unique: 1R0oN_EROkG3nLeeI2OIiQ-1
Received: by mail-ej1-f69.google.com with SMTP id au15so1069905ejc.8
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 09:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ix2mfUcEg/DOypNDwaacoOT966lSJ+UT8pzFrJ6uHI=;
        b=WSobn4mbet9oL/WVW2D0m8zUGvizbXAL7wOfDNO+zxDrubko8doqF4jhLLUJ5oNrIQ
         MNMRl0Ss6KFwrFlXhC9Ukzf06/ndjrVVTPI8IGNyE4oEKbfpfprPivU4wK/uSCfG48D5
         zNmjHPasVfNxscbCeSRPQTcNxXFjYc4wugYAWbvoJnide6m5NSCayzi9btbvec/NH0Pt
         WkLQq3c8NCRM16l9IHkO2rYHwPIBoT3FO0Zc1shPTCbgY0cJvBIzTREX1ZOuWeFlIEGn
         RGKUd1RofU7Kruaf4OrlecXxYBJSVm7DGiv21pVNWmRDfQQqJzJJDeeGbabvmPhD9b5T
         9t9A==
X-Gm-Message-State: AOAM530eOhhCoTaOEKu4JhUC72a3QtOFONFdR6/KaFyFhOEkeL+GObMy
        R+ZB5+VxZyHHjWjNUkcH0mSBNl06ddGUwSQK5hQehQLD3yqRSr/gtc6dUCXqkGjUXQmoLtwbkcG
        gHMJTSLWrXgCf
X-Received: by 2002:a17:906:1182:: with SMTP id n2mr4597701eja.234.1617209264755;
        Wed, 31 Mar 2021 09:47:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymG2hf8oxiTqtfGgyXFzM/nXfYjs4CdYmJnVTC5zNGPoNEIpchzu0nS+pvIuCk4GHAjhT9jA==
X-Received: by 2002:a17:906:1182:: with SMTP id n2mr4597673eja.234.1617209264605;
        Wed, 31 Mar 2021 09:47:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p24sm2057269edt.5.2021.03.31.09.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 09:47:43 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
Date:   Wed, 31 Mar 2021 18:47:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGSmMeSOPcjxRwf6@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 18:41, Sean Christopherson wrote:
>> That said, the easiest way to avoid this would be to always update
>> mmu_notifier_count.
> Updating mmu_notifier_count requires taking mmu_lock, which would defeat the
> purpose of these shenanigans.

Okay; I wasn't sure if the problem was contention with page faults in 
general, or just the long critical sections from the MMU notifier 
callbacks.  Still updating mmu_notifier_count unconditionally is a good 
way to break up the patch in two and keep one commit just for the rwsem 
nastiness.

>>> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>>> +	down_write(&kvm->mmu_notifier_slots_lock);
>>> +#endif
>>>   	rcu_assign_pointer(kvm->memslots[as_id], slots);
>>> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>>> +	up_write(&kvm->mmu_notifier_slots_lock);
>>> +#endif
>> Please do this unconditionally, the cost is minimal if the rwsem is not
>> contended (as is the case if the architecture doesn't use MMU notifiers at
>> all).
> It's not the cost, it's that mmu_notifier_slots_lock doesn't exist.  That's an
> easily solved problem, but then the lock wouldn't be initialized since
> kvm_init_mmu_notifier() is a nop.  That's again easy to solve, but IMO would
> look rather weird.  I guess the counter argument is that __kvm_memslots()
> wouldn't need #ifdeffery.

Yep.  Less #ifdefs usually wins. :)

> These are the to ideas I've come up with:
> 
> Option 1:
> 	static int kvm_init_mmu_notifier(struct kvm *kvm)
> 	{
> 		init_rwsem(&kvm->mmu_notifier_slots_lock);
> 
> 	#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> 		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
> 		return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
> 	#else
> 		return 0;
> 	#endif
> 	}

Option 2 is also okay I guess, but the simplest is option 1 + just init 
it in kvm_create_vm.

Paolo

