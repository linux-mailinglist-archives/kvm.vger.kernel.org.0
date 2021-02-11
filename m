Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A207318692
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 09:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhBKI4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 03:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBKIzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 03:55:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DF4C06178C;
        Thu, 11 Feb 2021 00:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WX5NVcUKIZdIhUtjWwyjBX7wtfkyAwPXoU6ZUKSIU20=; b=i8dCZRiAerXp1eu/98vB7FHRAH
        J7eS5IStBD5ibU7/jWtadyzfhnylL0wyNNDA1llX8hc4ZFpvdkaflXww6qtxbMqWFEbkHABBBT/h6
        72n5ERCPHoUqJtJa/4f5xZVWv1bHi9tCLn0z6ASdjwvDT/63IEvB83LJfAeatnnF137C8Wv1uAVnq
        wjEWwlyyfAtgFe9f75aqKYSHoAbe3aR53WMjhUGc8Aq5KoWRdTfcGhOahgfKcn31Ltqp8VoCG6lv8
        k4ffkSxFc24ISbbhXWzmnIV3YQJGmuxncd/ME6qYMnH3iR73CE7WOH+FoDerPPdbcsBNNRz/Mr17+
        ZhCK5+bQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lA7ct-009zVJ-LF; Thu, 11 Feb 2021 08:47:03 +0000
Date:   Thu, 11 Feb 2021 08:47:03 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211084703.GC2378134@infradead.org>
References: <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
 <20210202204432.GC4247@nvidia.com>
 <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
 <20210202143013.06366e9d@omen.home.shazbot.org>
 <20210202230604.GD4247@nvidia.com>
 <20210202165923.53f76901@omen.home.shazbot.org>
 <20210203135448.GG4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203135448.GG4247@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 09:54:48AM -0400, Jason Gunthorpe wrote:
> If people are accepting that these device-specific drivers are
> required then we need to come to a community consensus to decide what
> direction to pursue:
> 
> * Do we embrace the driver core and use it to load VFIO modules like a
>   normal subsytem (this RFC)
> 
> OR 
> 
> * Do we make a driver-core like thing inside the VFIO bus drivers and
>   have them run their own special driver matching, binding, and loading
>   scheme. (May RFC)
> 
> Haven't heard a 3rd option yet..

The third option would be to use the driver core to bind the VFIO
submodules.  Define a new bus for it, which also uses the normal PCI IDs
for binding, and walk through those VFIO specific drivers when vfio_pci
is bound to a device.  That would provide a pretty clean abstraction
and could even keep the existing behavior of say bind to all VGA devices
with an Intel vendor ID (even if I think that is a bad idea).
