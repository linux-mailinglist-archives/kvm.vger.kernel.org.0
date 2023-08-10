Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB411777BF1
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 17:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbjHJPQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 11:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbjHJPQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 11:16:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D610926A6
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 08:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691680553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/GLt4SKbOWTUuFGKog9UjUW6qvoR+8JSI2aZa7coSRQ=;
        b=G1Bz93KqowZscKFjPfd7XTzTnBObL+HEX9/UGpBcdXyFGyOZB/Y31ChHalxbObzgTKPAzC
        hoS6KQcpiUh+Aa6fjTPq7wZoI0OdVanxUCHAoJoHFTauy1X1sOhS6GdTcvOnXIrmt1NCnU
        ZWJfiFX9NLFhsZ/7BXKoDCdYVlGmpy0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-9Cc8_CiVMxKMB5xQrtJYBQ-1; Thu, 10 Aug 2023 11:15:46 -0400
X-MC-Unique: 9Cc8_CiVMxKMB5xQrtJYBQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31955c0e2adso124491f8f.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 08:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691680537; x=1692285337;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GLt4SKbOWTUuFGKog9UjUW6qvoR+8JSI2aZa7coSRQ=;
        b=lA8nQpnGdClhOE9WoL6OkT7YVhtYDNb06gJ2M8B8k6S+fw1mwqn8mVCZNpgkk5FV8W
         ZY4lfF0YOGCNxgxiW8d/FWV3MOqu7Gc3Idrx2CawpaJDnxIB2aHRr1blEFb2cD0UwoTD
         Ypiq66QTHKBHzyPsfORa8DPZFsVDJMT/Tj+apkseIT/i4DSuIvII/FW5KcOwgnSVvRMB
         i39VL8VvAZaZS9whukNLHbSUcqi/GFLfRUHPXlEhu7GM+kCt4aCnDnfDDIOwc3C1YIDw
         MHfSMGzPfciYDh4aNYDcQQA2HSnZW9/v9Sc2waBOQfg/HWc6IvyfTNHN5Zmc/BXFrsCU
         Smlg==
X-Gm-Message-State: AOJu0Yy3dFZ2TyTSkkVxROMGsq8oiVq0umzbBWP5GqanlPqt4pKZbfzr
        svUEHK8VD93X/jh7PP5fxsBTzO/gOx5dzS40W0c8RhtvA8Yjnrsn7gOnYE5Qix0tZCw9Ar47dTr
        rEHd6SHc1Seqe
X-Received: by 2002:adf:e7ca:0:b0:315:9fb7:bd9 with SMTP id e10-20020adfe7ca000000b003159fb70bd9mr2223591wrn.69.1691680536939;
        Thu, 10 Aug 2023 08:15:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfwRc5qUu6WRjHg9NbGS1VhTF6M2WGgugZwlRoDfWhCw2MrhbDVTNyBo5CirmVsz7c8vp8Pg==
X-Received: by 2002:adf:e7ca:0:b0:315:9fb7:bd9 with SMTP id e10-20020adfe7ca000000b003159fb70bd9mr2223576wrn.69.1691680536584;
        Thu, 10 Aug 2023 08:15:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i7-20020a5d5587000000b00314172ba213sm2443912wrv.108.2023.08.10.08.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 08:15:35 -0700 (PDT)
Message-ID: <8396a9f6-fbc4-1e62-b6a9-3df568fd15a2@redhat.com>
Date:   Thu, 10 Aug 2023 17:15:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
 <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
 <c871cc44-b6a0-06e3-493b-33ddf4fa6e05@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
In-Reply-To: <c871cc44-b6a0-06e3-493b-33ddf4fa6e05@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/23 16:29, Dave Hansen wrote:
> On 8/10/23 02:29, Yang, Weijiang wrote:
> ...
>> When KVM enumerates shadow stack support for guest in CPUID(0x7,
>> 0).ECX[bit7], architecturally it claims both SS user and supervisor
>> mode are supported. Although the latter is not supported in Linux,
>> but in virtualization world, the guest OS could be non-Linux system,
>> so KVM supervisor state support is necessary in this case.
> 
> What actual OSes need this support?

I think Xen could use it when running nested.  But KVM cannot expose 
support for CET in CPUID, and at the same time fake support for 
MSR_IA32_PL{0,1,2}_SSP (e.g. inject a #GP if it's ever written to a 
nonzero value).

I suppose we could invent our own paravirtualized CPUID bit for 
"supervisor IBT works but supervisor SHSTK doesn't".  Linux could check 
that but I don't think it's a good idea.

So... do, or do not.  There is no try. :)

>> Two solutions are on the table:
>> 1) Enable CET supervisor support in Linux kernel like user mode support.
> 
> We _will_ do this eventually, but not until FRED is merged.  The core
> kernel also probably won't be managing the MSRs on non-FRED hardware.
> 
> I think what you're really talking about here is that the kernel would
> enable CET_S XSAVE state management so that CET_S state could be managed
> by the core kernel's FPU code.

Yes, I understand it that way too.

> That is, frankly, *NOT* like the user mode support at all.

I agree.

>> 2) Enable support in KVM domain.
>>
>> Problem:
>> The Pros/Cons for each solution(my individual thoughts):
>> In kernel solution:
>> Pros:
>> - Avoid saving/restoring 3 supervisor MSRs(PL{0,1,2}_SSP) at vCPU
>>    execution path.
>> - Easy for KVM to manage guest CET xstate bits for guest.
>> Cons:
>> - Unnecessary supervisor state xsaves/xrstors operation for non-vCPU
>>    thread.
> 
> What operations would be unnecessary exactly?

Saving/restoring PL0/1/2_SSP when switching from one usermode task's 
fpstate to another.

>> KVM solution:
>> Pros:
>> - Not touch current kernel FPU management framework and logic.
>> - No extra space and operation for non-vCPU thread.
>> Cons:
>> - Manually saving/restoring 3 supervisor MSRs is a performance burden to
>>    KVM.
>> - It looks more like a hack method for KVM, and some handling logic
>>    seems a bit awkward.
> 
> In a perfect world, we'd just allocate space for CET_S in the KVM
> fpstates.  The core kernel fpstates would have
> XSTATE_BV[13]==XCOMP_BV[13]==0.  An XRSTOR of the core kernel fpstates
> would just set CET_S to its init state.

Yep.  I don't think it's a lot of work to implement.  The basic idea as 
you point out below is something like

#define XFEATURE_MASK_USER_DYNAMIC XFEATURE_MASK_XTILE_DATA
#define XFEATURE_MASK_USER_OPTIONAL \
     (XFEATURE_MASK_DYNAMIC | XFEATURE_MASK_CET_KERNEL)

where XFEATURE_MASK_USER_DYNAMIC is used for xfd-related tasks 
(including the ARCH_GET_XCOMP_SUPP arch_prctl) but everything else uses 
XFEATURE_MASK_USER_OPTIONAL.

KVM would enable the feature by hand when allocating the guest fpstate. 
Disabled features would be cleared from EDX:EAX when calling 
XSAVE/XSAVEC/XSAVES.

> But I suspect that would be too much work to implement in practice.  It
> would be akin to a new lesser kind of dynamic xstate, one that didn't
> interact with XFD and *NEVER* gets allocated in the core kernel
> fpstates, even on demand.
> 
> I want to hear more about who is going to use CET_S state under KVM in
> practice.  I don't want to touch it if this is some kind of purely
> academic exercise.  But it's also silly to hack some kind of temporary
> solution into KVM that we'll rip out in a year when real supervisor
> shadow stack support comes along.
> 
> If it's actually necessary, we should probably just eat the 24 bytes in
> the fpstates, flip the bit in IA32_XSS and move on.  There shouldn't be
> any other meaningful impact to the core kernel.

If that's good to you, why not.

Paolo

