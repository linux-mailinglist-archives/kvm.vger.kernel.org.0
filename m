Return-Path: <kvm+bounces-13964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C9389D116
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 05:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A6362829F0
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 03:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7751D60260;
	Tue,  9 Apr 2024 03:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="fl4VhxBc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC6E5B1EA
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 03:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712633661; cv=none; b=LY5ArzFXzFcUK8rZgg6vWsRZAciZzOl71UBczUtTwqJbkSn7mDCD9l+qIbUy3/lV2sbu2QRkYa3YS5387ta/gKVTnp/ykljRS/CL1mfGf1H3FLjYAIVmzaYoTx+OwjRgGjcvBJU5e81f93g0HlaWZVxbMxl6hJLMaBrKCcrot60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712633661; c=relaxed/simple;
	bh=GkRFw88WS1mpew6+A6ZhUjKfTBwNSz+H4IzQ8hpTTo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pmt3iwXn1SSbMyrh6yxBW8Olujnm4VXvnTe8b5G5bpsHyNfR5GLPC87ysDGMcO0ToE907e5j1YX8tmCM/8kSxGpdkB/PbFp8RqeHcyHy98NTTswIXAUxeoWTO+uvrYqlmy1wKPw2eShXzgud+6iXsTQxhuZw2OnLWpc6AVjWH5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=fl4VhxBc; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36a202020ccso10097065ab.2
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 20:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712633659; x=1713238459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYiXfZesMM7FrFbnCXvgnUL68t8FAPQGijOxyeQqLnk=;
        b=fl4VhxBcpwDy00r/JeKpeE06FdwwfjZvzELUaEjDGu0f/cm4tLfoe1qqyqhRToP0gh
         bXe48WG6a9IQF9YpplOmB0XOuU+l8ueQkFaHZYIGCO6zcdNExNZyqEvRDVk9qvU2rad2
         iy9nm/zycubJgea7/6dZqqdVvjJNv1QVcj9PiQrgAkOxjsAiVQkmM3N9y9G1Lq3Yci7q
         FOnipI7a27QpYiWTrKIdHJaEWMuvlBvl7dbVueXx6vvCC7VXNg9sq9CEpSBaNDjRup/K
         k8UZFZMoHPc2fWUUmVPXOynYFnaDswuSI4fXjQceCs+v2z1LyzzWDc5vUkYGsMyDeSt5
         DCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712633659; x=1713238459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZYiXfZesMM7FrFbnCXvgnUL68t8FAPQGijOxyeQqLnk=;
        b=inzT62hxj8yUvrmaWjs/ZWh5OcveSBT6zGMiMfzrEoCifl07+ZORWvc3Ouwc8Kss8I
         jrZCbc3AQ3JcTYdiOpX+raNdD0pzacSas8NXQ0H6KUezl6p7Iwav2PibQfOy6YGLDbXP
         pAIIfwAq5fW2WqfKuhEZCytFVoDyfNTNZJ2W3SagqFWHe6SBwS9ba4afRpqK0XZM1Apm
         /lYSHPbw9AC/eFHLyRBeyXCRi4793K3h8gCug23gG67YIBAGzzRRpffhmIy6Hc1IWXXi
         b47OmC3tiELFInMipFJ3Jyk7wXn0L514k145Ko79ncgSNWVH7sZyeTlNOh1euprPFrd4
         3JsA==
X-Gm-Message-State: AOJu0Yzu91F0Axc1tR80qBygwBYtS8UM8hhfUSAklou2cXaXJdWiKW3D
	b+pr62LcIeHP0/SBbnGhQHUMgm49q8cXahYvuBI9MADD/IcUSOZNx4qyVlzkjNGPehuYwwRFTvO
	eJsf1ylabPPhBIS5LorA087kxlqQDWYrwC19GlA==
X-Google-Smtp-Source: AGHT+IHTy5Sf7NfMvRKlGhgnKcKW0mmmuh0cJOOymVQwjyQL2Y3q9xjaFTO/PfvDB2N5MHvdgY3ikfO0ypFVd3ZsnLs=
X-Received: by 2002:a05:6e02:20e8:b0:369:f4bd:2df8 with SMTP id
 q8-20020a056e0220e800b00369f4bd2df8mr14044562ilv.10.1712633658893; Mon, 08
 Apr 2024 20:34:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403123300.63923-2-ajones@ventanamicro.com> <171262714494.1420034.12329953170509858303.b4-ty@google.com>
In-Reply-To: <171262714494.1420034.12329953170509858303.b4-ty@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 9 Apr 2024 09:04:08 +0530
Message-ID: <CAAhSdy3MuUdSJtsU-4pzJ-5KFpRfuHdeg1PxPrXQenY7O_NRZg@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for riscv
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Andrew Jones <ajones@ventanamicro.com>, pbonzini@redhat.com, 
	Atish Patra <atishp@atishpatra.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 7:23=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, 03 Apr 2024 14:33:01 +0200, Andrew Jones wrote:
> > commit 849c1816436f ("KVM: selftests: fix supported_flags for aarch64")
> > fixed the set-memory-region test for aarch64 by declaring the read-only
> > flag is supported. riscv also supports the read-only flag. Fix it too.
>
> Applied to kvm-x86 fixes (for 6.9).  Figure it doesn't matter a whole lot=
 if
> this goes through the RISC-V versus something else, and I have a pile of =
things
> to send to Paolo for 6.9-rc4.
>
> [1/1] KVM: selftests: fix supported_flags for riscv
>       https://github.com/kvm-x86/linux/commit/449c0811d872

Thanks taking this through kvm-x86 fixes.

Regards,
Anup

