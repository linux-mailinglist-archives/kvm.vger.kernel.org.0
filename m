Return-Path: <kvm+bounces-57335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 835C4B53892
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83012AC056C
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E707C350D65;
	Thu, 11 Sep 2025 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IO0Qficb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599802153D4
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606553; cv=none; b=I4MEmkmFXgpGMfcpaRVLOJokmsQvWu24UNbAoqc23A/r/qrTG2MtdJf2snyKbeVEDfof1ABhiYZlE1hRIkQHj3kwhtHcd4SGIYtwbO+UiXDMs/wScCB90NEQ7nQQjsbGY6oimSOWJ8IOYf7ISUw5DGiM3qhTSToRKBEhkyGieqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606553; c=relaxed/simple;
	bh=vSPFoGtwxh002ejWcm8cx4A3GNPgAgTbG2HYC/Blbdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JNJZ2t9PBvTZpfbX6m/GDjIdcC+JNlT/cxZUBjv2WgcHjM1SggNhq4iH0diuX8aX0kMjQsc+Ui7JAvkQc0+NQ1AEANJembS+6SVC1WfQyR/KFLObsdSgPl+Adqn4IaZ5B7FfbVITkEhvk7btMXJhbREWihtwqAfAmSg2Qhk94WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IO0Qficb; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-72ce9790ab3so6481437b3.1
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757606550; x=1758211350; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7dRGjVVwpjU1/n+vvstizJLUX8chlCa0TZSJ83N8d/Y=;
        b=IO0Qficb31vcNhM8iFEkZn4ieJg3XgHb+BDlrtf7wzzow4z6Inaa/6T162LYlzc0ym
         wRCYafhzWtXl5RkIFhEDaEASkEis5GxUCuW2hxeibQyDUYpA8jASM5P7aRjymi+Qahp2
         ZeTntHILonu54iSo8/xtBHSYeU4FAVn44cGa/gEz+qt435kH4bKXN5y/JztfFQ8CCPCt
         qEa3ol1HKC8goAp59/4rbpon9CrA7tlkW0O0SdKzUlZbXIpsiqDFrXYqtGAEe4zDpjux
         BcK8OCvqlUeBiAQrQBj0Hm+l5IpDfzQS4VqZ9jREVPBgMFwxTNEiLCEOu1cVXV1hWTeN
         S6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606550; x=1758211350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7dRGjVVwpjU1/n+vvstizJLUX8chlCa0TZSJ83N8d/Y=;
        b=YkotX9frdVbTvY9JdZQ3VPthvaPWrNG+xgSMR1P0nU8a5Vq1iit7UTEmq4Q54BHGHH
         4EvOSjPjrC2SvKh1OauT0HN3KFknv2BKm+SiHiYxQybLFw+GtG9i60f3D1RA6X319Chh
         iGulOPo0yrlPWFXbVAWLqID02A6v6aarKstFa/very8xNYKA6qJ/im6PLGJmA94Exn1h
         h/KMboDH/1Bhi7XZ9EalNqQqRuDeu3IJhLrxaC3wBLq2ZBilKoWwgXUsDQ++Odr915Hz
         Ak/hswQFGUh6WjAXrtgWtE9a1z/9wJxlt4PsHrh4Vo22yVK+kn0t57dDU0Y69h8MHJLK
         zVjw==
X-Forwarded-Encrypted: i=1; AJvYcCVlLMn+NWAwM1mOaoXtwLrVFTqr2KRlGX0/iFOCDlngvoQGnhuWMPeNrjOU1J9UEBGGTj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFeF9W5RQQ1s4ojWBROP4d5mOm3u5+qnK0Qi9TiYtvAw/cUvQp
	ffO3Be7fDe+vuwRIBSwVhjSqGNhoCLFAZTvnMoi7K9iIOn2bOFMyfBqyFWdPSQHD2snzrrR5puu
	6eophjIjm0b9mwxMtkjEA98Y3eNM0R9XBgpIxRBzmq/3CrueDLUEN
X-Gm-Gg: ASbGnctVvQSfGOPy+l/JOa+XVVCjojOgkquGEeeEN6VvPNTMKxSnx4U7dOXTvgLTJuO
	LQzQYb9IEhtYqipme0NTXIIA/v/uo23ucbKYD9rYK2YkCv8fv9xFxSu8ybVI3dnTc51OAqKjwN3
	LDU1ulXET59TzhLJZk/gTnIMCOO7AKSDv8bwO2WzcklJhcjBpQYRSribl/7TQ8qEfQB5HmXIy3J
	0tTxn59
X-Google-Smtp-Source: AGHT+IEcRWg0Ibv9La+c1AHa5/EwzBNdLFmIeSpsqfPLBULrqQYCnbKIvwEz11pcW5Z0PxHmVsBAk1FKJbGhiL4pVXI=
X-Received: by 2002:a05:690c:e1a:b0:721:1649:b070 with SMTP id
 00721157ae682-727f5648a22mr172576627b3.44.1757606549654; Thu, 11 Sep 2025
 09:02:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
 <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
In-Reply-To: <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Sep 2025 17:02:17 +0100
X-Gm-Features: Ac12FXx96W2Z904Fh96vP6TMP44uauq6yyDdA3EE2iGnUzJEwgpWwDS7kISm_EE
Message-ID: <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
>
> On Thu, 11 Sep 2025, Peter Maydell wrote:
> > On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
> >>
> >> This series adds a vcpu knob to request a specific PSCI version
> >> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
> >>
> >> Note: in order to support PSCI v0.1 we need to drop vcpu
> >> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> >> Alternatively we could limit support to versions >=0.2 .
> >>
> >> Sebastian Ott (2):
> >>   target/arm/kvm: add constants for new PSCI versions
> >>   target/arm/kvm: add kvm-psci-version vcpu property
> >
> > Could we have some rationale, please? What's the use case
> > where you might need to specify a particular PSCI version?
>
> The use case is migrating between different host kernel versions.
> Per default the kernel reports the latest PSCI version in the
> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
> when that differs between source and target a migration will fail.
>
> This property allows to request a PSCI version that is supported by
> both sides. Specifically I want to support migration between host
> kernels with and without the following Linux commit:
>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3

So if the destination kernel is post that commit and the
source kernel pre-dates it, do we fail migration? Or is
this only a migration failure when the destination doesn't
support the PSCI version we defaulted to at the source end?

thanks
-- PMM

