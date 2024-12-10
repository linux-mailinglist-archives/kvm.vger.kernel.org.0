Return-Path: <kvm+bounces-33418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F6F9EB266
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD189188DC0A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDA51AAA34;
	Tue, 10 Dec 2024 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Etl8FGqN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611A91AAA0D
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733838976; cv=none; b=nXVdiAP7hRG0ugvmDpRU+SGXr9cBERAXYsgWoIBTu59lhSVHJa1lx0PVt8wBT+RemBRvH9AElxiphtLy8jTUmno8jiemZniAYsBFncHW1/BmYbAzD9GgWxCQjDCLg3l1YeO/g6eO+qsIgcCm4WOtHOg1dUEueJVAh092N645Grg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733838976; c=relaxed/simple;
	bh=81SDwr+i7U7nSFtgaowgS3f+OVFldJCp5ag1L+YrymY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FqYUSwyesydgfvBG982jw0Vu5LDGIHxpmfmJyjdVaOj7PJCxUl0RjaJsZn6IUC4HGh4Hcuh1i2tYA9pOuuUlwjmpdaRnekDiO7BG8DObEcGS6vYcNwnh9WdBe8RyHtJBACUjGzpJSo+sqG1/FENcSrrV5VEmFtVmjP2sevdeC9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Etl8FGqN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733838973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSFsmOdcddKIbSt6Sh45W8nB+T2Eq7+gB4QNkOWTcWE=;
	b=Etl8FGqNKWCfq6dsSqteuo4yFMG1SENynok2bkscdkNtpdrfKwYdj+3IdwWlfEEwEonsHp
	VDnIeq3kh0dqlwNyhHu5H6jgFFUrqAvtoXYiYWWsXGVbeliIO3XKGMk9nCQnSqNYPrImL1
	bxPYDJljjtBiSn/HYWsY/lc5D78RsLA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-_9nj0P5mM7CWBF1ASgmc_g-1; Tue, 10 Dec 2024 08:56:12 -0500
X-MC-Unique: _9nj0P5mM7CWBF1ASgmc_g-1
X-Mimecast-MFC-AGG-ID: _9nj0P5mM7CWBF1ASgmc_g
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361a8fc3bdso1230885e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 05:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733838970; x=1734443770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSFsmOdcddKIbSt6Sh45W8nB+T2Eq7+gB4QNkOWTcWE=;
        b=EVK+ehRtiTK01lucKmRKEbNnbOvZhUZ75hlCJLkwCCYRcS8Iw1om1/eE6MpPImq5Vq
         qKkt+VpLTcCJsgPDgmctbCnQ96BlFdG91YRxVHEGrvypcPWi7oYozhtmU16Nz07Kb/9u
         JVA4Lje0gHUlkqJwx3L7JQN/5apuQ7Rh+N8WVLcN4jKnof95zqybNHEqFA8CXelGcbgc
         rluwjcdHEoEKd3VVHL4wui4zQWNFuZMsDnQVVq276uBLUkPz6U6pjWxSyzJTrbutUv3X
         Jvs9+otmjRO27WkDyXOuPbm0LWvMcXL2lwP0Rkws20eX5OFjDpUo/xltpOaBtoJkegMO
         mvyg==
X-Forwarded-Encrypted: i=1; AJvYcCXubz0KXcHsAQCOeDF+NrqPV/JuPV1tPQU1R7YkQR8x10O4SLo+uKn9ef2w1EJHgHM+Ffc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMnwY+/DJBwaaGiS9KCUbO5yMI59crwo8gVZJeOwVsGpP7e0pF
	NcM3rdRCBYK+Yn59H3HSH0Yp5lK71pfxLJPjmsb9wZL/QTfYJGdFLQpBHLssa6coqEfa9NKHGsU
	cBhV1qRpptGLuWldn1fBjj57Nm6l1m2tnw2jfrd4Tw6kI2hJBtef0lCKZ5eiwGX7a7DvqKu7lLR
	HttKfBMPtst4qn8y9E2lLuIGQgAZjz9gV3
X-Gm-Gg: ASbGncsoxFs1j4PSr5d9AR1rNz/FRVlpOj4yjHAM31tr4t5JYx6IQRVUkl/Tbz6E2A8
	GZgojo/Sc6Z8NgzrKqW7t3OlxXZjQMRuoJX0=
X-Received: by 2002:a05:600c:a46:b0:42c:b16e:7a22 with SMTP id 5b1f17b1804b1-434ddeb5573mr131813365e9.12.1733838970203;
        Tue, 10 Dec 2024 05:56:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGT6PKtby95Y/i0ysLL1kDTYIt+/yB6BbpbwY8jHyRrAnXXeBFggcg1I6c0FSATV4N/GlcZ6ogQmesGlCgDfo4=
X-Received: by 2002:a05:600c:a46:b0:42c:b16e:7a22 with SMTP id
 5b1f17b1804b1-434ddeb5573mr131813105e9.12.1733838969816; Tue, 10 Dec 2024
 05:56:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z0-n5WnAg8tBjLhG@linux.dev>
In-Reply-To: <Z0-n5WnAg8tBjLhG@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 10 Dec 2024 14:55:56 +0100
Message-ID: <CABgObfZqKKAmJuL+awFFQ8Y1+GvTOWNuvPGav9Y0DVWRhC7EOw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.13, part #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Marc Zyngier <maz@kernel.org>, James Clark <james.clark@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 1:53=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Paolo,
>
> Another week, another batch of fixes. The most notable here is the MDCR_E=
L2
> change from James, which addresses a rather stupid regression I introduce=
d
> in 6.13.
>
> Please pull.

Done, thanks!

Paolo

>
> --
> Thanks,
> Oliver
>
> The following changes since commit 13905f4547b050316262d54a5391d50e83ce61=
3a:
>
>   KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters (202=
4-11-20 17:23:32 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.13-2
>
> for you to fetch changes up to be7e611274224b23776469d7f7ce50e25ac53142:
>
>   KVM: arm64: vgic-its: Add error handling in vgic_its_cache_translation =
(2024-12-03 16:22:10 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.13, part #2
>
>  - Fix confusion with implicitly-shifted MDCR_EL2 masks breaking
>    SPE/TRBE initialization
>
>  - Align nested page table walker with the intended memory attribute
>    combining rules of the architecture
>
>  - Prevent userspace from constraining the advertised ASID width,
>    avoiding horrors of guest TLBIs not matching the intended context in
>    hardware
>
>  - Don't leak references on LPIs when insertion into the translation
>    cache fails
>
> ----------------------------------------------------------------
> James Clark (1):
>       arm64: Fix usage of new shifted MDCR_EL2 values
>
> Keisuke Nishimura (1):
>       KVM: arm64: vgic-its: Add error handling in vgic_its_cache_translat=
ion
>
> Marc Zyngier (2):
>       KVM: arm64: Fix S1/S2 combination when FWB=3D=3D1 and S2 has Device=
 memory type
>       KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
>
>  arch/arm64/include/asm/el2_setup.h |  4 ++--
>  arch/arm64/kernel/hyp-stub.S       |  4 ++--
>  arch/arm64/kvm/at.c                | 11 +++++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  4 ++--
>  arch/arm64/kvm/sys_regs.c          |  3 ++-
>  arch/arm64/kvm/vgic/vgic-its.c     | 12 +++++++++++-
>  6 files changed, 28 insertions(+), 10 deletions(-)
>


