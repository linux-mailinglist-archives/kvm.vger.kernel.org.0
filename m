Return-Path: <kvm+bounces-54797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE530B28320
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DC6A7BC2FA
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684833074B5;
	Fri, 15 Aug 2025 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E1BQUq9L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACAA307499
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 15:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272597; cv=none; b=E3hK0CnuulMwH9PT2aQTe8f36i1Ud5O2v03rGPgHc/bW2dM60dgLSBAdhapSzrcpN6DF2E+UkWq0XSGcmfj2h/VKDa+qnmt6CecGtIA+XGCHh65Es2RjBWMUWWvjN2cHNL6JgQkxnoZ0//ao4JpH8rW7QfIxxsO7B0jdt8KuBFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272597; c=relaxed/simple;
	bh=oeSalf/yLwgjR0IO65N9CQyedrwdJmUBVZlN9f6Yfqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Duj8rmfz1fAjhwEXHqx0zqCiG88uU82sC8DSgYe49v1gojOKZkNdkALQZEQYed4QfzfnfoQW4wLpfJiTGryoVSrJDEAx6nB0tSu10YnpRqxpAcjiIB0V/gF4UZTEggXkCB0Eo6eFhgjKdz1NnA7FFuJ2jDSOQAie6UR6FOuPlEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E1BQUq9L; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2445805aa2eso19063195ad.1
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 08:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755272595; x=1755877395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=buVtBGpVO2qFuCJLRA/MQVbYJ8Cn6PLF5emLFEWzGB8=;
        b=E1BQUq9LmugYF8sWbZ3OA492aA2l+yRZs6vsbgL1tkqK2b2TKPnzAclwAXVvVN9KKL
         J8vmdXdMaEoeTD7xOCigSkg6SUFFiFBIMX7aaX2F8w65K7O6pyRkVdcR5RvEkuvsm3dT
         hPZwzFqj2rvK0CvNRSt8jzTIkCEZxxjY47DS6BIbbm7wpEtvDGwrCIPNyTxw4aZTb3Rs
         jpGTPaH+aTybfyScOCBFJplga6dlsZkmhtS9brzSxSG4CjG+WAeDjw2nhSLIoxcfK1Fb
         6Uqquf9iNadAwOvBlmNWp6JskAgQsBWzIOpIKc7W4MXKEyU2+QHCVt0tP44FSioa8xl5
         ln3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272595; x=1755877395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buVtBGpVO2qFuCJLRA/MQVbYJ8Cn6PLF5emLFEWzGB8=;
        b=cmz4zmgoo5qpX9z2/SLgn94okpPZj5GZ2W99jnWR2+Eqmk7/Th/E+1BchfIRJ134LQ
         ehuumQ5An2H07jMdVn0Pm/aDJ3COcjwT6lic3WxesKcqCbllVXILzJuQjoL+qtinuhQG
         47Je89EBmbBFq+kCgJogqBriQqqu7uZpANRwen99K0mvALwjYWExWSp5J8IkcU9VIbUx
         x2nLZ0/k9PdDcL5tdByVHxGit/HMivekFSMvEtDQR7GvfAICOsjOmE7NrASa5CIRW2YR
         7m9v1Yb/71puhrVMVNgnDA6Q+dARBW8ZRcDWUXHEPKt9TQ8qSHGQTQ7mqWJZn5SqMU6j
         2gEA==
X-Forwarded-Encrypted: i=1; AJvYcCVbDaxST7ISUURg6YfdgoZMKDcTiDaoNOSqK50K20SplDuXvK7wXQ9bHf2AC7za1hQgxz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7ba/Yfm/vbq8/Y/ZwH3ok0hPSuFIogqijUKJKOnrxBaLoqXIJ
	EaZT/vUfpSLK391Mtte+GQbDD+cHA10KaqOL5fraVVnKS8Akz86z0Vrud4l9NQOE/j6tw+Or3hR
	wbcHrcWhOinXvFi6BMCN6gTlBI6+VysdKNvMNcP0z
X-Gm-Gg: ASbGnctnfDZIhOGDTe7pjP3gDek/ucqlOBUC2277lbVfrKw9B0aw34gAsneURsV6SYx
	JKbssQytD7o0lY7V8O0YqaXSEm3CDm0/JUQuqcOumlN5PSJ3OudlAWD5qI0x1fvSucQVip2W6Q6
	M3y5hNKoZ6ateE9KXiQSOIc82/Vvl2gHQ2IN0ESHIQnu8OeWqpsvNAzmzLckRQJHGvkjCQndr2b
	k4ByDsVwVJBV7U/0CnjOJdMbIyJhq7br0Ra2P89AgFQSQ==
X-Google-Smtp-Source: AGHT+IHLN1XcC4qoFNA2fwnUs0VOxxNCeh0+rqp1dIs2ILG4ZYpSyxCFz5Z9x+hJrPTx/BfQ3rEN3ennhyaJk7Nlv5c=
X-Received: by 2002:a17:902:ebca:b0:23f:fa79:15d0 with SMTP id
 d9443c01a7336-2446d939290mr42172865ad.46.1755272595233; Fri, 15 Aug 2025
 08:43:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <689f5129.050a0220.e29e5.0019.GAE@google.com> <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
In-Reply-To: <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 Aug 2025 17:43:03 +0200
X-Gm-Features: Ac12FXwZeTLz5pSIIxD3s3_BO2OVk5Y7yPGqJiF3VA6MqkLXviIJ0ppRoKfOrWU
Message-ID: <CANp29Y7BFtp9YrgzMTJhF1rmF_xx_48zMuCwbkP978LHPazD1g@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM guest
 and host.
To: David Woodhouse <dwmw2@infradead.org>
Cc: syzbot ci <syzbot+ci156aec4dff349a40@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 5:36=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Fri, 2025-08-15 at 08:24 -0700, syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v1] Support "generic" CPUID timing leaf as KVM guest and host.
> > https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.or=
g
> > * [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
> > * [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infom=
ation CPUID leaf
> > * [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present
> >
> > and found the following issue:
> > kernel build error
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20
> >
> > ***
> >
> > kernel build error
> >
> > tree:      torvalds
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/tor=
valds/linux
> > base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> > arch:      amd64
> > compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1=
~exp1~20250616065826.132), Debian LLD 20.1.7
> > config:    https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd-a80e-35083fe=
0988e/config
> >
> > arch/x86/kernel/kvm.c:899:30: error: a function declaration without a p=
rototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
> >
> > ***
>
> #syz test:
> git://git.infradead.org/users/dwmw2/linux.git f280e5436b3297ebb3ac282faf5=
559139b097969
>

Hi David,

(FYI) The syz test command is not supported for "syzbot ci" reports
yet (but it's in the plans).

--=20
Aleksandr

