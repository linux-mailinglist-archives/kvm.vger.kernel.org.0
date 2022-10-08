Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4625F8198
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 02:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJHAhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJHAhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 20:37:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831EC5113
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 17:37:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so6012337pjo.4
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 17:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6WXdeiroUwzI1m1TzkyRbdX6EmdcFzs3AcZ0suaC00w=;
        b=bng6zSE89nAhphFytrcePiNUn78t06CAG7MHmQsOuZU41sWkbGuxCGVxppU618zgOh
         pr8GxOuNIfbC737PwYyH6e7LcISnRSodGsf1S0JkykzV14loUyC5ATb+w9tSGhvuXBvD
         cpOInsWZNDPlskZb2ljFQYIrSjt8Yp/n6G3Zvy6QMUzlIbGg1plj/8vjDMU/MktJPzN+
         9rpUJtmdzohwjxbxmBf9FIfITgZdLsntfsc0v347oZr+g/Boj9mox0Hw6eVdV3shfYhD
         0h/coeo9qlLxay1eOMC0fR50iFXDEKgP5DGzXbsWVtKoXYLQh2bPVsgF+9fOOtplYxFq
         P0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WXdeiroUwzI1m1TzkyRbdX6EmdcFzs3AcZ0suaC00w=;
        b=2e6DGDW/HlMQi3MtSbJ06pAG+cpSFCHvBiQml8uFZI9+pgt0Kh4wG+YxXTvyrDOKeL
         Ie0fRZKb5mF2dSYAmeaaYh7AhNVNHslkk7X+Cj8KawpC807EBBdk8+wwfNiUs4hHx1Dz
         sBFIEjB0BQzeVBzQeiPpsT9vUW3e9vWQvQNhb2UU9puJqlDlke6f7/9pYrbbzUMr0h9R
         6S3VHhzuVU1PFD1Dzg0bNjBBuruLZ0HDn/aoK+ijFe6j+c10VectiJjrqLU39kmEfICd
         31tZOUSjdj+saJzgT3e4cZLNPoMXSXlT/es1bxqSfuz8nDRtMh8OML2SgIVjhH3KRZ9z
         uMNQ==
X-Gm-Message-State: ACrzQf0KPMVzrIULhUe8lAr4YR7bdi8qgkGW8qRwP/UHpoANdsbbSrCb
        gx7A0okrOqhoRWXW+taCRmUm1w==
X-Google-Smtp-Source: AMsMyM6g0bPGQGyBEjmD/oeHQKMI42CPv2PLf8fhDLRVppAsuHGG+/wII8iXlUn4fxX5O8CmyG2FpQ==
X-Received: by 2002:a17:90b:3903:b0:202:affa:1c9f with SMTP id ob3-20020a17090b390300b00202affa1c9fmr8210002pjb.27.1665189433147;
        Fri, 07 Oct 2022 17:37:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b001781a7c28b9sm2075255plw.240.2022.10.07.17.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 17:37:12 -0700 (PDT)
Date:   Sat, 8 Oct 2022 00:37:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <Y0DGNEvbmT3kWR56@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920174603.302510-5-aaronlewis@google.com>
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

On Tue, Sep 20, 2022, Aaron Lewis wrote:
> +To access individual components in a masked entry use:
> +::
> +  struct kvm_pmu_event_masked_entry {
> +	union {
> +	__u64 raw;
> +		struct {
> +			/* event_select bits 11:8 are only valid on AMD. */
> +			__u64 event_select:12;
> +			__u64 mask:8;
> +			__u64 match:8;
> +			__u64 exclude:1;

As suggested in patch 3, keep the architectural bits where they are and fill in
the gaps.  IIUC, all of bits 63:36 are available, i.e. there's lots of room for
expansion.  Go top down (start at 63) and cross our fingers that neither Intel
nor AMD puts stuff there.  If that does happen, then we can start mucking with
the layout, but until then, let's not make it too hard for ourselves.

> +			__u64 rsvd:35;

>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 7ce8bfafea91..b188ddb23f75 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -252,34 +252,61 @@ static inline u8 get_unit_mask(u64 eventsel)
>  	return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>  }

...

> +/*
> + * Sort will order the list by exclude, then event select.  This function will
> + * then index the sublists of event selects such that when a search is done on
> + * the list, the head of the event select sublist is returned.  This simplifies
> + * the logic in filter_contains_match() when walking the list.

Unless I'm missing something, this is a complex way to solve a relatively simple
problem.  You want a list of "includes" and a list of "excludes".  Just have two
separate lists.

Actually, if we're effectively changing the ABI, why not make everyone's lives
simpler and expose that to userspace.  E.g. use one of the "pad" words to specify
the number of "include" events and effectively do this:

struct kvm_pmu_event_filter {
	__u32 action;
	__u32 nevents;
	__u32 fixed_counter_bitmap;
	__u32 flags;
	__u32 nr_include_events;
	__u64 include[nr_include_events];
	__u64 exclude[nevents - nr_allowed_events];
};

Then we don't need to steal a bit for "exclude" in the uABI.  The kernel code
gets a wee bit simpler.

> @@ -693,6 +796,10 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	/* Ensure nevents can't be changed between the user copies. */
>  	*filter = tmp;
>  
> +	r = -EINVAL;
> +	if (!is_filter_valid(filter))

Do this in prepare_filter_events() to avoid walking the filter multiple times.
I've gotten fairly twisted around and my local copy of the code is a mess, but
something like this:

static int prepare_filter_events(struct kvm_pmu_event_filter *filter)
{
	int i;

	for (i = 0, j = 0; i < filter->nevents; i++) {
		if (filter->events[i] & ~kvm_pmu_ops.EVENTSEL_MASK) {
			if (!filter->mask)
				continue;

			if (<reserved bits set>)
				return -EINVAL;
		}

		filter->events[j++] = filter->events[i];
	}

	<more magic here>
}


> +		goto cleanup;
> +
>  	prepare_filter_events(filter);
>  
>  	mutex_lock(&kvm->lock);


