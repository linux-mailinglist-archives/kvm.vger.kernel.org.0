Return-Path: <kvm+bounces-66276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E802CCCC8E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 17:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63A563073941
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 16:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA8C36923F;
	Thu, 18 Dec 2025 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5jDWifX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09887368290;
	Thu, 18 Dec 2025 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766075414; cv=none; b=VlLZDSZnKWB2oGOFk8nGWjtxBScz5eMG8q+JMbCu1eNZ5KtuIm6v43fptcbdBrFk6dYWoL6PXqAXNqpwrmg9GGeP+cUsC40Zh1nptMZWt5YK5oB3dbhyi8lPQxKLfBanTtt231i65nS4dScL1GrimP7hcryTPz4w061GHib5Rvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766075414; c=relaxed/simple;
	bh=hI7YFV+z7VDBw39iRCMVjADZ7424gyN0jbW/C3K+dZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puzs9qSZwJqI0A1M4Q0LXLFKfyRrmDn1ohMLAQGcIJ+FED5jcUTHQKWnArX3XPcqdCAibK3LBSbdgNBE1i1xK7PDmDMumKuZlTYdKCu789TGpykJmPJlSCVdyw3/Wn1hEBF3XIffrRaGEy0us3liIRTo7vzKPmnieqt8nsBJPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5jDWifX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03757C4CEFB;
	Thu, 18 Dec 2025 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766075412;
	bh=hI7YFV+z7VDBw39iRCMVjADZ7424gyN0jbW/C3K+dZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P5jDWifXwa8UJIm8asTtbfPmXxJ3Wm4SF8P8ZTqnRcNZh0y0CYU6FZ8/Bwjgjz4Tm
	 ApfCH6h/6hR6M9N7+Ml0TphsUgJDcDvlxHEHKcrP0TunrmexGrUAlO7PyU9YwAqnM0
	 4s/pwfr1XeL8Z47KvQujNa/EqM5cBt+AoOun0zwGsHj0SMtVADGWLaEn5gs8UK9gWE
	 twhC/fO/zgfL7dfGm8GL8BGFSToOtJugvH0Ky8+H2fuf6BH9YC5ieuTJnAjZxVKBL3
	 YxoxHEZYuXt1IFix+cKureVZ+gQYfAj/C6CeOYK2D22N+28VPeosPTtuOM8JFdTOkt
	 1D9W9KcnvtA7A==
Date: Thu, 18 Dec 2025 18:30:08 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Xiong Weimin <15927021679@163.com>
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
Subject: Re: Implement initial driver for virtio-RDMA device(kernel)
Message-ID: <20251218163008.GH400630@unreal>
References: <20251218091050.55047-1-15927021679@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218091050.55047-1-15927021679@163.com>

On Thu, Dec 18, 2025 at 05:09:40PM +0800, Xiong Weimin wrote:
> Hi all,
> 
> This testing instructions aims to introduce an emulating a soft ROCE 
> device with normal NIC(no RDMA), we have finished a vhost-user RDMA
> device demo, which can work with RDMA features such as CM, QP type of 
> UC/UD and so on.

Same question as on your QEMU patches.
https://lore.kernel.org/all/20251218162028.GG400630@unreal/

And as a bare minimum, you should run get_maintainers.pl script on your
patches and add the right people and ML to the CC/TO fields.

Thanks

