Return-Path: <kvm+bounces-36664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C409BA1D974
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 16:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D909165ED2
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 15:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788A213B797;
	Mon, 27 Jan 2025 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/smgqVn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1310325A658
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737991524; cv=none; b=K+pdZ+q0r1OreYOu8RdWa9tQju7kZIQVVPaLDnP+n1gW9XcAUhLRKsOP3/wETmJdsm3Yv1Oy+o3wRDuwsozrp62sSiEztIWETfr7fh08d/bzUzBCKI6BWpfkbPyPmJErX9EK6vq+xHb11icWHNLXODuYiUQ6bInTySpxf/IqE9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737991524; c=relaxed/simple;
	bh=H19tpCD+6r9uQWFojnxWboQKCbiThOQQh3fjdS37aWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HgyHLWIHA0ue2Mr1sVIykGkHi4Jpl5Tp9BIC+qQ84l7qWy2K0CRDRa5pmxXYoDbBEsxMT+fIwBMjhQcZYvYyZsr2TRU7M5hUHrkEw0i8orh9wTM6b+D+P/P/voJctcKg1Ecy0gSm1to5JGRi8ymmKyBgNiczp0uM8JJCPnsi5P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L/smgqVn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737991521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ni7xoQbBTNC1W1Dz/5tMCYLRc4wPIwk62rJ/YGqS7IQ=;
	b=L/smgqVns9FzOiIuDp4SroriTXAn3Wtx7rLsD5ixjgnHUftBl34iQRulKqXZYaH9dzxGeu
	JVQB7nNDtDmPDcq++sRy6MN+rksThTH6e3/Bvhjd1RvxCjrOm7WKjo4r679zVFvjXgnFR2
	nUqI25bef8fpI/UUOrOwQ8WHirCQ0MY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-D1SxUz-CM32Qf42bf1yAkQ-1; Mon, 27 Jan 2025 10:25:20 -0500
X-MC-Unique: D1SxUz-CM32Qf42bf1yAkQ-1
X-Mimecast-MFC-AGG-ID: D1SxUz-CM32Qf42bf1yAkQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3862f3ccf4fso1679412f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 07:25:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737991519; x=1738596319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ni7xoQbBTNC1W1Dz/5tMCYLRc4wPIwk62rJ/YGqS7IQ=;
        b=dO/0tAshUmqqfHo8RV1Ds7BBd6cBR0uLt4Qg/zm3B79pCNOBKCdlXx4l4gJdWy9Hdm
         bdpt9LIFviltO9SGh0bBKqo4NglPIUjtWi4sKenX0dXXPCBwen62KekWHn05R/CB65NG
         FFVFuE6WQVzvdUP2jYUp22EHRF8RhedKuOByg5libVhWlelAMQWJLNv14SM8Kk9slteA
         U8UIVC4pD6iMwt55fYfCSGbtR9NyO70RPTAeZaaArKF43MwjgRii+M0/dWeOGJy8+RTq
         cA62cedkbK9T2OU8aA87YtI2pvOwJU7JYDgXxvwBs4BhmM+80hBSWnP+jvbmeoeC5FyX
         6uZg==
X-Forwarded-Encrypted: i=1; AJvYcCWtACTEW7sPyVR5FG8HZiaGhV+GDtfUUCHvzyfGhku64bGhYmggkhM8BYYgpVZegJIejjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnltJSwZe6y2OwbQUq1GifJbtyQZxVJpe5QAaQtu0DPMCpiuI/
	xd95yu2pygNyRKXdwfyOdrlGL5gtZhy8HaUu5SPTLhk/2qBVvYyb6tlia+EUse3x9DkxB/DPMPL
	FSl+4ehdwqvfKBdeOUemTtAVKm+DaNUZAcEQ86bewHJ6zrgr2uxwUnV/PfIANDiOXcab3yHP6s4
	QeAIQuLg8BHjgkmihz/tXs85uK
X-Gm-Gg: ASbGncsHyTG+FA5zfEFwXl4HOl4r0LT1FrRcV+49s0OQubFmRPIl4MYxkjQ6zP1wfCF
	ei3jU/i9906nZZXapxHZnYNY6F8oeSNHgYEWfm/d5s6Tj9mpVtpD2X2OvNSFEdg==
X-Received: by 2002:adf:e607:0:b0:38b:d765:7046 with SMTP id ffacd0b85a97d-38bf56855dbmr32608394f8f.33.1737991519253;
        Mon, 27 Jan 2025 07:25:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDK2nKpEEbuVoTUDJeT8cTSL435WDA3M2uAgnQ4m9e7VF+x8HvYay1WczP3Ph6/swzTVdOFofrnPYmrnoNE04=
X-Received: by 2002:adf:e607:0:b0:38b:d765:7046 with SMTP id
 ffacd0b85a97d-38bf56855dbmr32608369f8f.33.1737991518812; Mon, 27 Jan 2025
 07:25:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wghGxSMv3K0BEB8N3N3vwk-3v=T1FhBVJyf2u_xYYJOCA@mail.gmail.com>
In-Reply-To: <CAHk-=wghGxSMv3K0BEB8N3N3vwk-3v=T1FhBVJyf2u_xYYJOCA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Jan 2025 16:25:07 +0100
X-Gm-Features: AWEUYZl1IVNK_PFr0bWXpaQk46cR7FhjS9SzgCJZAf3Iy6Jth9zPpPYvremd4GE
Message-ID: <CABgObfbTB-xuJbFAzH0xV78aZm_mb92oEpNUyZ8LdvN1GdChMw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 25, 2025 at 7:16=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Ehh. My resolution ended up being different.
>
> I did this instead:
>
>                F(WRMSR_XX_BASE_NS),
>                SYNTHESIZED_F(SBPB),
>                SYNTHESIZED_F(IBPB_BRTYPE),
>                SYNTHESIZED_F(SRSO_NO),
> +              SYNTHESIZED_F(SRSO_USER_KERNEL_NO),
>
> which (apart from the line ordering) differs from your suggestion in
> F() vs SYNTHESIZED_F().
>
> That really seemed to be the RightThing(tm) to do from the context of
> the two conflicting commits, but maybe there was some reason that I
> didn't catch that you kept it as a plain "F()".

SYNTHESIZED_F() generally is used together with setup_force_cpu_cap(),
i.e. when it makes sense to present the feature even if cpuid does not
have it *and* the VM is not able to see the difference. You use it if
when mitigations on the host automatically protect the guest as well.
For example, F vs. SYNTHESIZED_F() makes a difference for
X86_FEATURE_SRSO_NO because F() hides the feature from the guests and
SYNTHESIZED_F() lets them use it.

It doesn't hurt at all in this case, or make a difference for that
matter, because there's no
setup_force_cpu_cap(X86_FEATURE_SRSO_USER_KERNEL_NO). But here using
SYNTHESIZED_F it's just a little less self-documenting and a little
less future proof, nothing that a quick follow-up PR can't fix, and
also I managed to pull the KVM/ARM changes from the wrong machine so I
have to send a second KVM pull request anyway.

> So please take a look, and if I screwed up send me a fix (with a
> scathing explanation for why I'm maternally related to some
> less-than-gifted rodentia with syphilis).

I think I don't want to know if it's a Finnish metaphor, or you came
up with it all on your own...

Paolo


