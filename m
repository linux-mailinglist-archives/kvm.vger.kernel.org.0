Return-Path: <kvm+bounces-59238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EAABAF06E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 04:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 677863C7018
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 02:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB3827B343;
	Wed,  1 Oct 2025 02:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwVCcbGW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDDF270ED2
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759287124; cv=none; b=H5TmAuPVccjbxOKbmLVAJx+I2I08IvR9cuDF6ROxqCaeZ75xrYJpGY+gyHLkYWllNFdmOVoPVLuvteUJDyX8QKT9qMLQ9nbFINfLgl03HBSQQejvpFePJ54R1ozc//X9dPoONHV+BhKW/y1KS+xdv7l1uBMwzYJzELEgYXTATSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759287124; c=relaxed/simple;
	bh=YnpV7AOicbHecSioq77wiV8762Tl9h9eEE8ofc6SmM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KTPdZWHcU7n11KP3r3oNz1oFdI9rr6YtkDK5w2z0EWDRmd0dFj8/lz/KZd9KU2mdrg/UPWnSz8xxWB00OR9geQAhdyw1qJbBY4J/j1XG3pqX8RPEvlVCHx6rOc+HNQNlR2cpq1WRLmqREmJzvWqQ1mfpjdBcRyjLZ4oc0VLXqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwVCcbGW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59564C16AAE
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 02:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759287124;
	bh=YnpV7AOicbHecSioq77wiV8762Tl9h9eEE8ofc6SmM8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FwVCcbGWNXWQqj9JY65RahfqJfLdMc2eDEKkBX9E08x/KhD6sxaG66XN1ywuOz432
	 687tU3XewCwa0JudfqFP2nd65jSIiX+3S/7jofHh+3+tm9PfQ5aRCkXn8NVpH5IOuD
	 IuIBG3LlQrHYvKbnHegqkLZtMUbJKyadKYMS2AL5CGN5q16oE6S0ZbDYNhiKN4UPhF
	 zQxKibA9xq486QKmqR//6vaq85OTx8tiV1yy7TA+2CWxfps/99SNHteda6IycCVtKk
	 NhgnHA8Pal9q/s9CaeI8YkCLZqYYgZSkGOvU1w4siyynqNm3DTA3uvxaur5UG2xN+f
	 641HGsvXiCW4g==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3e234fcd4bso524456666b.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 19:52:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUtbGr5vb2WHIFdteF7eGpymID3wgiyN79mJOQHfzn1gY21luDHr7NeabUzuojimhzMH58=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNXOd3i1n6aNGO2B8TzlDLBNJ4B7iLUL6BldFaVSu5sit+nnrw
	g03klofM2YX9/KYwfRajGH2E1KKUdZz0NXCd7Qf0eF7xgqVa/ileud7HmbbfgDBVXz5wC6byRNc
	xw/vRKm4gRfXTCVnF8pTcEY8FyH0mMPU=
X-Google-Smtp-Source: AGHT+IFWcL0PKFNrU8k5tcwcl7KBFEtDmDCe6D/kvvOhRJoVG/PAaPG8ESGNmKR/SIJNH7Nn2TUOH2PCNHylcY/DsO4=
X-Received: by 2002:a17:906:c107:b0:b40:8deb:9cbe with SMTP id
 a640c23a62f3a-b46e2434dc1mr225455966b.2.1759287122948; Tue, 30 Sep 2025
 19:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924081305.3068787-1-chenhuacai@loongson.cn>
 <CABgObfZvdkAR6YGx7HKT+aVaE06w=FG7Jus=3B6nxadDiv5c_Q@mail.gmail.com> <CABgObfaPEMTGYSSZp_5S8J67+=GdkxmwNuRMHVfV37iCQex7bg@mail.gmail.com>
In-Reply-To: <CABgObfaPEMTGYSSZp_5S8J67+=GdkxmwNuRMHVfV37iCQex7bg@mail.gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 1 Oct 2025 10:51:52 +0800
X-Gmail-Original-Message-ID: <CAAhV-H43OXs0nvm52r6yBw5hMyGWkr4atUHxf2q=MWAnEi6c6A@mail.gmail.com>
X-Gm-Features: AS18NWCdQ50IbrE74fOheYUmmi66RzlWjR_YEY6jDwxZJnEf8R3sUxcY18e3syU
Message-ID: <CAAhV-H43OXs0nvm52r6yBw5hMyGWkr4atUHxf2q=MWAnEi6c6A@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.18
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Paolo,

On Wed, Oct 1, 2025 at 1:58=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> On Tue, Sep 30, 2025 at 7:16=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> >
> > On Wed, Sep 24, 2025 at 10:15=E2=80=AFAM Huacai Chen <chenhuacai@loongs=
on.cn> wrote:
> > >
> > > The following changes since commit 07e27ad16399afcd693be20211b0dfae63=
e0615f:
> > >
> > >   Linux 6.17-rc7 (2025-09-21 15:08:52 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loon=
gson.git tags/loongarch-kvm-6.18
> > >
> > > for you to fetch changes up to 66e2d96b1c5875122bfb94239989d832ccf514=
77:
> > >
> > >   LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code (2025=
-09-23 23:37:26 +0800)
> >
> > Pulled, thanks.
>
> Forgot to mention, please pick one between chenhuacai@loongson.cn and
> chenhuacai@kernel.org and use it for both the committer and the
> Signed-off-by line. :)
Hmm, it seems I have always used chenhuacai@loongson.cn. What trouble
do you have? The E-mail was marked as SPAM?

Huacai
>
> Paolo
>

