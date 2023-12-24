Return-Path: <kvm+bounces-5198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF4F81DB5A
	for <lists+kvm@lfdr.de>; Sun, 24 Dec 2023 17:27:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D0921F21598
	for <lists+kvm@lfdr.de>; Sun, 24 Dec 2023 16:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4273BCA7B;
	Sun, 24 Dec 2023 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRdqEg9I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687ABCA64;
	Sun, 24 Dec 2023 16:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F83C433C8;
	Sun, 24 Dec 2023 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703435236;
	bh=4ed1q4p7tlBLnSJbNqgVjswznxS7kod3elBEnjU5yxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GRdqEg9IiABX3469J7q+sQkjwWvIb4y1DPXKHBaYjkuvJZ01mkU2W22sitpqH9mRN
	 /3NgiHW4ArdsDR5jRuB21ar4nlsMPJp9Mhw3p0tfZSKObn7wULvn2ImIRHg5y4Ievu
	 fMwQb/mqzlY6gGPz5NyCIfZwyyBOUjC8exN40HEttOerPRyF5CKkteeCUUItnKQf/L
	 EPqAHC0YxjuwhCnMCqhsxGPwlNTn/HMznD4anYpQ5C8lDGlF1LTwcE+tkiQQfkBF3w
	 KAn+F/zZgtNKk4LDDcqevr9uzsyXNWkIIoWQeUHD9I7kwXsGJqiiprHEXqR9XOL+Jl
	 PVAV+FVdVEuNQ==
Date: Sun, 24 Dec 2023 16:27:09 +0000
From: Simon Horman <horms@kernel.org>
To: Peter Hilber <peter.hilber@opensynergy.com>
Cc: linux-kernel@vger.kernel.org,
	"D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, jstultz@google.com,
	giometti@enneenne.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/7] x86/tsc: Add clocksource ID, set
 system_counterval_t.cs_id
Message-ID: <20231224162709.GA230301@kernel.org>
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
 <20231215220612.173603-3-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215220612.173603-3-peter.hilber@opensynergy.com>

On Fri, Dec 15, 2023 at 11:06:07PM +0100, Peter Hilber wrote:
> Add a clocksource ID for TSC and a distinct one for the early TSC.
> 
> Use distinct IDs for TSC and early TSC, since those also have distinct
> clocksource structs. This should help to keep existing semantics when
> comparing clocksources.
> 
> Also, set the recently added struct system_counterval_t member cs_id to the
> TSC ID in the cases where the clocksource member is being set to the TSC
> clocksource. In the future, this will keep get_device_system_crosststamp()
> working, when it will compare the clocksource id in struct
> system_counterval_t, rather than the clocksource.
> 
> For the x86 ART related code, system_counterval_t.cs == NULL corresponds to
> system_counterval_t.cs_id == CSID_GENERIC (0).
> 
> Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>

Hi Peter,

some minor feedback from my side that you may consider for
a future revision.

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c

...

> @@ -1327,12 +1334,15 @@ EXPORT_SYMBOL(convert_art_to_tsc);
>   * that this flag is set before conversion to TSC is attempted.
>   *
>   * Return:
> - * struct system_counterval_t - system counter value with the pointer to the
> + * struct system_counterval_t - system counter value with the ID of the
>   *	corresponding clocksource
>   *	@cycles:	System counter value
>   *	@cs:		Clocksource corresponding to system counter value. Used
>   *			by timekeeping code to verify comparability of two cycle
>   *			values.
> + *	@cs_id:		Clocksource ID corresponding to system counter value.
> + *			Used by timekeeping code to verify comparability of two
> + *			cycle values.

None of the documented parameters to convert_art_ns_to_tsc() above
correspond to the parameters of convert_art_ns_to_tsc() below.

I would suggest a separate patch to address this.
And dropping this hunk from this patch.

The same patch that corrects the kernel doc for convert_art_ns_to_tsc()
could also correct the kernel doc for tsc_refine_calibration_work()
by documenting it's work parameter.

>   */
>  
>  struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
> @@ -1347,8 +1357,11 @@ struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
>  	do_div(tmp, USEC_PER_SEC);
>  	res += tmp;
>  
> -	return (struct system_counterval_t) { .cs = art_related_clocksource,
> -					      .cycles = res};
> +	return (struct system_counterval_t) {
> +		.cs = art_related_clocksource,
> +		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
> +		.cycles = res
> +	};
>  }
>  EXPORT_SYMBOL(convert_art_ns_to_tsc);
>  
> @@ -1454,8 +1467,10 @@ static void tsc_refine_calibration_work(struct work_struct *work)
>  	if (tsc_unstable)
>  		goto unreg;
>  
> -	if (boot_cpu_has(X86_FEATURE_ART))
> +	if (boot_cpu_has(X86_FEATURE_ART)) {
>  		art_related_clocksource = &clocksource_tsc;
> +		have_art = true;
> +	}
>  	clocksource_register_khz(&clocksource_tsc, tsc_khz);
>  unreg:
>  	clocksource_unregister(&clocksource_tsc_early);

...

