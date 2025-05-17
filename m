Return-Path: <kvm+bounces-46935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 596FAABAABE
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 16:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D168E17EF02
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 14:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88671205502;
	Sat, 17 May 2025 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kb800Q2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA061E519;
	Sat, 17 May 2025 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747492564; cv=none; b=fP8KQSpIu9xo/AesJ2OW7J91C1wo8JsZxKiTcjV+EU1AaOwO1ufW0BeE3F7tK0NgHapD7gdcvH7aR5w+ZAowQtHS369ztape4hmO2B33IB0wyaMgmZiolViT+gNF/BbnpINB0PdYa2L0RNGKEppUFHGsxAmtHG7y4w9WlJLzXaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747492564; c=relaxed/simple;
	bh=XOsoPsNgyfKufNpivyOqQwfxwucR+v1GRX7ZO/Q4iOM=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=hLSDpePEMOIzO10a172dbWnqj89axXMUmmqJRoHFGNWHE+zSQR5kUGjw6dSDrfbqADNf9XZwIaknsVb1v48VPsSxoQ3SC+IyCSroTdYHqfWS2UxwCxafCfR2bJCjgrERrfes8YG+zkymmWpNBUnnC/hqXf6w7sYbJ6NMcmgzIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kb800Q2D; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-30e93977f7cso1246878a91.3;
        Sat, 17 May 2025 07:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747492561; x=1748097361; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qV/jfxSoj61KWz/2Bb//Agtf7zox03qaPOCEAGdJVD8=;
        b=kb800Q2D1vnivaYw33WKzwjA8j4FXwafyWEiZDpAu3MOVOFFtdTQEUexhbZjM4ZiWe
         ifWcR6WsTuFDQx71DgTobsRZ2iYaNrxq/9erhT6wA1kEWU9jQ6oNxblpLh0lpvn63glR
         fv8CxVSOEjR+68pfAQUsOVvaS83Y/Hi82RIofuv4hx7UDIsQKwI9/z02YT7v/7p2CWFH
         ySHUGBdG9DkVpBQa6ckyjo45n//efW65RWbsUcn33UO0G3oLtW+TjLhNi/J3WHwhCYgv
         lV1jcggXy6OKYgdxB8piieIe1FQkVaBkvNzD8gZ+eSxzqMcGdelGM09oubM/8TIWkOVK
         E2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747492561; x=1748097361;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qV/jfxSoj61KWz/2Bb//Agtf7zox03qaPOCEAGdJVD8=;
        b=u1/4f60aj+QjAG+c+tXJP1vHE9zytjHCWgNECp4ccCYmuLI964SJFK2cIbad5/9fak
         ZSN67wPlmO6iarjAjvNDtAp2I0aVTiVNaaJUaIObmz3tLPov9KimgrjcudbSjpx/H/lo
         Kh59IgccKkBppWoANMVOwLZuszKuj6VW8MbmYsMtplzTm535Ra4KI1UhOaPqUsJ6fC0V
         WXFTH077x6rufoJiM6dv6vXngdmc2uIhMPSTV25c0uQcyFGVN47yRSUQ5X7GsFVCA6PO
         Ku/mtTihj+hgs7Dqxcx9EaSRB/iFhc2JgKCsPlVbEYBMlKFEEtT986DfcBkLhMpPB0Dy
         UJfg==
X-Forwarded-Encrypted: i=1; AJvYcCU1/au0L4f0C1uJovt9pRL9Irxy0fYWy87lMxJwF1Am5IgUxTw5fdHr3EtWBB/TpGuKUybfTK+3q4koe7n8@vger.kernel.org, AJvYcCVvlmmtpNjzMXC1fbUcNrouSYSDv73q70eUV7WjiIPPsjpaXi/hF75cSmOr6xfGgpzT2r0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaYyhf5u28HpmvgJu1kPwtGDTtCiYXBodlEvrNWaY/XWGAqLLQ
	uv4X35hbAzh3N1vgLmUZkTh/CbhMmvBrdL+Bts95k0sm9h+PDgThi1WEAr668w==
X-Gm-Gg: ASbGnct5eroDp77KFVliaL23X8cNIXF9wkzhKvKA/K+xcRLiKD/MUvhhH5y5aNbjP9A
	c0kXfROBaCf4LA/JvM8KnLyE+LsnnMcVlUUnkqgEvImzGX4XBGw2c0Eiu3RSL2HtLv0vZtUSQbx
	DTrcVtwCVoHwe9BGIZni2WprdFWRBfm4nMpeXGhr1botA0LfEtpRaEDlHinphimXnMwRkiCBouo
	CXtLU2w4Cj1viuQ6H/p3Nxv5LYWA0vU6YpePn12LZhzXGQY7DJ1exqjW/EgJpUma7t0pcab1vbI
	OY7eZQqfD4Pk66kboeWB8GujbncYqQZfAyxNiMHNMrk=
X-Google-Smtp-Source: AGHT+IFCb3hB4IltQOOTVX3h/Zp2WTvE+WkzHlCHvIBE65lixQQsd15bRFp9QEaVX6UHRy84bFqrNw==
X-Received: by 2002:a17:90b:4b0f:b0:2ee:c291:765a with SMTP id 98e67ed59e1d1-30e7d51ee10mr10484441a91.8.1747492561597;
        Sat, 17 May 2025 07:36:01 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e7d4aa8a5sm3403372a91.26.2025.05.17.07.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 07:36:00 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Gautam Menghani <gautam@linux.ibm.com>, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, christophe.leroy@csgroup.eu
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Add H_VIRT mapping for tracing exits
In-Reply-To: <20250516121225.276466-1-gautam@linux.ibm.com>
Date: Sat, 17 May 2025 19:33:42 +0530
Message-ID: <87a57bwczl.fsf@gmail.com>
References: <20250516121225.276466-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Gautam Menghani <gautam@linux.ibm.com> writes:

> The macro kvm_trace_symbol_exit is used for providing the mappings
> for the trap vectors and their names. Add mapping for H_VIRT so that
> trap reason is displayed as string instead of a vector number when using
> the kvm_guest_exit tracepoint.
>

trace_kvm_guest_exit(vcpu) gets called on kvm exit and vcpu->arch.trap
carries the trap value whose values are defined in
arch/powerpc/include/asm/kvm_asm.h

i.e.
#define BOOK3S_INTERRUPT_H_VIRT		0xea0

kvm_trace_symbol_exit provides these mappings for book3s HV & PR.
The change looks good to me. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>  arch/powerpc/kvm/trace_book3s.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/powerpc/kvm/trace_book3s.h b/arch/powerpc/kvm/trace_book3s.h
> index 372a82fa2de3..9260ddbd557f 100644
> --- a/arch/powerpc/kvm/trace_book3s.h
> +++ b/arch/powerpc/kvm/trace_book3s.h
> @@ -25,6 +25,7 @@
>  	{0xe00, "H_DATA_STORAGE"}, \
>  	{0xe20, "H_INST_STORAGE"}, \
>  	{0xe40, "H_EMUL_ASSIST"}, \
> +	{0xea0, "H_VIRT"}, \
>  	{0xf00, "PERFMON"}, \
>  	{0xf20, "ALTIVEC"}, \
>  	{0xf40, "VSX"}
> --
> 2.49.0

