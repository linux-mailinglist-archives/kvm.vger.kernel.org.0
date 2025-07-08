Return-Path: <kvm+bounces-51777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBD4AFCE2F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE5FC18851C7
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016CA2DFA32;
	Tue,  8 Jul 2025 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4AmxOP/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF8D2DEA78
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986099; cv=none; b=pjB6yNVO+FSvJf6P+N/tNXgV9bV2782PhPmakPlF7dHokDoO1jo10YRFlCcPlbtnHFiQroS5O4CL0Jkmdnl5mjyAeOthrlWZIV5FLFG9bizvMbaoZuC/1J5NtvJGkJbEzrQK/0cAxK2NLm6yfRIOKqSlStKlxrQDex6VHPQhGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986099; c=relaxed/simple;
	bh=K6D0w4TlB1r2EMOgBoPLENgpbBMsqqcZbsDwAVdJIRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/JBQMzuO4pgFlYmOViJ1UOGMEAms87ZHnsd40gFWxovaAD88knb9hI4dkr2cGvDWzIgFEUERmGcg4LDTBNmDx5zj6FnRq/KYOO3kAhvBp25oY0Z37cNXb0J7x30efVF6eroFaTK67AAN+1h/Pgt/wEhXgP9PJcDg3FxMwYU1Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4AmxOP/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751986096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYwFNZ7gJ7YL/bHRH7pGKeSkqhcvD8xNXSGdyMHjqaw=;
	b=W4AmxOP/b/rOln4svI+tHyspeH6aX7BEkX6HENZoN7ZlEt+m+6mXsLLcOsYg0nUgYPt0LE
	0ZPjWPrLmhz9bMggMu6NyqoBc23HV3EYw8yPIkdUzNNEeA0hPfx/o9vDCFm0MudYx8M5ih
	CA4yAbIfg5EFug5wvpDA1ORcaLWDyvM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-YBf6QXq2OrGy5aC-6HAmUw-1; Tue, 08 Jul 2025 10:48:14 -0400
X-MC-Unique: YBf6QXq2OrGy5aC-6HAmUw-1
X-Mimecast-MFC-AGG-ID: YBf6QXq2OrGy5aC-6HAmUw_1751986094
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a5780e8137so2903757f8f.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751986094; x=1752590894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VYwFNZ7gJ7YL/bHRH7pGKeSkqhcvD8xNXSGdyMHjqaw=;
        b=mK7m+dvjW1PvIB3pKrW0Y8zPst+ot1vcXKEhrKs+OjlTvKe2PMCxUge71q2Ifc1GrT
         bR82wBYQrMEL0HJzEmY87xEWYvDSunWJw4CS//i1+AxJUFZQrnzCvxFM2d1McIlyH1U5
         roSzM16IESfk6hefVjOAkI2N/GYUrjK3ahKQAD4YnPNGN85u3fbir/ZuKWSs7MlHuDgQ
         A2lUiIcichtIGlTmFsPTp17nVTCvjtD03prBspic6Un3zqV6VdPMVBdMs2wzucv2F+9Q
         JXvXM8mFm9R/1djIP0r8H8EwPRXtGU+M7YOyIWryrHO/j0w1boY/Do6g3XWfyZlk0kD2
         kI5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgXshVl0XnLXX3ssMgKCsKL1IyvhQWUp3tQ3LxC5vo10tSFvY3SK31sKoRXxjKA/nHsUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzljY77FWTokONgZgdj08AWMeE2hrWgaSXSq3VvEFvDnD606yLe
	CzqgsRCd7PK0v3Jx1wWzjm9A1DQhKtQLZ73zIMegTEJq4FwCiP04jJjw3SKgPokFm4hXs5GkkMC
	AJT9SBOpNGB4FI0Znxbnqyz1+D8Jo1+XwAtz5+TjcJ44iqeQuCCwa87GkzF4B68gXcjowGxQK8z
	z2pxr0Hh9JthlW2pyZPcYUR/QT0sDr
X-Gm-Gg: ASbGncug39e9g6aybSt5DPYwLAsZhu2h2bzqINsnfj9q4AKNXxPnTR5YHzynECyl2da
	FIP1ksugJuY7Zc0+/RgjTZHGt8Bbdkh1/vYaD0jrymxtX1fk/mXBU4KemSe9YqrO6kia5touVJ+
	mBkg==
X-Received: by 2002:a05:6000:2303:b0:3a5:271e:c684 with SMTP id ffacd0b85a97d-3b5de020c32mr2975735f8f.24.1751986093520;
        Tue, 08 Jul 2025 07:48:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZiM0/9n6ueMPFfbYNFhT+fBviGPPImQB1n/AEnAcH0tJWdCzJAc7ZdV1DzjlOYDO19wxA0F443c++AksjL/c=
X-Received: by 2002:a05:6000:2303:b0:3a5:271e:c684 with SMTP id
 ffacd0b85a97d-3b5de020c32mr2975705f8f.24.1751986093032; Tue, 08 Jul 2025
 07:48:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626152023.192347-1-maz@kernel.org>
In-Reply-To: <20250626152023.192347-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Jul 2025 16:48:01 +0200
X-Gm-Features: Ac12FXzzshxqceQql3qnuEeB1aBk-3TKPKyjGfeEqol9jVWILuBd4g9oY4XHIv0
Message-ID: <CABgObfZ3RepTFAMVSB4v1cmuOg+JB7LAcqx04EZui6qF3q5QtA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 5:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Another week, another set of fixes. Nothing major this time: allow
> pKVM to fail to initialise without taking the host down, make sure we
> are not mapping too much in the host S2 (another pKVM special), and a
> brown-paper-bag quality bug fix on the nested GICv3 emulation.
>
> Please pull,
>
>         M.
>
> The following changes since commit 04c5355b2a94ff3191ce63ab035fb7f04d0368=
69:
>
>   KVM: arm64: VHE: Centralize ISBs when returning to host (2025-06-19 13:=
34:59 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-4

Done now, thanks!  Note that in the meanwhile git:// is not working
anymore, so you probably want https:// in there.

Paolo


