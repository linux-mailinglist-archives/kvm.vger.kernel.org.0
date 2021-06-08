Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6941139EE97
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhFHGVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHGVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:21:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCCEC061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 23:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MTyreAeZU0J5iUrW2vbgikylX3XWetzWPvXuALH2ow0=; b=vfPkPDPjQ6i9ySnhgmXJ+v15pd
        pMo/2ck7g4VYmmV4MXVkHmU2MOb1B9IrhprEmid5sI7eoXrahCiwEP06Oi6flPk/GRe05MAsELpAV
        GRvp/F1Bv5XoTvtOtUxSkNcuLsqsJ3+j14po06UUiwGkB5n/QXHCkjb13CbC46IfzF9Qeizu6mTxd
        NxGbidWyhSVTaBLRJ/NI9qpT3lpXb5/WVyDQRZlJlaLil7D8d8J13+9DeY1vWMS3POYozt7OpgGZn
        J50ezH2KfvgbEvbtGn88NroWWsyMGopImLmVCkrED3+IOdhg/pVXaxKFsqrVNsl5ULfivfciGQlM1
        Qq6PZQ0w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqV5J-00Gcqt-Tv; Tue, 08 Jun 2021 06:19:36 +0000
Date:   Tue, 8 Jun 2021 07:19:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 05/10] driver core: Export device_driver_attach()
Message-ID: <YL8L9Vgy1FDGUypL@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <5-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 09:55:47PM -0300, Jason Gunthorpe wrote:
> This is intended as a replacement API for device_bind_driver(). It has at
> least the following benefits:
> 
> - Internal locking. Few of the users of device_bind_driver() follow the
>   locking rules
> 
> - Calls device driver probe() internally. Notably this means that devm
>   support for probe works correctly as probe() error will call
>   devres_release_all()
> 
> - struct device_driver -> dev_groups is supported
> 
> - Simplified calling convention, no need to manually call probe().

Btw, it would be nice to convert at least one existing user of
device_bind_driver to show this.  Also maybe Cc all maintainers of
subsystems using device_bind_driver so that they get a headsup and
maybe quickly move over?

> @@ -1077,6 +1079,7 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
>  		return -EAGAIN;
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(device_driver_attach);

Ok, this means my earlier suggestions of a locked driver_probe_device
helper needs a different name as we really don't want to expose flags
and always return -EAGAIN here.  So maybe rename driver_probe_device
to __driver_probe_device, have a driver_probe_device around it that
does the locking and keep device_driver_attach for the newly exported
API.

The kerneldoc for device_driver_attach is pretty sparse, it might want a
little brushup as well.
