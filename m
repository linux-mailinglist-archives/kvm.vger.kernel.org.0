Return-Path: <kvm+bounces-10850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F72871374
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:15:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 001041F2289B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504F218AED;
	Tue,  5 Mar 2024 02:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="An4Ax8hR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BAE18032
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709604876; cv=none; b=JYeBNOXA2rd65/ZNSubyJWX8Ss8LOqVt8pyYD7S5ELVZ+TwQn4DXDvGfrZ4ojO0tUUEvzBiuGkC2evULsk6j/GOgNRaFNAfK+O8UGu7gdKmJ2brSZgEu4hX3OxwpOmhRfkZAzjVvNqoTeTiMO+VjAajW7GUkDi4cAtTSAIK1sNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709604876; c=relaxed/simple;
	bh=/+Q6mTZhqSjbWyDbIz87vv2jSlTpnufol/ZmxbDfuro=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=OIvgTaiQuTSHdt/YdNfEf2qICxkjqarfvmGeabOZszzzdpScB/Z0jVUtYaEWYYVn9JK51QNgXMnjX/8A9l86eGxcEnjBs4nLvLl1wzVvFwhJjLxEu/whNy09vuS7WZCcO7/SGabf9NbJl2/Kwyu5nq+eYwqlEP40it9YjOR/I4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=An4Ax8hR; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d81b08d6f2so4748660a12.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709604874; x=1710209674; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Glrxl2oFaqFsQaFLm3CDrPWwsMAFvXjuJugoNqHYYbQ=;
        b=An4Ax8hRMFV6UlqodoXnMEUJpPttNGze/KptMCl737QQ0onz6hAEklB3CF93zS6ovc
         GmfDz0C4qyE32bjIHdZv9laQEfmSsdsdJtHK67yj9/E8tec4oQhKRDdcorkjxq1Jv5dL
         dCpFnqpe+NL0QSh4a59AkAgRbNZasL/rUm/b6rRChuvO2U9ARd7wQIMYlUEYFu0yBqyx
         8L0MRhOjhANblGbNIUg1G7AKrA6LgyTYTvVWSVaZiROAmj6kKZPmLTLv60KQbm/ItHAO
         Asl/qMSrHeh6kW170jEZTUydqilMtjr4/GhISKK6EidGSHGq2wE8nZIhRRo5C0zhVpz0
         0TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709604874; x=1710209674;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Glrxl2oFaqFsQaFLm3CDrPWwsMAFvXjuJugoNqHYYbQ=;
        b=Z6Wydly8zHPjfHagN7pJ4pD4/zLyChL6Mtf7GM8E6HrQmbI5mNzoFj2fa3obSM4eSv
         E/Zv9UCiUOPub75h3oYvYQBUgJAGwC28YOVYMgp87NqFjLVi4iamqT+35AQVhySqRNd1
         ZoFDsQSXLVAVONvwnAxS0DWcRZGMV4g6pA0em3X8NuwW2waueZPIxuxshVufuwFjM47w
         O6TwUlHkkaJ/gBEas9Uo0yTs9Tjppv0afQgBuhDBY9/VMtr3aZNliWDRtmxV18/omROW
         7EV7GzeXHMnHNNQDGISOrnhJq6QtvWX33nf02GLHhdjJdEIhc4fb+lsYHWrWUGav9ihx
         bnpg==
X-Forwarded-Encrypted: i=1; AJvYcCUqD0F4YyK/ay6+HBGWlHvFkzHMgIBCQXzbj7EI7N0FdirJVl++cVs4BiZlH1859KMr0JYAY0indm0BKmDmIWGm/cT5
X-Gm-Message-State: AOJu0Yw1VxH/0uFDzMd270fKdLAWcSNpr5xAouhLLhuZvQcu88+t5jXZ
	UAfmOkMOupKmZe32xnyDH4fW03j+pZbPIFZgSadrexIEZl43ivasTvKJVCxd
X-Google-Smtp-Source: AGHT+IHjfT1+2QFMfQcAPYcvu8DZ+vjEp/Mvi30WYIv5XycXGtY/URBVHcfPW0OIRDmmDfGHfVlOiQ==
X-Received: by 2002:a05:6a20:7da9:b0:1a1:4bec:4835 with SMTP id v41-20020a056a207da900b001a14bec4835mr545319pzj.3.1709604874345;
        Mon, 04 Mar 2024 18:14:34 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b001db6da30331sm9231687pla.86.2024.03.04.18.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:14:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:14:28 +1000
Message-Id: <CZLGCIHLYA0V.33QYW4MF394R7@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 12/32] powerpc: Fix emulator illegal
 instruction test for powernv
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-13-npiggin@gmail.com>
 <a9441736-e254-49f0-9bea-e8008cec3e96@redhat.com>
In-Reply-To: <a9441736-e254-49f0-9bea-e8008cec3e96@redhat.com>

On Fri Mar 1, 2024 at 9:50 PM AEST, Thomas Huth wrote:
> On 26/02/2024 11.11, Nicholas Piggin wrote:
> > Illegal instructions cause 0xe40 (HEAI) interrupts rather
> > than program interrupts.
> >=20
> > Acked-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/asm/processor.h |  1 +
> >   lib/powerpc/setup.c         | 13 +++++++++++++
> >   powerpc/emulator.c          | 21 ++++++++++++++++++++-
> >   3 files changed, 34 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
> > index 9d8061962..cf1b9d8ff 100644
> > --- a/lib/powerpc/asm/processor.h
> > +++ b/lib/powerpc/asm/processor.h
> > @@ -11,6 +11,7 @@ void do_handle_exception(struct pt_regs *regs);
> >   #endif /* __ASSEMBLY__ */
> >  =20
> >   extern bool cpu_has_hv;
> > +extern bool cpu_has_heai;
> >  =20
> >   static inline uint64_t mfspr(int nr)
> >   {
> > diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
> > index 89e5157f2..3c81aee9e 100644
> > --- a/lib/powerpc/setup.c
> > +++ b/lib/powerpc/setup.c
> > @@ -87,6 +87,7 @@ static void cpu_set(int fdtnode, u64 regval, void *in=
fo)
> >   }
> >  =20
> >   bool cpu_has_hv;
> > +bool cpu_has_heai;
> >  =20
> >   static void cpu_init(void)
> >   {
> > @@ -108,6 +109,18 @@ static void cpu_init(void)
> >   		hcall(H_SET_MODE, 0, 4, 0, 0);
> >   #endif
> >   	}
> > +
> > +	switch (mfspr(SPR_PVR) & PVR_VERSION_MASK) {
> > +	case PVR_VER_POWER10:
> > +	case PVR_VER_POWER9:
> > +	case PVR_VER_POWER8E:
> > +	case PVR_VER_POWER8NVL:
> > +	case PVR_VER_POWER8:
> > +		cpu_has_heai =3D true;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> >   }
> >  =20
> >   static void mem_init(phys_addr_t freemem_start)
> > diff --git a/powerpc/emulator.c b/powerpc/emulator.c
> > index 39dd59645..c9b17f742 100644
> > --- a/powerpc/emulator.c
> > +++ b/powerpc/emulator.c
> > @@ -31,6 +31,20 @@ static void program_check_handler(struct pt_regs *re=
gs, void *opaque)
> >   	regs->nip +=3D 4;
> >   }
> >  =20
> > +static void heai_handler(struct pt_regs *regs, void *opaque)
> > +{
> > +	int *data =3D opaque;
> > +
> > +	if (verbose) {
> > +		printf("Detected invalid instruction %#018lx: %08x\n",
> > +		       regs->nip, *(uint32_t*)regs->nip);
> > +	}
> > +
> > +	*data =3D 8; /* Illegal instruction */
> > +
> > +	regs->nip +=3D 4;
> > +}
> > +
> >   static void alignment_handler(struct pt_regs *regs, void *opaque)
> >   {
> >   	int *data =3D opaque;
> > @@ -362,7 +376,12 @@ int main(int argc, char **argv)
> >   {
> >   	int i;
> >  =20
> > -	handle_exception(0x700, program_check_handler, (void *)&is_invalid);
> > +	if (cpu_has_heai) {
> > +		handle_exception(0xe40, heai_handler, (void *)&is_invalid);
> > +		handle_exception(0x700, program_check_handler, (void *)&is_invalid);
> > +	} else {
> > +		handle_exception(0x700, program_check_handler, (void *)&is_invalid);
>
> The 0x700 line looks identical to the other part of the if-statement ... =
I'd=20
> suggest to leave it outside of the if-statement, drop the else-part and j=
ust=20
> set 0xe40 if cpu_has_heai.

Can do.

Thanks,
Nick

