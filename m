Return-Path: <kvm+bounces-22965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C27F9450D7
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1FA9282E88
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4371BBBE9;
	Thu,  1 Aug 2024 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUylvfyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5A113C9A3;
	Thu,  1 Aug 2024 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722530120; cv=none; b=aEqWwZf1rwKtOIBZWYO1PcR6PteCUBEm5jlY+g6HoZh0G5fTaGOTvjN8LqBUlEd/IfwvrMSN1dx3y8TTk51NwY6xp7PIa435EN+l0vv+bKhJukJ4DiUlCcTSBf9q0MJ1oco+lbYb5gV4r0cPPbMbiZmy2BiJB4MrU2gO2ppL2hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722530120; c=relaxed/simple;
	bh=epQcZml1KFHD/cAYF1EPI6sbtGZHn6QCLdxUDPlEPdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkcGwLMgSnNdHM5lkd4kdhadZhPSykXyvFQQNrgP+oZWe77t7Iy17akndFpQIa0svLwwG55imZj4WXgEuzlNnn5b8ofE93WjQ71xY7tNqhPLQ2YxWTOUKL9B7jFNWydfq1mrx3tR95+b5J2mcOpx80i1h+EvWOCm6Er9pvdiRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUylvfyb; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2cb55ff1007so4798843a91.0;
        Thu, 01 Aug 2024 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722530118; x=1723134918; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/T4t3jzF+nFkAWEOEP+qO2FrWc+IPdqT2e1MH6ST1k=;
        b=QUylvfyb8XAnyKXaEd2MIERZ62ltDf7QeKrzVfo4nroX8iAM5+W/dRkzk9x4blEfH/
         V+yw5LJPUrQ9eMTu3Xjf73tgwOzI95OLLZRJD6Tq9ImiL4wcSvUUVeekkSvCteVA8dFd
         Zxdicn/90qCGGo82d1zIayIjnc234ZTTxAP+TTSKqNM8OE/ZVUGJsTLGsnUTWmirRuAN
         azsmHIWEbx+5YqTuGQh8yElfFKA5LYtWZGbANlgLiave7dFfTvUcLxp3Q/svuYH2e95j
         9tc69xI7gxRifciW+RelXSa+aUYeM3joduoX2HDwp20fcDGJ8F35IxgpIVx1e1SSsWKA
         ZB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722530118; x=1723134918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/T4t3jzF+nFkAWEOEP+qO2FrWc+IPdqT2e1MH6ST1k=;
        b=kf+arfJSWHSauaZ7Eff4UfCd9qbGWOf/EwUecAVofmXOx+PMDFYku2iiQMMgsF7HBd
         HVG50qQXlN8NcUZRyYgC3u0Yi7S+oQnw2gFwc5No/wNfE1piEgjdGIzR81kZwgdIDdoY
         /bywOGGS+g/WvWHKZDJ5AAY2dbLx1+PxW4JpvQgNgHKiBZn5Ht3hcceBbGm+XLdR4DE8
         ydQRhzpHb7Rqc3x0MNXegljzMD4wC/NjnSkHUnhia6EteOG19Sj+GVvfd2saUwlrNFkV
         JYBfjGOb6e5HDv2u0yeoC1YrVxN9E9ERvi7jja0MWeQZsLNsByn0QhNUrEHI85H0s5Y5
         jIRA==
X-Forwarded-Encrypted: i=1; AJvYcCWOfUADt4SHN8UpCjMy2ERu7bZJepkuBJrvq4MeEWERyV0nnUP+CBe376FCUbSJs9oYwYXd3ESVlJI/JBtZ5pXZDSpl3YwfMDgM2Y/NLuEA9LXUYgOLEnUPsEEgbe5wXsjAKAOgScOzjguVHX9L+0edMUAzhq0USK5L
X-Gm-Message-State: AOJu0YwOqf9ld+XCiEg0RA9x+Z++Yq1K8lOwr/3R+yEeENa/4cLWPtVF
	caKCOcMzutxlwzN6Soxt+7wriCg7xz40oXMnryh9AUgsVQ0nxltQ
X-Google-Smtp-Source: AGHT+IFPzIKAAGtrIboS0JIgBIcn/RCGQZX+i6sR6dJvOvCnViybU/zZEgesDQpsFrg3VVwYreSuHA==
X-Received: by 2002:a17:90a:d34c:b0:2c9:80fd:a111 with SMTP id 98e67ed59e1d1-2cff941b716mr996111a91.18.1722530118409;
        Thu, 01 Aug 2024 09:35:18 -0700 (PDT)
Received: from localhost ([2601:647:6881:9060:dc43:fce:b051:e6e8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cfdc42f9d3sm3599577a91.18.2024.08.01.09.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 09:35:17 -0700 (PDT)
Date: Thu, 1 Aug 2024 09:35:16 -0700
From: Cong Wang <xiyou.wangcong@gmail.com>
To: luigi.leonardi@outlook.com
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v4 0/3] ioctl support for AF_VSOCK and
 virtio-based transports
Message-ID: <Zqu5RHO2x+1uLmeD@pop-os.localdomain>
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>

On Tue, Jul 30, 2024 at 09:43:05PM +0200, Luigi Leonardi via B4 Relay wrote:
> This patch series introduce the support for ioctl(s) in AF_VSOCK.
> The only ioctl currently available is SIOCOUTQ, which returns
> the number of unsent or unacked packets. It is available for
> SOCK_STREAM, SOCK_SEQPACKET and SOCK_DGRAM.
> 

Why not using sock diag to dump it? Like ->idiag_wqueue for TCP.

Thanks.

