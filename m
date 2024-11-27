Return-Path: <kvm+bounces-32574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CEB9DAC09
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87AC0B20F7C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E015E200BB5;
	Wed, 27 Nov 2024 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="AVote8iB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B5917C96
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732726289; cv=none; b=paBhlH3y/BBvUGvvguSMiFtbnWBYeQktJDSbAqJBWcyhZ2xbAGOv+NCQh35CqEvg+ah5Z0ATtwLfzAZ6JwgeUlc0SMoPhqOGSHMoJb87ffrY3bnEgrCPvacTpvCbCiPIA09ATO0JNLU3SYx9aJmFOXZMCtvCHXqlOBGtQXjlePI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732726289; c=relaxed/simple;
	bh=Bza9TXjKrMx+ZuvYZSE+jh++0b0PFp5Y1oO9gfMuvgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgWvafJDjpLw6ktHAMSFTmcPCS/HCr/kYNScTCgHwR2JKSn/cn6HlqNY/RUdL7HpoUbZW7fejnAaSCzTKHtcK4kjB1MnD4Fx7/rDV1nyOpIDfuGUYaHwCz58NcF28/nO8MXQoaTSSe/jezQqhq1CIxZNG4bqA4vEzZW0BKckHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=AVote8iB; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8418ecda199so146886639f.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1732726287; x=1733331087; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bza9TXjKrMx+ZuvYZSE+jh++0b0PFp5Y1oO9gfMuvgM=;
        b=AVote8iBq94xyFsE3S6QlFXfAWnvN9jzt5+ycfrVWsfij1Mrq6uTee1TqQNbq6Sr84
         oWdr9JRBsXOKrAV3mizpV4jMX07NVzDPSR/YZMMj/LgwH1y0Vlco1hpOEmNyDJ97zAtM
         UXmDyao9lrfvfTSGWp70e9M51DEKS6nVpez/Rw0ol8+H98jIO4gBldct9JapAE/CIct7
         qlCXJxkibjwr49fzIj9SvTO1f/eLDrNA2f93AULD1B+bNNoHiSCa6Fk+hA7xvIRadMLp
         dXaOpXa7j29Xhxt/z1FeZV2lFwH4pxsw+6HZgsrJprLjEFqzFdJQeH41d3ugRxJ8hNjI
         nXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732726287; x=1733331087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bza9TXjKrMx+ZuvYZSE+jh++0b0PFp5Y1oO9gfMuvgM=;
        b=iUg1yFUnESCAH7JlljFQD4qZNwqHQwveCaNeGdUBI6O+5wpeZJtFPbwPO5kxnmalZc
         Hbhy11l038arb1W4sQulkOiiFQlAkM6FKrrur/ab/hOqvQlQ2vyQTi/z9DNIAS7HdQ5g
         yQcq9WznZOsC6/vaYgow+nvbSBdDBRUMTvdBLyY4QD6BbtF2pXUB4uZlzd+9RskpzMnd
         fpMgWk01obMdaM7+vh4bF+qsTyt9WUKoPaftY1ry2TMWKl5FENOooNE5xginnoOIIZc2
         JXFXo2/SIZXxrIOkDrP+AXPdr+LVN4Jhops9Y40zo+nGStTitOitdOkfrcYlyV4jjSGc
         6R3A==
X-Forwarded-Encrypted: i=1; AJvYcCXN8G1yazyHZtospGjV76edYoxdfBHuqznxKr2hOJ2AI8ReRS8xFN5UHKpKnWKGFdlcWdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxpWejC859R+8k11rqHJs5KCG70xdKGzu/VqW6d0z+05egO+Kr
	uBL0NsDFd9mJV6sEp/L2MH5vTjzGG4oAEU3D/hId/pqkwObSSDu2sNNnyqzW4bpyMzSg+tcQ0lq
	Gdj9xCIQktAevGBFQD8tGT1mwDjpsKfbPNtEL/Q==
X-Gm-Gg: ASbGnct+5f0z9m3arxSnFquHhCd/cyaFHJZNEt3lIfS767+mkDkINmQ89SM1qtwOqny
	3qeUk33NxNzCVpScoekrAmtnChG9hXUMrOQ==
X-Google-Smtp-Source: AGHT+IHxvDlHWGRrvsQdmkTyZjkHawKzIvwtz6T9UyKPE9sZ2QFQD9qYyIufn4uqqBrMH/tchj8LjVN4cYc8/GBl11Y=
X-Received: by 2002:a05:6602:6001:b0:843:ea9a:acc4 with SMTP id
 ca18e2360f4ac-843ed0671b8mr429804039f.8.1732726286648; Wed, 27 Nov 2024
 08:51:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
 <CABgObfacuB-8KN1+Czt5DaXQbaiw9=jP5zYGatw6CGooLnz9Sg@mail.gmail.com>
 <CAAhSdy1eYZc__ynDrF8sQCk8Rj+CRj+LBBbGnV+Hc4qHfYiEOA@mail.gmail.com> <CABgObfbKYc0Dqcq36dHsV=uopV+TAGu9-SuZF+QP=u6x0uMiHg@mail.gmail.com>
In-Reply-To: <CABgObfbKYc0Dqcq36dHsV=uopV+TAGu9-SuZF+QP=u6x0uMiHg@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 27 Nov 2024 22:21:15 +0530
Message-ID: <CAAhSdy1QCeg82kQsPHJx1+Oc=L7BoOUTpeLUNoeApao8rZDE+Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13, part #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 10:17=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Wed, Nov 27, 2024 at 5:44=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > On Wed, Nov 27, 2024 at 10:08=E2=80=AFPM Paolo Bonzini <pbonzini@redhat=
.com> wrote:
> > >
> > > On Thu, Nov 21, 2024 at 1:55=E2=80=AFPM Anup Patel <anup@brainfault.o=
rg> wrote:
> > > >
> > > > Hi Paolo,
> > > >
> > > > As mentioned in the last PR, here are the remaining KVM RISC-V
> > > > changes for 6.13 which mainly consists of Svade/Svadu extension
> > > > support for Host and Guest/VM.
> > > >
> > > > Please note that Palmer has not yet sent the RISC-V PR for 6.13
> > > > so these patches will conflict with the RISC-V tree.
> > >
> > > The RISC-V PR has not been merged yet (has it been sent?) and I am no=
t
> > > sure what's happening here. If these are merged first, presumably
> > > Linus will bump the arch/riscv/include/asm/hwcap.h constants --
> > > leaving SVADE/SVADU at 87 and 88 and adjusting the others. Should I d=
o
> > > that or is it delayed to 6.14 at this point?
> >
> > Yes, Palmer send-out RISC-V PR one hour ago.
> > (subject "[GIT PULL] RISC-V Paches for the 6.13 Merge Window, Part 1")
> > (git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git
> > tags/riscv-for-linus-6.13-mw1)
> >
> > We have already skipped Svade & Svadu support in the 6.12 merge
> > window. If possible please take it in this merge window.
>
> Ok, will do. But I'd like to understand if KVM patches needed the bare
> metal support. If not, and the only reason to skip it in 6.12 was the
> hwcap.h constants, then there was no reason to delay it. Just send the
> hwcap.h update as a pull request to both me and Palmer, and we'll
> merge it from the same commit into our trees.

It was skipped in 6.12 due to confusion between myself and Palmer
about which tree these patches will go through and we did not resolve
this in time.

Regards,
Anup

