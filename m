Return-Path: <kvm+bounces-8556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0076C851606
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33B9E1C22F69
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 13:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366A54EB2E;
	Mon, 12 Feb 2024 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Q8p8h/uC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6549C4D5AB
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707745492; cv=none; b=BN8iA0b1qvdPHdY2Elt+A38El6fNzltTJFKv/CbPkj1vwrKExBfSxe+eIn5KfBNVup92JZnJprTGYh1kc1Hf8k3VwXT7cn7Cx8y1zaTdjYbajV55++7WZOi7aMd9vEB7IPXsk6Vxyr+zroW6cQtFRltunBPnnmSqZKOci7rCRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707745492; c=relaxed/simple;
	bh=pbQuBXFHw1o0/Z9ineAwD3HEwjXD+2A+xezjlyIhPgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjqckJO2yWcTC2nCH0mP2RvDngKcCF78RYoV59RcOztutHdQy8MUNl7dN0wdjq3ErfD+4RQyShGOymAH6K2jDRArj0nd9P4ndtSt45dOAG2s4Yq8VfEB4VOZS+t93xCSVKFoZviuMvsrdWyHUQWmj+tO04F8hj6Y8QQKoU38OYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Q8p8h/uC; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3be78c26850so1843518b6e.0
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 05:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707745489; x=1708350289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uGXjdHO8XjU5jzrVV0nG9dx+YzuEyrCWweYCQg9Rxzo=;
        b=Q8p8h/uCkgyvUNliEmcYatZzPuvEXc2HjzCHNsRTqR5hXrrDeqIXSCMa3ixLO2Swp3
         l5Wj6rAzysV1p0WIcvuKap+dmB0DhkflDYmipztOGvGSnvy/kjXkJcZHOWmYFKlkHiqz
         sehTNJ+L30y3C3xxLD8dVEKLP+0m5NP26v7Gm0JCPOCPSqpuTgA7BcQVTjBgnUAVde8E
         nt2ax0IpqaEtnyS75U3XkVxMcs5V35yOqMlXsKTeMvhRflmWDqzb05lra66Z+XT9FYrQ
         Nm1CnbuEUvfBbI6zf59c1HQPKkygliHRTBdrbUWJMDgE/RtZIM68pXvy8e8GW3kfQeQ8
         dPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707745489; x=1708350289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGXjdHO8XjU5jzrVV0nG9dx+YzuEyrCWweYCQg9Rxzo=;
        b=DpL3TVaJFpGQ5mJnxFd2TjKVNzlxBx6liTJaM+xxX5e00bqSzcuTN2Y/Udiyb+aI6E
         gyY7hUnb/+cYZUOfRVizEmR9WdZLfNwjbzqRgCdZiZScV9OL2hI7JksmxlSjyT/sVN2t
         BsuIVGmy3d/1duXpHGfU8V/00VYeWxuw7mPPPJ/4rDQFSjZZF3zWVBAK/TsdyauZc3sa
         LR9rYYoFmtOBkTt6zADmTw3+WqBDL19xfqnYK4JCTuNiXtXRctkeB3bwuPfK0KsMp+hn
         QecOCglC5z+TNUbe16PftKQsMwkxwWkhid7YdbTG9sjuKSOXRg05i3mdMQoLvyuyobfI
         VFSQ==
X-Gm-Message-State: AOJu0YzQCgnUCJIWwKEG2SF3pvvKVq1JjOsvxrxDBPmTrTEwg9Fc57wy
	JY0GKPeMYLskvf6ascF6/vkDMvNmJz0AhkmA1n/6c8QWM/hHvU5N5NsJslK6pqQ=
X-Google-Smtp-Source: AGHT+IFGR9r99HJE7DQeQZXr1YOwwDxduMFfkDo90GDDsOOblr8csu3ww1+fSvm/uT4KLESekErhUw==
X-Received: by 2002:a05:6808:650a:b0:3c0:3e27:b122 with SMTP id fm10-20020a056808650a00b003c03e27b122mr1273092oib.39.1707745489408;
        Mon, 12 Feb 2024 05:44:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUuODdFqYOxs3shUrxfjF20Q5OP5KgiYqXfaW9qGZ26oFB+YjdxhFIR11ymkSOn0GJ+uY4cO5Uqanl4Fkvjby/2kJylAJPjfUWOVRo8tRQzejeVVC+YQY8QJaiViARy3zC6iz+zG2K+5+blbybY3SaKScl/6A88S+6z4kY4N2VUWcAw4ZYyogeK6f136AipGMX1qGcsUS74ahs=
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id dj9-20020a056808418900b003c03ae77e0csm51778oib.51.2024.02.12.05.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 05:44:48 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rZWc4-00Gwv7-4x;
	Mon, 12 Feb 2024 09:44:48 -0400
Date: Mon, 12 Feb 2024 09:44:48 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Ricardo B. Marliere" <ricardo@marliere.net>
Cc: Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] vfio: mdev: make mdev_bus_type const
Message-ID: <20240212134448.GC765010@ziepe.ca>
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

