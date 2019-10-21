Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F177DE20E
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 04:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfJUC0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 22:26:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:24376 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfJUC0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 22:26:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 19:26:06 -0700
X-IronPort-AV: E=Sophos;i="5.67,321,1566889200"; 
   d="scan'208";a="190965593"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.130]) ([10.239.196.130])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 20 Oct 2019 19:26:03 -0700
Subject: Re: [PATCH v2 0/4] KVM: x86/vPMU: Efficiency optimization by reusing
 last created perf_event
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20191013091533.12971-1-like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <e567902b-4ae6-c880-2ed3-9c9170496cbd@linux.intel.com>
Date:   Mon, 21 Oct 2019 10:26:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191013091533.12971-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/13 17:15, Like Xu wrote:
...

Hi Paolo,

Do you have any concerns or comments for the KVM codes (the last two 
patches) about this vPMU efficiency optimization?

Thanks,
Like Xu

> 
> ---
> Changes in v2:
> - use perf_event_pause() to disable, read, reset by only one lock;
> - use __perf_event_read_value() after _perf_event_disable();
> - replace bitfields with 'u8 event_count; bool need_cleanup;';
> - refine comments and commit messages;
> - fix two issues reported by kbuild test robot for ARCH=[nds32|sh]
> 
> v1:
> https://lore.kernel.org/kvm/20190930072257.43352-1-like.xu@linux.intel.com/
> 
> Like Xu (4):
>    perf/core: Provide a kernel-internal interface to recalibrate event
>      period
>    perf/core: Provide a kernel-internal interface to pause perf_event
>    KVM: x86/vPMU: Reuse perf_event to avoid unnecessary
>      pmc_reprogram_counter
>    KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC
> 
>   arch/x86/include/asm/kvm_host.h | 17 +++++++
>   arch/x86/kvm/pmu.c              | 88 ++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/pmu.h              | 15 +++++-
>   arch/x86/kvm/pmu_amd.c          | 14 ++++++
>   arch/x86/kvm/vmx/pmu_intel.c    | 27 ++++++++++
>   arch/x86/kvm/x86.c              | 12 +++++
>   include/linux/perf_event.h      | 10 ++++
>   kernel/events/core.c            | 44 ++++++++++++++---
>   8 files changed, 216 insertions(+), 11 deletions(-)
> 

