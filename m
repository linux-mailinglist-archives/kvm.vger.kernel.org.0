Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2222E7A4F40
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjIRQgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjIRQgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:36:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AC1266BA;
        Mon, 18 Sep 2023 09:15:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-404539209ffso48708905e9.0;
        Mon, 18 Sep 2023 09:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695053748; x=1695658548; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EvGUhKIFB0rClGn71fMSiVc724KBXgl1Chaez7Tz0KI=;
        b=haUCkjkPp9Rtov3OBXmTT34HkbwuXvp9c05GzxEOYOCPrqTCBTZHofZ+rr++68vQKz
         5M5Rw7F0cDgx7r/nYb+uhl+8lwF9/imCzN9vvEESO/59FmFC7ogGC9JdkyeUsEPId4Xl
         jXWBbZTxWgGtdsHTKRMucZt0QOJgX+KAJ5xaJd+iY9k9hMyrRaP8P5STsTYTFZO7Gx/B
         bBOeNJ1trLMUTBSC/QFRWdBa0obgT6rfKOxOJt1wsuWu3R/zLXVZLN0wFLf1+BoulfG6
         G8VyzO3IqQFElKATMr1vTvmAHpTsU1M66GmmpJUhPsk26tib7GLxwSZI+JBilnv1HAVA
         2g2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053748; x=1695658548;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvGUhKIFB0rClGn71fMSiVc724KBXgl1Chaez7Tz0KI=;
        b=O1D2xQ+NI04/gi1RGIeR+37ceZjnIqJAGpExxPpl+ITqe+PiXN3GG4VLINO005rc3Y
         +28DFL4YYCjgOPVzQMC2DDYi+EVETEm4iTyAaktRXYLitYSHkw2thNkpPndwmrIhp51x
         E4kooTSKp/7SGo4MnQwNsPVW3LBL6LjOP7oqFIifEsDw/Gq1Py0Ijy+FYG8M5nr3PxL/
         C8kN/gjfYnSAvlxWNfLySM4U2bNnNnB5YVGFzSoiu4aPVwfqr2x8BT+o+/yk9BvXMXH2
         4MqFWnzX/r7Ubsw66y4seQE/12AjpsvUMXTJY71UL2I+ee8zB+PTglhK6lFMtZLdVAwV
         La9A==
X-Gm-Message-State: AOJu0Yz3nRfgUJWXne+vaWDpgkJQ4ByDR82mQrQoscZC8w/GEGgNTNv7
        mIzf2J0VRXr2EwNrIgZ0uHhrAfMtLgn2ZMiS
X-Google-Smtp-Source: AGHT+IFs0Rs9N3ZBq+IM1ZtFSg5eriEKRTchzCi7RV3wQzmxhl1REeXw8t4DQ/XGaA22uafrNNRHbA==
X-Received: by 2002:a1c:f717:0:b0:3fe:22fd:1b23 with SMTP id v23-20020a1cf717000000b003fe22fd1b23mr8055588wmh.34.1695053748140;
        Mon, 18 Sep 2023 09:15:48 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c294c00b003fee777fd84sm12791498wmd.41.2023.09.18.09.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 09:15:47 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <7ff44cd2-c1a3-27a1-85cd-675320b4cf46@xen.org>
Date:   Mon, 18 Sep 2023 17:15:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 09/13] KVM: xen: automatically use the vcpu_info
 embedded in shared_info
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230918144111.641369-1-paul@xen.org>
 <20230918144111.641369-10-paul@xen.org>
 <dde3cb9dc2fb26db9d5508c11c6d9dee1505b0df.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <dde3cb9dc2fb26db9d5508c11c6d9dee1505b0df.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 17:07, David Woodhouse wrote:
> On Mon, 2023-09-18 at 14:41 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> The VMM should only need to set the KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
>> attribute in response to a VCPUOP_register_vcpu_info hypercall. We can
>> handle the default case internally since we already know where the
>> shared_info page is. Modify get_vcpu_info_cache() to pass back a pointer
>> to the shared info pfn cache (and appropriate offset) for any of the
>> first 32 vCPUs if the attribute has not been set.
>>
>> A VMM will be able to determine whether it needs to set up default
>> vcpu_info using the previously defined KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA
>> Xen capability flag, which will be advertized in a subsequent patch.
>>
>> Also update the KVM API documentation to describe the new behaviour.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>> ---
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: x86@kernel.org
>>
>> v3:
>>   - Add a note to the API documentation discussing vcpu_info copying.
>>
>> v2:
>>   - Dispense with the KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO capability.
>>   - Add API documentation.
>> ---
>>   Documentation/virt/kvm/api.rst | 22 +++++++++++++++-------
>>   arch/x86/kvm/xen.c             | 15 +++++++++++++++
>>   2 files changed, 30 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index e9df4df6fe48..47bf3db74674 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5442,13 +5442,7 @@ KVM_XEN_ATTR_TYPE_LONG_MODE
>>   
>>   KVM_XEN_ATTR_TYPE_SHARED_INFO
>>     Sets the guest physical frame number at which the Xen shared_info
>> -  page resides. Note that although Xen places vcpu_info for the first
>> -  32 vCPUs in the shared_info page, KVM does not automatically do so
>> -  and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
>> -  explicitly even when the vcpu_info for a given vCPU resides at the
>> -  "default" location in the shared_info page. This is because KVM may
>> -  not be aware of the Xen CPU id which is used as the index into the
>> -  vcpu_info[] array, so may know the correct default location.
>> +  page resides.
>>   
>>     Note that the shared_info page may be constantly written to by KVM;
>>     it contains the event channel bitmap used to deliver interrupts to
>> @@ -5564,12 +5558,26 @@ type values:
>>   
>>   KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
>>     Sets the guest physical address of the vcpu_info for a given vCPU.
>> +  The vcpu_info for the first 32 vCPUs defaults to the structures
>> +  embedded in the shared_info page.
> 
> The above is true only if KVM has KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA.
> You kind of touch on that next, but perhaps the 'if the KVM_...'
> condition should be moved up?
> 
>> +  If the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag is also set in the
>> +  Xen capabilities then the VMM is not required to set this default
>> +  location; KVM will handle that internally. Otherwise this attribute
>> +  must be set for all vCPUs.
>> +
>>     As with the shared_info page for the VM, the corresponding page may be
>>     dirtied at any time if event channel interrupt delivery is enabled, so
>>     userspace should always assume that the page is dirty without relying
>>     on dirty logging. Setting the gpa to KVM_XEN_INVALID_GPA will disable
>>     the vcpu_info.
>>   
>> +  Note that, if the guest sets an explicit vcpu_info location in guest
>> +  memory then the VMM is expected to copy the content of the structure
>> +  embedded in the shared_info page to the new location. It is therefore
>> +  important that no event delivery is in progress at this time, otherwise
>> +  events may be missed.
>>
> 
> That's difficult. It means tearing down all interrupts from passthrough
> devices which are mapped via PIRQs, and also all IPIs.

So those don't honour event channel masking? That seems like a problem.

> 
> The IPI code *should* be able to fall back to just letting the VMM
> handle the hypercall in userspace. But PIRQs are harder. I'd be happier
> if our plan — handwavy though it may be — led to being able to use the
> existing slow path for delivering interrupts by just *invalidating* the
> cache. Maybe we *should* move the memcpy into the kernel, and let it
> lock *both* the shinfo and new vcpu_info caches while it's doing the
> copy? Given that that's the only valid transition, that shouldn't be so
> hard, should it?
> 

No, it just kind of oversteps the remit of the attribute... but I'll try 
adding it and see how messy it gets.

   Paul

>>   KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
>>     Sets the guest physical address of an additional pvclock structure
>>     for a given vCPU. This is typically used for guest vsyscall support.
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index 459f3ca4710e..660a808c0b50 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -491,6 +491,21 @@ static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
>>   
>>   static struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
>>   {
>> +       if (!v->arch.xen.vcpu_info_cache.active && v->arch.xen.vcpu_id < MAX_VIRT_CPUS) {
>> +               struct kvm *kvm = v->kvm;
>> +
>> +               if (offset) {
>> +                       if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
>> +                               *offset = offsetof(struct shared_info,
>> +                                                  vcpu_info[v->arch.xen.vcpu_id]);
>> +                       else
>> +                               *offset = offsetof(struct compat_shared_info,
>> +                                                  vcpu_info[v->arch.xen.vcpu_id]);
>> +               }
>> +
>> +               return &kvm->arch.xen.shinfo_cache;
>> +       }
>> +
>>          if (offset)
>>                  *offset = 0;
>>   
> 

