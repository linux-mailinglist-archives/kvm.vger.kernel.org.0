Return-Path: <kvm+bounces-18634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7B78D816C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A481F1F245AB
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9370184DE8;
	Mon,  3 Jun 2024 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="VaId9LVd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466BB84A51
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414824; cv=none; b=lGBaSLHplSzTVFs4Jv1SOWsmTnc7J2qC29oQAWk1UPpEPUG8XrG5AWBjo8mKkj5pKWkUG95k2roBwB6lLEXpoWwvBcXyAnowxmu1KXVx/nv6KTXjXfgyic050JDI0GnP1mLqLL4wh6uyWn+PaWNo6Xvrr+RoQQZK8ZZzHeVIYKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414824; c=relaxed/simple;
	bh=RRaEqV7B8iSS7qa/pDOAH3MqYofRF4D4b2oFQnNTQJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DIp416/vIhSQSLxkCPjvo1RH/h4jcAAtfyTVh4jAqmKDj/dFTTRHFzdaGXw5dpP0k9e5EOWZd46KxvRbO+N2DG8my8qQChg3AMQ9EYQdA+XENaM/kNWm6B1V/fhxqOCTpcO+iOUd3ALYcaPcWEZGO4Met0aOyJGLa49B2Vk6Rpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=VaId9LVd; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7eae92e7b5aso191580739f.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717414822; x=1718019622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jznY1UA7/SXmEB87TeYXPvswNX7BAys1PkdQILLo1MY=;
        b=VaId9LVdcP8LsNBrkeurRiOKNXEeqoKTLyB33jLyIdn7O6HtYPBK04OiLmDKAy8Lvl
         6XK1tuQtJ5WlNjFpJJ1Xv7+PWr+J1vN5IWD6wp3oOhvx0+jQKCyLkelGK/r9yA09NkRG
         NqOdZ0QaB+F3JaJmlsxspw/4SDd5kmNb/TMCk344ElII/IND2ynqo8KyTfSZDrhv719B
         OuSiUqmbgCYkNtH0JHvMMupYxEoO2IesBrecObvfRp2OmtiXPQDcIw8K/asHrpcafQ8h
         5a0jtAWJ1xt8XIemoN+ldxTsCVBeIK7Cy9touYQwr717IUjBq0E0jBdXMg4VDJxNwQHC
         usVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717414822; x=1718019622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jznY1UA7/SXmEB87TeYXPvswNX7BAys1PkdQILLo1MY=;
        b=LP72YZXDsOQwsss29A6p1HbHwTgOE5A5ZgXgDaRua+BbbUJWeRerQH+yaMTJdYDpQW
         VEHerhDr3mTJbuenFdNd3BYWQOs5COzNztHIIwz/saCcq0qdjbruQrYhJch/ZT8VkNmE
         lib4Wl2IAWO9XAUnlEBD+KsLCLlwzgDcd97jghtHWIFhiAPCFpKoUKlyS8XLkMTyZSZ6
         k0VNOxHHsi3gOWyVQuy9MFf9MzFnMrolfRWPUg0gacXSBlUw5aNiEyH81gtdVOEYhNM5
         2JILpNOugVTxgbLGHxkm33IC8k9rpTc6KDiVb8TO1YrC673OkwHW+nGqVO9CAPjHWf+h
         VCaA==
X-Forwarded-Encrypted: i=1; AJvYcCW0xIkA7AnhjzJe6UpDvNwz9mzVQau5RTiQGwgxuSbUnX3H0couTobc8Zj+TiCQV3CuzIlRrxmischTF4Za2GKjsu94
X-Gm-Message-State: AOJu0YxFS/szzkQGqsE2QiwVX/ZHOmfN8q9k1DGVjMzRafgN79mSQWsx
	QgPvMhIbeAg/f9cfH46BVYzK5J+LVIz6ZyNqgbe4i6yrNke2YwUvhvwCJ88tO/h42YrFM8WStbn
	Db/y6CVpSSLIdw6z7GEqSFxY7XFf71xtIpJTuvg==
X-Google-Smtp-Source: AGHT+IGJ9Mvf8z85SE/NFg8HuQmyPGDBsDk+Yroy5ITFqpG+kRyKvmd5ME6X9GIu0azVzqIEgdBbQinMEvImFyXLYtw=
X-Received: by 2002:a05:6e02:216a:b0:374:9995:b369 with SMTP id
 e9e14a558f8ab-3749995b506mr46562275ab.4.1717414822141; Mon, 03 Jun 2024
 04:40:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com> <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
 <ec110587-d557-439b-ae50-f3472535ef3a@ghiti.fr> <20240530-3e5538b8e4dea932e2d3edc4@orel>
 <3b76c46f-c502-4245-ae58-be3bd3f8a41f@ghiti.fr> <20240530-de1fde9735e6648dc34654f3@orel>
 <f2016305-e24b-41ea-8c48-cfdeb8ee6b48@ghiti.fr>
In-Reply-To: <f2016305-e24b-41ea-8c48-cfdeb8ee6b48@ghiti.fr>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 3 Jun 2024 17:10:10 +0530
Message-ID: <CAAhSdy2dJaNWYH88RhjiUktX5n4-ZfFuXsjyYeJ-+Y8qOf7zRA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension Support
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Jones <ajones@ventanamicro.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	cleger@rivosinc.com, Jinyu Tang <tjytimi@163.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor.dooley@microchip.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Samuel Ortiz <sameo@rivosinc.com>, Evan Green <evan@rivosinc.com>, 
	Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Jisheng Zhang <jszhang@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Charlie Jenkins <charlie@rivosinc.com>, 
	Leonardo Bras <leobras@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 4:59=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> On 30/05/2024 11:24, Andrew Jones wrote:
> > On Thu, May 30, 2024 at 11:01:20AM GMT, Alexandre Ghiti wrote:
> >> Hi Andrew,
> >>
> >> On 30/05/2024 10:47, Andrew Jones wrote:
> >>> On Thu, May 30, 2024 at 10:19:12AM GMT, Alexandre Ghiti wrote:
> >>>> Hi Yong-Xuan,
> >>>>
> >>>> On 27/05/2024 18:25, Andrew Jones wrote:
> >>>>> On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
> >>>>>> Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
> >>>>>>
> >>>>>> In this patch we detect Svadu extension support from DTB and enabl=
e it
> >>>>>> with SBI FWFT extension. Also we add arch_has_hw_pte_young() to en=
able
> >>>>>> optimization in MGLRU and __wp_page_copy_user() if Svadu extension=
 is
> >>>>>> available.
> >>>> So we talked about this yesterday during the linux-riscv patchwork m=
eeting.
> >>>> We came to the conclusion that we should not wait for the SBI FWFT e=
xtension
> >>>> to enable Svadu but instead, it should be enabled by default by open=
SBI if
> >>>> the extension is present in the device tree. This is because we did =
not find
> >>>> any backward compatibility issues, meaning that enabling Svadu shoul=
d not
> >>>> break any S-mode software.
> >>> Unfortunately I joined yesterday's patchwork call late and missed thi=
s
> >>> discussion. I'm still not sure how we avoid concerns with S-mode soft=
ware
> >>> expecting exceptions by purposely not setting A/D bits, but then not
> >>> getting those exceptions.
> >>
> >> Most other architectures implement hardware A/D updates, so I don't se=
e
> >> what's specific in riscv. In addition, if an OS really needs the excep=
tions,
> >> it can always play with the page table permissions to achieve such
> >> behaviour.
> > Hmm, yeah we're probably pretty safe since sorting this out is just one=
 of
> > many things an OS will have to learn to manage when getting ported. Als=
o,
> > handling both svade and svadu at boot is trivial since the OS simply ne=
eds
> > to set the A/D bits when creating the PTEs or have exception handlers
> > which do nothing but set the bits ready just in case.
> >
> >>
> >>>> This is what you did in your previous versions of
> >>>> this patchset so the changes should be easy. This behaviour must be =
added to
> >>>> the dtbinding description of the Svadu extension.
> >>>>
> >>>> Another thing that we discussed yesterday. There exist 2 schemes to =
manage
> >>>> the A/D bits updates, Svade and Svadu. If a platform supports both
> >>>> extensions and both are present in the device tree, it is M-mode fir=
mware's
> >>>> responsibility to provide a "sane" device tree to the S-mode softwar=
e,
> >>>> meaning the device tree can not contain both extensions. And because=
 on such
> >>>> platforms, Svadu is more performant than Svade, Svadu should be enab=
led by
> >>>> the M-mode firmware and only Svadu should be present in the device t=
ree.
> >>> I'm not sure firmware will be able to choose svadu when it's availabl=
e.
> >>> For example, platforms which want to conform to the upcoming "Server
> >>> Platform" specification must also conform to the RVA23 profile, which
> >>> mandates Svade and lists Svadu as an optional extension. This implies=
 to
> >>> me that S-mode should be boot with both svade and svadu in the DT and=
 with
> >>> svade being the active one. Then, S-mode can choose to request switch=
ing
> >>> to svadu with FWFT.
> >>
> >> The problem is that FWFT is not there and won't be there for ~1y (acco=
rding
> >> to Anup). So in the meantime, we prevent all uarchs that support Svadu=
 to
> >> take advantage of this.
> > I think we should have documented behaviors for all four possibilities
> >
> >   1. Neither svade nor svadu in DT -- current behavior
> >   2. Only svade in DT -- current behavior
> >   3. Only svadu in DT -- expect hardware A/D updating
> >   4. Both svade and svadu in DT -- current behavior, but, if we have FW=
FT,
> >      then use it to switch to svadu. If we don't have FWFT, then, oh we=
ll...
> >
> > Platforms/firmwares that aren't concerned with the profiles can choose =
(3)
> > and Linux is fine. Those that do want to conform to the profile will
> > choose (4) but Linux won't get the benefit of svadu until it also gets
> > FWFT.
>
>
> I think this solution pleases everyone so I'd say we should go for it,
> thanks Andrew!

Yes, this looks good to me as well. The key aspect is documenting
the behaviour of these four possibilities.

Regards,
Anup

>
> @Yong-Xuan do you think you can prepare another spin with Andrew's
> proposal implemented?
>
> Thanks,
>
> Alex
>
>
> >
> > IOW, I think your proposal is fine except for wanting to document in th=
e
> > DT bindings that only svade or svadu may be provided, since I think we'=
ll
> > want both to be allowed eventually.
> >
> > Thanks,
> > drew
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv

