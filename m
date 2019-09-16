Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04AF1B36B2
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 10:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfIPIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 04:55:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbfIPIzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 04:55:13 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4F0A4FCC9
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 08:55:12 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id z8so5783575wrs.14
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 01:55:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SUB1IVXL6hgEq88Q4J0UTBzixwOO6EmRLqrfJRI+g3o=;
        b=XpEETE96XHshus+w4Mlzzi49UC9d63GxushpIUJ23LL7VF6RO1MxpWYJK4fvBP/ttr
         od+Ri46cJjXnZh+9SO50MX0DZfjWh8opDcnXgAbNP1RuXQ7w7mEiYJ9Pqo3NNcywP8Yq
         yYah83myrXgvVL28w3YIxY5NJggv0+dy/c+A5OA0OiEkiD/p5XZITW81lwFwLNSilbhK
         mwbhDyQi01Ai82nj1epze+VvMw50g3QW9rIrAvvluujXlswzamXvyzL299MF2CxN6jr3
         /Qc2ZP69Teh3s4gqcAja/B/W4F3pEsTJc0//UvOlrtUr7r3XO7pdVsnjupfaPReRhXl1
         Cazw==
X-Gm-Message-State: APjAAAUex6apgJm4geBcgL0yHAYPDpTbzaOFZmIKtwOaIrp+R70mpK67
        J83qqY1k0RFK0atWjzn7IiQYn00P3jG+2w1kRB3kkF5hHEWakHpBhtIEwEj//QqJpX8oL6yfqwD
        8dm8u0EO4kZkq
X-Received: by 2002:adf:de0d:: with SMTP id b13mr19749472wrm.140.1568624111205;
        Mon, 16 Sep 2019 01:55:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxB6gC9RNDOJt+z56qp5dQpVvWDMYCdc+fZNySO8MEVvHEiJSJfxbdldHJcoj+LPYeFXQKdgw==
X-Received: by 2002:adf:de0d:: with SMTP id b13mr19749460wrm.140.1568624110978;
        Mon, 16 Sep 2019 01:55:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a10sm2214994wrv.64.2019.09.16.01.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 01:55:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3] KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapic_in_kernel
In-Reply-To: <1568619752-3885-1-git-send-email-wanpengli@tencent.com>
References: <1568619752-3885-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 16 Sep 2019 10:55:09 +0200
Message-ID: <87muf4boya.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Reported by syzkaller:
>
> 	kasan: GPF could be caused by NULL-ptr deref or user memory access
> 	general protection fault: 0000 [#1] PREEMPT SMP KASAN
> 	RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
> 	Call Trace:
> 	kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
> 	stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
> 	stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
> 	kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
> 	vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
> 	vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
> 	kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
> 	kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765
>
> The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUNT,
> in addition, there is no lapic in the kernel, the counters value are small
> enough in order that kvm_hv_process_stimers() inject this already-expired
> timer interrupt into the guest through lapic in the kernel which triggers
> the NULL deferencing. This patch fixes it by don't advertise direct mode 
> synthetic timers and discarding the inject when lapic is not in kernel.
>
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=1752fe0a600000
>
> Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>  * add the link of syzkaller source
> v1 -> v2:
>  * don't advertise direct mode synthetic timers when lapic is not in kernel
>
>  arch/x86/kvm/hyperv.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index c10a8b1..069e655 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
>  		.vector = stimer->config.apic_vector
>  	};
>  
> -	return !kvm_apic_set_irq(vcpu, &irq, NULL);
> +	if (lapic_in_kernel(vcpu))
> +		return !kvm_apic_set_irq(vcpu, &irq, NULL);
> +	return 0;

We can go even further and forbid to enable direct mode by adding
lapic_in_kernel() check to stimer_set_config() but the guest (or
userspace setting CPUIDs) is already misbehaving and we can't magically
fix things in KVM.

>  }
>  
>  static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
> @@ -1849,7 +1851,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>  			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
> -			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
> +
> +			/*
> +			 * Direct Synthetic timers only make sense with in-kernel
> +			 * LAPIC
> +			 */
> +			if (lapic_in_kernel(vcpu))
> +				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
>  
>  			break;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
