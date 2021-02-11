Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED6831866E
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 09:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhBKIif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 03:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBKIhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 03:37:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E7CC061574;
        Thu, 11 Feb 2021 00:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wg5fPTLM+1cZ9yRJ2/wT41q1NwpITJ04WaAL3iNvvr8=; b=CysCp9b6F7J9AuOhF4p35Ff0hh
        Ze5GD0f2KT/7rpHeXg+2xDlZJZvp2BYXw+/rFwdWOcCU9xVt9B5QI0LP8AZnfiXjPGizp/o/Ig+1L
        x/ztvT+EuNtLqfK3/Sq2jW1wB34ihHTsxf7rN/o52I8DFpT764V9KDdx+qA2/zS0aAzctrbigmHTY
        MWPEIWWDC+pUtGJali6xzN0ai9GU3KUSv3zYkJG/UE71tfdQk5QAyrLFyuDLZutAbSNMGzY3qDIGQ
        uoFy5PBAKb6Bi2P0PopaUcMRJy4IujPbSFaJdjeQeTnNgOO793QMQrp/9a+H6utei/t0v1ru0SVIj
        ccvvlAhg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lA7SX-009yv8-8z; Thu, 11 Feb 2021 08:36:21 +0000
Date:   Thu, 11 Feb 2021 08:36:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "liranl@nvidia.com" <liranl@nvidia.com>,
        "oren@nvidia.com" <oren@nvidia.com>,
        "tzahio@nvidia.com" <tzahio@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "yarong@nvidia.com" <yarong@nvidia.com>,
        "aviadye@nvidia.com" <aviadye@nvidia.com>,
        "shahafs@nvidia.com" <shahafs@nvidia.com>,
        "artemp@nvidia.com" <artemp@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "ACurrid@nvidia.com" <ACurrid@nvidia.com>,
        "gmataev@nvidia.com" <gmataev@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 0/9] Introduce vfio-pci-core subsystem
Message-ID: <20210211083621.GA2378134@infradead.org>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <MWHPR11MB18867A429497117960344A798C8D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210210133452.GW4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210133452.GW4247@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 09:34:52AM -0400, Jason Gunthorpe wrote:
> > I'm a bit confused about the change from v1 to v2, especially about
> > how to inject module specific operations. From live migration p.o.v
> > it may requires two hook points at least for some devices (e.g. i40e 
> > in original Yan's example):
> 
> IMHO, it was too soon to give up on putting the vfio_device_ops in the
> final driver- we should try to define a reasonable public/private
> split of vfio_pci_device as is the norm in the kernel. No reason we
> can't achieve that.
> 
> >  register a migration region and intercept guest writes to specific
> > registers. [PATCH 4/9] demonstrates the former but not the latter
> > (which is allowed in v1).
> 
> And this is why, the ROI to wrapper every vfio op in a PCI op just to
> keep vfio_pci_device completely private is poor :(

Yes.  If Alex has a strong preference to keep some values private
a split between vfio_pci_device vfio_pci_device_priv might be doable,
but it is somewhat silly.

> > Then another question. Once we have this framework in place, do we 
> > mandate this approach for any vendor specific tweak or still allow
> > doing it as vfio_pci_core extensions (such as igd and zdev in this
> > series)?
> 
> I would say no to any further vfio_pci_core extensions that are tied
> to specific PCI devices. Things like zdev are platform features, they
> are not tied to specific PCI devices

Yes, ZDEV is just a special case of exposing extra information for any
PCI device on s390.  It does not fit any split up vfio_pci framework.
In fact I wonder why it even has its own config option.

> > vfio-mdev is just the channel to bring VFIO APIs through mdev core
> > to underlying vendor specific mdev device driver, which is already
> > granted flexibility to tweak whatever needs through mdev_parent_ops.
> 
> This is the second thing, and it could just be deleted. The actual
> final mdev driver can just use vfio_device_ops directly. The
> redirection shim in vfio_mdev.c doesn't add value.

Yes, that would simplify a lot of things.
