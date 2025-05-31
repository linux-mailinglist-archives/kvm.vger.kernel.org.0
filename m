Return-Path: <kvm+bounces-48132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2304AC9C28
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 20:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFABA3BBA3C
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 18:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C9C191F89;
	Sat, 31 May 2025 18:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVbaKFug"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92108645;
	Sat, 31 May 2025 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748714485; cv=none; b=DY/LEKEB/ELqGuIJQ9PfPeHwCtbzKippam+AMRVeox540RRexzj0sYpGzQmTfcY9YDBggAQFkn7t7fcxp3WF+J/2r92o1VHi6enQavPi2gUN+dccEkSEVD9aQ9Ih1rOrCvSA9NdsKXiJUtKtso9AAxKsu0rlqq+Y4oUTeQQ/7lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748714485; c=relaxed/simple;
	bh=IIO2ZrW4hMoB/RO3YoS7t7jsG6uwCicCIHFVETR/btE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=qClIo2OcFLiG9CcjbYd9FaDjmFZ7YJEptgqe6qQdyGFP1BqcYZ6G6lWQKHjOYhPbzPul2K083h+Y5gLKYRNThFmPm0gAttZnsFwToB2TMSMUn8lUSERhmQm4Q3RK8wmepzxahK+S0F1XXOS02IgEM3sNTVJb30DqQgPtdxVMVP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVbaKFug; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-450df5d7b9fso5021495e9.1;
        Sat, 31 May 2025 11:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748714481; x=1749319281; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7N23WPiWeZX7wNDy0YIlIArv1JuPRPe0Q6JS06wayU=;
        b=FVbaKFugZBaNwAwQQveVKCtPvIQH826ffFDv1gN1mycTn5PDz+vZ+GbVYMDVKfxCk+
         nZG7zypPhwZvcM6maL9mDAOz7L2fMW3LIoTVnOv1Ew4GamLl2lKiCfaeFL9gRRslXBv6
         N0ctcCC4eS6op5XpBtHwZV9MwWTGSA0oXm4m9McuqyaLZwFy8duGTrheIcaLnlydgHUH
         KEJUMGMlQE6xHyyJ1YklfZ1iPpB0D9jlKrvC7hm/faDcUm3013gIgoTLKOb5zLZfu0Ap
         eOwvn5IYRvlKuIMnQ5KxK3L1PXyg/pseHlufCfpDd43p1CBTLfUcplleUqXdkaQmZKAr
         T9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748714481; x=1749319281;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y7N23WPiWeZX7wNDy0YIlIArv1JuPRPe0Q6JS06wayU=;
        b=aLKZVc0sX3cYb1IVr5eSC982pt09Ot++AUhAuf3lOMus+bbZTja+qkFGjw+nEVy9JJ
         h+fQm2K4YgrQYCUpuxiM6Hvj1r+3HVCX8EXe+fSKBYg6AAIDK30nhXUKkL+YRcDwfYxL
         gjmGJuIOtzFRzFsTp8IgFohZZIEFTr73aLEW0llw4B+dUIZXcBP36/Mb8ojy3Sd0967Q
         tdyd+ztPD/HU4iiVbxTamJ1P6L9xPpl8ewHQ1HNrZziE91GIidYUixjGTUAFGSSEcP7N
         MWxnROiIi65CA4LKJqPtRZouYzM+mIEYDeNaNqF/g2YOAtC0BPp/a12ToOe+qLwNDce8
         m+Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUuSh+I2Q8h8zRA3kxlLz0PJHa1PkruHQS6xZClcmelt7OX355I1lLTaZB61qpKzYSRGRtiu5o52+XKREtV@vger.kernel.org, AJvYcCWBzUatT0W62l86kvnbMrFMddzYPehEu5sllsqX88hPV1jeumJ0q39JHaA/4+Ex9vNdZms=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDUqy1/y9EYCGN0NPMfi4vtvpualG2unzbZOuJpBER5ArihbJR
	brf2gRl0meurjQUc5gOBeaIlCkNhcLQytPLxr7t2FSFx8IoQ3e03EO4t
X-Gm-Gg: ASbGncueNeAmazSH1RK/QJDBLHroxk4Aj+Br85Ha7BvkwNVBUx8eigqdUQeR8GLhk4q
	3zNJHPzRJ6ToSUA3/fz8nuPrzRHwW3EBUvwpVXvYmz8C/VFjid5uC+JzbGu/3+wVMZKt88YY+iu
	ZaeLrDQjfbj04ezB4VBwFqYVk1zoIByDAaKE9e/+NfJGdZSxwHkF2o2NNRiFHEq3NUPBPJ6XZ1r
	UzhDARfvC770DndH0742VpCdVfBigK3SyBt52V6bmIAVJ5Uzu+/P5fHLiWw4B+5v8Fc8/qoThD1
	fU/vRyxPf7GgfGIA+/Wo/rZCczL0RS53FAU+7ZqkLF76EmYKp7BzTRC/m/aNWzwUK2R4Bby9wta
	lO2xnjL92+q28oDrZbNqlM69C+P48e0O/
X-Google-Smtp-Source: AGHT+IGow34iFFc5A3PtRC3U9gzX+qOmKMUGQmeKxZjFz5/C983xaeQUZnyV5p0/lrZD5A++twH+Cg==
X-Received: by 2002:a05:600c:1c08:b0:442:f861:3536 with SMTP id 5b1f17b1804b1-450d6b59b03mr67320495e9.7.1748714480425;
        Sat, 31 May 2025 11:01:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:5c69:6d03:309e:bc47? ([2001:b07:5d29:f42d:5c69:6d03:309e:bc47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4f0097205sm8774995f8f.79.2025.05.31.11.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 May 2025 11:01:20 -0700 (PDT)
Message-ID: <e5e1fb2715a98f24ba69cc4da5c30777633f6f62.camel@gmail.com>
Subject: Re: [PATCH 17/28] KVM: SVM: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: seanjc@google.com
Cc: bp@alien8.de, chao.gao@intel.com, dapeng1.mi@linux.intel.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	xin@zytor.com
Date: Sat, 31 May 2025 20:01:18 +0200
In-Reply-To: <20250529234013.3826933-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-05-29 at 23:40, Sean Christopherson wrote:
> @@ -81,70 +79,6 @@ static uint64_t osvw_len =3D 4, osvw_status;
> =20
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
> =20
> -static const u32 direct_access_msrs[] =3D {
> -	MSR_STAR,
> -	MSR_IA32_SYSENTER_CS,
> -	MSR_IA32_SYSENTER_EIP,
> -	MSR_IA32_SYSENTER_ESP,
> -#ifdef CONFIG_X86_64
> -	MSR_GS_BASE,
> -	MSR_FS_BASE,
> -	MSR_KERNEL_GS_BASE,
> -	MSR_LSTAR,
> -	MSR_CSTAR,
> -	MSR_SYSCALL_MASK,
> -#endif
> -	MSR_IA32_SPEC_CTRL,
> -	MSR_IA32_PRED_CMD,
> -	MSR_IA32_FLUSH_CMD,
> -	MSR_IA32_DEBUGCTLMSR,
> -	MSR_IA32_LASTBRANCHFROMIP,
> -	MSR_IA32_LASTBRANCHTOIP,
> -	MSR_IA32_LASTINTFROMIP,
> -	MSR_IA32_LASTINTTOIP,
> -	MSR_IA32_XSS,
> -	MSR_EFER,
> -	MSR_IA32_CR_PAT,
> -	MSR_AMD64_SEV_ES_GHCB,
> -	MSR_TSC_AUX,
> -	X2APIC_MSR(APIC_ID),
> -	X2APIC_MSR(APIC_LVR),
> -	X2APIC_MSR(APIC_TASKPRI),
> -	X2APIC_MSR(APIC_ARBPRI),
> -	X2APIC_MSR(APIC_PROCPRI),
> -	X2APIC_MSR(APIC_EOI),
> -	X2APIC_MSR(APIC_RRR),
> -	X2APIC_MSR(APIC_LDR),
> -	X2APIC_MSR(APIC_DFR),
> -	X2APIC_MSR(APIC_SPIV),
> -	X2APIC_MSR(APIC_ISR),
> -	X2APIC_MSR(APIC_TMR),
> -	X2APIC_MSR(APIC_IRR),
> -	X2APIC_MSR(APIC_ESR),
> -	X2APIC_MSR(APIC_ICR),
> -	X2APIC_MSR(APIC_ICR2),
> -
> -	/*
> -	 * Note:
> -	 * AMD does not virtualize APIC TSC-deadline timer mode, but it
> is
> -	 * emulated by KVM. When setting APIC LVTT (0x832) register bit
> 18,
> -	 * the AVIC hardware would generate GP fault. Therefore, always
> -	 * intercept the MSR 0x832, and do not setup direct_access_msr.
> -	 */
> -	X2APIC_MSR(APIC_LVTTHMR),
> -	X2APIC_MSR(APIC_LVTPC),
> -	X2APIC_MSR(APIC_LVT0),
> -	X2APIC_MSR(APIC_LVT1),
> -	X2APIC_MSR(APIC_LVTERR),
> -	X2APIC_MSR(APIC_TMICT),
> -	X2APIC_MSR(APIC_TMCCT),
> -	X2APIC_MSR(APIC_TDCR),
> -};
> -
> -static_assert(ARRAY_SIZE(direct_access_msrs) =3D=3D
> -	      MAX_DIRECT_ACCESS_MSRS - 6 * !IS_ENABLED(CONFIG_X86_64));
> -#undef MAX_DIRECT_ACCESS_MSRS

The MAX_DIRECT_ACCESS_MSRS define should now be removed from
arch/x86/kvm/svm/svm.harch/x86/kvm/svm/svm.h, since it's no longer used.

