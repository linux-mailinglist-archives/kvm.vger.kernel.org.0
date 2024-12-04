Return-Path: <kvm+bounces-33064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 214A19E4395
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5B18280FE6
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBE21A8F90;
	Wed,  4 Dec 2024 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edj+LNbg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0741A8F78;
	Wed,  4 Dec 2024 18:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733337737; cv=none; b=l967cujsmyCwCg3rto+RLFPzvgai69UmapZ1YcMlHbgU29X+oaep0mgk0oIMDe2hGkfhCHQR4c1y4pQ5+QKw0ZvKpeNKSVUHLHjbu7Scyt6Lky/KCeUIxs3adLa9uHHPl4xej8TfAR7/nQ/ApxrEwV8FPaNAfd6hNkFL2CVd3hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733337737; c=relaxed/simple;
	bh=wiRmPcDPfl447CPd2d06m48S9Tj33PHLmHZm/NeD6WE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PSnZZjbR0HhvoGT0A7ol0tKzgw8mchtRm+L0gAytr235TOi8kJntkxvQm3Q1e4ntsFEn7vXVzciOHHrxACI2u7LFM571sfLxQ9HgVQuQkITiu4KtsJmFk65LrGCO3bXL4FXK2wNJ/GG76KxRe+3UDdcid7htjgSNswWOAE6w1xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edj+LNbg; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa53ebdf3caso4403866b.2;
        Wed, 04 Dec 2024 10:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733337733; x=1733942533; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3C6QThKHzGlWczzeqqYbCy3PuGqDdCeGAsd/QclkMA=;
        b=edj+LNbgLGF4cj29aej3LPdAt+b3WD+UP+ePezi+m6Ri/jOuodxpip9/ru2gvRsqHc
         dtfwTjbW2bfWcPMb8TK4EKtIBDKwqgC42pC4Rg4gtZe3gxcduH0LFbqXOuzn6rtjPFhc
         FjqONeZ8ZD1vdqv27JqUzEue7SqgevFR3TdltlAqxfyPCUR1EfZAUCqJBR8O5edgv7l1
         RcRqQC/XvZtUWGjaTyrVXHp53zT1XPoHqq0iID43pmZ10Dcv8D+nPCgSGn6ybKOY7DKy
         oB3KsGwHs+CiuoxBZsydmy7dDNZmW31NCH4Fk1SITNQQ6EdOThzMqSV1EvltQV3P4hN8
         K7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733337733; x=1733942533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3C6QThKHzGlWczzeqqYbCy3PuGqDdCeGAsd/QclkMA=;
        b=D2kH0+vl/q42xmc3r0Fh5AlK7sidZZGy6ig5I5EJSM28NmpDIeVprT4nU7Nz+AfYNm
         BlI4T/keehGgfVRN+dXtD0pXEU0jWI1UbNNNDc2/XJ5WHS65C8spFh9gSbEG78yUi8uW
         MNmoMeiMXjNOFIp6Vog+FMpDzhxOC5bFkQOzQ0xo6RVje5MUPviHwQuXeS+5eFlOJJqZ
         hTFwlnGHLb8IkXWeQRIxubLR2i8x+9KBsuCgjdlUYXNhIdtNMrM7gpX/8T4JBo8IvC7u
         siFMeS8qpwGgUw3TcnoLbgQMQ8rEkck87soMjfryw6Z2IXoGJ5ET4BVXPr92WvfZb2Im
         U4pg==
X-Forwarded-Encrypted: i=1; AJvYcCUwwduEXoA+8/LFHM7lV79uaW7++sRo7jkbATdT4pyY7jXqQSGEZ094cZrBFhjwHh8HzI8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2r/oEH4ZCnh4IRiR43TNYax4a32+jvrfRnTNU1NszxfDDebPu
	fVACUvz2Pbqa6ltPF3NSLGoXZTpgV4b6dJgtqrm3ZcC3ipLQYX1lauwyQyyTv/0wudlD1ZfOHc2
	S4sVOL71fRqH87ePnSRto6PBNFb0=
X-Gm-Gg: ASbGnctIP8xNzoh1q8QldGFG7kjyIGKOY+aTbSp+Br2cgzF/4hEA1bSyAcQEVyfXC9h
	KJqXG9K9RjYqn/j0EXcn12mcLSE+Na4E=
X-Google-Smtp-Source: AGHT+IEa7Gtl4pp7owEvUuHPLflJ+zvC65UMe54y6Ui0RggEQA4RoD4lnAJki0FHTdD9fRU+FHBJ0o7jW75EaSmav7g=
X-Received: by 2002:a17:906:30ca:b0:aa6:1e9a:e46a with SMTP id
 a640c23a62f3a-aa61e9ae53emr80364766b.57.1733337733169; Wed, 04 Dec 2024
 10:42:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-7-arnd@kernel.org>
In-Reply-To: <20241204103042.1904639-7-arnd@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 4 Dec 2024 20:41:36 +0200
Message-ID: <CAHp75VcQcDD3gbfc6UzH3wYgge6EqSBEyWWOQ_dTkz8Eo+XgFw@mail.gmail.com>
Subject: Re: [PATCH 06/11] x86: drop SWIOTLB and PHYS_ADDR_T_64BIT for PAE
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> Since kernels with and without CONFIG_X86_PAE are now limited
> to the low 4GB of physical address space, there is no need to
> use either swiotlb or 64-bit phys_addr_t any more, so stop
> selecting these and fix up the build warnings from that.

...

>         mtrr_type_lookup(addr, addr + PMD_SIZE, &uniform);
>         if (!uniform) {
>                 pr_warn_once("%s: Cannot satisfy [mem %#010llx-%#010llx] =
with a huge-page mapping due to MTRR override.\n",
> -                            __func__, addr, addr + PMD_SIZE);
> +                            __func__, (u64)addr, (u64)addr + PMD_SIZE);

Instead of castings I would rather:
1) have addr and size (? does above have off-by-one error?) or end;
2) use struct resource / range with the respective %p[Rr][a] specifier
or use %pa.



--=20
With Best Regards,
Andy Shevchenko

