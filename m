Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0763E4856
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 17:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhHIPIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbhHIPIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 11:08:50 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1984C0613D3;
        Mon,  9 Aug 2021 08:08:29 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p38so7116969lfa.0;
        Mon, 09 Aug 2021 08:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDJzN0F1WF5mOprRxjX5kY7x+uv7q/PkzLNKpudNlaQ=;
        b=M2mSWAmzbSQ/dESj//1mXpehasYfI6exx45MLHkYhhxNOoJvnPO48q7JNHgn9z6HTz
         DoxXwkHEFfnI9EWfC/IJLMdRO0JJ/DABGs0mB7IBtEpXVRYFnlhffHIw1I8kn5frFvdW
         MqtUzhf/HkxvNukw7sfWVUJN2v0o6oWkf3eW0A9UWwHrKXwSMPboonsRNLqdb8X4Q1Yw
         m5hkWY40Ry3YJJZRcK1Qr7uXcJLZXjpSXAcMuX86VXqIFwjNxedYryUjAjOb1yvTAwev
         PTkedY/eWM0dR0kCdCNZoWg/xnNCCrwWREiAKY97AQXx9Tax1DtStuuIir9IG+yAkmSl
         XewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDJzN0F1WF5mOprRxjX5kY7x+uv7q/PkzLNKpudNlaQ=;
        b=mFL3Ry5Sy3sT+UnqJ0KaNiNbuGgwPR/fnmTWYSzXYjonhufmSdZwowyoQ5No7nnvD0
         gEnE0hMKRwqmNnxReSkTYO0lkEV3aF3BEuMS/rq7D9UbpGurDf8XYE4TE7I80UU0Pr0z
         5kK0B//7EqSfqRaxXeZIfk7unfXOU1capDcc9RYmp/oi9rmYfciINbb653O+pqZ932Dr
         jCcDEjE2TdqrnzOZertnsCbK0DQOzYc//FVyUjQCuPMLut7CYTTLTE297mb1xuUHHbQN
         cGPkk3nyGSnm1j8CCneow1CNdcPmj3g1MwX4v3NFXRa6ngGxcv/EdtgL7+rLm48pvCv4
         WbLw==
X-Gm-Message-State: AOAM531KiLsCr01azfPeFT+tZGqP3b7LWI9wtC54+Xo5nv2DJUZ2Ecxh
        J3Rxzb3sEWKVbFWNoHuYBQG/ffJMvd9pEaW9/zw=
X-Google-Smtp-Source: ABdhPJx4sHr8dvW+wwXzfa5zhIeJZFDTaQe7IDZi1FybWo1LhVpYXgzJFGP/L3E/ebv0KH+Y2DoTuF2qc4LX8LXDv1s=
X-Received: by 2002:a05:6512:132a:: with SMTP id x42mr17346429lfu.291.1628521708328;
 Mon, 09 Aug 2021 08:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210809074803.43154-1-likexu@tencent.com> <7599a987-c931-20f1-9441-d86222a4519d@linux.intel.com>
In-Reply-To: <7599a987-c931-20f1-9441-d86222a4519d@linux.intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Date:   Mon, 9 Aug 2021 23:08:11 +0800
Message-ID: <CAA3+yLfF8a5Jwz6s3ZG6zMgRn7GEF5Q8ENucuu3Ne977MmVUug@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Don't expose guest LBR if the LBR_SELECT is
 shared per physical core
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 9, 2021 at 10:12 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 8/9/2021 3:48 AM, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> >
> > According to Intel SDM, the Last Branch Record Filtering Select Register
> > (R/W) is defined as shared per physical core rather than per logical core
> > on some older Intel platforms: Silvermont, Airmont, Goldmont and Nehalem.
> >
> > To avoid LBR attacks or accidental data leakage, on these specific
> > platforms, KVM should not expose guest LBR capability even if HT is
> > disabled on the host, considering that the HT state can be dynamically
> > changed, yet the KVM capabilities are initialized at module initialisation.
> >
> > Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> >   arch/x86/include/asm/intel-family.h |  1 +
> >   arch/x86/kvm/vmx/capabilities.h     | 19 ++++++++++++++++++-
> >   2 files changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
> > index 27158436f322..f35c915566e3 100644
> > --- a/arch/x86/include/asm/intel-family.h
> > +++ b/arch/x86/include/asm/intel-family.h
> > @@ -119,6 +119,7 @@
> >
> >   #define INTEL_FAM6_ATOM_SILVERMONT  0x37 /* Bay Trail, Valleyview */
> >   #define INTEL_FAM6_ATOM_SILVERMONT_D        0x4D /* Avaton, Rangely */
> > +#define INTEL_FAM6_ATOM_SILVERMONT_X3        0x5D /* X3-C3000 based on Silvermont */
>
>
> Please submit a separate patch if you want to add a new CPU ID. Also,
> the comments should be platform code name, not the model.
>
> AFAIK, Atom X3 should be SoFIA which is for mobile phone. It's an old
> product. I don't think I enabled it in perf. I have no idea why you want
> to add it here for KVM. If you have a product and want to enable it, I
> guess you may want to enable it for perf first.

Thanks for your clarification about SoFIA. I'll drop 0x5D check
for V2 since we doesn't have host support as you said.

Do the other models here and the idea of banning guest LBR make sense to you ?

>
> Thanks,
> Kan
>
> >   #define INTEL_FAM6_ATOM_SILVERMONT_MID      0x4A /* Merriefield */
> >
> >   #define INTEL_FAM6_ATOM_AIRMONT             0x4C /* Cherry Trail, Braswell */
> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> > index 4705ad55abb5..ff9596d7112d 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -3,6 +3,7 @@
> >   #define __KVM_X86_VMX_CAPS_H
> >
> >   #include <asm/vmx.h>
> > +#include <asm/cpu_device_id.h>
> >
> >   #include "lapic.h"
> >
> > @@ -376,6 +377,21 @@ static inline bool vmx_pt_mode_is_host_guest(void)
> >       return pt_mode == PT_MODE_HOST_GUEST;
> >   }
> >
> > +static const struct x86_cpu_id lbr_select_shared_cpu[] = {
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_X3, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_MID, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_G, NULL),
> > +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX, NULL),
> > +     {}
> > +};
> > +
> >   static inline u64 vmx_get_perf_capabilities(void)
> >   {
> >       u64 perf_cap = 0;
> > @@ -383,7 +399,8 @@ static inline u64 vmx_get_perf_capabilities(void)
> >       if (boot_cpu_has(X86_FEATURE_PDCM))
> >               rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
> >
> > -     perf_cap &= PMU_CAP_LBR_FMT;
> > +     if (!x86_match_cpu(lbr_select_shared_cpu))
> > +             perf_cap &= PMU_CAP_LBR_FMT;
> >
> >       /*
> >        * Since counters are virtualized, KVM would support full
> >
