Return-Path: <kvm+bounces-30973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FED9BF1FD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 765011F23CCF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330D02022F9;
	Wed,  6 Nov 2024 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fXeG2DLl"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BE42EAE0;
	Wed,  6 Nov 2024 15:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907957; cv=none; b=m5Wmslp2iL0qDWnGMu43X+RsSMehkBGlZhlbBoM1UhCHKW0CXmGKtdjVxTAtqJ3FMCooAJuRa3tV6KeP6b3iqT4BYQ3bCiGZc8zWCFCvzsWaWhzOWUdxNigUwiKBTtKjKfExlkdnYHmcSd1tpMvTdXeDNwkwl8hod1NX1yadC+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907957; c=relaxed/simple;
	bh=vwmdwh9p0MkC8M3txKwd05mOaAC7dFJH8WNu6iNevo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i98KLOcD/vTfMX6B+oixeanA4l2nTgONvghZVc/fHiSiUhHh4Ym38TFdXmV5QsqiIUGA/fAMyO8p1VQHpBwT8cHGTZIqtx1Xrh2zHVlh8SHETNkUyH1QqNsvY2/moNAIqa9ql7y+d2JKdqVkL/03T59Wmdhltp57fN8CmIfeN+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fXeG2DLl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wyQu6vowSRFmkW1quebGYzpajWeL2fiYU3+PvoZUQlc=; b=fXeG2DLl+Aq9S30LzjI6tdZM5n
	4y/6TXuliWDLEehkumnvXwWbUAhv7eF32g/m053D7wJ209SiuwkYhdKNKyzEKzB7lbU66cFIk0qaI
	K9VoLrViDgxfDDtVGJFfDa6gUIRQtO4qKGW0gLpVlseY1TnQSUwCLzQunwp0sW2uokQFY35EKjz7/
	4S3qm/vPZPqNT8bNrXm9KDvxfBDFBxV8N+XanRpP+3zJqis6hlE7VDaJsUiEDbBy+7DdI3JKJCbWb
	zoBplHJ9Qco6SphCd/PQqOaE01ahPruhJoOAyWbVnQTDL9otD8pPsF4lSdJdD1Y9UxDLAkcj/nzp2
	hyiukz1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t8iEC-00000003sNS-1QqQ;
	Wed, 06 Nov 2024 15:45:52 +0000
Date: Wed, 6 Nov 2024 07:45:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Srujana Challa <schalla@marvell.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <ZyuPMI-VOp8eK-dP@infradead.org>
References: <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
 <ZxieizC7zeS7zyrd@infradead.org>
 <20241023041739-mutt-send-email-mst@kernel.org>
 <ZxoN57kleWecXejY@infradead.org>
 <DS0PR18MB5368B1BCC3CFAE5D7E4EB627A0532@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR18MB5368B1BCC3CFAE5D7E4EB627A0532@DS0PR18MB5368.namprd18.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 06, 2024 at 12:38:02PM +0000, Srujana Challa wrote:
> It is going in circles, let me give the summary,
> Issue: We need to address the lack of no-IOMMU support in the vhost vDPA driver for better performance.
> Measured Performance: On the machine "13th Gen Intel(R) Core(TM) i9-13900K, 32 Cores", we observed

Looks ike you are going in circles indeed.  Lack of performance is never
a reason to disable the basic memoy safety for userspace drivers.

The (also quite bad) reason why vfio-nummu was added was to support
hardware entirely with an iommu.

There is absolutely no reason to add krnel code for new methods of
unsafer userspace I/O without an IOMMU ever.


