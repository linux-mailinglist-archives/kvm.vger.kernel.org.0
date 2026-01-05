Return-Path: <kvm+bounces-67055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DCDCF44A1
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 16:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C2D48300A3F5
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 15:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587042EC0AE;
	Mon,  5 Jan 2026 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ek6JXvFh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05942367AC
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767625462; cv=none; b=BKrU2/+O9p2wMeLMVvl7S3s7HHQkeZqVMDGWB5W7d271lqE/vApItkF5yUwIUGntmCelS/S1Tqoxd8zBDLGOJ2bzxTorsowcCnRcxDfnqNsRhtgjEQABRUayYZmBMqC/z21GReGXU0FC7CeOssYJVO+aB5unyeaLOqDOCUrn4L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767625462; c=relaxed/simple;
	bh=X5MIHAp5JK1NlV89p7C9v/3gPK3omfO9gWSPtLvKdYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAhnTBtM8hgPaHMwE8oDbzQjVOlYFxsO/5XT3FqK+IBEiPnfAMOTVjex6nQXRpHDNCH08ijxl12OcyBzUtMAgMxO10r7ZKYHHcKn6AvZOX3TZzTeTFzCBoY1AI8sBGiT3H91YCa67AFM6Ro3uPlwOVVfxtEJhAF+jR+ED4fpfWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ek6JXvFh; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8bc53dae8c2so2157099085a.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 07:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767625460; x=1768230260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yb2yGX8XpVdwAg+BOMxHsU4DTiVLYDcQfLOceevAzvY=;
        b=Ek6JXvFhePFfs9uW2hC4xuuriHVSbC+G0qNrnuWpsGEOHoPTIuzqwYFpcMGgBitvT2
         ++w99S1nbZB/5DbxrVBTR9S48B8Ebhur1It08J9j0fuZ/R+dq1l7HwVyIeTwaz0scHAn
         PRVpYVYEFO9yJe463RQZMRptIhid178185YflpFPJ0ZJjTffDrYpRmERo23KZ7qfTchL
         PmJUjzhD4uMtnMnVmKQHNFiwkpGz0fRymu4ZgE4u31vy3Vj7K0xlTIvdyHDzOEEGtFoC
         fcj38uRIMyFSinpGVevGBpNOysoJ42gXbmCbqbJWBGlxqQwG8WgWmJU3M0AvzREUBC1m
         ztzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767625460; x=1768230260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yb2yGX8XpVdwAg+BOMxHsU4DTiVLYDcQfLOceevAzvY=;
        b=CCu1ONJDPtsUA0GsTWT2V4PdvasWniqmdHQn+aoYfF/lHXvAH3zl/damAL/A70APpV
         6VmvrQwulSXJon33RuG31fM4v6twV/oJOoNdGkRzEfL9tWIgtzGz/HO8/5MMVT/Xhcn3
         EuGCENYPZmwOFHq3HTfuVhSJjj/MUv8m3lNfGLQ7UN5Px4PP+bWhN83z9PFw0TO/9eTq
         kj/D72/TGFQdbTnqPQGTweK0teF2a88OxSfmJaDpUcRG1flY9nSBp5zS5U53feMAseiJ
         utmPzJTobrLn10AeBhoJH8KEOg52KzRgiu6a0RAhCBLXRSm6X3y3jpsUN3pLmD96kxoF
         FVhw==
X-Forwarded-Encrypted: i=1; AJvYcCXbsj1528zUDYKJoV9TalIsCIKyz0ZQ3LuN6R9g0JdXrTm8s1dtgMaQJuLA+g4xNwYuRaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYk3eR67fMyT6w8gHNeqQNK/j492tHyrPRwK6JTdecKd3AVFAg
	3K/AfKEfuEzqXV3DNYZlTlZljhwiakagBXWA6YAwCMp8fS8/qBreCKyKrLVNwtp4GQg=
X-Gm-Gg: AY/fxX7m91D+VvI+3S+qO6+Bn9GyN7znUS1FYtgq8MNAkZV6PnS5+BLVlt+OOFCzACd
	R02u9aYt5ld/EpChK4AydzstCZ4h1pImUgAnsvt2epc84Vswc/W5K0EEVZpqOmqOnRcrLdS+fga
	dBG/e6cDCk3wEaYkLjFRjG3kvRtdxAEIomm+wVLPCoRpCyaj+fwuD1863oIQ11Pq873kKTeF5i8
	GYYfyoCc1g10CPBMEJ7FFQ4J7dyzsno87HJUYwozWig5K6y3qIpOUwRAcKBRk8vK1JVbIzk95mh
	pDU4t1g59zTlOjGsk9/If7PR5Jkgzr0Y4xaGtupkqJHWxZOAFEEefJUeFGJBJAeqY8DRcnjoCh8
	T2bqZSBkLth+StyfG515yHErC9Ly1ov9/dxhjKTUeQkqKfpRsO5/BxDDcx5JWQC7ZMFluifFNUE
	pihc7ReowGxf8gOLJtAg9IPSQ7DhRfkTV+OMwCdvMAj8sWasbMEQDOWlXtOn0n/Br2NS4=
X-Google-Smtp-Source: AGHT+IE0KSB9dzoXLvYDNi/2QizYzBYbxFHcrGMTg8rYaX5btB81fEkojeSpnken2msWHtKygqw6qA==
X-Received: by 2002:a05:620a:1789:b0:8b2:7290:27da with SMTP id af79cd13be357-8c08fa9bf01mr7773575785a.12.1767625459349;
        Mon, 05 Jan 2026 07:04:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c09689153asm3620440885a.17.2026.01.05.07.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 07:04:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vcm81-00000001AVB-0TCK;
	Mon, 05 Jan 2026 11:04:17 -0400
Date: Mon, 5 Jan 2026 11:04:17 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: Kirti Wankhede <kwankhede@nvidia.com>, yunbolyu@smu.edu.sg,
	kexinsun@smail.nju.edu.cn, ratnadiraw@smu.edu.sg,
	xutong.ma@inria.fr, Alex Williamson <alex@shazbot.org>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/mdev: update outdated comment
Message-ID: <20260105150417.GE125261@ziepe.ca>
References: <20251230164113.102604-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230164113.102604-1-Julia.Lawall@inria.fr>

On Tue, Dec 30, 2025 at 05:41:13PM +0100, Julia Lawall wrote:
> The function add_mdev_supported_type() was renamed mdev_type_add() in
> commit da44c340c4fe ("vfio/mdev: simplify mdev_type handling").
> Update the comment accordingly.
> 
> Note that just as mdev_type_release() now states that its put pairs
> with the get in mdev_type_add(), mdev_type_add() already stated that
> its get pairs with the put in mdev_type_release().
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/vfio/mdev/mdev_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

