Return-Path: <kvm+bounces-21829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB070934D08
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D68591C229B5
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B0F13B5A2;
	Thu, 18 Jul 2024 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OVCdNCBd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0812C473
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721304887; cv=none; b=DTh33ILfqxNJlrGcQnZzwrAH+JBw1kh4HW9XdTDorSaX2PDI3DBRLngUxuEpmcbnJsZVTK4L8AUC9Zipmg1rECnBW8Std4Mc6eDdYMFq63ddnFjevCor9EKXR5JJkoWP0hPOHT8z8q8B22EHuSX5amfaPkGHEV2rDp/cRVsj8lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721304887; c=relaxed/simple;
	bh=aco/3AAfoPmRyM6ToEfACnvAzDHiw25PsAVcEIIiBIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A/B+bOBBKdCkpAA4mQD+ZDfam9DV/ya01bzrXYbmjor0sRbBHqDoy7gukBMCwIpD617naep/YHYF0PjFGg52cWdkLy9emH9sMNig/i5c5IiGYSOlE/rYcBQrTqMbCC8PoH1H98AgGe+lE0SlgxYgJry5cmmaUU9+6YE6YpzlDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OVCdNCBd; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-36798779d75so709505f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 05:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721304884; x=1721909684; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9qsVsg1ViojjIwgSQ0F58P2aHMMy1cjG85swySoOl7M=;
        b=OVCdNCBdRUiCYtiR9mIt6JW856yJlrFntiRqk8t7m2d9pNewus2qKPk84RKmsiOrET
         EGtFjWPW0FYKvbs3V+LsE/sST9Ey5pzy1Iij+3i53A/tORAzyocBzUcYjFggcB5J6S/t
         hhR+j5BLB03vvpymxGSUdY7wSiy0C5Pp6RuKxqGq6yqiBOyulq+sl6pbAGcoxPWj9kPO
         oH0cfUVgNA4h7+/ysO9FXIC52pxarwQjcqt5dlIcqNfMuM0CikztQasHF9hQMtE8V4Et
         dUsB+qMVI4u8rSoXFqgD9d9+E0TNwtAyHSSfeKtTUnf5875b+zpLMMsmSe6CkmL2Wi/W
         AQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721304884; x=1721909684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9qsVsg1ViojjIwgSQ0F58P2aHMMy1cjG85swySoOl7M=;
        b=wz7tWQsPy1Q51WDFDe2Z0K8YYRBzOZcUJgwgWw1TengpJF6038mBKCibFSZeMdCr2r
         fRM8Ixo6pglhi3ZtlKiuVhMQxSyfUQLQ6sJNtOo3B+ODF+aj11wwPSofDYWsyr+6ru0i
         47c89NyI5fMyCjPwmGkv1Eg3rIIfowe+n+1huJfalO9siS+LkP1oGoUfK0Q4vT188Toy
         OVSslHuchedeIpmMzNI3q1UtMwl39rNsnIF0sUmQJLnwzSu10ePpbhn5Yh1AILYK22Bo
         cJKFvDZ44v6G5A2PfISKUanE+pe9W3fVdfIfa1l2lh20WU7zYRbZp7tNc3cfDNKIavN6
         lEHg==
X-Forwarded-Encrypted: i=1; AJvYcCWB/PFknRwBhE/FTHbQy61JDNX1/Q5uY9orcYp9TVZ5xCvqDgzIE6fNQU7wqmn/PDXn1pbrDQf7sG4fbrelzU19tdms
X-Gm-Message-State: AOJu0YySNWJCmlFPJmvOeKpnrjmFNYKniE+d2GBx0lm3iqYmJ7CdKOZ/
	cqNh0d0374TS4vv4TAiaSzwP++VP6Mji7hANOLUDeuSKNtBD3dlFWEV5IOZs5NOy/YUAMU3fD1+
	8KU8N553Gq+5O2Gzukp6gp7BZb82MoAAlJnf1HQ==
X-Google-Smtp-Source: AGHT+IEMipb3SbK7ecswG8tKXL1R8ctTFurUtnHmwNCQTkbuz+DRKLXD8nr7YIIz7g8XnP6wpy2xuHCe+1bLjs7HiLs=
X-Received: by 2002:a5d:5009:0:b0:368:319c:9a70 with SMTP id
 ffacd0b85a97d-368319c9b62mr3353986f8f.5.1721304884408; Thu, 18 Jul 2024
 05:14:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
In-Reply-To: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 18 Jul 2024 13:14:33 +0100
Message-ID: <CAFEAcA92tB_Hf9AcYsnCSfzCu34RDOb1Mxf8QsQzV1Re9aGfDg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] target/arm/kvm: Report PMU unavailability
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 13:50, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> target/arm/kvm.c checked PMU availability but claimed PMU is
> available even if it is not. In fact, Asahi Linux supports KVM but lacks
> PMU support. Only advertise PMU availability only when it is really
> available.
>
> Fixes: dc40d45ebd8e ("target/arm/kvm: Move kvm_arm_get_host_cpu_features and unexport")
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> Changes in v3:
> - Dropped patch "target/arm: Do not allow setting 'pmu' for hvf".
> - Dropped patch "target/arm: Allow setting 'pmu' only for host and max".
> - Dropped patch "target/arm/kvm: Report PMU unavailability".
> - Added patch "target/arm/kvm: Fix PMU feature bit early".
> - Added patch "hvf: arm: Do not advance PC when raising an exception".
> - Added patch "hvf: arm: Properly disable PMU".
> - Changed to check for Armv8 before adding PMU property.
> - Link to v2: https://lore.kernel.org/r/20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com
>
> Changes in v2:
> - Restricted writes to 'pmu' to host and max.
> - Prohibited writes to 'pmu' for hvf.
> - Link to v1: https://lore.kernel.org/r/20240629-pmu-v1-0-7269123b88a4@daynix.com
>
> ---
> Akihiko Odaki (5):
>       tests/arm-cpu-features: Do not assume PMU availability
>       target/arm/kvm: Fix PMU feature bit early
>       target/arm: Always add pmu property for Armv8
>       hvf: arm: Do not advance PC when raising an exception
>       hvf: arm: Properly disable PMU

Hi; I've left reviews for some of these patches. I'm going to
apply "hvf: arm: Do not advance PC when raising an exception"
to my target-arm queue since I'm about to do a pullreq for
9.1 softfreeze.

thanks
-- PMM

