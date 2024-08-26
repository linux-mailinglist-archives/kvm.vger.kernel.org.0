Return-Path: <kvm+bounces-25053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 446ED95F3C9
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 16:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0122428168C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 14:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA33018D63F;
	Mon, 26 Aug 2024 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="jO7LpLJA"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010AB145B07;
	Mon, 26 Aug 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724682305; cv=none; b=pSkIOHxQuQVWHbwXyHmpDlY5UTA812w6dLgi0N9sB29v+kYX51Xgc9FRak3Kget7nZu08VLye6+v6QIQTfZ08k1fDXLDTtQbgU6GP4/4EWMAyhonBvibnL3vFQMQ6DIAKq6ixcDnwTwpKPENlpNm5Bp2XRP3xFELih6CklSF/0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724682305; c=relaxed/simple;
	bh=bG8kqaZxngIAfDrMIMUCTanhr4CBigPaB0e+Hac/i1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wi6Z1dmasfKOTWlFH4n3b2r3Avi496sKphUtFgwMhYXVJSkIFBNXM0fNx2hmEkji8NdDRF4yfwjjfaFc+oKWAyFRFfBywEAC4cW/USWLiAcJkbvsuiGEfU7l/igEUVBQkeDKZIzB8wLCLLLf639nDe52x044Dt1cYBbuRSTRoHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=jO7LpLJA; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=+sTEWQlm/SIizE6LJlOZ3JYq0RVnDt1LZfmj/BC5RB0=; b=jO7LpLJA4NNzbuer2wrKsZaSJp
	N8O/fhhbXaaWUXDuqOw9+S9WY9y2HoRLy8S5mBKDfXpp8aybfGfaGmLeUg34FRupkTSTtd5KRrZCv
	PwD8qj1gIy94sYlhyorR2slWqZUf83DtYSxr301zkx9lpdqJt9cYPdx5MWH5z0NSqa4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1siaeI-005iS4-Q2; Mon, 26 Aug 2024 16:24:50 +0200
Date: Mon, 26 Aug 2024 16:24:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Carlos Bilbao <cbilbao@digitalocean.com>, eli@mellanox.com,
	mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	eperezma@redhat.com, sashal@kernel.org, yuehaibing@huawei.com,
	steven.sistare@oracle.com
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
Message-ID: <fd8ad1d9-81a0-4155-abf5-627ef08afa9e@lunn.ch>
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>

On Mon, Aug 26, 2024 at 11:06:09AM +0200, Dragos Tatulea wrote:
> 
> 
> On 23.08.24 18:54, Carlos Bilbao wrote:
> > Hello,
> > 
> > I'm debugging my vDPA setup, and when using ioctl to retrieve the
> > configuration, I noticed that it's running in half duplex mode:
> > 
> > Configuration data (24 bytes):
> >   MAC address: (Mac address)
> >   Status: 0x0001
> >   Max virtqueue pairs: 8
> >   MTU: 1500
> >   Speed: 0 Mb
> >   Duplex: Half Duplex
> >   RSS max key size: 0
> >   RSS max indirection table length: 0
> >   Supported hash types: 0x00000000
> > 
> > I believe this might be contributing to the underperformance of vDPA.
> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
> feature which reports speed and duplex. You can check the state on the
> PF.

Then it should probably report DUPLEX_UNKNOWN.

The speed of 0 also suggests SPEED_UNKNOWN is not being returned. So
this just looks buggy in general.

     Andrew

