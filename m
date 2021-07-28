Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9F3D935A
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhG1QlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 12:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhG1QlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 12:41:19 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDB8C061757;
        Wed, 28 Jul 2021 09:41:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m13so5077940lfg.13;
        Wed, 28 Jul 2021 09:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbHSe5ZmokTeRZOVR5/DxbeDukJUOZWqPm1zkRBz3bc=;
        b=Y0tizcCEiBh+D7lqJGorKFC0uu9mzmJ+oKCwjELrNTc3QiKdHM7vxw8UwwvMU/PaUA
         53tPEf3XHrNfByM7bl/komnTjiUYQA+Ci900eyGa0vW3bBGAY1ZQna2oOVTSJ+mScAef
         ceR/M7AP4kLP/PjDCYKjb98hV7xYlzqqeXqyHmlAU4tsht+id5F2zzhw+/A6FuFU0OTy
         MQQgpH6yZruzxncfSequRGMtWDbBTglcwesAGyxsGKCzX6zSVGhct0h3X2G1OrsnE6vC
         IxN6ckpLC6Uy2wlZVeLY7xafATu4jXq0lZ53iiRMaGCnHgQFqk8NT3crT/Xu1X5UW0Em
         S9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbHSe5ZmokTeRZOVR5/DxbeDukJUOZWqPm1zkRBz3bc=;
        b=sBGJ9/kBP1F/AreucvOoXqlQMUs33CPeWfp00CNi4j9kznNEMVvmcoXgOF2UtylZlj
         RfrborwDXEFypNltOqqiwGC2vyTvDq7PcDw1bmPEAF7W5EaFl8dhP/BJK36H3tduHpV3
         OAlI9e+ly2b9nk4O51jFObzAvedXklYzKSxParxhO6bYITZ1FFV7vEKN4wkn4fNXu57S
         aoO+tbhArAP0rHD1sivKrQscdmJHuLETjszMBT1vIhd53C3uAW0aO0PznErGQJ0TquXJ
         mw5TRAp9tCux2m98nZSxRYf9hmCEm+VcCs5SzJwkAO3kBEsHMU+3mxmMSuLOJUn04zPR
         0KSA==
X-Gm-Message-State: AOAM532RNt0GXrLYM1nW+m+Vi0sRs7lWzYIS8l4eGGWFCFQHfIlgbxm/
        7TKlH45uEqvW9BnaR+cd7EabQPXCSW2H2KNNWp0=
X-Google-Smtp-Source: ABdhPJw23T56CmiSS82fKQEiITmrFD7JG4x28Dd9mzB4sWJvcaayyqyqfcUURs8u+JK1LLu9eDiUAFteoWd98pTvZXc=
X-Received: by 2002:a05:6512:3148:: with SMTP id s8mr341209lfi.513.1627490475453;
 Wed, 28 Jul 2021 09:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210722054159.4459-1-lingshan.zhu@intel.com> <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
In-Reply-To: <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
Date:   Thu, 29 Jul 2021 00:40:59 +0800
Message-ID: <CAA3+yLe3xd5uP47kOTA843b5ZByTJR7h5Ud38y+yhP8i2vk_6Q@mail.gmail.com>
Subject: Re: [PATCH V9 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Liang, Kan" <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, Stephane Eranian <eranian@google.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        boris.ostrvsky@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 11:46 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jul 22, 2021 at 01:41:41PM +0800, Zhu Lingshan wrote:
> > The guest Precise Event Based Sampling (PEBS) feature can provide an
> > architectural state of the instruction executed after the guest instruction
> > that exactly caused the event. It needs new hardware facility only available
> > on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
> > feature for KVM guests on ICX.
> >
> > We can use PEBS feature on the Linux guest like native:
> >
> >    # echo 0 > /proc/sys/kernel/watchdog (on the host)
> >    # perf record -e instructions:ppp ./br_instr a
> >    # perf record -c 100000 -e instructions:pp ./br_instr a
>
> Why does the host need to disable the watchdog? IIRC ICL has multiple
> PEBS capable counters. Also, I think the watchdog ends up on a fixed
> counter by default anyway.

The watchdog counter blocks the KVM PEBS request on the same (fixed) counter.
This restriction will be lifted when we have cross-mapping support later in KVM.

>
> > Like Xu (17):
> >   perf/core: Use static_call to optimize perf_guest_info_callbacks
> >   perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
> >   perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
> >   perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
> >   KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
> >   KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
> >   KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
> >   KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
> >   KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
> >   KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
> >   KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
> >   KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
> >   KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
> >   KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
> >   KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
> >   KVM: x86/cpuid: Refactor host/guest CPU model consistency check
> >   KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
> >
> > Peter Zijlstra (Intel) (1):
> >   x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
>
> Looks good:
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks for your time and support of the guest PMU features.

> How do we want to route this, all through the KVM tree?

As a prerequisite, the perf tree may apply the first three patches.
Hi Paolo, do you have any preferences ?

>
> One little nit I had; would something like the below (on top perhaps)
> make the code easier to read?

Fine to me and I may provide a follow-up patch.

>
> ---
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3921,9 +3921,12 @@ static struct perf_guest_switch_msr *int
>         struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
>         u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
>         u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> +       int global_ctrl, pebs_enable;
>
>         *nr = 0;
> -       arr[(*nr)++] = (struct perf_guest_switch_msr){
> +
> +       global_ctrl = (*nr)++;
> +       arr[global_ctrl] = (struct perf_guest_switch_msr){
>                 .msr = MSR_CORE_PERF_GLOBAL_CTRL,
>                 .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
>                 .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> @@ -3966,23 +3969,23 @@ static struct perf_guest_switch_msr *int
>                 };
>         }
>
> -       arr[*nr] = (struct perf_guest_switch_msr){
> +       pebs_enable = (*nr)++;
> +       arr[pebs_enable] = (struct perf_guest_switch_msr){
>                 .msr = MSR_IA32_PEBS_ENABLE,
>                 .host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
>                 .guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
>         };
>
> -       if (arr[*nr].host) {
> +       if (arr[pebs_enable].host) {
>                 /* Disable guest PEBS if host PEBS is enabled. */
> -               arr[*nr].guest = 0;
> +               arr[pebs_enable].guest = 0;
>         } else {
>                 /* Disable guest PEBS for cross-mapped PEBS counters. */
> -               arr[*nr].guest &= ~kvm_pmu->host_cross_mapped_mask;
> +               arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
>                 /* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
> -               arr[0].guest |= arr[*nr].guest;
> +               arr[global_ctrl].guest |= arr[pebs_enable].guest;
>         }
>
> -       ++(*nr);
>         return arr;
>  }
>
>
>
>
