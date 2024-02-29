Return-Path: <kvm+bounces-10349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 292D086BF9F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9233E1F241D4
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C251364D9;
	Thu, 29 Feb 2024 03:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5Y9ApGC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B50364D8
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 03:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709178651; cv=none; b=NS/mB+uNf8eOA6IW7H5GqqToPr05+tr2DvZj5FrIrRAjOUJbiiMdYvohEZKWpIh4FPHXRR6fEsCSxOAynx0noI/czbGmxybnLOdFwVPpj/O9nbZvmBt7TlSZxFxoZ0YAthIIMa0UXyqNF+2T0+IF7uYfucJQ3IVXUghnOuZAuF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709178651; c=relaxed/simple;
	bh=Y3UAx9xMCsa2Tt3Cvo7/8eGfUqse9215E4EX5NBGlvs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=VNEY+9DQZxoOR3SI0Pc2xmAgNblswk2C9c8ihMjsUQb8ajQg9eDKFNaDGZc3TMQTyBq8ejkfWdawHQcUFsQscmMSj78dkRCyxN+2KWwXivo5vaEJP1iB26+1zK9tYRDTbgKvZGWsm7wkc9qS1K/5PizPGyLJ5Qlg8Y3YpDshhso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5Y9ApGC; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d944e8f367so3820175ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 19:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709178649; x=1709783449; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zeWVQkyXgOzOQIs/dHWRu2DNvYw94klE30/Fe7skDjk=;
        b=P5Y9ApGCfWGUl7fP6GK0fX5w71wdAA5JnoctsqG5V2RCGH1FiMP9GNjbJ2Bkax2w+V
         NpKrHClLc65j97YfiWNQlGlfh1gjkLOcAseGwLaBu0QiYfT8KTCxwvQijic6d5y/SIdd
         wGboCvl6KCb1MHMOQv3m0+RN3n/RN8/EXHYj5ijqL8Ra8H7hETOGfddemc+4uA/oLaZ/
         aO/sm8ULTt5J1KiB24DdDdsXsYBBELBskW9B05mmrSgtRNJgF/Yd252XAAT/gMWfxs4F
         p5dlGIMwVJsGXAaNWXqxsJxdLIsKtp+D5dV75QVrEwOV+J2Q8ugV9VtGvFm85Rsj6cxV
         7L/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709178649; x=1709783449;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zeWVQkyXgOzOQIs/dHWRu2DNvYw94klE30/Fe7skDjk=;
        b=U6C5Qa08CDtD6xljkel6V9TZi7vVaFtW4zD6OKmIdr8coyi1i/Knxa5URr2dVj4SMk
         6/xot2QwasD+Cj0bwxvwRAdypoELV+w8ygXAnlUK9IiOKtR4KzLTnTCO9pWFLiWnXkHU
         JEy3qCiF942v2pZ2pWV18iXynZu9opRKbMeekpmwsCq1sc0/6Bg8XzRsM+PHxgOL0vhS
         D232jSmyZFue75f0rqNMtUNfCmLfhg8xSxfduZabXTB7GdY++YIIjLFzPDTJPKOwXrWa
         mZTOfEsWbYDby9MvCO0aQaCfkNvtmUXFc900sSdnMJ1eBhe/Xh+Eu99gpbB+vhkzWhZ8
         RHSA==
X-Forwarded-Encrypted: i=1; AJvYcCWDbUga82MRlnCq0k2ewagwNXeniElmNzV79JHmIdc9+DOsA8dWybf4pdczsUSGOdu42UAihXre+S4peX7qFlQcrODx
X-Gm-Message-State: AOJu0YxGmfeeaaCV/4mkIi7NtlPLaHWTlFcwCueyQw7KLR7oXR7J+3C3
	Shg2WZiXliI3d78CKRlnmQIGs8yIPQrwjt6Zr9bGpYsQNIdaozNz
X-Google-Smtp-Source: AGHT+IFlcd/QXUtF+np1jPBNMucUwhgDNhaD3xRM0rkywhWDhdQXiyxsLumNg+rkxL4B19+Fi+mbdQ==
X-Received: by 2002:a17:902:9a8c:b0:1dc:ceb0:b00c with SMTP id w12-20020a1709029a8c00b001dcceb0b00cmr1125939plp.35.1709178649417;
        Wed, 28 Feb 2024 19:50:49 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b001dcd00165a7sm247911plk.38.2024.02.28.19.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 19:50:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Feb 2024 13:50:43 +1000
Message-Id: <CZH99HE5N56V.2WDSGQQAERND4@wheely>
Cc: "Thomas Huth" <thuth@redhat.com>, "Laurent Vivier" <lvivier@redhat.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Joel Stanley" <joel@jms.id.au>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 04/32] powerpc: interrupt stack
 backtracing
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-5-npiggin@gmail.com>
 <20240228-9b32ddf7f58dc8f75b24e33c@orel>
In-Reply-To: <20240228-9b32ddf7f58dc8f75b24e33c@orel>

On Wed Feb 28, 2024 at 9:46 PM AEST, Andrew Jones wrote:
> On Mon, Feb 26, 2024 at 08:11:50PM +1000, Nicholas Piggin wrote:
> > Add support for backtracing across interrupt stacks, and
> > add interrupt frame backtrace for unhandled interrupts.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  lib/powerpc/processor.c |  4 ++-
> >  lib/ppc64/asm/stack.h   |  3 +++
> >  lib/ppc64/stack.c       | 55 +++++++++++++++++++++++++++++++++++++++++
> >  powerpc/Makefile.ppc64  |  1 +
> >  powerpc/cstart64.S      |  7 ++++--
> >  5 files changed, 67 insertions(+), 3 deletions(-)
> >  create mode 100644 lib/ppc64/stack.c
> >=20
> > diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> > index ad0d95666..114584024 100644
> > --- a/lib/powerpc/processor.c
> > +++ b/lib/powerpc/processor.c
> > @@ -51,7 +51,9 @@ void do_handle_exception(struct pt_regs *regs)
> >  		return;
> >  	}
> > =20
> > -	printf("unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n",=
 regs->trap, regs->nip, regs->msr);
> > +	printf("Unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n",
> > +			regs->trap, regs->nip, regs->msr);
> > +	dump_frame_stack((void *)regs->nip, (void *)regs->gpr[1]);
> >  	abort();
> >  }
> > =20
> > diff --git a/lib/ppc64/asm/stack.h b/lib/ppc64/asm/stack.h
> > index 9734bbb8f..94fd1021c 100644
> > --- a/lib/ppc64/asm/stack.h
> > +++ b/lib/ppc64/asm/stack.h
> > @@ -5,4 +5,7 @@
> >  #error Do not directly include <asm/stack.h>. Just use <stack.h>.
> >  #endif
> > =20
> > +#define HAVE_ARCH_BACKTRACE
> > +#define HAVE_ARCH_BACKTRACE_FRAME
> > +
> >  #endif
> > diff --git a/lib/ppc64/stack.c b/lib/ppc64/stack.c
> > new file mode 100644
> > index 000000000..fcb7fa860
> > --- /dev/null
> > +++ b/lib/ppc64/stack.c
> > @@ -0,0 +1,55 @@
> > +#include <libcflat.h>
> > +#include <asm/ptrace.h>
> > +#include <stack.h>
> > +
> > +extern char exception_stack_marker[];
> > +
> > +int backtrace_frame(const void *frame, const void **return_addrs, int =
max_depth)
> > +{
> > +	static int walking;
> > +	int depth =3D 0;
> > +	const unsigned long *bp =3D (unsigned long *)frame;
> > +	void *return_addr;
> > +
> > +	asm volatile("" ::: "lr"); /* Force it to save LR */
> > +
> > +	if (walking) {
> > +		printf("RECURSIVE STACK WALK!!!\n");
> > +		return 0;
> > +	}
> > +	walking =3D 1;
> > +
> > +	bp =3D (unsigned long *)bp[0];
> > +	return_addr =3D (void *)bp[2];
> > +
> > +	for (depth =3D 0; bp && depth < max_depth; depth++) {
> > +		return_addrs[depth] =3D return_addr;
> > +		if (return_addrs[depth] =3D=3D 0)
> > +			break;
> > +		if (return_addrs[depth] =3D=3D exception_stack_marker) {
> > +			struct pt_regs *regs;
> > +
> > +			regs =3D (void *)bp + STACK_FRAME_OVERHEAD;
> > +			bp =3D (unsigned long *)bp[0];
> > +			/* Represent interrupt frame with vector number */
> > +			return_addr =3D (void *)regs->trap;
> > +			if (depth + 1 < max_depth) {
> > +				depth++;
> > +				return_addrs[depth] =3D return_addr;
> > +				return_addr =3D (void *)regs->nip;
> > +			}
> > +		} else {
> > +			bp =3D (unsigned long *)bp[0];
> > +			return_addr =3D (void *)bp[2];
> > +		}
> > +	}
> > +
> > +	walking =3D 0;
> > +	return depth;
> > +}
> > +
> > +int backtrace(const void **return_addrs, int max_depth)
> > +{
> > +	return backtrace_frame(__builtin_frame_address(0), return_addrs,
> > +			       max_depth);
> > +}
>
> I'm about to post a series which has a couple treewide tracing changes
> in them. Depending on which series goes first the other will need to
> accommodate.

Yeah that's fine.

Thanks,
Nick

