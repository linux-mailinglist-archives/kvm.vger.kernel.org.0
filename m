Return-Path: <kvm+bounces-33063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 845A29E461C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0720B3B0E1
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3831A8F8E;
	Wed,  4 Dec 2024 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jtmcrmh0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106C826AFC;
	Wed,  4 Dec 2024 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733337465; cv=none; b=QkOq+HU7PhEfUzAdOiRE8fgsQM2b4Rg1p4HcLhb6ft8YF5jm2viIOF9EbNJxdo2321Wd78rEqLdvWuxRm9kupaGByvRp8mczxxuoGLLxFgEVWgyluYxvYF4HRX39TbtPPDHIVXuBWvfXQi+yDa3lOu81IrZr0xtG+WqYfEcaDy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733337465; c=relaxed/simple;
	bh=EWoaxKB0aLT9FeSkyV3o5lbx/1eDkyAsm3E8u52WkA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UJy2gt9r5lWaUo1ih7wMh6xop2oWmL2GAucOYbHEh8UrRxSaZysuloEZ6IwJziQ3owxVnNWDiEbtj6n1UjuJwPAj/bCjy3NAxXklupmNyTv3AGHDlb8oQPieQi51b3AxeK3LsFeY5+o/Z/TT3/Pj47X7yXu5pVIxgBS5CV+ayx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jtmcrmh0; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa549f2fa32so7459866b.0;
        Wed, 04 Dec 2024 10:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733337462; x=1733942262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWoaxKB0aLT9FeSkyV3o5lbx/1eDkyAsm3E8u52WkA8=;
        b=Jtmcrmh0XjHXgw49hYwpCBfDg9KS4fEG05Wc+iEDyTqEd0PjI7wV2FKZkOMu83ChDC
         WCzMGwETEtinJ27vI9FSQNMFS3u8Hjs5ROQlhlrc2f8CxmZNfMwSm9pvh4v1iLLTzc7e
         x4OAs1j6KpU3PJMI1X69NrgWcqU5TBq4o1TbGK08HFEFeExjUrXJ73KEMUpeEWsWq9NI
         L7u1j8VXSI3ynEN5JzdHBwHSQ4zfu9lHnN5Waon+iU2SWR3einiKIHw2su/ZeLdOtCrR
         ItvESQAJK7eEzMP3D1Mw2v/TwuSO8tUqQ0vXku3CyWQnD7XzQudOStwV5/odsGyc8Rdw
         GaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733337462; x=1733942262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWoaxKB0aLT9FeSkyV3o5lbx/1eDkyAsm3E8u52WkA8=;
        b=rDbMbbIGPVdYbbh6HRZZN6O3qzSFxWfoNnZ2YEHZEW65yBtJ8ci4OeA4eMTyldRwbM
         HjSKXuIt2wfFPQHwHDt9F/b9cW4ZU1R3lBQ27gWmH5lbkjbT4y5sThcSebAppxLD/+s1
         dhtBcy+HpszngKl0L4en159quCKi3Z9NT43BrHe7Qum2DVGopzVt40+ql4P5whaQmpF1
         3KhtYJamUu8vOgnuzPQltwsFPSkdUNxJd0gILTA9i86nfExbnryuu6p4SLqKtbGxoe4b
         DI9+ROwKJi1Mk0ENsKIXau2ki4HCRuIDVuASI4fzJKQWlvfbZy2Qw1dQrJXUSAYisUhM
         Lq7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVIyhWo1X2xgxe95c9dYaDjQGdYDZV6N9XlHkiPq7DAOsyD+LPI6sZZ6wVn2g0u7JjMxnFRvAHigTBOiueF@vger.kernel.org, AJvYcCWdcab2ln8lI8hZCozwCaI8fK3EvPBn4yy/9ipZhjtgykpmSAEI4Allhh28Zhhxz44+3Zs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+YR+XREJUdPGrvaAv0HoogBKYG5OgPE/rqOWYH9I0RTS9lMoW
	5snqTpTFGgGyZsjQ46FmCYhfZBpl/JZlxtwjZA2n181uUcXZaNWXszfEI8gs30/G4xho0QClQp7
	X7a54d4hQrtBho6wQqxo3GQ5uBqhG9QN9
X-Gm-Gg: ASbGncv0lMFGAGqz4LnaDHWV549bPY9i6dBen/YZm4PTPiapTmoPjPhV71qOUKsPsnV
	4AcQY/Anj8oCbxNR/0SzKTaH8VlyXu4Y=
X-Google-Smtp-Source: AGHT+IGN65+DQeAMrK1MI+RNcN/8L1Ag7BqGwZzompARXlNXFQAt1JXtVlCy9nUM2mDMbxPAiTYF7jhO9LABFugrSw0=
X-Received: by 2002:a17:906:23e1:b0:aa5:4adc:5a1f with SMTP id
 a640c23a62f3a-aa5f7da98eamr585181166b.33.1733337462261; Wed, 04 Dec 2024
 10:37:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org>
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
 <A0F192E7-EFD2-4DD4-8E84-764BF7210C6A@zytor.com> <13308b89-53d1-4977-970f-81b34f40f070@app.fastmail.com>
In-Reply-To: <13308b89-53d1-4977-970f-81b34f40f070@app.fastmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 4 Dec 2024 20:37:03 +0200
Message-ID: <CAHp75VfyBLTnY1kReQ-ALngWqPoyLaHhsmT1shR_UzpL8sK1UA@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>, Arnd Bergmann <arnd@kernel.org>, 
	linux-kernel@vger.kernel.org, x86@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 6:57=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Dec 4, 2024, at 17:37, H. Peter Anvin wrote:
> > On December 4, 2024 5:29:17 AM PST, Brian Gerst <brgerst@gmail.com> wro=
te:
> >>>
> >>> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
> >>> PAE mode is still required to get access to the 'NX' bit on Atom
> >>> 'Pentium M' and 'Core Duo' CPUs.
> >
> > By the way, there are 64-bit machines which require swiotlb.
>
> What I meant to write here was that CONFIG_X86_PAE no longer
> needs to select PHYS_ADDR_T_64BIT and SWIOTLB. I ended up
> splitting that change out to patch 06/11 with a better explanation,
> so the sentence above is just wrong now and I've removed it
> in my local copy now.
>
> Obviously 64-bit kernels still generally need swiotlb.

Theoretically swiotlb can be useful on 32-bit machines as well for the
DMA controllers that have < 32-bit mask. Dunno if swiotlb was designed
to run on 32-bit machines at all.


--=20
With Best Regards,
Andy Shevchenko

