Return-Path: <kvm+bounces-14655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4B98A518E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BEE11F2474F
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908C112BF3A;
	Mon, 15 Apr 2024 13:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="djlGTVLT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650EA78274
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187421; cv=none; b=bGVrt8gmIPEMSfzVITTHPOFqm2OpItKn+rmwas8O3VkkI3BbmWNhq+/5SIi31nxjPsivYFMmMOEv1moPGTJ5dt1EhTcRtfrDDQvthKldKu6Wo7zHmzFtMErOmuQaQBfH2+8Q0Jp4mh1ttQi0egljjPGV2e6u2g18bqbARa4jWXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187421; c=relaxed/simple;
	bh=6QDDaFd9eTHSjGZ+Gq69MqmItflrTqKnpwZ5H6nspls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7Dn4D/hbEmlSzo6/Pfq4wE+mzi/HIUsben+gnTo4fuw7Sx3LkPQ7XBH5tubwx7SwAHpdEHBNxpEuuuZ/aIsq/W67faJimC9AjO0Dz+Qp4/j04VXTSsQOBfSkAOvUyO+Lph7ZTFvgJIaS+O6NTL5MDv7y4pNCEFP9tKTG/L2yQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=djlGTVLT; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a526d0b2349so106969466b.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713187418; x=1713792218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SsPjsW5vGyGQYslNcZfnPrf8zdlh6X3WXkIuouRF3Dg=;
        b=djlGTVLTcajbVDmPo6YNTF2O+xyJkOimFpaRVQ7JuevkkNHFEadaaMCCaHNOsMhaIc
         MtJvD2+8UIpEGNK5EwrYO8VSYN5qAIu0D5b8QCiIdmfJxpI2PS71mI8JX/94vcQwIEVu
         pr34Qh84oOWtpnTBXr4/f9wdhj0DAEJsTvUtcNyc7sk5CltR/Fu+AvEYjOHQZhI/5sDO
         fc2w1Bq5RBdVP97WF9AbAWBmXyNrLGw6tUG43XxqhAbnIV9Hc+q0GHA4WmeX2eQOhvAi
         Nwo3ASmkh4LH9lmL5mFQOjAXlKJuaJBV8KeMFGDcRy9uvJg4qVAgRPAfuUstdrMFlyz4
         0XLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713187418; x=1713792218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsPjsW5vGyGQYslNcZfnPrf8zdlh6X3WXkIuouRF3Dg=;
        b=nj6Q7RB5a1L8rW4WR2zCltSINJAW1Wvs4QAJ3Tv/8/l+tYbTmTu8goj1WQuICWEdXk
         8qJiiXYjIu0naL91lknK2/HamxnymM3yq0XQXs2knXySix7ToLoSBY5jGtLFwapM9Awc
         F6LLDmaZ5pXWpyeBdeEdTh7b9W2NkNlsn/ryX5kpvD4/Oazk9VWJ09+E8iFYjuPiXlXC
         iN8H3mCQX3OfiszV9GPURg+6ONlNuRiwIhiFBcovfPv5RbI3eBRnu5S5Hgs7WG3+QfUo
         FLnq12m3YMpVgvxTYQ2L4mJ2ZF75Qad6OnQIzinBwpkQzuXfCpd2PyUWjLcl8u1mGj5G
         vcRg==
X-Forwarded-Encrypted: i=1; AJvYcCUVEI5qrCA1yYJ0fiSjEHq/aVk1c/4Uf48ljIfEwOA4v52OS/9u0VTH5mjGVlAAQ4Kfstq6A4r94Y898C8AEtr9aavZ
X-Gm-Message-State: AOJu0YygusWlyDsBexVpBjNWDu7ZHI1j77lOOxsfPLxNCGvD4Kbhp5UX
	S14CH1iNtd4daAuMend7hflCAvhxmlJurCMp+FZ/AUSwHAKMymWv2cmH0Z65wVk=
X-Google-Smtp-Source: AGHT+IHklOBQ3iGKHu088UkpOHw/VxcGUKSaeMTX9Gz3utwCjBi1O3+vYBQcukgR3YGBfTGMHvrvUA==
X-Received: by 2002:a17:906:f1c7:b0:a52:fb9:27ad with SMTP id gx7-20020a170906f1c700b00a520fb927admr6011866ejb.48.1713187416663;
        Mon, 15 Apr 2024 06:23:36 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id ji16-20020a170907981000b00a5244a80cfcsm3480965ejc.91.2024.04.15.06.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 06:23:36 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:23:35 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <alexey.amakhalov@broadcom.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	x86@kernel.org
Subject: Re: [PATCH v6 14/24] RISC-V: KVM: Add perf sampling support for
 guests
Message-ID: <20240415-cdc6d5bc6c5145f9d6f54afc@orel>
References: <20240411000752.955910-1-atishp@rivosinc.com>
 <20240411000752.955910-15-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411000752.955910-15-atishp@rivosinc.com>

On Wed, Apr 10, 2024 at 05:07:42PM -0700, Atish Patra wrote:
> KVM enables perf for guest via counter virtualization. However, the
> sampling can not be supported as there is no mechanism to enabled
> trap/emulate scountovf in ISA yet. Rely on the SBI PMU snapshot
> to provide the counter overflow data via the shared memory.
> 
> In case of sampling event, the host first sets the guest's LCOFI
> interrupt and injects to the guest via irq filtering mechanism defined
> in AIA specification. Thus, ssaia must be enabled in the host in order
> to use perf sampling in the guest. No other AIA dependency w.r.t kernel
> is required.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h          |  3 +-
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  3 ++
>  arch/riscv/include/uapi/asm/kvm.h     |  1 +
>  arch/riscv/kvm/aia.c                  |  5 ++
>  arch/riscv/kvm/vcpu.c                 | 15 ++++--
>  arch/riscv/kvm/vcpu_onereg.c          |  6 +++
>  arch/riscv/kvm/vcpu_pmu.c             | 68 +++++++++++++++++++++++++--
>  7 files changed, 93 insertions(+), 8 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

