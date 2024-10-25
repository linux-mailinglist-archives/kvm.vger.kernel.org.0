Return-Path: <kvm+bounces-29689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3239AFA37
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 08:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C9B61F23367
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 06:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637741B0F03;
	Fri, 25 Oct 2024 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLsLHJ6b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923118C018;
	Fri, 25 Oct 2024 06:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838592; cv=none; b=FUMqKuRoQIfLf6fogz3UhTIesnq0YPHosa2ZpThOTvIoOmFc8KhUKSZfOyRJz5B9DFMnPZXi+iy0T/OZn6aIqa8UzluxTDas0eH02XG3IwMDuuaNBp3aXORYVTCb6wv/JuWSxMKtF7UylK+/64W+GRkWuvQv8XjhpPcTgxFH6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838592; c=relaxed/simple;
	bh=tYWW8T550R8QEZd5gfGCnQaBxuLELI8mHkKVHTwpUMU=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=ZNZepCL1400CxijCjK8MzPMQrKjnQsgiU43NN1lrPhEblQLvtldkfeZb7dqFI1YO8E3D+/gG6Uny66nMYnqL2TsN1uCjcXeAV2sReizbowH3D4aXcKCu8vmgfk/DeEZ/vkivsnIhZAyL02uaH+lYNVIXfr4lHjG2+zSoAlHTl34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLsLHJ6b; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7ea8d7341e6so1123888a12.3;
        Thu, 24 Oct 2024 23:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729838589; x=1730443389; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P47I0gdiUlkn3LmA4ci0Px6PUVaCXe2wtW4m1OPAR8s=;
        b=fLsLHJ6bW8WRrEt31EroqwA80Ok23bqef280bKa5k2tVKRvVQMUM1+BBvfa9dTFRRv
         jMJlZva4iNaBG5oPPQGQmYhPL92ZQLHCdaXh8aF4DgG2sflO+0mZO/7S20EZlnqtwsPM
         2gjjDhAjyQ2polYr9i8OSLx8cTz4k0amYz7KnANFMs9ooWcCY6Qdj1hcBpEpDwozUsoh
         xsej0RI3GSdQnUaaoTSF/HleFALrtWxDfp8wbmWtCs6m55SanQNjt3bZTyRWAuKdF7BH
         AEWPKaD4pBS77+XC2MCQRAII3VED8qfjoETG8+xOwH/6l0QNxJxiOatLv9Qt6yb8v1AJ
         mCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838589; x=1730443389;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P47I0gdiUlkn3LmA4ci0Px6PUVaCXe2wtW4m1OPAR8s=;
        b=PBDqNyLZnhwefTxh04/61B7OBWpDw8Yj6hH+v4y0MK7NxdAsXjmxS1CYkkiFPisxpA
         GUHTrUlFeau++Me15Yhu1p8PtDHsJrlmsZjT9kaqxV0DsK2IX4TxRZ1lg7lw8eRW3CS3
         mzHGtOjWQk5OUj5etNa8kZ2yd9RyH80KNLQWobu/NUs8f6Jda8kEYwAHLQwB1BMhQl1P
         c5tvLb9jKu8bzuHM6jhFLrLqp75nNqZbPTkCioOtCeT80TFQ5q0bqpRNartYkKlM+5kz
         0aajbbH0pXRzF/67WpYNmh3IEtM8MBl0wJMEVZEraqp9zrDPjKDCmVrLyz1Xvmjep4iK
         G8ow==
X-Forwarded-Encrypted: i=1; AJvYcCVt+WaAZQKv0BIhwGmEqR2tzJ9EFCUXofI+XRFi/vfxTMRSJjA6T2Am1Ml9wsX+dvEY50g=@vger.kernel.org, AJvYcCWxcDdD7nQAqb4s73DLpjNnvYEzlOH4SollbBrk9n0QI7tSionYyOrh/x30dLgtrGyK8ow0S1uM5IMzd9Lv@vger.kernel.org
X-Gm-Message-State: AOJu0YzY1Yp9P37858B0I3K0SBsBVM9xIy3vjU+2tPbaeDXcQve6g0Ti
	GCPiyegCbdCUtEbxmd6XWwWfrkaGVfV6g8hun8t7cxHwRiSJuRliZyMmMw==
X-Google-Smtp-Source: AGHT+IFxdZwIFKOQNiOIOKlXyUTiHQUYTmMXDxrzgTed1lrPb/WrWs4hS/ZL7SNSfx+CwmEz3d4d5g==
X-Received: by 2002:a05:6a21:3a82:b0:1d6:5f3d:4ab7 with SMTP id adf61e73a8af0-1d989b3c990mr5577835637.22.1729838588742;
        Thu, 24 Oct 2024 23:43:08 -0700 (PDT)
Received: from dw-tp ([171.76.85.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a1f18esm446345b3a.146.2024.10.24.23.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 23:43:07 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: Gautam Menghani <gautam@linux.ibm.com>, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU before running it to avoid spurious interrupts
In-Reply-To: <20241024173417.95395-1-gautam@linux.ibm.com>
Date: Fri, 25 Oct 2024 11:37:52 +0530
Message-ID: <871q04oguf.fsf@gmail.com>
References: <20241024173417.95395-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Gautam Menghani <gautam@linux.ibm.com> writes:

> Mask off the LPCR_MER bit before running a vCPU to ensure that it is not
> set if there are no pending interrupts. Running a vCPU with LPCR_MER bit
> set and no pending interrupts results in L2 vCPU getting an infinite flood
> of spurious interrupts. The 'if check' in kvmhv_run_single_vcpu() sets
> the LPCR_MER bit if there are pending interrupts.
>
> The spurious flood problem can be observed in 2 cases:
> 1. Crashing the guest while interrupt heavy workload is running
>   a. Start a L2 guest and run an interrupt heavy workload (eg: ipistorm)
>   b. While the workload is running, crash the guest (make sure kdump
>      is configured)
>   c. Any one of the vCPUs of the guest will start getting an infinite
>      flood of spurious interrupts.
>
> 2. Running LTP stress tests in multiple guests at the same time
>    a. Start 4 L2 guests.
>    b. Start running LTP stress tests on all 4 guests at same time.
>    c. In some time, any one/more of the vCPUs of any of the guests will
>       start getting an infinite flood of spurious interrupts.
>
> The root cause of both the above issues is the same:
> 1. A NMI is sent to a running vCPU that has LPCR_MER bit set.
> 2. In the NMI path, all registers are refreshed, i.e, H_GUEST_GET_STATE
>    is called for all the registers.
> 3. When H_GUEST_GET_STATE is called for lpcr, the vcpu->arch.vcore->lpcr
>    of that vCPU at L1 level gets updated with LPCR_MER set to 1, and this
>    new value is always used whenever that vCPU runs, regardless of whether
>    there was a pending interrupt.
> 4. Since LPCR_MER is set, the vCPU in L2 always jumps to the external
>    interrupt handler, and this cycle never ends.
>
> Fix the spurious flood by making sure a vCPU's LPCR_MER is always masked
> before running a vCPU.
>
> Fixes: ec0f6639fa88 ("KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0")
> Cc: stable@vger.kernel.org # v6.8+
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
> V1 -> V2:
> 1. Mask off the LPCR_MER in vcpu->arch.vcore->lpcr instead of resetting
> it so that we avoid grabbing vcpu->arch.vcore->lock. (Suggested by
> Ritesh in an internal review)

Thanks Gautam for addressing the review comment. But let me improve the
changelog a little to make it more accurate for others too.

Removed the macro which was silently clearing LPCR_MER bit from vcore->lpcr
and instead just mask it off while sending it to kvmhv_run_single_vcpu().
Added an inline comment describing the reason to avoid anyone tipping
it over. - (suggested ...)


Yes, that would also mean that no need of taking any vcore lock since we
are not modifying any of the vcore state variables which came up in the
internal review discussion.
Having said that it will be good to document the usage of vcore->lock
above the struct kvmppc_vcore definition. Because it isn't obvious of
when all it should be taken and/or what all it protects?

>
>  arch/powerpc/kvm/book3s_hv.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 8f7d7e37bc8c..b8701b5dde50 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5089,9 +5089,19 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
>  
>  	do {
>  		accumulate_time(vcpu, &vcpu->arch.guest_entry);
> +		/*
> +		 * L1's copy of L2's lpcr (vcpu->arch.vcore->lpcr) can get its MER bit
> +		 * unexpectedly set - for e.g. during NMI handling when all register
> +		 * states are synchronized from L0 to L1. L1 needs to inform L0 about
> +		 * MER=1 only when there are pending external interrupts.
> +		 * kvmhv_run_single_vcpu() anyway sets MER bit if there are pending
> +		 * external interrupts. Hence, mask off MER bit when passing vcore->lpcr
> +		 * here as otherwise it may generate spurious interrupts in L2 KVM
> +		 * causing an endless loop, which results in L2 guest getting hung.
> +		 */

Thanks for describing this inline.

>  		if (cpu_has_feature(CPU_FTR_ARCH_300))
>  			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
> -						  vcpu->arch.vcore->lpcr);
> +						  vcpu->arch.vcore->lpcr & ~LPCR_MER);

While still at it - 
I too like mpe suggestion to clear the LPCR_MER bit at one place
itself within kvmhv_run_single_vcpu(). 

>  		else
>  			r = kvmppc_run_vcpu(vcpu);
>  
> -- 
> 2.47.0

-ritesh

