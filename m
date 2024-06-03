Return-Path: <kvm+bounces-18671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 067798D8555
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 383B61C20F4E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893FC12FB2F;
	Mon,  3 Jun 2024 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNlsI0Mx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB74912FB09;
	Mon,  3 Jun 2024 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425821; cv=none; b=eREwkYIh/tyjRDtss0Dr/FoiBX4hpoZ50/0OyyOP3b1lWXj3akYwzz49rQ95uvpAAKhl0Nfu+9RCw6Eq2BBCkPnEyFRJN54K9EV/4AcKUts8RE6YsOtwtb1kdpi7WUugvgyrpEaNo8SkXAthiioc4xXk+wDFdVLkU5QqhKxlIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425821; c=relaxed/simple;
	bh=QOCguvWutTzPzURXi7UnaHBKvkWN5M+ynPtQXkH2U/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNRudvMNmLfQzh66sKiZfgV2QjrtqKQCzzjEYTio9fbUMpy0+OeBK9BgO03jB5gxLsFlcwiAdTIS50vBXb2CvPAtv4GH94NFYElq51aU745gmGCl1mOSXjH+x9AoJK3rO9Ffvd2pDVH3p1OTxBlJXCL1JxrnEImBH3cBlpW07eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNlsI0Mx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9175EC4AF08;
	Mon,  3 Jun 2024 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425821;
	bh=QOCguvWutTzPzURXi7UnaHBKvkWN5M+ynPtQXkH2U/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNlsI0Mx2TPI7CzXeIC7uiYd9aPVj49beNcqzDmapLFHBht3FtMQCRFPjHd4WQnqy
	 uHO62rMIx4GyW90NsO9KbR2ECq6irZDgjczYvNKHAWVWcT0RBoeI2CUkFLewttAkkY
	 VEwFBDDBxbtPgK2ze8pF6GjoYzGrHGqvjJXcG/6hRT3oJ2zyrCUhJFMpJMGM52FS01
	 hxA5OQp33xqTPGYVovvKSP/0kcbrMBV3VuwkLnjNINniuTEdiH/wUhE4Leu5aGO6A/
	 uMQqdCxe2Qxmmzv1Yv5M6rhHMYCFxX7jE1O4NgkOXU0GhddLI8FN5XthDua4qBX9gy
	 JupfDjYqGS04g==
Date: Mon, 3 Jun 2024 15:43:36 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 09/13] KVM: arm64: Introduce print_nvhe_hyp_panic
 helper
Message-ID: <20240603144336.GJ19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-10-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-10-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:15PM +0100, Pierre-Clément Tosi wrote:
> Add a helper to display a panic banner soon to also be used for kCFI
> failures, to ensure that we remain consistent.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/handle_exit.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

