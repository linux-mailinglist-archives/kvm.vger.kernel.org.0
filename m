Return-Path: <kvm+bounces-66459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F651CD3D25
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 09:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6AE83012762
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 08:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDA4279324;
	Sun, 21 Dec 2025 08:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqpj2yAW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BCE1A262A;
	Sun, 21 Dec 2025 08:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766306781; cv=none; b=hdx1dueONOaW7jd+MEwBD/x0hGFlo+rlXLy6kqcAcVxJgZXLH/IWVdi3jzth1iDwTPM+ORhKT6FP9afIug6TRlOLphg16xpidCNfKMOKwePQxfg78X31i7J3CHO7Up5x3wsssDKzaKrEwsXW+1rOgSVGXNCPs1D4h/SuEmNttGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766306781; c=relaxed/simple;
	bh=LzD3evTlbOZ9okKa/QPL8yyABDk/ui8XeBYX9VdYiL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e83JbEcbWMd8KveabuZ+AtXTZ1AylIRnsu2IV2qbJe13tNXlSB/tc9D3cWgBlxSZlWONo9rl3SRMiujMlx80pYBn1mLiJF3gjYHmU3JQ4zFgTgaOzRtBkIc5sBBNPxoCfnPu7UgttxwnsKOPzRgntV0kCjuo0eriFXWzdOrlIFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqpj2yAW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02106C116B1;
	Sun, 21 Dec 2025 08:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766306780;
	bh=LzD3evTlbOZ9okKa/QPL8yyABDk/ui8XeBYX9VdYiL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iqpj2yAWQXba4lB65BL8nDC1aWyjVjtIjEMQGcnEx/w31Hcytp7St/mUJbbn9BUM2
	 mZi8a1JUPvdGpq7uAmmyVglB9HJtI4W+LvtFeqCWtSz2gCVxn46mEbwmcHPHEffY3M
	 pB8R3osQbPLuJcdSfV/lD9lONJ5QXPIbTlN/2vB8r+x7LXWLE0YoEgQpcvM8pGHVYJ
	 glF4yGGndQ30vWEHuKbodeh5SedLAy+lCGo62tSXCMCMKtRYoioNfAfiDHIrS79RQu
	 rL/b2JFXfPe7AtNqDvEzO0/262NCpkbKQ7/lrkQlwyBg3g+TOng1g4yFJf36SQiFh2
	 LFiH6oqjQog4w==
Date: Sun, 21 Dec 2025 10:46:15 +0200
From: Leon Romanovsky <leon@kernel.org>
To: =?utf-8?B?54aK5Lyf5rCR?= <15927021679@163.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Thomas Monjalon <thomas@monjalon.net>,
	David Marchand <david.marchand@redhat.com>,
	Luca Boccassi <bluca@debian.org>,
	Kevin Traynor <ktraynor@redhat.com>,
	Christian Ehrhardt <christian.ehrhardt@canonical.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xueming Li <xuemingl@nvidia.com>,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	Chenbo Xia <chenbox@nvidia.com>,
	Bruce Richardson <bruce.richardson@intel.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: Re: Implement initial driver for virtio-RDMA device(kernel)
Message-ID: <20251221084615.GD13030@unreal>
References: <20251218091050.55047-1-15927021679@163.com>
 <20251218163008.GH400630@unreal>
 <6ef11502.4847.19b34677a76.Coremail.15927021679@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ef11502.4847.19b34677a76.Coremail.15927021679@163.com>

On Fri, Dec 19, 2025 at 10:19:15AM +0800, 熊伟民  wrote:
> 
> At 2025-12-19 00:30:08, "Leon Romanovsky" <leon@kernel.org> wrote:
> >On Thu, Dec 18, 2025 at 05:09:40PM +0800, Xiong Weimin wrote:
> >> Hi all,
> >> 
> >> This testing instructions aims to introduce an emulating a soft ROCE 
> >> device with normal NIC(no RDMA), we have finished a vhost-user RDMA
> >> device demo, which can work with RDMA features such as CM, QP type of 
> >> UC/UD and so on.
> >
> >Same question as on your QEMU patches.
> >https://lore.kernel.org/all/20251218162028.GG400630@unreal/
> >
> >And as a bare minimum, you should run get_maintainers.pl script on your
> >patches and add the right people and ML to the CC/TO fields.
> >
> 
> >Thanks
> 
> 
> Since this feature involves coordinated changes across QEMU, DPDK, and the kernel, 
> I have submitted patches for all three components to every maintainer. This is to 
> ensure that senior developers can review the complete architecture and code.

Please run get_maintainers.pl on your kernel patches and check if you
really added "every maintainer".

Hint, you didn't even add right mailing list here.

Thanks

> 
> 
> Thanks.

