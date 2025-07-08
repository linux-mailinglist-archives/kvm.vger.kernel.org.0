Return-Path: <kvm+bounces-51720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC90AFC019
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 03:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5BC34A6082
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 01:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8E41F8755;
	Tue,  8 Jul 2025 01:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKCR0Vap"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6A35893;
	Tue,  8 Jul 2025 01:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751938655; cv=none; b=ntqomELVIkkGL1RRpBB2ZP05NmAFS98bD4c5F/7vmioSa88k2gykK8MN/QMQhp6Yb+u6A9Z7o9mJgRUaVR/C1a1aj4I79alokp/FMBcsgr5DmkEV3DfnWfM+vtZDNbtcuUcDhY0Q6qe5Oa6CjcR5sT6i2s4l6BkyWC5HfVZePNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751938655; c=relaxed/simple;
	bh=0/e0f/iH5qAnC0FrVkBoQWY70peX3hblYE56Ge41Mek=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrEf8ewJHVe8doVHmilKCAv1G2MFJQd/6k87GCpmPMHDTcNDbgGxkqxD7VAi9msrBpctFTyl96JJMYmajAaCMIfG/bjf6VZMlOZNbx0f1bf4x4eY3LG5OSIM6R/XK25OGb5rMXrjNAjOKhRYTN6PcVNIoL2bVvh517ofjo1sIbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKCR0Vap; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB00C4CEE3;
	Tue,  8 Jul 2025 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751938654;
	bh=0/e0f/iH5qAnC0FrVkBoQWY70peX3hblYE56Ge41Mek=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jKCR0VapSS1zGE4Tc+APcWxosUmIwqlOR9+T8vWqOFOu/nE7+JLgXkw7FdfEjUSkO
	 SiMK2VOcMAAQskVP9s0XHQqIG6V1kJK2TD+xQQixtEwAgRswaz3GVyfwd6btcPswkO
	 8bNp9z2vp4csEoYGd5sc5B0ztfjZf3VQ6qFI4qiaCY4sVS7rflmwUr5cHRRFW4n/YB
	 9nnH2LWWGmwykIljbhw5BijxupwiUTrc2RX30h5T1L1bPs+B1HbO3DcgII5cE49fhI
	 0zEZu1Q49UnHIx0GBsaKmUwGcw/6GKxil2gntz+fTOimLCq4yysVbcI/99YA0mHWuT
	 jLV/0nT8x10rg==
Date: Mon, 7 Jul 2025 18:37:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: liming.wu@jaguarmicro.com
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowang@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com
Subject: Re: [PATCH] virtio_net: simplify tx queue wake condition check
Message-ID: <20250707183733.4088e82f@kernel.org>
In-Reply-To: <20250702014139.721-1-liming.wu@jaguarmicro.com>
References: <20250702014139.721-1-liming.wu@jaguarmicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  2 Jul 2025 09:41:39 +0800 liming.wu@jaguarmicro.com wrote:
> From: Liming Wu <liming.wu@jaguarmicro.com>
> 
> Consolidate the two nested if conditions for checking tx queue wake
> conditions into a single combined condition. This improves code
> readability without changing functionality. And move netif_tx_wake_queue
> into if condition to reduce unnecessary checks for queue stops.

No longer applies, please rebase and repost if its still necessary.
-- 
pw-bot: cr

