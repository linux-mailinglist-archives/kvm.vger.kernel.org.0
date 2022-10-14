Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC35FF23C
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJNQ0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 12:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiJNQ0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 12:26:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AAF1D1A81
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:26:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so5174719pjf.5
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h1RXoRckstVb64Zu+F1W32N42yM60nxrLN8ZPInKuxo=;
        b=m/3oQYy3MIFFJC/h1U8wCfy0YRay4gwaS4HXwRWu2JP+4vy5pXAup7/SDQukrMh3/o
         O/v7+22bdN5KhmSQ4wzhiMDJQjwYSMrQAYaHFZd45rvbzaubn4OmH/7iZbUwAln9ndvs
         4pr2yBKusDUtjqhYG89/L2iSo61jwd8DvDvhqXElLNm6RUaL4MQGu6EWjPp9dqhhK35d
         HQWlSo4OTxppTIRwHNU3U/838VrxsEtXZDg3Uuuxr/G20Au0uwus1iybc0G2UzQuE7np
         kgmWSeQSpTY0XznejcPJBD/oukKXb2S77OzX3Ki1xEVTDD9gmn6sFCzRpy5XPi3Puxv+
         0U6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1RXoRckstVb64Zu+F1W32N42yM60nxrLN8ZPInKuxo=;
        b=iwMK901B0lZ/NkAB9OfFE++l7zi9o3NyZtfNO0AdfSbNvAQQuJ7++zDSF4Rv7MCk+R
         cp5/QKvICYx4YZZHr5vChw/I1p7j5+XCBP/FNPkulXH6C4j1T/52BtWzg6/zDJPMQ+/c
         KAIywO702YD6lEKNk84T+yeb70CNfPWuRiEpktHc+zty19TUY0JJocV5CciTVqQ84exu
         q8NwzRpJjFv35thHg3aWVL1gA+IM287o/vOVr6myt8+VDVIxtJZI3k8yH7grTTOVd7g6
         LcifJ2jqgPIU1na5SuTun+xnLxgsSkD7CqCdur3wVD5KdhoUUwEE5jw/CD/hj/g4E31g
         ghGg==
X-Gm-Message-State: ACrzQf3i5H2ytoz4sbyHvCisaQnmH4bKeZgwteXQzD+qvFAVTpiQnyot
        T+qd0yz48roqiZpqPEF+0Np8XQ==
X-Google-Smtp-Source: AMsMyM4Qx0bT+j0Nq4kEAkLDzEZzpTIqW0tcJOtc/EriGOjKLLenS5eDVt8GVaVguViHKVfhOpGfXQ==
X-Received: by 2002:a17:90b:2247:b0:20d:a2be:95ae with SMTP id hk7-20020a17090b224700b0020da2be95aemr11935369pjb.244.1665764808417;
        Fri, 14 Oct 2022 09:26:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b0016c50179b1esm1923881pli.152.2022.10.14.09.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 09:26:48 -0700 (PDT)
Date:   Fri, 14 Oct 2022 16:26:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86/pmu: Clear "reprogram" bit if counter is
 disabled or disallowed
Message-ID: <Y0mNxJGpXPAwKLML@google.com>
References: <20220923001355.3741194-1-seanjc@google.com>
 <20220923001355.3741194-3-seanjc@google.com>
 <2a83292b-a4d0-8d5e-b52a-31b7fcad2de6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a83292b-a4d0-8d5e-b52a-31b7fcad2de6@gmail.com>
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

On Fri, Oct 14, 2022, Like Xu wrote:
> For subject title, the "reprogram" bit is _only_ used to keep track of
> pmc->perf_event,
> not whether the counter is disabled.
> 
> On 23/9/2022 8:13 am, Sean Christopherson wrote:
> > When reprogramming a counter, clear the counter's "reprogram pending" bit
> > if the counter is disabled (by the guest) or is disallowed (by the
> > userspace filter).  In both cases, there's no need to re-attempt
> > programming on the next coincident KVM_REQ_PMU as enabling the counter by
> > either method will trigger reprogramming.
> 
> Perhaps we could move the check_pmu_event_filter() towards the top of the
> call stack.

Top of what call stack exactly?  reprogram_counter() has multiple callers, and
the filter check is already near the top of reprogram_counter().

> > @@ -245,7 +245,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
> >   	perf_event_enable(pmc->perf_event);
> >   	pmc->is_paused = false;
> > -	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
> 
> This change is very suspicious.

In the current code, pmc_resume_counter() clears the bit iff it returns true.
With this patch, reprogram_counter() is guarnteed to clear the bit if
pmc_resume_counter() returns true.

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

> > @@ -324,16 +323,27 @@ void reprogram_counter(struct kvm_pmc *pmc)
> >   	}
> >   	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
> > -		return;
> > +		goto reprogram_complete;
> >   	pmc_release_perf_event(pmc);
> >   	pmc->current_config = new_config;
> > -	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
> > -			      (eventsel & pmu->raw_event_mask),
> > -			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
> > -			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> > -			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
> > +
> > +	/*
> > +	 * If reprogramming fails, e.g. due to contention, leave the counter's
> > +	 * regprogram bit set, i.e. opportunistically try again on the next PMU
> 
> This is what we need, in the upstream case we need to keep trying regprogram
> to try to occupy the hardware.

Maybe in an ideal world, but in reality KVM can't guarantee that programming will
ever succeed.  Making a new KVM_REQ_PMU will prevent entering the guest, i.e. will
effectively hang the vCPU.  Breaking the vPMU isn't great, but hanging the guest
is worse.

> > +	 * refresh.  Don't make a new request as doing so can stall the guest
> > +	 * if reprogramming repeatedly fails.
> 
> This does not happen, the guest still enters w/p perf_event backend support
> and the vPMU is broken until the next vm-exit.
> 
> There is no need to endlessly call kvm_pmu_handle_event() when reprogram fails.

Yes, that's what the above comment is calling out, or at least trying to call out.
