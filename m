Return-Path: <kvm+bounces-22511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F23193F931
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9A861F22FBD
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B61156F30;
	Mon, 29 Jul 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QelriPIB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049BB1487D6
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722266046; cv=none; b=VvZiWhe+b5qOfVrmlpSJB1j80CUd6kBe3RhIjqjtEC+G9jrIgGVqzcV9WImiuouQ3JpR7wYiwY2uBPzSE5CxiJ/TjtoMmfoYvBBM5fiHE/W8K65N4i1CfsTL2k/rf+0CdQynrrvZ6yAi4cwWLKEyLNon9Or9oTFzs5KV4oF+oms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722266046; c=relaxed/simple;
	bh=dtzkPLkwdWH1FJOPEcLFBdupmDWr4rq1L8AayGCyo08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s9Emyr7b/Um1FWQdvzRFrM0IgdeZ3x4QNTmxr6W89vTNRY/Uhjv+Vt9ZhrFipY9pGxbmeBVDgO4w8NEgX2owWlc8OeIuRBdzMf/ime38aUkcG8l/5IrigR8qA8FEJLWQysV1lbwZOfUOdCI2BWGnsV+RZcTBj+6jNFTsBRhMCDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QelriPIB; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5a156556fb4so5794878a12.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 08:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722266043; x=1722870843; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tXRCoLvUC43mCRcozMDDdTd1IZQkjbRsqylKzysvyww=;
        b=QelriPIByS8BxMay1N9bNx2ZBNS9decv+pNS8wSmJGsdFNyplg7JdvAlmuop4MukED
         Kag9LijDuvJGNvWkHOgU1wzg9yxPyHSSVFwMTgJgz+OAy4/LhDxcDmuXpSmHDq+yEnsl
         XLc4GAIh0l2rOzcKjmMVSLFIbG9gJgFrbSdSegv/eUWQkDBVQu7bfObuGtFhPMBR/VhG
         WSqll0fk26kjBx6g1ObQfDlvorZCF7xih8DKx+/VrqkR9Gs2XjJKOMDdS6V59JrycoBP
         qPVlEuuK3DTA5ukV8Mnsw15yceeUkCq+Lp/bfI+5lh39fgAuJLQxRVBrNjwMoSZZfYCX
         oJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722266043; x=1722870843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXRCoLvUC43mCRcozMDDdTd1IZQkjbRsqylKzysvyww=;
        b=kVBjI8e9Ijurk/InRS2Ln4i/2SvMRw1yd4Qqaa7dHmOXVUmVMlAWalqlkNmhjM3jNh
         LHAiwi6KkZrwruWsP7Qtn/n42fFodkmMsh2wEtyCL8uAI93Agd99kzsxe9UwIE0NQ5Qq
         R5S2j8jvoR1i8ZCGL/BllePzAfBXcwztJOhRcXaoBHeAEsf9oRR9xqoTYqvzHioWd3bH
         j8iut82K0Q3cWA01CpV/ZlbMm9IzL7u40Whapk+7mBDeqHbvJVdDPSF+CFIps83wgC7+
         5PELJP75MMLN14NgNTY3B6zi+/zw4ZGLJG8dNsvEznY/o0XyZ9vJhq/Oyo0/rIK1+Zq9
         SLXw==
X-Forwarded-Encrypted: i=1; AJvYcCWrnnEkdU2niCoN5CPeXuI324CKUCVSxxDsiF8STL82ddfqYCJjoBSgK6xyFCYpmHi0cSm6yzRv8gP5wELIrooe6WV3
X-Gm-Message-State: AOJu0Yzx2N29eBeb0qG7DiGfxCMWeoxCX0Zk6bYMqr49nxjA8LQIXRVn
	P8DY/sf7ZbjRP9lBxC4GJs7qbWAuCrmBcW16jLqB2v7u4e59JAMbrtlorkiBqTEf3HqZb4rQc3v
	U3mHEyAF3uT/9XHINxdcpgD2idhB69PyiF++3zw==
X-Google-Smtp-Source: AGHT+IEs8iHg9e+bOR7W3CkBhHyHTd7gyVHiVEpROtEV8UlqIDIqwS8P6KwVB/1hSoNtpt6mIOAqLDchb0mgMZ5A8/k=
X-Received: by 2002:a50:cd18:0:b0:5a0:f8a2:9cf4 with SMTP id
 4fb4d7f45d1cf-5b022003a8fmr5356669a12.25.1722266043138; Mon, 29 Jul 2024
 08:14:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com> <20240720-pmu-v4-3-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-3-2a2b28f6b08f@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 29 Jul 2024 16:13:52 +0100
Message-ID: <CAFEAcA_HWfCU09NfZDf6EC=rpvHn148avySCztQ8PqPBMFx4_Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] target/arm: Always add pmu property for Armv7-A/R+
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Jul 2024 at 10:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> kvm-steal-time and sve properties are added for KVM even if the
> corresponding features are not available. Always add pmu property for
> Armv8. Note that the property is added only for Armv7-A/R+ as QEMU
> currently emulates PMU only for such versions, and a different
> version may have a different definition of PMU or may not have one at
> all.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  target/arm/cpu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 19191c239181..c1955a82fb3c 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1741,6 +1741,10 @@ void arm_cpu_post_init(Object *obj)
>
>      if (!arm_feature(&cpu->env, ARM_FEATURE_M)) {
>          qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_hivecs_property);
> +
> +        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
> +            object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> +        }

Not every V7 CPU has a PMU[*]. Unfortunately for PMUv1 the
architecture did not define an ID register field for it,
so there's no ID field you can look at to distinguish
"has PMUv1" from "has no PMU". (For PMUv2 and later you
can look at ID_DFR0 bits [27:24]; or for AArch64
ID_AA64DFR0_EL1.PMUVer.) This is why we have the
ARM_FEATURE_PMU feature bit. So the correct way to determine
"does this CPU have a PMU and so it's OK to add the 'pmu'
property" is to look at ARM_FEATURE_PMU. Which is what
we already do.

Alternatively, if you want to make the property always
present even on CPUs where it can't be set, you need
to have some mechanism for having the user's attempt to
enable it fail. But mostly for Arm at the moment we
have properties which are only present when they're
meaningful. (I'm not opposed to changing this -- it would
arguably be cleaner to have properties be per-class,
not per-object, to aid in introspection. But it's a big
task and probably not easy.)

[*] It happens that all the v7 CPUs that QEMU currently
models do have at least a PMUv1, but that's not an
architectural requirement.

thanks
-- PMM

