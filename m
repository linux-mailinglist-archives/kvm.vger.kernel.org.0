Return-Path: <kvm+bounces-46066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462BFAB16CE
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 16:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 942313BD705
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 14:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13462293B42;
	Fri,  9 May 2025 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="P58N5FQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE492920B6
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799064; cv=none; b=rVyCi8X7jlwge/wGIFW1KavWINqZ0ivf2SKtOYRStjamnDl8jzE0mqlpTfzfexKcVfxd8keLmCk1mkNcv7i3FFa/uwyRi55CfDFExyhuJSf6dm2a0+5RXUxarmtt3R0O20RksygiS2X65Qn9Fp+thxpkwb1FLrazwZvylZ4LgCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799064; c=relaxed/simple;
	bh=uXbSh30SrWCCLUYB2fIrcVdMaScZKq89anW8KRg2CYo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=MsI1kKngxqB9tSkycDj/jFbW5+KkvT211R+i+qJPXwgH1V8eRcFX5ZoKk9gpoWiI1Vboe+adBS/Qf/tQa2NVG63nnyyHUV8P/93HDGE/iuBTtNbgU17u44zgFIb+B9Ke+iymdaK3agFfzQrIovezfC9QhQZnD8q8w0SyYcL9JOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=P58N5FQ8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-44069f5f3aaso799045e9.2
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 06:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746799061; x=1747403861; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89ii3tAdP6qYOru2WdH/cAWgrXsFKNVha3J9tXFOzI4=;
        b=P58N5FQ8PC6Ro9iq8lJAdpjx54i7odd0umPqu+qDcyHX/dPXJts1Nj8AxkGY9ZuAw+
         CeMDrC+HHrY6WToWc9pbtxAo/8mDW7ZPo+HeJ49QksFgpK/ZP0PsR90cGE0gImpetHrD
         6PSoqt6SaQeRtXbSZv2n/Uw/LM/F1aNybRqd70Dfzn8DGj/Il2+QydyQZFlNA5ososp8
         aznRdByTzZjn6cB6DjeWeYvtyiuyAeOUFtnV76lchaCu8JaKVqv2C/ICHEYLvVnZdFu1
         6ljEN2up4WDVfO/eeXm5vIwMfOKvUSNT8EmYuOoma87Ap0W53+lWckYAvvCSGUVy5TBH
         xw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746799061; x=1747403861;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=89ii3tAdP6qYOru2WdH/cAWgrXsFKNVha3J9tXFOzI4=;
        b=ZAtRbYxq+tmchTOkkE/zAy8zH65LJc8TJiMvPBQ3djn8/ehVrtDRB52HvC43BZiPva
         AXsKjM3kN/M2BRuEXDszMY04vMjvUtGlA0qYAIBj/W7OSNfUbQeTjortMnLLaSTJdk13
         LB39aTC010snyQSAt16pD6CkFLd1kez3LTJsxN5VTMeatehOuE3lh4DRqr1nUmc90gv0
         SPHL43Jlt9BL006lkbBq22ZvhfuZi8cNUipb17JgpDVtfY0/w6/TMarxxjRGXCu6g73g
         BuMt+zElhfifEpmptgQ7SQx8Q6CGZddSkQe5zkuX6fwYpubVLh6T7tCfbvUrXSN+wKJA
         36cw==
X-Forwarded-Encrypted: i=1; AJvYcCWAne7S0LcoGporEPy6bMeS/6JtEoJ6XWlI5IM58f4pSGy7VBYjWAG2jH8meX/x1758gDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmFHerz77WOOW2wGHZnJWpLRV8/dH5LjhND3gL3O/wHCA8SuOd
	yad9QOP1v/Yki7OwoUVFn+zU0v2djwGlsbfL9IY9EUfpCA8QE5wwq9RN6WJtet8=
X-Gm-Gg: ASbGncsCrxMQL9fslFg4SdBoVfFhO/bV0JIbFJS9hWo2d7EJY2Z/Krug2Gs0pfb9wMr
	aCqQRiVoZqi75d4eE8fNREhhWIc80oww25FlZAyobeyDEzwqxMn6lSgZy+rpHVVkIYeTBhGXLpt
	eqFMdrfwGpU2ZXf3dz/d5MV1UUPcQNZQ3kEK8ADekoQXCy7Rwaz6yRB0nzdzeegWMBc66jLOr3t
	R3zeFschdsQ8dWIUiaR4+bI1pKhvbuRWvFjCcte2aIN41s/f1XLxsfw0G8neI2WxIx9Jw+7yqRI
	6moBfwrEDqSgJk4+Ok31TJRT34iJEKaLz9AgJQutjlwyKzxF
X-Google-Smtp-Source: AGHT+IEcAmbHJpk5CxOrqm5l+BEA2PNktNRuHCKGe+vwxNwlbx7QLnODKWUwlOC/RXddA54K8TiWJw==
X-Received: by 2002:a05:600c:8215:b0:439:94f8:fc7b with SMTP id 5b1f17b1804b1-442d6c39708mr11774315e9.0.1746799060674;
        Fri, 09 May 2025 06:57:40 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:1f7f:4cfe:e0bb:202b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aeb26sm74090875e9.29.2025.05.09.06.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 06:57:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 May 2025 15:57:39 +0200
Message-Id: <D9ROL5UEYYHX.1B1FE6LZJ9ESO@ventanamicro.com>
Subject: Re: [PATCH v2 2/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
Cc: <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Atish
 Patra" <atishp@atishpatra.org>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>
To: "Anup Patel" <anup@brainfault.org>, "Andrew Jones"
 <ajones@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250508142842.1496099-2-rkrcmar@ventanamicro.com>
 <20250508142842.1496099-4-rkrcmar@ventanamicro.com>
 <CAAhSdy2nOBndtJ46yHbdjc2f0cNoPV3kjXth-q57cXt8jZA6bQ@mail.gmail.com>
 <D9RHYLQHCFP1.24E5305A5VDZH@ventanamicro.com>
 <CAAhSdy2U_LsoVm=4jdZQWdOkPkCH8c2bk6rsts8rY+ZGKwVuUg@mail.gmail.com>
 <20250509-0811f32c1643d3db0ad04f63@orel>
 <CAAhSdy389g=cvi81e7SKAi=2KTC2y9bd17aHniTUr4RNY=Kokg@mail.gmail.com>
In-Reply-To: <CAAhSdy389g=cvi81e7SKAi=2KTC2y9bd17aHniTUr4RNY=Kokg@mail.gmail.com>

2025-05-09T17:59:28+05:30, Anup Patel <anup@brainfault.org>:
> On Fri, May 9, 2025 at 5:49=E2=80=AFPM Andrew Jones <ajones@ventanamicro.=
com> wrote:
>> On Fri, May 09, 2025 at 05:33:49PM +0530, Anup Patel wrote:
>> > On Fri, May 9, 2025 at 2:16=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
>> > > 2025-05-09T12:25:24+05:30, Anup Patel <anup@brainfault.org>:
>> > > > On Thu, May 8, 2025 at 8:01=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99=
 <rkrcmar@ventanamicro.com> wrote:
>> > > >>  * Preserve the userspace initialized VCPU state on sbi_hart_star=
t.
>> > > >>  * Return to userspace on sbi_hart_stop.
>> > > >
>> > > > There is no userspace involvement required when a Guest VCPU
>> > > > stops itself using SBI HSM stop() call so STRONG NO to this change=
.
>> > >
>> > > Ok, I'll drop it from v3 -- it can be handled by future patches that
>> > > trap SBI calls to userspace.
>> > >
>> > > The lack of userspace involvement is the issue.  KVM doesn't know wh=
at
>> > > the initial state should be.
>> >
>> > The SBI HSM virtualization does not need any KVM userspace
>> > involvement.
>> >
>> > When a VCPU stops itself using SBI HSM stop(), the Guest itself
>> > provides the entry address and argument when starting the VCPU
>> > using SBI HSM start() without any KVM userspace involvement.
>> >
>> > In fact, even at Guest boot time all non-boot VCPUs are brought-up
>> > using SBI HSM start() by the boot VCPU where the Guest itself
>> > provides entry address and argument without any KVM userspace
>> > involvement.
>>
>> HSM only specifies the state of a few registers and the ISA only a few
>> more. All other registers have IMPDEF reset values. Zeros, like KVM
>> selects, are a good choice and the best default, but if the VMM disagree=
s,
>> then it should be allowed to select what it likes, as the VMM/user is th=
e
>> policy maker and KVM is "just" the accelerator.
>
> Till now there are no such IMPDEF reset values expected. We will
> cross that bridge when needed. Although, I doubt we will ever need it.

The IMPDEF issue already exists.  KVM resets scounteren to 7, but
userspace wants it to be different, likely 0.

