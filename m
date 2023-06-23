Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A0E73C050
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjFWUi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 16:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjFWUix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 16:38:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF942130
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:38:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c1039cbba72so248157276.0
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687552694; x=1690144694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QwNPgwiBQZGJeDnguHE5i5QhIkh5nKMqMyEPaR/bIi0=;
        b=S+gS2IQYLrYxQ/9+oRMG1ahOtYGEn4Hx1tnys8TxBtT5IefCIFC0J1mYt2T2h0EOd8
         Yhvyu9Epl+xfAOfKqWuXEOKQfKH1y790+4wYskDZ0Awt0AST/Kwvi3m4NVlsMeOsaAl2
         HFduxVFkrks7NWvWafWc2IB48aAaJNaQzPaiMSpC5gNB8Kb15lJD5rnFWS9F1IACFvFO
         TxhphQw8dS+VtPpXo/I2jouDnp01zylDHZfitq/+NpO+r/WfSv2akxEwxVEcjIgfYlxh
         PDXMXqHGRSuegFHhwoHEF1o0CUiq7bc78FJzS3bXOQvJMNzZ2EewecUcbGxLjn1tiIlQ
         DxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687552694; x=1690144694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QwNPgwiBQZGJeDnguHE5i5QhIkh5nKMqMyEPaR/bIi0=;
        b=DpHqU+0vL6WmAhXFXojkdMR7QUlUK8I+cpF1j+qnwTddOpFaEZ0+3kbyreooF0shmg
         /9OPi0eRO2yeQkcoPfbFE9HjJ0LK9GSXrO4MfbEL629Lf/hsZKYkfdNomh09XqPyxNIU
         GTuK6IianxIGnZFM8iUXAmCCKk8363FxJhBuiIB+CsFiaEZhuNeZrM1Vajg5TPcAveAu
         Gd8p77mvnBh7SO0Z9rlqqIZYbVDdYwvsHNtnH2JrLfhK7WLso74gldrImOvJr/1T2NHd
         lVKO5hySJDtUtQeMBJvXvQwNKhOlnaISfzoVxl0pjUnNJ+CxZCdCWxwoKpQqp1vAUmDb
         dHKQ==
X-Gm-Message-State: AC+VfDwtnAzsVZqPDq448Gg44eh9iw5o0aZgj7yoND9o89Ou/w+hBTmZ
        MqyY4vg3Go8nsZMNe8xb/n+QuLOwFRw=
X-Google-Smtp-Source: ACHHUZ6bgde2JCXrNsJtz06MCTZDowjFJv1N0BDCPuMZvZmiiAsrXclVeOU/48XYNaZZon8hj8RtdhjkyGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2691:0:b0:ba8:1646:c15d with SMTP id
 m139-20020a252691000000b00ba81646c15dmr9694281ybm.1.1687552694461; Fri, 23
 Jun 2023 13:38:14 -0700 (PDT)
Date:   Fri, 23 Jun 2023 13:38:12 -0700
In-Reply-To: <20230616113353.45202-4-xiong.y.zhang@intel.com>
Mime-Version: 1.0
References: <20230616113353.45202-1-xiong.y.zhang@intel.com> <20230616113353.45202-4-xiong.y.zhang@intel.com>
Message-ID: <ZJYCtDN+ITmrgCUs@google.com>
Subject: Re: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR
 MSR emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Xiong Zhang wrote:
> vLBR event could be inactive in two case:
> a. host per cpu pinned LBR event occupy LBR when vLBR event is created
> b. vLBR event is preempted by host per cpu pinned LBR event during vm
> exit handler.
> When vLBR event is inactive, guest couldn't access LBR msr, and it is
> forced into error state and is excluded from schedule by perf scheduler.
> So vLBR event couldn't be active through perf scheduler even if host per
> cpu pinned LBR event has released LBR, kvm could enable vLBR event
> proactively, then vLBR event may be active and LBR msr could be passthrough
> into guest.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 741efe2c497b..5a3ab8c8711b 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -314,7 +314,16 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>  	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
>  		return false;
>  
> -	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
> +	/* vLBR event may be inactive, but physical LBR may be free now.

	/*
	 * This is the preferred block comment style.
	 */

> +	 * but vLBR event is pinned event, once it is inactive state, perf
> +	 * will force it to error state in merge_sched_in() and exclude it from
> +	 * perf schedule, so even if LBR is free now, vLBR event couldn't be active
> +	 * through perf scheduler and vLBR event could be active through
> +	 * perf_event_enable().
> +	 */

Trimming that down, is this what you mean?

	/*
	 * Attempt to re-enable the vLBR event if it was disabled due to
	 * contention with host LBR usage, i.e. was put into an error state.
	 * Perf doesn't notify KVM if the host stops using LBRs, i.e. KVM needs
	 * to manually re-enable the event.
	 */

Which begs the question, why can't there be a notification of some form that the
LBRs are once again available?

Assuming that's too difficult for whatever reason, why wait until the guest tries
to read LBRs?  E.g. why not be more aggressive and try to re-enable vLBRs on every
VM-Exit.

And if we do wait until the guest touches relevant MSRs, shouldn't writes to
DEBUG_CTL that set DEBUGCTLMSR_LBR also try to re-enable the event?

Lastly, what guarantees that the MSRs hold guest data?  I assume perf purges the
MSRs at some point, but it would be helpful to call that out in the changelog.

> +	if (lbr_desc->event && (lbr_desc->event->state == PERF_EVENT_STATE_ERROR))
> +		perf_event_enable(lbr_desc->event);
> +	else if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
>  		goto dummy;
>  
>  	/*
> -- 
> 2.25.1
> 
