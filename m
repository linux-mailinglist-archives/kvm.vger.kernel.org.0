Return-Path: <kvm+bounces-55924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 658C1B389EA
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C26997A944B
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCE22E2DF1;
	Wed, 27 Aug 2025 18:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VTW2AhUM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25502E283B
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320944; cv=none; b=I6sC60IzdDLmc4lPkUHES42lpctqOXcaiM7OP5IOkikqE3GwSw1pMSVk34uqjyDnp4QsmRwv/OaH3tPeUyN6oC/jvv1Qhc++KD7fpBU0i0WpINzSquynh7jSHYHmQg4/HwXpgHuHs5rcewuMe0byz4mU1BDjyfEMdsv5jsPXQ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320944; c=relaxed/simple;
	bh=tQA9/Ach0BZRCqEuu6uOpIqPBwzD/W6GlLUH0sTqYxY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DWrXsDaoX+zqvs9Jgy2lbEuwLVc5qwWNje9vNOzJ0FTkkMqc57OXt1NY717RlUzFgQpeJTA1PmcALRfIie+mVe07sGKxutq+k0M+2e+uVHmFFg0AzB0YmSsKkCH00S4rTUK81/whEjuqrCaY6TCsrg++YT9E7JO3oDDIys4DzPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VTW2AhUM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756320941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2HjWNr8OnKkSSzWz+TsTIEe/Fd8VZeWw89vd0AMdn6Q=;
	b=VTW2AhUMPdbdNVBd5JPTu3Lnz/2reVgOr8EER8ZTWMRI5IceMdCKZzdnuWluqom7sdntUl
	0O9DisR7U2tHP5kewYv8jv3nRU6tEQjUtC/NZkcjJ4HG2E4gThTz1n4VWammywp1zkW0kX
	RK2NVsNu8pZJD/CE+4Ffr2VA2d94GHw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-RrSXPnGVOlab3mSxBOHxtA-1; Wed, 27 Aug 2025 14:55:40 -0400
X-MC-Unique: RrSXPnGVOlab3mSxBOHxtA-1
X-Mimecast-MFC-AGG-ID: RrSXPnGVOlab3mSxBOHxtA_1756320938
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3f08c081ba7so414735ab.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320938; x=1756925738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2HjWNr8OnKkSSzWz+TsTIEe/Fd8VZeWw89vd0AMdn6Q=;
        b=sxroZEewRhalVRt0mX0xgVHY1LivshZk1mB7ZeuR2kdUjjJ48nYmetCQW94yI7QxbP
         pTCDfW3m9caddPu2utgCBoRqPLoAvvX8gqH0+Cc4ePi4yYDpeIvCwPyeeHFrbK2uPYhj
         FKxI5tlx1xM4jHPLkqL0PMQzJLcZwaXCX02/Jchzy4uFDLWhDnc1zTDBWnQcVtsH1A7X
         9HVJKFMMGHBs48qiGx8PJUMmZhzlH9HaDmzAehgAG9f5WYl9X5lVyIrG2CGyytfmu3hz
         AwDd9YigsBdWpdU3bz2MN8b5d8ZAhmqGPvkMnRoEwZ11l41M12ORxdb0U43foNnRuyCo
         iY2w==
X-Forwarded-Encrypted: i=1; AJvYcCUMsDRWaenENvZsaFiYD2fHVMHOAHXsof4F58JCRbqzMYs9IZFY5XWbAM/Gxo/8KZTzuec=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN+6eAmsBpDLMCabtNcEt5ZzFOlMuYr4K7PScGaDwJ0dVAO/Ni
	mEeLN54epPwx/5P/dNZAL99WlVSH9LX0SMCyM3uIYmXimaBfJVWXZOBCgc59FIMz4GyrD1ANG4o
	xq9LVbBVC6pmtXgt8AZDXzjT4ATn0Og+Lg+DAaJHsjFRnHXdiPpOpSA==
X-Gm-Gg: ASbGnctkWIvgkx28bgo52HGSY7Pnipz4YSdJ5ftr1ria7HeKlE7hXEvoXi2fP4/CCQy
	MLXdddKYylrHD4tEzamhBB0X4bd9/jkCnbtaaEh/eh7VFEpzmtoPB/x5Hm3jiQ/wUHvHmNzahXz
	W5wZ0juCSS2uXxoxFQbdQoIm+k4NLsHCd1m1rDekqNtfl0nsuSSSrMoVCXLBwbKn+KUYuzyXFt/
	cdM2EvF5bjZ4sKIlwzIy3LdvhbUg7qdNamAGrKaKm65BtFwAuqjHuzS5grBa9jRuT+/g+x1qhzK
	Kbl0DQf4bgzjxjmkswQspKbyMZqdkwyQZXvXMFTl+BQ=
X-Received: by 2002:a05:6602:1649:b0:87c:ad2:cf44 with SMTP id ca18e2360f4ac-886bcfc9cfemr1107603939f.0.1756320938328;
        Wed, 27 Aug 2025 11:55:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGetQJuhhaIdZfy3mNvP8MjC+gfptY8oPY0KXYHB4yZ91tShcG4h8WoDVsCHp6QjTOyzjdXsg==
X-Received: by 2002:a05:6602:1649:b0:87c:ad2:cf44 with SMTP id ca18e2360f4ac-886bcfc9cfemr1107601439f.0.1756320937888;
        Wed, 27 Aug 2025 11:55:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8ef4c42sm874836039f.4.2025.08.27.11.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:55:37 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:55:33 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, Adhemerval Zanella
 <adhemerval.zanella@linaro.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Dan
 Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 dmaengine@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Joel Granados
 <joel.granados@kernel.org>, Josh Hilke <jrhilke@google.com>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma
 <vipinsh@google.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: Re: [PATCH v2 00/30] vfio: Introduce selftests for VFIO
Message-ID: <20250827125533.2fdffc7c.alex.williamson@redhat.com>
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Aug 2025 21:24:47 +0000
David Matlack <dmatlack@google.com> wrote:

> This series introduces VFIO selftests, located in
> tools/testing/selftests/vfio/.
> 
> VFIO selftests aim to enable kernel developers to write and run tests
> that take the form of userspace programs that interact with VFIO and
> IOMMUFD uAPIs. VFIO selftests can be used to write functional tests for
> new features, regression tests for bugs, and performance tests for
> optimizations.
> 
> These tests are designed to interact with real PCI devices, i.e. they do
> not rely on mocking out or faking any behavior in the kernel. This
> allows the tests to exercise not only VFIO but also IOMMUFD, the IOMMU
> driver, interrupt remapping, IRQ handling, etc.
> 
> For more background on the motivation and design of this series, please
> see the RFC:
> 
>   https://lore.kernel.org/kvm/20250523233018.1702151-1-dmatlack@google.com/
> 
> This series can also be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/vfio/selftests/v2

Applied to vfio next branch for v6.18.  I've got a system with
compatible ioatdma hardware, so I'll start incorporating this into my
regular testing and hopefully convert some unit tests as well.  Thanks,

Alex


