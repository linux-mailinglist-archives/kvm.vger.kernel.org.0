Return-Path: <kvm+bounces-27276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 365A997E1C1
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABC4281410
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A27139D;
	Sun, 22 Sep 2024 12:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wL45NcHc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DFD653
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009829; cv=none; b=nHMKNS3xZiQFcmS5PuFdKtFqSk5Y1NQQcjf/4XO1bDVqq+m1SwFjco0GQE3slduIyuHQppDwRZBJHN8Lgx6KtUdSz7LdclGez/HCjH2KdgcjuBnm0EjmcWA9FZKv9XU09PXeAsIqTu37PCVAA9AH6f95v/JIdt0ZCytBN0C1gQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009829; c=relaxed/simple;
	bh=0tebIIrK5//W75VvtcWE7S3HcGIK9kOTEzW/5IwFDv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/y91QwzPx++hwzHoM3vQ8H1TFeWr3aAcRo051pGo8LLndJTl0yYR07uQBv7oeQ86rrz1OnJQGElw5Gro2eXdlzs2/hNcM5KX0NhDvE3MtqpMOlVqhLnsmoFaPjUBRDc33+0r2r1Cx38ro7fM4eQDHz5YwnAwBg6SaKlgw3uhSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wL45NcHc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ddd7800846so61477617b3.0
        for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 05:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727009827; x=1727614627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e/jx3gAZzZMVdg0hAqALZvpfrYjhHi2X7D1wGU9NNbs=;
        b=wL45NcHcFZMvMp2uMxhlYYOrQBagXQVt7KqHmmNUDnSMnIgiQLw1l6oOYiWJ74pdaX
         XDw40VLvWAZoBzFopLiTFBNWTOADzNdgecbF/jAzJ6j/VoT5v9b6XlyI+xxJcBwj9B/+
         jivdSmquwa5IZvGDySbQc+rzLooQEgJn8+33XRGOkW7Ln7s9JWZBwk43aVOPzDICgL0O
         zNZfJNcG8jQ3Kk0FP2hnny8CYS42jo+T2k4XDvNB0ZST+GoxpjhmRTMQ9lxf3NQvsDRu
         L3m5slHlDK7RpVuoBoa7uZ7MyVeD5f4CvynQB3hV8h60qTbhnHlrcmQI/5r2ACQzAvLf
         o4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727009827; x=1727614627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/jx3gAZzZMVdg0hAqALZvpfrYjhHi2X7D1wGU9NNbs=;
        b=bLTQgkrQUPJSceEhO91Dmxh+AJ2pmNT9wOAaXpH3y0xwtD4F1ZzB8owqkk8xKFDEhZ
         plApv6N9nmfM4TxfNpzC8PB8KqOtQRmFuur14QtnIJ4ipOLoU5D4mM1SSEdAIJCSOkIH
         pDTVeaEdHUsh3ZI/9ZTjixjlagOUp2f0lgrZ/TQ7rQESZD6ULduTUE+oZpWCAQlMujKE
         7r44AMQ6iVjf1izvp7rU3PaXrt2lUK9vfEy4Qw2hIRPA/As7EmYK7Wrh5DOyNfTjcGgX
         5PuA1zzHYOtZJxIJEikYieJncpR1h96xzo8gUPK/mclEyhIg7d0YNwbqV8qRXNUGCoIG
         RFmw==
X-Gm-Message-State: AOJu0YxXDMuXWk0TsLAxXdA9EsHtc2d+xBlcy7OZodHPfLp45EQacpfl
	m43boWCN8HzBfcS73O5U2gAbvi1riHdeMvC7D0r8z6Deq10QRHgQnWtu4vBnpnezF4C/Nwa5JIG
	hvg==
X-Google-Smtp-Source: AGHT+IGQTIxqXbOA4oq8qRYp1uDWJL1K9q9Np7kTmTB4EQgJg3WubCDFTPknsEJCsz4OZMBnPkn/cmW0aT0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a88a:0:b0:68d:52a1:bed with SMTP id
 00721157ae682-6dfeec11e0amr174107b3.1.1727009826880; Sun, 22 Sep 2024
 05:57:06 -0700 (PDT)
Date: Sun, 22 Sep 2024 05:57:05 -0700
In-Reply-To: <20240820230431.3850991-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820230431.3850991-1-kbusch@meta.com>
Message-ID: <ZvAUIaZiFD3lsDI_@google.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, Keith Busch <kbusch@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xu Liu <liuxu@meta.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Keith Busch wrote:
> To test, I executed the following program against a qemu emulated pci
> device resource. Prior to this kernel patch, it would fail with
> 
>   traps: vmovdq[378] trap invalid opcode ip:4006b2 sp:7ffe2f5bb680 error:0 in vmovdq[6b2,400000+1000]
 
...

> +static const struct gprefix pfx_avx_0f_6f_0f_7f = {
> +	N, I(Avx | Aligned, em_mov), N, I(Avx | Unaligned, em_mov),
> +};
> +
> +static const struct opcode avx_0f_table[256] = {
> +	/* 0x00 - 0x5f */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> +	/* 0x60 - 0x6F */
> +	X8(N), X4(N), X2(N), N,
> +	GP(SrcMem | DstReg | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> +	/* 0x70 - 0x7F */
> +	X8(N), X4(N), X2(N), N,
> +	GP(SrcReg | DstMem | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> +	/* 0x80 - 0xFF */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> +};

Mostly as an FYI, we're likely going to run into more than just VMOVDQU sooner
rather than later.  E.g. gcc-13 with -march=x86-64-v3 (which per Vitaly is now
the default gcc behavior for some distros[*]) compiles this chunk from KVM
selftests' kvm_fixup_exception():

	regs->rip = regs->r11;
	regs->r9 = regs->vector;
	regs->r10 = regs->error_code;

intto this monstronsity (which is clever, but oof).

  405313:       c4 e1 f9 6e c8          vmovq  %rax,%xmm1
  405318:       48 89 68 08             mov    %rbp,0x8(%rax)
  40531c:       48 89 e8                mov    %rbp,%rax
  40531f:       c4 c3 f1 22 c4 01       vpinsrq $0x1,%r12,%xmm1,%xmm0
  405325:       49 89 6d 38             mov    %rbp,0x38(%r13)
  405329:       c5 fa 7f 45 00          vmovdqu %xmm0,0x0(%rbp)

I wouldn't be surprised if the same packing shenanigans get employed when generating
code for a struct overlay of emulated MMIO.

[*] https://lore.kernel.org/all/20240920154422.2890096-1-vkuznets@redhat.com

