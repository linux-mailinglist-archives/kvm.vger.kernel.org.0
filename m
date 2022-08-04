Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03943589F60
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiHDQ0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 12:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiHDQ0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 12:26:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD103F5B3
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 09:26:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x2-20020a17090ab00200b001f4da5cdc9cso5816965pjq.0
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 09:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=DhBplwpaPeTaCFx/niHA49c/n3C4puGXVVJPr46SB8U=;
        b=D92LV2Ch21YKDoy3TFGttPN77fNd88+lCbM/77UxAFQ/Yg/YyRIGwhWQ/WrU3C3JjS
         WeOx6AAex6Y+rEFGpkBSaeA4wNX5J6l6AKJgZeOfU6+bzTRzJOsFXVVSKKX6EBNhOSK3
         vB5otOYZZ1+szsRG4GSi1QKRyqYx19TTDOzJvb+E89UXT5bj11nWC37HuYUD6hf6l0ac
         Xq3EDFgFBrhb3eKPDKMXk+kZILt8T2pt+QmKSvUdK1suYgjJYfYFDGdIGp2GPfYYigeK
         VLUwhFmUEbRnW8wPOC7GQfEQtF5kUlK0NqJRfe3pBM4qckHvByC4I+gSPKGtqBB8xgGD
         zywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=DhBplwpaPeTaCFx/niHA49c/n3C4puGXVVJPr46SB8U=;
        b=V3j1YUoZRDQU7A9ghVxMhvbECKa8zKy+pxz8qgk9ulCHPkUyC1vcgM4W02F68/xq3y
         GUNvtWZCZQKMVLYzx5OTUoj4W4PKEW2dWoa2k9mpVVEeCZBv97i0Yhu4shEC9cd3vQpv
         gM88oSr00jIXkXahESj8A6eumTfO+Y804CApydN+bIUM7NHIliVo34d+AJeoegvFJLd8
         lhcyCyyVqgYqxC7EPHHdQ7T5wY23/G/y5ZxeJsrhmzflKP9uoDIsZAXeI/On5lEJxa17
         i1IaP238w+xy2SqPAemUaV7fZOFR2HyQ7njUjQeJ9wX6WQ8d9hgTQi7SEu6sxVOLRXzZ
         0hFg==
X-Gm-Message-State: ACgBeo0Y1to8Wy2+QlL/vZSjqvdIvl0bzIGeN8c0r4YxJJbq3L/Cq21c
        4b0z9oejrqXmiGuYz4aKIVs3jQ==
X-Google-Smtp-Source: AA6agR7JjZindUafniPMeRWjFyssaE0qSGH6obK2HJ0jMXKGWgMpUSeGPRk0eYCbV4QRcJqNoLs15A==
X-Received: by 2002:a17:902:c401:b0:16f:b59:85a7 with SMTP id k1-20020a170902c40100b0016f0b5985a7mr2622460plk.115.1659630371081;
        Thu, 04 Aug 2022 09:26:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d28-20020aa797bc000000b0052dee21fecdsm1200564pfq.77.2022.08.04.09.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 09:26:10 -0700 (PDT)
Date:   Thu, 4 Aug 2022 16:26:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <YuvzHkmU2DsBe6Rj@google.com>
References: <20220709011726.1006267-1-aaronlewis@google.com>
 <20220709011726.1006267-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709011726.1006267-2-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 09, 2022, Aaron Lewis wrote:
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index fdfd8e06fee6..016713b583bf 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(set_msr)
>  KVM_X86_PMU_OP(refresh)
>  KVM_X86_PMU_OP(init)
>  KVM_X86_PMU_OP(reset)
> +KVM_X86_PMU_OP(get_event_mask)
>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 21614807a2cb..2964f3f15fb5 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -522,6 +522,14 @@ struct kvm_pmu_event_filter {
>  #define KVM_PMU_EVENT_ALLOW 0
>  #define KVM_PMU_EVENT_DENY 1
>  
> +#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS (1u << 0)

Is this a "flag" or a "type"?  The usage in code isn't really clear, e.g. there's
both 

	if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)

and

	if (flag == KVM_PMU_EVENT_FLAG_MASKED_EVENTS)

> +#define KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert) \
> +		(((select) & 0xfful) | (((select) & 0xf00ul) << 24) | \
> +		(((mask) & 0xfful) << 24) | \
> +		(((match) & 0xfful) << 8) | \
> +		(((invert) & 0x1ul) << 23))

Please add a comment showing the actual layout, this is extremely dense to parse.
Alternatively, and probably my preference, would be to define this as a union.
Or maybe both?  E.g. so that userspace can do:

	filter[i].raw = KVM_PMU_EVENT_ENCODE_MASKED_EVENT(...);

	struct kvm_pmu_event_filter_entry {
		union {
			__u64 raw;
			struct {
				__u64 select_lo:8;
				__u64 match:8;
				__u64 rsvd1:7;
				__u64 invert:1;
				__u64 mask:8;
				__u64 select_hi:4;
				__u64 rsvd2:28;
			};
		}
	}

And that begs the question of whether or not KVM should check those "rsvd" fields.
IIUC, this layout directly correlates to hardware, and hardware defines many of the
"rsvd1" bits.  Are those just a don't care?

>  /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 3f868fed9114..99c02bbb8f32 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -197,14 +197,106 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>  	return true;
>  }
>  
> -static int cmp_u64(const void *pa, const void *pb)
> +static inline u64 get_event(u64 eventsel)
> +{
> +	return eventsel & AMD64_EVENTSEL_EVENT;
> +}
> +
> +static inline u8 get_unit_mask(u64 eventsel)
> +{
> +	return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> +}
> +
> +static inline u8 get_counter_mask(u64 eventsel)
>  {
> -	u64 a = *(u64 *)pa;
> -	u64 b = *(u64 *)pb;
> +	return (eventsel & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
> +}
> +
> +static inline bool get_invert_comparison(u64 eventsel)
> +{
> +	return !!(eventsel & ARCH_PERFMON_EVENTSEL_INV);
> +}
>  
> +static inline int cmp_safe64(u64 a, u64 b)
> +{
>  	return (a > b) - (a < b);
>  }
>  
> +static int cmp_eventsel_event(const void *pa, const void *pb)
> +{
> +	return cmp_safe64(*(u64 *)pa & AMD64_EVENTSEL_EVENT,
> +			  *(u64 *)pb & AMD64_EVENTSEL_EVENT);

Why is common x86 code reference AMD64 masks?  If "AMD64" here just means the
x86-64 / AMD64 architecture, i.e. is common to AMD and Intel, a comment to call
that out would be helpful.

> +}
> +
> +static int cmp_u64(const void *pa, const void *pb)
> +{
> +	return cmp_safe64(*(u64 *)pa,
> +			  *(u64 *)pb);
> +}
> +
> +static inline bool is_match(u64 masked_event, u64 eventsel)

Maybe "is_filter_entry_match"?

> +{
> +	u8 mask = get_counter_mask(masked_event);
> +	u8 match = get_unit_mask(masked_event);
> +	u8 unit_mask = get_unit_mask(eventsel);
> +
> +	return (unit_mask & mask) == match;
> +}
> +
> +static inline bool is_inverted(u64 masked_event)
> +{
> +	return get_invert_comparison(masked_event);
> +}

This is a pointless wrapper.  I suspect you added it to keep line lengths short,
but there are better ways to accomplish that.  More below.

> +
> +static bool is_filtered(struct kvm_pmu_event_filter *filter, u64 eventsel,
> +			bool invert)
> +{
> +	u64 key = get_event(eventsel);
> +	u64 *event, *evt;
> +
> +	event = bsearch(&key, filter->events, filter->nevents, sizeof(u64),
> +			cmp_eventsel_event);
> +
> +	if (event) {
> +		/* Walk the masked events backward looking for a match. */

This isn't a very helpful comment.  It's obvious enough from the code that this
walks backwards looking for a match, while the next one walks forward.  But it's
not immediately obvious _why_ that's the behavior.  I eventually realized the code
is looking for _any_ match, but a comment above this function documenting that
would would be very helpful.

And doesn't this approach yield somewhat arbitrary behavior?  If there are multiple
filters for 

> +		for (evt = event; evt >= filter->events &&
> +		     get_event(*evt) == get_event(eventsel); evt--)

The outer for-loop needs curly braces.  See "3) Placing Braces and Spaces" in
Documentation/process/coding-style.rst.

The "get_event() == get_event()" 
 
I have a strong dislike for arithmetic on pointers that aren't a single byte.  I
don't think it's entirely avoidable, but it could be contained (see below).,

> +			if (is_inverted(*evt) == invert && is_match(*evt, eventsel))

The is_inverted() helper can be avoided by handling the inversion check in
is_match().

			if (is_match(*event, eventsel, invert)

	if (entry) {
		pivot = <compute index of found entry>

		/*
		 * comment about how the key works and wanting to find any
		 * matching filter entry.
		 */
		for (i = pivot; i > 0; i--) {
			entry = &filter->events[i];
			if (get_event(*entry) != get_event(eventsel)
				break;
	
			if (is_match(*entry, eventsel, invert))
				return true;
		}

		for (i = pivot + 1; i < filter->nevents; i++) {
			entry = &filter->events[i];                             
                        if (get_event(*entry) != get_event(eventsel)            
                                break;                                          
                                                                                
                        if (is_match(*entry, eventsel, invert))                 
                                return true;  
		}
	}

> +				return true;
> +
> +		/* Walk the masked events forward looking for a match. */
> +		for (evt = event + 1;
> +		     evt < (filter->events + filter->nevents) &&
> +		     get_event(*evt) == get_event(eventsel); evt++)
> +			if (is_inverted(*evt) == invert && is_match(*evt, eventsel))
> +				return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool allowed_by_masked_events(struct kvm_pmu_event_filter *filter,
> +				     u64 eventsel)
> +{
> +	if (is_filtered(filter, eventsel, /*invert=*/false))

Outer if-statement needs curly braces.  But even better would be to do:

	if (is_filter(...) &&
	    !is_filter(...))
		return filter->action == KVM_PMU_EVENT_ALLOW;

That said, I have zero idea what the intended logic is, i.e. this needs a verbose
comment.   Maybe if I was actually familiar with PMU event magic it would be obvious,
but I won't be the last person that reads this code with only a passing undertsanding
of PMU events.

Specifically, having an inverted flag _and_ an inverted bit in the event mask is
confusing.

> +		if (!is_filtered(filter, eventsel, /*invert=*/true))
> +			return filter->action == KVM_PMU_EVENT_ALLOW;
> +
> +	return filter->action == KVM_PMU_EVENT_DENY;
> +}
> +
> +static bool allowed_by_default_events(struct kvm_pmu_event_filter *filter,
> +				    u64 eventsel)
> +{
> +	u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;

Again, a comment would be helpful.  What is a "default" event?  Why does that use
a "raw" mask as they key?  But the "default" part can be avoided entirely, see below.

> +
> +	if (bsearch(&key, filter->events, filter->nevents,
> +		    sizeof(u64), cmp_u64))

Let this poke out, it's only 82 chars.  Though I would say add a helper to do the
search.  That will also make it easier to use a unionized bitfield, e.g.

static __always_inline u64 *find_filter_entry(struct kvm_pmu_event_filter *filter,
					      u64 key, cmp_func_t cmp_fn)
{
	struct kvm_pmu_event_filter_entry *entry;

	entry = bsearch(&key, filter->events, filter->nevents,
			sizeof(filter->events[0]), cmp_fn);
	if (!entry)
		return NULL;

	return entry->raw;
}

> +		return filter->action == KVM_PMU_EVENT_ALLOW;
> +
> +	return filter->action == KVM_PMU_EVENT_DENY;
> +}
> +
>  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  {
>  	u64 config;
> @@ -226,14 +318,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  
>  	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
>  	if (filter) {
> -		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> -
> -		if (bsearch(&key, filter->events, filter->nevents,
> -			    sizeof(__u64), cmp_u64))
> -			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> -		else
> -			allow_event = filter->action == KVM_PMU_EVENT_DENY;
> +		allow_event = (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) ?
> +			allowed_by_masked_events(filter, eventsel) :
> +			allowed_by_default_events(filter, eventsel);

Using a ternary operator isn't buying much.  E.g. IMO this is more readable:

		if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
			allow_event = allowed_by_masked_events(filter, eventsel);
		else
			allow_event = allowed_by_default_events(filter, eventsel);

But again, better to avoid this entirely.

>  	}
> +
>  	if (!allow_event)

Checking "allow_event" outside of the "if (filter)" is unnecessary and confusing.

>  		return;

Rather than have separate helpers for "masked" versus "default", just have a single
"is_event_allowed"

static bool is_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
{
	u64 key;

	if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
		if (is_filtered(filter, eventsel, false) &&
	    	    !is_filtered(filter, eventsel, true))
			return filter->action == KVM_PMU_EVENT_ALLOW;
		goto not_filtered;
	}

	key = eventsel & AMD64_RAW_EVENT_MASK_NB;
	if (find_filter_entry(filter, key, cmp_u64))
		return filter->action == KVM_PMU_EVENT_ALLOW;

not_filtered:
	return filter->action == KVM_PMU_EVENT_DENY;
}


And then this is succint and readable:

	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
	if (filter && !is_event_allowed(filter, eventsel))
		return;
