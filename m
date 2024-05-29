Return-Path: <kvm+bounces-18346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9E78D4148
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6CAC1F232CF
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 22:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8193716D9AC;
	Wed, 29 May 2024 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="b9uhjuUI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80216133B
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717021274; cv=none; b=K1Uiq6ziSbRt+Hp8EDQ5566L6EXG6ZvUkhGq9php0W7Mn81SIeGJ1AK3ypUvLqYpEI2bMBLAKxmGkRPtNFeyFSRzyCvZOWZTAlXf+RdSTpaLHu2nen0jnayhxJzrjBLFzcfcIMRmeVlIQDPfBWhAGKmAlZLcrOvtPBVhC5on+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717021274; c=relaxed/simple;
	bh=4BJG6CuqZgaW7Arz6k1E8rNnqlKsn97Py6v+FY/aJtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4/R3SuXer/ja3aTFwSuDnNkRyx9EtojuNdMlnRhszgIqFGKL+sG4boQ2FyBFxO0vrN2B/ijuDCPLEU7/Sb5E1dY2ZC0N7B7DxHiTI/PJbkvCYvPjm5S4F+5N2TZyLk2LluqUXx5YnUmDvb/Kdz5v7cMjijRFtGuacyY2jCXwMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=b9uhjuUI; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70224f928edso292617b3a.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717021273; x=1717626073; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+33JepHINIVhbAh8qOzaJpAIf0uqs6BRQtkDENj6cbg=;
        b=b9uhjuUI0UhxeaxKgwKpk5KO/LJUbNTs3Z6MkjfdwdvBd0+ul1nm5gAGPn1H/SSw2+
         F+GiKfJQdvXycGiom6hOwf6detUO6hMmVJysNv4C8En2FCkhYsdJUbnXuTx9mOXhzwlY
         wRT7UJa6E+1jmKSiRUrcf5M+CDMKQYIogA5n/Vq8KRel2wub7FHj0sTPxeCekgGcYpNL
         ZMKfGdS4nG1iJ9g10SFYwyu7CZKoiiKuc9/4aR94OphxaZK3gt12Pb2sDj9cb+E2nV8Q
         RwD2nETN887TVgYw1LzA1MwxXK4/iYbKf5nql96Oa+tpZgcQRB6jCo/uU503RfSmWmUt
         4WTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717021273; x=1717626073;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+33JepHINIVhbAh8qOzaJpAIf0uqs6BRQtkDENj6cbg=;
        b=VF1vUYn/YE/u4FyjSg7eAcRUobCV9mc9NwBSD/er3yAcOdMiTQyd8Gi58ArECK3ELH
         kSPI1MSDv7Bg3PSydxUJyROgr8b4KpuvOaMp5KR5BPLk8G8dmir7fhnvJ9U5/rltnKNg
         8QCOpko9E1XWW28+DTBK+Emng7+HX0wLgBHFCLgs2UaTpRBi//6twoH5JR608OTvsAdf
         yqPLTnIfRYhXQQMwvNB6MSeBpgGgMLRE00LI1SBRhoej4aXBG0yoOOkzugp2rcOCNwOt
         6aZ+QWDeQ5/I2fg9kl1A0VRe2f7x1V1i4Gf7XCkHN1p4CRGttwIpBCeqiz76Z7Hb64QH
         iNsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWacGUb7RI8UHXVFE1ESpmEs7ASnqKDgpYsCoOe3GZ3aldJEy8Zsbc/Xj80nTrokpe/pdKmddCECS/nu5h2yfmgvuUz
X-Gm-Message-State: AOJu0Yw6T5H75Recd/cRqOH0gPO9noh9kbgg79AZwRKDwsQx76hBvVGF
	eqh1B9ky2f/KIdMRtZPFLz1Ho8BVM/h38DzXMEn/bJ0xlQp/ZMIugPOhkmhV/TU=
X-Google-Smtp-Source: AGHT+IGI+L6uEPqPqWpCYsDTU2d/epzJLqI8Fa4/v+SZQaArW3EwTo3rCZNunG+pitvTJAace7dG0A==
X-Received: by 2002:a05:6a20:5651:b0:1b1:e35f:3eeb with SMTP id adf61e73a8af0-1b26460d454mr361563637.46.1717021272535;
        Wed, 29 May 2024 15:21:12 -0700 (PDT)
Received: from ghost ([2601:647:5700:6860:32f9:8d5b:110a:1952])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7022ca54847sm533889b3a.183.2024.05.29.15.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 15:21:11 -0700 (PDT)
Date: Wed, 29 May 2024 15:21:09 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 02/16] riscv: add ISA extension parsing for Zimop
Message-ID: <ZleqVUhDW+xgiTwu@ghost>
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-3-cleger@rivosinc.com>
 <ZlenZ+NvXxOxvqEO@ghost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZlenZ+NvXxOxvqEO@ghost>

On Wed, May 29, 2024 at 03:08:39PM -0700, Charlie Jenkins wrote:
> On Fri, May 17, 2024 at 04:52:42PM +0200, Clément Léger wrote:
> > Add parsing for Zimop ISA extension which was ratified in commit
> > 58220614a5f of the riscv-isa-manual.
> > 
> > Signed-off-by: Clément Léger <cleger@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h | 1 +
> >  arch/riscv/kernel/cpufeature.c | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > index 1f2d2599c655..b1896dade74c 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -80,6 +80,7 @@
> >  #define RISCV_ISA_EXT_ZFA		71
> >  #define RISCV_ISA_EXT_ZTSO		72
> >  #define RISCV_ISA_EXT_ZACAS		73
> > +#define RISCV_ISA_EXT_ZIMOP		74
> 
> Since my changes for removing xandespmu haven't landed here yet I think
> you should keep RISCV_ISA_EXT_XANDESPMU in the diff here and make
> RISCV_ISA_EXT_ZIMOP have a key of 75. Palmer can probably resolve the
> conflicting keys when these two series are merged.
> 
> - Charlie

I missed that other patches in this series were based off my
xtheadvector changes. It's not in the cover letter that there is a
dependency though. What do you need from that series for this series to
work?

- Charlie

> 
> >  
> >  #define RISCV_ISA_EXT_XLINUXENVCFG	127
> >  
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > index 2993318b8ea2..41f8ae22e7a0 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -241,6 +241,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
> >  	__RISCV_ISA_EXT_DATA(zihintntl, RISCV_ISA_EXT_ZIHINTNTL),
> >  	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
> >  	__RISCV_ISA_EXT_DATA(zihpm, RISCV_ISA_EXT_ZIHPM),
> > +	__RISCV_ISA_EXT_DATA(zimop, RISCV_ISA_EXT_ZIMOP),
> >  	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
> >  	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
> >  	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
> > -- 
> > 2.43.0
> > 
> > 
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
> 

