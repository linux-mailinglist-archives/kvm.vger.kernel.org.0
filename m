Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CB67B9902
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244055AbjJEAAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 20:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243933AbjJEAAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 20:00:22 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93FC9E
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 17:00:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27911ce6206so329632a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 17:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696464019; x=1697068819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xg1fHItfDD30kEGBPXv4s/KtEg8wMEf74IDI5PyUyeQ=;
        b=X9xVto5XlzrrqjQV/k/2JavWI+Ncs/xFYuP6pD+dub55oVCOzNIdfjn8VsVyKmd24W
         lylDwpa0ilyz/RQPtiac6a99fCQCCxmiqqTGNoOqOAEQLKKTietb+wl5/p8W7fU+XeDn
         vVfsuUfg/eAYRqWGvY7dBGDqSzqyuDP+QvG99KIBnDyD+Cn7mOihtBpfImwKwh9XgG+b
         K/ydRp8XWjDpzPjw5/goTW/JtPdyBXLWticuRhiW0JoXZ8EnzEcvQM+mO47ZmFaoaVCM
         SffXn8lesEzUQqiJf3J8lK6GkiL3j9ndbu9AHwIQHApKZJr1Fafw5xM8rV0qxKDBR4aX
         21eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696464019; x=1697068819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xg1fHItfDD30kEGBPXv4s/KtEg8wMEf74IDI5PyUyeQ=;
        b=A/yE6waTDUNfMpDkNQxxzr3zBDweDF2DH3NJ86iPNa1X70ie7RjOkPBQ3EwzONP97m
         XD9gu65KX+SApjfEjlZBwWHdviXpdxb1sT+OqhAB2OYxOSPomdIpHW8NRWjmFiQBojFr
         6ayjmtj6HUQJgKlFSwuCsUBcqRS+ZxGDw5UzJtV+llp7/Z/NCweP+aLKuwNumMXMU87S
         4SS6+IzAmTGRN8/tpiNIPUMtFchblVgXFHtHU6kL6iCXC4+109j3IUxobfoTD4gt9OXY
         u0jYvDd515lnALJ0BKi6I11OkUQ+nTK+FDO5n+sr05r7VfDCuxFyyhflBSXQS/ZKxg0V
         iQyw==
X-Gm-Message-State: AOJu0YyLn8QaJnxdp7ErtsGJKbDp9F3D2e/tCDHvMOY0KopVB1jQh3Yi
        UoQFLXsF8S/UgLYVpvF4JYkpCQ/bWEk=
X-Google-Smtp-Source: AGHT+IFWnBUbNZ5ulgXQNxMlItU9ENUDJTM0xVPGLEnppgPLdmhNe377f1+gLmsJQkXgr2cw+H/03qtw510=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4584:b0:269:6494:cbc8 with SMTP id
 v4-20020a17090a458400b002696494cbc8mr60450pjg.4.1696464019166; Wed, 04 Oct
 2023 17:00:19 -0700 (PDT)
Date:   Wed, 4 Oct 2023 17:00:17 -0700
In-Reply-To: <ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org>
Mime-Version: 1.0
References: <ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org>
Message-ID: <ZR38kaj4UIqdWwJr@google.com>
Subject: Re: [PATCH] KVM: x86: Refine calculation of guest wall clock to use a
 single TSC read
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, sveith@amazon.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>,
        inux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023, David Woodhouse wrote:
> +uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
> +{
> +	/*
> +	 * The guest calculates current wall clock time by adding
> +	 * system time (updated by kvm_guest_time_update below) to the
> +	 * wall clock specified here.  We do the reverse here.

I would much rather this be a function comment that first explains what "epoch"
means in this context.  "epoch" is a perfect fit, but I suspect it won't be all
that intuitive for many readers (definitely wasn't for me).

> +	 */
> +#ifdef CONFIG_X86_64
> +	struct pvclock_vcpu_time_info hv_clock;
> +	struct kvm_arch *ka = &kvm->arch;
> +	unsigned long seq, local_tsc_khz = 0;
> +	struct timespec64 ts;
> +	uint64_t host_tsc;
> +
> +	do {
> +		seq = read_seqcount_begin(&ka->pvclock_sc);
> +
> +		if (!ka->use_master_clock)
> +			break;

This needs to zero local_tsc_khz, no?  E.g. read everything on loop 1, but the
pvclock_sc changes because use_master_clock is disabled, and so loop 2 will bail
and the code below will consume garbage TSC/masterclock information from loop 1.

> +		/* It all has to happen on the same CPU */

Define "it all", e.g. explain exactly why the cutoff for reenabling preemption is
after reading master_kernel_ns and not before, or not after kvm_get_time_scale().

> +		get_cpu();
> +
> +		local_tsc_khz = get_cpu_tsc_khz();
> +
> +		if (local_tsc_khz &&
> +		    !kvm_get_walltime_and_clockread(&ts, &host_tsc))
> +			local_tsc_khz = 0; /* Fall back to old method */
> +
> +		hv_clock.tsc_timestamp = ka->master_cycle_now;
> +		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> +
> +		put_cpu();
> +	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
> +
> +	/*
> +	 * If the conditions were right, and obtaining the wallclock+TSC was
> +	 * successful, calculate the KVM clock at the corresponding time and
> +	 * subtract one from the other to get the epoch in nanoseconds.
> +	 */
> +	if (local_tsc_khz) {
> +		kvm_get_time_scale(NSEC_PER_SEC, local_tsc_khz * 1000LL,

s/1000LL/NSEC_PER_USEC?

> +				   &hv_clock.tsc_shift,
> +				   &hv_clock.tsc_to_system_mul);
> +		return ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec -
> +			__pvclock_read_cycles(&hv_clock, host_tsc);
> +	}
> +#endif
