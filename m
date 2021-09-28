Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71EE41B943
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 23:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbhI1V2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 17:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242926AbhI1V16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 17:27:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EF6C061746
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 14:26:19 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so2657830pjy.1
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 14:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L4Z1qtd59VARXTo8mTMZfhpyo/YJa2yppwRF4l1omg8=;
        b=rSq0scJL/ha88RRlXKX42Isqbw/cwS5kVIP0Rz8OfVzzn6D5kKDMweVE0Q4ktQSiMJ
         FhxFPNTbhY9xS2vAGEQ+qB5gV/IMUC6h9JD8Smhm2ssJbOQpHIqEJKUl6mN0qk2Gvwz4
         iqKk5TZe73g8eJV+2vJnrwoJvPJ1P6NI4t92YcMxTQruO4ZgcMdMIYBXrSN2yeCfPbAN
         tFQ4GxwssW84Y1vg4LGpetlrhcF6FFA2L4YDutUNKomAAwAsIirg3JkaUm6HVKTrF3V4
         BHRGBPVxBUQcMzwQWA2PNjc4/b6DItbdmvXb7Ajmp33ZzPOIr2q8iG4+IHZG+ueXE4Hc
         nmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L4Z1qtd59VARXTo8mTMZfhpyo/YJa2yppwRF4l1omg8=;
        b=Fz785C6fIrylvTiHW7D2hlT/1XYnadWla3FpnpVxEbgNXjLHKJGIHXOjsSx/mMb2+H
         ug01IEMmo2BnGJSo1D/yRPl8rcuxfCd+ZV4Z8eeCFAgLcwyD+Ok8IhxSWXy85WsC73i6
         R2Vlfeq9sebywWfU9MSAkH7fbZ6ow2a+Ut5weyrE1JcxXP+MkjYoCYc35jSYvkJldqVi
         yoBo7s6iawjrcJM63Lgqm7D4un5FSCWbmbhbYXbENZtkmEyAwCR+mZ+hgNy07Tof6GBW
         pButId5Og3VtzegFnyx8gcoXF/gZ3LFm8igFFA/owFUIWtmhU/a9ZwpICOTgklVLjKXP
         Tlqg==
X-Gm-Message-State: AOAM5313GxVNdh2lDsnDRyU+ekXBFA43jezIKEttfDnzALIk+z//B0ED
        pHR6U5HKobST39Uko5OGO/ZsMA==
X-Google-Smtp-Source: ABdhPJyiNQfJ0RYEvCNSbQfmhva0TWeah3nt33T8BlFeMgmCPfbY0etgFPJGRuPzGjsIEt8CokHbDg==
X-Received: by 2002:a17:902:a3c2:b0:13d:be85:43ca with SMTP id q2-20020a170902a3c200b0013dbe8543camr7239171plb.0.1632864378224;
        Tue, 28 Sep 2021 14:26:18 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id j20sm109118pgb.2.2021.09.28.14.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:26:17 -0700 (PDT)
Date:   Tue, 28 Sep 2021 21:26:13 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 04/14] KVM: Reconcile discrepancies in halt-polling stats
Message-ID: <YVOIdZhAe5Bqn4hc@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-5-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:18PM -0700, Sean Christopherson wrote:
> Move the halt-polling "success" and histogram stats update into the
> dedicated helper to fix a discrepancy where the success/fail "time" stats
> consider polling successful so long as the wait is avoided, but the main
> "success" and histogram stats consider polling successful if and only if
> a wake event was detected by the halt-polling loop.
> 
> Move halt_attempted_poll to the helper as well so that all the stats are
> updated in a single location.  While it's a bit odd to update the stat
> well after the fact, practically speaking there's no meaningful advantage
> to updating before polling.
> 
> Note, there is a functional change in addition to the success vs. fail
> change.  The histogram updates previously called ktime_get() instead of
> using "cur".  But that change is desirable as it means all the stats are
> now updated with the same polling time, and avoids the extra ktime_get(),
> which isn't expensive but isn't free either.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 12fe91a0a4c8..2ba22b68af3b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3202,12 +3202,23 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  					  ktime_t end, bool success)
>  {
> +	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
>  	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
>  
> -	if (success)
> -		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
> -	else
> -		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
> +	++vcpu->stat.generic.halt_attempted_poll;
> +
> +	if (success) {
> +		++vcpu->stat.generic.halt_successful_poll;
> +
> +		if (!vcpu_valid_wakeup(vcpu))
> +			++vcpu->stat.generic.halt_poll_invalid;
> +
> +		stats->halt_poll_success_ns += poll_ns;
> +		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
> +	} else {
> +		stats->halt_poll_fail_ns += poll_ns;
> +		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_fail_hist, poll_ns);
> +	}
>  }
>  
>  /*
> @@ -3227,30 +3238,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
> -		++vcpu->stat.generic.halt_attempted_poll;
>  		do {
>  			/*
>  			 * This sets KVM_REQ_UNHALT if an interrupt
>  			 * arrives.
>  			 */
> -			if (kvm_vcpu_check_block(vcpu) < 0) {
> -				++vcpu->stat.generic.halt_successful_poll;
> -				if (!vcpu_valid_wakeup(vcpu))
> -					++vcpu->stat.generic.halt_poll_invalid;
> -
> -				KVM_STATS_LOG_HIST_UPDATE(
> -				      vcpu->stat.generic.halt_poll_success_hist,
> -				      ktime_to_ns(ktime_get()) -
> -				      ktime_to_ns(start));
> +			if (kvm_vcpu_check_block(vcpu) < 0)
>  				goto out;
> -			}
>  			cpu_relax();
>  			poll_end = cur = ktime_get();
>  		} while (kvm_vcpu_can_poll(cur, stop));
> -
> -		KVM_STATS_LOG_HIST_UPDATE(
> -				vcpu->stat.generic.halt_poll_fail_hist,
> -				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
>  	}
>  
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 
