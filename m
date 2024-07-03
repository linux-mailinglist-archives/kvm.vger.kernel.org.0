Return-Path: <kvm+bounces-20910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F407926937
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 21:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2395C1F22D33
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 19:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB04418F2CC;
	Wed,  3 Jul 2024 19:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="SZSNI2ow"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC01181D18
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 19:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720036757; cv=none; b=QDKQXNj7AVYB9DK4K3sJn5ZmioOcyHZGqgYsMKpHt+ml2PQ1fTOdNBYP612X1JvnG7CQKGo2Yk37BpCb26itjfLdyB8CHd1NdZjwm9RJri/fo+twiAkowzea4R/pZHAaUPWmcuSJ5OWRt6qRohb3c98XQ4vVKWNKWEUZJr0wZAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720036757; c=relaxed/simple;
	bh=1uzZzpE27QyXXXCxReOkYYZjMh1dw9TnfOmdAUrsY0k=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=tZbRU/KW9LIrRj1Gfi6r9DBsftOOXM9nRO/GMzVO5waXiItdrUfQAJkNl25LdHRliUkjDRiqE8bH+QyAvJ1hn1bZOJhY/ik4hHGTxV7VQ/ziCUtJDr/xQKnc87oPHC+SoU0qJc1A1vBnkQoQUX2CQz9jjaersSjAHykcRG2iCFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=SZSNI2ow; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70af48692bcso547653b3a.1
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 12:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1720036755; x=1720641555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=llqZeLMH/2BLbFjCrwTuUEHpE/ViSqc2wj4oZtu1yzA=;
        b=SZSNI2owGM/uwYOQgGk+IM8T6DI7EyPrul7gWiYBROkWbSFwawGf30DJstBULI6Ad5
         HEnK+M3W5FzOMEtbwyVUTmkjQ2FZRXWpbN157yGkv26seuywG87kyx0O8Kw52HdP/Iw3
         DLJlio+iCoItqWX/2sL1bql++FztCmIIlBOdHg6mR69kt89A8fHqblzxRH5pTu9CDswQ
         Ob450B2PCyYVTonT0YpuU6ktujO5aagBhx+d6DuKF6pJNVoilbLwt9x5AxQ5t3MTsJ41
         L6w4ufT2ovZoXxywJf9l6BTs+sol96dERtpYi6hjJJzODl+XkcHZsDBo+Anjgqlr4Yeh
         h0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720036755; x=1720641555;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llqZeLMH/2BLbFjCrwTuUEHpE/ViSqc2wj4oZtu1yzA=;
        b=gY0PvtRe/88EWddnoTs0JL+J/2lbm0S9NECdAF6yfj1GTFsBB8XIxxl/UNxNjqAGJw
         JDw4OmbqdVfHeyDcucgjij/wazFz4VQJBWwazzbGUU9w20vtrc5F7k/faCrpNuVz64Bt
         t0yriRiTNP8joVEKmALpz79NQtgv+qrnErTblP0JvxUEf9o0ViT9a37t7ImvIjCHlD2W
         7TT62OZ9SY1TFK3zbl+wGUrGwhM0+xTvsi+5wgh+yeM/01ZP2m6xq41KoLz1eFlZiDmQ
         KrtTXyquO5bbpkQ6vyOAC8Ff5mHmjp3QA4BQ/R+FyrjEF7vLBGIzO1BKucjju2lzr4ke
         dONQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdoRsONRXII2G/ZbPRf1/RhODFibR0WhYAffv9XlWsJiGTdKuIyaUzSfLVdV58xDD3bWSSl4SVDKHphygcUneRojHQ
X-Gm-Message-State: AOJu0Yw4/NTx0XyMlyRkmMNvim7djjYKQxTePo7cxePNlGPqSNhr9hYw
	g8jlHeKr1rU8ezRYW/3hO9YUUmkYdkKZLl8mRdjY6S8gQD3/d7WXPUftFK/c3J/WS2vfH2Ug+XU
	0
X-Google-Smtp-Source: AGHT+IFI2fOylyhpu9F7a1d+pF4zhchdEwR1QvH0cPmHKjCeEh3crHOa0vuNmj6ebNBPIEQBj9LrSg==
X-Received: by 2002:a05:6a00:218e:b0:706:5f74:b97b with SMTP id d2e1a72fcca58-70aaaf10da2mr11931505b3a.23.1720036754701;
        Wed, 03 Jul 2024 12:59:14 -0700 (PDT)
Received: from localhost ([199.68.152.145])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7080246bc72sm10867658b3a.60.2024.07.03.12.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 12:59:14 -0700 (PDT)
Date: Wed, 03 Jul 2024 12:59:14 -0700 (PDT)
X-Google-Original-Date: Wed, 03 Jul 2024 12:59:09 PDT (-0700)
Subject:     Re: [PATCH v4 0/3] Assorted fixes in RISC-V PMU driver
In-Reply-To: <20240701130127.GA2250@willie-the-truck>
CC: Atish Patra <atishp@rivosinc.com>, linux-riscv@lists.infradead.org,
  kvm-riscv@lists.infradead.org, atishp@atishpatra.org, anup@brainfault.org,
  Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, ajones@ventanamicro.com,
  Conor Dooley <conor.dooley@microchip.com>, samuel.holland@sifive.com, alexghiti@rivosinc.com,
  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, garthlei@pku.edu.cn
From: Palmer Dabbelt <palmer@rivosinc.com>
To: Will Deacon <will@kernel.org>
Message-ID: <mhng-c9cb22ea-9f7c-44c2-8e3c-8bd1de101e16@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 01 Jul 2024 06:01:27 PDT (-0700), Will Deacon wrote:
> On Fri, Jun 28, 2024 at 12:51:40AM -0700, Atish Patra wrote:
>> This series contains 3 fixes out of which the first one is a new fix
>> for invalid event data reported in lkml[2]. The last two are v3 of Samuel's
>> patch[1]. I added the RB/TB/Fixes tag and moved 1 unrelated change
>> to its own patch. I also changed an error message in kvm vcpu_pmu from
>> pr_err to pr_debug to avoid redundant failure error messages generated
>> due to the boot time quering of events implemented in the patch[1]
>
> I'm assuming this series will go via the riscv arch tree, but please
> shout if that's not the case.

Ya, it just ended up dragging on a bit because of a missing DCO.  I'm 
just throwing it at the tester now, it should show up on fixes 
eventually...

