Return-Path: <kvm+bounces-51179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A9BAEF4D7
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7E9D480807
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4715227056F;
	Tue,  1 Jul 2025 10:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="obcrPlro"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2BC26FDA6
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751365023; cv=none; b=u9OocRln1ZgImob6GeUnyM/ibcTVEZ1miZb48ItmBIpoQONAVfAK6LrrudtPU0jnBQY5L20Odq0p0RezH59G29ODf8oJucDRH1SM+9rpkhRaT4GM8KBjGnkFr7hfiCXEByQbvudhkW5n4bmvDgvPqT18npqexh0eMXXXs1tkMis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751365023; c=relaxed/simple;
	bh=fQWdNlzQPxrRoJZR2/EkBzZwhWrvSn16ca1VwCSfFzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TXtRvIppc8Xu7cXc50aBh0QAGNJC7JfwqvlPHoCy4DUoP8Wpt+XSMOCUBv+iVeoiUkUGlHH34uuM50Y97wZveMgU6bs27nW+6wUpA0VCVm+7B2DYgPkQVIOiCgIBG22xk4c/wZH/WhPuKstMQEi5F4qjsx37IjCax4sd41OBspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=obcrPlro; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-70e302191a3so54370397b3.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751365020; x=1751969820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EZGFydrDXJBrz0DVvdE/jHAvcnNcUyTdefYv3idd5Q=;
        b=obcrPlroowQ3JgLhVMeorHHDI/4PXG1cTr0l2eE4hMtOL0XsFb244LhUT+cYcpJvnt
         iHELGxe/ZVDpn6Fy0oxz7leBtUU+xqiqX5Rq4tTEDcG+kB9AnNhe1sByEn4fRgGVzl8H
         il0oKlAOo9TVgNRRPjS3Vkl8h9Vkq3KHy/gt3fGZIJwW+zTr1/CqwtbKDnK4obvG1FzZ
         /571VIuDAO9DPlSrb7h7ElREI8tQd7XMq8r05x65hBwPfan7RzmyJVP1iNjaWE/B9YOm
         iZAQvpEx5xlGCu0zz9Y4YJ3IeNo8VsNwuzVEGSDDhnXKzMoKoydCPGtmDDGzYlJK+k03
         tmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751365020; x=1751969820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/EZGFydrDXJBrz0DVvdE/jHAvcnNcUyTdefYv3idd5Q=;
        b=QYLM6s52emlbQmFg5bjhtJMDfjlGoCmdWyvmh3Bvzum9XRai5goopPzguCBdcXqrf1
         tK8h6RI3nPn7S5XQY2DUqLr3e5M5NK8VX/rReSknkSaX4PC1LZg5oNXzcmk0y6mHf6x7
         ltwJmX90hX+GT9EGe0KPlTTlU/8nlZzev465v1D65SzprIBy2RuQKMKedPCoq3dQN2n4
         pDuJamGz2ykW3JMpRLGwhRK3/VPWisKJ9hU4TPlenrZn6ZUM+ZZ3oWOiyGFikdhtHY6R
         U2FYsD/iN8OzLGIR1nKHaM6LhVS//rWCS5jRDrQpdYB4GJjDjekbUgxTkKyvyN6KXyYm
         R9mw==
X-Forwarded-Encrypted: i=1; AJvYcCU9VQmOKiqCpFBpVCmbwK+/2QQMiBldrRFvq2cxRPoWHRHbfaPD0X0TiMeNHJX7MMaUSS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoDBAWuv87/d6obyTpCFNjlfN+C56DtVBd5l9XD+3epVhsMMam
	l29hXcp4qyx/QkFs/rJigEFmo7ncURM0UHKhxFrNEIVYaRaOGJwJd8RjLrBDr7Z/+CJxWdRbAb/
	5UDE/L37CahF0rqMynTODUXkgXzB6EqsY6Ew2Zhj5BA==
X-Gm-Gg: ASbGnct7W4e00fLj+UqPW+xplQoFXmIYxzAkyhmA2rzQ54aOw0/2l63krwCn6d094+i
	e7CuIKK91TcCPWnmpjWGcZRGZj/e4+HCNfx3kucqpmKgfO8aHfFa8sq3YvtqbaXPt7Cvkw4K+ga
	DNa06TnLNtOkn2tjJPKjWTeIxhogZZO0UuQgAG/eF60exE
X-Google-Smtp-Source: AGHT+IHaev1eooza1tvFqNELJSxTEWCpDaYkpuMurhT9txvR+eF996nXRUAaSLtmrPa7B4Hk+87ADuca53LAipHLb58=
X-Received: by 2002:a05:690c:4901:b0:710:ebdb:83d3 with SMTP id
 00721157ae682-7151713eb30mr235674297b3.8.1751365020417; Tue, 01 Jul 2025
 03:17:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 11:16:49 +0100
X-Gm-Features: Ac12FXyxBi2YNUaZLCDi3EC5J8pKLHPxbd-OCNyqfbGXsAeITXA5VEa44a42DSs
Message-ID: <CAFEAcA_hD_8XjMU+xdXM6ez-O8xmQtSddFLUA1j4JhstmJTFFQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/26] arm: Fixes and preparatory cleanups for split-accel
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>, 
	qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>, 
	Radoslaw Biernacki <rad@semihalf.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2025 at 13:18, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> Only the last patch is missing review (#26)
>
> Since v2:
> - Addressed thuth review comments
>
> Since v1:
> - Addressed rth's review comments
>
> Omnibus series of ARM-related patches (noticed during the
> "split accel" PoC work).
>
> - Usual prototypes cleanups
> - Check TCG for EL2/EL3 features (and not !KVM or !HVF)
> - Improve HVF debugging
> - Correct HVF 'dtb_compatible' value for Linux
> - Fix HVF GTimer frequency (My M1 hardware has 24 MHz)
>   (this implies accel/ rework w.r.t. QDev vCPU REALIZE)
> - Expand functional tests w.r.t. HVF
>
> Regards,
>
> Phil.

Hi; I've applied these to target-arm.next:

> Philippe Mathieu-Daud=C3=A9 (26):
>   target/arm: Remove arm_handle_psci_call() stub
>   target/arm: Reduce arm_cpu_post_init() declaration scope
>   target/arm: Unify gen_exception_internal()
>   target/arm/hvf: Directly re-lock BQL after hv_vcpu_run()
>   target/arm/hvf: Trace hv_vcpu_run() failures
>   accel/hvf: Trace VM memory mapping
>   target/arm/hvf: Log $pc in hvf_unknown_hvc() trace event
>   target/arm: Correct KVM & HVF dtb_compatible value
>   target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
>   target/arm: Restrict system register properties to system binary
>   hw/arm/virt: Only require TCG || QTest to use TrustZone
>   hw/arm/virt: Only require TCG || QTest to use virtualization extension
>   hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
>   hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
>   tests/functional: Set sbsa-ref machine type in each test function
>   tests/functional: Restrict nested Aarch64 Xen test to TCG
>   tests/functional: Require TCG to run Aarch64 imx8mp-evk test
>   tests/functional: Add hvf_available() helper
>   tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator

Where I haven't picked up a patch it doesn't mean I'm
rejecting it, just that I don't have time to think through
the more complicated ones this week, and I wanted to at least
take the easy patches to reduce the size of your patchset.

-- PMM

