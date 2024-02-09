Return-Path: <kvm+bounces-8457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC68D84FB4D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B212928B096
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E237EF1B;
	Fri,  9 Feb 2024 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZPGqns1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4547EF06
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707501373; cv=none; b=OJt44s4eFHYdshS8bwr0f6HXV9Jx0/9mvyAoQKPDwgOJ3/HivmY+LWp0x+PwykN5byTsDOaKbR6SSVgqAW7d9OvZsvDI1kPkw2x4qINiEsIUjULVRSTKfScm89c4QlobQBq1mjezvCR97IXusXuUsKhBys1TMMD30kGiY8nnLro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707501373; c=relaxed/simple;
	bh=Vf9sTnp18c97Qa74hLutsqcRaj6j2Rea5/NTIJB8XkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j/3Rhy51UWpBifddyW+z6eH4x2Xr5t20010BEhABcXYt0fF11evDkttKj/XYsxLvC7EhG+hvjwqUpeZNNNBh+LlnR/V4e6gF+OssRGrYoekXXDlIy7yLR8FMkDzn5P5Gj2Plvdg85NvHhZJJTQphb7r8rAOeWdVwPlT3MSFUicc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZPGqns1; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-51165efb684so2072331e87.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 09:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707501369; x=1708106169; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NoqTVJex4Iddq9y5fjMVxpMdqogqTy+7RDtEYo1Z2eY=;
        b=UZPGqns1ddpe6PE8qep76DghxIZ54oub7dZQCE2ld456iSv0wQTTK1WqrvH5gsnz+J
         ThgCjE92VR5XRff4s3ohXEaHmItKSRgRGGyAeeSCYqYIS14AwfBa3T91/+CcBxuXv5dy
         5S2mi5tEO5XyFp0l1j1XI0c6dwu7iWzBkraLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707501369; x=1708106169;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NoqTVJex4Iddq9y5fjMVxpMdqogqTy+7RDtEYo1Z2eY=;
        b=WOU2GP6et0ABnaLU3ApCgxZrjnjm7youd69LD91XeKoTaGaMZaBcLc9hAfcb0K5dv4
         vzOJjuVm0ahCisHQGoQwiQOiWOP+EjEBSStNcPQDrycjjkeO8rwgvEfjZDz6g4ACjtRC
         EZJnpUPsuVnFzFP9p4pgAd5bEqoxCWjET9Uvp3zvg28hMTFZRF4h8ErwpEBdqIb79Usp
         aDGcbsuK8RvVv/nr+FKFZQMYWXc/cwxNMdexQLJ2mVK892Ubq+CZ2nGSceTUN+PtBVzv
         pMwDFTMdSq0CPrz9ppKNugS2muxbsD0SrMH9FJ9Q2wQ2VvawufyTgdlblPLBe+pX6sK0
         VCNA==
X-Gm-Message-State: AOJu0YyoxhnKhDWfF/RfhRtUt7S0YynGlzzC3MU05dY4cDbfeaAT0s4k
	xGlZaSdWnNy5XnsSgYez2UiEh9PcS0DMEe0SyiguVIkop9OxlecmbWzm0g3+CS71HjBgBLv9DzE
	f
X-Google-Smtp-Source: AGHT+IHBUmekplN9SfVMXws4rJeN0DJhQUXjNqRKZfk3Sd8QmEYFj3AcVfRgq7zAN0kzw/LRhMXxMw==
X-Received: by 2002:ac2:5f45:0:b0:511:529e:b54e with SMTP id 5-20020ac25f45000000b00511529eb54emr1626843lfz.30.1707501369505;
        Fri, 09 Feb 2024 09:56:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX4F3AwI/vUCDC9go7sWmp+q7fz6sgfAA5xEoOC8OsWWTiTXJMdwZ/cHgP6FZ8bsb5zAfnLUc6bnkZoqf3xAksCu+wq
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id b12-20020a056512304c00b00511759ff6b0sm320730lfb.141.2024.02.09.09.56.08
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 09:56:08 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d0512f6e32so16722731fa.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 09:56:08 -0800 (PST)
X-Received: by 2002:a2e:b057:0:b0:2d0:c9b5:7257 with SMTP id
 d23-20020a2eb057000000b002d0c9b57257mr2002248ljl.8.1707501367696; Fri, 09 Feb
 2024 09:56:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
In-Reply-To: <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Feb 2024 09:55:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
Message-ID: <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Sean Christopherson <seanjc@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Feb 2024 at 09:14, Andrew Pinski (QUIC)
<quic_apinski@quicinc.com> wrote:
>
> So the exact versions of GCC where this is/was fixed are:
> 12.4.0 (not released yet)
> 13.2.0
> 14.1.0 (not released yet)

Looking at the patch that the bugzilla says is the fix, it *looks*
like it's just the "mark volatile" that is missing.

But Sean says that  even if we mark "asm goto" as volatile manually,
it still fails.

So there seems to be something else going on in addition to just the volatile.

Side note: the reason we have that "asm_volatile_goto()" define in the
kernel is that we *used* to have a _different_ workaround for a gcc
bug in this area:

 /*
  * GCC 'asm goto' miscompiles certain code sequences:
  *
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
 #define asm_volatile_goto(x...) do { asm goto(x); asm (""); } while (0)

and looking at that (old) bugzilla there seems to be a lot of "seems
to be fixed", but it's not entirely clear.

We've removed that workaround in commit 43c249ea0b1e ("compiler-gcc.h:
remove ancient workaround for gcc PR 58670"), I'm wondering if maybe
that removal was a bit optimistic.

                Linus

