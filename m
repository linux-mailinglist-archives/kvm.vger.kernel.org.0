Return-Path: <kvm+bounces-44133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A92A9AE1B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 751051B65BF9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF1327C179;
	Thu, 24 Apr 2025 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nI2wKPbP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BFE27BF6D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745499464; cv=none; b=bG4JEumfAxhq1qLM5uS/XW+77yP+kroMrtKdyYZ1rPqB/WWW5bTp/O6AcUjIeE3uGdh0vEPljGa8QJJUArOk9Osxw2/BlLWxPluMEtQnhXgDZv9wj9tTDFnTLSydprk6/aIwyUuK0CkqzU5A25B0lfI7M+Y8P5Wz9HhwDlYWhYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745499464; c=relaxed/simple;
	bh=reTdbb+6O0sXBwedeFukDBYju2S+gng4mftDGCp7r68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mf9sVIG714XM29KiUEdGz3GrprqWo2D6hDbTHjTvPU9akFzn5zZhGFphZ6SVcv0nCg7xcV3z47vDzc21nvuue1IAz5uSy6wcmLhIeALNdLcuZHn5Rbt6wFJUOEWrIEsMmCf0MRHTa4a44se4VhCFPlNiZPT+i+hm0SX+NSN/eF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nI2wKPbP; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so780462f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745499461; x=1746104261; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oPQSBVtSMsvYsAl+gZRdiR2fvyhUD5u3wJ4ZqhPNu8A=;
        b=nI2wKPbPDt/hA2aXCHz+p57vALDN2e0hpjTHegksYqxT2aEG28AMjyogp5hLa/Se7J
         RvMfNz+b/RK0nTGxhlIWSa9mUUQCwCjv1UaOAm4gBFxAscrFmuRqNUDXmsIO/BEfEbqa
         xPgRj74zkANoWWlSUcFp1weo3fvKoFhAkgSlQV6ZqY4XkxNKS8AW88ToTpcs74wRtf6N
         y+u+JySzY/KXJl0fmBuovbx+mL7K5497jTjUbj6HnczAvxg50JIDFLl80A9dSapQzSxF
         Dt0IVrBcAC3fZmvjDj1Ik3cB4QINSqsHPaf7F1tGy8JBh5+Y6fBc3d1N3vhbyHDQGcuR
         PhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745499461; x=1746104261;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPQSBVtSMsvYsAl+gZRdiR2fvyhUD5u3wJ4ZqhPNu8A=;
        b=WR2za/p4JG62oVacYNdufgLgjxjifprU0a5s30WkbK8SWlJbltXeywpbl/K6bkRBWF
         bMbgPvSUI8g9zbLPfnYHg0sYMUwHmufLiAZDCEvR9mO5thwoxK/bgoEL6HdoblTc8bRH
         q5MJ46hRW2AaMNvfhn0dSjdz9W6ZrXVbccuVI7+Wqt1vnou9YkeRa+2ZVnItBMwWVQpO
         ILz6Vw7ua0yi1xCEWB1xgGRIjJt3em7jAQmybzD+8IMAoHN3/x9zOgUNjj+cz/3976sZ
         Z+9LYzE5Zqo08JCI8CsQ40u8z0a+rGuHkYF/qvroiA59u+RdYqBS4zsQzVvKr0jYZ0L2
         d60w==
X-Forwarded-Encrypted: i=1; AJvYcCWVj5Va3rvnRJ2TvEJ9wu/W0NV1c+p5WbkX4TWdwDGBKFSbCGiEtGsK9jK66fLAjqRFBQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxldU5OxZ6pD2kK2ceGIVmTS5+5IB9g7aIzKNfiHCeOVSh5mUPx
	YATyp6BnsbkAOIt62p1SdcQzXDLcgpo7FoIgkG55UopQmXTmyC6JcOZqeL7u2ko=
X-Gm-Gg: ASbGncuPTWogjo/BhGxA6MaAJU+3vodgsxjd09YY7bRgLJ/lQ0pTP2V5cM5IReDFuh+
	OQy7rGaj4qarksPSw1C818E0SARR0Pf79AqMJVcyvIfh7BycyLqNqCL7F4t61FRZmOeVhjw/99z
	BKdWH5QWTd1NPMdJB7MwFg/ptpwKZSDbpp1SIO7rqjHoH0czDZMzCNzPZsJ3srT8uMzgS0KiEis
	8LMmxMsexIuF/0HR3lzbFPqOviQR1Z4BjpqdYG0161PqrzWth2BsTVVY07eHrc8b8ZlEhvGFHxN
	CHbNiUTMR+ZPeKzPaFkQ+sC9qT1T
X-Google-Smtp-Source: AGHT+IGWv3/WPoD+1AaHzmJVHKE9pYWAl7MImqfR1l23ycVK/8svQHojX4uoV4n0a06YqpUIKi6wnQ==
X-Received: by 2002:a05:6000:1e48:b0:391:3cb7:d441 with SMTP id ffacd0b85a97d-3a06cf5f657mr1695750f8f.25.1745499461227;
        Thu, 24 Apr 2025 05:57:41 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d54f019sm2068909f8f.96.2025.04.24.05.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 05:57:40 -0700 (PDT)
Date: Thu, 24 Apr 2025 14:57:39 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v5 03/13] riscv: sbi: add FWFT extension interface
Message-ID: <20250424-dc96e54988e25abfc2bb9cf8@orel>
References: <20250417122337.547969-1-cleger@rivosinc.com>
 <20250417122337.547969-4-cleger@rivosinc.com>
 <20250424-c85c9d2f189fe4470038b519@orel>
 <67e81f13-5e5e-4630-9a3f-73856b952e6e@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67e81f13-5e5e-4630-9a3f-73856b952e6e@rivosinc.com>

On Thu, Apr 24, 2025 at 02:32:01PM +0200, Clément Léger wrote:
> 
> 
> On 24/04/2025 13:00, Andrew Jones wrote:
> > On Thu, Apr 17, 2025 at 02:19:50PM +0200, Clément Léger wrote:
> >> This SBI extensions enables supervisor mode to control feature that are
> >> under M-mode control (For instance, Svadu menvcfg ADUE bit, Ssdbltrp
> >> DTE, etc). Add an interface to set local features for a specific cpu
> >> mask as well as for the online cpu mask.
> >>
> >> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> >> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> >> ---
> >>  arch/riscv/include/asm/sbi.h | 17 +++++++++++
> >>  arch/riscv/kernel/sbi.c      | 57 ++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 74 insertions(+)
> >>
> >> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> >> index 7ec249fea880..c8eab315c80e 100644
> >> --- a/arch/riscv/include/asm/sbi.h
> >> +++ b/arch/riscv/include/asm/sbi.h
> >> @@ -503,6 +503,23 @@ int sbi_remote_hfence_vvma_asid(const struct cpumask *cpu_mask,
> >>  				unsigned long asid);
> >>  long sbi_probe_extension(int ext);
> >>  
> >> +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags);
> >> +int sbi_fwft_local_set_cpumask(const cpumask_t *mask, u32 feature,
> >> +			       unsigned long value, unsigned long flags);
> > 
> > I'm confused by the naming that includes 'local' and 'cpumask' together
> > and...
> > 
> >> +/**
> >> + * sbi_fwft_local_set() - Set a feature on all online cpus
> >> + * @feature: The feature to be set
> >> + * @value: The feature value to be set
> >> + * @flags: FWFT feature set flags
> >> + *
> >> + * Return: 0 on success, appropriate linux error code otherwise.
> >> + */
> >> +static inline int sbi_fwft_local_set(u32 feature, unsigned long value,
> >> +				     unsigned long flags)
> >> +{
> >> +	return sbi_fwft_local_set_cpumask(cpu_online_mask, feature, value, flags);
> > 
> > ...that something named with just 'local' is applied to all online cpus.
> > I've always considered 'local' functions to only affect the calling cpu.
> 
> Yeah I thought of that as well, local here refers to the fact that this
> function applies for a local feature (as described in the SBI
> documentation) but agreed that it's really missleading. Any idea for a
> better naming ?

I'd drop 'local' from these names and when we deal with global features we
can add 'global' to their function names. If we really must have something
now, then maybe 'per_cpu' instead of 'local'.

Thanks,
drew

