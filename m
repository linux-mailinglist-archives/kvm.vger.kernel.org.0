Return-Path: <kvm+bounces-27081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BBC97BD75
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CAA8287729
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 13:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88EE18C35E;
	Wed, 18 Sep 2024 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oHrFwWXg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E56D18C034
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667823; cv=none; b=YAtEWmc4dw2D7/Lj5FgohG7IANOLH7w71jOTwOTsT6Mre4wlZrUBkAkjQ4x2lY4V/hjje0t3R1HQZSYE/40pv/sIXu2dC3auHUzqRqnNYkVYRWAMClgDf5V2AVV12Sb4ZdLRIkzT90cg1dNwUD8LWHHZe4GzABx+ACGwe78PixI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667823; c=relaxed/simple;
	bh=h4G16277CUKZO25r98W1SYGS+5fOC+uxsWecCkOGJu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1h+kZVaZsV+5u6R4Xx52tEkaEW7oCScZiZ02m2xLA7fGUWDq9xhNPYTcpVTwcIZRra21dlSOpm8NGFrOnxdGYDjm3DuUVAyJBZF4+m7+8jjg4SiQiOu60/cI+/QuSDr0X2WXrmGV64nqSHGTiv3O5T3o/+jROBzvOvmSOO2FVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oHrFwWXg; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d2daa2262so714061666b.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 06:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726667820; x=1727272620; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jw9R7zHcU6wAlHrH9jZChqK3i5AsMOvAHMYccAaAi1I=;
        b=oHrFwWXgVckNNjSSZWUA00ZIgWHn6alyStqAMQUgpd6mOZJij/c1fKzdRi6HfWjpLY
         aMkpINcCExm4nqtvsurJcNTgfYdfhgw58uvV93fRHCH8RRQz9VA7s6BW6rbaQByJ+9Ra
         1q/FIVGhc6KAmPgb5BAP9lk0QKu59+VJ/g7fUmGCXtJs9IZ8cCtyWt4m78KN/IgVg4wc
         ObgOHLKDmvIdIDu6KJED+8Y9oUEYlEm5HyzczReMgBOujZl2jSPO+W/4CrYzpqpi/Nm4
         W5BzluCW6EmS8TQz719/RCBaPPEi7lRXABJUQbMg583kOVQtx0ju/Yj4S343qb1z0kpw
         Fk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726667820; x=1727272620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jw9R7zHcU6wAlHrH9jZChqK3i5AsMOvAHMYccAaAi1I=;
        b=eu9Sm95nB0qIAnsloOqbwogt+UafFZLmF9fqX3KGbno0dgnBX9C7pFgan63xQJZX0y
         EVO5U+KQdqwxhRJQQAWFMJc5mJWGnW5pnI2FndTh+LvECvXa2tlidp+IBLeXT3lk3JyT
         PZv6v2c2hin/MEidi/brmxPN0xbZC3r0V9MGR+L/bvcYUlCDutLNyFYwbc/m4+ewK8yC
         NDcrgpTkrqsvVCVzNQHVM8t0t519dE1y67hgpYWsi6m4SVtEpTgeLly+ZCCKShK6vDIn
         0e8KBXwILJ2/TW+7hBWyEEsZs1LNcZH3bePvdz9vits4LkRSyaLJqAtVRaelDlLXBrj5
         89vg==
X-Forwarded-Encrypted: i=1; AJvYcCVvk5CXk3anLpD1DhYr4wQkKk4gXfQQuRpSDqeTCdkaTTLbs7UgITY2okIeXbyEUgI4c4I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfk5m79+0Z9+TotekfJKTtg1y8xDKw8mk0IKhWLVxshSrzu1Nk
	f8pmC9MCvPf1pOH3aX5eUct+ICX8CeSnl70UlnZj+zCMnLIuV2jL7rOEzkN3B4c=
X-Google-Smtp-Source: AGHT+IEnUf2BBLrMw6AF9knDQNnY2Bh71rIsr9GcMfumfal10/pMPKRiwjmEtak/OEyud7HuRes7Yg==
X-Received: by 2002:a17:907:971b:b0:a89:ffd0:352f with SMTP id a640c23a62f3a-a90481045d7mr2005808166b.48.1726667820268;
        Wed, 18 Sep 2024 06:57:00 -0700 (PDT)
Received: from localhost ([83.68.141.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a906109662fsm594583266b.38.2024.09.18.06.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 06:56:59 -0700 (PDT)
Date: Wed, 18 Sep 2024 15:56:58 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, qemu-riscv@nongnu.org, 
	qemu-devel@nongnu.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] target/riscv: enable floating point unit
Message-ID: <20240918-4e2df3f0cabdb8002d7315d9@orel>
References: <20240916181633.366449-1-heinrich.schuchardt@canonical.com>
 <20240917-f45624310204491aede04703@orel>
 <15c359a4-b3c1-4cb0-be2e-d5ca5537bc5b@canonical.com>
 <20240917-b13c51d41030029c70aab785@orel>
 <8b24728f-8b6e-4c79-91f6-7cbb79494550@canonical.com>
 <20240918-039d1e3bebf2231bd452a5ad@orel>
 <CAFEAcA-Yg9=5naRVVCwma0Ug0vFZfikqc6_YiRQTrfBpoz9Bjw@mail.gmail.com>
 <bab7a5ce-74b6-49ae-b610-9a0f624addc0@canonical.com>
 <CAFEAcA-L7sQfK6MNt1ZbZqUMk+TJor=uD3Jj-Pc6Vy9j9JHhYQ@mail.gmail.com>
 <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com>

On Wed, Sep 18, 2024 at 03:49:39PM GMT, Heinrich Schuchardt wrote:
> On 18.09.24 15:12, Peter Maydell wrote:
> > On Wed, 18 Sept 2024 at 14:06, Heinrich Schuchardt
> > <heinrich.schuchardt@canonical.com> wrote:
> > > Thanks Peter for looking into this.
> > > 
> > > QEMU's cpu_synchronize_all_post_init() and
> > > do_kvm_cpu_synchronize_post_reset() both end up in
> > > kvm_arch_put_registers() and that is long after Linux
> > > kvm_arch_vcpu_create() has been setting some FPU state. See the output
> > > below.
> > > 
> > > kvm_arch_put_registers() copies the CSRs by calling
> > > kvm_riscv_put_regs_csr(). Here we can find:
> > > 
> > >       KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
> > > 
> > > This call enables or disables the FPU according to the value of
> > > env->mstatus.
> > > 
> > > So we need to set the desired state of the floating point unit in QEMU.
> > > And this is what the current patch does both for TCG and KVM.
> > 
> > If it does this for both TCG and KVM then I don't understand
> > this bit from the commit message:
> > 
> > # Without this patch EDK II with TLS enabled crashes when hitting the first
> > # floating point instruction while running QEMU with --accel kvm and runs
> > # fine with --accel tcg.
> > 
> > Shouldn't this guest crash the same way with both KVM and TCG without
> > this patch, because the FPU state is the same for both?
> > 
> > -- PMM
> 
> By default `qemu-system-riscv64 --accel tcg` runs OpenSBI as firmware which
> enables the FPU.
> 
> If you would choose a different SBI implementation which does not enable the
> FPU you could experience the same crash.
> 

Thanks Heinrich, I had also forgotten that distinction. So the last
question is whether or not we want to reset mstatus.FS to 1 instead of 3,
as is done in this patch.

Thanks,
drew

