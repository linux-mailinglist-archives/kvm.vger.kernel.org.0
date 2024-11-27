Return-Path: <kvm+bounces-32573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B16BF9DAC04
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:47:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7684F282CA7
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E2B200BAE;
	Wed, 27 Nov 2024 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8G/CKBh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B9517C96
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732726049; cv=none; b=oHRN7nHNdb5zDwx8jG5KLWpqyx99PQK2k0R7nYfqja3REl8V2G0WTbO5ntNtOBw9oYIvg/JvhOHOZg7yDIoYitf1W/BxoqCOz2+kSOIKIHmAHYLK4uFKKC07ZuNYayuNS5Yw1Dc6qfgU443S9LMcs3AV1V6TAUBj5qFiLoECT3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732726049; c=relaxed/simple;
	bh=8Y9Le1Qou9VDWL2Er7ukdS8f8KHT58ETuT1igFfZRnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ddGrjxOptCT3JH93gRchdkSnP7laivhp6GqCe1Z+vPhDkrkxSZMJ650NxBxgC+oJwqCjsnxNKTtfbRB0uvVT3adVjKL0S/inxR5SpkyICblFYPW1efux2CXKKciCrmKO4qvJ+wPQGdYXNQCF8iQrKNX+yOLluv1erkfQjFI4L10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8G/CKBh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732726045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Y9Le1Qou9VDWL2Er7ukdS8f8KHT58ETuT1igFfZRnU=;
	b=h8G/CKBhLYSGMsjQvgrx3uFrSZVECvQ8sLxCPzCR6Hbv5R+MY6Ug26rf3rkvdV1Suxb97H
	3TLPR0SxspwYOU5bgm2NLXkt2/8rA3HGARS7ItOLUvBCkpjODCeyULk/UeIwcKabj5mWzC
	gnVem9Pap1g07RKFZteApbfI/ukJM90=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-W-Ys2JvSMC6l04uN1UsC6w-1; Wed, 27 Nov 2024 11:47:20 -0500
X-MC-Unique: W-Ys2JvSMC6l04uN1UsC6w-1
X-Mimecast-MFC-AGG-ID: W-Ys2JvSMC6l04uN1UsC6w
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38242a78f3eso3629123f8f.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:47:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732726039; x=1733330839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Y9Le1Qou9VDWL2Er7ukdS8f8KHT58ETuT1igFfZRnU=;
        b=cEzCcshNyno7m6Z2/26ba2amuJ6XoewJpIpXuXfhoAS2bTdhE5rXN1wOkY/naLV/sg
         wr9ZPu0SM7RSwIINbjSzxUP7RSKikcgkDjwOkZ7SDXCmC2tkY1tDnNNgYW2DzPYj7vnY
         FYdFQFqxHZ2eNdOh+Fe6mQmsXKkr/wZRf/jMuHvZs5JaxzEYpZeryJNkVFNZpcEanNEs
         jurOyvr2dnyIk8qmGW8Uo6uraUgdY/rpLCHG5UbMBeNK1Ry294/oriWOe0T/wwIIdcyz
         S7w77F4Y5V8LRurT9NjDDqja3jypt8Wsb7CmadMyydpicFn7peBXHaY8ltvBYcuQHV2H
         Za5g==
X-Forwarded-Encrypted: i=1; AJvYcCXQUsrcVIL8VqtEwy4s61n+0SY6ifHk7FOipuneOaRqVauxatHV1ZHtHCyTgkQg7fgqwug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrsDTQSPFSkULLWxsjfwo3FmHivyJLlfHez6ElFawR/5lZtabX
	r2ZmPh0Mo/RaNGFbD2MXBEzOAHOnCvlfd23PHsw3v9HRhv64feZbf3Opruo+8lFZp6uSIMC0Fzj
	KL3b+ZGclWx1TMe/y4JnMVNIghzjJVBNOckbahEAsJ42FJ0rppoAyu2ElnWihvc5vW3DQlohpxi
	yOv0Jtk0MVywOYKPBLeab+wiUW
X-Gm-Gg: ASbGncvY1hpypa+73spIT6f9BuKy+XYKzzoleCG0TAd7agxJs1zdnAI6OrL972RN9/q
	V1HS9pRKZPEPb7EWXQ0+QxoxZKQ/9MPIw
X-Received: by 2002:a5d:47a2:0:b0:382:3816:f50e with SMTP id ffacd0b85a97d-385c6ec0c20mr2844822f8f.34.1732726039546;
        Wed, 27 Nov 2024 08:47:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFyIJjCJsUsjTkEPyjKk/HdgXkYrWMJZ2C2yYVcuGldlRnE+mex1jvt62mbPHFSs9dS+0exPW1ON8tsC0Ue1s=
X-Received: by 2002:a5d:47a2:0:b0:382:3816:f50e with SMTP id
 ffacd0b85a97d-385c6ec0c20mr2844810f8f.34.1732726039255; Wed, 27 Nov 2024
 08:47:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
 <CABgObfacuB-8KN1+Czt5DaXQbaiw9=jP5zYGatw6CGooLnz9Sg@mail.gmail.com> <CAAhSdy1eYZc__ynDrF8sQCk8Rj+CRj+LBBbGnV+Hc4qHfYiEOA@mail.gmail.com>
In-Reply-To: <CAAhSdy1eYZc__ynDrF8sQCk8Rj+CRj+LBBbGnV+Hc4qHfYiEOA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Nov 2024 17:47:07 +0100
Message-ID: <CABgObfbKYc0Dqcq36dHsV=uopV+TAGu9-SuZF+QP=u6x0uMiHg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13, part #2
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 5:44=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Wed, Nov 27, 2024 at 10:08=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> >
> > On Thu, Nov 21, 2024 at 1:55=E2=80=AFPM Anup Patel <anup@brainfault.org=
> wrote:
> > >
> > > Hi Paolo,
> > >
> > > As mentioned in the last PR, here are the remaining KVM RISC-V
> > > changes for 6.13 which mainly consists of Svade/Svadu extension
> > > support for Host and Guest/VM.
> > >
> > > Please note that Palmer has not yet sent the RISC-V PR for 6.13
> > > so these patches will conflict with the RISC-V tree.
> >
> > The RISC-V PR has not been merged yet (has it been sent?) and I am not
> > sure what's happening here. If these are merged first, presumably
> > Linus will bump the arch/riscv/include/asm/hwcap.h constants --
> > leaving SVADE/SVADU at 87 and 88 and adjusting the others. Should I do
> > that or is it delayed to 6.14 at this point?
>
> Yes, Palmer send-out RISC-V PR one hour ago.
> (subject "[GIT PULL] RISC-V Paches for the 6.13 Merge Window, Part 1")
> (git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git
> tags/riscv-for-linus-6.13-mw1)
>
> We have already skipped Svade & Svadu support in the 6.12 merge
> window. If possible please take it in this merge window.

Ok, will do. But I'd like to understand if KVM patches needed the bare
metal support. If not, and the only reason to skip it in 6.12 was the
hwcap.h constants, then there was no reason to delay it. Just send the
hwcap.h update as a pull request to both me and Palmer, and we'll
merge it from the same commit into our trees.

Paolo


