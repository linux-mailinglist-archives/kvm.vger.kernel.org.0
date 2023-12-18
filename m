Return-Path: <kvm+bounces-4703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E26D6816AE7
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AFB71C22609
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEE814ABD;
	Mon, 18 Dec 2023 10:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GIwHuhOy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5558313AC2;
	Mon, 18 Dec 2023 10:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702895025; x=1734431025;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OR8ENRQEVanZisncmHUkNCSziQATmbvmhDTN5mpUyIE=;
  b=GIwHuhOybTOdTaDw5shnbLYkoOmyuhL4Rq9vErQUh9aBKsfYgdkQ/ZGp
   7nlVdifKjn/9FNYuEeK2L+wfCtcvI9QxDyvZllP2/+M7WqBoAuw8zOS4n
   BQiF0xYpiH8/PhsDJvb8D07OP4GNoG5Yh/OGEQuvGfSD4mjJbY76vNoF9
   lRWcI7Zsi/McMgnEB0JaWm89x50U5PKj1TUPmjaLNlxM3l/zo4dlIOZbi
   6nNsHOW2gBpR2n4sMZrXmPcmFwFgEf39WWQlq9hBYefqjd6MXk7Z+N1pc
   hmQ3o4vl+QuVzsI0Tvk/qHDZPJUV9jE7iVgBT5hMC5e/ogvwKj0uP+pGv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2692351"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="2692351"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 02:23:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="809764965"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="809764965"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 02:23:37 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1rFAmb-00000006tHO-0x88;
	Mon, 18 Dec 2023 12:23:33 +0200
Date: Mon, 18 Dec 2023 12:23:32 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Peter Hilber <peter.hilber@opensynergy.com>
Cc: linux-kernel@vger.kernel.org,
	"D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, jstultz@google.com,
	giometti@enneenne.com, corbet@lwn.net,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/7] x86/kvm, ptp/kvm: Add clocksource ID, set
 system_counterval_t.cs_id
Message-ID: <ZYAdpPfFa2jlmZ44@smile.fi.intel.com>
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
 <20231215220612.173603-4-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215220612.173603-4-peter.hilber@opensynergy.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Dec 15, 2023 at 11:06:08PM +0100, Peter Hilber wrote:
> Add a clocksource ID for the x86 kvmclock.
> 
> Also, for ptp_kvm, set the recently added struct system_counterval_t member
> cs_id to the clocksource ID (x86 kvmclock or Arm Generic Timer). In the
> future, this will keep get_device_system_crosststamp() working, when it
> will compare the clocksource id in struct system_counterval_t, rather than
> the clocksource.
> 
> For now, to avoid touching too many subsystems at once, extract the
> clocksource ID from the clocksource. The clocksource dereference will be
> removed in the following.

...

>  #include <linux/clocksource.h>
> +#include <linux/clocksource_ids.h>

It's the second file that includes both.

I'm just wondering if it makes sense to always (?) include the latter into
the former.

-- 
With Best Regards,
Andy Shevchenko



