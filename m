Return-Path: <kvm+bounces-66581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DFFB0CD80D8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8DB77301CE41
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C212DF15B;
	Tue, 23 Dec 2025 04:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbQUsYTj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A3F283FC5
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 04:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766464021; cv=none; b=cB4FAglW1pCvNyKyE7hlrow46nlZkkWGXAWwxHDxkvAzXemDvRPTbrfxl1rfK8DUS8zQyY7tE5FJu3kicCBP6JrECO515FUbK66ykkTlBkZATx1oSb0ib20s/M+Zs1Dfnm2XjWMbJ9kZUO7jAm/Dt5TEwfXV0wwk40i75wvYIy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766464021; c=relaxed/simple;
	bh=cGjT7byy5gtI85CR6/qpFC1uBi/VBOhtLeYdVe3nnJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aUcwuNDrHpW+S0iEY81N/KFkY1kn8ptnfwN0Nb/b94nmDoNP94ZsNYNyEzRsHEp8SmL30pKCSlatVoPv2B0Ryh5kEg5DajhnW50DFAnrzjVoQ3pbyuV5NwVcxPZvQZMb/F6ZY0EEiQPadImhkVNqpNYUgRV2oChyHxu6vOJ0HX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IbQUsYTj; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b83949fdaso5414070a12.2
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 20:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766464018; x=1767068818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJ3tD45XzcEgQ7T192a3IA07CG+ZNFQQuaZLudrMyQU=;
        b=IbQUsYTjvJjRcuzs88XwqegyNNuE1mcwe4YziHdUEsu/M5deILtJfAE8t+sf1/5D72
         7Ad+ypto0c0hDYhg/hP5/AnztMJJK/pmhRZG0QB4CjwLlcAJ96lhOgDgS/gkaCYfvzPp
         emPzAaI3zpK+CRU0NlDLkqyrfY/TNjbmJnMmm7nG0nSwnxOQYvxnZ1vlR7l3lR8O4nZD
         3ui/EbXWMPay4SKQC5DXz0URSbrWsKP9ixOfcMtRLCItp3/LV5+aZosEFwXdggxlw3t4
         gQgMDqLkYvo8YUHdCclT1AFtvQygqtybh8VTtRh01GdJzfo+18EvUE1+LdVi6enQOjMF
         mx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766464018; x=1767068818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YJ3tD45XzcEgQ7T192a3IA07CG+ZNFQQuaZLudrMyQU=;
        b=if+usNwc60F421FH5Ijp/H/gPl6BF0jT+GcAavLhhDzafABJFNFWav0ws/7D/dVUy9
         86+abtJmKvyxhH0a/rU0lzRIetGrmUiKLDTU5bI4sshxfc8jHqn1voK2JfzaAj2SbziA
         nlE7te9GQ1qfZh1kFp4J+s4rIL5QEW66i4xkhT3ml2HDsTeOaoiVrZlQT80u55HP+7hb
         xQEytRp5KEGpD1vxeJFLUV0K9FVyxL/WG6k0eJ2wK5BW7Lf5KToGkTJJJxjdDe0610/K
         nN9tKGBAp4BR3ukeXW5Zj488PmfE40ojgE2SR8gTz1E/YMKwBDFBibYFk3gvLMVmGvsj
         Ybdw==
X-Gm-Message-State: AOJu0Ywu+qKItljDqh0U7N0OsckQzkw5HstBttxN3pSd47MJvljfJZAw
	Rby6Cy3xk7YodXjM6Bun07JqDqeR+sK7bZCvO6YDWUmPdAXVzEEBqRtYyq9L9L2u/yd730A5Ek0
	sMsApKf9vGWKNDGJ6HZoggOkGo7QBoXWpYb/46l8=
X-Gm-Gg: AY/fxX7rnF1OobRoYvvaK8vL+2q63Sqy5X9MVEac2ELM3sEMivjgfc7D2QIdUx5eoSP
	1qZXFqLqp6BB69k9HkGG9v28AXOq9m2rXjTh3BJwQNc/TtfkbG+ImizyzeE8H4XKvUMvaKU5U43
	z3bGnEC+Nl0E4StUm2brnSxt79PDnMnioZo+P8qSf8+YNkPgm5SkzY7I1A7YkpH7v2wPKK/PcPY
	RDxBkqNQIBF+o2eYho2t+UfOAQx1j4N46wCCGhOTPfLANOVUlx3o/12NSykERJPbdB9C3Tp1qGb
	MEuu
X-Google-Smtp-Source: AGHT+IEPyqsPeO6aTr7a1+qa+IWvSutJ6bA8q2StoHYn3dgBycTBccwz4+G2cUxDQyQ/460kIBB6sDviCRGemuCxf6c=
X-Received: by 2002:a17:907:86a4:b0:b7a:6178:2b4a with SMTP id
 a640c23a62f3a-b8036f2ae4cmr1483447466b.26.1766464017487; Mon, 22 Dec 2025
 20:26:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251213150848.149729-1-jamestiotio@gmail.com> <20251222-4edd14c1464744ef9e24245d@orel>
In-Reply-To: <20251222-4edd14c1464744ef9e24245d@orel>
From: James R T <jamestiotio@gmail.com>
Date: Tue, 23 Dec 2025 12:26:20 +0800
X-Gm-Features: AQt7F2p8Lq_3pLPWCZGwO3DzpJjCobA3X5LEm--Rh0O0jr86bUAg0GosKKLbco4
Message-ID: <CAA_Li+srDoyr9eOqexHejviZddXPeq0eFjnf32OnGa_WPykQiA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] riscv: sbi: Add support to test PMU extension
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 1:25=E2=80=AFAM Andrew Jones <andrew.jones@linux.de=
v> wrote:
>
> On Sat, Dec 13, 2025 at 11:08:44PM +0800, James Raphael Tiovalen wrote:
> > This patch series adds support for testing most of the SBI PMU
> > extension functions. The functions related to shared memory
> > (FID #7 and #8) are not tested yet.
> >
> > The first 3 patches add the required support for SBI PMU and some
> > helper functions, while the last patch adds the actual tests.
> >
> > James Raphael Tiovalen (4):
> >   lib: riscv: Add SBI PMU CSRs and enums
> >   lib: riscv: Add SBI PMU support
> >   lib: riscv: Add SBI PMU helper functions
> >   riscv: sbi: Add tests for PMU extension
> >
> >  riscv/Makefile      |   2 +
> >  lib/riscv/asm/csr.h |  31 +++
> >  lib/riscv/asm/pmu.h | 167 ++++++++++++++++
> >  lib/riscv/asm/sbi.h | 104 ++++++++++
> >  lib/riscv/pmu.c     | 169 ++++++++++++++++
> >  lib/riscv/sbi.c     |  73 +++++++
> >  riscv/sbi-tests.h   |   1 +
> >  riscv/sbi-pmu.c     | 461 ++++++++++++++++++++++++++++++++++++++++++++
> >  riscv/sbi.c         |   2 +
> >  9 files changed, 1010 insertions(+)
> >  create mode 100644 lib/riscv/asm/pmu.h
> >  create mode 100644 lib/riscv/pmu.c
> >  create mode 100644 riscv/sbi-pmu.c
> >
> > --
> > 2.43.0
> >
>
> Hi James,
>
> Thanks for posting this. I'll look at it as soon as possible, but I'm
> juggling some other stuff right now and also plan to be on vacation for
> a week starting tomorrow.
>
> Thanks,
> drew

Hi Andrew,

No worries. Feel free to look at the series whenever you manage to
find some time to do so.

Best regards,
James Raphael Tiovalen

