Return-Path: <kvm+bounces-51204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C71AEFEAB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 17:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4971178810
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A692797A0;
	Tue,  1 Jul 2025 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e9yLwsNG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF371C84C5
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751385029; cv=none; b=hMwfRgKvtDbPIGV6Oy3Tkr3jbqKmmMUKbDuPpYZ0cUrJwq04ImVPZ1JCOK2mudKvQ/jFzNz371AC486hBZSOhcytHsvfxCxXJGpl3hl4MpCRdKLWwKWcKeLEDbiEkC73Mh8CCVcbx7nAKq1mxW6HRimXjjokDIpBSEghW0P245c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751385029; c=relaxed/simple;
	bh=O8bXaMRUBRWCcpUy84xcRUs53mH4mMSR3Jt9aCAf+6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uj5SOGxwE+joMEZBpFQhpTWN90Gee54gJEfVNNkg+gKtk6/By/beGCeD8Dj/PzHz2vR7A/at+IhC6ZMMSq5MX+vCAngJncE6uUIk8CnHWtxrPa/jajcditr4+uFWh3hRDqp7HHeDCwDLBcl3Z9OHWwbBpKiBgXx6aO4oUo6AJFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e9yLwsNG; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e81f311a86fso4585660276.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 08:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751385026; x=1751989826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM0m9m6FgXQhqUCQOzdMmZYVj23cYKuGezzGfv9F+qE=;
        b=e9yLwsNGNQ5LgAtOMbmS36Ra5R7ILPOBJNUkFVAnozUXdjbp+Wkmo7S0hmAUqHsQ6m
         u5ZVX6a3HRHi1iZbVRLURGNuYZo5xqXCZ+G0p3X7k+MhEYCqWo4ZlcrO6fKfzjhol3i5
         HMK/N3owUaeP828P1WDzkJ2eBc+7ziwKadUppzbtE58I915TtJbNvcwbzNeO1C7/MNgp
         VRHOqgtg3JOQeNpEJVjbFxTW+CH8AUGN80bBJqA7w2xGSfWphJ4pWePMH1pspg+zk/BQ
         /KR5ZFcPu21gTWn2rILolhpmt2Kov/KoAQG4o4oJo9GsEdE7mxk3hS3BHKUgd1YmlWlH
         A7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751385026; x=1751989826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NM0m9m6FgXQhqUCQOzdMmZYVj23cYKuGezzGfv9F+qE=;
        b=w5/aI1ocymzsswHQiQcbcIJLy8WwACp5EX+xSvtN8M6Nk3hPYWIxMo4H+xuNt26SKy
         Sm3IG69RJH6+PCvXALBBltjzcn28jZ6ceVRDmRfk+o2MdjMYe1q1rQOpDZEE3u4u5qOH
         OXz8eA6eR//WLCBOP+av62zond7S49vEuXXpGR+jVk2bWakH5FRu1vyfYfClrP2wEJdz
         ugmLyXTS8/xR8zrHiRPph900MzVQDBtAWzPHB07P4nc6CPPkyqpWFUQ+J/SJE2dc+QlV
         VNB5S0/M7HANPlC0aCSo/k8PiPVBmvhl/NtnP7lgCde8S/Fbxcd+CvX2NQDWFDeZ+Yso
         bK1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXUREZm8g3ZFkgcqeb2/Kr1ODnWuySjJEWof+9v4eWJav4cnQEYjgNB7Vuwpx/0dI46EU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqMaiJhfV3IAopVIm6vaH3nVSUFWHcJJzupdB/O80So3GtpKE4
	IGXpbtEkeU2eTuXAeAVkdEsok8f2iKdhnkWl97h5xXK1YlbucWiBAbls2q8cZSEv/8Psiq7eUl1
	KIdfiCqJ/ws1P3ZJtXWduZi3KdaYEjm6HYDdkIF8sRfEUygjb/kR8
X-Gm-Gg: ASbGnctzLK/FOJm66UZtJAHtf2Ai/xmldjHCAP/UAKbzoJ1iT08oCBg1OoG/DfZr6Jv
	9uv84AfoVyvUrr8x37q/oqF/qtfG6Dcoo3+UKC62q6LtUNu1UjDZp5TAvryfYF30J4ZvBhiUfkk
	ihznet9LNojHB136RB7pXTFOwsEDWa2jkH1nnzPJIgo/sL
X-Google-Smtp-Source: AGHT+IGGy1LiWLJoul/YG8YZ7v1W37zVJZeUDsvzCu+RNL4TBiAeiTy/45xc5PzZQdt8W81oQJcvdTJMl4dmlwVX3uo=
X-Received: by 2002:a05:690c:1e:b0:70f:6ec6:62b2 with SMTP id
 00721157ae682-71517150f8emr253657857b3.8.1751385025700; Tue, 01 Jul 2025
 08:50:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-26-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-26-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 16:50:14 +0100
X-Gm-Features: Ac12FXxbbgcWVCUlees7q4LLOO8nBn3R6BKx2RlRYHRfsfQHSIdewGI2EN-Bf0M
Message-ID: <CAFEAcA9MLMJBFk+PQCJT8Bd+6R+vaho9_vXmDCjPU5cp6B7LfQ@mail.gmail.com>
Subject: Re: [PATCH v3 25/26] tests/functional: Add hvf_available() helper
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

On Mon, 23 Jun 2025 at 13:20, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  python/qemu/utils/__init__.py          | 2 +-
>  python/qemu/utils/accel.py             | 8 ++++++++
>  tests/functional/qemu_test/testcase.py | 6 ++++--
>  3 files changed, 13 insertions(+), 3 deletions(-)

This seems to trigger errors in the check-python-minreqs job:
https://gitlab.com/pm215/qemu/-/jobs/10529051338

Log file "stdout" content for test "01-tests/flake8.sh" (FAIL):
qemu/utils/__init__.py:26:1: F401 '.accel.hvf_available' imported but unuse=
d
qemu/utils/accel.py:86:1: E302 expected 2 blank lines, found 1
Log file "stderr" content for test "01-tests/flake8.sh" (FAIL):
Log file "stdout" content for test "04-tests/isort.sh" (FAIL):
ERROR: /builds/pm215/qemu/python/qemu/utils/__init__.py Imports are
incorrectly sorted and/or formatted.

I'll see if I can fix this up locally. (The missing blank line
is easy; I think probably hvf_available needs to be in the
__all__ =3D () list in __init__.py like kvm_available and
tcg_available. Not sure about the incorrectly-sorted warning.)

-- PMM

