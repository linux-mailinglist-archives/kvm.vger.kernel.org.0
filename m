Return-Path: <kvm+bounces-52744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F759B0903D
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2C38588509
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539F62F85F5;
	Thu, 17 Jul 2025 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ghkP7rq8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025A22BEC22
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765050; cv=none; b=cCJAtLJF0m147jsXkxA8Q7lCV5xOAc/AYMnVR2+sEoboYv3yr1Dv7ad5ZQ6lX0v2QHzs9vY8m9sVL7SPsIJNroDaY2LKxPks787RwItRSVC17hQUqB+IEFMVkBZCvATUSkSQUYXV8K3T94fTFeKFuHMPPkXU/9y2Ig0kUd+wfjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765050; c=relaxed/simple;
	bh=poCj92+UAzU5WvbVhRNoWdrEAB1GWQRAmRpltnsXCfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cd3PSmgC9FzXpwmrdI96LLoTRZl22H7gswd937lK56Etam0YM1vbyzzaVvBEtYld1aPEwTOR+kUfDqamnjqF6xpClfwNWqPZBdU3fWyGfFSPk13nT4wCWGNkR7ytEmyGOtjcB8DOU5bRWNA05qvJ3yEB4lJGpQwEfOeShvcwwc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ghkP7rq8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752765048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SEjYoBcwqDptwkNDt9J1x/LYBRGTVclbAUkgXREtLhI=;
	b=ghkP7rq85x0/6C/Ij/0mRZEkHYx/1VMJh1bkJHgxacfsCsqby8sTOYPL6DRkraCuOvh2Kb
	fC9QEg8BVwHCk/MEV7DEi1tnl+eqEI4uryM0LK+fXPBZ5AiYguK7MJvGyOEfxkQWNR0oWZ
	weEJpEpPW9X2feIs23gWXCek2yxQw8I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-egohHyNAO0CNtwV_Q_eljw-1; Thu, 17 Jul 2025 11:10:36 -0400
X-MC-Unique: egohHyNAO0CNtwV_Q_eljw-1
X-Mimecast-MFC-AGG-ID: egohHyNAO0CNtwV_Q_eljw_1752765035
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso9222215e9.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765035; x=1753369835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEjYoBcwqDptwkNDt9J1x/LYBRGTVclbAUkgXREtLhI=;
        b=LQ4V3/FDIElqhBe/v3qCqJnnQ6Wd+OUBzEFnxNI7HEddS/hK/FK28AIV1yF42kkBwH
         Boi9G/cnh/q1tKOK7uyKJvMOUsFX2M7YxSfWdTBU/11PUhbjAKq1PNF2L0VjvX7SP+eD
         EXr0/vQ9VmNAcTuyQMEvnXnvave7MIS8aDH02Zc34MLHTGxQXYVV1sr2pbt6iLAfn27Z
         3cQypsjZlBVRxAFOoqTy6sYOQS76h+iDFGz344WDMhcPM9cr1JWmXX208uNsNx4FMxhX
         MWpLUFI4gTb7xeL6yKZQHgqNmiEef2LCXb29oprSr2wocnzO8ZJ95j60nIdzdQvRvsbI
         Gyxg==
X-Forwarded-Encrypted: i=1; AJvYcCW9NlvA1YZ/6EbKKmAXV+M/mlj45rjn8jsfu771lYuF1vpYCkPCL6XgqAdPuDEAdNUrzvs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW5kXLmK19T3YyWWJcO4gProN366feZfxqxfx5SyFlId/eK2EH
	9oErPeu4riPKZZGITI8ozBonycrcXDScGF7t6VQWFBWU82d5z8NhrEGNTwKRFc+IFprHEeMoeq+
	qmJCb/pskubDJz5uwltJHI8MlK4TeB/+YE5tM1kiEcnEP6peka2hLFwrvXKM2cl8muvPDOsC6TH
	GxLSMReOYPrLsYwWkBNVlidGWzXEYl
X-Gm-Gg: ASbGncu7ZSt2s5jgJpcyx2ZUkElw3iW9EnmOzQEPXzznuwOeWNVM8yoEAkh0t2Jyq2J
	04G/4HJ9W1Mp65y3JcJpE1NiysuiJQJMgrJoE2ygu/srSysQoDInzROvrRMfnttUrYAS6AfOevj
	70uQeXEA==
X-Received: by 2002:a05:600c:8206:b0:456:1ac8:cac8 with SMTP id 5b1f17b1804b1-456389d8648mr20322715e9.15.1752765034259;
        Thu, 17 Jul 2025 08:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqFKu12WNYkyuv+EBrH40VIjm3DSpAGBvOZK5BRr1yGNQvSYPEChTjgLpLHbHmtfrETxQh9JFrb2OtUf6QmQA=
X-Received: by 2002:a05:600c:8206:b0:456:1ac8:cac8 with SMTP id
 5b1f17b1804b1-456389d8648mr20322395e9.15.1752765033769; Thu, 17 Jul 2025
 08:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711084835.2411230-1-maz@kernel.org>
In-Reply-To: <20250711084835.2411230-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Jul 2025 17:10:21 +0200
X-Gm-Features: Ac12FXzzA7dEcA7kGiq4t8H3V98DgvDEFcCmXVWP7oItkogbslxByYn5IOuKZ9c
Message-ID: <CABgObfbEXvmbSFdku=bRKaB+1Pe9g_7ZuVmy-vmgJwUczA99cg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #6
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 10:49=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here the (hopefully) last fix for 6.16, addressing what can adequately
> be called a brain fart in dealing with the sanitisation of the number
> of PMU registers in nested virt.
>
> Please pull,
>
>         M.
>
> The following changes since commit 42ce432522a17685f5a84529de49e555477c0a=
1f:
>
>   KVM: arm64: Remove kvm_arch_vcpu_run_map_fp() (2025-07-03 10:39:24 +010=
0)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-6
>
> for you to fetch changes up to 2265c08ec393ef1f5ef5019add0ab1e3a7ee0b79:
>
>   KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN (2025-07-09=
 13:19:24 +0100)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.16, take #6
>
> - Fix use of u64_replace_bits() in adjusting the guest's view of
>   MDCR_EL2.HPMN.
>
> ----------------------------------------------------------------
> Ben Horgan (1):
>       KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN
>
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>


