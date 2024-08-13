Return-Path: <kvm+bounces-23974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A1795021C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37B10B26A3A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D161898EB;
	Tue, 13 Aug 2024 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8nIy9PT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0F1607B9
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543631; cv=none; b=XzmXLtWQ9D+CNjjNYTb3CGcFAQ28FoFrzkIkyS2mQpYW5EkZazO5rP9AsCnuRulgWK4m9QxCVZbEYbU0CDqter6kmpuD+skHwU6Bj15xlKiX/Myf8ZIt6S7m32rSjXRFaPzrJ9Bnwwr4Vgjy3I6H46IkGQaPGbn+aBA86Zz3WjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543631; c=relaxed/simple;
	bh=OpU1+ywTBKCCT1UVkJHl2CzzFHTxAXlIpSi9zVut8Ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u34dW4W7beaa61pjLePaCufr6YkywuhfB6ORVJLxCB2gdiRsZMHY01B3o3ThNs2rvk78ucPvKTkket42I1XK73+mXvCtpdALz9lXYOk9VNUn3G8GZhSnzK1JK1oBzOJXEa6/pqmKuEhLjqgVF485AXghLNd4RPufGqR0i0HNlfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8nIy9PT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723543628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdGpFIJhXUbfoxC6RL3l2LvGdIi9u4emfZaadOLgiuo=;
	b=i8nIy9PTOW5RCLJYiFumKmOJWEIu62ucF6yHVVw0+EQ9DoQJYJLJ8CXovTCoFb1PpiYT4r
	95WbXEmcvICcqFTFjXB/xGF0bc4D0nmewaVGUu0geiMVgfXGrV6WesMFDGIctqql0nwlqb
	siIW6TjgOd8tsIQ5j1ZHxwCpayDJZn0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-WNPUMVybO_GFjt365F8r3w-1; Tue, 13 Aug 2024 06:07:05 -0400
X-MC-Unique: WNPUMVybO_GFjt365F8r3w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42808685ef0so38027825e9.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 03:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723543623; x=1724148423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZdGpFIJhXUbfoxC6RL3l2LvGdIi9u4emfZaadOLgiuo=;
        b=BmAqA0AuzKd4sxWWnXavuIbsWT6l2exRmi0nHd5rMOcmjywpgFX445oK/aOXJp1z+I
         Zkv4LDf+hy+5elW9VLzovJ/8dq5KtBvE2fQmHJOYXlpbUbOyt1mIpHtteVpyvjNkoq9y
         MCiBIZxyOnU/PqjsNgFtSHmbQj9fw+PWn2wK3SPLi4eDMsMErY7os8QQYOfrVOOSix6o
         sNpTyCP/FCzJNwZFj38tAO79UPVlBNSHEcE59gw+T8cyNFwhyr2ASSuWsCqcqEcoMGPp
         6pE+f1BPJlUhJBWj8HVly3I8fYWJB3lhgvoJKopdV8rQq4bl4LyySlixdG6hqd2SI7/d
         hV2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWI9IYG1YLQzEpzlMFOosU3RkAVP4t/bI12/2vNabCUMvZP7dqfbGuGzUPp5nMoOyMqsopnM/WGAt6DQy6TtsqT6nG6
X-Gm-Message-State: AOJu0YwZg8xDCkA6+8MYM26Ec7n/FYkijMoX6Q9phgOsvsyGfO0fgLxa
	iPKalDR2QPk0ZwM/v1tvnAz6sC233lKcZIgxeCu+n1SWh9WHbsDvKJeS+aX9CGNlEgQWtU1MyZo
	KWXHiKpel8xARvPOnB3EmOOMpE8zTh46OjZwGxlTdUjWd5+h29vS+zT3U3b1SN3Hjvcc2y1A3j+
	D7bV2gOz+b1FiampclangxiOUj7Jv9NrFy
X-Received: by 2002:a05:6000:45:b0:366:ebd1:3bc1 with SMTP id ffacd0b85a97d-3716ccd71aemr1739832f8f.3.1723543622996;
        Tue, 13 Aug 2024 03:07:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDvTUTDd+LsRhjmB6zNVog1K4fVcAdlK3qvWE8ZDFz2Q/6hzL0KTKDRwibjwzk8bnEf5C27ISqUKXY48zo5Zg=
X-Received: by 2002:a05:6000:45:b0:366:ebd1:3bc1 with SMTP id
 ffacd0b85a97d-3716ccd71aemr1739813f8f.3.1723543622487; Tue, 13 Aug 2024
 03:07:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrXPY7yIG0eu8mQU@linux.dev>
In-Reply-To: <ZrXPY7yIG0eu8mQU@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 13 Aug 2024 12:06:51 +0200
Message-ID: <CABgObfa=AL_+-oYAAOYM+gbS=UXnoBfsroohB5B+b1g4cvoJbg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.11, round #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexander Potapenko <glider@google.com>, Mark Brown <broonie@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Takahiro Itazuri <itazur@amazon.com>, Sebastian Ott <sebott@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 10:12=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Decent bit of fixes this time around. The most noteworthy among these
> is probably Marc's vgic fix that closes a race which can precipitate a
> UAF, as seen w/ syskaller.
>
> Please pull.

Pulled, thanks.

Paolo

> --
> Thanks,
> Oliver
>
> The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f01=
7b:
>
>   Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.11-1
>
> for you to fetch changes up to 9eb18136af9fe4dd688724070f2bfba271bd1542:
>
>   KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface (=
2024-08-08 16:58:22 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.11, round #1
>
>  - Use kvfree() for the kvmalloc'd nested MMUs array
>
>  - Set of fixes to address warnings in W=3D1 builds
>
>  - Make KVM depend on assembler support for ARMv8.4
>
>  - Fix for vgic-debug interface for VMs without LPIs
>
>  - Actually check ID_AA64MMFR3_EL1.S1PIE in get-reg-list selftest
>
>  - Minor code / comment cleanups for configuring PAuth traps
>
>  - Take kvm->arch.config_lock to prevent destruction / initialization
>    race for a vCPU's CPUIF which may lead to a UAF
>
> ----------------------------------------------------------------
> Danilo Krummrich (1):
>       KVM: arm64: free kvm->arch.nested_mmus with kvfree()
>
> Fuad Tabba (1):
>       KVM: arm64: Tidying up PAuth code in KVM
>
> Marc Zyngier (2):
>       KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
>       KVM: arm64: vgic: Hold config_lock while tearing down a CPU interfa=
ce
>
> Mark Brown (1):
>       KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-li=
st
>
> Sebastian Ott (3):
>       KVM: arm64: fix override-init warnings in W=3D1 builds
>       KVM: arm64: fix kdoc warnings in W=3D1 builds
>       KVM: arm64: vgic: fix unexpected unlock sparse warnings
>
> Takahiro Itazuri (1):
>       docs: KVM: Fix register ID of SPSR_FIQ
>
> Zenghui Yu (1):
>       KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI
>
>  Documentation/virt/kvm/api.rst                     |  2 +-
>  arch/arm64/include/asm/kvm_ptrauth.h               |  2 +-
>  arch/arm64/kvm/Kconfig                             |  1 +
>  arch/arm64/kvm/Makefile                            |  3 +++
>  arch/arm64/kvm/arm.c                               | 15 +++++----------
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  1 -
>  arch/arm64/kvm/hyp/nvhe/Makefile                   |  2 ++
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |  5 ++---
>  arch/arm64/kvm/hyp/vhe/Makefile                    |  2 ++
>  arch/arm64/kvm/nested.c                            |  2 +-
>  arch/arm64/kvm/vgic/vgic-debug.c                   |  5 +++--
>  arch/arm64/kvm/vgic/vgic-init.c                    |  3 +--
>  arch/arm64/kvm/vgic/vgic-irqfd.c                   |  7 ++++---
>  arch/arm64/kvm/vgic/vgic-its.c                     | 18 +++++++++++-----=
--
>  arch/arm64/kvm/vgic/vgic-v3.c                      |  2 +-
>  arch/arm64/kvm/vgic/vgic.c                         |  2 +-
>  arch/arm64/kvm/vgic/vgic.h                         |  2 +-
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c |  4 ++--
>  18 files changed, 42 insertions(+), 36 deletions(-)
>


