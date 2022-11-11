Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DA1625A3D
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiKKMHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbiKKMGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:06:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D49388556
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668168271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajNQehgGzAdQRTIAlCOxMOqv02DUIADA/hE0i3TN+qw=;
        b=G4zAcao9my71qD34yLpm7rO3l1SzeOvrqXm1qz8UToUnGJwNJltoeMoSsByoIXxgvNLly1
        sWtccLkoeAgI6f/SCktXNq+zFNAsaaxlFQWyYaZs/SiciBXAJHVa3I5259b+ua0hpQ6ihG
        Phs8djkMKbQ5penm4mMUoOR6FkZNYXY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-i2Jxl8ZaPnC2rV2-lup7sQ-1; Fri, 11 Nov 2022 07:04:30 -0500
X-MC-Unique: i2Jxl8ZaPnC2rV2-lup7sQ-1
Received: by mail-wm1-f69.google.com with SMTP id l1-20020a7bc341000000b003bfe1273d6cso1719160wmj.4
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:04:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ajNQehgGzAdQRTIAlCOxMOqv02DUIADA/hE0i3TN+qw=;
        b=T+Q+1PW879T/LT8lOANLP2PkWCk0Q8HpC6WbJoFOgoTnLMOKqOEUnt6WKa0gCBvJ/u
         XiNR3pA4iQuz3s49rkBe3Klf6ql9Jm4iv8P9nwBfTvq1b48iyC+Z8Kp4RtmnjMCHc5iM
         nishVntIgxpPE8hLCto0y5g3yeYVLyz3tEZPPjygUILAvUVFqq04frFJrKsIWkdKZn6j
         xzTJ10ML9WhFG0S3iZy4BymM9jeZjVB839Ocq8J0zPI+aKaWFwj1uVJH/mzPsp3bSj6Y
         MweO0RC4C6o3l+Wrlelxu8gXL28J+wgSwBtGw8KV1o0xIRwm52AD5VCSp1vWlVl66OB3
         fwmQ==
X-Gm-Message-State: ANoB5pmyN7GpYV+PqdQD05Og8wXG+yYfDp/u7o3jpgWRYIO3fdepKJEt
        gtRT0Wrc9lyPXM6aRv1Nh31uEkj2vpvfgUwGmSBhMfHvRCYFIVSaQ6sO7Ayc03WofRMCSSzppHM
        CnUTxPOfwou35
X-Received: by 2002:a5d:4f0a:0:b0:22c:c2f0:5091 with SMTP id c10-20020a5d4f0a000000b0022cc2f05091mr1052085wru.403.1668168269032;
        Fri, 11 Nov 2022 04:04:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5vBYLkPmqLCdPUOSQXDgiSAEh9GAlL58nDj2fjTxkOHE+CL3fgvosIZd98HJyEHAOEr9om/A==
X-Received: by 2002:a5d:4f0a:0:b0:22c:c2f0:5091 with SMTP id c10-20020a5d4f0a000000b0022cc2f05091mr1052071wru.403.1668168268813;
        Fri, 11 Nov 2022 04:04:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n3-20020a05600c4f8300b003a8434530bbsm9193165wmq.13.2022.11.11.04.04.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 04:04:28 -0800 (PST)
Message-ID: <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
Date:   Fri, 11 Nov 2022 13:04:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/22 10:15, Peter Zijlstra wrote:
> I don't speak virt (but this all sounds disguisting)

Yes, it is.  AMD does not need this, they just hold onto the interrupt
until the host has issued both STGI (for NMIs) and STI (for IRQs).

On Intel you can optionally make it hold onto IRQs, but NMIs are always
eaten by the VMEXIT and have to be reinjected manually.

> -- but what appears to be the case is you calling into entry code
> from regular kernel context, which is odd at best.
> 
> Specifically, going by the fact that all this is not noinstr code,
> the assumption is that RCU/lockdep/etc.. is all set-up and running.

Indeed it is.  This is called long after the noinstr area has been left:

vcpu_enter_guest
   ...
   static_call(kvm_x86_vcpu_run) -> vmx_vcpu_run
     vmx_vcpu_enter_exit (noinstr)
       guest_state_enter_irqoff
       __vmx_vcpu_run
       guest_state_exit_irqoff
   ...
   static_call(kvm_x86_handle_exit_irqoff) -> vmx_handle_exit_irqoff
     handle_external_interrupt_irqoff
   ...

Paolo

> This means you should not be calling DEFINE_IDTENTRY_*(func)
> functions because those will try and set all that up again.
> 
> Granted, irqentry_{enter,exit}() do nest, but*yuck*.

