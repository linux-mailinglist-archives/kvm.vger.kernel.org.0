Return-Path: <kvm+bounces-13015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8351E8900A0
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 14:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 377081F25ED3
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38EF84FDA;
	Thu, 28 Mar 2024 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="G0grn7P+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5518E80020;
	Thu, 28 Mar 2024 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711633294; cv=none; b=m3LhZgXNe8R/HZzVzVntDDwenSjeVvyOFB9DxwzYpEWERWmRIEOft1dv+ROn3vxQB8OZQFMYodxLNhYpxO9XlmyyVt7JCxgn7dPqODa0iUlo6hWkKsgl6NVbQHyFd9tCW+6pQGtQdlqKiy+6W3MupyGTjZ6BSeNQ5OG1wdn9Fmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711633294; c=relaxed/simple;
	bh=JLro+ytMlRj5SZwocJl85+I0rVqXR5OQKDwZUUf2niM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPbof3zfRJHi6zuYgKgToTSQ5OYXWIn28INTyRl4D8W0eQjGryT8lacP+XNF6LQQ6pPSerRTb80MAmEHPuInNityLlBKR6DIrHHQPAVnEtTUP1/AY5eTCf/ADetD0bAjLZlH+WmOZ2nTwJuiI5IL2VkVmXOzKUuQYK+rbsxGp/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=G0grn7P+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DE7B840E024C;
	Thu, 28 Mar 2024 13:41:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4NgxidKtt6Gn; Thu, 28 Mar 2024 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711633284; bh=W93HjW3JrM1y0k7Mv6Ui5mqxj+SzjiQ4F361zTa73MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G0grn7P+qcyf9p2CWDp19AdgohpG4K0FhaamFZ1iXSN1yMugTViU3fYqIj511UU9D
	 beQdrdWXMu0Svx3oWfKOGzXPdIyYoDLdNtbeaLXwTO9fcSizjrdvCqq6mgeK4KNvNb
	 odtAwiFeNAiis+Xb4FJpDsEmOdd3jv5+UrUgi/t3tOVOOsy2ipD0ZRYrUUGZDTMAm4
	 Ebiv8KI1q8XVCE5fvF7nUUtmJB5afqJYv6GBqDaoRolrZVOxdaB2F1Xpy5ueP6Xotg
	 9CofXtbbHSTx2nJEfvgTh/rCEUZbN8Vyk3uFppA0SBW1iexFf2dR/jN8jOaqVmbZjr
	 vAtyDygfOtjahWMqZ+WAkn6SrCJttCcS2iZZnUzvnv7OOgqunPFRuQNbeXNVR6QGBc
	 FIrQiV8kxHRvMoOh4hup/COCvTt2vkgizhxqb69kA2J3no9EGmO3zaUbhM3G64+qpu
	 wztKR/HR95mVDMy5Wiw8o/NzBYvJWwJ1XDI5Wc2Udscg83wPbKZZk/58tetIuV/CpM
	 kWto73/tBB0yDcMv2gca3WyC1xRQB6bb2RUGK/dABm0rjMTd0IzAzGqat1oaZZKCy2
	 XbHUTVjidW3yfQ6StAgLvPC9/JmUHxuISluPNldrrcPlhwtU1IaGZEzTF6yisMft0I
	 SSftC5zR7syOL3lNYf9nDm+0=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 47E9640E016B;
	Thu, 28 Mar 2024 13:41:16 +0000 (UTC)
Date: Thu, 28 Mar 2024 14:41:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
Message-ID: <20240328134109.GAZgVzdfQob43XAIr9@fat_crate.local>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
 <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>

On Thu, Mar 28, 2024 at 12:51:17PM +0100, Jeremi Piotrowski wrote:
> Shouldn't this line be inside the cpu_has(c, X86_FEATURE_SEV_SNP) check?

The cc_vendor is not dependent on X86_FEATURE_SEV_SNP.

> How about turning this into a more specific check:
> 
>   if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) &&

Why?

The check is "am I running as a hypervisor on baremetal".

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

