Return-Path: <kvm+bounces-46347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4ED2AB53C1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 13:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 486E419E3D43
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7747628D8D7;
	Tue, 13 May 2025 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ll7pVrbg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0180023F424
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 11:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747135426; cv=none; b=tksnL3MXNtHIvWDaplpv8BICO0DdLBdcWXzizj5/Hq/g0wzYkWsqDICIplKuOz9lk6CbIzY5jHmInSOHtjtk4akf45V9pb0FFVsawbnRvUWPwNsxRp6Sj+kmbGg9oA80rNg9i4MHUH74AplUod6EH9pvH8ROXHS9t/ZjbPOiNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747135426; c=relaxed/simple;
	bh=UmtbBJRv6Phk1m3lAkSOmJC/eHcblEqbvBE5Y3m3d14=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m5rlXICLoRQhsQZe+ytZhELdwXc2aHOriUiCC+VM0/n2cV1I/viFUR2WJXROkVGgX/UZLi6O9pmn3W8JuSZQEzpEXQgcq0EAlhetmqcF5Rpn/zAYEZ02JKAgqdO1Qfg9QTLDBM6uvn5t6uTTtgLl5GxbWzjVy65mI+tCbSvYjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ll7pVrbg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747135423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrH7sINLTStGfBHqPPfKqploDfxrQD6FVuxl9QrE70E=;
	b=Ll7pVrbgto79NmOe2FFDw+1dJ3wuvDsnayLnSrw2/zopJGA6tOd/WRto2aFWH5Eeg13Lhz
	vCDiAgrhpjrtgv9YbC3aIplQRkDPRu41xmJb84zeHlSyFArme8CPErTAYRyarHmSARWx+k
	YaqVLoefUcY8eJd8lOtGP3LfBSbbSGI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-1WvmCKAoOxiu0vORCOXmGg-1; Tue, 13 May 2025 07:23:42 -0400
X-MC-Unique: 1WvmCKAoOxiu0vORCOXmGg-1
X-Mimecast-MFC-AGG-ID: 1WvmCKAoOxiu0vORCOXmGg_1747135421
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d4d15058dso39686795e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 04:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747135421; x=1747740221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XrH7sINLTStGfBHqPPfKqploDfxrQD6FVuxl9QrE70E=;
        b=XNQmzAEgkcGIlBx0Pgcahe8CfoA9ok5x1ULHxgxdDraoZKdwS+ENPs/R4ETnTC8ETG
         RtbhWnAKJk9/PlMM46iTourHbVBvVugPXtBi91tkxmVoFFlpNuY8QXktP63vGcQBSBjo
         sFA0P/QbaXQXfmJ8b/cwIXtHgb5HgXDnpBxKHb4yPqqQBoIjAPknfEk8DnFxxkNaU7rO
         /6FKlim4zz55L+iZxVr5YsGnYi2n3jjYIOHTQUKJcnb5Xqlz5ilUmR58a3/eCbJI4x8u
         6WLQAKBjdnvuAcDxeAPS4FXTx3wC8RPIMqCQUB7WSeBL/xg2JG1KcJbslvM6JSn80Vup
         Ee6A==
X-Forwarded-Encrypted: i=1; AJvYcCXM3W9aElyPi1fhkL/VWnV2ypVrO/YeNyD/jYWs6mnEG9ARdTFO2C9aEowLSLrDYKmm4/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeetS0x3Jj/MPFTGWri4zF5rh298pWnhaJJc0flEhscSsjN0PX
	zzBOAu3vb9Fka5MBhHKWl4Py3rOS4TZ/dEEe9vn95nka+QOtDe8qJgIPx96ei+A+NM+SRAxRBHo
	MEqSqWpgm6479uo9t1v8hp7X4r1SdxD2GQ/tB4Fn49JGHyq9mVQ==
X-Gm-Gg: ASbGncvNxA5mN3WnGvzolhStK71BZKK4NgQjvmwsI5GMm+SqmbSzkdG0xgAT8NEfxeb
	hAnNzLtz/wVXgAdjYWPzSTfoiF/iQTJoImiqbM8st93OKU6d3FUoHtGDZDn3qhZ6RwY1ttw7VGq
	uueOKw53V8coJjbIQqc3jgTUVJ9MoQJhVbCn28zHEPVJNX/ScrKcKbav2kYTqw64cTR/5Iq/vP8
	HnebIhimy2BIIWW5oddltGWsx45OyYQ6T6kpW7M+d62SKhu82LtMFmpvpnCTQLIvzOBNlRTOm26
	rCSMU13ypDwGfxTVGZHjYVvXc1tqdhyi
X-Received: by 2002:a05:600c:1e18:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-442dc95a564mr126025885e9.15.1747135421378;
        Tue, 13 May 2025 04:23:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiMGzpOP7kEMnYGvVM8p+Koxg205GYZRanapDy3HAulIVBobUs+iamSuLianwcYnNelki2hg==
X-Received: by 2002:a05:600c:1e18:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-442dc95a564mr126025345e9.15.1747135420906;
        Tue, 13 May 2025 04:23:40 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3af15bsm208511805e9.30.2025.05.13.04.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 04:23:40 -0700 (PDT)
Date: Tue, 13 May 2025 13:23:38 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Zhao Liu
 <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Jason
 Wang <jasowang@redhat.com>, devel@lists.libvirt.org
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <20250513132338.4089736b@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:23 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> Since v3:
> - Addressed Thomas and Zhao review comments
> - Rename fw_cfg_init_mem_[no]dma() helpers
> - Remove unused CPU properties
> - Remove {multi,linux}boot.bin
> - Added R-b tags
>=20
> Since v2:
> - Addressed Mark review comments and added his R-b tags
>=20
> The versioned 'pc' and 'q35' machines up to 2.12 been marked
> as deprecated two releases ago, and are older than 6 years,
> so according to our support policy we can remove them.
>=20
> This series only includes the 2.6 and 2.7 machines removal,
> as it is a big enough number of LoC removed. Rest will
> follow.

CCing libvirt folks

series removes some properties that has been used as compat
knobs with 2.6/2.7 machine types that are being removed.

However libvirt might still use them,
please check if being removed properties are safe to remove
as is | should be deprecated 1st | should be left alone
from an immediate user perspective.

>=20
> Based-on: <20250506143905.4961-1-philmd@linaro.org>
>=20
[...]


