Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C5D45879
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 11:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfFNJVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 05:21:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:62342 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfFNJVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 05:21:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 02:21:13 -0700
X-ExtLoop1: 1
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 02:21:12 -0700
Message-ID: <5D036843.2010607@intel.com>
Date:   Fri, 14 Jun 2019 17:26:27 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
In-Reply-To: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/23/2019 06:23 AM, Eric Hankland wrote:
> - Add a VCPU ioctl that can control which events the guest can monitor.
>
> Signed-off-by: ehankland <ehankland@google.com>
> ---
> Some events can provide a guest with information about other guests or the
> host (e.g. L3 cache stats); providing the capability to restrict access
> to a "safe" set of events would limit the potential for the PMU to be used
> in any side channel attacks. This change introduces a new vcpu ioctl that
> sets an event whitelist. If the guest attempts to program a counter for
> any unwhitelisted event, the kernel counter won't be created, so any
> RDPMC/RDMSR will show 0 instances of that event.
> ---
>   Documentation/virtual/kvm/api.txt | 16 +++++++++++
>   arch/x86/include/asm/kvm_host.h   |  1 +
>   arch/x86/include/uapi/asm/kvm.h   |  7 +++++
>   arch/x86/kvm/pmu.c                | 44 +++++++++++++++++++++++++++++++
>   arch/x86/kvm/pmu.h                |  3 +++
>   arch/x86/kvm/pmu_amd.c            | 16 +++++++++++
>   arch/x86/kvm/vmx/pmu_intel.c      | 16 +++++++++++
>   arch/x86/kvm/x86.c                |  7 +++++
>   include/uapi/linux/kvm.h          |  4 +++
>   9 files changed, 114 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/api.txt
> b/Documentation/virtual/kvm/api.txt
> index ba6c42c576dd..79cbe7339145 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -4065,6 +4065,22 @@ KVM_ARM_VCPU_FINALIZE call.
>   See KVM_ARM_VCPU_INIT for details of vcpu features that require finalization
>   using this ioctl.
>
> +4.120 KVM_SET_PMU_WHITELIST
> +
> +Capability: KVM_CAP_PMU_WHITELIST
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_pmu_whitelist (in)
> +Returns: 0 on success, -1 on error
> +
> +struct kvm_pmu_whitelist {
> +       __u64 event_mask;

Is this "ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK"?


> +       __u16 num_events;
> +       __u64 events[0];

Can this be __u16?
The lower 16 bits (umask+eventsel) already determines what the event is.


> +};
> +This ioctl restricts the set of PMU events that the guest can program to the
> +set of whitelisted events.
> +
>   5. The kvm_run structure
>   ------------------------
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 450d69a1e6fa..942647475999 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -477,6 +477,7 @@ struct kvm_pmu {
>          struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
>          struct irq_work irq_work;
>          u64 reprogram_pmi;
> +       struct kvm_pmu_whitelist *whitelist;

This could be per-VM and under rcu?

>   };
>
>   struct kvm_pmu_ops;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7a0e64ccd6ff..2633b48b75cd 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -421,4 +421,11 @@ struct kvm_nested_state {
>          __u8 data[0];
>   };
>
> +/* for KVM_SET_PMU_WHITELIST */
> +struct kvm_pmu_whitelist {
> +       __u64 event_mask;
> +       __u16 num_events;
> +       __u64 events[0];
> +};
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e39741997893..d0d81cd3626d 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -101,6 +101,9 @@ static void pmc_reprogram_counter(struct kvm_pmc
> *pmc, u32 type,
>                                    bool exclude_kernel, bool intr,
>                                    bool in_tx, bool in_tx_cp)
>   {
> +       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +       int i;
> +       u64 event_config;
>          struct perf_event *event;
>          struct perf_event_attr attr = {
>                  .type = type,
> @@ -127,6 +130,19 @@ static void pmc_reprogram_counter(struct kvm_pmc
> *pmc, u32 type,
>                  attr.config |= HSW_IN_TX_CHECKPOINTED;
>          }
>
> +       if (pmu->whitelist) {

Why not moving this filter to reprogram_gp_counter?

You could directly compare "unit_mask, event_sel"  with whitelist->events[i]

> +               event_config = attr.config;
> +               if (type == PERF_TYPE_HARDWARE)
> +                       event_config = kvm_x86_ops->pmu_ops->get_event_code(
> +                               attr.config);
> +               event_config &= pmu->whitelist->event_mask;
> +               for (i = 0; i < pmu->whitelist->num_events; i++)
> +                       if (event_config == pmu->whitelist->events[i])
> +                               break;
> +               if (i == pmu->whitelist->num_events)
> +                       return;
> +       }
> +
>          event = perf_event_create_kernel_counter(&attr, -1, current,
>                                                   intr ? kvm_perf_overflow_intr :
>                                                   kvm_perf_overflow, pmc);
> @@ -244,6 +260,34 @@ int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu
> *vcpu, unsigned idx)
>          return kvm_x86_ops->pmu_ops->is_valid_msr_idx(vcpu, idx);
>   }
>
> +int kvm_vcpu_ioctl_set_pmu_whitelist(struct kvm_vcpu *vcpu,
> +                                    struct kvm_pmu_whitelist __user *whtlst)
> +{
> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +       struct kvm_pmu_whitelist *old = pmu->whitelist;
> +       struct kvm_pmu_whitelist *new = NULL;
> +       struct kvm_pmu_whitelist tmp;
> +       int r;
> +       size_t size;
> +
> +       r = -EFAULT;
> +       if (copy_from_user(&tmp, whtlst, sizeof(struct kvm_pmu_whitelist)))
> +               goto err;

I would directly return -EFAULT here.

> +
> +       size = sizeof(tmp) + sizeof(tmp.events[0]) * tmp.num_events;
> +       new = kvzalloc(size, GFP_KERNEL_ACCOUNT);
> +       r = -ENOMEM;
> +       if (!new)
> +               goto err;

Same here.

> +       pmu->whitelist = new;

Forgot to copy the whitelist-ed events to new?


Best,
Wei
