Return-Path: <kvm+bounces-8476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9C884FC86
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F1431C26C2E
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D0F82892;
	Fri,  9 Feb 2024 19:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCzptNqt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3579643148
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707505305; cv=none; b=ZKY9Bvn/f8t0/TklNtBUqg3+TCq8u+i1HYZGe4sowoX9/AFBgUUIPKFinLADmwtkRWNqz1xkBPQkPJCPOJhS8IMJBt3qt4nnoYF1jpASvXBG5+wDi8QAQhBpx3XMgPuFndWFf2XkcnESA70WbvRKdmacSoMbXT2u9NvDlJhj008=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707505305; c=relaxed/simple;
	bh=/Fi6BzVbQmG5nVQ63UG70WqUaLeYJODCbbDv9TLG8F4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBainflHrvicPDcgICLs+TAl00WXQ6PjGgWCKkQmwXUdHlPbsPl8TFzmuXSGnWgVIfFLSV9BMA5RMQg/RA1ipWyoAJN7Uj5ueA/eCtz1Ac1DHYqiCqmhEKdum3hsCQcwG6Up+2avpl5wSj4xDw3vVnyt7QgkNHPOBjErKZFLSTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCzptNqt; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-511717231bfso1640408e87.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 11:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707505302; x=1708110102; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IdZXKSMkBRnCj9HwTG4zGu6FPnSLltcxrc9e3CQDYLI=;
        b=OCzptNqtiODz+UiHiLte5mCCG0wbaplo0sV6dG+X3XzJ3G2cUrTICSgtHwTWexeLee
         cdlxeqAPzUvPfHhgE+yvA+/KG0I4NRvOcMcHPTFEY2c/5WYn5IVgqIzgqHr/oJ5gtNuz
         0DRhTeQapHqw3SHxZz+VER/rpI3nRsFLNRqY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707505302; x=1708110102;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IdZXKSMkBRnCj9HwTG4zGu6FPnSLltcxrc9e3CQDYLI=;
        b=jnWWUyfnmYBEN7RrhLljyolcz2TKEwNAdDICW11B5BmObH9xJKOmDP02De9JAyoxd7
         t/CrNShlZMsgPcRy4yX1HmuhEe1Qe6sQavakKUdSSUzLK0eJx/spw9buZ7GYSsUZC9dC
         avjhxrn7lkj6yUx2ghkrPqQAZYukpVfS5ivYvIjVfxotqEc1mOxTeo7dMdLSBYB76HCz
         TC5puz7BpRDC0u/hhwdgTm0nLA1rMqzzmTe/WgUdCHHhZgFRUJeUtTQPQFzMTzWibVky
         LrvKbEiSSUrtVFhPOLBJlo8xkEcMF1Gx/Qo/oznpkHp1F+POAo7HCuT7NBbzv1iJlapA
         dBNg==
X-Forwarded-Encrypted: i=1; AJvYcCXdGpjVCzigkseSiABcvo688XOpXTknGXpqaW4CydhfPIwIoTluCqjePuw3wtPWFHLpZvHanhZhzNWA1R6Li6Z2B6s/
X-Gm-Message-State: AOJu0YzV1JH0Mw4NVqoEoWO92c+nBEH4J9u3b7QXijOgjbWsGMtVunZl
	qipD9T2oxaBnypLZdRn6X3qKGRjsQRJre6cwFHAJY9UqsMX9I4mDzMCuvzgGxIcqB9YYbjAS6pI
	Obsc=
X-Google-Smtp-Source: AGHT+IEtQA6h9kGOwNn/f4gQrQ37+1Suir9/fZsQ35O2FBZ3HQ0f+L4oF5uqkctNdysG+O+GVhtI2g==
X-Received: by 2002:a05:651c:544:b0:2d0:e32d:aa89 with SMTP id q4-20020a05651c054400b002d0e32daa89mr510195ljp.37.1707505301900;
        Fri, 09 Feb 2024 11:01:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXp0JJHVFQCo5UPj0N0gyIplLIVPU//cqT5tMQgVdY1gS6OFm9/qZHDJLnwQFES0OEed4CT5U1D7re2rp12bROxy/Gs
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id c32-20020a509fa3000000b0056020849adfsm16585edf.26.2024.02.09.11.01.41
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 11:01:41 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-55f279dca99so1931780a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 11:01:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWUsXWvdNDlhXd/+n5OHD7VFmACfCTxWXA+sCLjJOnIFgMKh9dxS+NfJ7Sr49xS6BQ5SVsTekXuX/jLaqE8ARaKAMtS
X-Received: by 2002:a05:6402:5d82:b0:561:3d83:96a4 with SMTP id
 if2-20020a0564025d8200b005613d8396a4mr1642420edb.42.1707505300634; Fri, 09
 Feb 2024 11:01:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
In-Reply-To: <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Feb 2024 11:01:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
Message-ID: <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Feb 2024 at 10:55, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> And also pessimizes all asm gotos (for gcc) including ones that don't
> contain output as described in 43c249ea0b1e.  The version checks would
> at least not pessimize those.

Yeah, no, we should limit that workaround only to the asm goto with
outputs case.

We should also probably get rid of the existing "asm_volatile_goto()"
macro name entirely. That name was always pretty horrific, in that it
didn't even mark the asm as volatile even in the case where it did
anything.

So the name of that macro made little sense, and the new workaround
should be only for asm goto with outputs. So I'd suggest jmaking a new
macro with that name:

   #define asm_goto_output(x...)

and on gcc use that old workaround, and on clang just make it be a
plain "asm goto".

Hmm?

            Linus

