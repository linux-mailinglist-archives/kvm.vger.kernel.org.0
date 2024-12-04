Return-Path: <kvm+bounces-33039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 674139E3D86
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B27C2163E9B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A079A1F7070;
	Wed,  4 Dec 2024 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQjJmUaT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B771B21BA;
	Wed,  4 Dec 2024 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733324463; cv=none; b=WXcSQZWsJaGzidihEf/LzZAQkdBB9UVA+kB/6xbd+E+GjDzOtk6+gmZGib8Uykjw5R20OrsmyosP7LOSmruvflrQz0SmzNieJMht25tKlga55EyBQwo3bJUfHvd5fORy25psRtB1ku8gDn44OWqt4qewa681c+u2IDn7vVrFqTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733324463; c=relaxed/simple;
	bh=WGya6tZYlOrAb1I6ImJYl0uIMnBGiv4hsZiyCqgd15Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D4wmt3VluOcy2XeO5+FuuNh0b7V41tvECbqtPyyxGcdIylQFfsqLuwKS4YbQ22hEEe/QnWow9S9fd5ynllbJ4sj+w6NKY1776QkCUuH+E6HBm/3e6OHkkiUnlspnXMQpfTxP3DwhHAxvpEofPDfdKRgOgsDogsHZ7SehWFf58iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQjJmUaT; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53df1d1b726so8336402e87.0;
        Wed, 04 Dec 2024 07:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733324460; x=1733929260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAYfoe7YxaLLp79KiNTGPQN0mL7BqRD1Ol2OVwMDpXw=;
        b=ZQjJmUaTjT1qc/z4MaajOA6nHGADChEszAlyenw+GfXM/hZ5SADwd2+VQqcr61IWLf
         O7fOTnlbiAsndIIhLWV6O4RiqG7Baem2XFJeGpX15LMxYwoU/FiSG6SJ3vrRYnHNmm9r
         QJphtXjOaB+7gN763tCChfwZDRKqUClCp6kYP9o4cuB8O9tT8QW8d1FF++CRYQ0TWCq5
         wcyoSb6AnTFOmxUoGNR34HhO+2cY6gyc66HtJVMvs34AkXm8KT0y6Rd8u00DccDUC+eI
         kq6Q8SjBPzNg186ELAEHW9G3smN+0Ye4V0dDhDvS+zXUawGJEXckeDfZHxRR+e9aJkXi
         N88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733324460; x=1733929260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAYfoe7YxaLLp79KiNTGPQN0mL7BqRD1Ol2OVwMDpXw=;
        b=k1w9vphDL72Pf1IUXUrE7Sf11otx24w2VYD8QLzKZz8M7S5OKfOb0mKTQacj40/P/J
         cs7TXlXNP4SlRJB3h2JBZANKFivZmAtjo9Jbihk8sOfZvnDF53wZW7eteJHKR1j9XdIT
         f2tRo+UsDMU0hT+nVYnj0eqdkSVKX0xZDFOIaKgMIUuPn9lo+i/545ToQ5BGleWNti66
         HdINiLmOaPBNFW7VvTEaCkPYZpbv/xUcZJjAiYbIFz2LnyDN0WVrNLNUZU+4BpeXCaaF
         +a9/S/dMY6+Y8cosP1AG6X/kjdIcydPbXzrwqU5XJRTSDRMdNjACA2b3doVn6IwE2Nze
         Ozjg==
X-Forwarded-Encrypted: i=1; AJvYcCWTk5rbjn1QqaY4q12Twd0Wo47jsVPCJLZnlHh/hNIW+DRJLQ17frMBQip4LzUAcoajRl0=@vger.kernel.org, AJvYcCXMJHacLmyc3AZmXSxXfJo4V5kM57qD2uf9mJGRQut8A4Fjr0XeYz3BRBAKI69dI+kOSG5YLy67XbiobeFN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6GPgUnk8wxu5N/YorXmWbBpeioWQq/I/4eujxpadtELaWXPNS
	JOmzMJxWq8JNrJxKimbOclx1rn2R8/go0V7If7+3yynK0ibC+jNrzQUOyPTvo7jkotJuO3ha2UP
	Se2H1ITWJbLvFJw3uDVORc/CZlQ==
X-Gm-Gg: ASbGncsswIkQ+Td/xs6+BYcszwlZJc/Dt/KSysIZCrrYa11r6vHnFjSDVPl8bi8Q/ym
	pA21ua2vzuoRy3Jhq5e6j2mhGHBFNo8KmfbWFIqnxCQ+FHg==
X-Google-Smtp-Source: AGHT+IE9yu189cldcYdGXhKzLCVnldkK7OU6Uyyi6xPi54jzRMCQIhG/ltnwFk0bt4xIPAue41I5qib7x2Abr7wU3HA=
X-Received: by 2002:a05:6512:3f0e:b0:539:905c:15ab with SMTP id
 2adb3069b0e04-53e12a01745mr4625177e87.32.1733324459590; Wed, 04 Dec 2024
 07:00:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org>
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
 <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com> <CAMzpN2gTUks3K3Hvwq3MEVBCN-9HHTLM4+FNdHkuQOmgX0Tfjg@mail.gmail.com>
In-Reply-To: <CAMzpN2gTUks3K3Hvwq3MEVBCN-9HHTLM4+FNdHkuQOmgX0Tfjg@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 4 Dec 2024 10:00:48 -0500
Message-ID: <CAMzpN2iAWnq_RNaoCHYLD0bh2HskZjXWD+RGPmpDigvWtOXekA@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 9:02=E2=80=AFAM Brian Gerst <brgerst@gmail.com> wrot=
e:
>
> On Wed, Dec 4, 2024 at 8:43=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrot=
e:
> >
> > On Wed, Dec 4, 2024, at 14:29, Brian Gerst wrote:
> > > On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel.org=
> wrote:
> > >>
> > >>  - In the early days of x86-64 hardware, there was sometimes the nee=
d
> > >>    to run a 32-bit kernel to work around bugs in the hardware driver=
s,
> > >>    or in the syscall emulation for 32-bit userspace. This likely sti=
ll
> > >>    works but there should never be a need for this any more.
> > >>
> > >> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
> > >> PAE mode is still required to get access to the 'NX' bit on Atom
> > >> 'Pentium M' and 'Core Duo' CPUs.
> > >
> > > 8GB of memory is still useful for 32-bit guest VMs.
> >
> > Can you give some more background on this?
> >
> > It's clear that one can run a virtual machine this way and it
> > currently works, but are you able to construct a case where this
> > is a good idea, compared to running the same userspace with a
> > 64-bit kernel?
> >
> > From what I can tell, any practical workload that requires
> > 8GB of total RAM will likely run into either the lowmem
> > limits or into virtual addressig limits, in addition to the
> > problems of 32-bit kernels being generally worse than 64-bit
> > ones in terms of performance, features and testing.
>
> I use a 32-bit VM to test 32-bit kernel builds.  I haven't benchmarked
> kernel builds with 4GB/8GB yet, but logically more memory would be
> better for caching files.
>
>
> Brian Gerst

After verifying, I only had the VM set to 4GB and CONFIG_HIGHMEM64G
was not set.  So I have no issue with this.


Brian Gerst

