Return-Path: <kvm+bounces-33868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 346D59F36E3
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 18:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B032618905CF
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F363620B815;
	Mon, 16 Dec 2024 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udS4EU0e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1B2063DB;
	Mon, 16 Dec 2024 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734368064; cv=none; b=t9gup852UDYIrMz25gqRtWQEU2eo7XxxrHYHvjThA1DPRRSb6TlMusC4iSPfj/fdDh4+wwPkOSzi6U1oR6iTAgcOPzRBjP1UW7sGG7+yJhrsrCyBi2Tr0b2zDvySnssmDYmjoqBzHvpMBFzhWvrzfAqkvQzRmpUoPuQZgjWUgtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734368064; c=relaxed/simple;
	bh=fGSmira3qY0qu6Pm6drcj0Bgb5kegO5+9l28c2GA9N8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7zLN937ymvCsN9BwuHX2OlbPwEs5Gq3zmqUIDhaRT9eqoouaxaPLxgfWXQKL3XP6pjiXINH/BGy0TFjAg6+4bn4OimLK/awp7ZT/1pacqaQd+bgzaXnHiAD/x0lRrR8d9Zq7CzHYj39w+nIODHfJzYTq47WuBsoYxTkO4JOJF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udS4EU0e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8293C4CED0;
	Mon, 16 Dec 2024 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734368063;
	bh=fGSmira3qY0qu6Pm6drcj0Bgb5kegO5+9l28c2GA9N8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=udS4EU0eMphp2mwSceRBJPdkzI/VrMjsXMZp5BmFC6BJIef/c+Wcn/96KxFZSFhLf
	 zCdiTCat+WhHh33aYZkXmyx516q+wuMyPUcLHUJBgJysU04T1nvGhORixryddbu7Ed
	 b59uYs2I8PloVltK5pPPXEq1WLTYZ1yfYwcw5a+LwthvfygLaPUcUtwi9oRGpmwze7
	 Q+277JErXes6oeSNNAXda7wLXaCRYGWQGhOsalIoUDudcrkXWTPPXYENUlazJeApFR
	 rSBGjokABEG3AhTpTDmLLgffEMycIVFjgu3a/NYPIj3jmBcDXxtoNo4YHAnFXyyqG+
	 WxobQh8faXkdg==
Date: Mon, 16 Dec 2024 09:54:20 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Wei Lin Guay <wguay@fb.com>, alex.williamson@redhat.com,
	dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, jgg@nvidia.com,
	vivek.kasireddy@intel.com, dagmoxnes@meta.com, nviljoen@meta.com,
	Wei Lin Guay <wguay@meta.com>, Oded Gabbay <ogabbay@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH 0/4] cover-letter: Allow MMIO regions to be exported
 through dmabuf
Message-ID: <Z2BbPKvbxm7jvJL9@kbusch-mbp.dhcp.thefacebook.com>
References: <20241216095429.210792-1-wguay@fb.com>
 <89d9071b-0d3e-4fcd-963b-7aa234031a38@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89d9071b-0d3e-4fcd-963b-7aa234031a38@amd.com>

On Mon, Dec 16, 2024 at 11:21:39AM +0100, Christian König wrote:
> Am 16.12.24 um 10:54 schrieb Wei Lin Guay:
> > From: Wei Lin Guay <wguay@meta.com>
> > However, as a general mechanism, it can support many other scenarios with
> > VFIO. I imagine this dmabuf approach to be usable by iommufd as well for
> > generic and safe P2P mappings.
> > 
> > This series goes after the "Break up ioctl dispatch functions to one
> > function per ioctl" series.
> 
> Yeah that sounds like it should work.
> 
> But where is the rest of the series, I only see the cover letter?

Should be here:

  https://lore.kernel.org/linux-rdma/20241216095429.210792-2-wguay@fb.com/T/#u

