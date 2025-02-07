Return-Path: <kvm+bounces-37602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A071A2C7AB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FF4016C93D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 15:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAED323F29E;
	Fri,  7 Feb 2025 15:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BSorZpHu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489F16C687
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738943152; cv=none; b=UMR3oVMf5AXIfQU2RDWSyJaQu0swbFAGKFRwUWPOLqQ2v59yiCb5OWKIe5zOU2qgJhW03Skk5cCBeW75xyj65QNFFK0kVEhyWQWRWC4z+UgQxxLK1lq6sWyoBIW6/u0FbCLc24mVkaQoTtkPN7XIkiTgT8zDNiFtev0UVb69F1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738943152; c=relaxed/simple;
	bh=7TZqOpBGM4qiBP24O4/+Co78y8eE9l7PPFvJdZDCR+8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VH8TjyTvQO0PufoHJbmHpLK8IEWYUR29NPYy96HlU+AZSaV0Z84lhaqJOo6gxL7Qb1ZbWa0NAOGi/YMVuxc4LQcoQ0k55nMn9/VW60JL/b2vevrdeBJiYJxwGiae0Oj3OiYLrAvHr9upk5yII3dZOGEyEE7tmS/bgp2pFf3RpgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BSorZpHu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738943150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aDfq/b9NJB3SnEsKYqDfREsImxMuOj2V1wZz1GVd1jM=;
	b=BSorZpHuMAZSftCJggCs0/F1gLP2Smu0rq+JoWwRkQIrxfr2XmCoKzERi3jA/M8f66cM9J
	hvMw5DrXjxB0l3fd7cgUvXZ/otH2yRlHb+Vd9oFWc2Z8yNiL+iJoj1XhzD3wH5HGlWLGOS
	wAh2eF4CH2cQVksBv0b2qUe6pNH6+fM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-5rOaMYP5PlaRgx-nQe0w9w-1; Fri, 07 Feb 2025 10:45:48 -0500
X-MC-Unique: 5rOaMYP5PlaRgx-nQe0w9w-1
X-Mimecast-MFC-AGG-ID: 5rOaMYP5PlaRgx-nQe0w9w
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38db8a516ddso1060403f8f.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 07:45:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738943147; x=1739547947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDfq/b9NJB3SnEsKYqDfREsImxMuOj2V1wZz1GVd1jM=;
        b=EaGBxrsg28Wykd5TdxMHSNmt3vQflF96erIf+ibfRrVHJftwqqdV2cmuqlpRIANrDT
         rtOhXa9YT+oDycYTr9kYm/EIlGafnnLJwXFAh/TCJo0RmZM9yYO6whhWxsFfO8//IjSe
         e8d7tqfI+pDK/nIMe2kWcZtWWPaGoEqOasJarAYQXuqcaSmw/ckSuFgw476xd8jgBv/c
         9GQ0fkadfUqhY+jAQBb4bVM9+d8IM01zKII+NjjhFWLbBQCiz3Qthyx8IYOTNMkEW/lt
         kUavt53FshZxX2bNHhEWq4R6rRi2Hf2/3daEaYsMdHugOsfwDNrIZOIQq694sBExF1Hi
         I8Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVgVhMesrtz2DON8lvb4CHoCYz6X54cQ3qnb/rENmSsBJXUnbNuSkEbqEWdyQ0FHi03tQM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Om0SA3ihjhRYRYl5YK+LS7dG3IfO8EQWYSCFqauS8OaIS9I+
	7bOaz1up0urk+9RkUs16EQMpS8mK/SQvYa4P7ASOHp0t4G1G3QSrMjtJRn+X6fmLiVcrFvO5+Gc
	MOiHGgaCoz7eNK95Rir4XZnj10rfeGk9ONzXB4Mmt6XzSF6cekA==
X-Gm-Gg: ASbGncukDlZxhOgo7jJgaTCRkYDGLJEIQztcGEWyAAiQGWKtvu0gTgBt5gHIvGVr19d
	mOSLvHokZc88pOMF9aksNBToSpRSU7XrVRFYLsQonFevvfE6kzlqOGUoR5lrhz8jQeoB1ONahUX
	fRVIMvyjAKKpjaStVHx4Jkyah3uDbDrZ085A4P/lGTfNfMup/fGuNKPN/enyo4xvg32nUcUZnWJ
	hoxwi9ZAxbxIIoSTPqLcw5AnSpwD6C1uLvm2rfKTYJhqqo2Ic2riwz4Qv0vQiROrD0kB/eH+Yj0
	yqI2F7vYEqc8MJp0tKN1+cEsTxW30XBqpkq5SgJFE1ZLk7/J6TAU
X-Received: by 2002:a5d:5f94:0:b0:38d:b9c5:7988 with SMTP id ffacd0b85a97d-38dc937324fmr2309349f8f.50.1738943147273;
        Fri, 07 Feb 2025 07:45:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgSOlpazfMjNWp2Qc+p7N5nHYSVTYYn3A3MdIORDwNn8Y6nZFZLyNtakfYKleLqE/vWlMAxw==
X-Received: by 2002:a5d:5f94:0:b0:38d:b9c5:7988 with SMTP id ffacd0b85a97d-38dc937324fmr2309238f8f.50.1738943144359;
        Fri, 07 Feb 2025 07:45:44 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbf6e4a4bsm4477509f8f.92.2025.02.07.07.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 07:45:43 -0800 (PST)
Date: Fri, 7 Feb 2025 16:45:40 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, Yanan
 Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Harsh
 Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org, Zhao Liu
 <zhao1.liu@intel.com>, "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Richard Henderson
 <richard.henderson@linaro.org>
Subject: Re: [RFC PATCH 0/9] accel: Only include qdev-realized vCPUs in
 global &cpus_queue
Message-ID: <20250207164540.0f9ac1d7@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jan 2025 15:21:43 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> Hi,
>=20
> The goal of this series is to expose vCPUs in a stable state
> to the accelerators, in particular the QDev 'REALIZED' step.

I'll take some of your patches (with Richard's feedback fixed),
and respin series focusing mostly on realize part.
(and drop wire/unwire parts, reshuffling cpu code instead)

>=20
> To do so we split the QTAILQ_INSERT/REMOVE calls from
> cpu_list_add() / cpu_list_remove(), by moving them to the
> DeviceClass::[un]wire() handlers, guaranty to be called just
> before a vCPU is exposed to the guest, as "realized".
>=20
> First we have to modify how &first_cpu is used in TCG round
> robin implementation, and ensure we invalidate the TB jmpcache
> with &qemu_cpu_list locked.
>=20
> I'm really out of my comfort zone here, so posting as RFC. At
> least all test suite is passing...
>=20
> I expect these changes to allow CPUState::cpu_index clarifications
> and simplifications, but this will be addressed (and commented) in
> a separate series.
>=20
> Regards,
>=20
> Phil.
>=20
> Philippe Mathieu-Daud=C3=A9 (9):
>   accel/tcg: Simplify use of &first_cpu in rr_cpu_thread_fn()
>   accel/tcg: Invalidate TB jump cache with global vCPU queue locked
>   cpus: Remove cpu from global queue after UNREALIZE completed
>   hw/qdev: Introduce DeviceClass::[un]wire() handlers
>   cpus: Add DeviceClass::[un]wire() stubs
>   cpus: Call hotplug handlers in DeviceWire()
>   cpus: Only expose REALIZED vCPUs to global &cpus_queue
>   accel/kvm: Assert vCPU is created when calling kvm_dirty_ring_reap*()
>   accel/kvm: Remove unreachable assertion in kvm_dirty_ring_reap*()
>=20
>  include/hw/qdev-core.h       |  7 +++++++
>  accel/kvm/kvm-all.c          |  9 ---------
>  accel/tcg/tb-maint.c         |  2 ++
>  accel/tcg/tcg-accel-ops-rr.c | 15 ++++++++-------
>  cpu-common.c                 |  2 --
>  cpu-target.c                 |  7 ++-----
>  hw/core/cpu-common.c         | 18 +++++++++++++++++-
>  hw/core/qdev.c               | 20 +++++++++++++++++++-
>  8 files changed, 55 insertions(+), 25 deletions(-)
>=20


