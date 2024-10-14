Return-Path: <kvm+bounces-28788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD7399D4AA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C69BAB23574
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3902C1B85E1;
	Mon, 14 Oct 2024 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bAC6XqKD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CF32595
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728923440; cv=none; b=GrgBEEvG3vsw4lP4ocaF7Eblz0xlnU0zJ16Ty/Xv+z/sTkoBvjXO5nWxreEwkPErrX/mv+rbywXH7KF/uMLhS1lZxLuCZ/ZdT/wEn4Y2Wf9Nw8JCrbU8SAoQiR8PpC2oDanLY6mfciDhEN6aawVwvMIm2L/H6blwCksCI9eX9cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728923440; c=relaxed/simple;
	bh=R5twWvuBxbSkKjU5DxaFHvgCxegsEVFhiDX6NRt1pEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n9IVSSAJUxT9oV00mBfsBsPjAv5r+UTKIXZCJrjpP3LSypcQY9tFKzjQJSpgSq3Sy7OxpsrVu5g0jZWf2DLy8vZSDmijGiRCVdX9WtncbrhRNvKzW8Ga5tcxiBN5glH9P+5Tg7pMPhVEuq0jZTwIeWxQmGbHkAVUVX7JKarjiY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bAC6XqKD; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539f72c913aso1292314e87.1
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 09:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728923437; x=1729528237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4LSjq+Z4kPIuZ7MZOow4TSRNQJNrfrecbRyxEk3/mM=;
        b=bAC6XqKDUoqT2oxzdDyzzdWmULAFD3jhLp7E0M1zkjw3MTW4NOMNXJlogkGBvoKHII
         X0GkO2dhJ5pQSnY6LMNE2T04ZzD7oYNRUKYdPmNTWcNp/Ml3CLxFmmBeYzF4MqElqHOY
         xaon3BTnW1Oivf8HVCQsTawhOOLWKRktpeuaYBUHAX+8infULfon0JZGBDyLP5vUHHj/
         kY2ijEF++alIk5Mtn6rvQBA94DI4IhVMS3y6YkqWwUJslHBoWbndx/rR+q+pomYWmF7f
         WARdnq6NEnCQ+LQ88ZeMqGZZQlUNNBivkL0zc0fkJFNyDR6mdzmvdzI2UzzwI+QtGT3B
         yvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728923437; x=1729528237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4LSjq+Z4kPIuZ7MZOow4TSRNQJNrfrecbRyxEk3/mM=;
        b=tWK3/wUsOfhQzq68Htwt8uixTiM3v0V9grxhrVbqkB5P3T7x93g75z8NgzY58WsJeu
         IMJowz6VQMfxR0yXYVpzL5o8mgrVjsOekxQd3foAqPusEUwLcN0TWzft4LlUdzjX4PUz
         hwrinOirPYGpteSxaU99GqDbELK3q2N7pz0Y4/1eBTZIOLEoQNtWsQgjrp1XdpOLu9dx
         PUbaiHCtV6NJAjAj9u76GjY3ISWTem1xiB/HZpEGv5SyUI1qJP2JjHzv+9s4KrSCZHTI
         sc89w+b0qwqV1ifJ4xiz05PynQ091v8coSDHhZQ5XtI8/YaRR13//WhOB7kFyWfA1Nql
         0xaQ==
X-Forwarded-Encrypted: i=1; AJvYcCU49Xr56Xn4AvvDaE6Cc1nPMhDgNe8lV5CgwQqDcOcQe3yoMA8S8eU0f48idez0q9yUDhI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz352jequ1sTQJBVv4/mco9aJtl8jrVhinA2j7t/r/f7zzm9bZ6
	GPLDnuTkG2oN1kABkf9CSXFd7vbt7XvmXkxbg28D07DIv/wAvFwWeUEP3j/avzoOwTajmhWihn+
	CHUEpf2V/J357VNaO1ljnepyTg4E7SoQWhN1UTAl62J1xYBftUEGIPw==
X-Google-Smtp-Source: AGHT+IGDcb7i+efuqaoT42RCooJWDtJPMo4pp2k54ABh1Gftx/fwHm6hFiF9DGtK36yDqfrvTD+V0mz/1ETuA2kMEUs=
X-Received: by 2002:a05:6512:3a8d:b0:52e:7542:f469 with SMTP id
 2adb3069b0e04-539da22cdf6mr5784547e87.0.1728923436071; Mon, 14 Oct 2024
 09:30:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241005080024.11927-1-apatel@ventanamicro.com>
In-Reply-To: <20241005080024.11927-1-apatel@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 14 Oct 2024 22:00:25 +0530
Message-ID: <CAK9=C2VMcaoi4b1Yn8pDFP_1pt6-2DEZCMCra5UmcxPdBx+yjQ@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 0/8] Add RISC-V ISA extensions based on Linux-6.11
To: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Sat, Oct 5, 2024 at 1:30=E2=80=AFPM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> This series adds support for new ISA extensions based on Linux-6.11
> namely: Zawrs, Zca, Zcb, Zcd, Zcf, Zcmop, and Zimop.
>
> These patches can also be found in the riscv_more_exts_round4_v2 branch
> at: https://github.com/avpatel/kvmtool.git
>
> Changes since v1:
> - Updated PATCH1 to sync-up header with released Linux-6.11 kernel
>
> Anup Patel (8):
>   Sync-up headers with Linux-6.11 kernel
>   riscv: Add Zawrs extension support
>   riscv: Add Zca extension support
>   riscv: Add Zcb extension support
>   riscv: Add Zcd extension support
>   riscv: Add Zcf extension support
>   riscv: Add Zcmop extension support
>   riscv: Add Zimop extension support
>
>  include/linux/kvm.h                 | 27 +++++++++++++++-
>  powerpc/include/asm/kvm.h           |  3 ++
>  riscv/fdt.c                         |  7 +++++
>  riscv/include/asm/kvm.h             |  7 +++++
>  riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++
>  x86/include/asm/kvm.h               | 49 +++++++++++++++++++++++++++++
>  6 files changed, 113 insertions(+), 1 deletion(-)

Friendly ping ?

Regards,
Anup

