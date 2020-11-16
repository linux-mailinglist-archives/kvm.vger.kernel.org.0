Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D742B3BCE
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 04:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKPDWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 22:22:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:59623 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgKPDWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 22:22:36 -0500
IronPort-SDR: dVvUgWlIefuJFpK1Fgqg0gdbEe0zOxlojTnNNY/X/viOTeyzSxvDW7k5F+DMI7ma119GO/dZqE
 tvXd9rInwckA==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="157720988"
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="157720988"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 19:22:30 -0800
IronPort-SDR: C+9UVmClgbQXVE9Nm0up9iKW+Io7rYMSXIhKHaP13k8X3o1e/U8LJRu+9DndMKIVxmuyzITj5+
 9l0OKuy62mXw==
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="543427933"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 19:22:26 -0800
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
 <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <11ba9e20-84eb-3ea5-5987-8357ae5af53f@linux.intel.com>
Date:   Mon, 16 Nov 2020 11:22:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/11/10 23:37, Peter Zijlstra wrote:
> -static int __init intel_perf_counter_freezing_setup(char *s)
> -{
> -	bool res;
> -
> -	if (kstrtobool(s, &res))
> -		return -EINVAL;
> -
> -	disable_counter_freezing = !res;
> -	return 1;
> -}
> -__setup("perf_v4_pmi=", intel_perf_counter_freezing_setup);

...

> Anyway, as it stands I think the whole counter_freezing thing is a
> trainwreck and it needs to go.

If you really want to drop the counter_freezing stuff, we also need
to clean it up in Documentation/admin-guide/kernel-parameters.txt:

	perf_v4_pmi=	[X86,INTEL]
			Format: <bool>
			Disable Intel PMU counter freezing feature.
			The feature only exists starting from
			Arch Perfmon v4 (Skylake and newer).

However someone may still need it based on the correct understanding
of "Freeze-on-Overflow" as Stephane said. How about renaming and 
documenting it instead of discarding it completely?

Our guest PEBS enabling patches does not completely depend on it
and we do not require the administrator to enable perf_v4_pmi for
guest PEBS.

Would you generously take a look at the perf part in this series?

Thanks,
Like Xu
