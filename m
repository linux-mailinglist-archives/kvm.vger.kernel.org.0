Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7AF4F8039
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343593AbiDGNPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiDGNPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 724425D662
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 06:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649337183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jgcFIANEmV3DqgP0seVeVyH30NWV2QqOukTsdkt/MFU=;
        b=NTwx+g+QuMWp+kODy4y/k+8GTRhptXSYefangtDTdvVj0GB/jg26xVvNu+D64dDv7PD4sc
        J0Mfh1Lwg9VQytmUI5gRsdPWGDw6RJ1BpYQExvt6Ji7Mrbkn9Typ6XlTDwoDkrfUvIYUpE
        /1AylEIMQcB0KEM8eAifYwLXdaqzDqU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-jo5Fg4mPMi6kqpdwZDfYqQ-1; Thu, 07 Apr 2022 09:13:02 -0400
X-MC-Unique: jo5Fg4mPMi6kqpdwZDfYqQ-1
Received: by mail-ed1-f69.google.com with SMTP id i4-20020aa7c9c4000000b00419c542270dso2943590edt.8
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 06:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jgcFIANEmV3DqgP0seVeVyH30NWV2QqOukTsdkt/MFU=;
        b=6RHE9SSF2Cjy53oIdzh8D6Of0Y4zPijf8DWt5FoeUQfmwj6SBUyDCg5iNbHcqw33mW
         68d5ayuHJwnBoc2y4bIUbKLlhiZOWo5wvqL3D50xXmkMxdHcNoh2gkdG0iHvsRA7BOmE
         8lQ8H5LunHb17rbqw9cxaw9AH2CmKZcPLE/4iPLpOIx4VpnYOWQLLc5ruGkXJUhfMKDZ
         dR+LerKchB4FcBHKaw3mJpFFMkSNgzhMd3qwHL6ey94DRKbgfdLahqQ9bjarA/oZwK1b
         vLXxLRpz7hCkdlX9KOaTsyynri5OedVPxQztjVv5Ym1FE9TnD8zHJeLTg1Y2SMSeEWF5
         hZ0w==
X-Gm-Message-State: AOAM533QkpNDjkjybw/NTFFjlKsFDpZg933ukvFOnSnGpG6Cz59+aQ3P
        K+rpnt738VkBlVMDl7PMvgOjqaJHPTtYvFCaspkvOMNKs87/qx/E6xZMkmxWdut8kL64fIb9KVd
        gF0DFtWq7wKsn
X-Received: by 2002:a05:6402:2681:b0:419:4564:1bd4 with SMTP id w1-20020a056402268100b0041945641bd4mr14180708edd.358.1649337180937;
        Thu, 07 Apr 2022 06:13:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyirsd+HTZRX9NhaFwuw4B/4zFy4Zr6O7O5P+ww+XWhCTiAg+z91MGP9ytIn8PHipyYG95rMA==
X-Received: by 2002:a05:6402:2681:b0:419:4564:1bd4 with SMTP id w1-20020a056402268100b0041945641bd4mr14180678edd.358.1649337180711;
        Thu, 07 Apr 2022 06:13:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s3-20020a1709067b8300b006e4a6dee49dsm7703235ejo.184.2022.04.07.06.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 06:12:59 -0700 (PDT)
Message-ID: <1eac9040-f75f-8838-bd75-521cb666c61a@redhat.com>
Date:   Thu, 7 Apr 2022 15:12:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 083/104] KVM: x86: Split core of hypercall
 emulation to helper function
Content-Language: en-US
To:     Sagi Shahar <sagis@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <f3293bd872a916bf33165a2ec0d6fc50533b817f.1646422845.git.isaku.yamahata@intel.com>
 <CAAhR5DFPsmxYXXXZ9WNW=MDWRRz5jrntPvsnKw7VTrRh5CbohQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhR5DFPsmxYXXXZ9WNW=MDWRRz5jrntPvsnKw7VTrRh5CbohQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 19:32, Sagi Shahar wrote:
> On Fri, Mar 4, 2022 at 12:00 PM <isaku.yamahata@intel.com> wrote:
>>
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> By necessity, TDX will use a different register ABI for hypercalls.
>> Break out the core functionality so that it may be reused for TDX.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  4 +++
>>   arch/x86/kvm/x86.c              | 54 ++++++++++++++++++++-------------
>>   2 files changed, 37 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8dab9f16f559..33b75b0e3de1 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1818,6 +1818,10 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate,
>>   void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
>>                                  unsigned long bit);
>>
>> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>> +                                     unsigned long a0, unsigned long a1,
>> +                                     unsigned long a2, unsigned long a3,
>> +                                     int op_64_bit);
>>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>>
>>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 314ae43e07bf..9acb33a17445 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9090,26 +9090,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>>          return kvm_skip_emulated_instruction(vcpu);
>>   }
>>
>> -int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>> +                                     unsigned long a0, unsigned long a1,
>> +                                     unsigned long a2, unsigned long a3,
>> +                                     int op_64_bit)
>>   {
>> -       unsigned long nr, a0, a1, a2, a3, ret;
>> -       int op_64_bit;
>> -
>> -       if (kvm_xen_hypercall_enabled(vcpu->kvm))
>> -               return kvm_xen_hypercall(vcpu);
>> -
>> -       if (kvm_hv_hypercall_enabled(vcpu))
>> -               return kvm_hv_hypercall(vcpu);

Please keep Xen and Hyper-V hypercalls to kvm_emulate_hypercall (more on 
this in the reply to patch 89).  __kvm_emulate_hypercall should only 
handle KVM hypercalls.

>> +       if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
>> +               ret = -KVM_EPERM;
>> +               goto out;
>> +       }

Is this guaranteed by TDG.VP.VMCALL?

Paolo

>> +       ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit);
>>   out:
>>          if (!op_64_bit)
>>                  ret = (u32)ret;
>> --
>> 2.25.1
>>
> 
> Sagi
> 

