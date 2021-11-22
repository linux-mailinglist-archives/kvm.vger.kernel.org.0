Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAB545955E
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbhKVTQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbhKVTQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:16:15 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4373C06173E
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:13:08 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 28so16092606pgq.8
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xdP/1E/sjsU4zxgXiTU4EW1L3AvShi1LySCVgiuwxhk=;
        b=pgAhS8MM5EonlJPkdQAeawThA4p4egLanaMBN6/4TKVldxH9LVZ7k9WHaYVGo82KX7
         18aFXBTWlhy0r/V4IOx8/8UAgghLzT09K0F9iCHD30AQvsa4Qt+CSvMLRp5SvJjtT/gi
         1PqBcprOLhMQoW5KlGtsACtBcaGDwM0bSlRJd65uOqAG5ciWprx28kvVT/YCQFd1rj7U
         376ehb8bHBDi9adfN3SfvlYq/nyxAuTfnV9uoanvKLMC61PL5czLo8QVib+HUNC/wLrt
         ieOxttB5hSPlfSshaRcdbBLJbF+aZVwSAzHz9ED2YhoDiAwAZ4JPOuBkXvo6xB5av/py
         6DNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xdP/1E/sjsU4zxgXiTU4EW1L3AvShi1LySCVgiuwxhk=;
        b=QCSX82mAf2TP2C6EsiXgzTZhEE+3V7BVjNyGpPPSoDikDjj/UMZFoQC7eTFV/BvPzm
         wRzbvvhIRmv1HmoZfjZVWmqlutk4mLIzteTCkeELUwZ+LCsrFqIebq67xPlKKVcsEOdf
         LR/dBw6FU9Dm0UxToXpEfSVX8+pbKYvgOxaldBYoejpAjNb9gOs53biFUakI3BTrGXOP
         xZZP2iPCkLwM7hb9PDjw7739k+dOJNnUWkL82dn6lVBbFFYrVkapho3ngdvfHL/N3k3N
         mW+OoXqY9wUTqTMEF0ya3Agny4GJdUfZuVA9djb8i2dFffpD33+NrNcXLiMjcLiTi/8I
         1nUw==
X-Gm-Message-State: AOAM533QlZKx5CxjD7xYCOg3bjAlRhhX99VgZLhXr4NVxLhYnaRDOnDE
        9zcRnqCLm1OZP4lA6NZUQvL47Q==
X-Google-Smtp-Source: ABdhPJywWf83H/xNNjbfsd1y6iSA/s+3iEDb0YY1d+t06wff/MSS3oF9BLmYM22aWFFftqWP9pxyxg==
X-Received: by 2002:a62:1b51:0:b0:49f:a8d8:84b with SMTP id b78-20020a621b51000000b0049fa8d8084bmr87130253pfb.31.1637608387283;
        Mon, 22 Nov 2021 11:13:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b15sm9600038pfv.48.2021.11.22.11.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 11:13:06 -0800 (PST)
Date:   Mon, 22 Nov 2021 19:13:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aili Yao <yaoaili126@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <YZvrvmRnuDc1e+gi@google.com>
References: <20211122095619.000060d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122095619.000060d2@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Aili Yao wrote:
> From: Aili Yao <yaoaili@kingsoft.com>
> 
> When we isolate some pyhiscal cores, We may not use them for kvm guests,
> We may use them for other purposes like DPDK, or we can make some kvm
> guests isolated and some not, the global judgement pi_inject_timer is
> not enough; We may make wrong decisions:
> 
> In such a scenario, the guests without isolated cores will not be
> permitted to use vmx preemption timer, and tscdeadline fastpath also be
> disabled, both will lead to performance penalty.
> 
> So check whether the vcpu->cpu is isolated, if not, don't post timer
> interrupt.
> 
> Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> ---
>  arch/x86/kvm/lapic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 759952dd1222..72dde5532101 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -34,6 +34,7 @@
>  #include <asm/delay.h>
>  #include <linux/atomic.h>
>  #include <linux/jump_label.h>
> +#include <linux/sched/isolation.h>
>  #include "kvm_cache_regs.h"
>  #include "irq.h"
>  #include "ioapic.h"
> @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>  
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);

I don't think this is safe, vcpu->cpu will be -1 if the vCPU isn't scheduled in.
This also doesn't play nice with the admin forcing pi_inject_timer=1.  Not saying
there's a reasonable use case for doing that, but it's supported today and this
would break that behavior.  It would also lead to weird behavior if a vCPU were
migrated on/off a housekeeping vCPU.  Again, probably not a reasonable use case,
but I don't see anything that would outright prevent that behavior.

The existing behavior also feels a bit unsafe as pi_inject_timer is writable while
KVM is running, though I supposed that's orthogonal to this discussion.

Rather than check vcpu->cpu, is there an existing vCPU flag that can be queried,
e.g. KVM_HINTS_REALTIME?

>  }
>  
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> -- 
> 2.25.1
> 
