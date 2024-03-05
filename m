Return-Path: <kvm+bounces-10862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C87B1871424
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 04:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F0961F250F9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1BC2942C;
	Tue,  5 Mar 2024 03:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JOm0gI8q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A4917C6C
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 03:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709608221; cv=none; b=MuEWwWRbwu+scrkuL/uZUXDbOx08CWeBfuhTt3OiKNppKHArYFaRLXSKL9N6Ecn2Ff8ada4w/XHq3tbB2gZlWx6hX3RBCWmt/4G6XkBiMfylCKPDc2ia41m3Cy/ls+N9kWglFB/9SrXQ1p45TEwbZ30inFqc/unoo9owd+92vCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709608221; c=relaxed/simple;
	bh=WeEgENVkgj4FbzgvewclCT729n9kD5VPiZmZZtVrPsI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ukZy+DI7g2m5Hwh2zdrbgVUi8hUa1Tcd+tKP4H0X3xAK0wbp0TRmctPcHralX7tUfwb4YYksgsJOhXs1J/mbYmgSaYmAgUL2WM3Prgnq5i7Kc30nzBUdP3h617rB+7ZaGy7jwY2QnEB+EaCK774ABEgEvCIaqzU8SkgoNIvOJDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JOm0gI8q; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-412a2c2ce88so22245e9.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 19:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709608218; x=1710213018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvn3MANUj/EZDfhu91vd14pnU3eGW+Y5/g+sIiJa3c8=;
        b=JOm0gI8qa8J/YyxcqLC5/zUbDEYMXQbSiFTxid1xic7aqEQRRsnAb83eQZRauwBpyw
         emWxdDMm6xmWnTcw21CyyCDjbTlSCfYMZMkawb9vCY0spHBw5bAdYtJLHViTEyK4r/EF
         s8LLID4omDoLJ7p4zwxWScYjN8g7UWRL2Ddy/unPLBQhtjI42ZTnQz2a7jy7YZStXlin
         n1pVP+NwkHqplH0C9TvCI3XVJ24CuGE1hS0f9Nc1XIzJ4xD58QHLgAG78NSRMVz7hi8e
         NtdCyBUAqEgob46T/Qn94F6hsH0E6+nuzTW7kN1eSS1ZRuHLXzA5JjtzWT0HQ3K5f3sq
         lxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709608218; x=1710213018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvn3MANUj/EZDfhu91vd14pnU3eGW+Y5/g+sIiJa3c8=;
        b=JQMYg3ExkSmvN69pjiLi3+KcJKdxI7zX+9LVvi5RlJY8IC4hlmm4dF9CHQniXNBgHl
         96EVNKK9W/5xzcqi9QmCbaYOr91ztrlTz21zinxIVO5iHtOqFkZwNvjlPKYVz78A4QEp
         o8qnpdbB0USyW4eNQ2dV8vsbKTCkClCsuHSSA6oNaLalQxHYZB93U82Tj6Qxu15qxFRW
         7mUxf32bFYXvR2TVrelIwLp4iP6lIFwFC0Cr9pbrkWDT8P6DWPZ508KW7s8FawUt2HSl
         tGEFOQLL3cCGWRq8/V5BAwsv0CLx67LutUJHxNgGP/SEvLawOoM+j1N++JiiZ4YZTTYA
         PaCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvE0c5+sp3xAee0qxHUIRKTI+8XNLpnSAsbNPNyXMjDQnhC5BOKhV0FF7inwaVlCduMRkB1Tjk53WopOrzrBieoz9p
X-Gm-Message-State: AOJu0Yy/EjH1GwHXwYeY5XsdfL2ygHN873WTI135GcNveQ0lbk9u13qA
	KEwuZZ3MZkn+Sl63FzndCxott8BE82QKB2HU0CVB/adppJPdbFGkMTUAyMqUnf4WmZtSAHOIIrR
	dXi/QDlMYfOsW/KyAJWxfNbCCSXpj4yrMRRrXUdgpgRX4Hw57Akui
X-Google-Smtp-Source: AGHT+IHZdBV4XvLVjH2kYHplMlzfwvFzrZsluNZicC+ljUyG4+mrtZOBsCtDakMRE5TO1oiZkqqfMbCk0kJfLUeMUAE=
X-Received: by 2002:a05:600c:4c11:b0:412:e4fc:b10 with SMTP id
 d17-20020a05600c4c1100b00412e4fc0b10mr13995wmp.3.1709608218354; Mon, 04 Mar
 2024 19:10:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <39E9DB13-5FA3-4D1A-A573-7D58BA83B35C@fb.com> <20240304145932.4e685a38.alex.williamson@redhat.com>
 <51e57a7c-c8a1-4a18-a08b-d2c8fd5b35b3@redhat.com> <383DC340-967F-454A-B298-C59B3F70B63C@fb.com>
In-Reply-To: <383DC340-967F-454A-B298-C59B3F70B63C@fb.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 4 Mar 2024 19:10:04 -0800
Message-ID: <CALMp9eRwTEMUy+u-03U8Y20ez5_nyD=XA6Hs=OJYN2Pe80ms9A@mail.gmail.com>
Subject: Re: Why does the vmovdqu works for passthrough device but crashes for
 emulated device with "illegal operand" error (in x86_64 QEMU, -accel = kvm) ?
To: Xu Liu <liuxu@meta.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 6:11=E2=80=AFPM Xu Liu <liuxu@meta.com> wrote:
>
> Hey Alex and Paolo,
>
> I saw there is some code related to AVX  https://elixir.bootlin.com/linux=
/latest/source/arch/x86/kvm/emulate.c#L668
>
> Does that mean in some special cases, kvm supports AVX instructions ?
> I didn=E2=80=99t really know the big picture, so just guess what it is do=
ing .

The Avx bit was added in commit 1c11b37669a5 ("KVM: x86 emulator: add
support for vector alignment"). It is not used.

> Thanks,
> Xu
>
> > On Mar 4, 2024, at 6:39=E2=80=AFPM, Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> >
> > !-------------------------------------------------------------------|
> > This Message Is From an External Sender
> >
> > |-------------------------------------------------------------------!
> >
> > On 3/4/24 22:59, Alex Williamson wrote:
> >> Since you're not seeing a KVM_EXIT_MMIO I'd guess this is more of a KV=
M
> >> issue than QEMU (Cc kvm list).  Possibly KVM doesn't emulate vmovdqu
> >> relative to an MMIO access, but honestly I'm not positive that AVX
> >> instructions are meant to work on MMIO space.  I'll let x86 KVM expert=
s
> >> more familiar with specific opcode semantics weigh in on that.
> >
> > Indeed, KVM's instruction emulator supports some SSE MOV instructions b=
ut not the corresponding AVX instructions.
> >
> > Vector instructions however do work on MMIO space, and they are used oc=
casionally especially in combination with write-combining memory.  SSE supp=
ort was added to KVM because some operating systems used SSE instructions t=
o read and write to VRAM.  However, so far we've never received any reports=
 of OSes using AVX instructions on devices that QEMU can emulate (as oppose=
d to, for example, GPU VRAM that is passed through).
> >
> > Thanks,
> >
> > Paolo
> >
> >> Is your "program" just doing a memcpy() with an mmap() of the PCI BAR
> >> acquired through pci-sysfs or a userspace vfio-pci driver within the
> >> guest?
> >> In QEMU 4a2e242bbb30 ("memory: Don't use memcpy for ram_device
> >> regions") we resolved an issue[1] where QEMU itself was doing a memcpy=
()
> >> to assigned device MMIO space resulting in breaking functionality of
> >> the device.  IIRC memcpy() was using an SSE instruction that didn't
> >> fault, but didn't work correctly relative to MMIO space either.
> >> So I also wouldn't rule out that the program isn't inherently
> >> misbehaving by using memcpy() and thereby ignoring the nature of the
> >> device MMIO access semantics.  Thanks,
> >> Alex
> >> [1]https://bugs.launchpad.net/qemu/+bug/1384892
> >
>

