Return-Path: <kvm+bounces-867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E96F7E3A54
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 11:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80A1E1C20A6C
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA8829CF3;
	Tue,  7 Nov 2023 10:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XC+XyCer"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475D8210F9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:51:23 +0000 (UTC)
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A3910E4;
	Tue,  7 Nov 2023 02:51:21 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-5441ba3e53cso6783180a12.1;
        Tue, 07 Nov 2023 02:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699354280; x=1699959080; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coaWb7mkmt/6LxRuFv3ptidxFk602lwpzwu0xZUpXsE=;
        b=XC+XyCerVjzA4tNHrHrEPN6PJIl2ydgIk5j0Xf/PH+jbmLOQuGpZX04C4y/wthTXqc
         rML1Qif1pe5klNh0gcuaeC0oktqWe51Q0fmL88ThGVG7cOhrX/MkxLJwSN+culWCAEfG
         kz1iXp0TfZW0AnbBxXFKc2LozJozrgRVqwByxQjJHsCds8KRF+wNgHSBr5vtdmExOYzV
         BfzU0R3azyFvV8mCyr18XEm7Lq0uTpicek6n3Lyj9pZxyvxVHUuXYJlUVDGL7qhM2gwT
         VeuRQbyOLvTc4DIrpxTChlNAvCJtTKAAoFzBWSVT9Pp9fTWJNohgxrOdi3gCMFZtPcRK
         xa9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699354280; x=1699959080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=coaWb7mkmt/6LxRuFv3ptidxFk602lwpzwu0xZUpXsE=;
        b=LrvfTUPoWGEwMiwJgrxaQrKBlN2jIkm3OFHAQwWNq7XA2DfigH51nwTsjaPzIQcWTJ
         qX8BKvOFLjSEHaaZO6+cfB+rg7R8sPbI6fNTLq6g4xON24h+khIVECq/HiT2l4BRLKK9
         rhfkftF6XIJlAzbiG8xoDux7HJza7HrtEKsMxp3xR9ZKyMWcY0jll45PMgaXGLjcuzWe
         pZBNShv+dIBa+kJFeGy3EZAkv5EozESDvt8/1XeXCddgrBWVXsYIHXbhW3vQcExzlDfz
         qDv9EI67n8NgdX464DH70TDiZwH7VKAvbzU1MfmXoERDVUxWG7N5PVqlEJS4SGrqve/v
         p31Q==
X-Gm-Message-State: AOJu0YzTFdaZNoZlr7UggH8ahbFdTjqesJYq16jLmOsxuRabqDhbPusq
	SG9uzbHpG6CzDjEFb2JvEstN71IZ/rNKQwa94Lw=
X-Google-Smtp-Source: AGHT+IHJ6QYQnWgoMx2Yvec+D7D1TMWtMKnGpR7FU98HC25IDoaNN3aCNO4z4aI6R8C6S+3PS1ZcSIFoecWr3BWB/j0=
X-Received: by 2002:aa7:c595:0:b0:541:783:4b17 with SMTP id
 g21-20020aa7c595000000b0054107834b17mr25055855edq.7.1699354279604; Tue, 07
 Nov 2023 02:51:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-10-seanjc@google.com>
 <CALMp9eT22j2Ob9ihva41p2JRufR5P+xnzsm99LEd1quxnfCyWA@mail.gmail.com>
 <e704b8ef-7488-96f4-27a8-35af722d4a3f@gmail.com> <ZUlPT6ed5d0FCLYL@google.com>
In-Reply-To: <ZUlPT6ed5d0FCLYL@google.com>
From: Jinrong Liang <ljr.kernel@gmail.com>
Date: Tue, 7 Nov 2023 18:51:08 +0800
Message-ID: <CAFg_LQVAfS_neNsZftUMTN33-ZhzNBdnOhELCPPksdkK8peZGw@mail.gmail.com>
Subject: Re: [PATCH v6 09/20] KVM: selftests: Add pmu.h and lib/pmu.c for
 common PMU assets
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Jinrong Liang <cloudliang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B411=E6=9C=887=
=E6=97=A5=E5=91=A8=E4=BA=8C 04:40=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Nov 06, 2023, JinrongLiang wrote:
> > =E5=9C=A8 2023/11/4 21:20, Jim Mattson =E5=86=99=E9=81=93:
> > > > diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/test=
ing/selftests/kvm/include/pmu.h
> > > > new file mode 100644
> > > > index 000000000000..987602c62b51
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/kvm/include/pmu.h
> > > > @@ -0,0 +1,84 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > +/*
> > > > + * Copyright (C) 2023, Tencent, Inc.
> > > > + */
> > > > +#ifndef SELFTEST_KVM_PMU_H
> > > > +#define SELFTEST_KVM_PMU_H
> > > > +
> > > > +#include <stdint.h>
> > > > +
> > > > +#define X86_PMC_IDX_MAX                                64
> > > > +#define INTEL_PMC_MAX_GENERIC                          32
> > >
> > > I think this is actually 15. Note that IA32_PMC0 through IA32_PMC7
> > > have MSR indices from 0xc1 through 0xc8, and MSR 0xcf is
> > > IA32_CORE_CAPABILITIES. At the very least, we have to handle
> > > non-contiguous MSR indices if we ever go beyond IA32_PMC14.
>
> There's no reason to define this, it's not used in selftests.
>
> > > > +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS                300
> > > > +
> > > > +#define GP_COUNTER_NR_OFS_BIT                          8
> > > > +#define EVENT_LENGTH_OFS_BIT                           24
> > > > +
> > > > +#define PMU_VERSION_MASK                               GENMASK_ULL=
(7, 0)
> > > > +#define EVENT_LENGTH_MASK                              GENMASK_ULL=
(31, EVENT_LENGTH_OFS_BIT)
> > > > +#define GP_COUNTER_NR_MASK                             GENMASK_ULL=
(15, GP_COUNTER_NR_OFS_BIT)
> > > > +#define FIXED_COUNTER_NR_MASK                          GENMASK_ULL=
(4, 0)
>
> These are also unneeded, they're superseded by CPUID properties.
>
> > > > +#define ARCH_PERFMON_EVENTSEL_EVENT                    GENMASK_ULL=
(7, 0)
> > > > +#define ARCH_PERFMON_EVENTSEL_UMASK                    GENMASK_ULL=
(15, 8)
> > > > +#define ARCH_PERFMON_EVENTSEL_USR                      BIT_ULL(16)
> > > > +#define ARCH_PERFMON_EVENTSEL_OS                       BIT_ULL(17)
> > > > +#define ARCH_PERFMON_EVENTSEL_EDGE                     BIT_ULL(18)
> > > > +#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL              BIT_ULL(19)
> > > > +#define ARCH_PERFMON_EVENTSEL_INT                      BIT_ULL(20)
> > > > +#define ARCH_PERFMON_EVENTSEL_ANY                      BIT_ULL(21)
> > > > +#define ARCH_PERFMON_EVENTSEL_ENABLE                   BIT_ULL(22)
> > > > +#define ARCH_PERFMON_EVENTSEL_INV                      BIT_ULL(23)
> > > > +#define ARCH_PERFMON_EVENTSEL_CMASK                    GENMASK_ULL=
(31, 24)
> > > > +
> > > > +#define PMC_MAX_FIXED                                  16
>
> Also unneeded.
>
> > > > +#define PMC_IDX_FIXED                                  32
>
> This one is absolutely ridiculous.  It's the shift for the enable bit in =
global
> control, which is super obvious from the name. /s
>
> > > > +
> > > > +/* RDPMC offset for Fixed PMCs */
> > > > +#define PMC_FIXED_RDPMC_BASE                           BIT_ULL(30)
> > > > +#define PMC_FIXED_RDPMC_METRICS                        BIT_ULL(29)
> > > > +
> > > > +#define FIXED_BITS_MASK                                0xFULL
> > > > +#define FIXED_BITS_STRIDE                              4
> > > > +#define FIXED_0_KERNEL                                 BIT_ULL(0)
> > > > +#define FIXED_0_USER                                   BIT_ULL(1)
> > > > +#define FIXED_0_ANYTHREAD                              BIT_ULL(2)
> > > > +#define FIXED_0_ENABLE_PMI                             BIT_ULL(3)
> > > > +
> > > > +#define fixed_bits_by_idx(_idx, _bits)                 \
> > > > +       ((_bits) << ((_idx) * FIXED_BITS_STRIDE))
>
> *sigh*  And now I see where the "i * 4" stuff in the new test comes from.=
  My
> plan is to redo the above as:
>
> /* RDPMC offset for Fixed PMCs */
> #define FIXED_PMC_RDPMC_METRICS                 BIT_ULL(29)
> #define FIXED_PMC_RDPMC_BASE                    BIT_ULL(30)
>
> #define FIXED_PMC_GLOBAL_CTRL_ENABLE(_idx)      BIT_ULL((32 + (_idx)))
>
> #define FIXED_PMC_KERNEL                        BIT_ULL(0)
> #define FIXED_PMC_USER                          BIT_ULL(1)
> #define FIXED_PMC_ANYTHREAD                     BIT_ULL(2)
> #define FIXED_PMC_ENABLE_PMI                    BIT_ULL(3)
> #define FIXED_PMC_NR_BITS                       4
> #define FIXED_PMC_CTRL(_idx, _val)              ((_val) << ((_idx) * FIXE=
D_PMC_NR_BITS))
>
> > > > +#define AMD64_NR_COUNTERS                              4
> > > > +#define AMD64_NR_COUNTERS_CORE                         6
>
> These too can be dropped for now.
>
> > > > +#define PMU_CAP_FW_WRITES                              BIT_ULL(13)
> > > > +#define PMU_CAP_LBR_FMT                                0x3f
> > > > +
> > > > +enum intel_pmu_architectural_events {
> > > > +       /*
> > > > +        * The order of the architectural events matters as support=
 for each
> > > > +        * event is enumerated via CPUID using the index of the eve=
nt.
> > > > +        */
> > > > +       INTEL_ARCH_CPU_CYCLES,
> > > > +       INTEL_ARCH_INSTRUCTIONS_RETIRED,
> > > > +       INTEL_ARCH_REFERENCE_CYCLES,
> > > > +       INTEL_ARCH_LLC_REFERENCES,
> > > > +       INTEL_ARCH_LLC_MISSES,
> > > > +       INTEL_ARCH_BRANCHES_RETIRED,
> > > > +       INTEL_ARCH_BRANCHES_MISPREDICTED,
> > > > +       NR_INTEL_ARCH_EVENTS,
> > > > +};
> > > > +
> > > > +enum amd_pmu_k7_events {
> > > > +       AMD_ZEN_CORE_CYCLES,
> > > > +       AMD_ZEN_INSTRUCTIONS,
> > > > +       AMD_ZEN_BRANCHES,
> > > > +       AMD_ZEN_BRANCH_MISSES,
> > > > +       NR_AMD_ARCH_EVENTS,
> > > > +};
> > > > +
> > > > +extern const uint64_t intel_pmu_arch_events[];
> > > > +extern const uint64_t amd_pmu_arch_events[];
> > >
> > > AMD doesn't define *any* architectural events. Perhaps
> > > amd_pmu_zen_events[], though who knows what Zen5 and  beyond will
> > > bring?
> > >
> > > > +extern const int intel_pmu_fixed_pmc_events[];
> > > > +
> > > > +#endif /* SELFTEST_KVM_PMU_H */
> > > > diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/=
selftests/kvm/lib/pmu.c
> > > > new file mode 100644
> > > > index 000000000000..27a6c35f98a1
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/kvm/lib/pmu.c
> > > > @@ -0,0 +1,28 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * Copyright (C) 2023, Tencent, Inc.
> > > > + */
> > > > +
> > > > +#include <stdint.h>
> > > > +
> > > > +#include "pmu.h"
> > > > +
> > > > +/* Definitions for Architectural Performance Events */
> > > > +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & =
0xff) << 8)
> > >
> > > There's nothing architectural about this. Perhaps RAW_EVENT() for
> > > consistency with perf?
>
> Works for me.
>
> > > > +const uint64_t intel_pmu_arch_events[] =3D {
> > > > +       [INTEL_ARCH_CPU_CYCLES]                 =3D ARCH_EVENT(0x3c=
, 0x0),
> > > > +       [INTEL_ARCH_INSTRUCTIONS_RETIRED]       =3D ARCH_EVENT(0xc0=
, 0x0),
> > > > +       [INTEL_ARCH_REFERENCE_CYCLES]           =3D ARCH_EVENT(0x3c=
, 0x1),
> > > > +       [INTEL_ARCH_LLC_REFERENCES]             =3D ARCH_EVENT(0x2e=
, 0x4f),
> > > > +       [INTEL_ARCH_LLC_MISSES]                 =3D ARCH_EVENT(0x2e=
, 0x41),
> > > > +       [INTEL_ARCH_BRANCHES_RETIRED]           =3D ARCH_EVENT(0xc4=
, 0x0),
> > > > +       [INTEL_ARCH_BRANCHES_MISPREDICTED]      =3D ARCH_EVENT(0xc5=
, 0x0),
> > >
> > > [INTEL_ARCH_TOPDOWN_SLOTS] =3D ARCH_EVENT(0xa4, 1),
>
> ...
>
> > > > @@ -63,7 +50,6 @@
> > > >
> > > >   #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
> > >
> > > Now AMD_ZEN_BRANCHES, above?
> >
> > Yes, I forgot to replace INTEL_BR_RETIRED, AMD_ZEN_BR_RETIRED and
> > INST_RETIRED in pmu_event_filter_test.c and remove their macro definiti=
ons.
>
> Having to go through an array to get a hardcoded value is silly, e.g. it =
makes
> it unnecessarily difficult to reference the encodings because they aren't=
 simple
> literals.
>
> My vote is this:
>
> #define INTEL_ARCH_CPU_CYCLES                   RAW_EVENT(0x3c, 0x00)
> #define INTEL_ARCH_INSTRUCTIONS_RETIRED         RAW_EVENT(0xc0, 0x00)
> #define INTEL_ARCH_REFERENCE_CYCLES             RAW_EVENT(0x3c, 0x01)
> #define INTEL_ARCH_LLC_REFERENCES               RAW_EVENT(0x2e, 0x4f)
> #define INTEL_ARCH_LLC_MISSES                   RAW_EVENT(0x2e, 0x41)
> #define INTEL_ARCH_BRANCHES_RETIRED             RAW_EVENT(0xc4, 0x00)
> #define INTEL_ARCH_BRANCHES_MISPREDICTED        RAW_EVENT(0xc5, 0x00)
> #define INTEL_ARCH_TOPDOWN_SLOTS                RAW_EVENT(0xa4, 0x01)
>
> #define AMD_ZEN_CORE_CYCLES                     RAW_EVENT(0x76, 0x00)
> #define AMD_ZEN_INSTRUCTIONS_RETIRED            RAW_EVENT(0xc0, 0x00)
> #define AMD_ZEN_BRANCHES_RETIRED                RAW_EVENT(0xc2, 0x00)
> #define AMD_ZEN_BRANCHES_MISPREDICTED           RAW_EVENT(0xc3, 0x00)
>
> /*
>  * Note!  The order and thus the index of the architectural events matter=
s as
>  * support for each event is enumerated via CPUID using the index of the =
event.
>  */
> enum intel_pmu_architectural_events {
>         INTEL_ARCH_CPU_CYCLES_INDEX,
>         INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX,
>         INTEL_ARCH_REFERENCE_CYCLES_INDEX,
>         INTEL_ARCH_LLC_REFERENCES_INDEX,
>         INTEL_ARCH_LLC_MISSES_INDEX,
>         INTEL_ARCH_BRANCHES_RETIRED_INDEX,
>         INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX,
>         INTEL_ARCH_TOPDOWN_SLOTS_INDEX,
>         NR_INTEL_ARCH_EVENTS,
> };
>
> enum amd_pmu_zen_events {
>         AMD_ZEN_CORE_CYCLES_INDEX,
>         AMD_ZEN_INSTRUCTIONS_INDEX,
>         AMD_ZEN_BRANCHES_INDEX,
>         AMD_ZEN_BRANCH_MISSES_INDEX,
>         NR_AMD_ZEN_EVENTS,
> };
>
> extern const uint64_t intel_pmu_arch_events[];
> extern const uint64_t amd_pmu_zen_events[];
>
> ...
>
>
> const uint64_t intel_pmu_arch_events[] =3D {
>         INTEL_ARCH_CPU_CYCLES,
>         INTEL_ARCH_INSTRUCTIONS_RETIRED,
>         INTEL_ARCH_REFERENCE_CYCLES,
>         INTEL_ARCH_LLC_REFERENCES,
>         INTEL_ARCH_LLC_MISSES,
>         INTEL_ARCH_BRANCHES_RETIRED,
>         INTEL_ARCH_BRANCHES_MISPREDICTED,
>         INTEL_ARCH_TOPDOWN_SLOTS,
> };
> kvm_static_assert(ARRAY_SIZE(intel_pmu_arch_events) =3D=3D NR_INTEL_ARCH_=
EVENTS);
>
> const uint64_t amd_pmu_zen_events[] =3D {
>         AMD_ZEN_CORE_CYCLES,
>         AMD_ZEN_INSTRUCTIONS_RETIRED,
>         AMD_ZEN_BRANCHES_RETIRED,
>         AMD_ZEN_BRANCHES_MISPREDICTED,
> };
> kvm_static_assert(ARRAY_SIZE(amd_pmu_zen_events) =3D=3D NR_AMD_ZEN_EVENTS=
);

LGTM, thanks.

