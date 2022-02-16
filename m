Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5E54B86F8
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiBPLqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:46:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiBPLp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:45:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31443B822B
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645011946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WP90pIk7jEBwCs42OYImo884m3Sc20R1f26ph5uJrT8=;
        b=JN67/N93b5tx/pBdpDZnU5JXONcgaENMKl/1nus0i6kr8CBGUpneSqchktvCIvy/frzRVK
        jPxNkP6EmGpGNsveT+IboK70BVPr6kujT5VJWB4XxXmgfmg4ghzAswum4TVWEQxr9gzMGQ
        uKfXORmX5eGtEsDARBb0CEM8ZMU04xk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-iAQLpVeVMYynOtahJw2fDg-1; Wed, 16 Feb 2022 06:45:45 -0500
X-MC-Unique: iAQLpVeVMYynOtahJw2fDg-1
Received: by mail-ed1-f72.google.com with SMTP id cr7-20020a056402222700b0040f59dae606so1390596edb.11
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:45:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WP90pIk7jEBwCs42OYImo884m3Sc20R1f26ph5uJrT8=;
        b=2TvIWwV7dqVHio8yUn/RlyCBFBWb7wI0FCejhLh5PlhovXCNTXnE5xz90k8pK4J1tD
         4COz9YMc+W481D5LttXNATpNjspwr/bz4y7AqAoA+xOQ7mj7pV+Y8ht+0/9nVa9EGL+2
         1iyGXO0fFtYSdgMtftkIa/sT2GiRRyGXLsgDf1ddqvVL1cX0N+XdgUPjzR1O57Y5za8x
         pgi0Pn8xMdZxc8YQ0mO+yG/GLhk9hfCj3KUUucngy+Bu5M1RtBTlmfmaoET0N998alzB
         O77rTvsDmKOWqU4wFtF2pbrCgSPe3IrUuIOtGrrqY/I0JtuO3yIwALYL3tesgtQNKTJO
         addA==
X-Gm-Message-State: AOAM5323Petp2chfktRqn10fdiTw9nUsFjg0DIurIanlHZhJDSiOuJ39
        MS1Mx4Z2lsnJKhBmBvpqEEty2Wf8NVVOJOgm+J6y4cLdyLbCwJlasQ1Rl+EiGVCpXvCnjapUuxQ
        JhH/5UeRvTlYN
X-Received: by 2002:aa7:d8d8:0:b0:3f5:9041:2450 with SMTP id k24-20020aa7d8d8000000b003f590412450mr2610137eds.322.1645011943875;
        Wed, 16 Feb 2022 03:45:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkaJn52bD+L6Qtxp/FoVpy6ltuid1x9L0SwoLrXz5wehaYTP1E8b2cWzjlZw8g9RYGxeTLVg==
X-Received: by 2002:aa7:d8d8:0:b0:3f5:9041:2450 with SMTP id k24-20020aa7d8d8000000b003f590412450mr2610107eds.322.1645011943624;
        Wed, 16 Feb 2022 03:45:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s1sm1467429edt.49.2022.02.16.03.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 03:45:42 -0800 (PST)
Message-ID: <9b1d925c-1e6a-8a06-ada5-941adb5b349f@redhat.com>
Date:   Wed, 16 Feb 2022 12:45:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
Content-Language: en-US
To:     Leonardo Bras Soares Passos <leobras@redhat.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220211060742.34083-1-leobras@redhat.com>
 <5fd84e2f-8ebc-9a4c-64bf-8d6a2c146629@redhat.com>
 <cunsfslpyvh.fsf@oracle.com>
 <6bee793c-f7fc-2ede-0405-7a5d7968b175@redhat.com>
 <CAJ6HWG6RB6NS8vx0vWdgRhO54B+NqHyBvpg7dRjd_78TRnJ9eg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJ6HWG6RB6NS8vx0vWdgRhO54B+NqHyBvpg7dRjd_78TRnJ9eg@mail.gmail.com>
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

On 2/16/22 08:48, Leonardo Bras Soares Passos wrote:
> On Mon, Feb 14, 2022 at 6:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On top of this patch, we can even replace vcpu->arch.guest_supported_xcr0
>> with vcpu->arch.guest_fpu.fpstate->user_xfeatures. Probably with local
>> variables or wrapper functions though, so as to keep the code readable.
> 
> You mean another patch (#2) removing guest_supported_xcr0 field from
> kvm_vcpu_arch ?
> (and introducing something like kvm_guest_supported_xcr() ?)

Yes, introducing both kvm_guest_supported_xcr0() that just reads 
user_xfeatures, and kvm_guest_supported_xfd() as below.

>> For example:
>>
>> static inline u64 kvm_guest_supported_xfd()
>> {
>>          u64 guest_supported_xcr0 = vcpu->arch.guest_fpu.fpstate->user_xfeatures;
>>
>>          return guest_supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC;
>> }
> 
> Not sure If I get the above.
> Are you suggesting also removing fpstate->xfd and use a wrapper instead?
> Or is the above just an example?
> (s/xfd/xcr0/ & s/XFEATURE_MASK_USER_DYNAMIC/XFEATURE_MASK_USER_SUPPORTED/ )

The above is an example of how even "indirect" uses as 
guest_supported_xcr0 can be changed to a function.

>> Also, already in this patch fpstate_realloc should do
>>
>>           newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
>>
>> only if !guest_fpu.  In other words, the user_xfeatures of the guest FPU
>> should be controlled exclusively by KVM_SET_CPUID2.
> 
> Just to check, you suggest adding this on patch #2 ?
> (I am failing to see how would that impact on #1)

In patch 1.  Since KVM_SET_CPUID2 now changes newfps->user_xfeatures, it 
should be the only place where it's changed, and arch_prctl() should not 
change it anymore.

Paolo

