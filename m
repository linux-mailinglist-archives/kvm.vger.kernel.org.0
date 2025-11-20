Return-Path: <kvm+bounces-63986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 21110C767E0
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E93B74E29CF
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 22:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36C6302172;
	Thu, 20 Nov 2025 22:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="veqzfZ/c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7A42DBF78
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 22:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763677626; cv=none; b=gG7YmyIgicJieM92gew1vKHJb0xuSSCn8nNzjExseNjCJVoHz15Zz50omEa2t/Wspldyahbv6XfWAkUcWL6cZnH3Zyw8OIJHi7aBAQIfJxZsnuAjymCE8FYIMBnQijWrvJ0oBv0awBqz3yQvXKbeY2SWveEGVg4geM/LgDtTszI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763677626; c=relaxed/simple;
	bh=/K3s0pscS/haF+4ncnaGGaMkqpu4JLMANZf3wfh48o8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o+0PQaLMRkouDW+L2TMc4zrqSzYsUX4ADLhHgdLUP0YFBDzbvh0lQaFfEBlTG7oEoMNw8oqG8dgqzjjspMkN2MPxre3btwIKNDXGnHnCVfF7CotjGSg1h9jHRItlm17wD/BsiKn2HpxdZLTFgDsqbBds84crV3/7NdlRFVJploY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=veqzfZ/c; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297e66542afso52203495ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 14:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763677624; x=1764282424; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGFTpRUsW1Pp+jEd+v3ug7mu4QrYVAMAujn3cigLF98=;
        b=veqzfZ/cDpJr7ZbRdXKbqaqPawzCpBvYZaYNyrN9HBeozSwGsn8GLx5WVfM33B1Hy5
         XEPIVJIPoDf/ikkcwXebC5WbYpn1uoa0Ja1grV/PN1ZYIgF1/dzl8WFoVPP7pZkE+iVq
         g7PcHLuaN0JWRpTpkmMzv9vGa2E75Vhq9KKAaoYdzomLSepUDWYOB88b/Tjd2WX2NUPR
         8A1wQ/jd69oFLfXkiz2bl+SwjOA7ee8HxtJo8pfGihV2Dx/ELA7OzRleRUxL5PE7+Dso
         rRvKRu6Ws2b5HzExQ+p9CNMyij9IGjCnMXpOZTnZPR1uuwMGsxGGfs4E4qV90myIK654
         4uUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763677624; x=1764282424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGFTpRUsW1Pp+jEd+v3ug7mu4QrYVAMAujn3cigLF98=;
        b=noJcqBo5x0f+c6Z4fKQVO2C2BxqQNMUbgAiju8mwgpcJRf2Wr92Ou8LxqVxdovC+kH
         9pXPrlrxD86tscVJFOshvF4CDIo5UK5X2ZIAEYQzksXxf7mNLCJL3YtCKpfSgIh+IwYJ
         3VmThwZvp4CvCVNLVpSMauzqt0GQ/K3KPk0lCRlP41wiVm0lKMuxK8GxSrr0NgpUQZCu
         lhJVnq7ffz2bQGKDYbIPgYSNrQuu/IGkyziBJ1iQYRegOiuhXVAWHt6ouVbvKTBAnuQf
         NMoDr7Ws3S5xjBiNyFn0/RHKd4Hz1POZerW2fO9hUNLhAUAhky72g4Ejqwc3j6WKd9p0
         lxGA==
X-Forwarded-Encrypted: i=1; AJvYcCW0jo4ocvrXXF7J/5xSiUftLSgSzIvvJKrNqXmFk7bZ5F00Lgv0jvIrJw+zMO93+n16Q+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye+kTeyLvd0+pbQAFNZ77KN9f4V41HvKFnuUMgVkmcwxJvH8cw
	mBDZrfObLqezG+hw8QdEiRKJc7qiOOjRMMEeHnTipD3RtQ1hnn1/uuo/rW30gQ5iNwqACNq+JPw
	K2pxA2w==
X-Google-Smtp-Source: AGHT+IGlaDUtwJDvDwb1Pa/FFMGXk9r4pFh9EvTNO/Z/rASKT9JYbxX3lZuUoockY57dBy0AkBbgaS8KMxE=
X-Received: from plblf11.prod.google.com ([2002:a17:902:fb4b:b0:290:28e2:ce59])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d54a:b0:295:ed0:f7bf
 with SMTP id d9443c01a7336-29b6bf7f2a9mr2465825ad.58.1763677623748; Thu, 20
 Nov 2025 14:27:03 -0800 (PST)
Date: Thu, 20 Nov 2025 14:27:02 -0800
In-Reply-To: <20250903064601.32131-2-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com> <20250903064601.32131-2-dapeng1.mi@linux.intel.com>
Message-ID: <aR-VtupdTy4vHvSz@google.com>
Subject: Re: [kvm-unit-tests patch v3 1/8] x86/pmu: Add helper to detect Intel
 overcount issues
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>, 
	Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 03, 2025, Dapeng Mi wrote:
> From: dongsheng <dongsheng.x.zhang@intel.com>
> 
> For Intel Atom CPUs, the PMU events "Instruction Retired" or
> "Branch Instruction Retired" may be overcounted for some certain
> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> and complex SGX/SMX/CSTATE instructions/flows.
> 
> The detailed information can be found in the errata (section SRF7):
> https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
> 
> For the Atom platforms before Sierra Forest (including Sierra Forest),
> Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
> be overcounted on these certain instructions, but for Clearwater Forest
> only "Instruction Retired" event is overcounted on these instructions.
> 
> So add a helper detect_inst_overcount_flags() to detect whether the
> platform has the overcount issue and the later patches would relax the
> precise count check by leveraging the gotten overcount flags from this
> helper.
> 
> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
> [Rewrite comments and commit message - Dapeng]
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  lib/x86/processor.h | 27 ++++++++++++++++++++++++++
>  x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 62f3d578..937f75e4 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -1188,4 +1188,31 @@ static inline bool is_lam_u57_enabled(void)
>  	return !!(read_cr3() & X86_CR3_LAM_U57);
>  }
>  
> +/* Copy from kernel arch/x86/lib/cpu.c */

Eh, just drop this, we don't care if the kernel code changes, this is all based
on architectural behavior.

> +static inline u32 x86_family(u32 sig)
> +{
> +	u32 x86;
> +
> +	x86 = (sig >> 8) & 0xf;
> +
> +	if (x86 == 0xf)
> +		x86 += (sig >> 20) & 0xff;
> +
> +	return x86;
> +}
> +
> +static inline u32 x86_model(u32 sig)
> +{
> +	u32 fam, model;
> +
> +	fam = x86_family(sig);
> +
> +	model = (sig >> 4) & 0xf;
> +
> +	if (fam >= 0x6)
> +		model += ((sig >> 16) & 0xf) << 4;
> +
> +	return model;
> +}

We should place these up near is_intel() so that it's more obviously what "family"
and "model" mean (should be obvious already, but it's an easy thing to do).
> +/*
> + * For Intel Atom CPUs, the PMU events "Instruction Retired" or
> + * "Branch Instruction Retired" may be overcounted for some certain
> + * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> + * and complex SGX/SMX/CSTATE instructions/flows.
> + *
> + * The detailed information can be found in the errata (section SRF7):
> + * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
> + *
> + * For the Atom platforms before Sierra Forest (including Sierra Forest),
> + * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
> + * be overcounted on these certain instructions, but for Clearwater Forest
> + * only "Instruction Retired" event is overcounted on these instructions.
> + */
> +static u32 detect_inst_overcount_flags(void)
> +{
> +	u32 flags = 0;
> +	struct cpuid c = cpuid(1);
> +
> +	if (x86_family(c.a) == 0x6) {
> +		switch (x86_model(c.a)) {
> +		case 0xDD: /* Clearwater Forest */
> +			flags = INST_RETIRED_OVERCOUNT;
> +			break;
> +
> +		case 0xAF: /* Sierra Forest */
> +		case 0x4D: /* Avaton, Rangely */
> +		case 0x5F: /* Denverton */
> +		case 0x86: /* Jacobsville */
> +			flags = INST_RETIRED_OVERCOUNT | BR_RETIRED_OVERCOUNT;
> +			break;
> +		}
> +	}
> +
> +	return flags;
> +}

The errata tracking definitely belongs "struct pmu_caps pmu", and the init in
pmu_init().

