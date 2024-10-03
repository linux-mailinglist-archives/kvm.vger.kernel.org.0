Return-Path: <kvm+bounces-27838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB90498EC0E
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 11:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43F2D2844CE
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 09:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BABC145B39;
	Thu,  3 Oct 2024 09:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qy6t3RZy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E57F45BE3;
	Thu,  3 Oct 2024 09:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727946563; cv=none; b=YYLAywKxsTfwdZDLDUfaYVh9ttQzzm9/LzBD4ecL26I2/KWzVd1rGMCdYmnlBIbzWsSVuA3GiDaWHQw7y7oFUix6dcIt5OJnazPEwlz0KAAt3o+BwZIM/lgFtNaNhUll4+5X6TGtj5Z43x+VJerBHHOCd5PtqlVIFaK/cB/vylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727946563; c=relaxed/simple;
	bh=nW2bwbdMC4sk/Nale1eCWcTAjfPhmEnbSdq/ueg8GOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLD+0m3k08bYLEp/x1rKideT/teSpyu/0I5BrdhNWHNNkQcQxmeivIvmIB79t2x7rcsphQrmlGveGX1LefnuzXfoYppsZVHo/B1qodJkIvnD7ggS4vp+5+qMEqXaCOR9PHScYmsu+kGvRH8z3UbTEBi5fmzYb9Dfy58c450H9XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qy6t3RZy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7B6C4CEC7;
	Thu,  3 Oct 2024 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727946562;
	bh=nW2bwbdMC4sk/Nale1eCWcTAjfPhmEnbSdq/ueg8GOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qy6t3RZyvPPexaJMyz9PQh0DSq3fUA19YKVTExJXuQvYgXSTEjz3yMWVSxujnjQfX
	 +EQaspqhxl3FKDItbHTcKuuwLoKgBmUDDoCG/CZBJnCgM9eqx05ZRn0jxGcYDaN3Ub
	 tpYoI00/Y9oIhE5RYlcB1WJ8UPDG2mbIoBPnV+EA/BxxrITFwf16fy1KjVU2I8qfQA
	 VIOqDl9GJnQHgXXVBHC1bH8d8469fNuvnM71wlEDI1ggJ6+DgbrfyUbXNRfk8ax8Dk
	 zGedzBdRWm1Xa8TRZ70pgUyVebu/YTwUuCeg4ZiaBFdntIGOAAntzA5BK7FZafgoAl
	 XhtdV37utJ5EA==
Date: Thu, 3 Oct 2024 11:09:16 +0200
From: Christian Brauner <brauner@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>, 
	Luigi Leonardi <luigi.leonardi@outlook.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Marco Pinna <marco.pinn95@gmail.com>, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Message-ID: <20241003-inkompatibel-bankraub-c63b9ca506f5@brauner>
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>

On Wed, Oct 02, 2024 at 09:41:42AM GMT, Michael S. Tsirkin wrote:
> virtio_transport_send_pkt in now called on transport fast path,
> under RCU read lock. In that case, we have a bug: virtio_add_sgs
> is called with GFP_KERNEL, and might sleep.
> 
> Pass the gfp flags as an argument, and use GFP_ATOMIC on
> the fast path.
> 
> Link: https://lore.kernel.org/all/hfcr2aget2zojmqpr4uhlzvnep4vgskblx5b6xf2ddosbsrke7@nt34bxgp7j2x
> Fixes: efcd71af38be ("vsock/virtio: avoid queuing packets when intermediate queue is empty")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Lightly tested. Christian, could you pls confirm this fixes the problem
> for you? Stefano, it's a holiday here - could you pls help test!
> Thanks!

Thank you for the quick fix:
Reviewed-by: Christian Brauner <brauner@kernel.org>

