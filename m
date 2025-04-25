Return-Path: <kvm+bounces-44334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 808C1A9CDC0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 18:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78F6D1BC08F9
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 16:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E262418DF93;
	Fri, 25 Apr 2025 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JdVNc3E1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B19189B9D
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745597098; cv=none; b=ideNURJptvt70K9ax+MVw7xa3Xom52l4SJLlAaV4VL/KiTWLKzkArznmfygFJiIObsOyaxIUb5VSRQzH2aqjv1S5W534CAr10vyBUWVcs+XkmQ8O2XlzYXTTk+y329axmkBBLE4+tRB7xJKyeVcyA/MafKrFbRVwPZTo8IryB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745597098; c=relaxed/simple;
	bh=23QgPi6XF0jIetS0s+QPwlevn+YBcwsl063Mh1cXQaU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=EVq4nZWaevcLDVcJHp1dUayDjLKzTkWAD42Eb6rv9T8plYAwlPd5szW8iNP43i4IBMKyu8CDgukw87Eo5ANRFBE+lQBycr9bdbwm9b9xULWAAL+Y5c0w54LfYQ9SlTZOiCy1L2ScnWMvqLiO5fIpMq1uPRg3TMOY4eZ/GWAjQvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JdVNc3E1; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39d73b97500so127770f8f.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 09:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745597093; x=1746201893; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVmQISaVL5Cg2XsgzQXK0sbbtQNmhL4LdWnCYGEZ450=;
        b=JdVNc3E1vu+5NCR6xLM5WpSyAA6nYltdhfBvxzkGHaU4GOFNIt/DvRYUsJkogEwf/p
         kZMo10t6xroBvou/QD+GvXOHg6BzwLzi+jO3aqzNjfkAHXqkoMbows2AkCr3hZ016fo5
         giUQnhM1Pi07aqIm1tv1shGr1DjcBIYz3BYLTvoeMwQQ2bZfI3DnFs0SuHG4KXuSbKpZ
         FC+iyb8/kahe4wfzYrXzqSBmhCGhS6NeEw2LKgFZx0h+RbjcEw29qqRDTYgL1Eh6FUAg
         vBpw+u0YNuDELKUZlmeDL4t42OeDYhjTG8ISAWz2YjPqA7zqBKqI3dUEHWwBvwoGL2Kk
         27yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745597093; x=1746201893;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vVmQISaVL5Cg2XsgzQXK0sbbtQNmhL4LdWnCYGEZ450=;
        b=rhqhpx7uvdauz4AQzxvq0gZ5OxLqSibgTqrHXbh7RF3nJt/Zk8HXJCa7o7xM8e8t4x
         vTQykLaTPDiK4GlWirUxWHA/1lCtEPWp63r0W3t1wOQ6AYerH/qbXHXmd7ek1ar1wppX
         sOBA/zeunjA04jcMiLn2E212SAFGixScbmgcVf0IdiGdE1TzyIITXtm8pi9jGJ5KChO9
         sms7l4HCaNmHAusaI0HlnF/82A5Bc7+YrcBm1DeUde0XcRlEZfdFRxejzQXBXc4lKjme
         R5RSfRjB4N3b1mNVkCb/1hYS20usNIx5JXfu145XGDD60wdnwQATJndnf60OOz+ufSVV
         eRMA==
X-Forwarded-Encrypted: i=1; AJvYcCXrsrQ5pvZJFgtLAmWeJSTeo8XKS5fXJ1JwbO67ReTSpjQjT4pNpdfWC88MIELMtpeCYKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+GRNGVoOnt+0jX8r/xgM7vPpOLUVfmPv9cChSyHxIPdpC9+HK
	AFhQHQre/2KFREwkACU+h+EjzLx9CrmPGmPft3UlMT+Wq8SNCSAE5fKZ2GbtLFI=
X-Gm-Gg: ASbGncsj6MD8nOrsxWQ2WulQQYDCTcVekheh8z47PI2izxVVtqthtxSReY+jfmWT+OA
	/NjKf/ud5+43iwfwqjJcedFc2rqsdyJxW4zpV3QpxxIt93ds7u4Eg9Dc30oxDl8iHaM96QaKjY4
	sWNgAjswZJZH5bfcVZcc/ofTW8Cp0f1u43BsGTiQTL2IH8uSUAbROvdrGogHMjeY41A5MPOSPP7
	d+c/OUBYLlK8hJ6ZSWvoiANePb6NuvrWgpW9Xr8T5Gs2StHs0fYLPBZJFmeASUSwb9HKoUmKaZY
	5bGVb2GEKQTx1KcD9wLgXzi+sr1L8uW+tu5uXIydOpf9fUVv
X-Google-Smtp-Source: AGHT+IFygwyNuR6Mluia/w4Oq01jCNKf5/yVIETD2X/Y28L1PTlwfkhtOAURq+PQcMZWcGjTeDYsfw==
X-Received: by 2002:a05:6000:2211:b0:3a0:1d90:f7c1 with SMTP id ffacd0b85a97d-3a074d90429mr834424f8f.0.1745597093416;
        Fri, 25 Apr 2025 09:04:53 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:84a3:2b0a:bdb8:ce08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e46981sm2731522f8f.66.2025.04.25.09.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 09:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Apr 2025 18:04:52 +0200
Message-Id: <D9FUIXQ1FIHS.2BLRCEWLXZL45@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming
 runnable
Cc: <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Anup
 Patel" <anup@brainfault.org>, "Atish Patra" <atishp@atishpatra.org>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Mayuresh Chitale" <mchitale@ventanamicro.com>
To: "Andrew Jones" <ajones@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
 <20250425-2bc11e21ecef7269702c424e@orel>
In-Reply-To: <20250425-2bc11e21ecef7269702c424e@orel>

2025-04-25T15:26:08+02:00, Andrew Jones <ajones@ventanamicro.com>:
> On Thu, Apr 03, 2025 at 01:25:23PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 wro=
te:
>> Beware, this patch is "breaking" the userspace interface, because it
>> fixes a KVM/QEMU bug where the boot VCPU is not being reset by KVM.
>>=20
>> The VCPU reset paths are inconsistent right now.  KVM resets VCPUs that
>> are brought up by KVM-accelerated SBI calls, but does nothing for VCPUs
>> brought up through ioctls.
>
> I guess we currently expect userspace to make a series of set-one-reg
> ioctls in order to prepare ("reset") newly created vcpus,

Userspace should currently get-one-reg a freshly reset VCPU to know what
KVM SBI decides is the correct reset.  Userspace shouldn't set-one-reg
anything other than what KVM decides, hence we can currently just let
KVM do it.

>                                                           and I guess
> the problem is that KVM isn't capturing the resulting configuration
> in order to replay it when SBI HSM reset is invoked by the guest.

That can also be a solution, but it's not possible to capture the
desired reset state with current IOCTLs, because the first run of a VCPU
can just as well be a resume from a mid-execution.

>                                                                   But,
> instead of capture-replay we could just exit to userspace on an SBI
> HSM reset call and let userspace repeat what it did at vcpu-create
> time.

Right, I like the idea.  (It doesn't fix current userspaces, though.)

>> We need to perform a KVM reset even when the VCPU is started through an
>> ioctl.  This patch is one of the ways we can achieve it.
>>=20
>> Assume that userspace has no business setting the post-reset state.
>> KVM is de-facto the SBI implementation, as the SBI HSM acceleration
>> cannot be disabled and userspace cannot control the reset state, so KVM
>> should be in full control of the post-reset state.
>>=20
>> Do not reset the pc and a1 registers, because SBI reset is expected to
>> provide them and KVM has no idea what these registers should be -- only
>> the userspace knows where it put the data.
>
> s/userspace/guest/

Both are correct...  I should have made the context clearer here.
I meant the initial hart boot, where userspace loads code/dt and sets
pc/a1 to them.

>> An important consideration is resume.  Userspace might want to start
>> with non-reset state.  Check ran_atleast_once to allow this, because
>> KVM-SBI HSM creates some VCPUs as STOPPED.
>>=20
>> The drawback is that userspace can still start the boot VCPU with an
>> incorrect reset state, because there is no way to distinguish a freshly
>> reset new VCPU on the KVM side (userspace might set some values by
>> mistake) from a restored VCPU (userspace must set all values).
>
> If there's a correct vs. incorrect reset state that KVM needs to enforce,
> then we'll need a different API than just a bunch of set-one-reg calls,
> or set/get-one-reg should be WARL for userpace.

Incorrect might have been too strong word... while the SBI reset state
is technically UNSPECIFIED, I think it's just asking for bugs if the
harts have different initial states based on their reset method.

>    set/get-one-reg should be WARL for userpace.

WAAAA! :)

>> The advantage of this solution is that it fixes current QEMU and makes
>> some sense with the assumption that KVM implements SBI HSM.
>> I do not like it too much, so I'd be in favor of a different solution if
>> we can still afford to drop support for current userspaces.
>>=20
>> For a cleaner solution, we should add interfaces to perform the KVM-SBI
>> reset request on userspace demand.
>
> That's what the change to kvm_arch_vcpu_ioctl_set_mpstate() in this
> patch is providing, right?

It does.  With conditions to be as compatible as possible.

>> I think it would also be much better
>> if userspace was in control of the post-reset state.
>
> Agreed. Can we just exit to userspace on SBI HSM reset?

Yes.  (It needs an userspace toggle if we care about
backward-compatiblity, though.)

How much do we want to fix/break current userspaces?

Thanks.

