Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E61211FC
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfLPRmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 12:42:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725805AbfLPRmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 12:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576518171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6RsCBgLCZybl+F5fHNe92eTIf8xWOpDUNeWuJDnjnM=;
        b=AjsU0yVZQt73r6zH0p/5c3EeWJkQlIqehXLGOhb2R1zMFx34DQ1TB5x+33GVG5R++quO6A
        VcWP0oGRrxyZB4oONkvVdX1xBdlpZvDKv4dDmCTpmy3uBrqt+sq//h+Bfw4QApFAr6vraD
        GGOVd4Jb6x1m6wWv5JCs/VnET9BkoDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-Y0JOvVc9NZaHDUGhTuDYQw-1; Mon, 16 Dec 2019 12:42:46 -0500
X-MC-Unique: Y0JOvVc9NZaHDUGhTuDYQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED7F0800D48;
        Mon, 16 Dec 2019 17:42:44 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B50D86106B;
        Mon, 16 Dec 2019 17:42:39 +0000 (UTC)
Date:   Mon, 16 Dec 2019 10:42:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits
 alloc/free
Message-ID: <20191216104239.49e3d147@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A134FBE@SHSMSX104.ccr.corp.intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
        <1574335427-3763-9-git-send-email-yi.l.liu@intel.com>
        <20191215154633.4641b05e@x1.home>
        <A2975661238FB949B60364EF0F2C25743A134FBE@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Dec 2019 11:57:54 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Monday, December 16, 2019 6:47 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
> > 
> > On Thu, 21 Nov 2019 19:23:45 +0800
> > Liu Yi L <yi.l.liu@intel.com> wrote:
> >   
> > > This patch add a user numer track for the shared cap/ecap_perms bits,
> > > and the alloc/free will hold a semaphore to protect the operations.
> > > With the changes, first caller of vfio_pci_init_perm_bits() will
> > > initialize the bits. While the last caller of vfio_pci_uninit_perm_bits()
> > > will free the bits. This is a preparation to have multiple cap/ecap_perms
> > > bits users.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++++--
> > >  1 file changed, 31 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > > index f0891bd..274c993 100644
> > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > @@ -36,6 +36,13 @@
> > >  	 (offset >= PCI_ROM_ADDRESS && offset < PCI_ROM_ADDRESS + 4))
> > >
> > >  /*
> > > + * vfio_perm_bits_sem: prorects the shared perm_bits alloc/free
> > > + * vfio_pci_perm_bits_users: tracks the user of the shared perm_bits
> > > + */
> > > +static DEFINE_SEMAPHORE(vfio_perm_bits_sem);
> > > +static int vfio_pci_perm_bits_users;
> > > +
> > > +/*
> > >   * Lengths of PCI Config Capabilities
> > >   *   0: Removed from the user visible capability list
> > >   *   FF: Variable length
> > > @@ -995,7 +1002,7 @@ static int __init init_pci_ext_cap_pwr_perm(struct  
> > perm_bits *perm)  
> > >  /*
> > >   * Initialize the shared permission tables
> > >   */
> > > -void vfio_pci_uninit_perm_bits(void)
> > > +static void vfio_pci_uninit_perm_bits_internal(void)
> > >  {
> > >  	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
> > >
> > > @@ -1009,10 +1016,30 @@ void vfio_pci_uninit_perm_bits(void)
> > >  	free_perm_bits(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
> > >  }
> > >
> > > +void vfio_pci_uninit_perm_bits(void)
> > > +{
> > > +	down(&vfio_perm_bits_sem);
> > > +
> > > +	if (--vfio_pci_perm_bits_users > 0)
> > > +		goto out;
> > > +
> > > +	vfio_pci_uninit_perm_bits_internal();
> > > +
> > > +out:
> > > +	up(&vfio_perm_bits_sem);
> > > +}
> > > +
> > >  int __init vfio_pci_init_perm_bits(void)
> > >  {
> > >  	int ret;
> > >
> > > +	down(&vfio_perm_bits_sem);
> > > +
> > > +	if (++vfio_pci_perm_bits_users > 1) {
> > > +		ret = 0;
> > > +		goto out;
> > > +	}
> > > +
> > >  	/* Basic config space */
> > >  	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
> > >
> > > @@ -1030,8 +1057,10 @@ int __init vfio_pci_init_perm_bits(void)
> > >  	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
> > >
> > >  	if (ret)
> > > -		vfio_pci_uninit_perm_bits();
> > > +		vfio_pci_uninit_perm_bits_internal();
> > >
> > > +out:
> > > +	up(&vfio_perm_bits_sem);
> > >  	return ret;
> > >  }
> > >  
> > 
> > Hi Yi,
> > 
> > Sorry for slowness in providing feedback on this series.  If we
> > provided a vfio-pci-common module that vfio-pci and vfio-mdev-pci
> > depend on, doesn't this entire problem go away?   
> 
> I checked previous email, export the common functions out of
> vfio-pci module was proposed in RFC v2. But at that time, I didn't
> propose to have a separate module. So I guess it may be just correct
> way. Below is the reply at that time.
> 
> https://lkml.org/lkml/2019/3/19/756
> 
> > I played a little bit
> > with this in the crude patch below, it seems to work.  To finish this,
> > I think we'd move the function declarations out of the "private" header
> > file and into one under include/linux, then we could also move
> > vfio_mdev_pci.c to the samples directory like we intended originally.
> > I know you had tried to link things from samples and it didn't work,
> > but is the below a better attempt at resolving this?  It commits us to
> > exporting a bunch of functions, we'll need to decide whether that's a
> > good idea.  Thanks,  
> 
> I played with your patch and added a crude patch to move
> vfio-mdev-pci to samples directory. I can see below errors with
> either CONFIG_VFIO_PCI_COMMON=y and
> CONFIG_SAMPLE_VFIO_MDEV_PCI=y, or
> CONFIG_VFIO_PCI_COMMON=m and
> CONFIG_SAMPLE_VFIO_MDEV_PCI=m.
> 
> But CONFIG_VFIO_PCI_COMMON works well with CONFIG_VFIO_PCI...
> 
> Kernel: arch/x86/boot/bzImage is ready  (#88)
> ERROR: "vfio_pci_fill_ids" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_err_handlers" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_reflck_attach" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_write" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_disable" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_reflck_put" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_refresh_config" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_set_power_state" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_enable" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_set_vga_decode" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_probe_power_state" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_mmap" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_ioctl" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> ERROR: "vfio_pci_read" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> scripts/Makefile.modpost:93: recipe for target '__modpost' failed
> 
> So I'm afraid that it still cannot resolve the problem which we encountered
> when trying to place vfio-mdev-pci in samples/.

I'm not sure what we're doing differently (with your patch applied):

$ grep VFIO ~/build/.config | grep -v ^#
CONFIG_KVM_VFIO=y
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_PCI_COMMON=m
CONFIG_VFIO_PCI=m
CONFIG_VFIO_PCI_VGA=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_SAMPLE_VFIO_MDEV_PCI=m

$ make O=~/build -j36 > /dev/null && echo $?
0

$ grep VFIO ~/build/.config | grep -v ^#
CONFIG_KVM_VFIO=y
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO_VIRQFD=y
CONFIG_VFIO=y
CONFIG_VFIO_PCI_COMMON=y
CONFIG_VFIO_PCI=y
CONFIG_VFIO_PCI_VGA=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
$ make O=~/build -j36 > /dev/null && echo $?
0

$ grep VFIO ~/build/.config | grep -v ^#
CONFIG_KVM_VFIO=y
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=y
CONFIG_VFIO_PCI_COMMON=m
CONFIG_VFIO_PCI=m
CONFIG_VFIO_PCI_VGA=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
$ make O=~/build -j36 > /dev/null && echo $?
0

> ================= [the crude patch] =================
> From fa860ff15ab188481141f7bd2b9cb3a1d500f24d Mon Sep 17 00:00:00 2001
> From: Liu Yi L <yi.l.liu@intel.com>
> Date: Sun, 15 Dec 2019 19:16:54 +0800
> Subject: [PATCH] vfio/pci/sample: move vfio-pci-mdev to samples
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/Makefile             |   2 -
>  drivers/vfio/pci/vfio_mdev_pci.c      | 421 ----------------------------------
>  drivers/vfio/pci/vfio_pci.c           |   2 +-
>  drivers/vfio/pci/vfio_pci_common.c    |   2 +-
>  drivers/vfio/pci/vfio_pci_config.c    |   2 +-
>  drivers/vfio/pci/vfio_pci_igd.c       |   2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c     |   2 +-
>  drivers/vfio/pci/vfio_pci_nvlink2.c   |   2 +-
>  drivers/vfio/pci/vfio_pci_private.h   | 228 ------------------
>  drivers/vfio/pci/vfio_pci_rdwr.c      |   2 +-
>  include/linux/vfio_pci_private.h      | 228 ++++++++++++++++++

Of course this would not be "private" if this is the direction we
decide to go.  Potentially there are still things private to
vfio-pci-common that we'd leave in the drivers directory though.  I'm
not entirely thrilled to expose the objects outside of vfio-pci, but
potentially if vfio-pci had a mechanism to choose an alternate
vfio_device_ops that provided vendor mediation extension when calling
vfio_add_group_dev(), and common code was sharable to vendor drivers,
it might clean up the interface Yan is proposing for adding migration
to non-mdev devices.  Thanks,

Alex

