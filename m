Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A45E7060
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIVX7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiIVX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:59:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9132010F731
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:59:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l10so10260354plb.10
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=jm63ZFlCF83VQksqmhDH0eSFayNoZCWcO8SHr0tn98E=;
        b=H9ODMIeIS2kVC20Ym4nsBzAbyNxkF5who3jm54e5N/VCcHIuvoShYmWdcmk/x3idGR
         ictEjUGxq4S+Nh1fAr9br09TyWZoq3NMEVTbcHXM6fxtCymLKdpgucc/DBdu9hzfjSYe
         yIEUh7eFr4YhoBE5EU4Qg42XuDlzWYIyy2ssEsLSwW0UZJcykjhR4UuZGtYBJCyag4Y7
         xHEQusUdJMZR6egB5rsqdcChRTez5k2RmPQuE0We3CrQb/Ds44mdaXnkmC8I5L+gMlc4
         mAisi2yI/4dOSGDdiIMmSUK31oVK/wGOtJccXnlSHDeRNc5+S32xfmKnISlEclb2pceO
         4oUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=jm63ZFlCF83VQksqmhDH0eSFayNoZCWcO8SHr0tn98E=;
        b=oeghRrj/UE7fnbOK6mbR4O9noVf6sx3nfNxnU1q2YNaPUKMp6Rxb59/qsDvXGwpMSZ
         xCVcl0dkF6FkIuTr2fSldSn0CNaSN0pclxRueJQ9BigNcTAc2RjQcic4a2GwICnqrQUl
         ItLyJRrKIa0xh3bgAP+RJbydJtFquky+zWDkPJ9oWsOFjiCkhvNf7qWPPbl1R1abISih
         vbolzBf/vujc88S7w0xm30Xk6Ee19E6YXMaO0WxmLr/Km8lIdOmGpPC1yNhf7uOOTFiP
         DBRjwnDjVl+JbDvOUyJZbTFfAfKUKXWgKqLSUlr7xrHM+Yun9vUrOioW9QTZegbhPRFm
         FJpw==
X-Gm-Message-State: ACrzQf1ySwBRDTJzA2pCZUb+xr6Gtr8wlCby/MYUFyKQv3S668YTI265
        p/0XycsOlX/nqiviihV1YvH3Ow==
X-Google-Smtp-Source: AMsMyM7TFMK3isA+fp7iIw4EoPDYXSb+wg12181ltiBDNGXSmwYGIpaDxLSwOrwPn3dWTn0BpVpbMA==
X-Received: by 2002:a17:90b:2802:b0:1fb:4efd:a1ca with SMTP id qb2-20020a17090b280200b001fb4efda1camr6382460pjb.198.1663891146753;
        Thu, 22 Sep 2022 16:59:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h6-20020aa79f46000000b00540ffb28da0sm5214850pfr.91.2022.09.22.16.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 16:59:06 -0700 (PDT)
Date:   Thu, 22 Sep 2022 23:59:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v3 5/7] KVM: x86/pmu: Defer counter emulated overflow via
 pmc->prev_counter
Message-ID: <Yyz2x5bSR/7ZTV0R@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
 <20220831085328.45489-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085328.45489-6-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Like Xu wrote:
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 7f391750ebd3..3c42df3a55ff 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -349,6 +349,10 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  		}
>  
>  		reprogram_counter(pmc);
> +
> +		if (pmc->counter < pmc->prev_counter)
> +			__kvm_perf_overflow(pmc, false);

I would prefer to stick this in repgrogram_counter(), after pausing the counter
and checking that the event is enabled, but before the actual programming/resume.

I don't think false positives are actually possible, especially without my fixes
for clearing reprogram_pmi bits (incoming), but I don't like the twisty logic
that's required to suss out that prev_counter can be non-zero if and only if the
PMC is enabled.

The bigger issue is that calling __kvm_perf_overflow() here can get false negatives.
If reprogramming fails due to contention, the reprogram_pmi bit will be left set
and so this check in __kvm_perf_overflow() will suppress the PMI.

	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
		return;

And the related issue is that because __kvm_perf_overflow() sets the bit and
makes another KVM_REQ_PMU, overflow will cause KVM to reprogram the counter a
second time.  That's especially inefficient since KVM will get quite far into the
VM-Enter flow before detecting the new event.

So, I think this? (goes on top of patches I'm about to post)

static void reprogram_counter(struct kvm_pmc *pmc)
{
	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
	u64 eventsel = pmc->eventsel;
	u64 new_config = eventsel;
	u8 fixed_ctr_ctrl;

	pmc_pause_counter(pmc);

	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
		goto reprogram_complete;

	if (!check_pmu_event_filter(pmc))
		goto reprogram_complete;

	if (pmc->counter < pmc->prev_counter)
		__kvm_perf_overflow(pmc, false);

	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
		printk_once("kvm pmu: pin control bit is ignored\n");

	if (pmc_is_fixed(pmc)) {
		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
						  pmc->idx - INTEL_PMC_IDX_FIXED);
		if (fixed_ctr_ctrl & 0x1)
			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
		if (fixed_ctr_ctrl & 0x2)
			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
		if (fixed_ctr_ctrl & 0x8)
			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
		new_config = (u64)fixed_ctr_ctrl;
	}

	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
		goto reprogram_complete;

	pmc_release_perf_event(pmc);

	pmc->current_config = new_config;

	/*
	 * If reprogramming fails, e.g. due to contention, leave the counter's
	 * regprogram bit set, i.e. opportunistically try again on the next PMU
	 * refresh.  Don't make a new request as doing so can stall the guest
	 * if reprogramming repeatedly fails.
	 */
	if (pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
				  (eventsel & pmu->raw_event_mask),
				  !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
				  !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
				  eventsel & ARCH_PERFMON_EVENTSEL_INT))
		return;

reprogram_complete:
	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
	pmc->prev_counter = 0;
}


static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
{
	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
	bool skip_pmi = false;

	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
		if (!in_pmi) {
			/*
			 * TODO: KVM is currently _choosing_ to not generate records
			 * for emulated instructions, avoiding BUFFER_OVF PMI when
			 * there are no records. Strictly speaking, it should be done
			 * as well in the right context to improve sampling accuracy.
			 */
			skip_pmi = true;
		} else {
			/* Indicate PEBS overflow PMI to guest. */
			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
						      (unsigned long *)&pmu->global_status);
		}
	} else {
		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
	}

	if (!pmc->intr || skip_pmi)
		return;

	/*
	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
	 * can be ejected on a guest mode re-entry. Otherwise we can't
	 * be sure that vcpu wasn't executing hlt instruction at the
	 * time of vmexit and is not going to re-enter guest mode until
	 * woken up. So we should wake it, but this is impossible from
	 * NMI context. Do it from irq work instead.
	 */
	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
	else
		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
}

static void kvm_perf_overflow(struct perf_event *perf_event,
			      struct perf_sample_data *data,
			      struct pt_regs *regs)
{
	struct kvm_pmc *pmc = perf_event->overflow_handler_context;

	/*
	 * Ignore overflow events for counters that are scheduled to be
	 * reprogrammed, e.g. if a PMI for the previous event races with KVM's
	 * handling of a related guest WRMSR.
	 */
	if (test_and_set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi))
		return;

	__kvm_perf_overflow(pmc, true);

	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
}

