Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1962F7D3F
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbhAONyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:54:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:33803 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbhAONyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 08:54:09 -0500
IronPort-SDR: VVEEsqom9PzFjwPXiRcXBzExKnyyhYEt8PlRA3Lux599GOiOQO2+wc/U4P6KEVqmXHHP+wxocm
 gaw9QZwCvghw==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="197215176"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="197215176"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:53:29 -0800
IronPort-SDR: 7KrbAkabW0umhvJ5KcYGj4mrEiiUaIoGAfiJqcKFS1YLXOjUkCDJ9sxnL35dQ9hetMKs1Js35z
 rrFlrbT5AiIA==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382669625"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.174.174]) ([10.249.174.174])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:53:24 -0800
Subject: Re: [PATCH v3 05/17] KVM: x86/pmu: Reprogram guest PEBS event to
 emulate guest PEBS counter
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-6-like.xu@linux.intel.com>
 <YAF9mulfhGCIyNz+@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <38e774f5-81d6-4853-cbb9-d4b7811e65db@intel.com>
Date:   Fri, 15 Jan 2021 21:53:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAF9mulfhGCIyNz+@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/15 19:33, Peter Zijlstra wrote:
> On Mon, Jan 04, 2021 at 09:15:30PM +0800, Like Xu wrote:
>> When a guest counter is configured as a PEBS counter through
>> IA32_PEBS_ENABLE, a guest PEBS event will be reprogrammed by
>> configuring a non-zero precision level in the perf_event_attr.
>>
>> The guest PEBS overflow PMI bit would be set in the guest
>> GLOBAL_STATUS MSR when PEBS facility generates a PEBS
>> overflow PMI based on guest IA32_DS_AREA MSR.
>>
>> The attr.precise_ip would be adjusted to a special precision
>> level when the new PEBS-PDIR feature is supported later which
>> would affect the host counters scheduling.
> This seems like a random collection of changes, all required, but
> loosely related.

Yes, these changes are made in the KVM context, and
they are all necessary to emulate basic PEBS hw behavior.

>
>> The guest PEBS event would not be reused for non-PEBS
>> guest event even with the same guest counter index.

Let me add more KVM context here,

we would create a perf_event for a normal non-PEBS counter
and we reuse the same perf_event from time to time as much as possible
instead of "create + destroy" new perf_event.

So when a normal counter is configured for PEBS,
the original perf_event would not be reused and
a new PEBS perf_event is created, vice verse.

> /me rolls eyes at the whole destroy+create nonsense...

I absolutely agree that cross-domain development
may make maintainers' eyes uncomfortable.

My on-demand explanation is always online
if you fire more questions on this patch set.


