Return-Path: <kvm+bounces-44593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46309A9F7EA
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 20:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81D813B7980
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 18:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBEEF2973B6;
	Mon, 28 Apr 2025 18:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="V5cET2gS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EF3296D10
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745863259; cv=none; b=T0yilXXCllizj4TvSPOjHksbAtdGeLAJRAJN78qdpraxI4VkFAskqmWAaBR7zqfXU2pmc6SmlPphWKvZEYf4nS8LPlta9Xb5laFr52m3y73DMRUouCcX63VCPM9INIVjqfpFRlmqul/0tpirCpRGpetpqjBhZlIOj86c+1Mi3MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745863259; c=relaxed/simple;
	bh=N2wU7kmG2IIfCkkipVz4Ed3x45pSvoHez5zYP1lbaMc=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=EJpYgmUhBnsYxGLzmlvuUI3wK7cNGb934PygoMVIyC2nrpvXaB+rLztVXWuFVaUxNg05MnxXdMimGc+QI47t+AtDbWWUrMdxvdlJiARI/B00aHAfet/+XZCWQDENeyQhjmebcEYffgmlLGWDow8hRtSH5OhcHWrCzpNdb9290w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=V5cET2gS; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3913290f754so591739f8f.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 11:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745863256; x=1746468056; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZwXwtzXWmeQYckV0YYno1wNCKBMqM9oV5/JyBASh3g=;
        b=V5cET2gS/m3xie1dh1KXei4fIVhB9H+Xr9O5gVCRGfNLSNbhXe12Fu27s2iTHbl0Hn
         5Clw6TL6f+UvZ9yKdH5EbSFuRTY4QGlSXpGdT7p0Vyw7QqgLITLj3/KHBicn5CC2l6Bx
         eTkyVhn0QLazoAxWBp5SBAkyuebJS82z3lTWTXkMuqM+kBaD1qKQveqAjGt4P6VOCQwI
         0OwRl+8/gPCwxZj17A+c91yL6oiRRrrkAZErbf5DX8JAVfJqUBG2+cSYd6TsDUEcKeSS
         VA5WNZMLsyE2oO7TakVjWrSRDKMR5c1ccja6r/sVqNLWNipv6l9OKqT3kEcc6h9EWNG5
         4B8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745863256; x=1746468056;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mZwXwtzXWmeQYckV0YYno1wNCKBMqM9oV5/JyBASh3g=;
        b=BiTsU7LI+ZWVl1rYEVqppjHuaukIT0n1X/1j3TGmCPrvED5bwyBWHfxEj0SjGcAccp
         Lhq8dYuEIwuVT0boKVg4GpZD90rGn24JZY1mbAKv8yZFXbO/oUzkR9R1M8gtevb4RBog
         JdDA5JLlh96ZKYwa4ge8D5zNqE+daysbVsmBM5ql2WOwLszGy0MDUYwGb/0aM6K6qjN0
         mxcTod+vkdswEhXItvnwVctWeFTg5mMGVdzxNFA3yMsI8k6UuuARu1i0BC99KMK5SCGX
         U1xS2aH/pNSSRb4SPeHh3PvVR/Bo1CMQjfw7ZA5GL3p64tO+e/m4lpk0VDccPGvQysiK
         eF1A==
X-Forwarded-Encrypted: i=1; AJvYcCXP5ON4CmIvN/TCmjHSOAycgfPh5XdWTxtQvsvt7WTvnXl6QVioORXnCAHXkNE87if5k2w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKSjzkYYlu2JN6u6s/8vvoU9TvzAkzx0N1HjqzOoMAhwRHX5wr
	YmuWMf3hvZ8NmyhsPOOH8W3YbPbzJbeVfUXbhovPQzwmpYsOp9FmuuWTniVMKn5/iuolQZqUPRZ
	E4Ww=
X-Gm-Gg: ASbGncsuKoBgHDzgjDt9Jj1i1ZW4FJGeOwQW6IhN1YDiDvjqzT39r0Ed+CNGUma/8DH
	3SM9WoqVQNx3JGj837N2alL1Aq3GXuN54xpzNW3yt90TM4wrLo5uFfB4majw9rFFqEkYt01s0Wl
	I7h+U4BEj0994gLWkvyvfWmjaeS7xdmK1gq0MGQgmFs2tfSu95f27JMmpplA97LP8+yLjohRCKW
	Zlho+4pDFZN1eWhfE5rf8G+kOzyYFND2RcXgIjNDF/coat7FwWvzwMT6Q9JPURwn+3WObSjXTec
	z6GRz694prylJtMmZgaTdctt8hqcvFKY8WqKkGrB8MAiOD8=
X-Google-Smtp-Source: AGHT+IEoLn0qfVLaHBdPIxVZ7lJCgR2On0y4jpuci39/L3rmNtHaRZ20QzdrYfwyAYvWF7jRY9MHSQ==
X-Received: by 2002:a05:6000:1886:b0:3a0:86f3:451f with SMTP id ffacd0b85a97d-3a08a3438camr79148f8f.12.1745863255647;
        Mon, 28 Apr 2025 11:00:55 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:785:f3a7:1fbb:6b76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073cbdb78sm11569680f8f.41.2025.04.28.11.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 11:00:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Apr 2025 20:00:54 +0200
Message-Id: <D9IGVF0OY4WJ.1O1BX0M2LWUVM@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 3/5] KVM: RISC-V: remove unnecessary SBI reset state
Cc: <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Atish
 Patra" <atishp@atishpatra.org>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Mayuresh Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
 <CAAhSdy1RSpVCUzD+Aqbhh7aiQPmC2zdvuQfuOsmYNJrF3HxCsA@mail.gmail.com>
In-Reply-To: <CAAhSdy1RSpVCUzD+Aqbhh7aiQPmC2zdvuQfuOsmYNJrF3HxCsA@mail.gmail.com>

2025-04-28T17:46:01+05:30, Anup Patel <anup@brainfault.org>:
> On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>>
>> The SBI reset state has only two variables -- pc and a1.
>> The rest is known, so keep only the necessary information.
>>
>> The reset structures make sense if we want userspace to control the
>> reset state (which we do), but I'd still remove them now and reintroduce
>> with the userspace interface later -- we could probably have just a
>> single reset state per VM, instead of a reset state for each VCPU.
>
> The SBI spec does not define the reset state of CPUs. The SBI
> implementations (aka KVM RISC-V or OpenSBI) or platform
> firmwares are free to clear additional registers as part system
> reset or CPU.
>
> As part of resetting the VCPU, the in-kernel KVM clears all
> the registers.

Yes, but instead of doing a simple memset(0), KVM carriers around a lot
of data with minimal information value.  Reset is not really a fast
path, so I think it would be good to have the code there as simple as
possible.

> The setting of PC, A0, and A1 is only an entry condition defined
> for CPUs brought-up using SBI HSM start or SBI System suspend.

That is why this patch has to add kvm_vcpu_reset_state, to remember the
state of pc and a1.  (a0 is hart id and can be figured out.)

> We should not go ahead with this patch.

This patch only does refactoring.  Do you think the current reset
structures are better?

Thanks.

