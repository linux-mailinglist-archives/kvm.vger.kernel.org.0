Return-Path: <kvm+bounces-11110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 315918730EF
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 09:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 633771C240FA
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 08:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233315D8EA;
	Wed,  6 Mar 2024 08:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kM2SK1RR"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A28199DC
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 08:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709714393; cv=none; b=V1ox2m7D3J7XyDrkELO2y+eU1655kq1Zcs7CW2utWpfe5DA+ZhEw6L/5DgVWg3I26gM3dqAlM9tUuH4K0p/Ezi5WE2MXj1EjLNRz1PtgDLhDjBTP7vHBv2yS9Io1WF3M/6BrReO9Nz0Z54r7PDnf+gkJJWXtEeYYJ1Mhi5CFLkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709714393; c=relaxed/simple;
	bh=kSiViu/PNwEQ6CeKZ88X2MM/44fvA8higRaew3HJTkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEuZxCjW92dplfap9dlpw7+1fWAbfFXJ9cE94xqolmq4JyIVJqtsdZ33W1FJZy9QGWnNzKKDmysUcm8jXeSty12bPqQy2ijXWwnqHj2S96Nb8xpTZcQhn9HX1Qo1DBEoz7/14rAAqMtuImMsKShgtbz2Ca0p3QOSrMey53nrW+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kM2SK1RR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Mar 2024 00:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709714389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=esGonkOHKLwe5cJdl4RDMJ39QA6gaSTz6ugwpE4PceU=;
	b=kM2SK1RRAqE3BIYVmPqKxyr/Bn9blz228x8OZ9r6uiZH5LkalR/HNKJHi4g+M4GDYHgzAo
	QrKK+ALWY8fD3ewEfvRA1dFK1BcxQ6LdPRohhEqKlttCqHKRligQYvnDZqU9lfW8K8r7Rg
	PeWBU01QQwG5u8nxftuXEc6DG5qkrp0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, darren@os.amperecomputing.com,
	d.scott.phillips@amperecomputing.com,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Message-ID: <ZegrzpC-GODaO1yB@linux.dev>
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <Zebb9CyihqC4JqnK@linux.dev>
 <8e2ee8dd-4412-4133-8b08-75d64ab79649@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e2ee8dd-4412-4133-8b08-75d64ab79649@os.amperecomputing.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 06, 2024 at 11:01:09AM +0530, Ganapatrao Kulkarni wrote:
> Of course I know this script -:)
> I didn't cc since I felt to avoid unnecessary overloading someone's inbox.

People signed up as reviewers for a subsystem know what they've gotten
themselves into... or at least realize it after the fact with the pile
of patches in their inbox.

> I don't think anyone(even ARM) is interested in this feature other than Marc
> and me/Ampere.

... and based on this _presumption_ it's OK to leave folks in the dark?

> Otherwise this would have merged upstream by now.

Stuff lands upstream when it is ready, no sooner.

-- 
Thanks,
Oliver

