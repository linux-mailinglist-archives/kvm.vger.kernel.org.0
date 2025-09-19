Return-Path: <kvm+bounces-58144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B52DB89312
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 13:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAFA11660BA
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3573093CF;
	Fri, 19 Sep 2025 11:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8SC6C39"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A23093A5
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758279985; cv=none; b=edD3zLYql63g1YG+QK7F877cgLizdk9lDRa/4W/T7U2R2Dad910MIT1sM3aSkE21DFJUL6Zyx32GmFMO7C2hwC2XZschpAwfW7ZMcrmlFjD/Cw6MAzVotHBsxL1xgdVvwA601ePT0NUDmhJiJCWJBsIT8/xJVRHREmEb0jewGG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758279985; c=relaxed/simple;
	bh=FeRgsSRi/iWOgqISnP+r+zKDQoLdP8inVV16qsd7MGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNH29HDj0l7Tgt/K6cY9J7ZwuBdH2HBboNIccijDIOk1cuvCN53NrTS9MeD9SqIFntn8T0qTi5oYPX2wulTbI8fmyCAAj0U/hs+JyvOqY3cBsKJDfZy5jf0eU7FWFfG6nPnG3QqvR/w/zFWFFD2gx2slJr3aq5ft64Q/jKA7vIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8SC6C39; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee1317b1f7so958758f8f.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 04:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758279982; x=1758884782; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E0gpwB10/6E2U+Sby0w+MPfG8NeegflF3tJftb7joqA=;
        b=Q8SC6C39HSzMllgd/UNkS5pHqobCWsVLBjBEoSNzLAi1wsLTx93PZqvd4EabCCHfh6
         cMHspRcNaxe1EUOPs1/THG2wDGA3vz51R9eOdzC/3l3r4e/iQd7To8YerJGalNMfVJqC
         uiTF0rDFb5fx5D9veDlLBTYsbpNcME9/bbEld9/ZGMIf1TlCyonJUAKCmx5vMZkm7D7X
         tQXLJa+AwBiM/GRvYgxFU7pDgyWOKdyD2J/kznrNiArhSTDytaR7xmFm+cCYX1LDG24o
         /8c/T8JCJDl3Yhlwn41FOJWVLglJoXkfu4FjDDbjHn/fkX+AsKjHR5nWxq05trMcuq1A
         eOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758279982; x=1758884782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0gpwB10/6E2U+Sby0w+MPfG8NeegflF3tJftb7joqA=;
        b=O+rufERE/wHcEDrCV1hrKYRbOXMYmwp5p5q+dPfW+0tO2XjhCJ3124Wru/RuYEQNJo
         EbKiyFZasnnVU5iVw8IRiNk2GpbMzXEt1iQpkiXmKhWI9oUZQTGzOo25WCosTydBhRQN
         +mfrg8/awhq9tl4FZES0/KqXGm+uQjanrXMGJgKjsqooWMQXDjH7cXTgN6KYwEbwlJXF
         xSGuWS3RmWgL+7+YJNWacLf2zfZb8arXGZ9wKaR+9O7BGUcTRZ69qT9Cze6CgjB29n1P
         36NXdIFA9l/lP9DF4LVE7aFoFPPX3alr4HtlLrkvTz9ug5frd+pH2686X/GnDYDbmQY8
         Avpg==
X-Forwarded-Encrypted: i=1; AJvYcCXD5MdSzI09dgAEUfVsSrIXap/XYsoWmwdgn8QIAHd3V5iHiUPa3AFh+2E7oiHDjW/Lq6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEqLanx3b5qT1o8Q+XR/IUJWy1Dspgtf5AjQMSzRz5cVtWT5Rf
	sCmvNIwP7LCCnc7qd3RE9+pFs5+I9q9ILbEqLtwMtqTIlFDiJWSLU5t+
X-Gm-Gg: ASbGnctuPD0Ajzpwn/Zd91h/x0rm3aJZDf7lr23w7jT2reN2/n+sRtqB2mciigrHBmT
	s+2biqnszAjXHnuUj25f4Y2QHmLhZga3XXRcgSlDj6GFvnSgogvFBxtTxpTMZOgZjv2MTLDmMVy
	hV6anQzzgV4bo4uVVMx0H7n1jPblVGJWCvq81CLJyrSKDMDDuVGVaLI4lClPflY5pRIEQYNaiEr
	LZGEoFzYRkyJU1fhYRltA6bteay240v3JbqKy1DqRdCOUsBZY4waCGwi8Np7ukl+JURP4aIicId
	K2NBvPGKTyElTvzGwGi8s4ocFzlCuNyLjDOhSCsfBgbKRcse/ChIhheWqk3iB54gQd8vnvQIGfg
	65ggiTNcxn45A1IFN3kIQ
X-Google-Smtp-Source: AGHT+IF2Z0bInAWZqDYYETRVnCkFEjbkAn2Fex4pkyig1CAMuVquXF5ao4cQ8XxsbTLy1k2XXr+50A==
X-Received: by 2002:a05:6000:2881:b0:3eb:dcf:bfa4 with SMTP id ffacd0b85a97d-3ee868a75b0mr2033940f8f.54.1758279981950;
        Fri, 19 Sep 2025 04:06:21 -0700 (PDT)
Received: from andrea ([176.201.192.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46138694957sm139550595e9.4.2025.09.19.04.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 04:06:21 -0700 (PDT)
Date: Fri, 19 Sep 2025 13:06:15 +0200
From: Andrea Parri <parri.andrea@gmail.com>
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: corbet@lwn.net, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, will@kernel.org,
	peterz@infradead.org, boqun.feng@gmail.com, mark.rutland@arm.com,
	ajones@ventanamicro.com, brs@rivosinc.com, anup@brainfault.org,
	atish.patra@linux.dev, pbonzini@redhat.com, shuah@kernel.org,
	devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, apw@canonical.com, joe@perches.com,
	linux-doc@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [External] Re: [PATCH v3 0/8] riscv: Add Zalasr ISA extension
 support
Message-ID: <aM05J6FU0xG3SBzR@andrea>
References: <20250919073714.83063-1-luxu.kernel@bytedance.com>
 <aM0qlTNPiaQRY2Nv@andrea>
 <CAPYmKFsP+=S56Cj2XT0DjdvBT_SY84moM4LVeqxHTVWbtq4EVw@mail.gmail.com>
 <CAPYmKFsV_ZPifJBtvPOdqM6_Mzhac9A4-PH9zt8TirOqAwKGhw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPYmKFsV_ZPifJBtvPOdqM6_Mzhac9A4-PH9zt8TirOqAwKGhw@mail.gmail.com>

> > > (not a review, just looking at this diff stat) is changing the fastpath
> > >
> > >   read_unlock()
> > >   read_lock()
> > >
> > > from something like
> > >
> > >   fence rw,w
> > >   amodadd.w
> > >   amoadd.w
> > >   fence r,rw
> > >
> > > to
> > >
> > >   fence rw,rw
> > >   amoadd.w
> > >   amoadd.w
> > >   fence rw,rw
> > >
> > > no matter Zalasr or !Zalasr.  Similarly for other atomic operations with
> > > release or acquire semantics.  I guess the change was not intentional?
> > > If it was intentional, it should be properly mentioned in the changelog.
> >
> > Sorry about that. It is intended. The atomic operation before
> > __atomic_acquire_fence or operation after __atomic_release_fence can
> > be just a single ld or sd instruction instead of amocas or amoswap. In
> > such cases, when the store release operation becomes 'sd.rl', the
> > __atomic_acquire_fence via 'fence r, rw' can not ensure FENCE.TSO
> > anymore. Thus I replace it with 'fence rw, rw'.

But you could apply similar changes you performed for xchg & cmpxchg: use
.AQ and .RL for other atomic RMW operations as well, no?  AFAICS, that is
what arm64 actually does in arch/arm64/include/asm/atomic_{ll_sc,lse}.h .

  Andrea


> This is also the common implementation on other architectures who use
> aq/rl instructions like ARM. And you certainly already knew it~

