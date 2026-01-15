Return-Path: <kvm+bounces-68108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30608D21F14
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55E9F30386AF
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3601023B628;
	Thu, 15 Jan 2026 01:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaLbSVOa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161AA21B9DA
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439482; cv=none; b=uqtP0u6gGy38WQu82OVS85Ifa+uxpFXogOkUq4Wwr3ycMYc/DtFnIiqn5tYD/v4d6rdQ1mvo7avJQ5hXL243gEwI0QxK7UUqtAMzAuNa1ATh1PrQF/TBh6caAsiNDYdAdzC6KQgeFyRhOpCKKMXnNfhGEmHzw2+rJEDO9Bz6CTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439482; c=relaxed/simple;
	bh=rmt8XDDydkWQ8r1wRcZRWYnvOL/qCyrfLFY7AcLJ3Ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qq4mVjmqgy1LdCXncUXvdBQpbQl8TxHvCgETcIJxxCQtsjsRheTfNU4n0VjdkymTgEilAIL9rPgttXZG/3i/nU3vK34XbQ+TgUcIGOG74WiHVRI/nZouZYz8mqpGbB2pAdvWEEnIPuf19RbrHgT8QigqX7cpACTGRm4WtUVSSVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaLbSVOa; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-941063da73eso300879241.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768439480; x=1769044280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWEmSPSV/4aq+tGwuGvE1EWZPGM77eZ+/59U3WROy80=;
        b=KaLbSVOainCstWZIa4MCInRUjwaqk1CJ/858JBOqyb89N4VJ51zPQWbIrtD1vXD6rN
         cyCGlHH729esF32O5cW1gV/jc+2iUPArSAi3gTDLCZGdiYrmHEjvZPjWuECNHWNoQb78
         +prJIsSOgSEzGfXmRr/DT5Q1fidN2n1vNEyfom7QxtFPY/4NIzkovnPtebF/N15AJ9xO
         m2vZdVSsxs7AdJe6ywU2bz4UJ3DkPpbZrVgFzNyUY9Oeitv2pN9p1uEwx9qQ9gT8TW8j
         BbBLJzbgQk5aWfHdFx58OQMJ7uluuUn2Z0MxMXbGhcVkWNOJ850jIfk16iWjfcE3/M3D
         RYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768439480; x=1769044280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uWEmSPSV/4aq+tGwuGvE1EWZPGM77eZ+/59U3WROy80=;
        b=Sho4xKJNvG/J09hlEao6xDVKxqrULHARgM6E+NS3m8BVItnHAQ+x9/THwI09l/xCng
         tCwQv47zr2iNICAas2B9wwVtni6GycNZa+P5XV+yI2onBTerOA+EV5+8s9jLYY2bRZtK
         dz5LKebWQk//7+GW109awCsVfClTq5DYET+ZrRp1/VqXX+npCRY2AgAanr0im4gT2LDX
         oasev5RCj2yoiumxgSbBsWWdDWDZsgn+A4UpbJI5AdF9EAzTzXzCVvVuEUfTFryLdTcn
         lBulM+FbSwjzgU0O7YILOHxYRyriH9/01Hlpz7dgDXZoykOF2fvy+vogd6+Cuj3gjTXE
         uQpg==
X-Forwarded-Encrypted: i=1; AJvYcCUd++BiPLPLZxO+JXhLaYgI9If/6qd3V6pp3MPptIfStDkmtB35S178SyGjm1vX04j5gAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1MbMQFtR9/567Wr1OgqvSnul8gZRflUrVA3a/8CCVFXCqG7rk
	gOw70hJrOraGfZL9nBl2yruH4Dnjsm85SIpeQe8QAOk4O30+5EHLxrozTR9yvFjOexGqrfC7lJG
	g7UwNUj0bLXQTiwY6fz8jpRGDv+fnFhTiD1PCClM=
X-Gm-Gg: AY/fxX7CFc7vO/2BeLhb6/InlOyjzOi0RgetGa0WCeJhg1Isw6Qpye9KZqcRII5vtr2
	am8wK/ykMiO8jkHVbunjn2H8qKezfa87axHkUItycO6oLO59F9ceDToA/tIcfEotOwoRfA05dnN
	zhG0yHJlHN5rtCTdeiCt4ZBIwYzIN+ewqogY1NigFeZ4O3Aa5SZ2+U7T2sm3QGlLOmD1TNzio1G
	KQArsW0fDU9AM5l6dqxntTZsCefPCsFX0og4x/OcJhqXdFj+YyF2Cfi4CBQuXSjl6ofT0BiUQ==
X-Received: by 2002:a05:6102:26d3:b0:5db:f615:1821 with SMTP id
 ada2fe7eead31-5f1838c16bamr1746719137.10.1768439478555; Wed, 14 Jan 2026
 17:11:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104135938.524-1-naohiko.shimizu@gmail.com> <10a102b9-1dd1-c5ca-66e4-f02794a84a93@kernel.org>
In-Reply-To: <10a102b9-1dd1-c5ca-66e4-f02794a84a93@kernel.org>
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Date: Thu, 15 Jan 2026 10:11:09 +0900
X-Gm-Features: AZwV_QgNY9cbiPSf-Pg_buhTiH9o3_E8wCotzHaSqbEA_BVUDA10Wv_icM50ON8
Message-ID: <CAA7_YY-3iVLzBJgntPkzMBZFe=uwQnkYUfJzW7rZ-i=Rw5sUKQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] riscv: fix timer update hazards on RV32
To: Paul Walmsley <pjw@kernel.org>
Cc: palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	anup@brainfault.org, atish.patra@linux.dev, daniel.lezcano@linaro.org, 
	tglx@linutronix.de, nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you very much, Paul.
I really appreciate your quick handling.

Naohiko

On Thu, Jan 15, 2026 at 9:39=E2=80=AFAM Paul Walmsley <pjw@kernel.org> wrot=
e:
>
> On Sun, 4 Jan 2026, Naohiko Shimizu wrote:
>
> > This patch series fixes timer register update hazards on RV32 for
> > clocksource, KVM, and suspend/resume paths by adopting the 3-step
> > update sequence recommended by the RISC-V Privileged Specification.
> >
> > Changes in v3:
> > - Dropped redundant subject line from commit descriptions.
> > - Added Fixes tags for all patches.
> > - Moved Signed-off-by tags to the end of commit messages.
> >
> > Changes in v2:
> > - Added detailed architectural background to commit messages.
> > - Added KVM and suspend/resume cases.
> >
> > Naohiko Shimizu (3):
> >   riscv: clocksource: Fix stimecmp update hazard on RV32
> >   riscv: kvm: Fix vstimecmp update hazard on RV32
> >   riscv: suspend: Fix stimecmp update hazard on RV32
> >
> >  arch/riscv/kernel/suspend.c       | 3 ++-
> >  arch/riscv/kvm/vcpu_timer.c       | 6 ++++--
> >  drivers/clocksource/timer-riscv.c | 3 ++-
> >  3 files changed, 8 insertions(+), 4 deletions(-)
>
> Thanks, queued for v6.19-rc.
>
>
> - Paul

