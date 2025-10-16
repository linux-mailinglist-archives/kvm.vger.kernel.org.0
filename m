Return-Path: <kvm+bounces-60141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D5BBE47D2
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59A5A18887BE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CEC32D0EF;
	Thu, 16 Oct 2025 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQS3XcEu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FE932D0C2
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760631206; cv=none; b=Cj/Ez2AAHh5tEWznbD+BfaMarTFSXEHk4XA2BaQLJEd4D83WezEobYdbvATeiQOQ1pQ/MfjyBmG4SblKMbRjRa1SC1CpYWSxHO4nt0pIei109DZ5mtIVraJAaz8WnywbkavQZRKLgtMebQ46y6DAkUqdS78wkxVJ1t5+K5+F0Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760631206; c=relaxed/simple;
	bh=VGte+oZcxm4Ft5T8f9NWmjymAE/iWHrS/ZWMCT7oMjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PKCVfyHRZ17R79/TJ41PCLaXr1oSHccrDBk6WIvNULd9Wa76WTJ9WouG2LkJhlKbUXXo8GXoz5uxcrd3UeAbLsjC8qMo9Vq5E+zLnv+DLaNYtYJl9mpzOzYE0YeXzseQyiKQb6bhc5XlLmSjqbnzqYcPVlKKQBSdhrhebvb7iH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQS3XcEu; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5818de29d15so1178504e87.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760631202; x=1761236002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGte+oZcxm4Ft5T8f9NWmjymAE/iWHrS/ZWMCT7oMjc=;
        b=JQS3XcEuFIfuOOsOdm7Q+Q3Sa7TSSEHg4QB981Kei5TEXzf4GXNL4ny8OzRmP5tB4d
         6y/WutZ4W8j+lLTV4xHSBSQnxIbbQXzOs8kFi16xlf84cEkIiFobssEKt8sq9LomaY/c
         147olb/Nm+5ej0s+9f4k+WlNkSWoMCiOoiC3de48sXDdBExeAVWzCKFNHZzLZsjqaty9
         x9USpG39MUFAJWnkLS270djIolqY8WP2LK0ub1VFzpnvGqXEMC4eGSAtpcoChHrZrfVY
         aaOb8zoTpU7MMgM1ci97ltdWZgYHrT6k+wmEuNTqa3ulKlarzAutL81gsn+AQ/Qx8cEo
         /A4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760631202; x=1761236002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGte+oZcxm4Ft5T8f9NWmjymAE/iWHrS/ZWMCT7oMjc=;
        b=IwAFE9Dl5wtMgwuhBY+WZzbSKqp2fWpmoFXS6OK497jwpEpTRSlN3pEXQ3JHi5HAjB
         qiIvP78DF0VcwzA/IkHYhbUBDBlQBTY3JDSEBRDS9RN1pQWSez+Jrl460P1/KinlSGaH
         qylwkhgTdNDxbEbKoWSst/QsQ+tQNOngXrjwRSk6FJvqGiai+kgKXn40/THsBzMJf8dw
         eozFmROrrBjGcvtClfHiIXhNeE7fSLQxzDamV0W2GYmz4HR1yWxkSn0XJ22NMDzfynIr
         6I6ghPx/founkSt6vpY3aWX3tmjgDy8in6QMdV6vHioGkuieIj+UODYLKxsR0vHIuUw0
         YL7w==
X-Forwarded-Encrypted: i=1; AJvYcCWz2MvHKdB8E8SjvmPW8w5lUlEwUrJt0Q5ZuNsVBUFAQFUKt0GcvWPuFkTIBAIlEWqKg54=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB5hf08XbuUQcsT2REfQ8fZCT6gl69LScpbRJe4X0IkqQ+XPrP
	DhWaUwj4GE1YwC3PhNaDXvVzwcWobs6LRfgi2QXsh+zjz4F1w33uIuHHyKWqmjDiMJy3Bf/8s89
	1w1fYeOzJnQ/ZkxsaTY8nw3VAPop0Qw1xKePQrT77
X-Gm-Gg: ASbGncvvz/N9FYu3uW4Xk46AweD4e+H9N2q/7qfv+42SaioFR76yhAH2lLM7k1jF+wi
	paMDuXxRTwhy7X/e7IqW8jRZDefXEb+VTuDNRakory/5u6UV/EkxpjvJw24ALOaW2iPSPRxFVSb
	obktUABngAQ5QtjESM7p/cxgAnMJxcO9KLwXTVEwzCo2AUbwlUeGAjdQsgDEa53rBTtLygjuGNm
	BVGbI31XY/bDSU7NrBETPs2eVIWLPqJV2BGWCnNHJ8CI+057ZFmnBlvWt79PN1txJ2wgSy3SB8O
	zZPByis=
X-Google-Smtp-Source: AGHT+IF0Fj0+Y/SrJCb/WtrFZPuoyjn4f/OpW/ZCQOooqAZ0e+FMbyeh7/Nj+3fU5/+rdVN96wRWZGQQsmqnY5Y1Bkg=
X-Received: by 2002:a05:6512:3d8f:b0:587:68fc:c4f with SMTP id
 2adb3069b0e04-591d85aff32mr218847e87.53.1760631202245; Thu, 16 Oct 2025
 09:13:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com> <20251008232531.1152035-13-dmatlack@google.com>
In-Reply-To: <20251008232531.1152035-13-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 16 Oct 2025 09:12:54 -0700
X-Gm-Features: AS18NWBuFnhDQBSJkMHnBtdaGfEuWjdsHGK0TPEYbopq6OWht-AaDyryXx-r63c
Message-ID: <CALzav=eJbMtRS-7y8UqQgJ3mSKSoAYOPVqH4R5rmH3Nphu_9eQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] vfio: selftests: Add vfio_pci_device_init_perf_test
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 8, 2025 at 4:26=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> This test serves as manual regression test for the performance
> improvement of commit e908f58b6beb ("vfio/pci: Separate SR-IOV VF
> dev_set").
>
> This test does not make any assertions about performance, since any such
> assertion is likely to be flaky due to system differences and random
> noise. However this test can be fed into automation to detect
> regressions, and can be used by developers in the future to measure
> performance optimizations.

Perhaps this test can compare the time it takes to initialize a single
device against the time it takes to initialize all devices provided to
the test, and assert that they are within some range of each other. In
other words, assert that initializing N devices does not scale with
the number of devices. To avoid false negatives, the test can collect
each measurement N times and discard the outliers (e.g. only look at
the median or min time).

