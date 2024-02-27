Return-Path: <kvm+bounces-10096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D6B869A63
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD320B246DC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646B2145B07;
	Tue, 27 Feb 2024 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lt+G1Tff"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43C8145321;
	Tue, 27 Feb 2024 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047746; cv=none; b=elQiqqfWRVp1oTaBosQKXJy8DIy5BMTeP/vBfmPVlxsdD4FDwGMZrI4uLUD3+OpMQocqkNmq1Onzm/WGsBx0dgHrRYSE0GA68lWpCstVpNlc7dpAhqZL/iCtBrTu1fYLKk/fB7NGMdS4bUWaKSHy0ckuppyYJJXlC4ywfZ6pitk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047746; c=relaxed/simple;
	bh=DH9qtvg5WfaxD59IE3Xlc/6PI70KjeJ1UtHDkSZXgbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBEf2OhycJnmzkwiA3IntUPGpbN4gOXfSuOJg0Notvw2PkzyaMd9JgKKmxbgknxU3PEij4EEzldRja9gX6ve0pBfs39aRGExtPHYn5XmR+DnQVN87W+msRjvG3ltCWq4SvYqb2OIkMur0dnuObprCXH3pknw+p9vp4b8LyJB/no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lt+G1Tff; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7Fvhr2XhN7ulIRI1917z5nzuJS9iqQElRa4UgtdMSvk=; b=Lt+G1Tffix+R2oF/xiTokOujqQ
	/z1GMFcTeSV2u8AGVEXM519jHILiqabPSBRLIBtiwb60NXbH9P3ZF/vURWDtPY/YtInJxttyzNInx
	MQR6LliVhaM44VeC4Cwqd1D2ynagyuLrRe3HsLYibAz8h7Irk2FLWdI2w/ArpywtaYr+FsMHxRbvs
	xowlxVbgRgtMBpdc2UFpyWqefsKtgpSSzzdDm+wzk96Uig3lfgVr6UJDZGcOwP3gQx/aB94Y1AkKs
	fdg/NNVAIAB4pURVWQfz5duyDy7mwRUPH+7na2rJ/RrsZ7uQh8GzD6Xdz9/mR3GkB0prTdInx2uRZ
	x8cO05WQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rezOA-00000005mat-1DeK;
	Tue, 27 Feb 2024 15:29:02 +0000
Date: Tue, 27 Feb 2024 07:29:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yisheng Xie <ethan.xys@linux.alibaba.com>
Cc: alex.williamson@redhat.com, akpm@linux-foundation.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] vfio/type1: unpin PageReserved page
Message-ID: <Zd3_vjbfN6jTiEz5@infradead.org>
References: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Why does it pin a reserved page?  It should stay the hell away
from it.


