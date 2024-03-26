Return-Path: <kvm+bounces-12649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5649F88B941
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 05:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10C33291FD5
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7CA12A170;
	Tue, 26 Mar 2024 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="YetuRw60"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B821208A5
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 04:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711426074; cv=none; b=FETM/UMmSjzvf/jB+mkiKkWqO/HiJsrQIcDkryjzAC/XDSHUoVjynIxvMGPkWvhXGKTd84IIGr8LdZuUlsw1dCDnR3ouD+sDmnQ9WDwJMfLj/GsowavHW3MACxEBvl4UkrEMseShgCjQdq7dwnMhWgfZr4lEPLOhhF7Dn8q3q7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711426074; c=relaxed/simple;
	bh=R+nLcOTwvgUirVNTt7cUeAOPAWPx06FjNpRRUFDyAgE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTR/E0NAVvbOD9UY6x8wxY5yewjrrQ+sLIbDYp0D40LQBJE8m803g9IaRLYoyuwhZB6XgqyZzSQ0cUZNChtBdDCB+9QB2pvWx1jQgetS77cZclMDQeveOqPnQgrfvZdgKxwOThzNv9bKta68Oo95C9H4TsedGSDr+WYXQjJXcLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=YetuRw60; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3662feb90a8so38298205ab.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1711426070; x=1712030870; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZR8vGousVKLTwUEi/21KojnQf3J0MYLn3UhiAu3VJo=;
        b=YetuRw60hxaxKBJTn8/ugVAuzuDY0vHPOhS8oQTB7zX6I6ZPg4goMhotHlmw2Zeroy
         s6p+Gvu7jc392gPrzp76Q7AgYlxi9yQ1K/OECXNY+AtscLJAjBSdMbdBrovPOlcJksPS
         ijWsZ8XKAvyF1fjdcks0VoqhAPgaq5SPNASqgr1gHBs624wN9jwozmYrNnTYtVYqZ+AJ
         /b7xIOV8+OMaytW9iqpxZh9b8YuB0D3241e9SOLESrmI0LCDik7Twqk4XTVF1EHdw45J
         4rRbNLFhFWC19cZFDWObMZsOUZHufrXCL5dmrKuLWltlEOaHiN4tna+L43lkVxNVl+7b
         XlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711426070; x=1712030870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ZR8vGousVKLTwUEi/21KojnQf3J0MYLn3UhiAu3VJo=;
        b=fuM4pHvIm6NXYsqOphB0owJMohABR7ZUawGwGWIR8qj4Wc0ONUghu0VJXhWd1+1YSW
         aV55dlqW8lZvuY84ZHWZu5uI9UEiqQ5UYRvsGDLBmo5rYxd7pBCyUvO+KBo4dSibeq4f
         5DdLU1anZArZC/0bqni64SypKzShKGXoyReKS8mFOKLRt0DHMdlc6BXzyc8CCkoQ+cb3
         1GkYk2wf6+HtVsWhBs48fIl6j5nku8eUcc9S5rhcPC9gwGIyRYqWb0netx0dZzLJFHSW
         TnKcT8EZodnbVyPxajyp5dFzigoBbVQWiSNc0eG/r0rGYHRKZh940yHVFrjS9MG1KN5w
         4tpA==
X-Forwarded-Encrypted: i=1; AJvYcCXMkGxOLRzBM413y4PRpkhsKpNYnT6CrI9kgjeXAp1uhnTZboxPs8RN6FA8tngTMXA9JyJaGJy0RJLUCxGR0Cr0d8gE
X-Gm-Message-State: AOJu0Yz8N4aTQ2+uZKoiDgOgxVuikKne3yKdPFupxcn3/iGCKB8HC/SW
	LMRbhZ4pqZDy0CebQtij/0QhxgYJKNbTbFricBo88LpRajghBtRm1A7bBQYmbAfuM8vivntZGbC
	yOmDVl/wFjhKo+c9GuygddPCjPFGV8H3k/E4xBQ==
X-Google-Smtp-Source: AGHT+IGt0bGGYQWpx67EJCwTtVelUSMNY0t2MZE8NdaGGuCuPZUdwQH0ix+HnbyiD5ovliqTKGlpmL5Ocw1jnFJWOTM=
X-Received: by 2002:a92:d782:0:b0:368:9850:82c1 with SMTP id
 d2-20020a92d782000000b00368985082c1mr36365iln.13.1711426070652; Mon, 25 Mar
 2024 21:07:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240321085041.1955293-1-apatel@ventanamicro.com>
In-Reply-To: <20240321085041.1955293-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 26 Mar 2024 09:37:39 +0530
Message-ID: <CAAhSdy1jAjGJR=+ZtfLpfzgctJ4cA==nCXJ0FEDBF_vJLNJBWA@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM RISC-V APLIC fixes
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 2:20=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> Few fixes for KVM RISC-V in-kernel APLIC emulation which were discovered
> during Linux AIA driver patch reviews.
>
> These patches can also be found in the riscv_kvm_aplic_fixes_v1
> branch at: https://github.com/avpatel/linux.git
>
> Anup Patel (2):
>   RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
>   RISC-V: KVM: Fix APLIC in_clrip[x] read emulation

Queued this series for Linux-6.9 fixes.

Thanks,
Anup

>
>  arch/riscv/kvm/aia_aplic.c | 37 +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
>
> --
> 2.34.1
>

