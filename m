Return-Path: <kvm+bounces-22830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0383E9441E1
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791CC28302D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A0345000;
	Thu,  1 Aug 2024 03:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8P7oVqy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE9E1EB493
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 03:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722483044; cv=none; b=qxtRCU7466VouSmoIVuRFhyZ5B4aBZ7Ze6BopP+m/+u/ovyiButSQOw8w/1hyot/A/xB0fxsxjXzEX3gWmBWwohxYVWqVlfQFJEP0KAEINNZpFVH1FdX4Xqj1SbtWxBrI/rhNVdYjxaRm/zP2HbfguhJgS+GTg+Jd9VrY0wwfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722483044; c=relaxed/simple;
	bh=j2hvfakGZt89Mx72W/OGNDIUPJ0O8ubJKdG+0Lkaark=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UobPIXgkLKdKZMhpJqwSKM0BC6zTQqruwgrcO/omiFNaKBv37XPoW7R6S3/EwWk3dzzUowX9zdJpxPjRnNyCb6YNHznJ7Z3X6mN727jlw+TLS1+Pk0isomiuYKNjsKv0khlmaduYLcd1seUrRgeZbN8zq5pbpglbbP3rpES1RxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q8P7oVqy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722483041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yRnIoxhtmS04LUR5Fr2AhObq2Vi0UowFWVOhiKEXTVQ=;
	b=Q8P7oVqy3q1j3v/9p4t/aJs/+RB2SbRoCXyMu0xun/y+Zbw33ScJVvd+Kqvn+lYkuUnuSb
	KGPWZghXGO23bFrioiDO+PpIr7cFoQLrnpU701Js7hh+lRjY7m5/imJtRWxXfWiRwDZFkr
	ZyXoPVoFmoF/nOCMhBJOOG4M7ec9470=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-72DL-kbCNZi-Q0QxidhQGw-1; Wed, 31 Jul 2024 23:30:39 -0400
X-MC-Unique: 72DL-kbCNZi-Q0QxidhQGw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-666010fb35cso28464387b3.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 20:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722483038; x=1723087838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRnIoxhtmS04LUR5Fr2AhObq2Vi0UowFWVOhiKEXTVQ=;
        b=sFCXVZHyMCNfpvBNhBQoeyJ/+vFIs9VrpQvJ2N36SvPbM8Ps7J7DrEa4AwPM76zllo
         p9XWEzvOJGhzi8tCzoOjVeYfRtgCydh/6xYPqJHYVSEVumbNmX8ey/CoT5WAvrbjm85d
         y0tlbdCLHma1LRvJ3rWsZqfQX5QejZnFt7/qNDiBQM7zd3vwszg6jc/HV93UYLs2UIfd
         pF2rPfNgpLUlHGR6uwviCf4VhUD5/wbH0rDiQ0ApO70n6lDCDDICVjgzqDVvsel+yKxB
         LWt/JQuMqhjnE2LT4sgBXmLUQCzfmYS7wxoG4jZ4rNWx46ikTG7bZgAjTQKTGdbq82nr
         LDOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSEVFi+PLHwKquisR50GryFNB65CBwtA2Q5vg2nV3yejGzqrSsYTunTpTPs7jP23GFWYMPn3iUAoizSTjRhaiJ/9/t
X-Gm-Message-State: AOJu0YxHsZUzX66+PhtQyRvIw2a7kwUcVDA0r70OdfRPY5zGkg8ol0d8
	5Fpn3RmqKNvIe2AnSwmzRdw7vYAc2eSYqa/RuBHcYx7Gb8KrwxIfioVY9A7hjU+7bqsAeFq5cxL
	W86j3Ry7pEV4VAXi2X51gezGGzgyXZYyB5zvDI1BNTHiVExn+97i6dcyAKVnqfjB85hS/VMoVhp
	tz+0qS0X/SRVcqzjy5VVB7iAn9
X-Received: by 2002:a0d:e944:0:b0:640:aec2:101c with SMTP id 00721157ae682-68741ef40fdmr8391987b3.2.1722483038630;
        Wed, 31 Jul 2024 20:30:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEc+0R+0iZI0YY0geNnyOpj9rwwTrXQrSh9z23VQ/Gn0T+AatmnUkFA7gwngv+CD5YcR7Jqfteif4Li0UMq2M=
X-Received: by 2002:a0d:e944:0:b0:640:aec2:101c with SMTP id
 00721157ae682-68741ef40fdmr8391817b3.2.1722483038348; Wed, 31 Jul 2024
 20:30:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208190911.102879-1-crosa@redhat.com> <20231208190911.102879-7-crosa@redhat.com>
 <20efca0c-982c-4962-8e0c-ea4959557a5e@linaro.org>
In-Reply-To: <20efca0c-982c-4962-8e0c-ea4959557a5e@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 31 Jul 2024 23:30:27 -0400
Message-ID: <CA+bd_6K5S9yrD6hsBsTmW4+eJpPsquE8Ud9eHZzptUwDrHcpeQ@mail.gmail.com>
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

On Mon, Dec 11, 2023 at 11:32=E2=80=AFAM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 8/12/23 20:09, Cleber Rosa wrote:
> > Some of these tests actually require the root filesystem image,
> > obtained through Avocado's asset feature and kept in a common cache
> > location, to be writable.
> >
> > This makes a distinction between the tests that actually have this
> > requirement and those who don't.  The goal is to be as safe as
> > possible, avoiding causing cache misses (because the assets get
> > modified and thus need to be dowloaded again) while avoid copying the
> > root filesystem backing file whenever possible.
>
> Having cache assets modified is a design issue. We should assume
> the cache directory as read-only.
>

I agree those files should not be modified, but I wonder if you
thought about any solution to this? Given that the same user writes
(downloads) those files, do you think setting file permissions between
the download and the use of the files should be done?

That can make the management of the cache (such as pruning it) either
require undoing the restriction or being done by a super user.

Anyway, just curious.

Regards,
- Cleber.


