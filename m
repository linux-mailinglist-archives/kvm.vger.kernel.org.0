Return-Path: <kvm+bounces-22798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F029433DD
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 18:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BFCA1F22CD8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 16:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905091BD000;
	Wed, 31 Jul 2024 16:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OPxNZr4+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBDD1BC083
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722442093; cv=none; b=qga1MsrRrNltTKPwQ/8AI84cYstSNrrPQ6zTJ7sTc4kJf0HgG7LvEyMfiEbSkjl2u4NdkQLeTh3Lcx7XCoRQoR/Pf2VunWKLxMf1mslH0QKC5Ze+BDn2dEQyVnbg/tpl6MYnp51lg+aTzi69uASAAeWjbVFuXh2k+AGUT38Z9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722442093; c=relaxed/simple;
	bh=TxRgMungOKUObRv5Bwb73PU4MAgBMOeeymQ3Pv/4WHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CY+/6Kp0ZGpOgXmnj5pULZGhf825WyIaJyqJCvZxK38dLpzUsFLDxQ9y4RSWaVxYuBLaxqqk+Js+XL0v6w0m4sbl8BUWwM/vpbef1KyXx07jS/pDkfeYryRh4prBuzONN99NKLXHvWQvMrzAxYh7YR/9w2KkRbupgfYxLzzWpdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OPxNZr4+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722442091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7W0ZiLKeSZAsU0ucqOVg1N0XEA5D5eoulVuuQsZPP0=;
	b=OPxNZr4+yUWTXAiynPtlokkV8sJ3yBxTes5Dz703iGi6UKg7Bj8ye+wGab+AsPem1SodBl
	wLhlR4yt9HAd7uzhyVCvvF737zRRbwtIEkdSnPTgVxIYky+JVRm8egZbpWxfFpPuH4sCVl
	l5cKRQ3Nk7OU/IsQFy8Zur8zRO1yasU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-FuSQADJeNdW7EMj78VXDoQ-1; Wed, 31 Jul 2024 12:08:09 -0400
X-MC-Unique: FuSQADJeNdW7EMj78VXDoQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4281f8994adso26540485e9.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722442088; x=1723046888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7W0ZiLKeSZAsU0ucqOVg1N0XEA5D5eoulVuuQsZPP0=;
        b=G6UsmzhNYa+fYfmdzQL70+HMV1GZ+EAp7aNzDA646OmN2R+eedg+arou0SqnZ9b9jT
         0It8jLRT3cNjpxRViPFS7ALgYA25NLE4xAbKV6yqpIbDDQv3+CLaMQCmGaIHpJqnUb2Q
         dCuvCtnOrfabyGlzfOF/Eaf1NITIAJqCX9dfFXlCVcCtRjdJDX43cSbPU5vQO2hShsR5
         hBg9iDh/QFgKcwd9nfgb/bDlhluFX5oBC1OQ1DtMHZHAAsledYf+xcqka0SQj+yLwiHZ
         HTmDdrh4S2KxB/RATmUcJmWghgQk2JoaEkIN7a5LvpGhe1beUh25XnniQP4H5xKj0mq6
         uErA==
X-Forwarded-Encrypted: i=1; AJvYcCUrj12869z0CevOfRs1FCT0YFGw3PtYYIOYT8tmD5V2CdvdF8iExnE0LKWQs64ZdmxmiZdrecTRPRf3niCqYIIi3Xiq
X-Gm-Message-State: AOJu0YyMXzJfRdqhS1IfvAh6E8VfF+yzValMO/TY23bqu0re0prBrUOA
	yPsOJ/aCHXM6MUiluZQ7IzVB7aEyermY+fmlb1QRV53FQeJTVz8gpqwxoZ/00O+J5+3Riql1eIM
	rh0aX1W+/wo7jFhNM5V+tj05B2gnRAuUkudVwVwXD12qQB85E47oqRa3175Vtzxv+M68z3Ep9lJ
	dfW5VJfLvc09HWobFD2E2RxCIm
X-Received: by 2002:a05:600c:500d:b0:426:59aa:e2fe with SMTP id 5b1f17b1804b1-42811da0c21mr101166985e9.19.1722442088443;
        Wed, 31 Jul 2024 09:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXNXmdxukknFbORSsLN9RAmLlNZbQ4SYaLs+1BDxL6OKg7iIzHbgjnwDmN9W7kbPXlvKfLknKmgszAMbjmk4M=
X-Received: by 2002:a05:600c:500d:b0:426:59aa:e2fe with SMTP id
 5b1f17b1804b1-42811da0c21mr101166805e9.19.1722442087991; Wed, 31 Jul 2024
 09:08:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com> <ZqlMob2o-97KsB8t@google.com>
 <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
 <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com> <CAPm50aJ2RtxM4bQE9Mq5Fz1tQy85K_eVW7cyKX3-n4o7H07YvQ@mail.gmail.com>
 <CABgObfb2MX_ZAX3Mz=2E0PwMp2p9XK+BrHXQ-tN0=MS+1BGsHg@mail.gmail.com> <ZqpWIXR1I53SD1-7@google.com>
In-Reply-To: <ZqpWIXR1I53SD1-7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 31 Jul 2024 18:07:56 +0200
Message-ID: <CABgObfa8m1mfmTpVi13zVzEUKiZhKMFe8=rVBum=ORioS6d=xA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: Sean Christopherson <seanjc@google.com>
Cc: Hao Peng <flyingpenghao@gmail.com>, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 5:21=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> It's not even remotely close to 100 instructions.  It's not even 10 instr=
uctions.
> It's 3 instructions, and maybe two uops?

Well yeah, I meant 100 instructions over the whole execution
of the VM...

Paolo

> Modern compilers are smart enough to optimize usage of kvm_mmu_commit_zap=
_page()
> so that the caller inlines the list_empty(invalid_list) check, but the gu=
ts of
> the zap code are non-inlined.
>
> So, as is, the generated code is:
>
>    0x00000000000599a7 <+55>:    mov    0x8d40(%r12),%rbp
>    0x00000000000599af <+63>:    cmp    %rbp,%r15
>    0x00000000000599b2 <+66>:    mov    0x8(%rbp),%rbx
>    0x00000000000599b6 <+70>:    je     0x599d6 <kvm_zap_obsolete_pages+10=
2>
>
>    0x00000000000599d6 <+102>:   mov    0x8d48(%r12),%rax
>    0x00000000000599de <+110>:   cmp    %r14,%rax
>    0x00000000000599e1 <+113>:   je     0x59a5f <kvm_zap_obsolete_pages+23=
9>
>
>    0x0000000000059a5f <+239>:   mov    0x8(%rsp),%rax
>    0x0000000000059a64 <+244>:   sub    %gs:0x28,%rax
>    0x0000000000059a6d <+253>:   jne    0x59a86 <kvm_zap_obsolete_pages+27=
8>
>    0x0000000000059a6f <+255>:   add    $0x10,%rsp
>    0x0000000000059a73 <+259>:   pop    %rbx
>    0x0000000000059a74 <+260>:   pop    %rbp
>    0x0000000000059a75 <+261>:   pop    %r12
>    0x0000000000059a77 <+263>:   pop    %r13
>    0x0000000000059a79 <+265>:   pop    %r14
>    0x0000000000059a7b <+267>:   pop    %r15
>    0x0000000000059a7d <+269>:   ret
>
> and adding an extra list_empty(kvm->arch.active_mmu_pages) generates:
>
>    0x000000000005999a <+42>:    mov    0x8d38(%rdi),%rax
>    0x00000000000599a1 <+49>:    cmp    %rax,%r15
>    0x00000000000599a4 <+52>:    je     0x59a6f <kvm_zap_obsolete_pages+25=
5>
>
>    0x0000000000059a6f <+255>:   mov    0x8(%rsp),%rax
>    0x0000000000059a74 <+260>:   sub    %gs:0x28,%rax
>    0x0000000000059a7d <+269>:   jne    0x59a96 <kvm_zap_obsolete_pages+29=
4>
>    0x0000000000059a7f <+271>:   add    $0x10,%rsp
>    0x0000000000059a83 <+275>:   pop    %rbx
>    0x0000000000059a84 <+276>:   pop    %rbp
>    0x0000000000059a85 <+277>:   pop    %r12
>    0x0000000000059a87 <+279>:   pop    %r13
>    0x0000000000059a89 <+281>:   pop    %r14
>    0x0000000000059a8b <+283>:   pop    %r15
>    0x0000000000059a8d <+285>:   ret
>
> i.e. it elides the list_empty(invalid_list) check, that's it.
>


