Return-Path: <kvm+bounces-8695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6039855008
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B3928FA48
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C45612881C;
	Wed, 14 Feb 2024 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6JG2eiX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3299A12838C
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707931208; cv=none; b=ogf5Ijnjr1LrUv1MDrIyf+ZMoxNSPy77Af1ac2S+h7461y2EHxPo2DTnEG3QpSPZ/kFQ8cxHjdoUihA600iRDBO0Q3hZbT2Vq/b0UkVZ7nlIqRLxewSqzkh/9SLqSy5HEBscBWAbvNfPQfKrTBysb/vb/xFJSZKkpQqO+BDEDDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707931208; c=relaxed/simple;
	bh=CGTeedDrb3fyQ8bw9v9S81c0WOzEdAHLsmIJvQpyzxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vC9Y66N33Zcpu6w9YU5nfiyvKyVIIj2aD6MTZra0xz259sft9xeb8lKCjiVH8IrPACYko/qCKTX4CNw8ZK6+K/jOPeTzx0K/1NAkemqC4BJoR9WisGxDYoMi9mab2FJQCrNBRDZpep3cdIrYq/RyjIONtUHKfJbaFl+uCcKuhnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6JG2eiX; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc647f65573so10598329276.2
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 09:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707931206; x=1708536006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZF5AWKakK2HlgjgZFF550I1BoQfMgek2mcRM5DDAG6E=;
        b=r6JG2eiXct8YmWSo0hfoxN6uaRFVEhimMkK0LYq4TpHMWzs3V+pUD8x2W70chF069b
         pIPWW2BDuQhg70iplYrbhU0e7tyj1i7IppnVagiSvlu6E+wY0ponb8rDjS8uHonhxFZF
         L6NDbaGOU7keBMdPVA3YfzYTYXq30utJsMKu9zw5JGqUQggzA6drtJHvNGmdUPwl5/8q
         Q0hEqhi56pGKW+VpyDy6haYcSS/gkUt8wdA9f1YTRZVzq53e5b0u1A/AHcRjrGwtoAxx
         RDAlBUQ/QKSxMd1l/H64H0cXhWgfVU6/9DSz3b4hsLcf0tSx/zPJQY2rjZXTqSEJye+e
         neRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707931206; x=1708536006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZF5AWKakK2HlgjgZFF550I1BoQfMgek2mcRM5DDAG6E=;
        b=ZctuiIdKQru1klPo3V331WUmC6LRgX1+r5tI+4GTO6BOZ7saFAg7//pKliNih+OPDZ
         SJyjym/xVIjT0ng5CQIgonbJ3+g4gR52mNzo2H/7S+8oZswyS63pn7A4UEEaAcR2RU3g
         ScJ8kEfD6jhIDxwkELyBnUnEgrEr3IXTAp7FpqyG3MMfkPfjBEow9bu889ntBIvCwgIA
         Lfj/XzISzlQERahWRrRtBw4VjyNVXVL8s8sGzWqjbZ1MnhyqnvIKTvLWUseeR8JdgIa0
         w87tUwQuTaXdYsoQSxaK4KYe1FMJtb4KSBCs4Pt5RFA82SfUCGvSZDPhkyiHYHcZ+xZT
         ddQw==
X-Forwarded-Encrypted: i=1; AJvYcCXWHQVoGa9pTaabEA87lIwTkg2Hr9Vs1MDf6xS3BzNvA7rnW3tYYaIoMPWRnlqP4uwLvJrQc7E7w6703mgLZ0IoTTBO
X-Gm-Message-State: AOJu0YwPc2phon9cFyjVuV091ltAfpiW2oNDxUO3GNNbK2cugeFCQOQw
	c+0nuLSUxNI/9lGG2DwphPzb1Kz0w4f735Gr5QIcmbw36km+lqD8H8mLvwnHlrbNx2xUCdsE6ch
	Neg==
X-Google-Smtp-Source: AGHT+IGgjPwvf/mN0OzfYNwubY737oAtMzdz5XSx634JXC4ZSz9+tF0ZnJ1RYyc/PujEtCEMvEC4Xjp7Kmw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ae5a:0:b0:dcd:3172:7265 with SMTP id
 g26-20020a25ae5a000000b00dcd31727265mr651230ybe.8.1707931206199; Wed, 14 Feb
 2024 09:20:06 -0800 (PST)
Date: Wed, 14 Feb 2024 09:20:04 -0800
In-Reply-To: <Zcq0qwfjrOYPeR1h@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
 <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com> <Zcq0qwfjrOYPeR1h@google.com>
Message-ID: <Zcz2RKR-1uRaydKv@google.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
From: Sean Christopherson <seanjc@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jakub Jelinek <jakub@redhat.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 12, 2024, Sean Christopherson wrote:
> On Sun, Feb 11, 2024, Linus Torvalds wrote:
> > On Sun, 11 Feb 2024 at 03:12, Uros Bizjak <ubizjak@gmail.com> wrote:
> > >
> > > I'd suggest the original poster to file a bug report in the GCC
> > > bugzilla. This way, the bug can be properly analysed and eventually
> > > fixed. The detailed instructions are available at
> > > https://gcc.gnu.org/bugs/
> > 
> > Yes, please. Sean?
> > 
> > In order to *not* confuse it with the "asm goto with output doesn't
> > imply volatile" bugs, could you make a bug report that talks purely
> > about the code generation issue that happens even with a manually
> > added volatile (your third code sequence in your original email)?
> 
> Will do.  Got a bug report ready, just waiting for a GCC Bugzilla account to be
> created for me so I can file it...

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921

