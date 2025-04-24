Return-Path: <kvm+bounces-44142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED605A9B028
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A3DB7AB8D6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D7B18A6AD;
	Thu, 24 Apr 2025 14:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="T2lsnBvz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CFB12CDA5
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745503679; cv=none; b=UHpdLH5vCpM/IGF9KAZfQfpQPIiCoihNxwee06MDEghsYc1XNTyCY5uzvN9a64/D3EiR6oa04rgIHUs8sWqUm4+fgYfn5KNRw5hDeVq3xHj9xY96CTqJdZnXNSykAKGP45rC5BSEq+BGPR3ljejCFy82LaQB2wSR3W96dOBnE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745503679; c=relaxed/simple;
	bh=Mee2OZD1lraRPPalIBE6iLcH6n6PqLWZrU1Z2lk9bFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qma3MlH1QoGvkF/0mKPuy0BXITFXne9FUwEHe1gYMUzw7HzuVr65mRvwVnLfe/eABoXEg7F/11nEj6GG4uYcu3c4ss42BTkGwFQLYr7EOCBsySvG9SzDaT6tkun4roAGV+UD511tKRHqIXF5xGzn0TYojCgaj+LGJXkYxPdzRUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=T2lsnBvz; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so9554025e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745503676; x=1746108476; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U0v6f9lKAMd35DpCsKVbL9D2wBml6curMV8py2v4cGU=;
        b=T2lsnBvzTEvD8AfwzcF1X+hQ3nhMbw3pBj55HCGYtCSAKrcwkKKbnbCg3su91RFQvW
         p4a7dq86Qsbf9nearJDc9E7RRHPQJuBD/0VYCsZxUhGWjolZrXE2Qyvo7R+vKgc1Fvbt
         4P6CgZbaUllEZfcZlVInXhGescIJXmhIo6t1RC1lkvmSSp8Xj3TFc/D5KpdnhwP4fDDx
         3KzAghaXWeFLXcp9nz5+iX/RTZWzA+5q+nfY566xys9NwlGoLBsy02iYWI69HmprD6zo
         oAanvCMBuxIptNCaoUjkpZQkDlLgPW+ZDC5/dIDi9DRWwk74w+00ATjh+nifjZSbAmWh
         MPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745503676; x=1746108476;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0v6f9lKAMd35DpCsKVbL9D2wBml6curMV8py2v4cGU=;
        b=dfU8FI9I65xIxWFZwEzDFH7roVjqUDRYTVjb0XkYZ7r8LcD7FWJR6Uv+YBysrnTlNs
         iLaLOd77jukek/Gki5tqonX5A3fXObWOhwRwR0iF1TDMwGUuTL92glJm1YEkpIqrjsKQ
         pT7RQoNZEHlWmphwYIz1ftzT7irGZ95zoIXYIhhgxnxtQ0WfuUobxTUPgXSARPt4JCYe
         UxPXoqdEnPLGGKof/iztwtOYAertUS7gLT//Wvf4P9THD2GE73zucrKEuyFbHAQNr+OM
         O6hNGbE+3rnKZZ284UWEWyyOgxLC7Ycm8R/5g64m+iOEy8MYBWzJFDxsOhTKFEtr0Tst
         3GoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa5eF+Vnp2HnV2im30dgOtfdQXdpmsozrDvQDcmsleU7I6GzlussMWrX7gEJGnIi3CVps=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw0VJhbiM1RRUHARHHG/3vK394qgH4B5pcEr2WU/2u9S40jln6
	X6pq5PH7sEGxe1ou0Wi5rEemM8OWWqGwZsiTKwGN0+VOegM8GmloOcF66No5ay0=
X-Gm-Gg: ASbGncvck1/uYRANXWBJwtdXnl5oaGQZH56Monh1fjtYvXepydXt1of7Wqcjl1I17CG
	2BHMHJuFxHl5YpFdnphngPn2r/SXIhS3jrq6WEYiRw0kKQbB2q1RczXmeHhqeI58vgXdE68S46p
	UUvT0bK85I3y9siwfW3JElHg6bVacHjwxGqoht4TPyJwO3hfQv2hBv1UVQjgAxWco0xOHTYwLPo
	fRVI/q0JzAiTd2hF/McqUmruSldVkzKYTx0arKMuPtNmlEtUb1fMxUAmBiboI8JwdHQ6u7YVFg2
	0arDJ95KDTQ8uphbD2RwO5WLQj1WXUo6gpxLtx0=
X-Google-Smtp-Source: AGHT+IFUPMtP/KjaYEN9MtbB/NYTf0ZhorBZP9X4u5pu7YG//9ef9TT7MFoljX3EChphPUpWA7o/8A==
X-Received: by 2002:a05:600c:a00d:b0:43d:7588:6688 with SMTP id 5b1f17b1804b1-4409bd18492mr27593225e9.12.1745503675515;
        Thu, 24 Apr 2025 07:07:55 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2ac27dsm22476585e9.22.2025.04.24.07.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:07:55 -0700 (PDT)
Date: Thu, 24 Apr 2025 16:07:54 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 10/10] riscv: Allow including extensions in the
 min CPU type using command-line
Message-ID: <20250424-153e6b09d5f0ccdee057a0d9@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-11-apatel@ventanamicro.com>
 <20250412-bc81866c2227ed98429f86b5@orel>
 <CAK9=C2UxikXyX_VEn7txnfXVjCdLE7Awn=yjs_Ye2dc8VP=DRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2UxikXyX_VEn7txnfXVjCdLE7Awn=yjs_Ye2dc8VP=DRg@mail.gmail.com>

On Thu, Apr 24, 2025 at 07:02:18PM +0530, Anup Patel wrote:
> On Sat, Apr 12, 2025 at 7:15 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> > >  bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
> > >  {
> > >       struct isa_ext_info *info = NULL;
> > > @@ -128,16 +142,39 @@ bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
> > >  int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
> > >  {
> > >       struct kvm *kvm = opt->ptr;
> > > +     const char *str, *nstr;
> > > +     int len;
> > >
> > > -     if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
> > > +     if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&
> >
> > If arg == 'min', then it can't be less than 3 so the '|| strlen(arg) < 3'
> > is dead code.
> >
> > > +         (strncmp(arg, "max", 3) || strlen(arg) != 3))
> >
> > I think we want
> >
> >  if (strlen(arg) < 3 ||
> >      (strlen(arg) == 3 && strcmp(arg, "min") && strcmp(arg, "max")) ||
> >      strncmp(arg, "min", 3))
> 
> Nope, for cpu-type = "min" the strlen(arg) can be greater than 3
> because of comma separated extensions provided as part of
> cpu-type value.

That's what the last condition 'strncmp(arg, "min", 3)' of my proposed
compound-condition is confirming. That condition is only checked for
strlen(arg) > 3.

Thanks,
drew

