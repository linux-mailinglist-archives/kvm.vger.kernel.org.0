Return-Path: <kvm+bounces-8427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C2C84F37B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 11:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4F511F219D9
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8909C1D542;
	Fri,  9 Feb 2024 10:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HidAQkaI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF4B28DD2;
	Fri,  9 Feb 2024 10:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707474734; cv=none; b=Tn4YlpcOYVOnpI+x+2AwpGsBMKRS6YG9XFkxE9V8R7wlxRLkXTmXdU8A4VDDmU9NmO/ju/iWRc7yV7xaXxIdA7Uzal9SHBTVOTbw1c9slnia2evxh1w4cJWiaHBKUX9+O2BvQc63np0XFAlsRqeY/hBdJnvKxASj/tHwMxxmJsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707474734; c=relaxed/simple;
	bh=EPDIaSnrDBYfBtH84QRpQtFyh1a+UlxiFu/DMO5OYC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qcsa9ocTkpsTmiEIAMMGAkl+SPG62Xi60qwSE8MLhk+5hq2d+L0NOHbUAVjPeNSxkykxNkXvLNvVgkg08cIG0ghjbX+SDjrBGZXFeoU8opaMbOp6jPvF9s4e0bHB46cwhrSvcDFS4vlijb+pOx5+2c/mjKIsbkdOI1++GIrBnrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HidAQkaI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A7AC433C7;
	Fri,  9 Feb 2024 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707474734;
	bh=EPDIaSnrDBYfBtH84QRpQtFyh1a+UlxiFu/DMO5OYC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HidAQkaID0CQbYqX4wdOnuFHROO6Ds9q9ZMTdJyd/a9Tg77qmDWw9bf/Ji/Nr1KBq
	 bxuWtPJUt5fgjDaGJx6YTH75HmZNa5oPw1CT1vguq75wtKKyAb5hNqLp0nEBWSh5TB
	 0f46LTruBmkjFWFpnddTCNTraKdtItWyYPpu3x7w=
Date: Fri, 9 Feb 2024 10:32:11 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Ricardo B. Marliere" <ricardo@marliere.net>
Cc: Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mdev: make mdev_bus_type const
Message-ID: <2024020902-luminance-scorer-3691@gregkh>
References: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>

On Thu, Feb 08, 2024 at 05:02:04PM -0300, Ricardo B. Marliere wrote:
> Now that the driver core can properly handle constant struct bus_type,
> move the mdev_bus_type variable to be a constant structure as well,
> placing it into read-only memory which can not be modified at runtime.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
> ---
>  drivers/vfio/mdev/mdev_driver.c  | 2 +-
>  drivers/vfio/mdev/mdev_private.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

