Return-Path: <kvm+bounces-52643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6356FB07745
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 15:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EC9C1C28162
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851681D8E10;
	Wed, 16 Jul 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibrDkvIk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4A92F2E;
	Wed, 16 Jul 2025 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752673627; cv=none; b=kkpJkmWMgt2SUf9W6KmYz7OAP1zvaBKQie1Q4T4IS5W74El8ldzpBfRR5i1vGgsf1r6xRK9REO99alpKLAXp3Jo+px2Akgf4JBU362KHO1rfsGYHHppbXhfnedJbyIMxACqvQUqfh56aI711GvTV5jlVPfxMCBU9xFa/5/zoXXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752673627; c=relaxed/simple;
	bh=Pn0ENlp+JUUOVc3XntzvH3nvrbpKtaCgJfzspPRk96M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfypU+c4PJ9T0hZhM8Qqos/aCwDKwyxYVbFjYmpOrnWvRgKXZ797OWSQa5idMWrHHiqetoACMhisIzQVKu8LAaXSYX9l6VETLvrf/Sqysi/8F6qfzZvGkm2iK/kHRSyv37m4zl0wnU4EjZaG0oGlRy1hZDdsmYBF7Sh4a/MMvAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibrDkvIk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011EDC4CEF0;
	Wed, 16 Jul 2025 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752673626;
	bh=Pn0ENlp+JUUOVc3XntzvH3nvrbpKtaCgJfzspPRk96M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ibrDkvIkMTnjt0hV/+Q3noW6npECXe0E/F5B4FZaDtE9vq3U0xGhyUNYbQfN/BbFR
	 myYQTgaq8CHtn2K9N8jL/8Xsoq6Fp9d98xFKlEmjNoBMW+mG3ejQCs1mWknFWjAxwe
	 q473lsymK+Tvw1pZZSN4MgrsGfDsBkbnaGEhXjdiRw5+CxI5ypzhp/OvnIBBQGYQfw
	 ZJpRyqFTFb45BNIWIrCgxV4eXwi2J4UkNUDrS6NMDxeVvCY7KJMIFEXtLkn0JooRhR
	 KZaPQSRBoitRO4v+pCtCzZ0iUmEG32MjqKyaPo7WJVbajDacba+kLgFpNpr6wGFCqY
	 vzEKEEi9ou0dw==
Date: Wed, 16 Jul 2025 07:47:04 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-pci@vger.kernel.org, paulmck@kernel.org
Subject: Re: [PATCHv2] vfio/type1: conditional rescheduling while pinning
Message-ID: <aHetWNNNGstvIOvB@kbusch-mbp>
References: <20250715184622.3561598-1-kbusch@meta.com>
 <20250716123201.GA2135755@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716123201.GA2135755@ziepe.ca>

On Wed, Jul 16, 2025 at 09:32:01AM -0300, Jason Gunthorpe wrote:
> 
> You should be making a matching change to iommufd too..

Yeah, okay. My colleauge I've been working with on this hasn't yet
reported CPU stalls using iommufd though, so I'm not sure which path
iommufd takes to know where to place cond_resched(). Blindly stumbly
through it, my best guess right now is arriving at the loop in
iopt_fill_domains_pages(), called through iommufd_vfio_map_dma(). Am I
close?

