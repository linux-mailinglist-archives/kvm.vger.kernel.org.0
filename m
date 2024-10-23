Return-Path: <kvm+bounces-29463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD2D9ABF8B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 09:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4200AB26009
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 07:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2776815ADB4;
	Wed, 23 Oct 2024 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QGc97Ajk"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5291598F4;
	Wed, 23 Oct 2024 06:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729666701; cv=none; b=Wc6+QTgA/uNNvVJrma/vuuFmZtZ9zGne8IZWgsPmPoBQ980OoeLUj0xi8zuzno/RJKKaufF8wwSE2pT3ppP4PYopt5BXMFR2yGrxktaGsycasb2BTjMAYdOy+yrmGRdUo30RRjyPAsgOvVHXd3q2nNASsOnO3rkN4bGYVu+VbkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729666701; c=relaxed/simple;
	bh=6vN1RWTuulRIgIW2oChoUe8GtsBgQxYoedNj7Pzt7AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kpegGZJNXaqvRebW/P5zH0F+LFBxcoFPWpQiZGUK0MjkjjDRWJjT83vyttOLZ21l98hI9EafYakAzDz0GuaEK/VfB21GZf9oOw/0oljgv2vw26DW9d2rjptHxKLafBeVPS5mLoWg6wg784WaN3R3nIVJ8REJfm70iUIhUKHEIhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QGc97Ajk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6vN1RWTuulRIgIW2oChoUe8GtsBgQxYoedNj7Pzt7AE=; b=QGc97Ajk7Z48fswQIVyboXj00U
	WkWv3qOAM/7w0wkw2TBIJYfcgeZb3FMAxSo3lGTN9bviwxp2ZpBYLooV03qWGXqH+JV0s2xsK8cJp
	hKkOy2YuUJTl0irMFLDZHQZvhFNOiCtliSfRsQf/BgmnL1QlXu3kOdDKjGIDPAWag1ycgxkvUrhrY
	xRFLabG865iG0mz8PELDa3tqKMLoc2PTKxN8JvGmO9RjYiiqpdyjwn85i4W/TGcttv4Ty3HJuIL5L
	8iu7MxghoAW4HwFR+lzXBhZlCZ1Yu6YNNBaNrz1BPPVX4J9SpFN/vtzC3RUfdTL8TVAjnGvSfGcuw
	X3jxOcwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t3VJz-0000000DI0U-2rax;
	Wed, 23 Oct 2024 06:58:19 +0000
Date: Tue, 22 Oct 2024 23:58:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <ZxieizC7zeS7zyrd@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241019201059-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 19, 2024 at 08:16:44PM -0400, Michael S. Tsirkin wrote:
> Because people want to move from some vendor specific solution with vfio
> to a standard vdpa compatible one with vdpa.

So now you have a want for new use cases and you turn that into a must
for supporting completely insecure and dangerous crap.


