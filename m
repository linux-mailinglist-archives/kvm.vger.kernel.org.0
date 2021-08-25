Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835C73F7537
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbhHYMlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhHYMli (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 08:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629895252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMyxtwEUZlb94aN0/T0jpLFJOu6zgJORs466FBZFQMw=;
        b=JHcfdiJW45GvgBf7PkOHCVpSHReYWX4VYjRdMwePIUrClKqnQQYWps2gXxbgd5RwDWZLU/
        nqKzXebioCuRFGHWEpRt0TV9RGEAuMEmt0CHHwf2kFO3C1/9ftyLPcTxq7Ab6YtBHVlq/e
        AuZ5dyJw7qacZnTU8SeYLUtddOd3hi8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-mGWBlh00NZSJ_7JoukKzaw-1; Wed, 25 Aug 2021 08:40:50 -0400
X-MC-Unique: mGWBlh00NZSJ_7JoukKzaw-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so5256546wmj.8
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xMyxtwEUZlb94aN0/T0jpLFJOu6zgJORs466FBZFQMw=;
        b=ZnJ4ZTzydRb7LY0UE97WKi6nf9xsUogH7CpgAhi+fM+3iZl6dd++8ggrW7BWMQg6wF
         rAn9xU2xO5QUZt+O2WFkG9JA9Wyni8gYVzbVQRQ7Lv5/Upc+DhhJymUkjh9UvPU91OxC
         /9BhliOgvgIINg/SvlB5Z6XUWUNTGlI2NPQ8EpaxtPxhcFCwXIBXs/Y+Y6J7oM+1nm10
         +40p2FkdWYiKyOvutJEx2pt77gA99K36D/mbC0jhQ+ZkyKFyr1ez4KsAh9idDeb3k2Tm
         BY1x4N8XjJXAnkWrLnnfNAKvWBcejGrjc8eaLoNvnhV2/05DBYUTUuJIf25BKwgv4Wmy
         n5Cg==
X-Gm-Message-State: AOAM5327xcSJ0bimTrIK/UVVQ/M77IKiFkD4CdXzN9W5hLXmwgEeRCmo
        LTi2gTTDvc8P/IL2ACIF/WS5y4D/GBvOIEd2p0wjP5ZA2VXQP5oemC5+SSW6geYF1Psioq5S3kQ
        h+FF/C5eroF4O
X-Received: by 2002:a05:600c:350c:: with SMTP id h12mr9124323wmq.88.1629895249767;
        Wed, 25 Aug 2021 05:40:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl0zbETwjnqK0gsPbIDchodFh6iUVTfzjMdtxa8gI7eXonXM3sT5+eQy7XWPqLCaAGoP2fZA==
X-Received: by 2002:a05:600c:350c:: with SMTP id h12mr9124290wmq.88.1629895249514;
        Wed, 25 Aug 2021 05:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id d8sm22293469wrv.20.2021.08.25.05.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 05:40:47 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: nSVM: temporarly save vmcb12's efer, cr0 and cr4
 to avoid TOC/TOU races
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20210809145343.97685-1-eesposit@redhat.com>
 <20210809145343.97685-3-eesposit@redhat.com>
 <21b14e5711dff386ced705a385f85301761b50a5.camel@redhat.com>
 <YRRcYvLoE+q5/Gbx@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <a47d4ba6-dada-72de-e6be-fb0e50324aaf@redhat.com>
Date:   Wed, 25 Aug 2021 14:40:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YRRcYvLoE+q5/Gbx@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

(Spoiler alert: I am new on all this stuff, so I would like to have some 
clarifications about your suggestion. Thank you in advance)

On 12/08/2021 01:25, Sean Christopherson wrote:
> On Wed, Aug 11, 2021, Maxim Levitsky wrote:
>> On Mon, 2021-08-09 at 16:53 +0200, Emanuele Giuseppe Esposito wrote:
>>> @@ -1336,7 +1335,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>>   	if (!(save->cr0 & X86_CR0_PG) ||
>>>   	    !(save->cr0 & X86_CR0_PE) ||
>>>   	    (save->rflags & X86_EFLAGS_VM) ||
>>> -	    !nested_vmcb_valid_sregs(vcpu, save))
>>> +	    !nested_vmcb_valid_sregs(vcpu, save, save->efer, save->cr0,
>>> +				     save->cr4))
>>>   		goto out_free;
>>>   
>>>   	/*
>> The disadvantage of my approach is that fields are copied twice, once from
>> vmcb12 to its local copy, and then from the local copy to vmcb02, however
>> this approach is generic in such a way that TOC/TOI races become impossible.
>>
>> The disadvantage of your approach is that only some fields are copied and
>> there is still a chance of TOC/TOI race in the future.
> 
> The partial copy makes me nervous too.  I also don't like pulling out select
> registers and passing them by value; IMO the resulting code is harder to follow
> and will be more difficult to maintain, e.g. it won't scale if the list of regs
> to check grows.
> 
> But I don't think we need to copy _everything_.   There's also an opportunity to
> clean up svm_set_nested_state(), though the ABI ramifications may be problematic.
> 
> Instead of passing vmcb_control_area and vmcb_save_area to nested_vmcb_valid_sregs()
> and nested_vmcb_valid_sregs(), pass svm_nested_state and force the helpers to extract
> the save/control fields from the nested state.  If a new check is added to KVM, it
> will be obvious (and hopefully fail) if the state being check is not copied from vmcb12.

I think I understood what you mean here, so basically you propose of 
having svm->nested.save and its helpers similar to copy_vmcb_save_area,
but for now just copy the fields that we want to protect, ie only efer, 
cr0, cr4 and maybe also cr3 (to be consistent with VMCB_CR of clean 
bits). Then pass svm->nested.save instead of vmcb12->save to 
nested_vmcb_valid_sregs() and use it also for 
nested_vmcb02_prepare_save(), to avoid TOC/TOU issues.
At least that's how I understood it.

> 
> Regarding svm_set_nested_state(), if we can clobber svm->nested.ctl and svm->nested.save
> (doesn't exist currently) on a failed ioctl(), then the temporary allocations for those
> can be replaced with using svm->nested as the buffer.

I am not sure what you mean with failed ioctl(), but I guess the meaning 
here is to replace the kzalloc'ed ctl and save variables with these two 
states (nested.save and nested.ctl).

> 
> And to mitigate the cost of copying to a kernel-controlled cache, we should use
> the VMCB Clean bits as they're intended.
> 
>    Each set bit in the VMCB Clean field allows the processor to load one guest
>    register or group of registers from the hardware cache;
> 
> E.g. copy from vmcb12 iff the clean bit is clear.  Then we could further optimize
> nested VMRUN to skip checks based on clean bits.
> 
I looked up the clean fields, so my understanding is that if we do set 
EFER/CR0/CR4 in nested_vmcb02_prepare_save() with nested.save, we don't 
need to check the clean bits because

"The guest's execution can cause cached state to be updated, but the 
hypervisor is not responsible for setting VMCB Clean bits corresponding 
to any state changes caused by guest execution."

and setting the VMCB_CR after copying the vmcb12 save fields into the 
nested state. But I don't think this is what you mean here, especially 
when saying
> copy from vmcb12 iff the clean bit is clear

Thank you,
Emanuele

