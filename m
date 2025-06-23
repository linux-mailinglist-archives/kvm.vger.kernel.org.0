Return-Path: <kvm+bounces-50294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D83DAE3B3F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 381101881E40
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 09:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59A9238C0C;
	Mon, 23 Jun 2025 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="M47IxdMV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F82202C2D
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 09:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672500; cv=none; b=FvcDLE4JGoagnwzz1vJ2Id5dHhekCssHJaM2Nm8/q4kn7xoxcG/mI6GzXz484RkIMYD0OqsqTmdBxhXRxWwyPmihVXR8MdtU+i3ej6dxIPxuS8bM+t4ZkBLyHcHrzBbJICPFuM2umrdUu/3c6LgLGqvpiiJVdXWFLjU/I6gfm7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672500; c=relaxed/simple;
	bh=9oh47QkG21KO16LzRfKjVyEi7rtXSfgkKmHNoMC+VVw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Jm5URnp1/bMD/SxGU9jqNojNMegJHVl8liCahsEEZ6hmAgIRC4HYuLUSf6cdUXRtcdjoNHJmqdtDENFLRdKxi/6mCUt7l3t+5G0zSfiti0koTYv28jikJWYoGoNk90b3PoKKxIK+d/Z5yh7k1pl4LPpCfTZ4QwXFzxsei+7WaTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=M47IxdMV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-450828af36aso1187595e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 02:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750672497; x=1751277297; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIpxzH7Ey6NOPuneckkYZHJ6AcvohPz9IFjSsSYVnZQ=;
        b=M47IxdMVfwLlyqvRY63Lysh48p8bvA/DXfkvfrFBieRa963MdMZyrGqAGh3DpsWc29
         IlcPhLY2K50H30h2yDn7m8oLYDBkvA0xOaFJARTaBoQwm4dPA0oKsFuJvBQOa9j3d/H8
         +SlV944lDdx1/v9qxJP9x78ePPy7IMp2ApabDZhFVxumE2Whj67RB45exEXbwy3sQ2hJ
         43XsNAk2JunYwUpwCab/qOWeHTGWD1Bnmiz5PEYBZG1yQR3H/SGbqe9j8Robc+LQpsMX
         z7cwAWmgRXTQ/uW+D+AnaFzbt5XBPm4dCZ79vStbYffPQB108Fa5cbKP7bQA6SuGS11F
         qP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750672497; x=1751277297;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rIpxzH7Ey6NOPuneckkYZHJ6AcvohPz9IFjSsSYVnZQ=;
        b=NkGm0GofUEj1fnvqFvG9oHTIpYBRbh6Pdu7FmphIzCGZ+IkC05Di2YOJLq/j9qzISQ
         dNjyTt9FcqWjDjzGwfLV4z6y0X7PlWLhIrAsMEUAe73uLZdjrqgohMO4gWRCmM/bliq3
         Ek1ZQXoIC2JNPfJre2ExsbpwxgvlEmNzMjH+wwfA+v7R+m2Z+MVywfWAm7+82TWJVRdg
         o0M1lNl24vbqCuDPpqlPKIvnWYkqvSUeMPlDh3CoiOTKrE3CQP0Z7EKBWsVN4mwqYSyf
         mmzlRexerq3DwGGRZaIJvP4TuCZ8tKpZNTVoL76pOvBPXGmMyHur7wSHZzK7Us96ViDj
         VDKQ==
X-Gm-Message-State: AOJu0YyH2IyZgjg478oSOG9LwkeIhysVWXaAWbMfjqQXQcRPsWiGSD/F
	cCKHtFjUMlCIBeVab1h/XmGon/vm2uPNqkY1+DP7kTDnzmOyH3ZmtmUF2AJO63BuCntSd9BFh86
	suSfW+j8=
X-Gm-Gg: ASbGnct1MYDUadInMM0W7Ps2TRBAQCjURjnMWbtUwUxXoKWLPsQG7hIW1+adjShWNWX
	x2HCk8WCtKsi7WCCZn3kSzGhLBDSkPtZlmVHY1PcHfdO6M9CL2Th2ta8heoPeu6GpXc1DnZjHsB
	a4rG8SyY9tgSnpHiMcJeitMkC6QZwjPginE5FM8tfPEI06Jg6p6JuC04vwpUTiqHhNUAHqZvT3X
	AKhCblj7VPFASH44npmGgduZm3/kEyVtcged26Es6qtmI75HadbDQ9ArFuQGhCBQjXx5BaTZjAu
	xkzlzketMRFgJgdzlA1AihRUITrdoJQFTOwHAZXSu/1aW+BcZJ2anvu5g+03zTeAMcY=
X-Google-Smtp-Source: AGHT+IFkDuNZbXec7bV7lPuMQ95q5Ol9D1Ng0Rhf3YsBGcD5BWQyx/AdkT7xTPlkQyoHbl04rNQmfg==
X-Received: by 2002:a05:600c:1d02:b0:450:d4b4:92d0 with SMTP id 5b1f17b1804b1-453653c105emr39996555e9.3.1750672497513;
        Mon, 23 Jun 2025 02:54:57 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:8947:973b:de:93b7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f10502sm9198663f8f.18.2025.06.23.02.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 02:54:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Jun 2025 11:54:56 +0200
Message-Id: <DATTLU8NTTUV.1L05K3TTMV29X@ventanamicro.com>
Subject: Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>, "Xu Lu"
 <luxu.kernel@bytedance.com>, <anup@brainfault.org>,
 <atish.patra@linux.dev>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
 <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
 <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
In-Reply-To: <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>

2025-06-23T10:04:45+02:00, Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>:
> On 20/06/2025 14:04, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> And why not delegate the others as well?
>> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
>>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
>
> Currently, OpenSBI does not delegate misaligned exception by default and
> handles misaligned access by itself, this is (partially) why we added
> the FWFT SBI extension to request such delegation. Since some supervisor
> software expect that default, they do not have code to handle misaligned
> accesses emulation. So they should not be delegated by default.

Yeah, I forgot about your patches that conflict with the change, thanks.

(The current KVM exception handler only forwards all the listed
 exceptions, so the only observable difference this change would make is
 that the KVM SBI PMU event is not counted.)

