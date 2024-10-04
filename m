Return-Path: <kvm+bounces-27913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C55990487
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 15:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79B85B20B42
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 13:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B333A2101A8;
	Fri,  4 Oct 2024 13:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nQZyQRxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7420FA9D
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728048932; cv=none; b=cPTiMutbkDxyRf4Hn2ECUhJXvpxqR8I9q+ObBRjNCq9Wn8f+ZXSSK6YZ95Au6qVPq2V2Ey3DbW8Dpuk5nWAB2YmjBsfbA2EzYWQzt3wamtXeZ49+b+wIpVhew3mN/e3btPHkyKQQuxi2Bdl6HfmDfOH9lZuUQ7zpwhdTtAmad9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728048932; c=relaxed/simple;
	bh=ZkmyxQ3QOTQso2mGTJ7hRHIUqp7vFnEruN8aoDO2Jok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NHnLTLXlW5x4mL8LomwcC8zdNhXcGRvifYlsYObpx0fmiD65IRttI+qwXJb5WbUBx84l2tezHPZyLEPiexAdbfBXkhU64jcCHkMi29uhI5nQnfWjeYe1eclY+sBFzzKnVazjEFvBSgjumWbR2EGzgCn5NaA8XSpvFWWZ4V7PXuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nQZyQRxZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e262e764f46so3472103276.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 06:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728048930; x=1728653730; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRKRcRUT8iLe/fkq4dl/vkLTjdTfTheBiakbS3Xtaxg=;
        b=nQZyQRxZ3Gwr5xPE4/CkHe/lVN1U9IMNaO1D7fMmUM6rqVi4ryEwcqaScLovw+SK78
         SV6njv7uAT/XO1sRhVO5FBsDKi6ewQyBgyXAvvux94UQnGpcBX3aEI64jFlqGtHzZM7F
         aVsL2IMViUnztx4Y3uobrARcx+dZc4c7zeSevTJSXvbZkxWXcJjjNgmKt0lqJku+0Haf
         H8iBbV1U5t1auqvuB0rAj1RXDt9ZXxO0XEWsLB+czn2LY3ZdhMidkej30HAuu11k2BnA
         +JWgKM/PtDm37AQqPwA9mTHuXZ5sAcLbb+nyfpoAIKOmXl9z9xJw/uFTSFeZZcFNzkTD
         VZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728048930; x=1728653730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRKRcRUT8iLe/fkq4dl/vkLTjdTfTheBiakbS3Xtaxg=;
        b=ltBYctQz57yUHb6/Totn7WQ5fjCd3KQ0r/wR83DIJ114cuKzBzKN0h93JclEvBAbkL
         ygvKjaFNyzpfkVsgjTT/wlQdvFg9IkWH0M4Aqu17TWZuPzYXoe+vb8AAJmXfxGjT5BGa
         dkHs3Trik+hTCXy56JCirf+v8evvCx6a/qo2aR7yaM0Dd6K/55i9xNZ6x/DOHOtT5tei
         E/Qwl5aC3xWOCFiyLygmybpwNB6suGkqgHDHz3QcaVMUjMnuOrfC1E4vnxI6E37HJ70Q
         hPZtwnfgUpX9AoL7HJBhRrRd7IfCVapLUgaqTtLFv7y1ujO7YJP7X4FZbNMqAGOMSkXs
         bRIQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6CsV74BEcQi9FHHf8cANT87PHs8lKen39TeTrKv2L3s8va6eTBqR3j/izmeAzh/h5V2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqbzAI8dzkIHADtwjEifCbjhwjNLt5IWzolDIlqrAvdrHhrAa2
	zS4ubNNfpA3LEUT0WH9b69pGWNHD1JN03ixBARlPpBWvVFnUAjk8TJ2gluFlXkFNeNO8KqNdIT2
	Xgw==
X-Google-Smtp-Source: AGHT+IGrQhmBThdQjeJmJqP3+NLqTBL86x6LnHPI+mDohnEHno+IVTKZ8ehf4O7OsYSKHm7wAkLZux85E7s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d804:0:b0:e28:8f00:896a with SMTP id
 3f1490d57ef6-e289393a895mr1609276.8.1728048930376; Fri, 04 Oct 2024 06:35:30
 -0700 (PDT)
Date: Fri, 4 Oct 2024 06:35:29 -0700
In-Reply-To: <87v7y8i6m3.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com> <20241003234337.273364-6-seanjc@google.com>
 <87v7y8i6m3.fsf@redhat.com>
Message-ID: <Zv_uvVT9RmiN84y_@google.com>
Subject: Re: [PATCH 05/11] KVM: selftests: Configure XCR0 to max supported
 value by default
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 04, 2024, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > To play nice with compilers generating AVX instructions, set CR4.OSXSAVE
> > and configure XCR0 by default when creating selftests vCPUs.  Some distros
> > have switched gcc to '-march=x86-64-v3' by default, and while it's hard to
> > find a CPU which doesn't support AVX today, many KVM selftests fail with
> >
> >   ==== Test Assertion Failure ====
> >     lib/x86_64/processor.c:570: Unhandled exception in guest
> >     pid=72747 tid=72747 errno=4 - Interrupted system call
> >     Unhandled exception '0x6' at guest RIP '0x4104f7'
> >
> > due to selftests not enabling AVX by default for the guest.  The failure
> > is easy to reproduce elsewhere with:
> >
> >    $ make clean && CFLAGS='-march=x86-64-v3' make -j && ./x86_64/kvm_pv_test
> >
> > E.g. gcc-13 with -march=x86-64-v3 compiles this chunk from selftests'
> > kvm_fixup_exception():
> >
> >         regs->rip = regs->r11;
> >         regs->r9 = regs->vector;
> >         regs->r10 = regs->error_code;
> >
> > into this monstronsity (which is clever, but oof):
> >
> >   405313:       c4 e1 f9 6e c8          vmovq  %rax,%xmm1
> >   405318:       48 89 68 08             mov    %rbp,0x8(%rax)
> >   40531c:       48 89 e8                mov    %rbp,%rax
> >   40531f:       c4 c3 f1 22 c4 01       vpinsrq $0x1,%r12,%xmm1,%xmm0
> >   405325:       49 89 6d 38             mov    %rbp,0x38(%r13)
> >   405329:       c5 fa 7f 45 00          vmovdqu %xmm0,0x0(%rbp)
> >
> > Alternatively, KVM selftests could explicitly restrict the compiler to
> > -march=x86-64-v2, but odds are very good that punting on AVX enabling will
> > simply result in tests that "need" AVX doing their own thing, e.g. there
> > are already three or so additional cleanups that can be done on top.
> 
> Ideally, we may still want to precisely pin the set of instructions
> which are used to generete guest code in selftests as the environment
> where this code runs is defined by us and it may not match the host. I
> can easily imaging future CPU features leading to similar issues in case
> they require explicit enablement.

Maybe.  I suspect the cross-section of features that require explicit enablement
*and* will be generated by the compiler for "regular" code will be limited to AVX
and the like.  E.g. the only new in -v4 is AVX512.

> To achive this, we can probably separate guest code from each test into its
> own compilation unit.

Hopefully we don't need to worry about that for years and years :-)

