Return-Path: <kvm+bounces-67270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 70EE4D00029
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1456A3003B3F
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F28338598;
	Wed,  7 Jan 2026 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bZ3SgUoI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA75337BA6
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817696; cv=none; b=MinPZlNCTuWqj9cGmElFniajGfCWvQJ0AmkG2/+r69iENHP0knsWQKBMPWHBhVgvQkt4sW/DsqfBEkLl/5BsO3cerry3HH0QNCKXWR6tQTgevnE6/PDYnQ5HIoAQQFpvr6dbBVkUA3C4crTEl+NUzQit7ZZAA97coIMpGJNeGGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817696; c=relaxed/simple;
	bh=Pwy+IfpUw29EKdohqqAF88REx1vjQAd1kd9B9jRJpfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahBYhs+wgX62I7OeVFqEmNM+rYal60Ki67OhDFvVZNyE7ziU4kVLwLmxlqI17eqfBykIge1apgw4HG4NxBOOHgxpJUouCJyjO+HCQfLzEevZHQczxT9aBfecqGWqEeq0MOACnbhC4rA6EzUXwfkDwJ7fca29jQKXluV3vxKRg8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bZ3SgUoI; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b220ddc189so321991885a.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767817694; x=1768422494; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pwy+IfpUw29EKdohqqAF88REx1vjQAd1kd9B9jRJpfw=;
        b=bZ3SgUoI5FQpLJsjzXc30s+FyYsVvVRWTAlmnDS7qLU24NDl+dgEWj4x3pYGdunKSo
         s/Wn4rpydmsEvBzlFNsiDynGyIr81nQGSKO8lcFOLzVc5wMeVXLjoPXABbLtSK7hJf5i
         Al5Rb1oRTnUTs/awnv3tjhBGvWSqhk1XmEHj9udCX9GL8WDKEl2sJRlsISjA42rKXcM/
         D9Yi2Hm/Mobp/g3N6FtPujJXdcDFSHJGvb7HmdW/r9rSJRYyNrz/V224Sz7cLR6szbs/
         yoUI8rzqz3PJ6bGxDkPDQ1ZnRW6BExzRj+T1f1w5R3EcshM2P7dIsa3WvaQMtzLMl7uc
         T8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817694; x=1768422494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pwy+IfpUw29EKdohqqAF88REx1vjQAd1kd9B9jRJpfw=;
        b=tosEzoKuR3TCUP1+B325Bxsgw5IUk7g0x5FllyporjmLtnhZl6dnlBkqkqkAY9D6zv
         UXb4jt+W7MfXqIKxZ5QWIRed3xy49G2Wbq/cBYHqJnmxqi1GELllei8FcOIkDXRMWas6
         On/r4hAI4IuCZnhM8HkTgNnrpY/sY0KkxEBY18EyJssrjZTLIoDVzCVP0bGlT+MlllRE
         HGHx+8acPpX4RwRveuv6hUpql5TEnxqy83FeOyrFUgLl/Dl89x4Qfkh5i4G7QzOZNnYk
         IIsZS1+j/NYEQm8MoFkbpfEwrVA+Bh4S8vfGARCnmqS+j/GEyX1DxBahtmnGt7006RDS
         phUw==
X-Forwarded-Encrypted: i=1; AJvYcCX60Q9/VMihCt655J2rwp3GBO92lghDSfxFAhQFN9gEEysD4hZOyfDB+I8QIXUCETmfbA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrTvyFYqwccgbin0Hfq8gwSU0Uge9NY0kVub0Eryy0FsR5xz7O
	5qYPivtNcblGSgdvuC7ZYRfJ2O0OgvMFKMeHoKyd9Ho1j7QBAxkq8Bv3FAs/vrz0DlQ=
X-Gm-Gg: AY/fxX51/Q8Dq76e2FNV/HBGDx06Vxbmf/JitUrMdbXEvhzn5ys/vv2ZWpdUDjtcl3/
	XCFhOXCOFIh6RnZ205SJtpth3GGziRe/YBW8eEk3sWv3f3nKDiRx1mSiwaGHSdXTkiHKmHQsch8
	lQoaJNqSsD1tFHds5iQMgZxMcI2WPYO5sZXof94i5AwkdhzyBxBEokhmLgF7/FJ/FVOiAX8mjpM
	uPEoVeWP6ZnMHhsifRU8d4Y11GZ/ZDZv9cUcUC8kJlDH3X5p8Bw5OPOMl3g4dzgIx+AI86V4qvx
	AJu8ywag5Kp7pMUwcGbkOSqjGO7nrzcUm2t/czSsm/wUkZeI0Jq2QtQl/hVwjXG7mIU6c7I3QwZ
	T3qIUDqUZlK538+XONrApmbRAO72ExhYCl8Ubw1tuYyU7iQX36VlsSmEPMj4zNC2bxz93UK/KPb
	LXKRaoNjDPEpYwig2d4OlhmddTjRoBh3SLckL6UJfAxPHi63/N9/ET9Y9d8FdUCZNTdjg=
X-Google-Smtp-Source: AGHT+IF1CHjyh/4VwE2Qpy7k+jz5GQV1Ds2jksHNp2vXpQ1aZAbgw8ISXAflbwZAAcJeQ4w7G3k3RQ==
X-Received: by 2002:a05:620a:191a:b0:8a2:4d02:eeb3 with SMTP id af79cd13be357-8c38936c94amr459388985a.11.1767817694411;
        Wed, 07 Jan 2026 12:28:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a6145sm441707785a.5.2026.01.07.12.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 12:28:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vda8a-00000002F8Z-2Bdq;
	Wed, 07 Jan 2026 16:28:12 -0400
Date: Wed, 7 Jan 2026 16:28:12 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Matlack <dmatlack@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Subject: Re: [PATCH 0/3] iommu/vt-d: Add support to hitless replace IOMMU
 domain
Message-ID: <20260107202812.GD340082@ziepe.ca>
References: <20260107201800.2486137-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107201800.2486137-1-skhawaja@google.com>

On Wed, Jan 07, 2026 at 08:17:57PM +0000, Samiullah Khawaja wrote:
> Intel IOMMU Driver already supports replacing IOMMU domain hitlessly in
> scalable mode.

It does? We were just talking about how it doesn't work because it
makes the PASID entry non-present while loading the new domain.

Jason

