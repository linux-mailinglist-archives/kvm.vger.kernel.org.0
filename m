Return-Path: <kvm+bounces-35990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00762A16BEF
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2BA31880A15
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4FF1DF996;
	Mon, 20 Jan 2025 12:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fu/8ZEZY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5292A1B87F4
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374538; cv=none; b=akTNVbD3rSxoFWpnNRRUT6mZdGil1Yt2GEmjnMKOKp4hu1YWX0nWxq/Rp0iILG9ADt0nDGLwiBMh3PYR4xKam2zJfxWpbvlUOHaSQC/endlYS1BKrr+7JpJ+MYtvNB8ave9iyrGGdXd667hFfZ+3WMxO49ph56pTaf9B8mmsN/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374538; c=relaxed/simple;
	bh=avDRX6riECMKR7igsGJkj8U4YigXns77GHJ18tfHbU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LhRQvW4rCeqpzmoIqWi28y4Gq3awuweWjgwv3P9/Qh9pkFUN5X7Cpx5xifmTx4wC7Bs/VgJvGRZ7ZCwi9t2d0t84okn4xvWu39+mzo6TWNw5b3qVf0Nbeq009JgNdO7GbmzIXB0e7YrE6CXs94qQYdAGEgd7iWYH9HSvv8qpQA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fu/8ZEZY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737374536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fexiX3t4iLg5WJeHYZBOyI9XPTWA4aqxc31q4mlujto=;
	b=Fu/8ZEZY02chzvE5Sxz1oUlADv5LPUExgcAP2CZV49scxgVmM0K7eXdhlMx8xpKgWRqv0n
	6CumzXjV7O/1Q+LV6Sf7SXbBmYo0tPl585Xnc3dC/nl3OJioav9hpBM16vDI2a4Z/E38v3
	cXg+ZtDgD05L2uXiGq054bNO4qI9FBw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-5kaiJPqTMr-C3nGOxLkMJw-1; Mon, 20 Jan 2025 07:02:14 -0500
X-MC-Unique: 5kaiJPqTMr-C3nGOxLkMJw-1
X-Mimecast-MFC-AGG-ID: 5kaiJPqTMr-C3nGOxLkMJw
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso8435280a91.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 04:02:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737374534; x=1737979334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fexiX3t4iLg5WJeHYZBOyI9XPTWA4aqxc31q4mlujto=;
        b=Gs9SBkclNOU8z/1Y8TERhgpqVixy7A25PW1QvIRh9ZZHJxmpITMYLpc7+sZSsOkYv+
         U1RNcVxk/7PcxK43EG20Wk2gxfB7ALDvbK/3TOZu/BZUaRYhwsbSW/1BuGe1TMLY5VGk
         Xg+afACyac9xODDaJtlwm1xbizeh0I6GdnnpOn+dIhWOZ0m2KO8UiLqPViSFlxC8b+Ri
         IUekUcmAfRExddgRJClwKbZmKdJ0aEB15V9ovxApYVRAs04b7AZ3PU26tDT2GaAKXOIA
         HgdO+NHxafMZr0rt4DcIZrx4vFyaSg5bMJyFapqBGuaImdYKweEAU/pzoyWAfxYu8hHC
         8IZw==
X-Forwarded-Encrypted: i=1; AJvYcCW/EFACfj73c36B9YcDGvrR3j9E+U4RXl7gbGDfdHo+jTxbdS+DT55IJJxWNzgvcdN7WwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwstYXKfNok9trNJyuPsqMBY5NdtK6Bw2cS/0p5PhmSoYK88Wd5
	kn53dPmI7DljtUeeM66rR+3kL+xhmkXa8IY3KldL7mMwwPQR7P+cqhCgF1kzF71uCag3rjbrSnT
	tFpdgLAerq0Bd4EENhaf+eWRHGDGpxt0/NZ+5v7PtM3V12PqDz5XX8Z6cQpVR77yRdzfgCgcwzM
	MG+wiMerbQKGvV5sEtsI81hDX9
X-Gm-Gg: ASbGncttpmkvO6Z0KGsDPzSaBOS766Av4vJM0egUez4NJazBmGpFqAknnXHp+5sov6S
	w+oN/JOwxDmsEW9afGc4QXze0LlltF+A63QSNVYszQ6QBoWBXSpVZ
X-Received: by 2002:a17:90b:2803:b0:2ee:ad18:b30d with SMTP id 98e67ed59e1d1-2f782c4bd4dmr16496020a91.6.1737374533818;
        Mon, 20 Jan 2025 04:02:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOCF0Lznp77ArLmeUPdmlx9sZZQ0u9IJTB8m9AZJMkb86ZWhU7cWNeBlgeTiJ+ImUI9S/aJk3IrYNM5QQgQRw=
X-Received: by 2002:a17:90b:2803:b0:2ee:ad18:b30d with SMTP id
 98e67ed59e1d1-2f782c4bd4dmr16495993a91.6.1737374533558; Mon, 20 Jan 2025
 04:02:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117115208.1616503-1-maz@kernel.org>
In-Reply-To: <20250117115208.1616503-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 20 Jan 2025 13:02:00 +0100
X-Gm-Features: AbW1kvav04dHAd6EFLXeH44giVkOFuZp7i48ZD-kxEE0FGoV-Ua3PABvmPT0ddY
Message-ID: <CABgObfYckN2J_Q3d--ZfAP=QbtGWp-teOpXGPfubU=BN4DSrgw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.14
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chase Conklin <chase.conklin@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Fuad Tabba <tabba@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>, 
	James Clark <james.clark@linaro.org>, Joey Gouly <Joey.Gouly@arm.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mostafa Saleh <smostafa@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>, 
	Rob Herring <robh@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Vincent Donnefort <vdonnefort@google.com>, Vladimir Murzin <vladimir.murzin@arm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 12:52=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the initial set of KVM/arm64 changes for 6.14. The bulk of the
> changes are around debug and protect mode, both of which are being
> radically cleaned up. On the feature side, we gain support for
> non-protected guests in protected mode, EL2 timer support, and some
> better CoreSight support.
>
> The rest is the usual mix of cleanups and bug fixes. Note that this
> drags two other branches:
>
> - arm64's for-next/cpufeature to resolve conflicts that were not
>   trivial to resolve
>
> - kvmarm-fixes-6.13-3 which was only merged in 6.13-rc7, while this
>   branch is firmly based on -rc3, and we had some dependencies with
>   it.
>
> As usual, gory details in the tag below.

Pulled, thanks.

Paolo


