Return-Path: <kvm+bounces-16963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D848BF547
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D3121F2178A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 04:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A48910A1B;
	Wed,  8 May 2024 04:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5IgeFsS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500B528F4
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 04:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715143016; cv=none; b=IC1Ifjx5zQi7S5IAdWE3DcQPgiFUHmFoTaJl2RTWKWN/UpepWfoI96tFIrNA5upZIWBaawnhbq09IpeJKtiQPjspNfMRHToo4aoKg+YmBF0qGfcRy9ps9hy/arbd6eAcmZstyh+iL/xBPu8F8+azqZ29GpFdn39HsEeCTiSlOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715143016; c=relaxed/simple;
	bh=Phq+qnbq/jzX/hzG7WpHAWxncVFl+OzG+PbZTNYers8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OU9o0HPmxDX+cNELQcnWeVS7dGNphh/weR8hPVVIvhGNsTIZZiOvhc1AT1XvtsPk4FRz7ChWj/4H09yOGoYtpoHU0wPgppsFAKm4Jzs8/lFaaqIyuVZLNjdgGknHTfBPu1sOYAzmAT77bJOwEHlLpdYS9fe510ZToY6V642shBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D5IgeFsS; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51f4d2676d1so4300577e87.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 21:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715143012; x=1715747812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvW6bcW5/9H572n3jcZ+QuQeXteJDuCr/aawtkwSyO8=;
        b=D5IgeFsSnX+KIZDZfc5dp6IKLb2ryUP4sCiggrMcfzNavIxm76KkeVBgJuTFMePYSP
         avgfmIY4bQXQPQxyXSPjcwAFwqRBBm0ayPJ8py+orRT+NZaxqh7vPV7r2sOmbx0xAc5i
         4XijNXb+9DoLcO2PgnlBf+sbboc0piRqrxbJAq6urz7bMLirnSf47XvNWt5y/UVAU/UD
         ZntIFqFvbrPCDgFscasRnNSK/iNhcvIENZKgG+dy9ePLXwvSWHyqK9Yq2h5cogkq6rlL
         Q4XdFLsUvQR47DQJ0enesyKXtNwUiKTZuRrZmc1hkb1GEJ3tC54ZxzglUteigTL3tA+h
         PKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715143012; x=1715747812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvW6bcW5/9H572n3jcZ+QuQeXteJDuCr/aawtkwSyO8=;
        b=YBDMnLr0jSkHMBHjbsGqZG/6GM9Tac2ACvtxzrDbyhbTetQtjpX09BOAk9m2BRwspP
         75ZMOuMy3IfD34+dfqeUcOxvIpy1FbNSsGvMGX5GlcBM8XmRo4F2/Y19Fwtmp6K5TndG
         4/ptRdC9D4z58m7lIJxwqk2R36aibz6xpxVP2BCCcGit4jD/u6/qg3h+rvqqaaCEPWTQ
         9a/lkxFvZLPC6exqA3N4Cawh6rIrIIIEcTsR6yrR2ASEIGf3PtGuQc3x2W2/gzKpdrrA
         jTqhG9oC6quaKArtNe5emT6d1iXGP9DVkyArTYu1zOG9Y1uVn+gCbOCfrYu/RRTbu6g5
         oRbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcvBGF9DMovlbbNGBHBVuUzPwALT/X/em+WvEOGNeQ8mgxE7a36TLXGL3A6rgIW+jAFP6CxuDcF3AU+mtHkJlPwpyS
X-Gm-Message-State: AOJu0YzRk9/7xFuz7LUmZoGYncLI/GilalWPq3/XGP/1r4EAZfztfSiW
	rR/m/VEAgFft3EQVpeZ/mX94nw/If58PxnKuNGAf04QAlM8HJzHzmofBQ4i1Vj+JGe8ex4WO8Og
	qIrnMD6NtdAXqHqMAvP+qP0eZ6nnxj4BahDw5
X-Google-Smtp-Source: AGHT+IGWYn3HLbtQAK6lcVfTSgk1K+GOPDLZAVrOEc/jGdjisZ86hcy3tMqrqi3XNn981JUfLi/I5uOTbU1go+gvgcY=
X-Received: by 2002:ac2:5291:0:b0:51d:5e16:517a with SMTP id
 2adb3069b0e04-5217cd49804mr728024e87.48.1715143012176; Tue, 07 May 2024
 21:36:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com> <20240506053020.3911940-18-mizhang@google.com>
 <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com>
In-Reply-To: <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 7 May 2024 21:36:15 -0700
Message-ID: <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 7, 2024 at 9:19=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.c=
om> wrote:
>
>
> On 5/6/2024 1:29 PM, Mingwei Zhang wrote:
> > From: Sandipan Das <sandipan.das@amd.com>
> >
> > Currently, the global control bits for a vcpu are restored to the reset
> > state only if the guest PMU version is less than 2. This works for
> > emulated PMU as the MSRs are intercepted and backing events are created
> > for and managed by the host PMU [1].
> >
> > If such a guest in run with passthrough PMU, the counters no longer wor=
k
> > because the global enable bits are cleared. Hence, set the global enabl=
e
> > bits to their reset state if passthrough PMU is used.
> >
> > A passthrough-capable host may not necessarily support PMU version 2 an=
d
> > it can choose to restore or save the global control state from struct
> > kvm_pmu in the PMU context save and restore helpers depending on the
> > availability of the global control register.
> >
> > [1] 7b46b733bdb4 ("KVM: x86/pmu: Set enable bits for GP counters in PER=
F_GLOBAL_CTRL at "RESET"");
> > Reported-by: Mingwei Zhang <mizhang@google.com>
> > Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> > [removed the fixes tag]
> > ---
> >  arch/x86/kvm/pmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 5768ea2935e9..e656f72fdace 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
> >        * in the global controls).  Emulate that behavior when refreshin=
g the
> >        * PMU so that userspace doesn't need to manually set PERF_GLOBAL=
_CTRL.
> >        */
> > -     if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters=
)
> > +     if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pm=
u->nr_arch_gp_counters)
>
> The logic seems not correct. we could support perfmon version 1 for
> meidated vPMU (passthrough vPMU) as well in the future.  pmu->passthrough
> is ture doesn't guarantee GLOBAL_CTRL MSR always exists.

heh, the logic is correct here. However, I would say the code change
may not reflect that clearly.

The if condition combines the handling of global ctrl registers for
both the legacy vPMU and the mediated passthrough vPMU.

In legacy pmu, the logic should be this:

if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)

Because, since KVM emulates the MSR, if the global ctrl register does
not exist, then there is no point resetting it to any value. However,
if it does exist, there are non-zero number of GP counters, we should
reset it to some value (all enabling bits are set for GP counters)
according to SDM.

The logic for mediated passthrough PMU is different as follows:

if (pmu->passthrough && pmu->nr_arch_gp_counters)

Since mediated passthrough PMU requires PerfMon v4 in Intel (PerfMon
v2 in AMD), once it is enabled (pmu->passthrough =3D true), then global
ctrl _must_ exist phyiscally. Regardless of whether we expose it to
the guest VM, at reset time, we need to ensure enabling bits for GP
counters are set (behind the screen). This is critical for AMD, since
most of the guests are usually in (AMD) PerfMon v1 in which global
ctrl MSR is inaccessible, but does exist and is operating in HW.

Yes, if we eliminate that requirement (pmu->passthrough -> Perfmon v4
Intel / Perfmon v2 AMD), then this code will have to change. However,
that is currently not in our RFCv2.

Thanks.
-Mingwei







>
>
> >               pmu->global_ctrl =3D GENMASK_ULL(pmu->nr_arch_gp_counters=
 - 1, 0);
> >  }
> >

