Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D6E7CC594
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344007AbjJQOHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344026AbjJQOHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B33FEA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697551578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4g1ulK+z9V7/aTKEMcc3y8TxPpp/2iJYC6X2tFRArVY=;
        b=CutMxfgBArq8hkunpxxMQWV3nprtxXSj/ys9n07lg8FPH+GMELqAhGaXnE//4jQQG5iCLE
        8KRJV3mwsXDXqfNdLcu/cW3t1oAydaMwXh/uordQMwMDwRPdTvw/I8VGA2d+CYyP0sXIv6
        YIkZKt3P7q1WYl4ZFcyOczj68elM6/w=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-fSLhNGMjOEeTpEGerX05_g-1; Tue, 17 Oct 2023 10:06:07 -0400
X-MC-Unique: fSLhNGMjOEeTpEGerX05_g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7788ce62d50so40406885a.3
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697551566; x=1698156366;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4g1ulK+z9V7/aTKEMcc3y8TxPpp/2iJYC6X2tFRArVY=;
        b=lVQzxgEHCpUw+bl3XrFxK3O+FdsPO4QU5Ac1ttivll4DPSn3f6FZrlVbnImYC1b05K
         6amJOGNKRETs1lE9kMoDCiE1Jf0mRndqTXKoLpj1qDQl6zRkH4JxyiOT5AsxJ21rFE+t
         qG3iJFxSW0//5biyPPLrD0C+yxeV2KCUPUJ+GijWvMnFChihBgR6WexsoiwVtTdTtf3n
         uNsGo7x7+sGGJEwWdpSyAFeVqu6yLMvNU62Su9VCnQvfm/pKDXWUHgF046cPgChU1nf6
         ClljMZB3L8Xfrcw+o/s6AxNmCVkybecRAJ6f/DNuwkJbGzdy411QN3CdqVYIOLSvHDL6
         Af5Q==
X-Gm-Message-State: AOJu0YwoU0Pdwfdf1tULiqe/jtIRkp8mSZW7hKdsWoQHh9pV6X4WPcEL
        qkp6q+JLL4vdP8rZuq43IpnGN/oKdT8QZ5dNqfYk9c2lH4XQyLIMi84bHwStGDODUjJj+t/NVcB
        ThJXHjGI+wz2e
X-Received: by 2002:a05:620a:2408:b0:76f:1eac:e72d with SMTP id d8-20020a05620a240800b0076f1eace72dmr2632491qkn.38.1697551566456;
        Tue, 17 Oct 2023 07:06:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTqwQs05khLwp9Lp1Jsou0C8WUsQSn70sPSDRymeyF+Ok+YvRjjulXMBXd6W5gM0sD+e9sfw==
X-Received: by 2002:a05:620a:2408:b0:76f:1eac:e72d with SMTP id d8-20020a05620a240800b0076f1eace72dmr2632457qkn.38.1697551566011;
        Tue, 17 Oct 2023 07:06:06 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id u22-20020a05620a085600b00767d572d651sm669745qku.87.2023.10.17.07.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 07:06:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Mancini, Riccardo" <mancio@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Batalov, Eugene" <bataloe@amazon.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Farrell, Greg" <gffarre@amazon.com>
Subject: RE: [RFC PATCH 4.14] KVM: x86: Backport support for interrupt-based
 APF page-ready delivery in guest
In-Reply-To: <ec949b37e92441f8bcaa4fade546f00a@amazon.com>
References: <ec949b37e92441f8bcaa4fade546f00a@amazon.com>
Date:   Tue, 17 Oct 2023 16:06:03 +0200
Message-ID: <87mswh7390.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Mancini, Riccardo" <mancio@amazon.com> writes:

> Hey,
>
> Thank you both for the quick feedback.
>
>> > I've backported the guest-side of the patchset to 4.14.326, could you 
>> > help us and take a look at the backport?
>> > I only backported the original patchset, I'm not sure if there's any 
>> > other patch (bug fix) that needs to be included in the backpotrt.
>>
>> I remember us fixing PV feature enablement/disablement for hibernation/kdump later, see e.g.
>>
>> commit 8b79feffeca28c5459458fe78676b081e87c93a4
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Wed Apr 14 14:35:41 2021 +0200
>>
>>     x86/kvm: Teardown PV features on boot CPU as well
>>
>> commit 3d6b84132d2a57b5a74100f6923a8feb679ac2ce
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Wed Apr 14 14:35:43 2021 +0200
>>
>>     x86/kvm: Disable all PV features on crash
>>
>> if you're interested in such use-cases. I don't recall any required fixes for normal operation.
>
> These look like issues already present in 4.14, not introduced by the
> interrupt-based mechanism, correct?
> If so, I wouldn't chase them.
> Furthermore, I don't even think we hit those use cases in our scenario.
>
>> 
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>> > On 10/16/23 16:18, Vitaly Kuznetsov wrote:
>> >> In case keeping legacy mechanism is a must, I would suggest you
>> >> somehow record the fact that the guest has opted for interrupt-based
>> >> delivery (e.g. set a global variable or use a static key) and
>> >> short-circuit
>> >> do_async_page_fault() to immediately return and not do anything in
>> >> this case.
>> >
>> > I guess you mean "not do anything for KVM_PV_REASON_PAGE_READY in this
>> > case"?
>> 
>> Yes, of course: KVM_PV_REASON_PAGE_NOT_PRESENT is always a #PF.
>
> I agree this is a difference with the upstream asyncpf-int implementation and
> it's theoretically incorrect. I think this shouldn't happen in a normal case, 
> but it's better to keep it consistent.
> I'll add a check that asyncpf-int is _not_ enabled before processing 
> KVM_PV_REASON_PAGE_READY. Draft diff below.
>
> Thanks,
> Riccardo
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 582a366b82d8..bdfdffd35939 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -79,6 +79,8 @@ static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
>  static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
>  static int has_steal_clock = 0;
>  
> +static DEFINE_PER_CPU(u32, kvm_apf_int_enabled);
> +
>  /*
>   * No need for any "IO delay" on KVM
>   */
> @@ -277,7 +279,8 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>                 prev_state = exception_enter();
>                 kvm_async_pf_task_wait((u32)read_cr2(), !user_mode(regs));
>                 exception_exit(prev_state);
> -       } else if (reason & KVM_PV_REASON_PAGE_READY) {
> +       } else if (!__this_cpu_read(kvm_apf_int_enabled) && (reason & KVM_PV_REASON_PAGE_READY)) {

My bad: I completely forgot KVM_PV_REASON_PAGE_READY is actually not
used for interrupt-based delivery:

commit 9ce372b33a2ebbd0b965148879ae169a0015d3f3
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu May 7 16:36:02 2020 +0200

    KVM: x86: drop KVM_PV_REASON_PAGE_READY case from kvm_handle_page_fault()

and in fact there's nothing else but KVM_PV_REASON_PAGE_NOT_PRESENT in
apf_reason.flags so I agree that this should never happen (but
'kvm_apf_int_enabled' is a good hardening anyway :-)

> +               /* this event is only possible if interrupt-based mechanism is disabled */
>                 rcu_irq_enter();
>                 kvm_async_pf_task_wake((u32)read_cr2());
>                 rcu_irq_exit();
> @@ -367,6 +370,7 @@ static void kvm_guest_cpu_init(void)
>                 if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT)) {
>                         pa |= KVM_ASYNC_PF_DELIVERY_AS_INT;
>                         wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
> +                       __this_cpu_write(kvm_apf_int_enabled, 1);
>                 }
>  
>                 wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
> @@ -396,6 +400,7 @@ static void kvm_pv_disable_apf(void)
>  
>         wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
>         __this_cpu_write(apf_reason.enabled, 0);
> +       __this_cpu_write(kvm_apf_int_enabled, 0);
>  
>         printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
>                smp_processor_id());
>

-- 
Vitaly

