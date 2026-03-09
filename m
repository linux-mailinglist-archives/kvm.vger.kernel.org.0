Return-Path: <kvm+bounces-73324-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMK1FMzprmlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73324-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:39:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E206B23BDEC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3DF5B30579EF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C0F3D9054;
	Mon,  9 Mar 2026 15:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sa8EL99P"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74F82222A9;
	Mon,  9 Mar 2026 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773070409; cv=none; b=ppFXPo+KguOZMJAg3PwebV+vsJp/61fNnzdJmzwLigt0XW82beKrsVjTv4/S5g5ZuwaVKg/mtIzAh3wBNbOUabs1F+XT1n+xMuoB2YDMU7aJlp52IEFKXyNRFx2e/Tx2DvFaGfyeeSDMO516u7YqMfMf0llRNLxroFdhbISRFhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773070409; c=relaxed/simple;
	bh=aD4Kvtq7MFHFOf563GxDjJW7WigBUuLJJsMJDmUv1Y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvOIOZFExAtYIW/tvhODQAVTXc6LowyC/fQXxG038ZwQH7pfLUt4vqjSCEhge99YBPV5wFc0TOWhrrzIUPxsq6bmVQ5Iqtuh/jCFYWTKxJfOyYJhQQN+4u6yMI6af8pC+VXEYo2ZNrLamHOkIIo5rcWcM7bvLWFE1woHM4vzUTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sa8EL99P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pp4urnCi3IeTM6CGI1j9gUGdpbRv58OD4sLS7m/YmFk=; b=sa8EL99PTk5jodZyOPf/tiBXzc
	j6HMZcBoPsL/mZs/0GCN1f3JSPORGalqrWjqGAG5Q62IuvW3sRV3SJl7fPz7syjDK20eSRfeGGwo+
	02pgXbN+UktlrmioYNMVAyBFRbIcikAEa8WIvD2mnQS+oHASgnk0ODcg6Ypdly2lgV86hJGjvwrIJ
	9fa4+vVqODzlpkKT8p4YyeYdLHmEWksgYoXx7fv59k4wZhVBYA+yQKNOTQ/rtEE0tg4oo7upfuxp/
	9DFbtEfgEcPMN/3cU4MxYO7oBliTj3yGdTQTVR8Q00CgaguiBM0Yra3bWLD4t+dhivj3CMWI9dyQq
	cS2n56og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzcbj-00000007cEr-06XI;
	Mon, 09 Mar 2026 15:33:23 +0000
Date: Mon, 9 Mar 2026 08:33:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: kwankhede@nvidia.com, alex@shazbot.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, malmond@meta.com,
	kernel-team@meta.com
Subject: Re: [PATCH] vfio/mdev: make VFIO_MDEV user-visible in Kconfig
Message-ID: <aa7oQ8ony-5sGEFY@infradead.org>
References: <20260305233526.32607-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305233526.32607-1-jp.kobryn@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E206B23BDEC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73324-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.949];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 03:35:26PM -0800, JP Kobryn (Meta) wrote:
> From: JP Kobryn <jp.kobryn@linux.dev>
> 
> VFIO_MDEV is currently hidden and only enabled via select by in-tree
> consumers. Out-of-tree drivers such as the NVIDIA vGPU rely on the mdev
> framework but have no way to trigger its selection.
> 
> Add a description and help text to make VFIO_MDEV visible and directly
> selectable.

Just as last time:  no.  out of tree drivers don't matter to the kernel,
and add totally pointless user visible options for them is of course
a no-go.


