Return-Path: <kvm+bounces-64594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 91859C87FB7
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 04:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EF90B354A14
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 03:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F14830E0EF;
	Wed, 26 Nov 2025 03:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIWNg9td"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDE71A239A;
	Wed, 26 Nov 2025 03:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764128523; cv=none; b=M3K3osor0nXjzPwPnz8aKB6ATzACMHV+AIE6LjOUdBFdm3H95MgMfTtjkXHw5ew/P/HhcLJPp7iMwOJatuHBm20HX1Pl00eJBtj0XJvNrbt0PylnNekiQH4rsoBj8EdewpctimLhWsP6/OAg7hIfgA6J3WQYMTNdkJXv1Um44gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764128523; c=relaxed/simple;
	bh=SPhDWiVuKzziBw2o3C4xt5XVjmfNUbxZ3JzyYL3Em5A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TmJo09xVw8Jo4QYVmF8gynAVAZqx/i5PqKhoM/k4RxDvw5xYVmHNAVaP9tQrzjGl+dD26iT70nP1k3Wv09NVtxlUcHRjWtnKjKg3LMj1pLMndWHhM3KGhi6iD2HzW9+9APM1/OOOjKbYdZ8d+krOE+bCBTJBPyIHzHe9wzptOsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIWNg9td; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D688DC113D0;
	Wed, 26 Nov 2025 03:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764128523;
	bh=SPhDWiVuKzziBw2o3C4xt5XVjmfNUbxZ3JzyYL3Em5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MIWNg9td3BiW0Z7Usiz++cJ9SRk/lxsb++rUCQBR2RfSEbTRkuSe7HUw0VEczpz+l
	 d2edplT3b4actAc2EIHebBxGTcDtCUBvB4nROW63F2EhZj/PONcjcLfaPNgSheKWJY
	 RG+nlpktN8CZi2LCDEavK4s0KVwJJOfPYbuGhsS4yjwg8dcWmHprjAd+P8GHwpDx9n
	 nDVX5RsvRW7DstMDdnhl7yF8F7ZXp6xc93WA/Qrc9ewCsMnb+ZVUEv0kODEhHQWdFs
	 5mH97aTsVE8+OfF+BI6ODlCVckqwiOCnxe/HfZJ0EHoq7flBzo7sSu7OYxbv3QZYWv
	 OOyYgSl0x5Log==
Date: Tue, 25 Nov 2025 19:42:02 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc: eperezma@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH net V2] vhost: rewind next_avail_head while discarding
 descriptors
Message-ID: <20251125194202.49e0eec7@kernel.org>
In-Reply-To: <20251120022950.10117-1-jasowang@redhat.com>
References: <20251120022950.10117-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Nov 2025 10:29:50 +0800 Jason Wang wrote:
> Subject: [PATCH net V2] vhost: rewind next_avail_head while discarding descriptors

>  drivers/vhost/net.c   | 53 ++++++++++++++++++------------
>  drivers/vhost/vhost.c | 76 +++++++++++++++++++++++++++++++++++--------
>  drivers/vhost/vhost.h | 10 +++++-

Hm, is this targeting net because Michael is not planning any more PRs
for the 6.18 season?

