Return-Path: <kvm+bounces-11961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6361D87DAAA
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 17:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1461A1F22AE6
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 16:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F931BC4C;
	Sat, 16 Mar 2024 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EcMGoG9R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A5F1B969
	for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710604929; cv=none; b=e6uhv4RWGZX9j3qa9nj+iWvghaOJDuU/7qm6gCo8YpiHTME+Y/602WI6qjy2S7eHUonCW7eFUQF2nkDabU+VeHcM6ubOUJlixQRRliWczzHdoWoaQzgbCZ+rdLSiYcKzM4lLxmq5McHR/bibU0U8zjSPmFDMF4WMjDYPCvbCjTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710604929; c=relaxed/simple;
	bh=JWvf+6scSz8b3lyEfY7d1WQwOuAUyHiD02tQ1aUQaMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3mdEDPBDjDatlS820n9Iv5SxzTB7hnUPLJ27JyO9KCYVklA5QxYtVa5otkKrYYru4CwnE3TUfWzVg4NLOlcMwkAbffvrzQBtJ/wy5vG5/oOKK85cgCFagTqjIu+8/G73X98ewR6NMUoPBoueuR0egmZ9XVQ//SHjOZthV3Rl5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EcMGoG9R; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-512ed314881so2398657e87.2
        for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 09:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710604926; x=1711209726; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qHGim/EngLZSLM4Ipv2QHE/SK/rU5ZyyxCqSLK9WeiE=;
        b=EcMGoG9RARV3eGHBOk599BIkfWCsqhlKWkon/u8enB3N4mfvpofR6H9rPWPV4HhnNl
         pa41Mpj9kyvQCwMfQSe0gn2VhAf0rbYuPJ+pCrtl7gifIgUbJcyLSJyCcz2Dy3wTWhdY
         XRzoKpwA98Lz6jCJxxTq9qrD13HPjNVF1c04Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710604926; x=1711209726;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qHGim/EngLZSLM4Ipv2QHE/SK/rU5ZyyxCqSLK9WeiE=;
        b=RpvO9oCKOEGBRqUNp65QAD5S+1FEPkM3IEsV9fPrAlcCzDpjhKNA+pJPjEApykgG9u
         vq6cUn2/pte30VXqxiuEWbiqvrEIHPBzBoOejsR3GtilCySM9AtUxUBqF/yYJM/pGw9v
         QPx/5LV8unMyGai1MBCESlivXyDjvm2Nwo7cUPb4qJX4rZqVpcTi66bj4gKwclLMWCaJ
         PLnKLXC7CfAY15+GSSLdKNMlB6v2ccGbwcB5MwkB1LSMio652FbSuQlQ74rIYWD1+JvE
         9nVylkB3IChxtVOPpQq5RO+HnRzaEWc4vAhS7YI/QzDdgd+6Wsm2RA/IESRRIsK5Ga1j
         eOHg==
X-Forwarded-Encrypted: i=1; AJvYcCVy68g5R3NjHcHPxA6pIoMopFJo1alVSy2Q+WfRULhLmQB5XuA8uXqCs5KJIwJFt+0G5HmleEre6MuISxdi3If6SJVq
X-Gm-Message-State: AOJu0YxKYPYRNN7nzXPlumOFepqshXqYYw5pdLaOGPDbM05ZoDR002Lm
	IEixNYCnlwmnGxbmXdIZ46i4cG6hI++scXEjNb3p7hYt5EFgQY2KxVM8gvcRmow4X6r4kRBzsWw
	tl3z7pw==
X-Google-Smtp-Source: AGHT+IHTDFCzkbiiztQrAe/SYVhFr730gmS+VBa0gKkW+63qF/Af71txqid9z7LIL2FM26rNt/GC2Q==
X-Received: by 2002:a05:6512:2098:b0:513:80b3:3eea with SMTP id t24-20020a056512209800b0051380b33eeamr4850799lfr.56.1710604926052;
        Sat, 16 Mar 2024 09:02:06 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id dl9-20020a170907944900b00a46ae3bca8dsm143172ejc.53.2024.03.16.09.02.05
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:02:05 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-568a42133d8so3086457a12.1
        for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 09:02:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUN4/Sq5e1YPW8/Fkg8bWkUe/NJTwdRGX95WfYf3BhhPUt6NPRQJ7fEn2laann7mn3sUTjLKoAHPU9BPDTX1t6wPNqD
X-Received: by 2002:a17:906:7f0e:b0:a46:141d:bf62 with SMTP id
 d14-20020a1709067f0e00b00a46141dbf62mr4663522ejr.73.1710604924499; Sat, 16
 Mar 2024 09:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315174939.2530483-1-pbonzini@redhat.com> <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
 <ZfTadCKIL7Ujxw3f@linux.dev> <ZfTepXx_lsriEg5U@linux.dev> <CABgObfaLzspX-eMOw3Mn0KgFzYJ1+FhN0d58VNQ088SoXfsvAA@mail.gmail.com>
In-Reply-To: <CABgObfaLzspX-eMOw3Mn0KgFzYJ1+FhN0d58VNQ088SoXfsvAA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Mar 2024 09:01:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whtnzTZ-9h6Su2aGDYUQJw2yyuZ04V0y_=V+=SBxkd38w@mail.gmail.com>
Message-ID: <CAHk-=whtnzTZ-9h6Su2aGDYUQJw2yyuZ04V0y_=V+=SBxkd38w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 16 Mar 2024 at 01:48, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Linus, were you compiling with allyesconfig so that you got
> CONFIG_KVM_ARM64_RES_BITS_PARANOIA on?

Regular allmodconfig.

> You can also make CONFIG_KVM_ARM64_RES_BITS_PARANOIA depend on !COMPILE_TEST.

No.

WTF is wrong with you?

You're saying "let's turn off this compile-time sanity check when
we're doing compile testing".

That's insane.

The sanity check was WRONG. People hadn't tested it. Stephen points
out that it was reported to you almost a month ago in

    https://lore.kernel.org/linux-next/20240222220349.1889c728@canb.auug.org.au/

and you're still trying to just *HIDE* this garbage?

Stop it.

                    Linus

