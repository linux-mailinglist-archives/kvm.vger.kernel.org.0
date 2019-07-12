Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB24C664E8
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 05:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbfGLDWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 23:22:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:2084 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbfGLDWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 23:22:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:22:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="174337093"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jul 2019 20:22:02 -0700
Message-ID: <5D27FE26.1050002@intel.com>
Date:   Fri, 12 Jul 2019 11:27:34 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com
CC:     linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
In-Reply-To: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/11/2019 09:25 AM, Eric Hankland wrote:
> - Add a VM ioctl that can control which events the guest can monitor.
>
> Signed-off-by: ehankland<ehankland@google.com>
> ---
> Changes since v1:
> -Moved to a vm ioctl rather than a vcpu one
> -Changed from a whitelist to a configurable filter which can either be
> white or black
> -Only restrict GP counters since fixed counters require extra handling
> and they can be disabled by setting the guest cpuid (though only by
> setting the number - they can't be disabled individually)

I think just disabling guest cpuid might not be enough, since guest
could write to the msr without checking the cpuid.

Why not just add a bitmap for fixed counter?
e.g. fixed_counter_reject_bitmap

At the beginning of reprogram_fixed_counter, we could add the check:

if (test_bit(idx, &kvm->arch.fixed_counter_reject_bitmap))
     return -EACCES;

(Please test with your old guest and see if they have issues if we 
inject #GP when
they try to set the fixed_ctrl msr. If there is, we could drop -EACCESS 
above)

The bitmap could be set at kvm_vm_ioctl_set_pmu_event_filter.

> +/* for KVM_CAP_PMU_EVENT_FILTER */
> +struct kvm_pmu_event_filter {
> +       __u32 type;
> +       __u32 nevents;
> +       __u64 events[0];
> +};
> +
> +#define KVM_PMU_EVENT_WHITELIST 0
> +#define KVM_PMU_EVENT_BLACKLIST 1

I think it would be better to add more, please see below:

enum kvm_pmu_action_type {
     KVM_PMU_EVENT_ACTION_NONE = 0,
     KVM_PMU_EVENT_ACTION_ACCEPT = 1,
     KVM_PMU_EVENT_ACTION_REJECT = 2,
     KVM_PMU_EVENT_ACTION_MAX
};

and do a check in kvm_vm_ioctl_set_pmu_event_filter()
     if (filter->action >= KVM_PMU_EVENT_ACTION_MAX)
         return -EINVAL;

This is for detecting the case that we add a new action in
userspace, while the kvm hasn't been updated to support that.

KVM_PMU_EVENT_ACTION_NONE is for userspace to remove
the filter after they set it.


> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index dd745b58ffd8..d674b79ff8da 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -22,6 +22,9 @@
>   #include "lapic.h"
>   #include "pmu.h"
>
> +/* This keeps the total size of the filter under 4k. */
> +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 63
> +

Why is this limit needed?

>   /* NOTE:
>    * - Each perf counter is defined as "struct kvm_pmc";
>    * - There are two types of perf counters: general purpose (gp) and fixed.
> @@ -144,6 +147,10 @@ void reprogram_gp_counter(struct kvm_pmc *pmc,
> u64 eventsel)
>   {
>          unsigned config, type = PERF_TYPE_RAW;
>          u8 event_select, unit_mask;
> +       struct kvm_arch *arch = &pmc->vcpu->kvm->arch;
> +       struct kvm_pmu_event_filter *filter;
> +       int i;
> +       bool allow_event = true;
>
>          if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
>                  printk_once("kvm pmu: pin control bit is ignored\n");
> @@ -155,6 +162,24 @@ void reprogram_gp_counter(struct kvm_pmc *pmc,
> u64 eventsel)
>          if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
>                  return;
>
> +       rcu_read_lock();
> +       filter = rcu_dereference(arch->pmu_event_filter);
> +       if (filter) {
> +               for (i = 0; i < filter->nevents; i++)
> +                       if (filter->events[i] ==
> +                           (eventsel & AMD64_RAW_EVENT_MASK_NB))
> +                               break;
> +               if (filter->type == KVM_PMU_EVENT_WHITELIST &&
> +                   i == filter->nevents)
> +                       allow_event = false;
> +               if (filter->type == KVM_PMU_EVENT_BLACKLIST &&
> +                   i < filter->nevents)
> +                       allow_event = false;
> +       }
> +       rcu_read_unlock();
> +       if (!allow_event)
> +               return;
> +

I think it looks tidier to wrap the changes above into a function:

     if (kvm_pmu_filter_event(kvm, eventsel & AMD64_RAW_EVENT_MASK_NB))
         return;

>          event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
>          unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>
> @@ -351,3 +376,39 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>   {
>          kvm_pmu_reset(vcpu);
>   }
> +
> +int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
> +{
> +       struct kvm_pmu_event_filter tmp, *filter;
> +       size_t size;
> +       int r;
> +
> +       if (copy_from_user(&tmp, argp, sizeof(tmp)))
> +               return -EFAULT;
> +
> +       if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
> +               return -E2BIG;
> +
> +       size = sizeof(tmp) + sizeof(tmp.events[0]) * tmp.nevents;
> +       filter = vmalloc(size);
> +       if (!filter)
> +               return -ENOMEM;
> +
> +       r = -EFAULT;
> +       if (copy_from_user(filter, argp, size))

Though the above functions correctly, I would just move "r = -EFAULT" here
to have it executed conditionally.


> +               goto cleanup;
> +
> +       /* Ensure nevents can't be changed between the user copies. */
> +       *filter = tmp;
> +
> +       mutex_lock(&kvm->lock);
> +       rcu_swap_protected(kvm->arch.pmu_event_filter, filter,
> +                          mutex_is_locked(&kvm->lock));
> +       mutex_unlock(&kvm->lock);
> +
> +       synchronize_rcu();
> +       r = 0;
> +cleanup:
> +       kvfree(filter);

Probably better to have it conditionally?

if (filter) {
     synchronize_srcu();
     kfree(filter)
}


You may want to factor it out, so that kvm_pmu_destroy could reuse.

Best,
Wei
