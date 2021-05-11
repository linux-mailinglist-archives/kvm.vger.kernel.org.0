Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4898437B0F4
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 23:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhEKVpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 17:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKVpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 17:45:44 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC2AC06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:44:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b21so11515959plz.0
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yx+39qXc438LnqcVoK9S+syQxNl3cscRnUz1xpfh/no=;
        b=EDXRhYVTURVbw6NqRnXEehgqiLGVWuHVbBI8DLssCYfOuCz6JrCz3mkNjIi98bnk5W
         oCZK3DNOlOu4HxiKsqlwd3J9rHiBSIHgxK50yuQYQFeu+4I/It0WU+wiGXllAMDzQ7Sv
         z9KsmGA6JMf0cL5ZAMuW5CyVWJisNGtZdmJZhsEafSD6/oZ9LW15rCuBGFYk36pbQrfN
         pD4ICd22pdVTVTp6B2oWZZLE2OuNapfZ1qlQsQDNT0NzG6yqthIwu/shzskbpBm+RjQy
         FRfJpvqq7rrB+dgorYLU/Fi+9HOLN8ir4dmmFHp+lXCEC5O54ZXCyvYOyFk87bnAkpFd
         XqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yx+39qXc438LnqcVoK9S+syQxNl3cscRnUz1xpfh/no=;
        b=t9dMA5Z3uiSNCX/bPv2GL0hGTdCkkh7U36YdWxQ9B8pPMPebMfEgNX1s/2ym+Fy1KW
         wK8UGUiutVjUHeWqVpuRzUPtn6lsfxjeB3/YH4x5TcfTFCy3pHijuf6Qfrghleapiv0f
         OsqaGr6w/cPnaxGdKcDQnoU/DcnIFerWbaXPuCfpDFe2slZC2mfyCllVE2eg+U78u91A
         DwV1VnUWXj8zgRwXYJJzOeLvEX6AWykp50K/gOlTz51vcIqli8QsUe1Oi9R6AeKwDRD2
         mEGA0+B9F0KkkkcBGXxHX5ZiNztjxkbi1CaWLvE7+nKlyhFRGvAMXdPERnNf/Hmq+GOq
         MCjg==
X-Gm-Message-State: AOAM5315D5PXm+mkyosq4HtESFH6XMqtJaJ9ybR7wTHYaNLVBnKL0Vmz
        0Ma0dazGzDYEAbLKgyTxD4saQA==
X-Google-Smtp-Source: ABdhPJyDWIqg+sOGSa4yi6cV8CgW47XfUiTcUY/QumB0S73X2jXRjXTnLBMNFIHzA9/eKoWO/Da06A==
X-Received: by 2002:a17:903:228b:b029:ee:daa8:eca6 with SMTP id b11-20020a170903228bb02900eedaa8eca6mr31593250plh.38.1620769475535;
        Tue, 11 May 2021 14:44:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id gb9sm2853476pjb.7.2021.05.11.14.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:44:35 -0700 (PDT)
Date:   Tue, 11 May 2021 21:44:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/3] KVM: X86: Bail out of direct yield in case of
 undercomitted scenarios
Message-ID: <YJr6v+hfMJxI2iAn@google.com>
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
 <1620466310-8428-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620466310-8428-2-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 08, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> In case of undercomitted scenarios, vCPU can get scheduling easily, 
> kvm_vcpu_yield_to adds extra overhead, we can observe a lot of race 
> between vcpu->ready is true and yield fails due to p->state is 
> TASK_RUNNING. Let's bail out is such scenarios by checking the length 
> of current cpu runqueue.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5bd550e..c0244a6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8358,6 +8358,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>  	struct kvm_vcpu *target = NULL;
>  	struct kvm_apic_map *map;
>  
> +	if (single_task_running())
> +		goto no_yield;
> +

Hmm, could we push the result of kvm_sched_yield() down into the guest?
Currently the guest bails after the first attempt, which is perfect for this
scenario, but it seems like it would make sense to keep trying to yield if there
are multiple preempted vCPUs and the "problem" was with the target.  E.g.

	/*
	 * Make sure other vCPUs get a chance to run if they need to.  Yield at
	 * most once, and stop trying to yield if the VMM says yielding isn't
	 * going to happen.
	 */
	for_each_cpu(cpu, mask) {
		if (vcpu_is_preempted(cpu)) {
			r = kvm_hypercall1(KVM_HC_SCHED_YIELD,
					   per_cpu(x86_cpu_to_apicid, cpu));
			if (r != -EBUSY)
				break;
		}
	}


Unrelated to this patch, but it's the first time I've really looked at the guest
side of directed yield...

Wouldn't it also make sense for the guest side to hook .send_call_func_single_ipi?

>  	vcpu->stat.directed_yield_attempted++;

Shouldn't directed_yield_attempted be incremented in this case?  It doesn't seem
fundamentally different than the case where the target was scheduled in between
the guest's check and the host's processing of the yield request.  In both
instances, the guest did indeed attempt to yield.

>  	rcu_read_lock();
> -- 
> 2.7.4
> 
