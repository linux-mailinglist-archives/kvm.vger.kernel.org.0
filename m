Return-Path: <kvm+bounces-43079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 396A9A83DA5
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9CA48A620C
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 08:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F3220E33D;
	Thu, 10 Apr 2025 08:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sRWlQV6K"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF99520C477;
	Thu, 10 Apr 2025 08:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744275233; cv=none; b=utRoK4DIRTAwXMSdoXs01zYhMptBHV7v/7zEOxVoWJZ4WOGUA3ly9qvvKpmEQKLXzOUkX8sGOIHFo0bXzdUfL6aUBwRRdPKvMbZL0BzcRGftxlrfb9bQnaw06HJqfLXjqdtLTGcVnSyKHj3rJQToMpb553Y5Li5HOANyoK22BuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744275233; c=relaxed/simple;
	bh=aCop2NCYxYQLVZbOYBztIuutt9Q6fjvbcLrSOou4TUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQMonWJTCSYCYujD8ygNr2c5B6okpUQPoszjEqHf/7w6Jb8xuT0guL7pXxEFwMytYlYdYVU9fe5VOBjQf6iSAGD1MDdUhaukQzbCE3PimalzuCA/xZypr/e+5scRzNU4DY60wZpJsT7HcBURKBm8+yahCLJJCCkqC+1trTHUno0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sRWlQV6K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RtxIxoigqQYXde/ahuxYdBARIf+SRXzUFP+gRfTCt0Q=; b=sRWlQV6KPBAfTa2WehVjjg2P/P
	BdlO2v11GQovoSXdWZ7/I7opo7BHxICY+Fy6ZBxuQ4KOvJvDC55PtmG1q9BnqQVb7t8Rw7NGZyWIX
	6KbWYQoBs1m6OH6ZIb4cF7w+eLwbnZvqc+Qz1xApMq5Y2p+hH3/rcyxa8PvmkGxqLrM/87jvV7GIl
	cXRHqJTFbj8WMVUrSJUQVO4jcnxwS11BnIS/77dxDgt+/IQC6TD6i5yqU2FiezVWAkENCQTaP5LRo
	nMokkXQev0D0sib3QU/VpKcS0arDC7C8APCAqKDdICycHQJKch3l3WhfAEQEshWeYp4DMGMtuKfGD
	IMtBiXqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2nfP-00000009pBY-04nj;
	Thu, 10 Apr 2025 08:53:47 +0000
Date: Thu, 10 Apr 2025 01:53:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
	chao.gao@intel.com, xin3.li@intel.com
Subject: Re: [PATCH v4 04/19] x86/cea: Export per CPU array
 'cea_exception_stacks' for KVM to use
Message-ID: <Z_eHGjzR33LMqLfL@infradead.org>
References: <20250328171205.2029296-1-xin@zytor.com>
 <20250328171205.2029296-5-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328171205.2029296-5-xin@zytor.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 28, 2025 at 10:11:50AM -0700, Xin Li (Intel) wrote:
> The per CPU array 'cea_exception_stacks' points to per CPU stacks
> +/*
> + * FRED introduced new fields in the host-state area of the VMCS for
> + * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
> + * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
> + * populate these each time a vCPU is loaded onto a CPU.
> + */
> +EXPORT_PER_CPU_SYMBOL(cea_exception_stacks);

Exporting data vs accessors for it is usually a bad idea.  Doing a
non-_GPl for such a very low level data struture is even worse.


