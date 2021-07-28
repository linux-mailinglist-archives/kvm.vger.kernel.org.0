Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B653D8DD4
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhG1MaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:30:01 -0400
Received: from verein.lst.de ([213.95.11.211]:53516 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhG1MaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:30:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3B55E67373; Wed, 28 Jul 2021 14:29:56 +0200 (CEST)
Date:   Wed, 28 Jul 2021 14:29:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210728122956.GA27111@lst.de>
References: <20210721161609.68223-1-yishaih@nvidia.com> <20210721161609.68223-13-yishaih@nvidia.com> <20210727155440.680ee22e.alex.williamson@redhat.com> <20210727230941.GL1721383@nvidia.com> <20210728054306.GA3421@lst.de> <20210728120326.GQ1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728120326.GQ1721383@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 09:03:26AM -0300, Jason Gunthorpe wrote:
> I'm not great with kconfig, but AFAIK:
> 
> - It controls building a module so it needs to be a tristate
> 
> - tristates need to be exposed in the menu structure

select can be used on tristates perfectly fine.

> - As it builds a module it also has depends on other things

So the dependencies are:

 - VFIO - duh, yeah, anything vfio related needs to select that.
   But this is a perfectly fine transitive select
 - PCI - yeah.  But we can expect everything that selects VFIO_PCI_CORE
   to select PCI.  Or a transitive select would be fine again
 - EVENTFD this is another classic transitive one that should just be selected
   instead of a user asking why it is not set
 - MMU: I suspect all of VFIO and thus the menuconfig really should
   depend on that

So not really an issue here.  VFIO_PCI_CORE really is underlying
infrastructure a user should not care about.
