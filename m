Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FED22F6A2D
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 19:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbhANS4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 13:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbhANS4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 13:56:14 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AA9C061757
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 10:55:34 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id b5so3743990pjl.0
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 10:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BZd5vz4hy8Xv+MkxlJJ7ylWIWD/7dL9BLPaHzk7fwBc=;
        b=C2sF1sIAUAJVx9PwWWwp02Cw3l3B0u/TrqSSltHVQ9OjN7DXJYO7ZtFBcEH1AFHB1j
         v/waeY6VTZlJJ9p/7QbkMFLAfNuHb/mwxy66ZX4QhI+QVjc5Jc/aMwQ1MfVYDw8kTuMz
         8I3M8NnbcqDq27BkDm08ayDSChTXb4hBC9Wf6Yz5GqQj34UNP+ygcPvEbtwJO8Ok3kRX
         Rc+aInAhPqOblsd4T+yD3tuM/lecpBfOM8kU921D8IDxh94HzIl87AioKSrP8Go/iFpe
         CjdyFFzBGot82Nj5F98G76i46WLJsLBp1cxe/aACXumSfygwbsEmkOx+RE38m//2iAVP
         wDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BZd5vz4hy8Xv+MkxlJJ7ylWIWD/7dL9BLPaHzk7fwBc=;
        b=P2YVBaYVnfoEVnh/0ouW2Nm8NQ49hofAVAN97lM718y/17JiE7CblwTqaAdOyBt4hf
         sNAN6zpr1tZZsir6oAvGWJfEweD662rd205M1nQxLBZAZr0PCcP3QAKwB/4/TSFxiaHp
         7b8bTYyH0YeqWW42CXArd3noQusjXWSfMm3dUhFKyRGkcfZGeXIZxDLYQwIneDXJTZFj
         hyzL4N0Dbwgy7AVeMkUz3PuKct+x3sXFd1FdffqKinEnft7Mx/PNmIMz+8Q9ovX2okmV
         4YlnWFkhmWUfteufV1AQO2djql9/xhUCNiwt5++w4QoNSKoV8lzzwQZWiNI/LPKKkLJH
         Ywkw==
X-Gm-Message-State: AOAM533K+4GIdVshMA4OSoTMkB7LRHq+DnzbHJnjW/eZxJq3adu04ESB
        TWU5bq4i6ScdrCv46+qqGSj0y0QJUOxTcw==
X-Google-Smtp-Source: ABdhPJybpMzaxPsT4F0zX42TRtgXkpt7IELZ8MQWQhB4kA8effHT+847pPFm3sA0tjsEsCdnKa78OA==
X-Received: by 2002:a17:902:bf06:b029:dc:1f:ac61 with SMTP id bi6-20020a170902bf06b02900dc001fac61mr8924128plb.16.1610650534057;
        Thu, 14 Jan 2021 10:55:34 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id p17sm5782386pfn.52.2021.01.14.10.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:55:33 -0800 (PST)
Date:   Thu, 14 Jan 2021 10:55:26 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <YACTnkdi1rxfrRCg@google.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-5-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021, Like Xu wrote:
> ---
>  arch/x86/events/intel/ds.c | 62 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index b47cc4226934..c499bdb58373 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -1721,6 +1721,65 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
>  	return 0;
>  }
>  
> +/*
> + * We may be running with guest PEBS events created by KVM, and the
> + * PEBS records are logged into the guest's DS and invisible to host.
> + *
> + * In the case of guest PEBS overflow, we only trigger a fake event
> + * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
> + * The guest will then vm-entry and check the guest DS area to read
> + * the guest PEBS records.
> + *
> + * The guest PEBS overflow PMI may be dropped when both the guest and
> + * the host use PEBS. Therefore, KVM will not enable guest PEBS once
> + * the host PEBS is enabled since it may bring a confused unknown NMI.
> + *
> + * The contents and other behavior of the guest event do not matter.
> + */
> +static int intel_pmu_handle_guest_pebs(struct cpu_hw_events *cpuc,
> +				       struct pt_regs *iregs,
> +				       struct debug_store *ds)
> +{
> +	struct perf_sample_data data;
> +	struct perf_event *event = NULL;
> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
> +	int bit;
> +
> +	/*
> +	 * Ideally, we should check guest DS to understand if it's
> +	 * a guest PEBS overflow PMI from guest PEBS counters.
> +	 * However, it brings high overhead to retrieve guest DS in host.
> +	 * So we check host DS instead for performance.
> +	 *
> +	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
> +	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
> +	 * There is no ambiguity since the reported event in the PMI is guest
> +	 * only. It gets handled correctly on a case by case base for each event.
> +	 *
> +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.

By "KVM", do you mean KVM's loading of the MSRs provided by intel_guest_get_msrs()?
Because the PMU should really be the entity that controls guest vs. host.  KVM
should just be a dumb pipe that handles the mechanics of how values are context
switch.

For example, commit 7099e2e1f4d9 ("KVM: VMX: disable PEBS before a guest entry"),
where KVM does an explicit WRMSR(PEBS_ENABLE) to (attempt to) force PEBS
quiescence, is flawed in that the PMU can re-enable PEBS after the WRMSR if a
PMI arrives between the WRMSR and VM-Enter (because VMX can't block NMIs).  The
PMU really needs to be involved in the WRMSR workaround.

> +	 */
> +	if (!guest_pebs_idxs || !in_nmi() ||

Are PEBS updates guaranteed to be isolated in both directions on relevant
hardware?  By that I mean, will host updates be fully processed before VM-Enter
compeletes, and guest updates before VM-Exit completes?  If that's the case,
then this path could be optimized to change the KVM invocation of the NMI
handler so that the "is this a guest PEBS PMI" check is done if and only if the
PMI originated from with the guest.

> +		ds->pebs_index >= ds->pebs_interrupt_threshold)
> +		return 0;
> +
> +	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
> +			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
> +
> +		event = cpuc->events[bit];
> +		if (!event->attr.precise_ip)
> +			continue;
> +
> +		perf_sample_data_init(&data, 0, event->hw.last_period);
> +		if (perf_event_overflow(event, &data, iregs))
> +			x86_pmu_stop(event, 0);
> +
> +		/* Inject one fake event is enough. */
> +		return 1;
> +	}
> +
> +	return 0;
> +}
