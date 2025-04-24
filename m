Return-Path: <kvm+bounces-44103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8700A9A6B7
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15C88927405
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009F52147F5;
	Thu, 24 Apr 2025 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="n6DmAHWV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BAF20D51E
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745484351; cv=none; b=CmQltjYMFrRKjw0v7aGXyNhjM31NJt7jefxUoyZCB1Vxd2CKJ6HtgNV262TtHvqp6hjn7WDKfJcN2j3ZNg1puDxtKEnRSn5YTz+w7pLHebnUoVa2ZKZJKYMcDwPPFBJjjSUidcYh20efgbuXm/EJfZWa0UlCs4sv09Mmi95WnL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745484351; c=relaxed/simple;
	bh=3ztsM8qbbkFemqNafDPhupNpXzWGGUyIKfomTM+y6cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgJfyK2RzPkJ8NQ3Mgi2oSbTxNzYOZLCKeHhJRrfPucCy6gX1DZAS2ZpKkrhW75NG31/JHL182mLeFY24AJpdQ2buoFG+G/N5koXygQt5MOmBEbElQie0IYIpE60HtfA56FS2Tj9ddoXQV60Uneh5kWjQ3LoiXpzanhDJ8sedj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=n6DmAHWV; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39c1efc457bso483387f8f.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 01:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745484348; x=1746089148; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cpfniZwlegMvSvblIXZcmgKGzHhGwzkwQ2fo2qopaps=;
        b=n6DmAHWVU+sarZLPyZDn18L6HTCYbqsYsMDdWUM1X+Vu4gS5c4ejyQPhCuzK5q8lR+
         ULQj7ErlXDNvarWN/32PUGn/a/XCggcEbvSDz15Iz7q4AxQ1RZik8ITK5GwF+HPGn9w5
         o+3nWADk73IKPNW6+i102UeFzw41PCbGVIi0GUViLq3R8avPiB7A9aKPc77awINNGawz
         fjtmmALJ4TpYH7HqffN2ohKnEgpPG11iLBWUZ1Uj3tgbVZHKxYJ2Qv4KgoRidvqpPPEH
         YkppobmsKy75l3tddp4WRK0Ugb1X/XwUUkX5wlPI2C9tEa4v2VKrl75yJzkv7Giq9Dlo
         3DKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745484348; x=1746089148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpfniZwlegMvSvblIXZcmgKGzHhGwzkwQ2fo2qopaps=;
        b=bQ9tvx9EdLuPsJ2ZQBapL+C31qwanFsuDO836p/7KIWYSy4rFX5TCRe7rVBATDvFaZ
         Pc9ofIeaWBLsSCI5kwQLibKu0Y7N1hXBNsPwV+F0J+uqLJQsgq6AEM7/o3fKgxBv7CPk
         4k7QQjvbZh//Q6EiPTSXtR0DV9QBReew6D91qehuGbcZKdzd9viuytRELKrx+EIoMPL7
         IV/fUtM868LXTexs/vq56FtfzR77dcIwR+E/PoEHjnHLBUnssxVl+i9yuEidaY6tmReD
         ENbIY9rOioYg/2BsnwT4qoDsLkiklgBfUQLxc3jSUPHuyqiTokZYUMo6gTq8GRacF2Fu
         eRtg==
X-Forwarded-Encrypted: i=1; AJvYcCVv/wv5NndCUXy+Ajrpv3sVwaSQAUBmy4VSEiq+3EUYdZMfNfLNAvzrO7xvK9nUZ2jifck=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhIOJ/wo/QMFTw1/bOKCEi1K3b4sxXrgZrMNm+UjkPBpDyP1wz
	bUSAl2DqGxw5SiDZdwRVjjWGwTuchNTPID/hMud1Syz2m7CK3pqxoQL66w/LYUU=
X-Gm-Gg: ASbGncs2P/Gle1VR3f2s6JxZXXaWVJE02ysTeqgG5/2vVPtUJnAP3j2g9/hF/fY4IoW
	JlU7hmFaYNeo/caGnNvl3mRJ0o+vk/XvGTwbPM8dm+GWFX2tq/q61dT/DziJoxFmOuCgdMz9RC9
	k8vtry4HNyaDySCH7AIpZiZ/NfQF18kaWwhYvSwBth4IQa8BCu7RjkfZJw0VG5LP4XXR//ZpUcc
	AmlJNaQ8hQZtGGbzSTz/41Vbd2/MhNbeW2NQp3Vu0b9WS5B+l/WBHMfCiKJGapUvOGYBxpUU9e6
	hhBl/oWayFqZ3ttQkmayf9uKopal
X-Google-Smtp-Source: AGHT+IHa85PG4qEjs29oVTV0lIFZzwktXz39JAxGkANuBNfdNGLagzd4Kpk6GR7N5o12prPoNooS8w==
X-Received: by 2002:a5d:47ab:0:b0:39c:1257:c96f with SMTP id ffacd0b85a97d-3a06cfab9bdmr1392834f8f.59.1745484347709;
        Thu, 24 Apr 2025 01:45:47 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a80bbsm1362860f8f.11.2025.04.24.01.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 01:45:47 -0700 (PDT)
Date: Thu, 24 Apr 2025 10:45:46 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 2/3] riscv: Strengthen duplicate and inconsistent
 definition of RV_X()
Message-ID: <20250424-f322adab22126ae97dd7c5b4@orel>
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-3-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422082545.450453-3-alexghiti@rivosinc.com>

On Tue, Apr 22, 2025 at 10:25:44AM +0200, Alexandre Ghiti wrote:
> RV_X() macro is defined in two different ways which is error prone.
> 
> So harmonize its first definition and add another macro RV_X_mask() for
> the second one.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h        | 39 ++++++++++++++--------------
>  arch/riscv/kernel/elf_kexec.c        |  1 -
>  arch/riscv/kernel/traps_misaligned.c |  1 -
>  arch/riscv/kvm/vcpu_insn.c           |  1 -
>  4 files changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index 2a589a58b291..4063ca35be9b 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -288,43 +288,44 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  
>  #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
>  #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
> -#define RV_X(X, s, mask)  (((X) >> (s)) & (mask))
> -#define RVC_X(X, s, mask) RV_X(X, s, mask)
> +#define RV_X(X, s, n) (((X) >> (s)) & ((1 << (n)) - 1))

Assuming n is arbitrary then we should be using BIT_ULL.

Thanks,
drew

