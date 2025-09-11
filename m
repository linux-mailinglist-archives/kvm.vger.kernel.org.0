Return-Path: <kvm+bounces-57339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6B9B53959
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:32:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96CB61CC1597
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A8035A28C;
	Thu, 11 Sep 2025 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lD4jeMRX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A6335082D
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608369; cv=none; b=FScNLO1vJZx9m6HZ3rMFGJGJpgCO4Nb8OebqdoPla0XmC8FXdReaSzUI/MLbQuRrkU1a6OsFwkUpEan6fZi42svF8j4JrKDP30QqNoVt3KtVdno1tTUfUqG7rfkdmPGlDtcmMiIEmd/a+tFkb+8qhFFZP+wovJhJBABI8kp4qeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608369; c=relaxed/simple;
	bh=St1GXFYFnQmwJYS+6lpFf6dXoKkG15hVX4vyJdlNAW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mAD1lzQx1+5WYFzJYDjMWGKDPUwRgn+Usiy6z4EoYIA7d5LkDCgvLibHb5BNDxfvmvrVI0HlUM5/pgNPjjGri2l4Caf3Qh/PTocsD2ULTry60pAs6ViYcXT9Dof3jqthyT/iKwd4/luNTaAlLw4nwiwV/P9C+qr/L/64OkMuUaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lD4jeMRX; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-60f4678ce9eso582930d50.2
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757608367; x=1758213167; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3oSOMVjrhS6G3pVuMKnnpOUFEcnFdvdNa1gz4DKRv8Q=;
        b=lD4jeMRXhhwM+2tp36Yga/FJSEd5Lv113CAAdaH7u4yD/uLUKc1fk5hVu9nRBFiLS5
         0zOpYNmkDvRd22S/2OheWW9XZWoerQgvcG0sqeF1hRrMm29MhcgnPRocbHS12rFbvyCP
         npni+9sXN8JTy611pG5N+XA/kds+2SZyr2taeQyv2KoaM7yW9YrlD1yWJ/pqsxMlL0ON
         ShTrfMD+vAs8LPOxR1eRu1Nctpdt8bNRVNDwBAEvKQ7SqKb/RpS2GzyL7lRQ/GoXeO5x
         ZdgMOf45dO97PVhX5OIekmfPlDxMyYawea1rhHak10o1oLZ7IwolUSteDbQXLkiA/lM0
         gk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608367; x=1758213167;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3oSOMVjrhS6G3pVuMKnnpOUFEcnFdvdNa1gz4DKRv8Q=;
        b=NVPT/EYSNrwOlAuOsX/KleN0Tn8jRf88O1dvW1+gJ3iAcT5trxDNXstY6TpDzThfFR
         64DFr3OsXe5U5Juu0yX95zgXcFBS/qqn5hbsoz5Ir0zllQ7YNNhaWgNgISINZoGTqTHH
         /MpfsBAyj2DBSfT7l8yI9YpyqiZs1BAiEUNtRZcKMhqvdxDmIs+cxJACl0sb0awdYwLC
         W2MDEqi1kMM7IzSVSr1mf+U8cFyl8pE/5UBzC8oyJV3pR6dMNzcHZT3WgsMhGsHt2cov
         6vHghoi6fUMBrsvGg0NdlXNh+pDx4aqRj1XzvPhJTfQG1YQpDFrrGHvpHn+i2cT5+xrO
         nylQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8E35TTrosa7UY5ml8jnz2n7YpBKLwRfF+OU+SW56DARwQx+1/ESo2pwpasbi1QKDmbcc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL5aIZhnyqet9UFb0Nv14p7RcfZIJsnpldPnie1p8DiAsoL5c7
	Njhu7mlo++4nC+6KHUBpdouYyNUZe4qf4kvMpSPz4QdY0Srgnaq4m01ZV9OSGk5d7rQXy9FgAJL
	t0UKnMWnjTjxWJDXhNlED1xZy+k3wRNN47Km2NCV5aw==
X-Gm-Gg: ASbGncusZyfXwSOgd+c5MkA2MXPV6zIUiiOmiUKlH0KAS7qczyizFnUtmPj/1luEop4
	nXyrm+cPtLPRDBesxBjIp4Y2tu7ylX5nyP6ULrdEXp56LXVpHbs7sxSHMgzlw619sKMOJ9PuNqL
	Y0okC0NWU91E84AXqPUxaIuEoOzv5K+MxZzpYzW1U5ECxv3oHkMVEwaT75T+FH0GsLFNpS6ugXu
	/PfqGHNN4DdIfLnw5s=
X-Google-Smtp-Source: AGHT+IGeH4N1vRnvak9qS44/0yvd4kSpobvGAPZaf480hH7OvuTCc6WKyKo4fqYHz2dGmlPhCMyjzhePDUvTwh237O4=
X-Received: by 2002:a05:690e:1a59:b0:5fd:9dff:f343 with SMTP id
 956f58d0204a3-62720222db3mr166980d50.20.1757608366474; Thu, 11 Sep 2025
 09:32:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
 <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com> <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
 <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
In-Reply-To: <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Sep 2025 17:32:33 +0100
X-Gm-Features: Ac12FXyeDpESW098EQeaKffAkGnL6LiJ4UVpPXhZdC_pEr0Pe8Dw3xSUiOGspuo
Message-ID: <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 17:29, Sebastian Ott <sebott@redhat.com> wrote:
>
> On Thu, 11 Sep 2025, Peter Maydell wrote:
> > On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
> >>
> >> On Thu, 11 Sep 2025, Peter Maydell wrote:
> >>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
> >>>>
> >>>> This series adds a vcpu knob to request a specific PSCI version
> >>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
> >>>>
> >>>> Note: in order to support PSCI v0.1 we need to drop vcpu
> >>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> >>>> Alternatively we could limit support to versions >=0.2 .
> >>>>
> >>>> Sebastian Ott (2):
> >>>>   target/arm/kvm: add constants for new PSCI versions
> >>>>   target/arm/kvm: add kvm-psci-version vcpu property
> >>>
> >>> Could we have some rationale, please? What's the use case
> >>> where you might need to specify a particular PSCI version?
> >>
> >> The use case is migrating between different host kernel versions.
> >> Per default the kernel reports the latest PSCI version in the
> >> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
> >> when that differs between source and target a migration will fail.
> >>
> >> This property allows to request a PSCI version that is supported by
> >> both sides. Specifically I want to support migration between host
> >> kernels with and without the following Linux commit:
> >>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
> >
> > So if the destination kernel is post that commit and the
> > source kernel pre-dates it, do we fail migration?
>
> This case works with current qemu without any changes, since on
> target qemu would write the register value it has stored from
> the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
> on target to emulate that version.
>
> > Or is
> > this only a migration failure when the destination doesn't
> > support the PSCI version we defaulted to at the source end?
>
> Yes, this doesn't work with current qemu. On target qemu would
> write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
> register but that kernel doesn't know this version and the
> migration will fail.

I was under the impression that trying to migrate backwards
from a newer kernel to an older one was likely to fail
for various reasons (notably "new kernel reports a new
system register the old one doesn't") ?  Perhaps we should
think about the problem in a wider scope than just the
PSCI version...

thanks
-- PMM

