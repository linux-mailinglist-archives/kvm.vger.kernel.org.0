Return-Path: <kvm+bounces-56071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5188DB398E9
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10B9A162A8B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594FF301039;
	Thu, 28 Aug 2025 09:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="FcWOPorR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D42E0910
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756375032; cv=none; b=i38Cf/LLmrNjHHWAZO8v4B0pcMjEl/oa+1E1ebeZpHVma3fv+8dBvD3Kc4tyV8gcphmhhh3For93qdj4jDEZA4DdXwp7JH8lIG4NaAIF/LZFCPzfHXlqoKcVwphP4KcXSiA3EOMXAiXlu/R26LJaqEplauU3WuN9oy+Rb3UApVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756375032; c=relaxed/simple;
	bh=Hnq/H4OM0sN9GCMsd6khrz1yjqu9CgoweKpvYyZesUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/PzqBbVxoKQ0cUd2YCv7pmFoB2Uc7PXsDcL+Bde5IJEIdhbh1KFS1YmaJg48F4ndkBP7gwwOIqwOf395X7JKxidOVJw7cxaj53YnFWEmC0Tc95NGEC8MDFaoXlEnaTp9ZRa0Af/CHOfgWYm+oqc/UoB9G1QoZ0cKpYNEXsOE0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=FcWOPorR; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-61c0b41ddd9so440943eaf.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 02:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756375028; x=1756979828; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCTsYU44p3FWuZ7IPCg/OzqSKlmAqKsoawQWj+0zU8s=;
        b=FcWOPorRG5hNKix5kFI/2CP83fAk1WqFVJ2AxQhohhKJEeN3Ohy4hBAl9/W/D1V5oC
         9ObNcSAaiVLH8jgTA0rD0ZojASAevSHpHPKOEF3VeLRHa5M92J+CEgIjuA1Aci2inok7
         2BBR3/lnQPbKGUkWrBFya6KFLmQdQImKlKPMC6AJMjPRasC6MR7GZP/cMmCpowpaiF3v
         yzg4Koxc5WNNh/+ZisnlLdUvnadth6/3EbIdRS+GGEuJTttCIXT9wRFObhQbGo5O6NeR
         /MGIjY2DXz60e2RNbTg539TOYOmsFjfenTej2FRPVzhElXWQanBXOkVJuwHarEiCAm46
         UxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756375028; x=1756979828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hCTsYU44p3FWuZ7IPCg/OzqSKlmAqKsoawQWj+0zU8s=;
        b=c44WZ1rHNH7bkT7COy9Il7PiazuUb9nZ1eLmp4pU7EHhIsd5VP0840f4jtI0xiqsw4
         8cPZOgqSljEunSrbaDcPtTJeYjX9yx2Y1VxfRbbJR0cVLwjYsYuycNEQxq9PuJ+sfWGo
         4P38gf09eVU5lwrU6pmVEjsC254b0Ig0SEtzRxs4GrvfqRMPo7gBtXf225+ZF96O4zgp
         j/4N5bbo3r1qqVKTU94o+nSe4Dt+xLtFe6DXi1tfcdvVq5icjnnBZ2pICpeExD4DmHSB
         dCAZ1MSokdp2jUwhrN+06hvJB6oHl1xcyHTyhXxyIlbB+gCxGboTp/Vie83G9I1aVzxT
         +vow==
X-Forwarded-Encrypted: i=1; AJvYcCWYjebCh1/9uwBLcw+VQtQbqpJyATyVJdZfDk/V4of5T5RSbV4+CyheWDtwnziMOB+P/pc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFsbzLYWsYuHIBpvSr2Y7K/Y/9UXUeZZdvGFmqOQElKVb/j3eb
	yIa6q0puI84fOGByJUL7Ms99ApAugJARWO0+7uqJmGbUIZVrUCcoWlsf6K2NLhtFEmP/LaCIBuX
	jeIXpjOnZVCVrag6SLZCaJcbuOuRXL7HHLPr6CgYf/g==
X-Gm-Gg: ASbGncv+xU2aRo4pJiOrQDA9bj9D1XR7nJyFq3PUvjGXZbU3MIt3R/oJayVOpcEivJL
	j+k5TzfFKqM65FmSXjTFCa6sWbxyls9OSJNwfJ5+gUxodqWdvffZ/mKSnq7D0kEBY23sZRUXiiT
	xkCkg7uub0K5xQ3oW2krzRwjwyQIiSriAmDEvYyEA2YczL/FnyHgscrph1uW1Vsv7r0LuRME00p
	bodf3y0HMmou0y5D3oV0rwBQgfEEws=
X-Google-Smtp-Source: AGHT+IEwoG3ESbssyFAHkjRNIHseLkd7Dh0TtAdJJ6SxQhXNJX52pwWQtZm3v/hQu2mVPHJs3mHrgfic0iQOiokXyz4=
X-Received: by 2002:a05:6808:15a4:b0:437:decf:ab53 with SMTP id
 5614622812f47-437decfac0fmr561997b6e.30.1756375027723; Thu, 28 Aug 2025
 02:57:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com> <20250327-counter_delegation-v5-14-1ee538468d1b@rivosinc.com>
In-Reply-To: <20250327-counter_delegation-v5-14-1ee538468d1b@rivosinc.com>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Thu, 28 Aug 2025 17:56:55 +0800
X-Gm-Features: Ac12FXw7Vpp2-zrU6JVqVb1ilZ0ttuDRvqs36Bw_BY9o7HuYc1B0_sIRDLnZv9M
Message-ID: <CAEEQ3wmjMJxbnb1dS2g-wojvB9G2w3N7UK9wqFtw77eWE-tEKQ@mail.gmail.com>
Subject: Re: [External] [PATCH v5 14/21] RISC-V: perf: Implement supervisor
 counter delegation support
To: Atish Patra <atishp@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Atish,

On Fri, Mar 28, 2025 at 3:43=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> There are few new RISC-V ISA exensions (ssccfg, sscsrind, smcntrpmf) whic=
h
> allows the hpmcounter/hpmevents to be programmed directly from S-mode. Th=
e
> implementation detects the ISA extension at runtime and uses them if
> available instead of SBI PMU extension. SBI PMU extension will still be
> used for firmware counters if the user requests it.
>
> The current linux driver relies on event encoding defined by SBI PMU
> specification for standard perf events. However, there are no standard
> event encoding available in the ISA. In the future, we may want to
> decouple the counter delegation and SBI PMU completely. In that case,
> counter delegation supported platforms must rely on the event encoding
> defined in the perf json file or in the pmu driver.
>
> For firmware events, it will continue to use the SBI PMU encoding as
> one can not support firmware event without SBI PMU.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h   |   1 +
>  drivers/perf/riscv_pmu_dev.c   | 561 +++++++++++++++++++++++++++++++++--=
------
>  include/linux/perf/riscv_pmu.h |   3 +
>  3 files changed, 462 insertions(+), 103 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 3d2d4f886c77..8b2f5ae1d60e 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -255,6 +255,7 @@
>  #endif
>
>  #define SISELECT_SSCCFG_BASE           0x40
> +#define HPMEVENT_MASK                  GENMASK_ULL(63, 56)
>
>  /* mseccfg bits */
>  #define MSECCFG_PMM                    ENVCFG_PMM
> diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
> index 6f64404a6e3d..7c4a1ef15866 100644
> --- a/drivers/perf/riscv_pmu_dev.c
> +++ b/drivers/perf/riscv_pmu_dev.c
> @@ -27,6 +27,8 @@
>  #include <asm/cpufeature.h>
>  #include <asm/vendor_extensions.h>
>  #include <asm/vendor_extensions/andes.h>
> +#include <asm/hwcap.h>
> +#include <asm/csr_ind.h>
>
>  #define ALT_SBI_PMU_OVERFLOW(__ovl)                                    \
>  asm volatile(ALTERNATIVE_2(                                            \
> @@ -59,14 +61,31 @@ asm volatile(ALTERNATIVE(                            =
               \
>  #define PERF_EVENT_FLAG_USER_ACCESS    BIT(SYSCTL_USER_ACCESS)
>  #define PERF_EVENT_FLAG_LEGACY         BIT(SYSCTL_LEGACY)
>
> -PMU_FORMAT_ATTR(event, "config:0-47");
> +#define RVPMU_SBI_PMU_FORMAT_ATTR      "config:0-47"
> +#define RVPMU_CDELEG_PMU_FORMAT_ATTR   "config:0-55"
> +
> +static ssize_t __maybe_unused rvpmu_format_show(struct device *dev, stru=
ct device_attribute *attr,
> +                                               char *buf);
> +
> +#define RVPMU_ATTR_ENTRY(_name, _func, _config)        (                =
       \
> +       &((struct dev_ext_attribute[]) {                                \
> +               { __ATTR(_name, 0444, _func, NULL), (void *)_config }   \
> +       })[0].attr.attr)
> +
> +#define RVPMU_FORMAT_ATTR_ENTRY(_name, _config) \
> +       RVPMU_ATTR_ENTRY(_name, rvpmu_format_show, (char *)_config)
> +
>  PMU_FORMAT_ATTR(firmware, "config:62-63");
>
>  static bool sbi_v2_available;
>  static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
>  #define sbi_pmu_snapshot_available() \
>         static_branch_unlikely(&sbi_pmu_snapshot_available)
> +
>  static DEFINE_STATIC_KEY_FALSE(riscv_pmu_sbi_available);
> +#define riscv_pmu_sbi_available() \
> +               static_branch_likely(&riscv_pmu_sbi_available)
> +
>  static DEFINE_STATIC_KEY_FALSE(riscv_pmu_cdeleg_available);
>
>  /* Avoid unnecessary code patching in the one time booting path*/
> @@ -81,19 +100,35 @@ static DEFINE_STATIC_KEY_FALSE(riscv_pmu_cdeleg_avai=
lable);
>  #define riscv_pmu_sbi_available() \
>                 static_branch_likely(&riscv_pmu_sbi_available)
>
> -static struct attribute *riscv_arch_formats_attr[] =3D {
> -       &format_attr_event.attr,
> +static struct attribute *riscv_sbi_pmu_formats_attr[] =3D {
> +       RVPMU_FORMAT_ATTR_ENTRY(event, RVPMU_SBI_PMU_FORMAT_ATTR),
> +       &format_attr_firmware.attr,
> +       NULL,
> +};
> +
> +static struct attribute_group riscv_sbi_pmu_format_group =3D {
> +       .name =3D "format",
> +       .attrs =3D riscv_sbi_pmu_formats_attr,
> +};
> +
> +static const struct attribute_group *riscv_sbi_pmu_attr_groups[] =3D {
> +       &riscv_sbi_pmu_format_group,
> +       NULL,
> +};
> +
> +static struct attribute *riscv_cdeleg_pmu_formats_attr[] =3D {
> +       RVPMU_FORMAT_ATTR_ENTRY(event, RVPMU_CDELEG_PMU_FORMAT_ATTR),
>         &format_attr_firmware.attr,
>         NULL,
>  };
>
> -static struct attribute_group riscv_pmu_format_group =3D {
> +static struct attribute_group riscv_cdeleg_pmu_format_group =3D {
>         .name =3D "format",
> -       .attrs =3D riscv_arch_formats_attr,
> +       .attrs =3D riscv_cdeleg_pmu_formats_attr,
>  };
>
> -static const struct attribute_group *riscv_pmu_attr_groups[] =3D {
> -       &riscv_pmu_format_group,
> +static const struct attribute_group *riscv_cdeleg_pmu_attr_groups[] =3D =
{
> +       &riscv_cdeleg_pmu_format_group,
>         NULL,
>  };
>
> @@ -395,6 +430,14 @@ static void rvpmu_sbi_check_std_events(struct work_s=
truct *work)
>
>  static DECLARE_WORK(check_std_events_work, rvpmu_sbi_check_std_events);
>
> +static ssize_t rvpmu_format_show(struct device *dev,
> +                                struct device_attribute *attr, char *buf=
)
> +{
> +       struct dev_ext_attribute *eattr =3D container_of(attr,
> +                               struct dev_ext_attribute, attr);
> +       return sysfs_emit(buf, "%s\n", (char *)eattr->var);
> +}
> +
>  static int rvpmu_ctr_get_width(int idx)
>  {
>         return pmu_ctr_list[idx].width;
> @@ -447,6 +490,38 @@ static uint8_t rvpmu_csr_index(struct perf_event *ev=
ent)
>         return pmu_ctr_list[event->hw.idx].csr - CSR_CYCLE;
>  }
>
> +static uint64_t get_deleg_priv_filter_bits(struct perf_event *event)
> +{
> +       u64 priv_filter_bits =3D 0;
> +       bool guest_events =3D false;
> +
> +       if (event->attr.config1 & RISCV_PMU_CONFIG1_GUEST_EVENTS)
> +               guest_events =3D true;
> +       if (event->attr.exclude_kernel)
> +               priv_filter_bits |=3D guest_events ? HPMEVENT_VSINH : HPM=
EVENT_SINH;
> +       if (event->attr.exclude_user)
> +               priv_filter_bits |=3D guest_events ? HPMEVENT_VUINH : HPM=
EVENT_UINH;
> +       if (guest_events && event->attr.exclude_hv)
> +               priv_filter_bits |=3D HPMEVENT_SINH;
> +       if (event->attr.exclude_host)
> +               priv_filter_bits |=3D HPMEVENT_UINH | HPMEVENT_SINH;
> +       if (event->attr.exclude_guest)
> +               priv_filter_bits |=3D HPMEVENT_VSINH | HPMEVENT_VUINH;
> +
> +       return priv_filter_bits;
> +}
> +
> +static bool pmu_sbi_is_fw_event(struct perf_event *event)
> +{
> +       u32 type =3D event->attr.type;
> +       u64 config =3D event->attr.config;
> +
> +       if (type =3D=3D PERF_TYPE_RAW && ((config >> 63) =3D=3D 1))
> +               return true;
> +       else
> +               return false;
> +}
> +
>  static unsigned long rvpmu_sbi_get_filter_flags(struct perf_event *event=
)
>  {
>         unsigned long cflags =3D 0;
> @@ -475,7 +550,8 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *e=
vent)
>         struct cpu_hw_events *cpuc =3D this_cpu_ptr(rvpmu->hw_events);
>         struct sbiret ret;
>         int idx;
> -       uint64_t cbase =3D 0, cmask =3D rvpmu->cmask;
> +       u64 cbase =3D 0;
> +       unsigned long ctr_mask =3D rvpmu->cmask;
>         unsigned long cflags =3D 0;
>
>         cflags =3D rvpmu_sbi_get_filter_flags(event);
> @@ -488,21 +564,23 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event =
*event)
>         if ((hwc->flags & PERF_EVENT_FLAG_LEGACY) && (event->attr.type =
=3D=3D PERF_TYPE_HARDWARE)) {
>                 if (event->attr.config =3D=3D PERF_COUNT_HW_CPU_CYCLES) {
>                         cflags |=3D SBI_PMU_CFG_FLAG_SKIP_MATCH;
> -                       cmask =3D 1;
> +                       ctr_mask =3D 1;
>                 } else if (event->attr.config =3D=3D PERF_COUNT_HW_INSTRU=
CTIONS) {
>                         cflags |=3D SBI_PMU_CFG_FLAG_SKIP_MATCH;
> -                       cmask =3D BIT(CSR_INSTRET - CSR_CYCLE);
> +                       ctr_mask =3D BIT(CSR_INSTRET - CSR_CYCLE);
>                 }
> +       } else if (pmu_sbi_is_fw_event(event)) {
> +               ctr_mask =3D firmware_cmask;
>         }
>
>         /* retrieve the available counter index */
>  #if defined(CONFIG_32BIT)
>         ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cba=
se,
> -                       cmask, cflags, hwc->event_base, hwc->config,
> +                       ctr_mask, cflags, hwc->event_base, hwc->config,
>                         hwc->config >> 32);
>  #else
>         ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cba=
se,
> -                       cmask, cflags, hwc->event_base, hwc->config, 0);
> +                       ctr_mask, cflags, hwc->event_base, hwc->config, 0=
);
>  #endif
>         if (ret.error) {
>                 pr_debug("Not able to find a counter for event %lx config=
 %llx\n",
> @@ -511,7 +589,7 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *e=
vent)
>         }
>
>         idx =3D ret.value;
> -       if (!test_bit(idx, &rvpmu->cmask) || !pmu_ctr_list[idx].value)
> +       if (!test_bit(idx, &ctr_mask) || !pmu_ctr_list[idx].value)
>                 return -ENOENT;
>
>         /* Additional sanity check for the counter id */
> @@ -561,17 +639,6 @@ static int sbi_pmu_event_find_cache(u64 config)
>         return ret;
>  }
>
> -static bool pmu_sbi_is_fw_event(struct perf_event *event)
> -{
> -       u32 type =3D event->attr.type;
> -       u64 config =3D event->attr.config;
> -
> -       if ((type =3D=3D PERF_TYPE_RAW) && ((config >> 63) =3D=3D 1))
> -               return true;
> -       else
> -               return false;
> -}
> -
>  static int rvpmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>  {
>         u32 type =3D event->attr.type;
> @@ -602,7 +669,6 @@ static int rvpmu_sbi_event_map(struct perf_event *eve=
nt, u64 *econfig)
>                  * 10 - SBI firmware events
>                  * 11 - Risc-V platform specific firmware event
>                  */
> -
>                 switch (config >> 62) {
>                 case 0:
>                         /* Return error any bits [48-63] is set  as it is=
 not allowed by the spec */
> @@ -634,6 +700,84 @@ static int rvpmu_sbi_event_map(struct perf_event *ev=
ent, u64 *econfig)
>         return ret;
>  }
>
> +static int cdeleg_pmu_event_find_cache(u64 config, u64 *eventid, uint32_=
t *counter_mask)
> +{
> +       unsigned int cache_type, cache_op, cache_result;
> +
> +       if (!current_pmu_cache_event_map)
> +               return -ENOENT;
> +
> +       cache_type =3D (config >>  0) & 0xff;
> +       if (cache_type >=3D PERF_COUNT_HW_CACHE_MAX)
> +               return -EINVAL;
> +
> +       cache_op =3D (config >>  8) & 0xff;
> +       if (cache_op >=3D PERF_COUNT_HW_CACHE_OP_MAX)
> +               return -EINVAL;
> +
> +       cache_result =3D (config >> 16) & 0xff;
> +       if (cache_result >=3D PERF_COUNT_HW_CACHE_RESULT_MAX)
> +               return -EINVAL;
> +
> +       if (eventid)
> +               *eventid =3D current_pmu_cache_event_map[cache_type][cach=
e_op]
> +                                                     [cache_result].even=
t_id;
> +       if (counter_mask)
> +               *counter_mask =3D current_pmu_cache_event_map[cache_type]=
[cache_op]
> +                                                          [cache_result]=
.counter_mask;
> +
> +       return 0;
> +}
> +
> +static int rvpmu_cdeleg_event_map(struct perf_event *event, u64 *econfig=
)
> +{
> +       u32 type =3D event->attr.type;
> +       u64 config =3D event->attr.config;
> +       int ret =3D 0;
> +
> +       /*
> +        * There are two ways standard perf events can be mapped to platf=
orm specific
> +        * encoding.
> +        * 1. The vendor may specify the encodings in the driver.
> +        * 2. The Perf tool for RISC-V may remap the standard perf event =
to platform
> +        * specific encoding.
> +        *
> +        * As RISC-V ISA doesn't define any standard event encoding. Thus=
, perf tool allows
> +        * vendor to define it via json file. The encoding defined in the=
 json will override
> +        * the perf legacy encoding. However, some user may want to run p=
erformance
> +        * monitoring without perf tool as well. That's why, vendors may =
specify the event
> +        * encoding in the driver as well if they want to support that us=
e case too.
> +        * If an encoding is defined in the json, it will be encoded as a=
 raw event.
> +        */
> +
> +       switch (type) {
> +       case PERF_TYPE_HARDWARE:
> +               if (config >=3D PERF_COUNT_HW_MAX)
> +                       return -EINVAL;
> +               if (!current_pmu_hw_event_map)
> +                       return -ENOENT;
> +
> +               *econfig =3D current_pmu_hw_event_map[config].event_id;
> +               if (*econfig =3D=3D HW_OP_UNSUPPORTED)
> +                       ret =3D -ENOENT;
> +               break;
> +       case PERF_TYPE_HW_CACHE:
> +               ret =3D cdeleg_pmu_event_find_cache(config, econfig, NULL=
);
> +               if (*econfig =3D=3D HW_OP_UNSUPPORTED)
> +                       ret =3D -ENOENT;
> +               break;
> +       case PERF_TYPE_RAW:
> +               *econfig =3D config & RISCV_PMU_DELEG_RAW_EVENT_MASK;
> +               break;
> +       default:
> +               ret =3D -ENOENT;
> +               break;
> +       }
> +
> +       /* event_base is not used for counter delegation */
> +       return ret;
> +}
> +
>  static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
>  {
>         int cpu;
> @@ -717,7 +861,7 @@ static int pmu_sbi_snapshot_setup(struct riscv_pmu *p=
mu, int cpu)
>         return 0;
>  }
>
> -static u64 rvpmu_sbi_ctr_read(struct perf_event *event)
> +static u64 rvpmu_ctr_read(struct perf_event *event)
>  {
>         struct hw_perf_event *hwc =3D &event->hw;
>         int idx =3D hwc->idx;
> @@ -794,10 +938,6 @@ static void rvpmu_sbi_ctr_start(struct perf_event *e=
vent, u64 ival)
>         if (ret.error && (ret.error !=3D SBI_ERR_ALREADY_STARTED))
>                 pr_err("Starting counter idx %d failed with error %d\n",
>                         hwc->idx, sbi_err_map_linux_errno(ret.error));
> -
> -       if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
> -           (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
> -               rvpmu_set_scounteren((void *)event);
>  }
>
>  static void rvpmu_sbi_ctr_stop(struct perf_event *event, unsigned long f=
lag)
> @@ -808,10 +948,6 @@ static void rvpmu_sbi_ctr_stop(struct perf_event *ev=
ent, unsigned long flag)
>         struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
>         struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
>
> -       if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
> -           (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
> -               rvpmu_reset_scounteren((void *)event);
> -
>         if (sbi_pmu_snapshot_available())
>                 flag |=3D SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
>
> @@ -847,12 +983,6 @@ static int rvpmu_sbi_find_num_ctrs(void)
>                 return sbi_err_map_linux_errno(ret.error);
>  }
>
> -static u32 rvpmu_deleg_find_ctrs(void)
> -{
> -       /* TODO */
> -       return 0;
> -}
> -
>  static int rvpmu_sbi_get_ctrinfo(u32 nsbi_ctr, u32 *num_fw_ctr, u32 *num=
_hw_ctr)
>  {
>         struct sbiret ret;
> @@ -930,53 +1060,75 @@ static inline void rvpmu_sbi_stop_hw_ctrs(struct r=
iscv_pmu *pmu)
>         }
>  }
>
> -/*
> - * This function starts all the used counters in two step approach.
> - * Any counter that did not overflow can be start in a single step
> - * while the overflowed counters need to be started with updated initial=
ization
> - * value.
> - */
> -static inline void rvpmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cp=
u_hw_evt,
> -                                               u64 ctr_ovf_mask)
> +static void rvpmu_deleg_ctr_start_mask(unsigned long mask)
>  {
> -       int idx =3D 0, i;
> -       struct perf_event *event;
> -       unsigned long flag =3D SBI_PMU_START_FLAG_SET_INIT_VALUE;
> -       unsigned long ctr_start_mask =3D 0;
> -       uint64_t max_period;
> -       struct hw_perf_event *hwc;
> -       u64 init_val =3D 0;
> +       unsigned long scountinhibit_val =3D 0;
>
> -       for (i =3D 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++) {
> -               ctr_start_mask =3D cpu_hw_evt->used_hw_ctrs[i] & ~ctr_ovf=
_mask;
> -               /* Start all the counters that did not overflow in a sing=
le shot */
> -               sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, i * BIT=
S_PER_LONG, ctr_start_mask,
> -                       0, 0, 0, 0);
> -       }
> +       scountinhibit_val =3D csr_read(CSR_SCOUNTINHIBIT);
> +       scountinhibit_val &=3D ~mask;
> +
> +       csr_write(CSR_SCOUNTINHIBIT, scountinhibit_val);
> +}
> +
> +static void rvpmu_deleg_ctr_enable_irq(struct perf_event *event)
> +{
> +       unsigned long hpmevent_curr;
> +       unsigned long of_mask;
> +       struct hw_perf_event *hwc =3D &event->hw;
> +       int counter_idx =3D hwc->idx;
> +       unsigned long sip_val =3D csr_read(CSR_SIP);
> +
> +       if (!is_sampling_event(event) || (sip_val & SIP_LCOFIP))
> +               return;
>
> -       /* Reinitialize and start all the counter that overflowed */
> -       while (ctr_ovf_mask) {
> -               if (ctr_ovf_mask & 0x01) {
> -                       event =3D cpu_hw_evt->events[idx];
> -                       hwc =3D &event->hw;
> -                       max_period =3D riscv_pmu_ctr_get_width_mask(event=
);
> -                       init_val =3D local64_read(&hwc->prev_count) & max=
_period;
>  #if defined(CONFIG_32BIT)
> -                       sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START,=
 idx, 1,
> -                                 flag, init_val, init_val >> 32, 0);
> +       hpmevent_curr =3D csr_ind_read(CSR_SIREG5, SISELECT_SSCCFG_BASE, =
counter_idx);
> +       of_mask =3D (u32)~HPMEVENTH_OF;
>  #else
> -                       sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START,=
 idx, 1,
> -                                 flag, init_val, 0, 0);
> +       hpmevent_curr =3D csr_ind_read(CSR_SIREG2, SISELECT_SSCCFG_BASE, =
counter_idx);
> +       of_mask =3D ~HPMEVENT_OF;
> +#endif

There are too many #if defined(CONFIG_32BIT) checks in the code. Could
we centralize their definitions in a unified place and unify the
32-bit/64-bit logic?


> +
> +       hpmevent_curr &=3D of_mask;
> +#if defined(CONFIG_32BIT)
> +       csr_ind_write(CSR_SIREG4, SISELECT_SSCCFG_BASE, counter_idx, hpme=
vent_curr);
> +#else
> +       csr_ind_write(CSR_SIREG2, SISELECT_SSCCFG_BASE, counter_idx, hpme=
vent_curr);
>  #endif
> -                       perf_event_update_userpage(event);
> -               }
> -               ctr_ovf_mask =3D ctr_ovf_mask >> 1;
> -               idx++;
> -       }
>  }
>
> -static inline void rvpmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_event=
s *cpu_hw_evt,
> -                                                    u64 ctr_ovf_mask)
> +static void rvpmu_deleg_ctr_start(struct perf_event *event, u64 ival)
> +{
> +       unsigned long scountinhibit_val =3D 0;
> +       struct hw_perf_event *hwc =3D &event->hw;
> +
> +#if defined(CONFIG_32BIT)
> +       csr_ind_write(CSR_SIREG, SISELECT_SSCCFG_BASE, hwc->idx, ival & 0=
xFFFFFFFF);
> +       csr_ind_write(CSR_SIREG4, SISELECT_SSCCFG_BASE, hwc->idx, ival >>=
 BITS_PER_LONG);
> +#else
> +       csr_ind_write(CSR_SIREG, SISELECT_SSCCFG_BASE, hwc->idx, ival);
> +#endif
> +
> +       rvpmu_deleg_ctr_enable_irq(event);
> +
> +       scountinhibit_val =3D csr_read(CSR_SCOUNTINHIBIT);
> +       scountinhibit_val &=3D ~(1 << hwc->idx);
> +
> +       csr_write(CSR_SCOUNTINHIBIT, scountinhibit_val);
> +}
> +

...

>
> +#define RISCV_PMU_DELEG_RAW_EVENT_MASK GENMASK_ULL(55, 0)
> +
>  #define HW_OP_UNSUPPORTED              0xFFFF
>  #define CACHE_OP_UNSUPPORTED           0xFFFF
>
>
> --
> 2.43.0
>
>

Thanks,
Yunhui

