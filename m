Return-Path: <kvm+bounces-46060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C3EAB123A
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 13:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D50CD3B1A14
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1626828FAA7;
	Fri,  9 May 2025 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jJRn4jiu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABC028ECEE
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 11:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790201; cv=none; b=DgpXBoPjmmE27tXXt06Grb3ioXAzK6R40HuEuZg+ylTG5WopXuk4buv8ma7LsVM86Mm+pE73lYbYXzmgryAI648zfAGWap1wBp41ad3iEl5srKClIhOQ8NkWO5ZA85lPhosXZBnUKPAda2xyaGTQDx7/PX7kdN9+jspjKvCiZ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790201; c=relaxed/simple;
	bh=fzs4MBOvD+LF7kzFPGxEsVFsEfSDbIKVc/1rCNfRN5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MkiRcexLVty5X6iNi8tXjtm663VflFqZdziNQxHBPCF6x59B+zzAhztFDMBkP7wWSB72Bj1zwMIJAnpHcpxdQu5mMwKTM0yNvx7gfsk/8gwfB8hTJ4df9OmqOrt99fxMRsYcP65yPTVxHPpYgyToGtpzHkZjqmwvb4juZ/76+aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jJRn4jiu; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a0b7fbdde7so1780975f8f.2
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 04:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746790198; x=1747394998; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PS161WiIseqQMvNduUZogtk3N3mmBOCWz6m7XRDgGoE=;
        b=jJRn4jiu8D89meBWhVKaKxXTJxO0mIREa4bVYTi307NVfp72tQvcylqqqZX7Ur92Gs
         8xj3aJPEIFkvh3CTfa+b6V/7GYu36VfDkhBfDKA1fy6ea6d/XrI7ouXsKv1bM/03Gkii
         xQ/NP1zpg3f5UXK7H3pnSgOdXm2/SeqjNItf8miX/2StDX5/l4JjWMrcI8Jpja8zwBX/
         kfHUmIxrIT3u6ZeHb7zlyio2At+oWsKpp8Jb/a0aFbD31xbB+ZkaStja9Yed0ygEmKGf
         gBMqI3x9i9FvPk4Mp7q4IxygRetqy0Mb3zrbBKA2gm3oLEX6jXmQG3CMMMKoVwIHqmj5
         bIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746790198; x=1747394998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PS161WiIseqQMvNduUZogtk3N3mmBOCWz6m7XRDgGoE=;
        b=pjpXUFyz2aSw92aNuu0lAWuiJ0HTLyGxzJwNhT8PH+DyfugH3WGIR7uNEdvy5c5ppM
         LFmCGpLg+Orp4oHgDAXRpH1xtDCnzgmdGdwPttgayLxAQsuRMdc0rNnEHRoX74SGAQPl
         p298vYajxUiQ4EJR9io2lCirTOIL3z+i8ADjd8PpWDV0us2aqSQVv+E+xGxNoW08P8Bx
         gUdRcqiZ7uEhFX4tv2CvMR4tpnHmP/vhR/t7T0WaZj2B9wRP+P0s2ln4j74/XmlM1YdZ
         cTN4smOK8/ihOQ4iEeOT6RgwQhC31oa0Zl7SLM8g0P6iYYXoJy74VNGkYfFKcR5sbR+Z
         2nXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1PUsWjAIxDi1Ml/D1oAd476Mdzk59jI9nAroDh6ngREuO+BOXJB3nHQFMTzUIeEaJeW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZC8YRCgoIm/jiFBjUM97YnNEE22iU1eQ7Vk1uacm1R8hxMR7d
	xRTbLGg+VEnphMFtPj9Z2FxniZzVlqt1ByB2in9ksrZRa/IY80fN/CtZvJJOEbo=
X-Gm-Gg: ASbGncssxbl/oBZnVMBWwwkiO6OKEF1TYxue3xo0UMfG/37fK9qlt/+s8YXmOOHM1OW
	z416OrA8luSos9xFr07cew1kfCyjR36tqVDFTYjw2qiCtNxbAr0XACFpRRfipRuvsfJ8lR1HmfJ
	dVgfiXcK2lb0t3Ig3qj8utWUxo5CFKyKITp0VtNq/y1HsAznGmVs4KtKi2I5WnwrnXNHdGVK++/
	gx5V04t0ZcolFXuxCtY9qqOmiRNAsZS7S53wW0SFEgfpEmRGvi8CKd+/Y3+j8GLSXhe0hKN5QTo
	Rg6SQSYygb/oPMHDPZMdXRorpDPF
X-Google-Smtp-Source: AGHT+IFyD+sjIl6oyk+GUqpe3q06X8ef9h4zpi/ejp13lhZHBDbgLcyRC1n+m1ZiSGeYARfIOQsk7g==
X-Received: by 2002:adf:e78b:0:b0:3a1:f70c:19bc with SMTP id ffacd0b85a97d-3a1f70c19d8mr1667927f8f.48.1746790197611;
        Fri, 09 May 2025 04:29:57 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::ce80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2d2c8sm2977553f8f.61.2025.05.09.04.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:29:57 -0700 (PDT)
Date: Fri, 9 May 2025 13:29:56 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 2/3] riscv: Strengthen duplicate and inconsistent
 definition of RV_X()
Message-ID: <20250509-1b7cbe3ce1c23a20c571d3c6@orel>
References: <20250508125202.108613-1-alexghiti@rivosinc.com>
 <20250508125202.108613-3-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508125202.108613-3-alexghiti@rivosinc.com>

On Thu, May 08, 2025 at 02:52:01PM +0200, Alexandre Ghiti wrote:
> RV_X() macro is defined in two different ways which is error prone.
> 
> So harmonize its first definition and add another macro RV_X_mask() for
> the second one.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h        | 39 ++++++++++++++--------------
>  arch/riscv/kernel/elf_kexec.c        |  2 +-
>  arch/riscv/kernel/traps_misaligned.c |  2 +-
>  arch/riscv/kvm/vcpu_insn.c           |  2 +-
>  4 files changed, 23 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

