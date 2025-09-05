Return-Path: <kvm+bounces-56879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F146B45813
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 14:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36DA0A0610A
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 12:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055DE350835;
	Fri,  5 Sep 2025 12:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="OEx80ZHy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3171822FF22;
	Fri,  5 Sep 2025 12:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757076354; cv=none; b=HazbCjHoAbeCXIYRKmS4FB/HjKEb8iBrAJa+2UWr8A62tGpIPlhzMg0hcd693s3naLrwGq9TJTsVdsfVfSf0fkUi8kAv/8Ppp0ke4NUmYLqflnluDfytYl6Pc9X8IujFdN9kZx6RrVFQcEWx5ww14Xww+dkupp9zRS+Y+uci72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757076354; c=relaxed/simple;
	bh=eOFVNvDFRW+Ujyc5Nyl0aSzWS/CCSEG+GpBw0i/LL28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgmq9AS/QcAfYkhYy5jlEQMGPxCbEQXwyDO3XEl+IPg8i5yr9J1duU6ejvGS4+9UD7N2JnYEdTZj00gxV5PTqsQbMRwSWDr20FnmWTCpTDMOOq5SnfoHq2ej0Fuy9RkRgTBy6K34c4x8RjndFPZtEXTeFl6XAJTDH70QznW5Nyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=OEx80ZHy; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p54921b16.dip0.t-ipconnect.de [84.146.27.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 02AE954B3D;
	Fri,  5 Sep 2025 14:45:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1757076351;
	bh=eOFVNvDFRW+Ujyc5Nyl0aSzWS/CCSEG+GpBw0i/LL28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEx80ZHyspmvy3kygXi0IKjmudWjl9IlAjDX2Uvp5isLSVHzDPIz/StmLV6jjrrHb
	 BlwFY/uHmwd0q8dw+055DyEiXA0KV88lEsxvM92HAJeMQp/ASDEB3eTi2+PZxdT3pN
	 sFP+j+f8BtpuUKvohKLe7SCo7U2ZZruvJIa4rJdCQSNjBzjKu7sbDMQtQzU5GQEu/8
	 KQxYBVWNVIe3iZ5KlTX8E/dg0ypfRA31H/QaKaDOhx2HpydCQZn5KPSe14ucrdn8Gh
	 YQvay1FvqixxzDXLz0OpJiNfY7DjumPnW9M2Hz95uBTibdCW2oQzEdtHvaDQhEOKF+
	 Uw3PYukpIdzyA==
Date: Fri, 5 Sep 2025 14:45:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
	Sairaj.ArunKodilkar@amd.com, Vasant.Hegde@amd.com,
	herbert@gondor.apana.org.au, seanjc@google.com, pbonzini@redhat.com,
	will@kernel.org, robin.murphy@arm.com, john.allen@amd.com,
	davem@davemloft.net, michael.roth@amd.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/4] Add host kdump support for SNP
Message-ID: <aLrbfaoZruWvaAcC@8bytes.org>
References: <cover.1756157913.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1756157913.git.ashish.kalra@amd.com>

On Mon, Aug 25, 2025 at 09:45:45PM +0000, Ashish Kalra wrote:
> Ashish Kalra (4):
>   iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
>   iommu/amd: Reuse device table for kdump
>   crypto: ccp: Skip SEV and SNP INIT for kdump boot
>   iommu/amd: Skip enabling command/event buffers for kdump
> 
>  drivers/crypto/ccp/sev-dev.c        |  10 +
>  drivers/iommu/amd/amd_iommu_types.h |   5 +
>  drivers/iommu/amd/init.c            | 284 +++++++++++++++++++---------
>  drivers/iommu/amd/iommu.c           |   2 +-
>  4 files changed, 209 insertions(+), 92 deletions(-)

Applied, thanks.

