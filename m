Return-Path: <kvm+bounces-29607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3155A9AE01D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2881284EE4
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2751B3951;
	Thu, 24 Oct 2024 09:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rx+c0tEI"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1073B1B3933;
	Thu, 24 Oct 2024 09:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729760745; cv=none; b=b/B56qZgOlyMtzeP9w1ELzvl5jQfpUON4+mSIwMeQqknTbhvmUQApK0nYhsGKcU/SFpN69phvjPttdPadJrmfgyZQXqOCWYehhgtMvr+cYIeykj5Nwx+wkJd2sp3GoPmGwuzbF3+Ce089xDPNJawvV7ZRoQ59IpGfs9G63JIVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729760745; c=relaxed/simple;
	bh=iLBl2uqkzw7TXsj+7GQ+KZq3Axo7bQMOS0R0jqOfu60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pw8DyCoV40wELXTX+xmNTBdoazBtoNfWFwUYrsU0aLM7pf3tE8Ept8wzV+EnQb577i3Sjslk0F+ejqBbyHgy1xNAk81Q9SgiTcpd9GfafYnNO8LqU9BXj+DnnUKX4D5lEqvVQCjIFmGKiJdNpUuMgPSN63LLbw+9MCjWVBJxLG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Rx+c0tEI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W+xcl40+d2Ufw9544YoSrmVFDCb6kVciErHqMFvT+8c=; b=Rx+c0tEIZxo7coLNsWBdyt0SWq
	UKGh9Mf9mkwwzY/XdGBBjiIh2maXLa+oLD4E6yxVWQhkpUYHSvrX4BDjgqWcJ9OW+wXcJ4vWJJSqm
	HBqy4/bBKWYI/EkO9fJ45cQ9kc4lT7UjhsmnXAP7wmXwJcf8HCk4W1xSka3nFy0SGal812vASUJh5
	hplj0b0Wm+++l2Xzd947aSXrLbR72c7BOS4k+AAIt7nvcTYynSmZRDS7HNQZQ/vMYLMQo3WaMOXwQ
	VcVGsJ1klkqJqXlVn2nycljCNgmPmobO2/Y+EC6bXbO0RaYR+wmV+TIOjZV/rtLC0qFqyjHnExA/5
	f2NBrMtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t3tmp-0000000HOMu-2RXX;
	Thu, 24 Oct 2024 09:05:43 +0000
Date: Thu, 24 Oct 2024 02:05:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <ZxoN57kleWecXejY@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
 <ZxieizC7zeS7zyrd@infradead.org>
 <20241023041739-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023041739-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 23, 2024 at 04:19:02AM -0400, Michael S. Tsirkin wrote:
> On Tue, Oct 22, 2024 at 11:58:19PM -0700, Christoph Hellwig wrote:
> > On Sat, Oct 19, 2024 at 08:16:44PM -0400, Michael S. Tsirkin wrote:
> > > Because people want to move from some vendor specific solution with vfio
> > > to a standard vdpa compatible one with vdpa.
> > 
> > So now you have a want for new use cases and you turn that into a must
> > for supporting completely insecure and dangerous crap.
> 
> Nope.
> 
> kernel is tainted -> unsupported
> 
> whoever supports tainted kernels is already in dangerous waters.

That's not a carte blanche for doing whatever crazy stuff you
want.

And if you don't trust me I'll add Greg who has a very clear opinion
on IOMMU-bypassing user I/O hooks in the style of the uio driver as
well I think :)

