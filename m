Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83894C3450
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387855AbfJAMdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:33:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:21857 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfJAMdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:33:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 05:33:50 -0700
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="185168539"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.172.165]) ([10.249.172.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 01 Oct 2019 05:33:46 -0700
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
Date:   Tue, 1 Oct 2019 20:33:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001082321.GL4519@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2019/10/1 16:23, Peter Zijlstra wrote:
> On Mon, Sep 30, 2019 at 03:22:57PM +0800, Like Xu wrote:
>> +	union {
>> +		u8 event_count :7; /* the total number of created perf_events */
>> +		bool enable_cleanup :1;
> 
> That's atrocious, don't ever create a bitfield with base _Bool.

I saw this kind of usages in the tree such as "struct 
arm_smmu_master/tipc_mon_state/regmap_irq_chip".

I'm not sure is this your personal preference or is there a technical
reason such as this usage is not incompatible with union syntax?

My design point is to save a little bit space without introducing
two variables such as "int event_count & bool enable_cleanup".

One of the alternatives is to introduce "u8 pmu_state", where the last 
seven bits are event_count for X86_PMC_IDX_MAX and the highest bit is 
the enable_cleanup bit. Are you OK with this ?

By the way, is the lazy release mechanism looks reasonable to you?

> 
>> +	} state;
> 

