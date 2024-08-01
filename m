Return-Path: <kvm+bounces-22951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDEDB944EEE
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B2D31C227FF
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA8213C66A;
	Thu,  1 Aug 2024 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RH6HkT77"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923F1E868
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525458; cv=none; b=uyhPLqzCWr3/1pfuAJ8CKPMbaOkeYnILwYY23Z4u4C7RZb8rAU1KFApBevrul+mJ5eVLrn7NaI7NKr3i1x0Z+ozSe63vJbi1FJh4x1M2qgXRxBnzcxjbcGvhHBCCYTf2OY0c72onbCcGZjdE3zYtPdsgGBWJaMoc8g1oqQtqTh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525458; c=relaxed/simple;
	bh=nrMq7Tnk4enAfV1fv/oDNnUGVM/ae4QfddmoMEjU6MU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uYA2TtObFUHCnxOWMazkOFxCi6yEiYOkRhLB94/GG0Q+XQiCbv2QR3WDy5G2afeqK02qrILUk1R1IOZKsM/HErUzhqvARoWTTDBomNTNmKPqRsEDUim/Yu22/oU+HDZHwcYZYYqlRTjVmy+f8SmebJdC3hR+zPRgmC4sqdplRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RH6HkT77; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722525455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=saWSM0dvG6oMWmS/XHDtmdkUhGSwyi8ohATfugSLLzE=;
	b=RH6HkT77DjJQa+wU0FPgk2e3ymnKCxw+Zg8OheyCaNgrcpfTk/eLJNUV8xHTnazJn4SbIl
	Jd8bb0BkhAz7OZdKtcb2Iw9ykk8yq3i7Sq+RwuucAXdp5QHg3S4/bh8OQR8g5XVJ6w9JoE
	jRBjcQLIiqK/oViWi0mx6d6UU3hKHlc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-9aubfyqxNUW-XiEEVuvd1A-1; Thu, 01 Aug 2024 11:17:34 -0400
X-MC-Unique: 9aubfyqxNUW-XiEEVuvd1A-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-64b70c4a269so132294297b3.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 08:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722525453; x=1723130253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saWSM0dvG6oMWmS/XHDtmdkUhGSwyi8ohATfugSLLzE=;
        b=o7oidQUfwcYSlWoBBkPs6qI6PNXODesYEXYu44WQAJCMm4YUBLLOQFgrhVU3ThrYra
         L1R/9+ZUthA2NLliAQu339rVFLzV3O9X/khsXQNXYCTiBb+TK2+nuS/iHMIgHvd/nXqV
         sunhSYh/W1ecwR7etJS/aKoQrtTZwnyupVDRXBPbPfo1bkEBjnIaCgVoCn+/XTHjR3sI
         jxv2FANLVEw3G7KrM93C6hTKUJuGTNwW+ejRzLgeNHQ0tq2FsHCJGozzVOr/cG9cRW4n
         d8kDIrjxv2icIcTTzrqU/9Qx4zv2a687EfPqonRbBAE4bfw+d4Qwk1xnJ39X5XjoKkzU
         26dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrJIWI/YexrksS84QDy53sev8RUazeo+HdkPkwKJSsovvfnN4nlG0C0xjfN56Ay8FhXYRAboII/whR5xhg4xc+8lAg
X-Gm-Message-State: AOJu0Yy9a6G97ygAPX0B2UTzvMR5JcUvbrh7KEtkkK+VsllC7/H6Eysk
	8WDy43kXR6HKxcezBQODtQreAovjsPORP7NQZeHX4ZibuYxD8VOFWPaxXu4jg+hVN6EFIKBZJpa
	R9Ao7FWyWuIiTqq+LQaR3wjlFb9P3udbJ71+MLBdQ9bV2mlM6C1P+q01F4PqRJNTH+RQs8Mf2zA
	GXr6awlO9c7n2aWWnBYHhAtdCq
X-Received: by 2002:a81:8a02:0:b0:627:88fc:61c5 with SMTP id 00721157ae682-689608712bemr3552187b3.14.1722525453628;
        Thu, 01 Aug 2024 08:17:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWb+pXe3srA1h/GWNLFlIOcL3RzIFjT+pBFwxzuvCICQfwHyygo1bFQwtpDjywD7rhu5d6eWz1qCxx5yiYRSM=
X-Received: by 2002:a81:8a02:0:b0:627:88fc:61c5 with SMTP id
 00721157ae682-689608712bemr3551957b3.14.1722525453261; Thu, 01 Aug 2024
 08:17:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208190911.102879-1-crosa@redhat.com> <20231208190911.102879-7-crosa@redhat.com>
 <20efca0c-982c-4962-8e0c-ea4959557a5e@linaro.org> <CA+bd_6K5S9yrD6hsBsTmW4+eJpPsquE8Ud9eHZzptUwDrHcpeQ@mail.gmail.com>
 <a3b0ebf6-47ca-4aad-9489-16458ffd6ff3@linaro.org>
In-Reply-To: <a3b0ebf6-47ca-4aad-9489-16458ffd6ff3@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Thu, 1 Aug 2024 11:17:21 -0400
Message-ID: <CA+bd_6LmuOdQ8ZdLjwt+MCusjQ8ROv23d9PXoF-Ku3j4j73wsg@mail.gmail.com>
Subject: Re: [PATCH 06/10] tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Leif Lindholm <quic_llindhol@quicinc.com>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, 
	qemu-arm@nongnu.org, Beraldo Leal <bleal@redhat.com>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@est.tech>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 8:57=E2=80=AFAM Philippe Mathieu-Daud=C3=A9 <philmd@=
linaro.org> wrote:
> > I agree those files should not be modified, but I wonder if you
> > thought about any solution to this? Given that the same user writes
> > (downloads) those files, do you think setting file permissions between
> > the download and the use of the files should be done?
>
> We want to share a cachedir on development hosts with multiple
> developers. OK to alter a downloaded file before adding it to
> the cache; but then once a file is added/hashed it shouldn't be
> modified IMO.
>

I was asking more in terms of what to do before/after the test.  When
it comes to this type of setup, Avocado's cache was designed to
support this use case.  You can provide multiple cache dirs in the
configuration, and some (the first ones, ideally) can be RO (life NFS
mounts).

But this is hardly something that can be configured without proper
user input, so this is not present in the generic "make
check-avocado".

> So far this directory is group=3DRW but we like the ability to track
> a read-only directory (like owned by a particular user) and adding
> missing assets to current user cachedir, to avoid duplication of
> files and waste of network transfer.
>

That can be done in avocado.conf, something like:

[datadir.paths]
cache_dirs =3D ['/path/that/is/ro/because/owned/by/someone/else',
'/home/cleber/avocado/data/cache']

The asset library will take care of trying to find assets in the RO
directories, while writing to the RW ones.

Hope this helps,
- Cleber.


