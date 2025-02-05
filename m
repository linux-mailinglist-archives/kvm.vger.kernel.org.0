Return-Path: <kvm+bounces-37287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AB4A2816A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 02:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CBC71889CF1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 01:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1332A22ACE4;
	Wed,  5 Feb 2025 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="L74/NA5T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A3122ACC5
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 01:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738719669; cv=none; b=uHG10XuLxrDdMWaOBfHpv1WrNe7IxFSrNVWk16pFPxDe2NdPSc+963c4Obp4l4XMPpDwKG/q+DDuRExji/gAk0aYn/vDNDqyeWA+/FJCYHedpHIhZ9/VyaM2CIo6062X8tyvkqfLp7qKPsIlz57fJ98tJ/5rjIh0yRq5R5d2vI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738719669; c=relaxed/simple;
	bh=JWnqsodjZ2L8uxleKmtmbchS/3DiFCoQOCVuhOQEYZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jvajEbuyvMRLVJYh9a6wnVi1V1q+UemdGh7p6otSZjktiPzsQQmHCsiNDiZLx10ZMg79H2FojTRSUBMsvOk/UarEv68aH8BjQ1n/kxbP64MDs0GNeixqiBcpV+IHMHwIxtTTDQ1NdXmnGISivcI38xaVEHMJgyau8YvO734GdCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b=L74/NA5T; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaf57c2e0beso1260822266b.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 17:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1738719664; x=1739324464; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nrPaxDBqK+jlat9vKvVguxt+VB4t86Q162K5AZAC3vA=;
        b=L74/NA5Tw0PqVIors3Csf/bDGTq0UaFUc5dizBfxbUbxH1eyMywM/GBk2ULDjvMdCo
         eiqKrLloFImZ3xb92xCd4KOzfYAqDeLyd2hVpo/tHCMN5hZ2xmML5fRWV7rQDmMhq7Tx
         figRd7Qn5cbvojNOm7xHFKS8RWYWmymTSUWP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738719664; x=1739324464;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nrPaxDBqK+jlat9vKvVguxt+VB4t86Q162K5AZAC3vA=;
        b=B/0KjBH2X8DAKZRbl2zF+OXswPoqumoVL3T6PDMq5rnuSG0MfUm8EO4b1RRIeMooKW
         Ht7uJqD25vsuhXj/3/LD8lIbz80MGSDA/uZYMtBh2h0AyK+MEkaFPRZ8+zkKnTDNFdvo
         0ny3jFipl5joTv9yHEl7mtvN4RkIB82ki+k51l2QQdyQqRm8ee8IC4u8fBNXoAqGDzd1
         TfoYggLqIkn+keMD2U7EStB8hxK92QNSpZTi0CdlMh3w5DNa8Fw5uFBkwlFiM88KGyl9
         BdMnN1cf/YRt8FXztYflzwNhjWWraZfeOCtaDwWHCFNIxmAvSbKjhlMFihmLfyv5EXUU
         bqGA==
X-Forwarded-Encrypted: i=1; AJvYcCVj8BEIyXdfh1xyVOTzYHFD8hnqLGAEQSjKRrdERD3fXQ0iNnGATZI3hXKkn/maJB18eos=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs72YXI1I8AeU62Vtnoc26g72HXETJthNF5QM+yQn8Uq6edVV1
	4jreRJYzCvZUp0y/GiSL4Ixbo0BFvX05hzs32i9XQ1/Aqsnbw8/TvkdD28gQUUkmllKNGu3kkk1
	4p/4RSI/uMuLHIwwk2uOxlXDDgxWi9RNQ
X-Gm-Gg: ASbGnctON6ON/7LHntW7FD0a4BjOr872nkEgiK+f6Mz/MT17djMGMlZFRNBQH5Ws2r7
	Dz0z6rnjKMniHCiJwhx1FwHkV9vtSDQviPuPCiVppIioQbKDhvGs6hcb/kaCpZzgaQyXeORyX
X-Google-Smtp-Source: AGHT+IF/FyfxZCPPCSLeFwOJKpFzgl8LW9G9778Di+L4CETKN1wAS79IR6OuXqxl/xS8h/BezssIMSXEiLzN8XP9uEU=
X-Received: by 2002:a17:907:a089:b0:aa6:9624:78f1 with SMTP id
 a640c23a62f3a-ab75e21433bmr66927466b.9.1738719664105; Tue, 04 Feb 2025
 17:41:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241129045926.2961198-1-cyrilbur@tenstorrent.com>
In-Reply-To: <20241129045926.2961198-1-cyrilbur@tenstorrent.com>
From: Joel Stanley <joel@jms.id.au>
Date: Wed, 5 Feb 2025 12:10:52 +1030
X-Gm-Features: AWEUYZlnkeEWpMJllG-kbFiqQxC_DD8CG6s1gC-tGRiAU1sCh05u-vUhKhzSVyw
Message-ID: <CACPK8Xehfy_12FmCd6fVcr5_-cpe2g-ADa9cwR+AjgDLJNuqTw@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2] riscv: Use the count parameter of term_putc in SBI_EXT_DBCN_CONSOLE_WRITE
To: Cyril Bur <cyrilbur@tenstorrent.com>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 15:29, Cyril Bur <cyrilbur@tenstorrent.com> wrote:
> --- a/riscv/kvm-cpu.c
> +++ b/riscv/kvm-cpu.c
> @@ -178,15 +178,16 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
>                                 break;
>                         }
>                         vcpu->kvm_run->riscv_sbi.ret[1] = 0;
> -                       while (str_start <= str_end) {
> -                               if (vcpu->kvm_run->riscv_sbi.function_id ==
> -                                   SBI_EXT_DBCN_CONSOLE_WRITE) {
> -                                       term_putc(str_start, 1, 0);
> -                               } else {
> -                                       if (!term_readable(0))
> -                                               break;
> -                                       *str_start = term_getc(vcpu->kvm, 0);
> -                               }
> +                       if (vcpu->kvm_run->riscv_sbi.function_id ==
> +                           SBI_EXT_DBCN_CONSOLE_WRITE) {
> +                               int length = (str_end - str_start) + 1;

Much more readable than v1!

You could add a check that str_end > str_start where the if
(!str_start || !str_end) test is to avoid shenanigans.

> +
> +                               term_putc(str_start, length, 0);
> +                               vcpu->kvm_run->riscv_sbi.ret[1] += length;

term_putc returns the actual length written, should you be putting
that in ret[1] instead?

> +                               break;
> +                       }
> +                       while (str_start <= str_end && term_readable(0)) {

Previously this would have only happened for function_id ==
SBI_EXT_DBCN_CONSOLE_READ. Should you add an else?

> +                               *str_start = term_getc(vcpu->kvm, 0);
>                                 vcpu->kvm_run->riscv_sbi.ret[1]++;
>                                 str_start++;
>                         }
> --
> 2.34.1
>

