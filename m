Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351736E26E
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 10:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfGSI0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 04:26:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:51802 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGSI0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 04:26:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 01:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="319903679"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2019 01:26:18 -0700
Message-ID: <5D317FFA.8000507@intel.com>
Date:   Fri, 19 Jul 2019 16:31:54 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] KVM: x86: Add fixed counters to PMU filter
References: <20190718183818.190051-1-ehankland@google.com>
In-Reply-To: <20190718183818.190051-1-ehankland@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/19/2019 02:38 AM, Eric Hankland wrote:
> From: ehankland <ehankland@google.com>
>
> Updates KVM_CAP_PMU_EVENT_FILTER so it can also whitelist or blacklist
> fixed counters.
>
> Signed-off-by: ehankland <ehankland@google.com>
> ---
>   Documentation/virtual/kvm/api.txt | 13 ++++++++-----
>   arch/x86/include/uapi/asm/kvm.h   |  9 ++++++---
>   arch/x86/kvm/pmu.c                | 30 +++++++++++++++++++++++++-----
>   3 files changed, 39 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 2cd6250b2896..96bcf1aa1931 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -4090,17 +4090,20 @@ Parameters: struct kvm_pmu_event_filter (in)
>   Returns: 0 on success, -1 on error
>   
>   struct kvm_pmu_event_filter {
> -       __u32 action;
> -       __u32 nevents;
> -       __u64 events[0];
> +	__u32 action;
> +	__u32 nevents;
> +	__u32 fixed_counter_bitmap;
> +	__u32 flags;
> +	__u32 pad[4];
> +	__u64 events[0];
>   };
>   
>   This ioctl restricts the set of PMU events that the guest can program.
>   The argument holds a list of events which will be allowed or denied.
>   The eventsel+umask of each event the guest attempts to program is compared
>   against the events field to determine whether the guest should have access.
> -This only affects general purpose counters; fixed purpose counters can
> -be disabled by changing the perfmon CPUID leaf.
> +The events field only controls general purpose counters; fixed purpose
> +counters are controlled by the fixed_counter_bitmap.
>   
>   Valid values for 'action':
>   #define KVM_PMU_EVENT_ALLOW 0
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index e901b0ab116f..503d3f42da16 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -435,9 +435,12 @@ struct kvm_nested_state {
>   
>   /* for KVM_CAP_PMU_EVENT_FILTER */
>   struct kvm_pmu_event_filter {
> -       __u32 action;
> -       __u32 nevents;
> -       __u64 events[0];
> +	__u32 action;
> +	__u32 nevents;
> +	__u32 fixed_counter_bitmap;
> +	__u32 flags;
> +	__u32 pad[4];
> +	__u64 events[0];
>   };
>   
>   #define KVM_PMU_EVENT_ALLOW 0
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index aa5a2597305a..ae5cd1b02086 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -19,8 +19,8 @@
>   #include "lapic.h"
>   #include "pmu.h"
>   
> -/* This keeps the total size of the filter under 4k. */
> -#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 63
> +/* This is enough to filter the vast majority of currently defined events. */
> +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
>   
>   /* NOTE:
>    * - Each perf counter is defined as "struct kvm_pmc";
> @@ -206,12 +206,25 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
>   {
>   	unsigned en_field = ctrl & 0x3;
>   	bool pmi = ctrl & 0x8;
> +	struct kvm_pmu_event_filter *filter;
> +	struct kvm *kvm = pmc->vcpu->kvm;
> +

unnecessary white space here, other part looks good to me.

Reviewed-by: Wei Wang <wei.w.wang@intel.com>

Best,
Wei
