Return-Path: <kvm+bounces-60892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 121BBC0209A
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF93550923B
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 15:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E913831AF0E;
	Thu, 23 Oct 2025 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="avSsCJpg"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BFE320A1D;
	Thu, 23 Oct 2025 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761232118; cv=none; b=FVm3Z7FdN+WstMRsztzi84eHPDwNAaN+znCd3NBX0GtyhiQWiTbGmRbAggqJg1uqxGc5/ynqh+jzBlYxLMKD4yHx2Du5tJFaupn5dNlOgWvgDK8UrdK54MpFlbUyHSo3mrGFwESdWyulFm9w517U/w+1S9n0XxXsGx8zYyL/mF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761232118; c=relaxed/simple;
	bh=7tB3X5RSOKBgMzA7Vk5D1Py0bompEayS9GxtLYhIrpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ned2abix8UY8hBELZh/n9Gc8HweZ7VV5uP8U1tb3K41Wr4tYd4OS2zst2aoekPvXWVtRtW+O5PjM71+JLadHyzhNm72JEo40vf2UwjHXJIyLKc4Ob4c3ee0fvwE9W0IljEgra086gWc90Hzu3ZnOzuweTW2eNz+UoO+7mE504gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=avSsCJpg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vUd9iejmQ3YIoCZIrpCmvS9LgqpBQbgMRVezSirRowk=; b=avSsCJpghnTcVUnnYsy1KPz7Bm
	VaZgVYc8z5ZU2TlVYuBcoicMDzu9qYYyJ1KfbbjeantAq42rZAidTQgctxDU4mpAro4+7lxelHELv
	VIgMiVehJvaADt6ZMF/Zk8uyw6sc0AKJ2P/JMlp/QLDgUDWVGrXFklP5TMjb+lrFrMJkPrYvAeNug
	dtIse1769tluZFc6HCS/t/KzBV1vxwpuvNtUP4IW4LFjtZtK0bY6qigApTtCMaQ8vjc2eyY9q57Je
	hUn9HIha4lueegkCHrvS5vSWqj9xhMwfcSeWAxVDlgC/lJBxOXkcslMPltiwmlGY+0lAvuGHOS59+
	GpYzmPeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBwvZ-00000006hj5-2ZSu;
	Thu, 23 Oct 2025 15:08:33 +0000
Date: Thu, 23 Oct 2025 08:08:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Cc: coconut-svsm@lists.linux.dev, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, qemu-devel@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, Thomas.Lendacky@amd.com,
	huibo.wang@amd.com, pankaj.gupta@amd.com
Subject: Re: KVM Planes with SVSM on Linux v6.17
Message-ID: <aPpE8emZ9n4N7S-T@infradead.org>
References: <wmymrx6xyc55p6dpa7yhfbxgcslqgucdjmyr7ep3mfesx4ssgq@qz5kskcrnnsg>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <wmymrx6xyc55p6dpa7yhfbxgcslqgucdjmyr7ep3mfesx4ssgq@qz5kskcrnnsg>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 22, 2025 at 10:35:28AM +0200, Jörg Rödel wrote:
> Hi all,
> 
> This morning I pushed out my current Linux and QEMU branches which support
> running COCONUT-SVSM on AMD SEV-SNP based on kernel v6.17 and the original KVM
> Planes patch-set from Paolo.

Can you explain what this alphabet-soup even means?

