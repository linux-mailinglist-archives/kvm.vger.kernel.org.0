Return-Path: <kvm+bounces-29048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE82B9A1A9E
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 08:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B0611F23A01
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 06:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D21817C213;
	Thu, 17 Oct 2024 06:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rMsw78LN"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA551779AE;
	Thu, 17 Oct 2024 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729145963; cv=none; b=kUziK+NBRbFRrpSX/Fx+NKWbJoaZFk5Q9Ra/MNu8ocafnAY5QZS6y+d7/rXiZYcX+JN5ZRuSqTAhRYVfofsz3DTLqXPrHz21MBw39Gp3rMKMisgcnbnpHbfUzujwnPn8mnuOCd1759etJXWcdFVIHMzpSDRK2S8SVvJo1IMmDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729145963; c=relaxed/simple;
	bh=dLlQ+uvki9JZnWSM4ozKPNHPAtPTrRMYxxs2H3DkD5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZ2QqnhTVTIis6MIXpuVt1LZyl0QxREFs2F3MHfWn0w0Z4P3RouRC6iHEX3l1EC33hOw8SMQYFGQvfngmhNVspjqXqlpJC3UQpZXnHFbyEbo8ml3Tckrf2HTMTlD47ANEFOVDv277EI5PwcLLKKxzLeC1DFKqomZGvhLS/Zmw8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rMsw78LN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=UmMwy4PArAU+1RMHo1HvKaM7MT5SR9w1d9MHHi8WJlo=; b=rMsw78LNS35MQnEBuk4ouEIqtn
	/60SRp0kpOlIgjyUZkQN3bdAuCgj7DPTh1qRH65/r1+6ywHTEe0oxqkOZDmg8C5u+D57mEtqCjMLc
	1nmER35UGjgU4loVw20Mx8567pUZ1DxaRSYNup4tUJfhPCbtLNG5NUW/xUmChCPtLqVqz04+Kpr1q
	QCf0ipKTmq4OjfkP4+DSKQWfiWY9KHzFMRhVNl4CtxN+UJXoMZ2n9c3rNjOFU4rTETUe8MWOqvyiw
	D4Y2jiW0lcVB9TCqP62Htxq998Z4pKYs9Gr6aYJQZg7RCNqROuMcDfZYV6L9krFp3exMifEFQmc5R
	N1fgPz0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t1Jqy-0000000DrGZ-14zc;
	Thu, 17 Oct 2024 06:19:20 +0000
Date: Wed, 16 Oct 2024 23:19:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Srujana Challa <schalla@marvell.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <ZxCsaMSBpoozpEQH@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 16, 2024 at 05:28:27PM +0000, Srujana Challa wrote:
> When using the DPDK virtio user PMD, we’ve noticed a significant 70%
> performance improvement when IOMMU is disabled on specific low-end
> x86 machines. This performance improvement can be particularly
> advantageous for embedded platforms where applications operate in
> controlled environments. Therefore, we believe supporting the intel_iommu=off
> mode is beneficial.

While making the system completely unsafe to use.  Maybe you should
fix your stack to use the iommu more itelligently instead?


