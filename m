Return-Path: <kvm+bounces-17763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E6C8C9E96
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:07:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500591C2216C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC95F136991;
	Mon, 20 May 2024 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nzXujvLQ"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BF45026;
	Mon, 20 May 2024 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716214037; cv=none; b=fFo7hhFcbhd1TaQsgNdI77dvKPpl6U+FuCuvuEjnHVqi7kx0uwVC3eQUB3aZePmaLiePnohksU7X+mOaxBvQ7DEQITkAV4Bqtqr6OypZwlMi2S7di6UKqvibEtBg8nV13eSyPBbn1lsiQUHTWACFwCi9fgTrisKQWMNw6evzta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716214037; c=relaxed/simple;
	bh=w4T6LcRjlCHTTZIBTqyyyFIHQt2VX43DOdStKH+dMjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFLWUfJfl2p/+J2Y+7xaEqlIwqSFkjQ+OTWrEYjESxf7Q+nENKnl6qVLNDoX++mHDgKtR+rwcI3tCNexPZucW/KbS+J43TDreVjnVXhsZ3BwHWGonZdE2IZwNibmR3KIWJc+xmVq/DW39FVSHivMCu8ILj32qsgVRnM5sYRDk7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nzXujvLQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wpWEoUMWnFLJr+MkLtPIZ/EXAlokieryuSaCz8a6I3M=; b=nzXujvLQghLXfJUbZl0u3JiQ/V
	njxgWrULaemEv1rhjj7uGwTNzAM865guFORckfkd4Elr/e93FJxZ7xTyAiIdHg5YdZ5fZ5uXnfPLZ
	CkqyBZ+Fnjku555e7eD3RcC1Zsq4vNK1IowWSRMEcMyM/9W+5QQhEQob/6fQ6CZLxDh8rF+J2mz7B
	ne6Lxk1tkPc4pO11ZuBp7Vn+3Cjy+Gsmh1kKjw1cn5zxMQmGVEIK5F3Q+mhhHaOwFlPewXynlVCI6
	yLaq/aRiNH+FsLzpdW2E0VFX3q2kB5KFtFAoFVn5xw4OdNAZXy5oqxQlyYTJG9vVi3+f7x+gT2JRa
	Z5hYlxBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s93fS-0000000EfNO-3kiZ;
	Mon, 20 May 2024 14:07:10 +0000
Date: Mon, 20 May 2024 07:07:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <ZktZDmcNnsHhp4Tm@infradead.org>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507062044.20399-1-yan.y.zhao@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 07, 2024 at 02:20:44PM +0800, Yan Zhao wrote:
> Introduce and export interface arch_clean_nonsnoop_dma() to flush CPU
> caches for memory involved in non-coherent DMAs (DMAs that lack CPU cache
> snooping).

Err, no.  There should really be no exported cache manipulation macros,
as drivers are almost guaranteed to get this wrong.  I've added
Russell to the Cc list who has been extremtly vocal about this at least
for arm.


