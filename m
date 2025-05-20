Return-Path: <kvm+bounces-47164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B2DABE197
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51B3017C903
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFF7280334;
	Tue, 20 May 2025 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="QVmjnv5j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC9B27E1AB
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 17:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747760905; cv=none; b=NfRWi2bMncJ8nYszXHErkcn7yuM9d3jGSAWW9bbMEMEcMWqqZ+2NJftXmJSn9Ykd5w2iYVVMG0fxmZxhZYHUS1WVV2Z9A52oam5dtlYesfPuPZTG7MDT7l1J7x+jYVrzPkhVEbWOqTqK9nfgxjUeOILly60E2ejsuN/Undiz7+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747760905; c=relaxed/simple;
	bh=p7E1s58bfdKq/W84Pqelq9+BY61nFPwJbfs01hSKOuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYsKBd3DwPlL9B/pZy5tAjPCvLRLcXCFVXDWLFnNMQJTOew2EXj6jCqk3yVh0imV1wuznL+XGMXVrAYQGgQdwGeHF/bq0QsYgr6ZzPe1vnDJrhmjgyktYbGY0X8TJV1D7ZFH6eaptkiBe0264AnLgF4mT3O+0jKeFC6WzI+yw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=QVmjnv5j; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso5220058b3a.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747760902; x=1748365702; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DDjRFmO/FlIqGEtWUGUmfdfKllur189aWobDQoyjRQs=;
        b=QVmjnv5jrhAjOmnrfodzMvtSxLGgoc9MgeXZfR/IQ1QM/cdFFBH6acGVW0LLOAaaqB
         wO51w0SuAvJaEMHoZksG4d5edkWcLoyS0cHawjMMzJNBGUkLNDK3dx33puavTOXeFRmG
         Vi+S+sZCew6BBZZrYKh+HeFG60bXUc4VfDz5gpeM6MK4O8rFG0APl5iaEIIS57nLUhTx
         rhNS1q1Dx8XY1sMuUyisn5i26OK6y3N9eyFQo1SUHpEuIic1rGgGCw1nL1iKCJWs+JWI
         hWmgUi/W2i8YOCvrFp23/iyeS/aXXPRuzTzTsPEDm92ajtQGqrPKRwlMiMIBeqJSx1OE
         JVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747760902; x=1748365702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DDjRFmO/FlIqGEtWUGUmfdfKllur189aWobDQoyjRQs=;
        b=UAoXEeYz2G0RiGTmoh4Z5JqCEAK0DKsQHS/MOnxZxkZuJ3hMDimLqmzOvaCkeo7W4l
         PY8zR84iyIWDe6ZTVgEUw4XlPuMyublBrWjiHSPoLjhNMTQU48L3aSybgklIrOA687WV
         2yn1Oj9G1fXlD2nmEVtHLyq0DKL+EFivzRiijNIX3feffkV+Slf45Ju9mzzGt1GhbRp1
         Yx4ruwWqRNxnogb5/Gb7yxBh2R4MiPP4p2ytykD3fsrbxz4AC9E5JNWLbViwFi1ts13L
         P+s2rtg0YNxvJz9/UgtXa5RT/qKzqJGa1Aj9Ac92IrdaZeuHGamPV1MIAv4FtHeh+BhQ
         WK8A==
X-Forwarded-Encrypted: i=1; AJvYcCXEWuA38+MJb6WSekWdsQHRB1r79H6/5MWg4D7+w7c/IdDgs0pwP+iMyt14foDW7ly+eUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN7YOzfo0RBdg9uov2tJHk3BXqNfKSmifRIQbspVgX1YXhArs0
	kfURvZuFJxL/rIe7HrjT78bADPbCOFBh16t1HVZcWvO4gw47i6y1CovucmjDth7wYYM=
X-Gm-Gg: ASbGncuq30ttYlGG7MA7ha/NFQpwsp3DdQKCRNUzpjaXM7s1PVn6H9rDX+triLvSFMn
	4sSTb/OuW6Cb4aLfiETG7wN783n3XNc6sBvfzMd4u8pm8XwURvCHjLesBhcKBL/vM/1WE7CHvwU
	eiTCDGq+nOkFC2my8Yj/lLuhBgMTmdwyZjH4M0JYERqtYeCvkIJDhFaoRyrAPXmvMZLhQq9X99c
	5KiaBnuPm7ud5WIJs/goLizPsCT4TPAiVo0utadwNVMExwiUZe2EwL0pFWijMhZZTRFydoSy2r6
	FzxxFSfPOAgZ+MqXlqNNFV7BSG5t2mZAxtWsMguoYlzZ4I8=
X-Google-Smtp-Source: AGHT+IHuT79L0+UrgKSwtY58fOb+r5axNp9Bh0rhvhNRM5zmWiTrh0ZXIgCZQR8QM+4Pdq9KGT4FDg==
X-Received: by 2002:a05:6a20:2d07:b0:1ee:a914:1d64 with SMTP id adf61e73a8af0-216219bd3a5mr27575586637.28.1747760902322;
        Tue, 20 May 2025 10:08:22 -0700 (PDT)
Received: from ghost ([2601:647:6700:64d0:17b4:8663:3229:f2dd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eaf96573sm8189882a12.43.2025.05.20.10.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 10:08:21 -0700 (PDT)
Date: Tue, 20 May 2025 10:08:19 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: Re: [PATCH v7 09/14] riscv: misaligned: move emulated access
 uniformity check in a function
Message-ID: <aCy3A6uUbnWoO9uC@ghost>
References: <20250515082217.433227-1-cleger@rivosinc.com>
 <20250515082217.433227-10-cleger@rivosinc.com>
 <aCu_ce-kVQsyjrh5@ghost>
 <126762fc-17ca-4e9d-94d0-3aed1ae321ff@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <126762fc-17ca-4e9d-94d0-3aed1ae321ff@rivosinc.com>

On Tue, May 20, 2025 at 10:19:47AM +0200, Clément Léger wrote:
> 
> 
> On 20/05/2025 01:32, Charlie Jenkins wrote:
> > On Thu, May 15, 2025 at 10:22:10AM +0200, Clément Léger wrote:
> >> Split the code that check for the uniformity of misaligned accesses
> >> performance on all cpus from check_unaligned_access_emulated_all_cpus()
> >> to its own function which will be used for delegation check. No
> >> functional changes intended.
> >>
> >> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> >> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> >> ---
> >>  arch/riscv/kernel/traps_misaligned.c | 20 ++++++++++++++------
> >>  1 file changed, 14 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> >> index e551ba17f557..287ec37021c8 100644
> >> --- a/arch/riscv/kernel/traps_misaligned.c
> >> +++ b/arch/riscv/kernel/traps_misaligned.c
> >> @@ -647,6 +647,18 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
> >>  }
> >>  #endif
> >>  
> >> +static bool all_cpus_unaligned_scalar_access_emulated(void)
> >> +{
> >> +	int cpu;
> >> +
> >> +	for_each_online_cpu(cpu)
> >> +		if (per_cpu(misaligned_access_speed, cpu) !=
> > 
> > misaligned_access_speed is only defined when
> > CONFIG_RISCV_SCALAR_MISALIGNED. This function should return false when
> > !CONFIG_RISCV_SCALAR_MISALIGNED and only use this logic otherwise.
> 
> Hi Charlie,
> 
> misaligned_access_speed is defined in unaligned_access_speed.c which is
> compiled based on CONFIG_RISCV_MISALIGNED (ditto for trap_misaligned.c)
> 
> obj-$(CONFIG_RISCV_MISALIGNED)	+= unaligned_access_speed.o
> 
> However, the declaration for it in the header cpu-feature.h however is
> under a CONFIG_RISCV_SCALAR_MISALIGNED ifdef. So either the declaration
> or the definition is wrong but the ifdefery soup makes it quite
> difficult to understand what's going on.
> 
> I would suggest to move the DECLARE_PER_CPU under
> CONFIG_RISCV_MISALIGNED so that it reduces ifdef in traps_misaligned as
> well.

Here is the patch I am using locally for testing purposes, but if there
is a way to reduce the number of ifdefs that is probably the better way to go:

From 18f9a056d3b597934c931abdf72fb6e775ccb714 Mon Sep 17 00:00:00 2001
From: Charlie Jenkins <charlie@rivosinc.com>
Date: Mon, 19 May 2025 16:35:51 -0700
Subject: [PATCH] fixup! riscv: misaligned: move emulated access uniformity
 check in a function

---
 arch/riscv/kernel/traps_misaligned.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index f3ab84bc4632..1449c6a4ac21 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -647,6 +647,10 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
 }
 #endif
 
+#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
+
+static bool unaligned_ctl __read_mostly;
+
 static bool all_cpus_unaligned_scalar_access_emulated(void)
 {
 	int cpu;
@@ -659,10 +663,6 @@ static bool all_cpus_unaligned_scalar_access_emulated(void)
 	return true;
 }
 
-#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
-
-static bool unaligned_ctl __read_mostly;
-
 static void check_unaligned_access_emulated(void *arg __always_unused)
 {
 	int cpu = smp_processor_id();
@@ -716,6 +716,10 @@ bool unaligned_ctl_available(void)
 	return unaligned_ctl;
 }
 #else
+static bool all_cpus_unaligned_scalar_access_emulated(void)
+{
+	return false;
+}
 bool __init check_unaligned_access_emulated_all_cpus(void)
 {
 	return false;
-- 
2.43.0


- Charlie

> 
> Thanks,
>
> Clément
> 
> > 
> > - Charlie
> > 
> >> +		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
> >> +			return false;
> >> +
> >> +	return true;
> >> +}
> >> +
> >>  #ifdef CONFIG_RISCV_SCALAR_MISALIGNED
> >>  
> >>  static bool unaligned_ctl __read_mostly;
> >> @@ -685,8 +697,6 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
> >>  
> >>  bool __init check_unaligned_access_emulated_all_cpus(void)
> >>  {
> >> -	int cpu;
> >> -
> >>  	/*
> >>  	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
> >>  	 * accesses emulated since tasks requesting such control can run on any
> >> @@ -694,10 +704,8 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
> >>  	 */
> >>  	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
> >>  
> >> -	for_each_online_cpu(cpu)
> >> -		if (per_cpu(misaligned_access_speed, cpu)
> >> -		    != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
> >> -			return false;
> >> +	if (!all_cpus_unaligned_scalar_access_emulated())
> >> +		return false;
> >>  
> >>  	unaligned_ctl = true;
> >>  	return true;
> >> -- 
> >> 2.49.0
> >>
> >>
> >> _______________________________________________
> >> linux-riscv mailing list
> >> linux-riscv@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-riscv
> 

