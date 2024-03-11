Return-Path: <kvm+bounces-11544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC93C87817E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 228C81C221F1
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6D73FBBB;
	Mon, 11 Mar 2024 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdrbjHje"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08BE3D993
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166777; cv=none; b=rri8vhVEK1G1NhQY7UohJqLj0hSYX80Nsx07rrTMuZWXbtWD0yDY7+lKIuIzz2mvfxqlzEm0/khsbaYiCIK2M9OVYjVgYur7X1yyEbr2/ZUx5opS1QaydI5+5OEPBK8QW0b9CuKWYkuIAvo5HzV50q2Dj2rPXlLVl7ZTmmjrirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166777; c=relaxed/simple;
	bh=0gDp7T5P1OWvOqlOUx1gmTE7LgCMhGzx//xP9WYXFhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ay/QCypuE+EA5LH51dkU0gXbIbJdrDERtVEA04fww0pPXkKlv4ynBjacxP3Yd4bjfpxn8aKkg7qetRUN9I+J59EFOLrUTPZYiSqgGAhRK2NIDivSSR1s+t8BRF/iKRKDfNwqAKh9Hkh79vr9sZU8A1ApbK0y1dl1CF6wFbeiLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QdrbjHje; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710166774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fjeIs11/GS4xnw7P/YbolbBH87bCSCu3+iV5r5aUsNM=;
	b=QdrbjHjeKBfp+SlKKzqiL2JsUs9wipS5+WiyBsc5E1ejHOHmbMFiX/WxoteKeS9L11FkAJ
	PM4nX2rVK9RUhVC204TzjGiBNdUkYOgtcj0uX7hvaMab2HMbpBSQt+PmFrlNz9xdj5D5RE
	bB0HY04p4YrTNo+duxitA0pP+myjl/U=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-4LfxYs4GNCuyFAQvsb9u1Q-1; Mon, 11 Mar 2024 10:19:31 -0400
X-MC-Unique: 4LfxYs4GNCuyFAQvsb9u1Q-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d449d68bc3so2968611fa.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166770; x=1710771570;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjeIs11/GS4xnw7P/YbolbBH87bCSCu3+iV5r5aUsNM=;
        b=j+0sii30RCbPgK42FVFeAS1ltke7uHfmSm88V5lKP0lbXe2u8X4ov0r4PyJTvYMFBt
         4wYySQVIjXhFOaN6Wh3kF9wrIdviN4EioiNHTyr0VTM4aCDF3pRtucoxL8A1mRsRFhqy
         3HNcUdTFF8OELr+yFD0x1t8XM2S2T8A/9UmB7O7fI3Nok4RH1TshYzIfcalLuMFBpLDe
         JpokS3IywSrMFAh6brPLTnBTGLR/6oB7NWDO+jqmJnNSU3dHALRYR0mz6Vc1vJRN0PMX
         qXXZYS6TsGy3klt/oMuQyburu2p7DiomufzR1jk/4V8dbC2l1EKuiVRsHpsRJnYohQNz
         pEeg==
X-Forwarded-Encrypted: i=1; AJvYcCVBfY89O6m0q20OYSTi7JRPWBXA8TBlFpQFj8Hep9XAvbfEX9A/boM9EKlMKLYbvTp70SsZsYFb069ArgDOeoOsOnG0
X-Gm-Message-State: AOJu0Yy5UOserjSzpqg4gIa+0ossO3/VLhdofw+BNfx+tcPBe19lfFV0
	ZFRD28srO4EAAPrKKzwvuloFPz261x4NKvr6jf45f3dx8gOmkk0PhliYKMbEq2bqSun3DlTOKUQ
	li8O16gDG3D+PsILUT3PhtsrzJKc3UG/tLXZEgqsvV8NdzjWFaQ==
X-Received: by 2002:a2e:869a:0:b0:2d2:c8c1:d844 with SMTP id l26-20020a2e869a000000b002d2c8c1d844mr4073996lji.13.1710166770309;
        Mon, 11 Mar 2024 07:19:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHenKVxc5lk5fJfJlsecO5k6bHxo+uZ6RjbQWXqALB2AGcnuymWmVp/1W9o9nVZ3YZ3HK6MDA==
X-Received: by 2002:a2e:869a:0:b0:2d2:c8c1:d844 with SMTP id l26-20020a2e869a000000b002d2c8c1d844mr4073977lji.13.1710166769909;
        Mon, 11 Mar 2024 07:19:29 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id x21-20020aa7d395000000b00567fa27e75fsm2940331edq.32.2024.03.11.07.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:19:28 -0700 (PDT)
Message-ID: <f58fd876-3aa7-4c0c-80ef-586862ee9363@redhat.com>
Date: Mon, 11 Mar 2024 15:19:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt
 <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>,
 Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>,
 KVM General <kvm@vger.kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)"
 <kvm-riscv@lists.infradead.org>,
 linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zen8qGzVpaOB_vKa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/24 18:43, Sean Christopherson wrote:
> E.g.
> if this were to happen with a less trivial conflict, the other sub-maintainer would
> be left doing a late scramble to figure things out just before sending their own
> pull requests.

Nah, either I would fix it, or I would look at an older tree from 
linux-next and ask whether it's okay to use that one.

>    tag kvm-riscv-6.9-1
>    Tagger:     Anup Patel<anup@brainfault.org>
>    TaggerDate: Thu Mar 7 11:54:34 2024 +0530
> 
> ...
> 
>    commit d8c0831348e78fdaf67aa95070bae2ef8e819b05
>    Author:     Anup Patel<apatel@ventanamicro.com>
>    AuthorDate: Tue Feb 13 13:39:17 2024 +0530
>    Commit:     Anup Patel<anup@brainfault.org>
>    CommitDate: Wed Mar 6 20:53:44 2024 +0530
> 
> The other reason this caught my eye is that the conflict happened in common code,
> but the added helper is RISC-V specific and used only from RISC-V code.  ARM does
> have an identical helper, but AFAICT ARM's helper is only used from ARM code.
> 
> But the prototype of guest_get_vcpuid() is in common code.  Which isn't a huge
> deal, but it's rather undesirable because there's no indication that its
> implementation is arch-specific, and trying to use it in code built for s390 or
> x86 (or MIPS or PPC, which are on the horizon), would fail.  I'm all for making
> code common where possible, but going halfway and leaving a trap for other
> architectures makes for a poor experience for developers.

I think it's okay if the _concept_ is reasonably arch-independent.  In 
that case, the first who uses it from arch-independent tests has to 
implement it for s390 and x86, but having a function in common code 
makes it possible to use it from the partly-arch-dependent tests such as 
arch_timer.c or get-reg-list.c.

(Now - that is _not_ the case here, because the function is only used in 
the aarch64 and RISC-V specific parts of the tests, but still to me it 
makes sense to have the prototype there).

Paolo


