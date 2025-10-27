Return-Path: <kvm+bounces-61183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBA3C0F2B2
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B556519C0C88
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD382877D2;
	Mon, 27 Oct 2025 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ww4P3DE7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1B630C37A
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761581054; cv=none; b=gOqILSpZc6346GKOv50emnuoTFd6NaVbhZ0y0hsCdUBJFmVLxyzCXvwpJ98JlQoLK/JuW3CvOgoux3E2Hx9QKNC8eMsRkO36QCc6SdDsK71mGiadfpDF9fkhdlegnHTDtdKAFPAJPjs5VArAcxYHHriHMPNgo9HCW2oG9ZUjYVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761581054; c=relaxed/simple;
	bh=DYNT/VChXtqrA2sDhHO3vFbenRYCP9kylJFBh2XvWzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uYhOcT+PYjEBzz8/oQmtUClFjNy24+jAFqZWmSoN/p7t4ZfZAUEbHeOQaV7Zk6uwb604eXeLvHi2nEd/rXvJ6xvW6koGcKlJIwt7e+Ck1yHG7Q7gtn2cjOGUDquHFJ9iktfTfJxHqvLNh1d1g4SmPjv5mDFJfIH8V/AsS1Q2pXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ww4P3DE7; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-378cfd75fb0so51896261fa.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761581051; x=1762185851; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpFhVdVLgSZYYPYkv9Xm+ppo7V2oCjM7bP0bHDIGOyQ=;
        b=ww4P3DE7nlxkXwimf803r5KuGrtcr9I8YBO4BjBHZGIUdG9ORfyxPgbbFAS9Wg2xcb
         +MTX3PGI46Bob64+S7ccqkBAUnE4YQSS0MTmQiaPfaH+jUq514H3IRW98wambuAAKj9G
         uM0TxE6ErPmaVkcKhzTr60lTnikKoYh1X2r2VBH14q23HsW2Ne9QaxRbEOeWm0Tt/mH4
         BHaJuSwHtGPwpeYhFmCK1aYqb5WWlTiffaJcf0G/6ZCboZZ2/RbGkDtcUhT8K88Sw25M
         EXDzNxeOmEm3gjVnuU8Yyh2ueQNQSR+geh1OF9GjBwdcMABZseMUfSvU7FtVxFYKeTxy
         B+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581051; x=1762185851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zpFhVdVLgSZYYPYkv9Xm+ppo7V2oCjM7bP0bHDIGOyQ=;
        b=TwmGzzHbDV6RwuBCY/Bjhx+9QLhkXa0ualnEcNmWIrHJv52WkAkMF/BD8npUxuHdeT
         7tCYu/QY39p0191Qzm7w/h4RQeusT9RHeSP9iMKeikCURS9K+FuBhv4GyPF/8159+CCX
         zKCyjvyi8c2OQxPr8MpOabnkgYoBJalxE/DUsW/XKR9DIwfnnk9rdI+qNAstH16V+6we
         Hdj0x+GIrQ3dj012HNHuF1eMpqDvAN2wDRiqFiKVW3MJwqjOUJInlsjD09/uXGCMFMVh
         DwrVOOorBMHgQ3U7Vo7gAC2ypQK4GzJBjIMvz33ZEMYCZeAaH/8yzjlEPiBDyWmbmtrZ
         kGeA==
X-Forwarded-Encrypted: i=1; AJvYcCVgYVqYTCPjqR48kpZzVUFnHpf/esDCicOjz9L+c/1qyhjQ/zABM6209YI7dF8DLQrQbe4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3ttvdgGstfK/D6rU4pZnJGPsRS8IrStogrTX7IZn4XpyHrLE9
	Cl7HtpLEv7aEhG9lgLGqb5scsLNpRCS5nWaNwYvgJpV2+egh8ZCSMCVVv1RGLDNikl/6NqdcE6l
	q1+yzwdzZbkTcxxyTJzYXbCPy0tutOefaqxT6PXknrArJyTrUIXWP2XOT
X-Gm-Gg: ASbGnct309t/pPvJuXptUeiWCLSeO2UV8TbqldIqEQTAY29tH9nBAJfso1HywFI/hXc
	yr319W3ylalXp03WCX6xNBMrSJHb/25ca1sD+5n+ch1wecExeu8FPMW1djwqFhU7uvNcGpfCA7t
	qh32P3QzqsXqWxpSwGO9XJnxXDL+nYf7Rvp3Ttmg663aAJ/oAJ4lkZJoljEimf64o1WCXdYAHLl
	g0yMj4w1a57BTa2CGAp8QKOURJMubguAMdpgXMsQIs5MWBhbvc8HPmmQeMI
X-Google-Smtp-Source: AGHT+IGoyTJm1oNUabEtAi7wxqKURcM0enDsqYKsw16P6RtMS3jkqu5ZA5d/yjT+nSCfooYWA3/HvqAjzrQjRYaNIg4=
X-Received: by 2002:a05:651c:3248:20b0:378:df5b:fbb8 with SMTP id
 38308e7fff4ca-379076dadb1mr459301fa.19.1761581050530; Mon, 27 Oct 2025
 09:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912222525.2515416-1-dmatlack@google.com> <aP-ULL69aQfCOwCb@google.com>
In-Reply-To: <aP-ULL69aQfCOwCb@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 09:03:41 -0700
X-Gm-Features: AWmQ_bm4QqK0xoOsZ6a7g1Ai6-HjU7xmmVDri0NNObOO-yyk5EMmALHZgIe_pdk
Message-ID: <CALzav=dTcRmF3UAYJNGNoG0D5e2GPmwavt8hM_ovfZrKXjO3vA@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Link with VFIO selftests lib and test
 device interrupts
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 8:47=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Sep 12, 2025, David Matlack wrote:
> > This series can be found on GitHub:
> >
> >   https://github.com/dmatlack/linux/tree/kvm/selftests/vfio_pci_irq_tes=
t/v1
>
> ...
>
> > David Matlack (2):
> >   KVM: selftests: Build and link sefltests/vfio/lib into KVM selftests
> >   KVM: selftests: Add a test for vfio-pci device IRQ delivery to vCPUs
> >
> >  tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
> >  .../testing/selftests/kvm/vfio_pci_irq_test.c | 507 ++++++++++++++++++
> >  2 files changed, 512 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/vfio_pci_irq_test.c
> >
> >
> > base-commit: 093458c58f830d0a713fab0de037df5f0ce24fef
> > prerequisite-patch-id: 72dce9cd586ac36ea378354735d9fabe2f3c445e
> > prerequisite-patch-id: a8c7ccfd91ce3208f328e8af7b25c83bff8d464d
>
> Please don't base series on prerequisite patches unless there is a hard d=
ependency.
>
>   ffdc6a9d6d9eb20c855404e2c09b6b2ea25b4a04 KVM: selftests: Rename $(ARCH_=
DIR) to $(SRCARCH)
>   9dc0c1189dfa1f4eef3856445fa72c9fb1e14d1c Revert "KVM: selftests: Overri=
de ARCH for x86_64 instead of using ARCH_DIR"
>
> By all means, do testing on top of such patches if that's what your envir=
onment
> effectively dictates, but rebase/drop such prereqs before posting, as the=
y add
> noise and friction.  E.g. these patches don't apply cleanly on kvm-x86/ne=
xt due
> to the prereqs.

Makes sense. I will send patches applied without prereqs specific to
my environment next time.

