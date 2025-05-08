Return-Path: <kvm+bounces-45851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C956AAFAF8
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 245234A404F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0600C22AE7E;
	Thu,  8 May 2025 13:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="xH7ZZVDq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BE322154A
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709882; cv=none; b=s6f+pvI2Authx1WyIGrSvqq2+KGdqyX99Cs0n5V7STczEGPOSqTAXqZNkzSZvgvK56F7imv+Nne9vZ/6xm9cIw1c6XWeuHpiDz+CUz+qdFeZc9c5nrdg5bXAaf4ZT2FrvwhZsg3K2HLVoFHZjScYpyO3dDQAFA+mJMUwcyEDE6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709882; c=relaxed/simple;
	bh=1wwTO5Nw42Ep7tw3uZOYZ34griFSvPoI6Sesn0+sV5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HRd5yAbVYyy3i3CMM/fHuj6oOpP6cx49bf7D6p/Q7KVuSNM7GlwoLTQl1ZqaxnFkmqIFaru0ckUk4vO9bwVs0HproSCONkrPoFZnx/ZUlnnhzPkLH/UecY6f36361stbtpaMXYDZnEOlc3nQA+XPCsWylHs0aarH7I2gcbQFQmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=xH7ZZVDq; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d940c7ea71so4600935ab.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746709879; x=1747314679; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIIzVOYBzARToag3Hu6HMwC8LbExnwHHAZ9eRtDBxjM=;
        b=xH7ZZVDqzqiI4rdOwYagK9n1lQnbR7IHdnlMMZzJ4v8b7+I2yRvvuGXkuFHI++t6JC
         tzn53s6nw/14/jCIqQZFah61+ZYQ0ASTKVsVBhi0ZkWOAoh/aEUiJGn78Y+Fad139v7v
         9rhtLaDsZoj1QrkC/fzeQJX5nS9J3VFNlogJgzWg+WOW22c+ZEo6Gh+c3PmiLZxFGVDQ
         8iW/nleDxXS8USd7kM/TCjFBlFq9ULnixiENny4bJVM1WLc8TxJ6NzRXT9OXdXJShyhX
         gKqiv8YIF0zIhuGm+7sJKorjs2I3rXfTIGbNQhXd/41njfnKJRe+CAkZtgtpBXYlnU6Z
         cFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746709879; x=1747314679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nIIzVOYBzARToag3Hu6HMwC8LbExnwHHAZ9eRtDBxjM=;
        b=anK80pJk2Nnio7sNinnOi5ryu0jOAXKBBwQQPdPXBLNJdgXnvBuDVtijSt12TsErnR
         agvC+isUJqYuH/RZlP1/p6ZOL4Nv/ERz/waJyo+M5plqf84N/zvXlpkZ8K1xnN6lEeYH
         HfAPYBXLllhZlzfS6GsiW/LneSsOOEsQHfE3JcRiXN6+IDq3FQ7JF5xfITl7HW95Mn8P
         lqm1vEkMzdoi7U9j+MuWBdISjF+Qj8ThKuVQJ+YkPng8vW/zSLBjXmzXBy5ox5t9juCS
         beakJMkVc/U6WGe48PAulKBCGYp4zqr+fpk3akRV+EY7zBgV+a+Amiu/ue2jSkoet9Mb
         XnHA==
X-Forwarded-Encrypted: i=1; AJvYcCUY807fevhxY+iRcOYS7zojaBBO9HwyDzgEkc5FDU4OLdDQBOW5Woae10Do46Kj2+XwbOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyb9QJsqFf0lh3c/levQStXl2T6RUBpQ8VMOzkrOQlr9eLcgbf
	U00IUIY5BMz+zUZjiH6sGYReVQjq6TX09NqGJ6xmdj754Y+4flrJxpyKe4T2LDt4o7Objvvqjv3
	V/N3BJTqnlCw7D+/PUG2s4hEfcneDjr/edpXoxw==
X-Gm-Gg: ASbGnctvQYs8OSmCZ8odO8k8iGYFpBSlXay186/G+ACspkdfb7EOc8craQzcmFcp6uX
	/c4UUFuisxkFCY25FoeG/miu731xmBZQmkukXd0X65m4bkOMEsYclJm1EmUpQHreFYrVLbEiH9K
	PMiUPs5JvMwpC9G2WhBKyiysjZcy3qlTCung==
X-Google-Smtp-Source: AGHT+IHQLQeo4Cv5ChZYTmyYcmLv/sbqMMoInT3yPEcu0Vzy2BhXgfYdd3qe4Af9myyCvg8pUIR3RpvOggHqQ9hf9zI=
X-Received: by 2002:a05:6e02:1809:b0:3d8:2178:5c63 with SMTP id
 e9e14a558f8ab-3da738d5abcmr87761745ab.4.1746709879462; Thu, 08 May 2025
 06:11:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-6-rkrcmar@ventanamicro.com> <CAAhSdy3y0-hz59Nrqvvhp=+cWJe1s50K7EpuZmKBqfy-XQFd1Q@mail.gmail.com>
 <D9QOY9TMQXSX.2VOEKVRCXKOO1@ventanamicro.com>
In-Reply-To: <D9QOY9TMQXSX.2VOEKVRCXKOO1@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 8 May 2025 18:41:08 +0530
X-Gm-Features: ATxdqUFytTSYeO2NMWgtWuuoNAjjyJfo1ZnV22TOYS1tMfbGTisHt7Mnprxdk_c
Message-ID: <CAAhSdy0-9OQmBf2VkJJFb+Gmwk3hmNapkjvJYvT06CG9eULDgQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: RISC-V: remove unnecessary SBI reset state
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 3:32=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> 2025-05-08T11:48:00+05:30, Anup Patel <anup@brainfault.org>:
> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkr=
cmar@ventanamicro.com> wrote:
> >>
> >> The SBI reset state has only two variables -- pc and a1.
> >> The rest is known, so keep only the necessary information.
> >>
> >> The reset structures make sense if we want userspace to control the
> >> reset state (which we do), but I'd still remove them now and reintrodu=
ce
> >> with the userspace interface later -- we could probably have just a
> >> single reset state per VM, instead of a reset state for each VCPU.
> >>
> >> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> >
> > Queued this patch for Linux-6.16
>
> [5/5] was already applied, which means that [3/5] would be nicer with
>
>   memset(&vcpu->arch.smstateen_csr, 0, sizeof(vcpu->arch.smstateen_csr));
>
> in the new function (kvm_riscv_vcpu_context_reset) where we memset(0)
> the other csr context.
>
> Should I add a patch to do that in v2?

Yes, please add it to your v2. I will update my queue accordingly.

Regards,
Anup

