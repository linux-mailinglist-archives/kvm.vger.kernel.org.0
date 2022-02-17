Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AC04BA3FD
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbiBQPHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:07:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238916AbiBQPHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:07:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84D7E25B2D4
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645110439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFSOR5Tcp5Zr84hEbE+k+4Qy9iD42HSTK7sgtEU/6PM=;
        b=Os8rOc5eqWVn6A2qtwojoQOFZ+O56RtWNTIx5bU1pz9iQjBQLMx61y09mzC7bIw3ax2ruO
        tM7jfTsEsX4lE/DpCEm/Y/R2+k8DAJntRn0CkYM9ynsPCwdjqjJTiDqiiw0acyx5ut/VMi
        lEfIwLcSkzNZXd9DUq9SkgFroDOTK7c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-3npDhJl5N0yhPHEzcK4LfA-1; Thu, 17 Feb 2022 10:07:18 -0500
X-MC-Unique: 3npDhJl5N0yhPHEzcK4LfA-1
Received: by mail-ej1-f72.google.com with SMTP id ky6-20020a170907778600b0068e4bd99fd1so1643637ejc.15
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:07:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qFSOR5Tcp5Zr84hEbE+k+4Qy9iD42HSTK7sgtEU/6PM=;
        b=Wdz4FGiXqYD5dYtkYRqJFjPuYavO5UAM1DbKcpbCP+kQh29otM7SZkKbi+Zc5Q1jxJ
         3KTlFidow66u+OiLat7l/ohvPqMdqf+hBGfmZVdhPCesouZnLm/EyJxW7e7Gub4cwaVr
         idvG9CUplkI67k98eQWiMIBzIAROSRiIHtW86xGtO3Iiud2RAxusYMn2jxrKD8umo6vX
         OnrSMhwqNULPDsjg+BC7KB7yiskdU4N7AcdOJ8/aPUPAlsw3vG55Juzwdp81dJl6b8EM
         uNeiftkrOrHWGb/jltUjFS6cIphVZY5HROlTJdt/mlTzcWyv9m6AZ0HGz+smij1NyGEz
         ORRg==
X-Gm-Message-State: AOAM530AdBNfMwDBMOf6Ke+w73SPqkW6NA7pBV/hd6UNgqXJQ75FYAZd
        9Uw1WD26nSmy424USIO/PxnDiV1Cv8e/5KkOrFhTI9gtiRocsAyi37cKnmNOwzJAPIaNUw/I1tq
        fbv94hh3pFiNy
X-Received: by 2002:a17:906:3104:b0:6ce:6b85:ecc9 with SMTP id 4-20020a170906310400b006ce6b85ecc9mr2636467ejx.339.1645110437080;
        Thu, 17 Feb 2022 07:07:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzANKo7hcVxixfL7sOwJBypOhLvl1k3r71hqgukS7AJAyKh1nYcS5xz9etrTRJFPRrNrgRSxA==
X-Received: by 2002:a17:906:3104:b0:6ce:6b85:ecc9 with SMTP id 4-20020a170906310400b006ce6b85ecc9mr2636451ejx.339.1645110436820;
        Thu, 17 Feb 2022 07:07:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m4sm1295147ejl.45.2022.02.17.07.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 07:07:15 -0800 (PST)
Message-ID: <f9b79015-1d5c-565e-ccf9-3d81592c17e5@redhat.com>
Date:   Thu, 17 Feb 2022 16:07:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/2] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
Content-Language: en-US
To:     David Edmondson <david.edmondson@oracle.com>,
        Leonardo Bras <leobras@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        David Gilbert <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220217053028.96432-1-leobras@redhat.com>
 <20220217053028.96432-2-leobras@redhat.com> <cunmtippugr.fsf@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cunmtippugr.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 13:07, David Edmondson wrote:
> The single line summary is now out of date - there's no new masking.

Thanks for the review, I made the adjustments and pushed to master.

Paolo

> On Thursday, 2022-02-17 at 02:30:29 -03, Leonardo Bras wrote:
> 
>> During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
>> swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().
>>
>> When xsave feature is available, the fpu swap is done by:
>> - xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
>>    to store the current state of the fpu registers to a buffer.
>> - xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
>>    XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.
>>
>> For xsave(s) the mask is used to limit what parts of the fpu regs will
>> be copied to the buffer. Likewise on xrstor(s), the mask is used to
>> limit what parts of the fpu regs will be changed.
>>
>> The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
>> kvm_arch_vcpu_create(), which (in summary) sets it to all features
>> supported by the cpu which are enabled on kernel config.
>>
>> This means that xsave(s) will save to guest buffer all the fpu regs
>> contents the cpu has enabled when the guest is paused, even if they
>> are not used.
>>
>> This would not be an issue, if xrstor(s) would also do that.
>>
>> xrstor(s)'s mask for host/guest swap is basically every valid feature
>> contained in kernel config, except XFEATURE_MASK_PKRU.
>> Accordingto kernel src, it is instead switched in switch_to() and
>> flush_thread().
>>
>> Then, the following happens with a host supporting PKRU starts a
>> guest that does not support it:
>> 1 - Host has XFEATURE_MASK_PKRU set. 1st switch to guest,
>> 2 - xsave(s) fpu regs to host fpustate (buffer has XFEATURE_MASK_PKRU)
>> 3 - xrstor(s) guest fpustate to fpu regs (fpu regs have XFEATURE_MASK_PKRU)
>> 4 - guest runs, then switch back to host,
>> 5 - xsave(s) fpu regs to guest fpstate (buffer now have XFEATURE_MASK_PKRU)
>> 6 - xrstor(s) host fpstate to fpu regs.
>> 7 - kvm_vcpu_ioctl_x86_get_xsave() copy guest fpstate to userspace (with
>>      XFEATURE_MASK_PKRU, which should not be supported by guest vcpu)
>>
>> On 5, even though the guest does not support PKRU, it does have the flag
>> set on guest fpstate, which is transferred to userspace via vcpu ioctl
>> KVM_GET_XSAVE.
>>
>> This becomes a problem when the user decides on migrating the above guest
>> to another machine that does not support PKRU:
>> The new host restores guest's fpu regs to as they were before (xrstor(s)),
>> but since the new host don't support PKRU, a general-protection exception
>> ocurs in xrstor(s) and that crashes the guest.
>>
>> This can be solved by making the guest's fpstate->user_xfeatures hold
>> a copy of guest_supported_xcr0. This way, on 7 the only flags copied to
>> userspace will be the ones compatible to guest requirements, and thus
>> there will be no issue during migration.
>>
>> As a bonus, it will also fail if userspace tries to set fpu features
>> that are not compatible to the guest configuration. (KVM_SET_XSAVE ioctl)
>>
>> Also, since kvm_vcpu_after_set_cpuid() now sets fpstate->user_xfeatures,
>> there is not need to set it in kvm_check_cpuid(). So, change
>> fpstate_realloc() so it does not touch fpstate->user_xfeatures if a
>> non-NULL guest_fpu is passed, which is the case when kvm_check_cpuid()
>> calls it.
>>
>> Signed-off-by: Leonardo Bras <leobras@redhat.com>
>> ---
>>   arch/x86/kernel/fpu/xstate.c | 5 ++++-
>>   arch/x86/kvm/cpuid.c         | 2 ++
>>   2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index 02b3ddaf4f75..7c7824ae7862 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -1558,7 +1558,10 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
>>   		fpregs_restore_userregs();
>>
>>   	newfps->xfeatures = curfps->xfeatures | xfeatures;
>> -	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
>> +
>> +	if (!guest_fpu)
>> +		newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
>> +
>>   	newfps->xfd = curfps->xfd & ~xfeatures;
>>
>>   	/* Do the final updates within the locked region */
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 494d4d351859..71125291c578 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -296,6 +296,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.guest_supported_xcr0 =
>>   		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>>
>> +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
>> +
>>   	kvm_update_pv_runtime(vcpu);
>>
>>   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> 
> dme.

