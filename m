Return-Path: <kvm+bounces-58859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED36FBA33DB
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 237D4387278
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 09:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3622BD5AD;
	Fri, 26 Sep 2025 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGnMyA+m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E8A265623;
	Fri, 26 Sep 2025 09:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758880323; cv=none; b=fKHtZg9LSYzZNmSvphSz3Xdk1z85pylr7dwU5JiqcRCiBj+wlTDw3sgv6mHL1Qo4fXWHmoLBQG6+dT/wqyfpoSmcBrrSrNwie97Ra0nGKvv8GHgg3YyabccSr+2MEq/0wgZiXMyjKfDPCCb6JLokBfEN/IRtIIfTGvoohhF9TOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758880323; c=relaxed/simple;
	bh=K2PsWb515+NIbc7/1vFNik1ObXIyBBGTGxrD0zJQBz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wba2Ar0u3V6OxPQe+lTpX5u+aIqlrufSDMiq4XY/yfz1Py22pHWxlnE5N93fXpBVBDrLZOjv6Ioy5eWICehtOItSmRg6H5rLMUEyTTFT0DWjk1wfrwp90FXeKAAgnSUG1M4T8iBGNx7QlbWVIJ7j0BpBUznEog5IHKnFQXl8gm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGnMyA+m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD66C4CEF4;
	Fri, 26 Sep 2025 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758880321;
	bh=K2PsWb515+NIbc7/1vFNik1ObXIyBBGTGxrD0zJQBz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JGnMyA+mZ2gBq2hXlzZkqhpIoBi7mNVsU/jCWYLYdgxKe3OQ17Wc7TOeQcv8/vhhF
	 aLmgSx1LsF/jH3Ab8rQGsWc9Pk5sPHJN6s2Ae3QYdqT4Eihr1xPTBtQJvcqzyvJejd
	 5x9/75FW0cs6uGJKZUoNh48QsRiWqey/D5Popk7viAUGvLMGsDVqCPszSxecNKLd5U
	 AC4mF7dpHC6bJRY+TrdFw8lj9nXNcdvLYUnxdc3eSsUyp10IIpdhCRt3jCP5ceiXQb
	 fsDgsAJ3D85R0cQ651jqaPi+6M0ddotzTVUP5LFiCeWcOK77aaMVeoKD36pdP1roXy
	 EWGA00EXWvSPg==
Date: Fri, 26 Sep 2025 10:51:57 +0100
From: Simon Horman <horms@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] vhost: vringh: Fix copy_to_iter return value check
Message-ID: <aNZiPbINQWoJA_-w@horms.kernel.org>
References: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com>

On Thu, Sep 25, 2025 at 02:04:08AM -0400, Michael S. Tsirkin wrote:
> The return value of copy_to_iter can't be negative, check whether the
> copied length is equal to the requested length instead of checking for
> negative values.
> 
> Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Hi Michael,

As a patch for net, I think it would be nice to include a fixes tag.
Perhaps:

Fixes: 309bba39c945 ("vringh: iterate on iotlb_translate to handle large translations")

And nicer still to include some description of the failure scenario.

In any case, the code change looks good to me.

Reviewed-by: Simon Horman <horms@kernel.org>

