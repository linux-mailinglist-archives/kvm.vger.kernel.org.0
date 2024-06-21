Return-Path: <kvm+bounces-20241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8604C9124C3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8FBCB21507
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41E9174EF0;
	Fri, 21 Jun 2024 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Fz6rxrhV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A43173357
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 12:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718971621; cv=none; b=dRxg33QEjTLMCaDueKQ6wPlq04nzYjko+MBqfhjOTV6CZo/oLaB22b7kLC/EmXUeu+3AxA2EfiXaBILQMKWXw/2Rh1x32BM93R6V7T0cllFfLcl+Uhvk1Vni0RNFuYmnPfWdAijHpwjhjweLaA3C7lK8Uj2ihpGmXhm3AdcmAes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718971621; c=relaxed/simple;
	bh=R27bi+sTyPcra6bImxssKXNbBgmbnnDJg/KQRnOsT+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0/Zg2As6ONYAPP3RrkJOaK8gI7Wh9diEvyk9DHIQibbXLKP9Kbf6zqXI3ZBIX1ZOo5yjnjJxepOLqx2ALzMpzJ1Kyh6UVyZu1JoLzOrQ5qWQh2md4nGmzdUinAASImG0WaaSS15XNJNwrtpNVIZCLb6drufXuP9IAPL9hh0T7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Fz6rxrhV; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a63359aaacaso282807166b.1
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 05:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718971618; x=1719576418; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHJrI7Vqw3c5XD9sXg5PVJnoydMCRn6WSSge8PKtjyc=;
        b=Fz6rxrhVBQeBuB2FeL2HO9+W4Z2MMBIEQFc5nZkqUTl+v9uk6tCrDrI87q4AmWiNnG
         TasYbFwhgoXBMXkyuad/hfXo+M8pR8Eh76D47sIej7kbEuXK1IJvH64cAzwH3SbhhuOP
         AWFEpP8B8qfqd5Tl/2seSCkx9NfAyj/2o+0sUNcuG3DwKDvJZmn/T7ravyrbrfSXIFAd
         2pfphiQfGY3FCwBaZuwK5Qt793WPsDXOZkXg9BoOCF1lmmXfWZmmCpNILJrYQJrNye8j
         5HgbyWtL0Zh+tmkNQMM1ud4twncFbebxJbgQe9o4g4x1LknrCp7gGIrUSCIKBnL0QyxR
         Q9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718971618; x=1719576418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHJrI7Vqw3c5XD9sXg5PVJnoydMCRn6WSSge8PKtjyc=;
        b=Jl+Qc8Pw6jSHaed9TeI/qci3ZEQcPfPZ3wpY1qkso+H9q3R3hbHwNIkA9HSJ1jyiRK
         NRmcSGHtlfdK1Z03semgpIZjBrUeqCd4hM6mcSWb4pUpicyhe5ZnMeOlGjn8aOPbCbLa
         epsPX+29psmdWn98gYSBVJKqjLJDAGhGEhmoqhOFNZ6yhKyND5i0Im6dPAyoJdlOP/1s
         3wVkPA4M54Cgy+La/rxY53lOAn0+9HYtMFQ0FbRh2B4iQjAZkQw2myUncWGvOpVaD3tg
         +H4h0P0ivTCwo6D+ivlcrgmUgQmWNRBYAfOLHmpJqd7T/63GV65c2solzGSq5l6AFPR0
         3rfw==
X-Forwarded-Encrypted: i=1; AJvYcCWn1wce1own1BVsFuDs7/D0DTl7wDVpi5LX3BCMyAvb1/BP7NVJp8Vu07l8+W51X5mjxqw9sVc+GWUX6wgLbRqTWRWK
X-Gm-Message-State: AOJu0YxHhL94QIgJHZdTcpT7DhePztNB7aZjpS9IsFQXHdH0ywXte1Fh
	3WOKUVLQs5/OdYMLABslVwiFvNVZ7OaRd9fJ1jZA50pInGR/VHUE2knRj1eT2vc=
X-Google-Smtp-Source: AGHT+IF2EHP5Y+0/X+QcGd8dEyDcv5ub1PMssgA7iavpB36MSQ3omIYrrSlu92gh8QjYHzsmEitT+g==
X-Received: by 2002:a17:907:a0d2:b0:a6f:b5dd:1a49 with SMTP id a640c23a62f3a-a6fb5dd1b35mr532165866b.3.1718971617469;
        Fri, 21 Jun 2024 05:06:57 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6fcf5490d9sm76845966b.115.2024.06.21.05.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 05:06:57 -0700 (PDT)
Date: Fri, 21 Jun 2024 14:06:51 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, apatel@ventanamicro.com, alex@ghiti.fr, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Jinyu Tang <tjytimi@163.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>, 
	Samuel Ortiz <sameo@rivosinc.com>, =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Charlie Jenkins <charlie@rivosinc.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Leonardo Bras <leobras@redhat.com>
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
Message-ID: <20240621-a69c8f97e566ebd3a82654c1@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
 <20240621-d1b77d43adacaa34337238c2@orel>
 <20240621-nutty-penknife-ca541ee5108d@wendy>
 <20240621-b22a7c677a8d61c26feaa75b@orel>
 <20240621-pushpin-exclude-1b4f38ae7e8d@wendy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621-pushpin-exclude-1b4f38ae7e8d@wendy>

On Fri, Jun 21, 2024 at 12:00:32PM GMT, Conor Dooley wrote:
> On Fri, Jun 21, 2024 at 12:42:32PM +0200, Andrew Jones wrote:
> > On Fri, Jun 21, 2024 at 11:24:19AM GMT, Conor Dooley wrote:
> > > On Fri, Jun 21, 2024 at 10:43:58AM +0200, Andrew Jones wrote:
...
> > > > It's hard to guess what is, or will be, more likely to be the correct
> > > > choice of call between the _unlikely and _likely variants. But, while we
> > > > assume svade is most prevalent right now, it's actually quite unlikely
> > > > that 'svade' will be in the DT, since DTs haven't been putting it there
> > > > yet. Anyway, it doesn't really matter much and maybe the _unlikely vs.
> > > > _likely variants are better for documenting expectations than for
> > > > performance.
> > > 
> > > binding hat off, and kernel hat on, what do we actually do if there's
> > > neither Svadu or Svade in the firmware's description of the hardware?
> > > Do we just arbitrarily turn on Svade, like we already do for some
> > > extensions:
> > > 	/*
> > > 	 * These ones were as they were part of the base ISA when the
> > > 	 * port & dt-bindings were upstreamed, and so can be set
> > > 	 * unconditionally where `i` is in riscv,isa on DT systems.
> > > 	 */
> > > 	if (acpi_disabled) {
> > > 		set_bit(RISCV_ISA_EXT_ZICSR, isainfo->isa);
> > > 		set_bit(RISCV_ISA_EXT_ZIFENCEI, isainfo->isa);
> > > 		set_bit(RISCV_ISA_EXT_ZICNTR, isainfo->isa);
> > > 		set_bit(RISCV_ISA_EXT_ZIHPM, isainfo->isa);
> > > 	}
> > >
> > 
> > Yes, I think that's reasonable, assuming we do it in the final "pass",
> > where we're sure svadu isn't present.
> 
> I haven't thought about specifically when to do it, but does it need to
> be in the final pass? If we were to, on each CPU, enable it if Svadu
> isn't there, we'd either end up with a system that I suspect we're not
> going to be supporting or the correct result. Or am I misunderstanding,
> and it will be valid to have a subset of CPUs that have Svadu enabled
> from the bootloader?
> 
> Note that it would not be problematic to have 3 CPUs with Svade + Svadu
> and a 4th with only Svade in the DT because we would just not use the
> FWFT mechanism to enable Svadu. It's just the Svadu in isolation case
> that I'm asking about.

I wasn't thinking about the potential of mixmatched A/D udpating. I'm
pretty sure this will be one of those things that is all or none. I
was more concerned with getting the result right and I had just been
too lazy to double check that the block of code you pointed out is
in the right place to be sure there's no svadu. Now that I look, I
believe it is.

> 
> > Doing this is a good idea since
> > we'll be able to simplify conditions, as we can just use 'if (svade)'
> > since !svade would imply svadu. With FWFT and both, we'll want to remove
> > svade from the isa bitmap when enabling svadu.
> 
> Right I would like to move the various extension stuff in this
> direction, where they have a bit more intelligence to them, and don't
> just reflect the state in DT/ACPI directly.
> I've got some patches in mind once Clement's Zca etc patchset
> is merged, think I posted one or two as replies to conversations on
> the list already. An example would be disabling the vector crypto
> extensions if we've had to disable vector, or as you suggest here,
> dropping Svade if we have turned on Svadu using FWFT. I think that makes
> the APIs more understandable to developers and more useful than they are
> at the moment, where to use vector crypto you also need to check vector
> itself for the code to be correct. If I call
> riscv_isa_extension_available(), and it returns true, the extension
> should be usable IMO.

Sounds good to me.

Thanks,
drew

