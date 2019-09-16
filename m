Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D029EB35EB
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 09:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfIPHtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 03:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbfIPHtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 03:49:49 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DF1546288
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 07:49:48 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id c1so15636495wrb.12
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 00:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fGp111aH2l7qegNh84iFHk3Dq9HJMbiQInTpzhHxUjw=;
        b=Aug2fUQJnTom2t8uAibp7RSvDc2dk0oFi2I0e/jGhat4DSEiGPYiaqE1DDGDhB/1IQ
         qQIRURknoXPw9PytU1EgtfThLQp5wRMqGpqUkx15GP4Tp5pcS5CMRK39tdIbFUpzh7lW
         5yuVrzS6oWUdspkJN2OSo7ddpNx2bntREbZKA44TLmRORMA+nXXm7h+aCj8RFLcx6pGi
         PA6Bsrcx5eb0Q+qHajDDceNV5wmG6sJT1eREAWsGbAoLZh8FEaQ1NGohgdbddCDnK/zi
         R2oiTXhDNaw2VdBX+SkGozwpVc0ahoqKhDt1Tm3tLpiR1qfOhtV/4E+tkuAdBWhwMHOr
         kLfg==
X-Gm-Message-State: APjAAAVDWWLqHVWoZp0jJnT9Wme1xZwQIfXAAM4oTv8u0WedhuMrkS6G
        yfdw2WLsnDnfNpTkWuckEq8wkymenuFNbqJSCosW5PZiGhQCTK0JbrrdXcj78QJbmwg+s8LktJ3
        r4XL6KwuReb6r
X-Received: by 2002:a1c:4946:: with SMTP id w67mr12754709wma.131.1568620187038;
        Mon, 16 Sep 2019 00:49:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz4BrE1csH+OTX5L6dAVXGnYlSUv1/pV5xTBLWoRojR+i93OAxrK9YwYUjkNwhSm69x2hXH3A==
X-Received: by 2002:a1c:4946:: with SMTP id w67mr12754689wma.131.1568620186697;
        Mon, 16 Sep 2019 00:49:46 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm12852046wmq.27.2019.09.16.00.49.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:49:46 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Wanpeng Li <wanpeng.li@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
 <a1c6c974-a6f2-aa71-aa2e-4c987447f419@redhat.com>
 <TY2PR02MB4160421A8C88D96C8BCB971180B00@TY2PR02MB4160.apcprd02.prod.outlook.com>
 <8054e73d-1e09-0f98-4beb-3caa501f2ac7@redhat.com>
 <CANRm+Cy+5pompcDDS2C9YnxvE_-87i24gbBfc53Qa1tcWNck2Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <82ff90b6-f518-e2a8-c4f5-ef4b294af15e@redhat.com>
Date:   Mon, 16 Sep 2019 09:49:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cy+5pompcDDS2C9YnxvE_-87i24gbBfc53Qa1tcWNck2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/19 06:02, Wanpeng Li wrote:
> Hi Paolo,
> 
> Something like below? It still fluctuate when running complex guest os
> like linux. Removing timer_advance_adjust_done will hinder introduce
> patch v3 2/2 since there is no adjust done flag in each round
> evaluation.

That's not important, since the adjustment would be continuous.

How much fluctuation can you see?

> I have two questions here, best-effort tune always as
> below or periodically revaluate to get conservative value and get
> best-effort value in each round evaluation as patch v3 2/2, which one
> do you prefer? The former one can wast time to wait sometimes and the
> later one can not get the best latency. In addition, can the adaptive
> tune algorithm be using in all the scenarios contain
> RT/over-subscribe?

I prefer the former, like the patch below, mostly because of the extra
complexity of the periodic reevaluation.

Paolo

> 
> ---8<---
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 685d17c..895735b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -69,6 +69,7 @@
>  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> +#define LAPIC_TIMER_ADVANCE_FILTER 5000
> 
>  static inline int apic_test_vector(int vec, void *bitmap)
>  {
> @@ -1479,29 +1480,28 @@ static inline void
> adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>                            s64 advance_expire_delta)
>  {
>      struct kvm_lapic *apic = vcpu->arch.apic;
> -    u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
> -    u64 ns;
> +    u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
> +
> +    if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER ||
> +        abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
> +        /* filter out random fluctuations */
> +        return;
> +    }
> 
>      /* too early */
>      if (advance_expire_delta < 0) {
>          ns = -advance_expire_delta * 1000000ULL;
>          do_div(ns, vcpu->arch.virtual_tsc_khz);
> -        timer_advance_ns -= min((u32)ns,
> -            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +        timer_advance_ns -= ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>      } else {
>      /* too late */
>          ns = advance_expire_delta * 1000000ULL;
>          do_div(ns, vcpu->arch.virtual_tsc_khz);
> -        timer_advance_ns += min((u32)ns,
> -            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +        timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>      }
> 
> -    if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> -        apic->lapic_timer.timer_advance_adjust_done = true;
> -    if (unlikely(timer_advance_ns > 5000)) {
> +    if (unlikely(timer_advance_ns > 5000))
>          timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -        apic->lapic_timer.timer_advance_adjust_done = false;
> -    }
>      apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
> 
> @@ -1521,7 +1521,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>      if (guest_tsc < tsc_deadline)
>          __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> 
> -    if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> +    if (lapic_timer_advance_ns == -1)
>          adjust_lapic_timer_advance(vcpu,
> apic->lapic_timer.advance_expire_delta);
>  }
> 
> @@ -2298,10 +2298,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int
> timer_advance_ns)
>      apic->lapic_timer.timer.function = apic_timer_fn;
>      if (timer_advance_ns == -1) {
>          apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -        apic->lapic_timer.timer_advance_adjust_done = false;
>      } else {
>          apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> -        apic->lapic_timer.timer_advance_adjust_done = true;
>      }
> 
> 
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 50053d2..2aad7e2 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -35,7 +35,6 @@ struct kvm_timer {
>      s64 advance_expire_delta;
>      atomic_t pending;            /* accumulated triggered timers */
>      bool hv_timer_in_use;
> -    bool timer_advance_adjust_done;
>  };
> 
>  struct kvm_lapic {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93b0bd4..4f65ef1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -141,7 +141,7 @@
>   * advancement entirely.  Any other value is used as-is and disables adaptive
>   * tuning, i.e. allows priveleged userspace to set an exact advancement time.
>   */
> -static int __read_mostly lapic_timer_advance_ns = -1;
> +int __read_mostly lapic_timer_advance_ns = -1;
>  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
> 
>  static bool __read_mostly vector_hashing = true;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6594020..2c6ba86 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -301,6 +301,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
> unsigned long cr2,
> 
>  extern bool enable_vmware_backdoor;
> 
> +extern int lapic_timer_advance_ns;
>  extern int pi_inject_timer;
> 
>  extern struct static_key kvm_no_apic_vcpu;
> 

