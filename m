Return-Path: <kvm+bounces-47589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 044C4AC240F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 15:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BED55454F4
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888B6292923;
	Fri, 23 May 2025 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZK7h21AF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085DA29291E
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 13:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748007097; cv=none; b=sFYNbxOgf2RS/G63dNwch0M5jvTOB7+QGx5wfXq7qBVbqRN8c8e/2avYNOeoxwurTkZVMwPDyL74CTLi3GbNsZ3UH78GyMI3f1a7JWZjkjCEkz2FcNylVkGlHU1fTMrYqVsRxhUHcFYc3mAj88zFUI61epCzDja/zGgxQEtO/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748007097; c=relaxed/simple;
	bh=sE7NSB29qsmfs0sI4wgf6B6ZQGe4IKQtX92E6yxep1o=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=PC4ND8w08i7XO1GBm4DHWydUHXsoSkFiiBx44uEJbUH/D8iJmRwDmeaHySArYy6FrS0rvkWq7Vyr97+ue2wvJGxL9ec5Pet4tpesHvVYp50G46XH/IbxYGElkua7buO44gGsPhSRvQh8lk2iu36E4OMgBGWiqUmGpMdT/6adiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZK7h21AF; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a368259589so1005436f8f.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 06:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748007094; x=1748611894; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sE7NSB29qsmfs0sI4wgf6B6ZQGe4IKQtX92E6yxep1o=;
        b=ZK7h21AFzO78aJkYSkcthA2284pP35VOKEzL669JZMfZVh40cPSxwUqJhG5ck1/pYK
         QAOcm25tG82u/QQJn6TVErx1VF5wGzJELP3jhgbBK3BpqwavTWdATz9HZK+vsnbhfD5X
         NJkooyefkoA626z+ANYuH7WRO3uWWUNIjZVrCbvrvO57IMd25yzB8oElvUCqaeWqrE0Z
         sanPDBaP781coJeu2sQqWBHvP+qtl3cgfjnxWWU7mvHu6CaShC0571ZbtYdp74Clu8BN
         7/ZaJnjjJOFTxMMzy9v13Uv3YdQI9syuTOyh1+nUqbiBjhJsLBruTMHGkS3ewVSPQLwu
         QN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748007094; x=1748611894;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sE7NSB29qsmfs0sI4wgf6B6ZQGe4IKQtX92E6yxep1o=;
        b=GaCpJ7/iyvJy8Mwp3BU+MSEaYsXJUiflnm74IwMBkG4J/2vhBW1H3n8az03uHwIGvV
         350Jf6bIS3s5dZ5MfEoKWSr8J0pr+PvO+Twqrbxj5elQhFAXAAv/80wY3h9w3kLXRgiP
         XZ8W8rxBP7SUozGCJdWpgcftgBhD7rVsDs8qoXhmGNqyHmpglRC5mQLd4Y34bc3Ws84+
         sjakZC63AVJSN235LIS4ooJ1oNp8QPmRfBh4McFE91MuxTmdpBx0A4zs75ZNgi8ya28r
         1gb6Y1lnWCexsZ8uFH3uI+T2X9N7rYVp2ySj3q9XiOfvEpUd5X8D7dgOSoKD41kBd7SU
         +ayQ==
X-Forwarded-Encrypted: i=1; AJvYcCX77jVy0nLgAfX7l3Vb92CV6PmsIpBMv0h8Vv+O4FP8ngW3GbzTrY42Wxdete+lpC0RsG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCG+KAaBb9CzP93MGA9SB9y6uszh5KZxyJHQiwQxRp55qHQL1V
	W6Zr6NqN627nze3Xg+azv9cR/7s2J1kzAEh7HjyH6wfDY/+R0EZvNfBcRc8dzcOeMnI=
X-Gm-Gg: ASbGncutTH/y+utm4eZlPUGg40V+EA6/9ta2kI64PKTKW5EEnSMikuzGSPmKL6rdwck
	lurbyAsOEhDNJ2hmb0O/gaG1ETT2d/++QsjDxi9LTQQRtkgB3SyYOvRCDaVTtSGAo6bH+dlc/Kl
	GmBhhTBkzwoydAfohx8ZLxYzcjc74okSC1WpkBV+3tIGUz9zn3ghe1Xhzh+JREqR2arAam95t7o
	jS2wcFegbsjnQ/Is8BVA2eBtumJ/PeGjOHGdOTs/B5PpvCSrHObcneQf8y9fvFKcFIIbz1HzpeJ
	ljWIotW5SWzYaljShe5qJAZWIMYTpLjLPqZL0FxY3ZWzTfgsLeTpmsHTiTg=
X-Google-Smtp-Source: AGHT+IH4B5YjATsLpzFQConVuBPC8YzXe6dS/7DO0gd92eFJugpX4BslSSwZcD/zqo2WMw5EUo7NzA==
X-Received: by 2002:a05:6000:400f:b0:39c:1401:6ede with SMTP id ffacd0b85a97d-3a4c2b3a659mr992493f8f.3.1748007094151;
        Fri, 23 May 2025 06:31:34 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:be84:d9ad:e5e6:f60b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca8d005sm27248141f8f.90.2025.05.23.06.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 06:31:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 May 2025 15:31:32 +0200
Message-Id: <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version
 to 3.0
Cc: <linux-riscv@lists.infradead.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "Palmer Dabbelt" <palmer@rivosinc.com>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atishp@rivosinc.com>, "Anup Patel" <anup@brainfault.org>,
 "Will Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
 "Paul Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Mayuresh Chitale" <mchitale@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>

2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
> Upgrade the SBI version to v3.0 so that corresponding features
> can be enabled in the guest.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> -#define KVM_SBI_VERSION_MAJOR 2
> +#define KVM_SBI_VERSION_MAJOR 3

I think it's time to add versioning to KVM SBI implementation.
Userspace should be able to select the desired SBI version and KVM would
tell the guest that newer features are not supported.

We could somewhat get away with the userspace_sbi patch I posted,
because userspace would at least be in control of the SBI version, but
it would still be incorrect without a KVM enforcement, because a
misbehaving guest could use features that should not be supported.

