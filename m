Return-Path: <kvm+bounces-31058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A8A9BFD56
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 05:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35EE9283559
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 04:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EEC2839E4;
	Thu,  7 Nov 2024 04:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ijvKq8C+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC9CDF59;
	Thu,  7 Nov 2024 04:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730953250; cv=none; b=oiXq5upn3ldf+LR8Uvrnoxtser24ZRiynmm8MQAbYZGQhzFW1xb1Kyu7SG16DumYz/LmIGXkN3k5tO20tqC4aJau1xa2IoqGVDSbfN5Tnip3uPgpo/9XOdhToy2hraRDXe0E/jAjzN55wJOfIqXemEE9E/m1meT4Ujpqrc/Eyxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730953250; c=relaxed/simple;
	bh=RwRfFAaA14v1KhFdJzVgKfI1kH9FS6nlOGTV/TreVI8=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=VyJ2UE2evsJ8Ahk0kRRu14JjoSJc/XyeqWWSH86NV06YG5Nr4FOQ6yskOEmrtwI7NByHP2k4Ckcu2H3km27749HxT6ga1MuPjBm0KZqCz/R23cj2w0aMi8VR/+FSScTVPliIySJUhUbw6iU6jZCKwiSEEhF5A7njkNdIbEdG31o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ijvKq8C+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2113da91b53so3967625ad.3;
        Wed, 06 Nov 2024 20:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730953248; x=1731558048; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P+IQhpL4e5Uo9lQJ0o9uzJmHF+9L3o1PKgI9OcfzQkk=;
        b=ijvKq8C+umdur0DVDjUAsqaD9phoJav1ZX2eOxl9SXVjMSlBfiiPIgjvp5DS3UUgRX
         DJptj5RV2f9u/fXMSdrtrGU0RrIzQX3ayt+g3gHzQZucPstyvOdOX6yhQrJapauE27d3
         FfTYoij887S1DV7hkYDXBdOdvfcwZi0ijLNPIJ9BLzA/pJyDb7weqZzy1h3PaCym25RI
         +DYDHQcwNi9T5TzM7DznEedg6Mi909n0sfJEMJKu5Anaq86UJh/RbBXtfkO6RcZ1VwlP
         JL3ye2AOxzSUelsEulHsX4Q/8KseL0n3UppqcEM4A8NMcZqlSLwW/jvv2BlgaxsBHM+C
         ctKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730953248; x=1731558048;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P+IQhpL4e5Uo9lQJ0o9uzJmHF+9L3o1PKgI9OcfzQkk=;
        b=wS1deroSUKTaQdpMb5dL/KYkHFuSafI5L48v/OoL9o5fc9rqriNJ4o7DRdSOw/gVIF
         RFv1csdmpXBrs69C4ShnCeRvjJm0lgaUYZKS208AtiioUbDhZimDO8TK9koULlcJMonC
         2FXJ6JD7NvekV1T0Bl6R3vA6SHeDeE1D1J395aHVhSvC6byuyrvGzpTC4NWDmWHpdL2F
         Tt8lQPxpNuTWVbwSjDE2BCZtUzr8Ue/2FOZWFrx8pb7yGaL9f+qS7sqiXbFHxzV9Jc+3
         9Rl2oJH80VMZsaTp2rJbr7uCRlRDwyuVF5op4cx9q8iOKEMpxGcEJSASkqcc5/TkW0od
         HVoA==
X-Forwarded-Encrypted: i=1; AJvYcCUFtI9j+0Zjfukt97QhSZ8tS0taUfI39f1djqfoMPiyRe8qpnLbVbR4lTxKK80ieEPKM6auXzD114CWlQhe@vger.kernel.org, AJvYcCURYzbth3ZCQZvzdl0Vm17aBAJOOO1xsnLemwZ7xTuOr+Ki2iXLyiK6976YEK8u6d8w+Ho=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsZGXH9kZl2w7PSxXHI2qHbfH9N+fm19IBbS90s/QqEKdDtk4g
	eopqTQTHasnqtjW0bj0h6pdGAuY+feWTWrlT04A04ozD4oAX1j2hL43UjTL4
X-Google-Smtp-Source: AGHT+IG79uYcUwF9lFYUeqaifpaRzERnIc8rQuJ5hk5cLFMMa1tPt4Z2qXs9P2uWg0OS8aU5m7Ue1w==
X-Received: by 2002:a17:902:ea0d:b0:210:f69c:bebe with SMTP id d9443c01a7336-210f69cc47cmr459585375ad.38.1730953247999;
        Wed, 06 Nov 2024 20:20:47 -0800 (PST)
Received: from dw-tp ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc826fsm2926855ad.11.2024.11.06.20.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 20:20:47 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: Gautam Menghani <gautam@linux.ibm.com>, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org, maddy@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU before running it to avoid spurious interrupts
In-Reply-To: <20241028090411.34625-1-gautam@linux.ibm.com>
Date: Thu, 07 Nov 2024 09:46:40 +0530
Message-ID: <87ttcjwudz.fsf@gmail.com>
References: <20241028090411.34625-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Gautam Menghani <gautam@linux.ibm.com> writes:

> Running a L2 vCPU (see [1] for terminology) with LPCR_MER bit set and no
> pending interrupts results in that L2 vCPU getting an infinite flood of
> spurious interrupts. The 'if check' in kvmhv_run_single_vcpu() sets the
> LPCR_MER bit if there are pending interrupts.
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
> 3. When H_GUEST_GET_STATE is called for LPCR, the vcpu->arch.vcore->lpcr
>    of that vCPU at L1 level gets updated with LPCR_MER set to 1, and this
>    new value is always used whenever that vCPU runs, regardless of whether
>    there was a pending interrupt.
> 4. Since LPCR_MER is set, the vCPU in L2 always jumps to the external
>    interrupt handler, and this cycle never ends.
>
> Fix the spurious flood by masking off the LPCR_MER bit before running a
> L2 vCPU to ensure that it is not set if there are no pending interrupts.
>
> [1] Terminology:
> 1. L0 : PAPR hypervisor running in HV mode
> 2. L1 : Linux guest (logical partition) running on top of L0
> 3. L2 : KVM guest running on top of L1
>
> Fixes: ec0f6639fa88 ("KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0")
> Cc: stable@vger.kernel.org # v6.8+
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
> v1 -> v2:
> 1. Removed the macro which was silently clearing LPCR_MER bit from vcore->lpcr
> and instead just masked it off while sending it to kvmhv_run_single_vcpu().
> Added an inline comment describing the reason to avoid anyone tipping
> it over. (Suggested by Ritesh in an internal review)
>
> v2 -> v3:
> 1. Moved the masking of LPCR_MER from kvmppc_vcpu_run_hv() to
> kvmhv_run_single_vcpu() (Suggested by Michael Ellerman)
>
>  arch/powerpc/kvm/book3s_hv.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 8f7d7e37bc8c..0ed5c5c7a350 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4892,6 +4892,18 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>  							   BOOK3S_INTERRUPT_EXTERNAL, 0);
>  			else
>  				lpcr |= LPCR_MER;
> +		} else {
> +			/*
> +			 * L1's copy of L2's LPCR (vcpu->arch.vcore->lpcr) can get its MER bit
> +			 * unexpectedly set - for e.g. during NMI handling when all register
> +			 * states are synchronized from L0 to L1. L1 needs to inform L0 about
> +			 * MER=1 only when there are pending external interrupts.
> +			 * In the above if check, MER bit is set if there are pending
> +			 * external interrupts. Hence, explicity mask off MER bit
> +			 * here as otherwise it may generate spurious interrupts in L2 KVM
> +			 * causing an endless loop, which results in L2 guest getting hung.
> +			 */
> +			lpcr &= ~LPCR_MER;
>  		}

I think we had enough discussions on v1 internally and v2 on mailing
list. So I am comfortable giving... 

LGTM. Please feel free to add - 

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

>  	} else if (vcpu->arch.pending_exceptions ||
>  		   vcpu->arch.doorbell_request ||
> -- 
> 2.47.0

