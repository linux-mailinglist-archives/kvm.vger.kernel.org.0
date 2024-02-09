Return-Path: <kvm+bounces-8475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDAF84FC67
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B98D282609
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5806285C56;
	Fri,  9 Feb 2024 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LKYYK+kR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDA884A4C
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707504993; cv=none; b=MwYpeAR+Q68yw+xvRGz981KQquG/8rxFp51enxxr0b2Rz/uRcrRmE5Kcn542Js3rAbjkPM9coGV0fedy5MRtJvoNpde6y0Xw/l5J/nGZSW04OYxWnfJdqviQ1TO9C+jrhF/NavXcmMLYZRPwkGLf2qqKI9iwPT0GA3sICnOhLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707504993; c=relaxed/simple;
	bh=jyq3Ou2zoIChrt4YF00OKCr8nhre49VBm+9l9qv0SqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lELzyKzyTMbP1wj6wx8rHM9dn3JBdb0qTQLxPEhVvCnUaZrYVJGRBFzhDUkFkE3JKKaD45YHylnptO3ZGnLqmQSN+3m9ekviA0h7pyT3DU2Tp9z0PEpD8NEcmA3wyS9pwJiH5PKnsS+QJu0KN9KHH9KiWdgur+1C5sZlls+MCxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LKYYK+kR; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-557dcb0f870so1855074a12.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 10:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707504989; x=1708109789; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tAuVk7SJcg0Z9C1D9VIVQQXO8KJNkpgkmG6crijy/Y8=;
        b=LKYYK+kREtotCAcUSMC7Gg0MVTg+UjwKbiArqfRKGfWYbQwZjQujS8SvGMWc3AQyEQ
         My49q27uaVhWvGgQskeX08W/XpDzaWk2bzACvs0ZEP52yiwzJFbafBj7KLUJLpi52V3V
         IttDi9hEL4jfnwMtLHHroVzKE8akQ0p7zDJRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707504989; x=1708109789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAuVk7SJcg0Z9C1D9VIVQQXO8KJNkpgkmG6crijy/Y8=;
        b=C4SkUJXmwoPbtgwOBUjHpE3m35ObCKgxwRV5Ta0RWWyhM9j5IXJhI1knWzrgM3gapJ
         bTmWPsc+PGDXsNa6BeszqeZ4lw2RS86/Q5QVDItfuqfPa8cobQc1iFVKBNwFYtg019qu
         7fMOua9EnJOzszvN/5xJPGrvUi1/al3bHvGJ78/c3oHEdxNhnyC0zJbj+bQkLqTmXAy9
         Y9v4FnCjlpVVjWLMQxh4bFa7Q05TjCWouNEXR81M73VaOdo5gRj/lCikISXMtHzc6JbP
         0biC2h5CMtNSEKVx93+FwmRIKorkWglPN7nKFXwTUk/gT+BZZiJ+U8evItt/ZAbzg2Sf
         CobA==
X-Forwarded-Encrypted: i=1; AJvYcCUrJ6c9FSuFg7O2fXV/LE1JLr5M5N3Y+v388NrtW5OwL20CebaPm35VD0dqAHyEVvx02t6JI3uP6J/EXYzBfNQE5lJZ
X-Gm-Message-State: AOJu0YwirjoxOSzMvfZNCrrtQDh3bfffra10L74d3UKivzr5laYESd/E
	GI6tvW27nnE3jrkxirxkphbOkp9BJpc66FdkqK3XQIfzHupGh3Dbejm2stZCQ1yUCKaNvdbU4EQ
	b1Ac=
X-Google-Smtp-Source: AGHT+IFl+rd7TDrxX83o9bVZFhgonBM+2dQay+boaPBTDRTgUdrh9QynFxk84090QSF6G5dQlbTJOw==
X-Received: by 2002:a05:6402:394:b0:560:8010:b680 with SMTP id o20-20020a056402039400b005608010b680mr1864926edv.36.1707504988983;
        Fri, 09 Feb 2024 10:56:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVoKLPKcGeV3hS7aNyxtg0o9nkFotYAvCnIEFbo/pb0gnJhVVM+/zUwxcT6AeTIWTxmYSxnj5OI4GRz05q5WA3BCNEY
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id v10-20020a056402184a00b0055f0b3ec5d8sm12176edy.36.2024.02.09.10.56.27
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 10:56:28 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so1742007a12.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 10:56:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVjTXEyfVolWKV2M3Mf3RPtp7yAQR2VKIuD8zwknJmbFellRqtjAjLsGgY8gzx7E6cwiBrbMyne7LYqlO0zTbGM2Lh7
X-Received: by 2002:aa7:c6d8:0:b0:560:bbcf:1f45 with SMTP id
 b24-20020aa7c6d8000000b00560bbcf1f45mr2004566eds.5.1707504987581; Fri, 09 Feb
 2024 10:56:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com> <ZcZyWrawr1NUCiQZ@google.com>
In-Reply-To: <ZcZyWrawr1NUCiQZ@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Feb 2024 10:56:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=whGn5j-1whM66VWJ=tVmpMFO8Q91uuFAJUXa5hG-PWdxA@mail.gmail.com>
Message-ID: <CAHk-=whGn5j-1whM66VWJ=tVmpMFO8Q91uuFAJUXa5hG-PWdxA@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Sean Christopherson <seanjc@google.com>
Cc: "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Feb 2024 at 10:43, Sean Christopherson <seanjc@google.com> wrote:
>
> > We've removed that workaround in commit 43c249ea0b1e ("compiler-gcc.h:
> > remove ancient workaround for gcc PR 58670"), I'm wondering if maybe
> > that removal was a bit optimistic.
>
> FWIW, reverting that does restore correct behavior on gcc-11.

Hmm. I suspect we'll just have to revert that commit then - although
probably in some form where it only affects the "this has outputs"
case.

Which is much less common than the non-output "asm goto" case.

It does cause gcc to generate fairly horrific code (as noted in the
commit), but it's almost certainly still better code than what the
non-asm-goto case results in.

We have very few uses of CC_HAS_ASM_GOTO_OUTPUT (and the related
CC_HAS_ASM_GOTO_TIED_OUTPUT), but unsafe_get_user() in particular
generates horrid code without it.

But it would be really good to understand *what* that secondary bug
is, and the fix for it. Just to make sure that gcc is really fixed,
and there isn't some pending bug that we just keep hiding with that
extra empty volatile asm.

Andrew?

                   Linus

