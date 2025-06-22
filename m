Return-Path: <kvm+bounces-50260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0792AE30B0
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 18:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE738188FA84
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 16:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0581F237E;
	Sun, 22 Jun 2025 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isZjmj3Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973B3FB1B;
	Sun, 22 Jun 2025 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750608147; cv=none; b=LdvTSgWWNr7VHyzhxli1uXF8XVWJy0cUCYK/lnydKuBaH6eF7WPKBUrwzt2scP+OnfzhITretkHbcc0Nv8JFhj26U+dpioXRyGyI99VPZlQNGzg3PkkaXKDasNkADqXGtkDMn6g7dEihXZiktmea80UHa4B9+BXmnPvo8KfHG2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750608147; c=relaxed/simple;
	bh=bAa+SPiPfXnsCLfgXME8rQ+DPB48Cn88u+M1H6HiyIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVvPX+rgJO5J1uzi8xJPUiNCC/kdUkmOG6UCYco0UAXuU6Cvk1PGlS1+APpFN9rXIsFf5J/qkCKzzyqimQ8kklGwrnL4RBwAKoz+mhZdFz+ii/jfdcX7TuS/zVxfcXsqtWILfYKq8o+grXcGKWUeRs5fUna3ziEJCocGTRoa+7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isZjmj3Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADCEC4CEE3;
	Sun, 22 Jun 2025 16:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750608146;
	bh=bAa+SPiPfXnsCLfgXME8rQ+DPB48Cn88u+M1H6HiyIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isZjmj3ZfniMHyhalxXtq4eIlshtWLyytwYkPSJy4UfV/4hUbMrrCDCjmHqNJ/kce
	 vi1vXlo+SJh6ftpY1X/ZQcTYDdd8LY7ZTG5/wZSuRlDmBi5m1aNeEqSWrMFbNmYaRg
	 tHQjVbI/OotFaax8+A80wS7WW+NSLmCZwajeFat+kTHd89Ah0bI5KYEih4Y7ea2fWz
	 PUKqOZKJooGIUBUmJROTXDlenZePlTw1oc2bLRAdS/m6YJYsy92a39bn32nBphobDC
	 pZzPwoHTDbIbiR38LvMaCeBASqj8U8gNfktetpknPXWfuoQNO2Q2iHQjzrajJC0fj0
	 soly3/jNqMj/A==
Date: Sun, 22 Jun 2025 17:02:21 +0100
From: Simon Horman <horms@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org
Subject: Re: [PATCH v5 net-next 4/9] vhost-net: allow configuring extended
 features
Message-ID: <20250622160221.GH71935@horms.kernel.org>
References: <cover.1750436464.git.pabeni@redhat.com>
 <e195567cf1f705143477f6eee7b528ee15918873.1750436464.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e195567cf1f705143477f6eee7b528ee15918873.1750436464.git.pabeni@redhat.com>

On Fri, Jun 20, 2025 at 07:39:48PM +0200, Paolo Abeni wrote:
> Use the extended feature type for 'acked_features' and implement
> two new ioctls operation allowing the user-space to set/query an
> unbounded amount of features.
> 
> The actual number of processed features is limited by VIRTIO_FEATURES_MAX
> and attempts to set features above such limit fail with
> EOPNOTSUPP.
> 
> Note that: the legacy ioctls implicitly truncate the negotiated
> features to the lower 64 bits range and the 'acked_backend_features'
> field don't need conversion, as the only negotiated feature there
> is in the low 64 bit range.
> 
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

...

> +	case VHOST_GET_FEATURES_ARRAY:
> +		if (get_user(count, featurep))
> +			return -EFAULT;
> +
> +		/* Copy the net features, up to the user-provided buffer size */
> +		argp += sizeof(u64);
> +		copied = min(count, VIRTIO_FEATURES_DWORDS);
> +		if (copy_to_user(argp, vhost_net_features,
> +				 copied * sizeof(u64)))
> +			return -EFAULT;
> +
> +		/* Zero the trailing space provided by user-space, if any */
> +		if (clear_user(argp, (count - copied) * sizeof(u64)))

Hi Paolo,

Smatch warns to "check for integer overflow 'count'" on the line above.

Perhaps it is wrong. Or my analyais is. But it seems to me that an overflow
could occur if count is very large, say such that (count - copied) is more
than 2^64 / 8.  As then (count - copied) * sizeof(u64) would overflow 64
bits.

By the same reasoning this could overflow 32 bits on systems where an
unsigned long, type type of the 2nd parameter of clear_user, is 32 bits.

> +			return -EFAULT;
> +		return 0;

...

