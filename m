Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03857330D04
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 13:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCHMCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 07:02:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:31226 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhCHMCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 07:02:02 -0500
IronPort-SDR: idO0w4Gj6XLmgMnobkU4djBrbbO4bQERtFgUUxkmoj5sA34CY8wjafbLa/qsU4Zl3JK3ZInsxK
 mxKE2pDINK5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="249392912"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="249392912"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 04:02:01 -0800
IronPort-SDR: E4eWEzz3M91SoK7Ba57k2QiKDBTD3PA3L0Gt/Fil8oVrwjzYX6GsV16oQ92n6/FNrSKGPPtK03
 xQSr9NGyHsWA==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="409271094"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.152]) ([10.249.171.152])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 04:01:57 -0800
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no
 PMU
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Thomas Gleixner
         "(x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)"
         "(x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <b209d39c-8c0d-93ce-c81d-be2dfea33ad6@intel.com>
Date:   Mon, 8 Mar 2021 20:01:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/8 16:53, Peter Zijlstra wrote:
> Still, it calling atomic_switch_perf_msrs() and
> intel_pmu_lbr_is_enabled() when there isn't a PMU at all is of course, a
> complete waste of cycles.

This suggestion is reminiscent of a sad regression of optimizing it:

https://lore.kernel.org/kvm/20200619094046.654019-1-vkuznets@redhat.com/
https://lore.kernel.org/kvm/20210209225653.1393771-1-jmattson@google.com/
