Return-Path: <kvm+bounces-38205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDFAA3691A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 198AC16A21B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 23:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7201FCFE6;
	Fri, 14 Feb 2025 23:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="arupsSGx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFF41C8628
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 23:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739576146; cv=none; b=E+dAgJSUMU1puWsAt/ve2r636Xu5p6oVopo+n3eZhce1sa+XfnY5kuUn05Kxd5kkMHz0L05cif0KRv8B2fQhYVSwaPe3RFj9Qz9ZdJ3JHLGX2cOA/fkB9/oA7gGtB3K8MkuAXQ0LsAl5D2vQfgFzM6r3pJc1EOgt7X9724rDVKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739576146; c=relaxed/simple;
	bh=h1p8m3cbA4dXXHkyCCV7Dsuyby91lpU0uZs5UgVRQrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CcSRy/sQoQ3KXGqksGzSYFUFO7x62qPw2QwE9/PhIWerOjcGrMZ8ykZob3CTr9hE4cVhzrNu5gp5IAGC2hUgIsqExT06iYmLZy0GGdLpBHXQ/aHo3Gwj1EbRJqyCyreZyzPep1XNDincyDujxUebFQ3vEX5JDzQI3R6JJDK445g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=arupsSGx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739576143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3QaL47zgHLdcs5EkgRrAkLY9U+KKlkChilDN7QnXbQ=;
	b=arupsSGxIsN39X2NPbGZ3b/DVoGNDtKzjVJXxkj9QZkc3wgCiUQh4KpVP7hgqJ/XbPdsIU
	NsAbfHZl8GeucG3S8UkL2Qwq1y51J6Aw9yBRascsRDpNobVne3E/6yU4oqO/24gp4nZp6M
	99WxlLBVSrq4z/8Vwxj3IYH96wN1/PU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-tU82Q6X1MRC66OOJVms4-g-1; Fri, 14 Feb 2025 18:35:42 -0500
X-MC-Unique: tU82Q6X1MRC66OOJVms4-g-1
X-Mimecast-MFC-AGG-ID: tU82Q6X1MRC66OOJVms4-g_1739576141
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dd533dad0so2245322f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 15:35:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739576141; x=1740180941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3QaL47zgHLdcs5EkgRrAkLY9U+KKlkChilDN7QnXbQ=;
        b=t+S7GgBhRpYXAt5tN/F1vcZgOctt0B2oADPYTKldgW37Mb/yOKgthdBbaTVKHenRfS
         u108mQMmQMhgPb9oKb3U6DJ30mR/eKIMOmk9tZZFtgfE6MzWgbtuU92rM7hwC/W9lSBg
         sVrltg8de+2OuHvQmhvDDV7xUV8hzZzLFZ34TXVNHWrdffT7d1ZGOzOZDLG8409QMNiS
         LEY/vSrXw1t+PKlDi2UsMICi2JK8iQCVfI0gXg4hDKmC3gSAP5HsGl13bbBBvDak7zqi
         8h+x4rk5haSphmV5axpsm3leKjLX49ewp8E00yQK1yBnl/XQDQm2sQVOt6yLyPbemxFS
         XolQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9gBADjlIyj4I7m5+R82qXVp7dYj9Z4UNFwL2eWjwa4Dyv9ZAMdVHEsEIHIXQzV5AbvYM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSTAQAnXxeu96hc16xMr/ru/hh3DCTt0r8TPdOTJQQAeM0D6I3
	rNjv4DEKN3hV1FRV51q8j5SreMUPkXjmeI4qtEJ/YXK9bX047fTqduvNNH1YkSnOA9dhtl/G1IS
	RPkv3rFpyKZ0vhz870B279+yLiALoIZKpPVyGGn6FIHWHh3U5Uildl+lGBIwQGaArh+orGKGFgZ
	LAwBOSBhRmmth8d+ghWhTMvj9a
X-Gm-Gg: ASbGncsKd2AUQvrDk6UM1Q7kU5hCxlUIySIUAh0DBIkA7tYqDUG5W9Dp8+xZ5xt4C9n
	Mo6ijttFAZcgzXJIOQIY79YME/fIg8O4bggRPiJb9h9VYHdaM1Mkc0/ZBpx2XTSRE
X-Received: by 2002:a5d:5f4d:0:b0:38d:de92:adab with SMTP id ffacd0b85a97d-38f33f34cc8mr1062568f8f.29.1739576140901;
        Fri, 14 Feb 2025 15:35:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRPUHm4YOOqYgdpQa1/Abpu1FH+JFzeebiyjLQPAuWs6N1wd0ZHNkh1THgVdQ28g3L0vPQ1rQihV3c/JaDpbc=
X-Received: by 2002:a5d:5f4d:0:b0:38d:de92:adab with SMTP id
 ffacd0b85a97d-38f33f34cc8mr1062544f8f.29.1739576140537; Fri, 14 Feb 2025
 15:35:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214115608.2986061-1-maz@kernel.org>
In-Reply-To: <20250214115608.2986061-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 15 Feb 2025 00:35:28 +0100
X-Gm-Features: AWEUYZmbJK9XoDAa1oF2aoN2h1YAezNxqJci3v-I9zFt7JUER3UJjYZD2898x9w
Message-ID: <CABgObfb4sLa70-_1_+XQ87Uy8Jo7GXc=ta2FaoM1K-q4YOE9Dw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Simner <ben.simner@cl.cam.ac.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
	Fuad Tabba <tabba@google.com>, Jeremy Linton <jeremy.linton@arm.com>, 
	kernel test robot <lkp@intel.com>, Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>, 
	Wilco Dijkstra <wilco.dijkstra@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 12:56=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the second batch of KVM/arm64 fixes for 6.14.
>
> The most noticeable item here is a rather large rework of our
> FP/SIMD/SVE/SME handling, mostly removing a bunch of fairly pointless
> and not-quite-thought-out optimisations. This fixes a bunch of
> failures reported in the wild, and makes the code far more
> maintainable. Thanks to Mark Rutland for doing all the hard work.
>
> The rest is mostly a bunch of fixes cleanups after the merge window
> (timers, vgic, pKVM...).
>
> Please pull,

>
> The following changes since commit 0e459810285503fb354537e84049e212c5917c=
33:
>
>   KVM: arm64: timer: Don't adjust the EL2 virtual timer offset (2025-02-0=
4 15:10:38 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-2
>
> for you to fetch changes up to b3aa9283c0c505b5cfd25f7d6cfd720de2adc807:
>
>   KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to kvm_create_vg=
ic() (2025-02-13 18:03:54 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #2
>
> - Large set of fixes for vector handling, specially in the interactions
>   between host and guest state. This fixes a number of bugs affecting
>   actual deployments, and greatly simplifies the FP/SIMD/SVE handling.
>   Thanks to Mark Rutland for dealing with this thankless task.
>
> - Fix an ugly race between vcpu and vgic creation/init, resulting in
>   unexpected behaviours.
>
> - Fix use of kernel VAs at EL2 when emulating timers with nVHE.
>
> - Small set of pKVM improvements and cleanups.

Done, thanks,

Paolo


