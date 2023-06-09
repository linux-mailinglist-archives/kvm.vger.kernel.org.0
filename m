Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF99729351
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 10:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbjFIIfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 04:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbjFIIfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 04:35:09 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D8E2737
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 01:34:55 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f642a24555so1853710e87.3
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 01:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686299693; x=1688891693;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WbM628bP3t+SmXXdafEY5TLBtuPvLSscbLIFzAKuHgE=;
        b=V2teVxxEboacjhC2rqBw7AUja6rqjHpgVMATJse5HOKqVNot2dbUroK+6u7jN3qkms
         U8E4jiqQMEH45MuXd7YvrUy02eQsIlC6cW/iZRWsatSrBigX5tcKuLTwQhFhvFZ3ia0B
         OFKr/NTg1uhwuaDG24JpqpQahmI9wODNuQR9/wVaYvr3CvIAV4eR7NdxTIa4DM7YN9gd
         KuNZsZ1l2cLocVW8TjmvlA07aDniWfkCL/Z5NyhA5K4tCU15zREz06bkQ0SSCCGJ/kNp
         8DqoTxJjhOy5tpBuiTFy3Agglk6niyY2fOaUbeaN0i/EWPOezTx/FuPhcaFmRE0uXHHr
         Srpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686299693; x=1688891693;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WbM628bP3t+SmXXdafEY5TLBtuPvLSscbLIFzAKuHgE=;
        b=CgPT2FB33WzyjOyRBXg7dIGt0gxve5xmAHIVCbFAgsRWYN5gQf8ZCYEw3jR2Ht4uKX
         15OZV6xjbMlQ8oIMXIotHrxq5wuqQMSF25CxXELB8Pvg6rmK4s7tlQXMb4QZ6V5aNkae
         9IAtQBwvHnZbcBgCc/FnDp9DqDRKdge/gTOSDHxkn0jtW5t4tdrwe/wSebJn4OAVJzQv
         OAGDUx/n1GQ6UofaBMhBif3vlrmY2t9FWaP83FqgFgCrlLpAjC5YNmxMkbQhJabvUBgn
         SHTbpQTIpUIbJUaoCG3J4aOs1qFUqZTri122pbBRs2tR6Zh5JmtgOHLq+uBT+2/DjVXo
         ZtJQ==
X-Gm-Message-State: AC+VfDxjNMs5svX6IQXLRcDMk3Outj3ij9Aurnta+4NfJOnrPbcWYtQW
        Z0Cp3JzcHKfyeBPZiZ/fsi6lt79ePfYFU4cnglk=
X-Google-Smtp-Source: ACHHUZ5g9kja+sfgeBFikeSnnj4HmfAIckn/3ZOafcbapByPwQMhBJAkda1ZJPQS8rMSCjCKJnp88A==
X-Received: by 2002:a19:5f0e:0:b0:4dd:9f86:859d with SMTP id t14-20020a195f0e000000b004dd9f86859dmr442756lfb.13.1686299693612;
        Fri, 09 Jun 2023 01:34:53 -0700 (PDT)
Received: from ?IPV6:2a02:a31b:2041:8680:1268:c8b0:5fcc:bf13? ([2a02:a31b:2041:8680:1268:c8b0:5fcc:bf13])
        by smtp.gmail.com with ESMTPSA id f2-20020ac25322000000b004f138ab93c7sm462856lfh.264.2023.06.09.01.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 01:34:53 -0700 (PDT)
Message-ID: <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
Date:   Fri, 9 Jun 2023 10:34:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
Content-Language: en-US
To:     "Chen, Jason CJ" <jason.cj.chen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
 <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/23 04:07, Chen, Jason CJ wrote:
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Friday, June 9, 2023 5:38 AM
>> To: Chen, Jason CJ <jason.cj.chen@intel.com>; Christopherson,, Sean
>> <seanjc@google.com>
>> Cc: kvm@vger.kernel.org; android-kvm@google.com; Dmitry Torokhov
>> <dtor@chromium.org>; Tomasz Nowicki <tn@semihalf.com>; Grzegorz Jaszczyk
>> <jaz@semihalf.com>; Keir Fraser <keirf@google.com>
>> Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
>>
>> On 3/14/23 17:29, Jason Chen CJ wrote:
>>> On Mon, Mar 13, 2023 at 09:58:27AM -0700, Sean Christopherson wrote:
>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>> This patch set is part-5 of this RFC patches. It introduces VMX
>>>>> emulation for pKVM on Intel platform.
>>>>>
>>>>> Host VM wants the capability to run its guest, it needs VMX support.
>>>>
>>>> No, the host VM only needs a way to request pKVM to run a VM.  If we
>>>> go down the rabbit hole of pKVM on x86, I think we should take the
>>>> red pill[*] and go all the way down said rabbit hole by heavily paravirtualizing
>> the KVM=>pKVM interface.
>>>
>>> hi, Sean,
>>>
>>> Like I mentioned in the reply for "[RFC PATCH part-1 0/5] pKVM on
>>> Intel Platform Introduction", we hope VMX emulation can be there at
>>> least for normal VM support.
>>>
>>>>
>>>> Except for VMCALL vs. VMMCALL, it should be possible to eliminate all
>>>> traces of VMX and SVM from the interface.  That means no VMCS
>>>> emulation, no EPT shadowing, etc.  As a bonus, any paravirt stuff we
>>>> do for pKVM x86 would also be usable for KVM-on-KVM nested virtualization.
>>>>
>>>> E.g. an idea floating around my head is to add a paravirt paging
>>>> interface for KVM-on-KVM so that L1's (KVM-high in this RFC) doesn't
>>>> need to maintain its own TDP page tables.  I haven't pursued that
>>>> idea in any real capacity since most nested virtualization use cases
>>>> for KVM involve running an older L1 kernel and/or a non-KVM L1
>>>> hypervisor, i.e. there's no concrete use case to justify the development and
>> maintenance cost.  But if the PV code is "needed" by pKVM anyways...
>>>
>>> Yes, I agree, we could have performance & mem cost benefit by using
>>> paravirt stuff for KVM-on-KVM nested virtualization. May I know do I
>>> miss other benefit you saw?
>>
>> As I see it, the advantages of a PV design for pKVM are:
>>
>> - performance
>> - memory cost
>> - code simplicity (of the pKVM hypervisor, first of all)
>> - better alignment with the pKVM on ARM
>>
>> Regarding performance, I actually suspect it may even be the least significant of
>> the above. I guess with a PV design we'd have roughly as many extra vmexits as
>> we have now (just due to hypercalls instead of traps on emulated VMX
>> instructions etc), so perhaps the performance improvement would be not as big
>> as we might expect (am I wrong?).
> 
> I think with PV design, we can benefit from skip shadowing. For example, a TLB flush
> could be done in hypervisor directly, while shadowing EPT need emulate it by destroy
> shadow EPT page table entries then do next shadowing upon ept violation.

Yeah indeed, good point.

Is my understanding correct: TLB flush is still gonna be requested by
the host VM via a hypercall, but the benefit is that the hypervisor
merely needs to do INVEPT?

> 
> Based on PV, with well-designed interfaces, I suppose we can also make some general
> design for nested support on KVM-on-hypervisor (e.g., we can do first for KVM-on-KVM
> then extend to support KVM-on-pKVM and others)

Yep, as Sean suggested. Forgot to mention this too.

> 
>>
>> But the memory cost advantage seems to be very attractive. With the emulated
>> design pKVM needs to maintain shadow page tables (and other shadow
>> structures too, but page tables are the most memory demanding). Moreover,
>> the number of shadow page tables is obviously proportional to the number of
>> VMs running, and since pKVM reserves all its memory upfront preparing for the
>> worst case, we have pretty restrictive limits on the maximum number of VMs [*]
>> (and if we run fewer VMs than this limit, we waste memory).
>>
>> To give some numbers, on a machine with 8GB of RAM, on ChromeOS with this
>> pKVM-on-x86 PoC currently we have pKVM memory cost of 229MB (and it only
>> allows up to 10 VMs running simultaneously), while on Android (ARM) it is afaik
>> only 44MB. According to my analysis, if we get rid of all the shadow tables in
>> pKVM, we should have 44MB on x86 too (regardless of the maximum number of
>> VMs).
>>
>> [*] And some other limits too, e.g. on the maximum number of DMA-capable
>> devices, since pKVM also needs shadow IOMMU page tables if we have only 1-
>> stage IOMMU.
> 
> I may not capture your meaning. Do you mean device want 2-stage while we only
> have 1-stage IOMMU? If so, not sure if there is real use case.
> 
> Per my understanding, if for PV IOMMU, the simplest implementation is just
> maintain 1-stage DMA mapping in the hypervisor as guest most likely just want 
> 1-stage DMA mapping for its device,  so if for IOMMU w/ nested capability meantime
> guest want use its nested capability (e.g., for vSVA), we can further extend the PV
> IOMMU interfaces.

Sorry, I wasn't clear enough. I mean, on the host or guest side we need
just 1-stage IOMMU, but pKVM needs to ensure memory protection. So if
2-stage is available, pKVM can just use it, but if not, currently in
pKVM on Intel we use shadow page tables for that (just as a consequence
of the overall "mostly emulated" design). (So as a result, in
particular, pKVM memory footprint depends on the max number of PCI
devices allowed by pKVM.) And yeah, with a PV IOMMU we can avoid the
need for shadow page tables while still having only 1-stage IOMMU,
that's exactly my point.

> 
>>
>>>
>>>>
>>>> [*] You take the blue pill, the story ends, you wake up in your bed and believe
>>>>     whatever you want to believe. You take the red pill, you stay in wonderland,
>>>>     and I show you how deep the rabbit hole goes.
>>>>
>>>>     -Morpheus
>>>
