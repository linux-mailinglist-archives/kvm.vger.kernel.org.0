Return-Path: <kvm+bounces-12486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAA1886B82
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 12:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8426D2849F2
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 11:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF353FB07;
	Fri, 22 Mar 2024 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="nt1burzF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F344E3EA9C
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 11:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108214; cv=none; b=TkalAladuFWSwzqFxe3hA0yI9EjS3VD1gA8Qkwu1gqhHyv/A+Y0NnFlare13J+jl1gR4nsUBj88Q5lZcXrYoEhvr3QU9a3WpYZ4NK0I2zkTM0yPTcwGzGnBc3g5raxdACRjrkE1j+FLeDckshMGZ5nqcRbwk6NPjd7imsLQUU7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108214; c=relaxed/simple;
	bh=5YnioGWbsAYLJyZb8b9JHmg6YRFPts9BTqRF1ogmYdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rWj7La1rDOI+kisPikFKNYXB6vzPls04UXjJ0XVsd0d9fbHQYZKo9+haXeQ9VG14bRdzxU7VSROgovGA3GL2HuhrPwz/YgEnzeuqG/xQS8wawukl7eyGlZmRaX2HB15WB2C01wAD4Jv6XQbdwSLAyQZFk5mZqcWwsUuCgYWXOpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=nt1burzF; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3684faf6286so8667165ab.1
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 04:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1711108212; x=1711713012; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAx2I7XvDqzXQw6wtmJmpS8c3rKWDIhE+rLvewBuwrM=;
        b=nt1burzFz5fEafBsl9ivjan1KrJ5xBuM/A98s7EnLTh+jPBZYuwPiUi5DKfGgJA0q8
         gNVZu1Qiw7aA0agLZvm3x+cvun5whqfQWetfd1sJ6OpnKg/FNXttn0pO2wzm9lzqgh8k
         GLYRvRdtg+lU0cxV44E4vnJ37R0A6yS6y5D5c8SIDf3tkAZbCtq5ReAMrBb1K7vSRzqp
         gF44gO58cCxhMjMDUPRtykTSYviG1efpIANp6BSOIlahrHAdDf7veCr3dfcodoWMxd6r
         vgUNeIpLuugp9SI3qFrf2i68f3fmcqDvS40Dry4BsRfqfjakdrN7XoqGLli9E0o8DOrg
         /OTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711108212; x=1711713012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAx2I7XvDqzXQw6wtmJmpS8c3rKWDIhE+rLvewBuwrM=;
        b=BR6jWisLYp2hYBgVrZRYhv7nnw1H0moDYzZ6+6GTX+7czuumEAPrA9Nr+Pel+mz2wt
         YjCo1rT5otqNHKD+pWBYDosp1CuNyZVKZnKgPmLoOx/9e+pubLbayixMWJCrU67xRF40
         sdAqwv9ACSZjdSXrhzuUrL2+TVLHn+EgoHVpoMD5Ioi6MX9mQGIBIaFZYtl7JfDdCYis
         uH0UftqNac+w8Sly2ctah6rZfZdF2gukaN0mtD+iUKgQJw51hzUmH6Zk1p5NHvTELDaK
         RQI/YS2xI0a6l8dj8ImJT55j35f2RdMQDEuPxLINFZdc+Fk/mJXg7xL2UxJtk5jPVLpP
         1BCg==
X-Forwarded-Encrypted: i=1; AJvYcCU8Ot8AA5Ezw6Vh4d486Ig980RO/mB93gCUZu9nLpaUZ85+kTtiTdw1+zAxaH5qTTrbs2W3VF6TNnsY06+Uz2Mm7Kxl
X-Gm-Message-State: AOJu0YxApvIxP7P6wOa51BWJvq02FlY59XyUPEV9jlQKgqKX8av2tSGS
	7xCC/hE2rsoHeQOSMXazD+bxcj1gv3BWOp0wqnQNenmDR5d5Ht+4XhrIsxyaCM+uBg+Kgmm1BWm
	VGinvtzEQnHItSxZ9vIRTabmuS7dDnDerYtAlMg==
X-Google-Smtp-Source: AGHT+IGc1Lk3igmGbpYPTMkvVjrig10NalqBLgFeStlCj29E23ErhBLOEWZu+ODvVKrcfDcGJtCgMDHVzrFWhsAZCSE=
X-Received: by 2002:a05:6e02:1a24:b0:368:4d28:5d0c with SMTP id
 g4-20020a056e021a2400b003684d285d0cmr2444188ile.22.1711108212026; Fri, 22 Mar
 2024 04:50:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240321085041.1955293-1-apatel@ventanamicro.com> <f44de7d9-e03d-483d-96d3-76c63158061d@gmail.com>
In-Reply-To: <f44de7d9-e03d-483d-96d3-76c63158061d@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 22 Mar 2024 17:20:00 +0530
Message-ID: <CAAhSdy1HnzB5T0G3dEfuVX1LHCMy6H4B1paQyCKC-iXTJ_Nf=w@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM RISC-V APLIC fixes
To: Bing Fan <hptsfb@gmail.com>
Cc: Anup Patel <apatel@ventanamicro.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2024 at 5:05=E2=80=AFPM Bing Fan <hptsfb@gmail.com> wrote:
>
>
> Hi,
>
>
> As you mentioned as below, riscv's aia patch in
> https://github.com/avpatel/linux.git
>
> Why is this series of patches not merged into upstream?

This will be sent as part of Linux-6.9-rcX fixes (after 1-2 weeks).

Regards,
Anup

>
>
> =E5=9C=A8 2024/3/21 16:50, Anup Patel =E5=86=99=E9=81=93:
> > Few fixes for KVM RISC-V in-kernel APLIC emulation which were discovere=
d
> > during Linux AIA driver patch reviews.
> >
> > These patches can also be found in the riscv_kvm_aplic_fixes_v1
> > branch at: https://github.com/avpatel/linux.git
> >
> > Anup Patel (2):
> >    RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
> >    RISC-V: KVM: Fix APLIC in_clrip[x] read emulation
> >
> >   arch/riscv/kvm/aia_aplic.c | 37 +++++++++++++++++++++++++++++++------
> >   1 file changed, 31 insertions(+), 6 deletions(-)
> >

