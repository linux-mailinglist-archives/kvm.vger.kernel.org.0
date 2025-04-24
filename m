Return-Path: <kvm+bounces-44138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6FEA9AEFF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 777984434D5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469C527C862;
	Thu, 24 Apr 2025 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cW/b/G+l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A772C1ACEC7
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745501393; cv=none; b=QS2xvnSQLOyfFzs3yhl/Sh4KyDM6Bgg5sQd0ZlaldZjdROEOcXFTIR2UxMGitwC5WAw1+Bz2O5zZ7Zc/BkJStBpwx7Js1OGbso3a1wQVVtADFYqCvGM1yFRtTD90sxycoJkKuapy0hyfJV5BNOn5u3WpCjCa6PAg90GfRdA/N3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745501393; c=relaxed/simple;
	bh=hVYtMB2lu0h3Ek3tmlKmZ7tydv7df0WcjdmEibaR2ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZoMi6FjXyasKF9jLzU5zBCBB8pC7wkVWX/NebsvTmztYZsaW7svtWQF+R5iImK4JIigyIBP13RJiI5MmT6budKWzPAFoyea+lAFP1mYb6M3Rwv4YC6RqQFpPMt9RQv4MIwsHwFTxdM2Av7TAsLzXrhh6hvhopdw0+xF+LPwFgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cW/b/G+l; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso4972935e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745501390; x=1746106190; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7j9NUEt/ncZz1epZplQ8DSs1gFnYZwmEmPsf7e7ffgk=;
        b=cW/b/G+l0twtWCuUNo7lu9fmhhfGN2EfpK6CC31DB7lk+0u63AKWVOy3zIofgUzlAS
         k8Vt+tHWBAuNqxYJ43yjwYgRJcJuQ+1YsIxH8owsopxudQU8RbcCBSeYlnnthbnBAmCc
         gpUTsbfqz49s4e8iiaF5ssx518m3gMewB/yvLXa3q7iT1hUB1D/KB4lG41rX5d6sQSRE
         KqgU25uAC5xyHKGsxPpO5ZnSt1+/Y9q6w3APOHsY3aV6s/H4pl47LpumMdigILiGeEyr
         8QXj766Ehz7S5RaAvKY3hcmGIkcPueEQEsllEqNBTD/EzfDDK7Q5Rtsyj1n33ZMOTlT6
         T0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745501390; x=1746106190;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7j9NUEt/ncZz1epZplQ8DSs1gFnYZwmEmPsf7e7ffgk=;
        b=ttCjuH1z1fk1UZ1LIhzfXCFYI80l2uUW5q2vTqTt9N/EHyT1Q9/C1/HeMJO6DCCKQ1
         /MDRtyv9N2qvHeYzVXWwTwp4LChy4s7ruhHYE5bYZN5TkZBgJ/GZypchbXgnZAYZG9h0
         PrLd5AyLhV4qt731IhA95Bcg06ipLPs2eNmUO6l2jSVQSXTy0j0qjZkECJJR4A4TYaq8
         vhaMqEtzZ4/FzFzWus92AqHm8y49WMd8Fo8lsx1oWQFT/57jGB2bfHEk04byYMDyGZmM
         0TEuJBaNo3FlahIDtU+pfehW/jUMstGSIRTNNP60P8PobvSFmINNMtHEwq2TWdUgsjEx
         cotg==
X-Forwarded-Encrypted: i=1; AJvYcCUolkI9YBb/kFJKOwbm0Aco2ik9tvUkLrZF0j+VJx8M8aTG+2IIuyVUQB2v6sNFhsw19d0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGNCSr3aqtnRatfVv5ABVsjqDKpLnP3wkLTsq+pXmnuduSXRp5
	XJqDEez16glG81TPk0G/yXpL61iAkqI1YL7R1WazVUbEWuzoxMR/PgKpujeVzeo=
X-Gm-Gg: ASbGncsQ3Tznz7fAkKXaemEXJfnl7p5O7he5okPWikMt7cOOaDr94+Ci1AVqr2X6r+n
	330235QCDN9JC/HaH/hxycL6Z/XHZ+b5rbcr4cGiVZsojtXGf2U1I0kTbdw1l9ZBLUjYAvcSfrY
	aAG2nNUGg3QMHiujEu8nFk9Xx77fz3aPcnquDxPma0b7H+reFJ4mkqvndd5y3lduTHz5K5m/kRW
	NmdRUCruAzuN8WWg2IJFfRp4oJfLSonv7rrEBrPZdl/7PX79o1CenaK32uf4Nd77dTfwJgP8FdI
	jPpvSZQDCRxcmflTMmMJFqUxSq2d
X-Google-Smtp-Source: AGHT+IHUUy7DAq8FdoTctbIZq+7IJFz8qCxQ/okI9KIsoeBuVJ0XGVtGE1TDEgi74UaQzCLfqt/vbg==
X-Received: by 2002:a05:600c:5007:b0:43d:fa59:cc8f with SMTP id 5b1f17b1804b1-4409bda56c9mr25014155e9.33.1745501389811;
        Thu, 24 Apr 2025 06:29:49 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2aab65sm20962525e9.17.2025.04.24.06.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 06:29:49 -0700 (PDT)
Date: Thu, 24 Apr 2025 15:29:48 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 09/10] riscv: Add cpu-type command-line option
Message-ID: <20250424-6f042bf5e7c2433d9df6cd11@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-10-apatel@ventanamicro.com>
 <20250412-6eb18b693df1bd8959bcdfc6@orel>
 <CAK9=C2XD2Zk98KJrPYqseVQO-m_tFA97r=eXb2XXJ10vpxuk=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2XD2Zk98KJrPYqseVQO-m_tFA97r=eXb2XXJ10vpxuk=A@mail.gmail.com>

On Thu, Apr 24, 2025 at 06:27:35PM +0530, Anup Patel wrote:
> On Sat, Apr 12, 2025 at 6:45 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Wed, Mar 26, 2025 at 12:26:43PM +0530, Anup Patel wrote:
...
> > > +         !info->min_cpu_included)
> > > +             return true;
> >
> > If 'min_cpu_included' (or 'min_enabled') is all we plan to check for
> > whether or not an extension is enabled for the 'min' cpu type, then
> > we should write this as
> >
> >  if (!strcmp(kvm->cfg.arch.cpu_type, "min"))
> >     return !info->min_enabled;
> >
> > Otherwise when min_enabled is true we'd still check
> > kvm->cfg.arch.ext_disabled[info->ext_id].
> 
> The extensions part of "min" cpu_type can be disabled using
> "--disable-xyz" command-line options hence the current approach.
> 

Shouldn't we just have a single place to check? Otherwise something like
this may not work the way the user expects

  -cpu min,xyz --disable-xyz

Something like that makes sense if you have a runkvm script like this

  #!/bin/bash
  BASE_CPU=min,xyz
  lkvm ... -cpu $BASE_CPU $@

and then you invoke it with

  runkvm --disable-xyz

> > >       bool            sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
> > >  };
> > >
> > > +int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset);
> > > +
> > >  #define OPT_ARCH_RUN(pfx, cfg)                                               \
> > >       pfx,                                                            \
> > > +     OPT_CALLBACK('\0', "cpu-type", kvm, "min or max",               \
> > > +                  "Choose the cpu type (default is max).", riscv__cpu_type_parser, kvm),\
> >
> > I had to look ahead at the next patch to understand why we're setting kvm
> > as the opt pointer here. I think it should be added in the next patch
> > where it's used. Also, we don't use opt->value so we cna set that to NULL.
> 
> We are indeed using opt->ptr in this patch so we should be passing
> kvm as opt-ptr.

Oh yeah, I see that now.

> > > diff --git a/riscv/kvm.c b/riscv/kvm.c
> > > index 1d49479..6a1b154 100644
> > > --- a/riscv/kvm.c
> > > +++ b/riscv/kvm.c
> > > @@ -20,6 +20,8 @@ u64 kvm__arch_default_ram_address(void)
> > >
> > >  void kvm__arch_validate_cfg(struct kvm *kvm)
> > >  {
> > > +     if (!kvm->cfg.arch.cpu_type)
> > > +             kvm->cfg.arch.cpu_type = "max";
> > >  }
> >
> > Hmm, seems like we're missing the right place for this. A validate
> > function shouln't be setting defaults. I think we should rename
> > kvm__arch_default_ram_address() to
> >
> >   void kvm__arch_set_defaults(struct kvm_config *cfg)
> >
> > and set cfg->ram_addr inside it. Then add the cpu_type default
> > setting to riscv's impl.
> 
> Renaming kvm__arch_default_ram_address() is certainly not
> the right way because it has to be done after parsing options
> so that we set the default value of cpu_type only if it is not
> set by command-line options. Due to this reason, the
> kvm__arch_validate_cfg() is the best place to set default
> value of cpu_type.

Can't we just unconditionally set kvm->cfg.arch.cpu_type to "max" in
kvm__arch_set_defaults() and then if the command line parsing determines
it should be overridden it gets reassigned?

Actually, does cpu_type need to be a string? If we use an enum for it
we could save ourselves some of the strcmp pain.

Thanks,
drew

