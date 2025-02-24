Return-Path: <kvm+bounces-39038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBFFA42B33
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A8E018935A5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6DD26657D;
	Mon, 24 Feb 2025 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbqaJPa/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A639226562A
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740421231; cv=none; b=QEWaJ2o9f1Srxx/6kIPVK0i2s0/4q+ldPKoswXxM4Kj/XbazK+R0A6uh3tNmhx42ID/lZWwfzq801lsod/p+L5LLmx0B6RQKlFBICHZYWsrZof0qyHC4vdO15rmj1ljBLyLEx1klh0GwufMETs28Cn0FC2bCOJ7QcsX4+c86T4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740421231; c=relaxed/simple;
	bh=+fWjvOFql4MYXWqia/zzl1L9GGvJoE/FTf4HrGaezp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YnBBTwPgIlkPPHd6F+4JjPM754iO3IlwKjzn/D/FrUa67bnzUcCwZS0pDVqGSnoIQT5KLrt6cQuUQ8KAbWiq2joktyJoOzNwtUFcnHzQSc3eONli66MbEBxS8YESu2vKAoDV9WHLH7iBh12rPRCHVKXN9OzF90WucSgwphUsSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XbqaJPa/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740421228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iZrFNI4C7gp68g9l+kDtLtosIj+17mZI2t4068Zb7/k=;
	b=XbqaJPa/sUTQMNZZP9lDWr0Ej+xGDju8x7q4c1csViPQB3DaEzBvQwW34wX9g2Iwy0BcoI
	WLO7X7+mKvStSlc8VSijMQNq4k401ck6Kyao5mzrlhU1lFhpVYer1WeUnq3Es3JEr2Dpsh
	WR8VCzOmPNutp7+226fmeusy4m7dRpQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-DuyEye_qOA24bt3XfRAQUA-1; Mon, 24 Feb 2025 13:20:27 -0500
X-MC-Unique: DuyEye_qOA24bt3XfRAQUA-1
X-Mimecast-MFC-AGG-ID: DuyEye_qOA24bt3XfRAQUA_1740421226
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4398e841963so39551355e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740421226; x=1741026026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZrFNI4C7gp68g9l+kDtLtosIj+17mZI2t4068Zb7/k=;
        b=V2G19dp8/QhYwoJrR8b2uFiEaxc7/q36gpFgnkHUbD/vy6HpW8uR6DXTEB0qwUcMvZ
         XIPZbh7yTBrrMykKuJVKc3qzrs5MBkApXeK2tRjFW5ll38uIlwPzrKEfBZPsceKDrD3Y
         +OA8mA+HMg6pNzc17wFkxetysYRgbLiZ6D7xhraBE2k61iN3+xOd47QNvvMdst6eohVU
         83TlK56iZ2HEzUen7g/EE85hmqwbby/1VQgtCyQTtAOLQpHlCek+lKxuK8IJa6oG+oOD
         e8bXang3DkfGzafQGcOK6j+B6sQy/vF+LATvEpmdtr3TKvP1y3Hv4G7OaHE7p2YtDo97
         AP2A==
X-Forwarded-Encrypted: i=1; AJvYcCUCobDY3jcStL5HYwTQv3AUnGQxvhtSHOy1B+rqNaEA7gVxPGKKm5WNh7jAKMbgQeuTB54=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+LSuznEJv/DxilWKldcdvjN0SiTFeyfSg7xqZgcc4d3jqb3eL
	einhLdcanUefSrEzEU2OzvNNxlW/bGwM5ABentY+lgdKqfCZGxqMc+XMMvlhGHFrhZPpPGDIdWH
	PXjOqZySzUBEClXLPjHKufHnBaP7xeeufufRAtyhrhqiJM+igITqP7LSdANC7a4nZwZNEpcGAsf
	BfRec5SQcSEbqa4BJDov4nGTpR
X-Gm-Gg: ASbGncu4XZ7Z9mXo/RYY9g+x5AUApbTME3Q+KNd1CNe3LZfjZasI1TWb8iKr/KcUd+r
	EluZeF+TYrZOIJzl9EKzq41QtzbidvtmtYAGdUZ+S9tTT9484UzSUu4/AbWwM4yjKxj3R9sai3g
	==
X-Received: by 2002:a05:600c:1e15:b0:439:9cbc:7753 with SMTP id 5b1f17b1804b1-439b03246d2mr120217875e9.10.1740421225752;
        Mon, 24 Feb 2025 10:20:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPgI3aLartuC/rneTquTEdyzyQpc0037VQO5E4VWeS/fDSQrV1vC9WSFvHP9NH6aMpcflu8dbApUxYsLMrEGk=
X-Received: by 2002:a05:600c:1e15:b0:439:9cbc:7753 with SMTP id
 5b1f17b1804b1-439b03246d2mr120217535e9.10.1740421225383; Mon, 24 Feb 2025
 10:20:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220174406.749490-1-maz@kernel.org>
In-Reply-To: <20250220174406.749490-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 24 Feb 2025 19:20:14 +0100
X-Gm-Features: AWEUYZlnPj-9rOwF2Mzb1qT313FEPSpFv0way0dOS9rLvuEZKU9Q-G2Q2GVG6xs
Message-ID: <CABgObfbG1wWT0rCynqZOYr8mzqrAdZeTYiG+EDOy1BOqa3k+aA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Vladimir Murzin <vladimir.murzin@arm.com>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 6:44=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Another week, another set of fixes.
>
> This time around, we have a focus on MMU bugs, with one bug affecting
> hVHE EL2 stage-1 and picking the ASID from the wrong register, while
> the other affects VHE and allows it to run with a stale VMID value.
>
> Either way, this is ugly.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b643=
19:
>
>   Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-3
>
> for you to fetch changes up to fa808ed4e199ed17d878eb75b110bda30dd52434:
>
>   KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2 (20=
25-02-20 16:29:28 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #3
>
> - Fix TCR_EL2 configuration to not use the ASID in TTBR1_EL2
>   and not mess-up T1SZ/PS by using the HCR_EL2.E2H=3D=3D0 layout.
>
> - Bring back the VMID allocation to the vcpu_load phase, ensuring
>   that we only setup VTTBR_EL2 once on VHE. This cures an ugly
>   race that would lead to running with an unallocated VMID.
>
> ----------------------------------------------------------------
> Oliver Upton (1):
>       KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2
>
> Will Deacon (1):
>       KVM: arm64: Fix tcr_el2 initialisation in hVHE mode
>
>  arch/arm64/include/asm/kvm_arm.h  |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              | 37 +++++++++++++++++----------------=
----
>  arch/arm64/kvm/vmid.c             | 11 +++--------
>  4 files changed, 22 insertions(+), 30 deletions(-)
>


