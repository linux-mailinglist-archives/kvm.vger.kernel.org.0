Return-Path: <kvm+bounces-37463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D20A2A4C8
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E64087A083B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74025227B92;
	Thu,  6 Feb 2025 09:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2G6kyba"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B6422652F
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834767; cv=none; b=o91go0muL5MCUiwmSW3keXgYZbaDvfvWuwD/C4tMewpvLIK/QHp9Dr1j0M7Kfzii+uGLP6M2OYBv9Av0numMHRg6e0LSS8kLTajshY/56F3Cj7CqSRXOeBugwFy9LxsP0D4YsDW7P61QnvgwNzmGaQv24ljIB9+VhprySX8lsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834767; c=relaxed/simple;
	bh=gHZyVt/xSbXZtV8kcHlEOIKgq/QQx2RvyNdyyAQthno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oocK7vvJ4LZG+UFERvKsjYzYRH1AktPcSWnUxBIMZYSDIbrwCO2ZguLnCWBo/aq8cULd/q7UQFE3DdVJMGKH8hlcufD1er0nHrWunG7BhCFTz4eU3/71vEACoqviN6oqm3+V4+3hSJj6obWe8gNnudFzNEZpWZ3Ch8DQ6Qx7cDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J2G6kyba; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738834765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zK/6lQqcEYL/R1meCPdVrlsxMHj74L1KpqoscZburOw=;
	b=J2G6kybaKqh+c3kzyoA396CTGAVHCc4MdtWZjFLNUWROteKUuj7Q9auitdaBfE5PLP197f
	oOqyKbxB7J+8QZi3q4ntlBB/j1tfPlPP229z/1fDcGwU32PvMfPGgPjFQ+PPLmFDFyyq8k
	ZW1zVMEVwd8Q7T3v/yTYZ5DAC9jttvc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-YmISwbySNiqa90P0fOp9dg-1; Thu, 06 Feb 2025 04:39:23 -0500
X-MC-Unique: YmISwbySNiqa90P0fOp9dg-1
X-Mimecast-MFC-AGG-ID: YmISwbySNiqa90P0fOp9dg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38c24ac3706so442909f8f.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 01:39:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738834762; x=1739439562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zK/6lQqcEYL/R1meCPdVrlsxMHj74L1KpqoscZburOw=;
        b=uVmCN2F8Pjp1a/ZRu7WhUVtaa4BKcE0RoXh1hsjQ1fSKIZY0zxv4RMSHoSMxDqgyBE
         rFpVFc8Sg0fKhRdj9+eoEiJbMcSWYMZanB6Dp7G9hSBHgwTKEqc7QU7DlpUzIbetS8/L
         3RnI7rD3tTJINCT/0twD2EVSO50nNDpCNDzFJDpsy4lOi869btdKxksKXs+c/HT76ME2
         7L09QFUCINCD81Pvo0zQxOCn89801FqkbNXKnIURqnZj7dEJaPyfpgb9tH3mIJWdLonE
         cQawvHDpNpM47D3I4Ypc7mrit8SSG/3/0KB3ch8ZcgApmwl2As/z/MrKmUSRLglrM54E
         KgrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXhZzi5GzGXd3/sup0qGbgIf7jdVQlSzoeC0NPvIabqMtjPeok9mVpL0cooif6G7+GmII=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2DQ9NqHtBE/ByVUjYwkCuNQ689UmRzpmCZ53KLiYLj3tfbEgI
	g1dDmwJUty7p0TdPAou5wedKEvm77dVBIayX/LMk2NDvton0qG9VSNUVxTrFZg1hKkhU3Yrj8PI
	o83PtqTBJ4HrQdzr3IqwmoEkQKMUS9+/ltXFvo+7D8459DtdE/gYNw5GY6UqMkZfDyuy3ynpCKe
	stGWfeOsvkqGADu/6SQsiGypvh
X-Gm-Gg: ASbGncutGWEHinpmEUJN040wYhTk/FTHmttdFAebdFG9cgFdXt40OzRCZjCVYbqfKVN
	doE50q1m0+Tc3x6rA5OftuE7SXi76YyL6J2shN1S19oyqfSgh79BniefAPT6J
X-Received: by 2002:a5d:6da8:0:b0:38a:a11e:7af6 with SMTP id ffacd0b85a97d-38db48a92bbmr4538307f8f.6.1738834761941;
        Thu, 06 Feb 2025 01:39:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpew+3VV/qOv0PNC07nCRiS2S9+c5C+JNNGHJrfpdky5+B8ifZWgPwO9qowgfQ/usuET5m5ZbGL4B3N12rG2g=
X-Received: by 2002:a5d:6da8:0:b0:38a:a11e:7af6 with SMTP id
 ffacd0b85a97d-38db48a92bbmr4538285f8f.6.1738834761541; Thu, 06 Feb 2025
 01:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250204155656.775615-1-maz@kernel.org>
In-Reply-To: <20250204155656.775615-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Feb 2025 10:39:10 +0100
X-Gm-Features: AWEUYZno2kuDpIE83k3643TzUSKf5V_RnzWbIr0C8_DMiPc6ZkU3_VvAeoPh5cU
Message-ID: <CABgObfaY9iXAj8QVn0keEpuLR6Fe0z3NLNdx2COnbgDGTLX7sQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Dmytro Terletskyi <dmytro_terletskyi@epam.com>, 
	Fuad Tabba <tabba@google.com>, Lokesh Vutla <lokeshvutla@google.com>, 
	Mark Brown <broonie@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 4:57=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> This is the first set of KVM/arm64 fixes for 6.14, most of them
> addressing issues exposed by code introduced in the merge window
> (timers, debug, protected mode...). Details in the tag, as usual.
>
> Please pull,

Done, thanks.

Paolo

>
>         M.
>
> The following changes since commit 01009b06a6b52d8439c55b530633a971c13b6c=
b2:
>
>   arm64/sysreg: Get rid of TRFCR_ELx SysregFields (2025-01-17 11:07:55 +0=
000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-1
>
> for you to fetch changes up to 0e459810285503fb354537e84049e212c5917c33:
>
>   KVM: arm64: timer: Don't adjust the EL2 virtual timer offset (2025-02-0=
4 15:10:38 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #1
>
> - Correctly clean the BSS to the PoC before allowing EL2 to access it
>   on nVHE/hVHE/protected configurations
>
> - Propagate ownership of debug registers in protected mode after
>   the rework that landed in 6.14-rc1
>
> - Stop pretending that we can run the protected mode without a GICv3
>   being present on the host
>
> - Fix a use-after-free situation that can occur if a vcpu fails to
>   initialise the NV shadow S2 MMU contexts
>
> - Always evaluate the need to arm a background timer for fully emulated
>   guest timers
>
> - Fix the emulation of EL1 timers in the absence of FEAT_ECV
>
> - Correctly handle the EL2 virtual timer, specially when HCR_EL2.E2H=3D=
=3D0
>
> ----------------------------------------------------------------
> Lokesh Vutla (1):
>       KVM: arm64: Flush hyp bss section after initialization of variables=
 in bss
>
> Marc Zyngier (4):
>       KVM: arm64: Fix nested S2 MMU structures reallocation
>       KVM: arm64: timer: Always evaluate the need for a soft timer
>       KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_=
ECV
>       KVM: arm64: timer: Don't adjust the EL2 virtual timer offset
>
> Oliver Upton (2):
>       KVM: arm64: Flush/sync debug state in protected mode
>       KVM: arm64: Fail protected mode init if no vgic hardware is present
>
>  arch/arm64/kvm/arch_timer.c        | 49 +++++++++-----------------------=
------
>  arch/arm64/kvm/arm.c               | 20 ++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 +++++++++++++++++++
>  arch/arm64/kvm/nested.c            |  9 +++----
>  arch/arm64/kvm/sys_regs.c          | 16 ++++++++++---
>  5 files changed, 73 insertions(+), 45 deletions(-)
>


