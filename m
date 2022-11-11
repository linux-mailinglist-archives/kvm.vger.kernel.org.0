Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E1E6259EC
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 12:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiKKL67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 06:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiKKL66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 06:58:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F212E64A2D
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 03:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668167883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQxeDeDhu6IzIjI16JkygauQkgAF1/yceW1QWgUfyxg=;
        b=Pv1Gp/51mZJ65xTy6BsKm4fAp9VbT/OKvVRNpLB0LaWAeXqO89nRUWhpZsPAnkkVEuFR73
        Vue7qEMFkdHWIpPzs8OqiAVc8encIbIGN4NMESWHQyxt4m644udikxYBzEaHEnMP3BBNui
        kQ21rwL2kKZURa00N41Ur8yqovJeI+w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-228--OTb5SYRPHaokdO92_mvZw-1; Fri, 11 Nov 2022 06:58:01 -0500
X-MC-Unique: -OTb5SYRPHaokdO92_mvZw-1
Received: by mail-wm1-f70.google.com with SMTP id z18-20020a05600c221200b003cf7fcc286aso1716963wml.1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 03:58:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQxeDeDhu6IzIjI16JkygauQkgAF1/yceW1QWgUfyxg=;
        b=yOSu/sxH4lIDjG2nf2j74wpSehFG1STAKfPxHtAoWfIxij1YCyJ8VUr93+ujnY7ocF
         O0uZDs5cySY5o3ZjSdT4X1mfuUwhvs42whKLxLmf0FOR95a9NSF3SD9LVrbUaM8RTGJa
         y4VdQTsHxWVIVuJ6UGF6t0o36K4aC5dMJNmPcMSa2yInxd4oUE1bPQ/BnnPYNHGNQ6DK
         nKTWRULgZi/pR/hJw8CB5RT9nLX7QtUhVVspNqRho9ZyYhJ/518Tpzt0bIQg/X6mKShe
         h7gMyG7uVGagpcgJYDUtLlUtcFdKenh0/74K8dOtb5zdNM8x0osD4POiatt6brrxM3RZ
         nOLA==
X-Gm-Message-State: ANoB5pkEnFRUfYAH/uS8TMisUo5sPWDKqEsxyB+YIfS0ApcDAhNXu9Qw
        wRKQV2Uu0Ma1AMSIiWZXAycAifgQiQz7pQ89GosWTwdQIeolWWnaaIgl7qeZ7tFO6MnaRYo+pHJ
        hW9RHTGMyhb47
X-Received: by 2002:a5d:4290:0:b0:236:6e66:3447 with SMTP id k16-20020a5d4290000000b002366e663447mr1047888wrq.24.1668167880626;
        Fri, 11 Nov 2022 03:58:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf57ho9CC+kZ6+dxY0ndw7qgIRESJn/77l5KhommJmSf3z+56OuXMQLjrm1O24GJI5Jxnaxh2w==
X-Received: by 2002:a5d:4290:0:b0:236:6e66:3447 with SMTP id k16-20020a5d4290000000b002366e663447mr1047876wrq.24.1668167880385;
        Fri, 11 Nov 2022 03:58:00 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r18-20020adfe692000000b00238df11940fsm1788044wrm.16.2022.11.11.03.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 03:57:59 -0800 (PST)
Message-ID: <ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com>
Date:   Fri, 11 Nov 2022 12:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com> <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
 <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
 <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
 <Y24n4bHoFBuHVid5@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y24n4bHoFBuHVid5@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/22 11:45, Peter Zijlstra wrote:
>> What is "correct" in this context?
>
> I don't know since I don't really speak virt, but I could image the
> regset that would match the vmrun (or whatever intel decided to call
> that again) instruction.

Right now it is not exactly that but close.  The RIP is somewhere in 
vmx_do_interrupt_nmi_irqoff; CS/SS are correct (i.e. it's not like they 
point to guest values!) and other registers including RSP and RFLAGS are 
consistent with the RIP.

>> Currently KVM basically stuff random data into pt_regs; this at least
>> makes it explicitly zero.
>
> 🙁 Both is broken. Once again proving to me that virt is a bunch of
> duck-tape at best.

Except currently it is not random.  At least I'm not alone in sometimes 
thinking I understand stuff when I actually don't.

Zero is just wrong, I agree.  Xin, if you don't want to poke at the IDT 
you need to build the pt_regs and pass them to the function you add in 
patch 5.  In order to make it like Peter wants it, then:

1) for the flags just use X86_EFLAGS_FIXED

2) for CS/SS segment selectors use __KERNEL_CS and __KERNEL_DS

3) the RIP/RSP can be found respectively in (unsigned long)vmx_vmexit 
vmx->loaded_vmcs->host_state.rsp

4) the other registers can be taken from vcpu->arch.regs

But I am not sure it's an improvement.  It may be okay to zero the 
registers, but setting CS/RIP/SS/RSP/RFLAGS to the actual processor 
values in vmx_do_interrupt_nmi_irqoff is safer.

I'm not sure who would set orig_rax, but I haven't looked too closely. 
Perhaps that's not a problem, but if so it has to be documented in the 
commit message.

Paolo

