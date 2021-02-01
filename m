Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8A530AFB0
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 19:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhBASoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 13:44:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231402AbhBASoH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 13:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612204959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gK4DMTFCpUGprBzVCp9eTqWhhzAb26o+GmrY8tvHmw=;
        b=PTg3vmqh3aEJgfVc75M3LagU4g8MPZXtwwxwGZu0T3tmEoTAK4AuM2tautxWK61pbxk3w5
        zjASu9iTvRXoNo/vyzUV3yZXgFWnK/JiceMH6ckz01d7A+poI0CAR7FkNl9122qiazrEzH
        ENk43jnwDEFYLFW9jQ8siHlEkJ050nA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-U1cJSbheOw2OhUmi932Sew-1; Mon, 01 Feb 2021 13:42:35 -0500
X-MC-Unique: U1cJSbheOw2OhUmi932Sew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A438359;
        Mon,  1 Feb 2021 18:42:32 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4100A648A3;
        Mon,  1 Feb 2021 18:42:31 +0000 (UTC)
Date:   Mon, 1 Feb 2021 11:42:30 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210201114230.37c18abd@omen.home.shazbot.org>
In-Reply-To: <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
        <20210201181454.22112b57.cohuck@redhat.com>
        <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 12:49:12 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 2/1/21 12:14 PM, Cornelia Huck wrote:
> > On Mon, 1 Feb 2021 16:28:27 +0000
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >   
> >> This patch doesn't change any logic but only align to the concept of
> >> vfio_pci_core extensions. Extensions that are related to a platform
> >> and not to a specific vendor of PCI devices should be part of the core
> >> driver. Extensions that are specific for PCI device vendor should go
> >> to a dedicated vendor vfio-pci driver.  
> > 
> > My understanding is that igd means support for Intel graphics, i.e. a
> > strict subset of x86. If there are other future extensions that e.g.
> > only make sense for some devices found only on AMD systems, I don't
> > think they should all be included under the same x86 umbrella.
> > 
> > Similar reasoning for nvlink, that only seems to cover support for some
> > GPUs under Power, and is not a general platform-specific extension IIUC.
> > 
> > We can arguably do the zdev -> s390 rename (as zpci appears only on
> > s390, and all PCI devices will be zpci on that platform), although I'm
> > not sure about the benefit.  
> 
> As far as I can tell, there isn't any benefit for s390 it's just 
> "re-branding" to match the platform name rather than the zdev moniker, 
> which admittedly perhaps makes it more clear to someone outside of s390 
> that any PCI device on s390 is a zdev/zpci type, and thus will use this 
> extension to vfio_pci(_core).  This would still be true even if we added 
> something later that builds atop it (e.g. a platform-specific device 
> like ism-vfio-pci).  Or for that matter, mlx5 via vfio-pci on s390x uses 
> these zdev extensions today and would need to continue using them in a 
> world where mlx5-vfio-pci.ko exists.
> 
> I guess all that to say: if such a rename matches the 'grand scheme' of 
> this design where we treat arch-level extensions to vfio_pci(_core) as 
> "vfio_pci_(arch)" then I'm not particularly opposed to the rename.  But 
> by itself it's not very exciting :)

This all seems like the wrong direction to me.  The goal here is to
modularize vfio-pci into a core library and derived vendor modules that
make use of that core library.  If existing device specific extensions
within vfio-pci cannot be turned into vendor modules through this
support and are instead redefined as platform specific features of the
new core library, that feels like we're already admitting failure of
this core library to support known devices, let alone future devices.

IGD is a specific set of devices.  They happen to rely on some platform
specific support, whose availability should be determined via the
vendor module probe callback.  Packing that support into an "x86"
component as part of the core feels not only short sighted, but also
avoids addressing the issues around how userspace determines an optimal
module to use for a device.  Thanks,

Alex

> >> For now, x86 extensions will include only igd.
> >>
> >> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> >> ---
> >>   drivers/vfio/pci/Kconfig                            | 13 ++++++-------
> >>   drivers/vfio/pci/Makefile                           |  2 +-
> >>   drivers/vfio/pci/vfio_pci_core.c                    |  2 +-
> >>   drivers/vfio/pci/vfio_pci_private.h                 |  2 +-
> >>   drivers/vfio/pci/{vfio_pci_igd.c => vfio_pci_x86.c} |  0
> >>   5 files changed, 9 insertions(+), 10 deletions(-)
> >>   rename drivers/vfio/pci/{vfio_pci_igd.c => vfio_pci_x86.c} (100%)  
> > 
> > (...)
> >   
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> >> index c559027def2d..e0e258c37fb5 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -328,7 +328,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
> >>   
> >>   	if (vfio_pci_is_vga(pdev) &&
> >>   	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
> >> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> >> +	    IS_ENABLED(CONFIG_VFIO_PCI_X86)) {
> >>   		ret = vfio_pci_igd_init(vdev);  
> > 
> > This one explicitly checks for Intel devices, so I'm not sure why you
> > want to generalize this to x86?
> >   
> >>   		if (ret && ret != -ENODEV) {
> >>   			pci_warn(pdev, "Failed to setup Intel IGD regions\n");  
> >   
> 

