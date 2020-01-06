Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF78130D30
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 06:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgAFF3k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 6 Jan 2020 00:29:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:41363 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgAFF3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 00:29:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jan 2020 21:29:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,401,1571727600"; 
   d="scan'208";a="222742545"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga003.jf.intel.com with ESMTP; 05 Jan 2020 21:29:37 -0800
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Jan 2020 21:29:36 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Jan 2020 21:29:36 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.89]) with mapi id 14.03.0439.000;
 Mon, 6 Jan 2020 13:29:34 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
Thread-Topic: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits
 alloc/free
Thread-Index: AQHVoSnwVqdzrJe2wU2Z/flFcmihA6e7ao+AgAD9KVCAAEBDgIAfUASA
Date:   Mon, 6 Jan 2020 05:29:34 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A17199E@SHSMSX104.ccr.corp.intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
        <1574335427-3763-9-git-send-email-yi.l.liu@intel.com>
        <20191215154633.4641b05e@x1.home>
        <A2975661238FB949B60364EF0F2C25743A134FBE@SHSMSX104.ccr.corp.intel.com>
 <20191216104239.49e3d147@x1.home>
In-Reply-To: <20191216104239.49e3d147@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzRmOTViNzgtYmQ0My00YzI0LTkzNTgtMWVmYTA0ZGUwMDc5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZGE5QkUyYjI0K050M2NUQ3RwckdyR1VWWlB6ZWhlNGMza0hKT1BjeDNSbEJzZXhiNWNRaHlQNnJ6TUtDKytScSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson < alex.williamson@redhat.com>
> Sent: Tuesday, December 17, 2019 1:43 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
> 
> On Mon, 16 Dec 2019 11:57:54 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Monday, December 16, 2019 6:47 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
> > >
> > > On Thu, 21 Nov 2019 19:23:45 +0800
> > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > >
> > > > This patch add a user numer track for the shared cap/ecap_perms bits,
> > > > and the alloc/free will hold a semaphore to protect the operations.
> > > > With the changes, first caller of vfio_pci_init_perm_bits() will
> > > > initialize the bits. While the last caller of vfio_pci_uninit_perm_bits()
> > > > will free the bits. This is a preparation to have multiple cap/ecap_perms
> > > > bits users.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++++--
> > > >  1 file changed, 31 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci_config.c
> b/drivers/vfio/pci/vfio_pci_config.c
> > > > index f0891bd..274c993 100644
> > > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > > @@ -36,6 +36,13 @@
> > > >  	 (offset >= PCI_ROM_ADDRESS && offset < PCI_ROM_ADDRESS + 4))
> > > >
> > > >  /*
> > > > + * vfio_perm_bits_sem: prorects the shared perm_bits alloc/free
> > > > + * vfio_pci_perm_bits_users: tracks the user of the shared perm_bits
> > > > + */
> > > > +static DEFINE_SEMAPHORE(vfio_perm_bits_sem);
> > > > +static int vfio_pci_perm_bits_users;
> > > > +
> > > > +/*
> > > >   * Lengths of PCI Config Capabilities
> > > >   *   0: Removed from the user visible capability list
> > > >   *   FF: Variable length
> > > > @@ -995,7 +1002,7 @@ static int __init init_pci_ext_cap_pwr_perm(struct
> > > perm_bits *perm)
> > > >  /*
> > > >   * Initialize the shared permission tables
> > > >   */
> > > > -void vfio_pci_uninit_perm_bits(void)
> > > > +static void vfio_pci_uninit_perm_bits_internal(void)
> > > >  {
> > > >  	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
> > > >
> > > > @@ -1009,10 +1016,30 @@ void vfio_pci_uninit_perm_bits(void)
> > > >  	free_perm_bits(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
> > > >  }
> > > >
> > > > +void vfio_pci_uninit_perm_bits(void)
> > > > +{
> > > > +	down(&vfio_perm_bits_sem);
> > > > +
> > > > +	if (--vfio_pci_perm_bits_users > 0)
> > > > +		goto out;
> > > > +
> > > > +	vfio_pci_uninit_perm_bits_internal();
> > > > +
> > > > +out:
> > > > +	up(&vfio_perm_bits_sem);
> > > > +}
> > > > +
> > > >  int __init vfio_pci_init_perm_bits(void)
> > > >  {
> > > >  	int ret;
> > > >
> > > > +	down(&vfio_perm_bits_sem);
> > > > +
> > > > +	if (++vfio_pci_perm_bits_users > 1) {
> > > > +		ret = 0;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > >  	/* Basic config space */
> > > >  	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
> > > >
> > > > @@ -1030,8 +1057,10 @@ int __init vfio_pci_init_perm_bits(void)
> > > >  	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
> > > >
> > > >  	if (ret)
> > > > -		vfio_pci_uninit_perm_bits();
> > > > +		vfio_pci_uninit_perm_bits_internal();
> > > >
> > > > +out:
> > > > +	up(&vfio_perm_bits_sem);
> > > >  	return ret;
> > > >  }
> > > >
> > >
> > > Hi Yi,
> > >
> > > Sorry for slowness in providing feedback on this series.  If we
> > > provided a vfio-pci-common module that vfio-pci and vfio-mdev-pci
> > > depend on, doesn't this entire problem go away?
> >
> > I checked previous email, export the common functions out of
> > vfio-pci module was proposed in RFC v2. But at that time, I didn't
> > propose to have a separate module. So I guess it may be just correct
> > way. Below is the reply at that time.
> >
> > https://lkml.org/lkml/2019/3/19/756
> >
> > > I played a little bit
> > > with this in the crude patch below, it seems to work.  To finish this,
> > > I think we'd move the function declarations out of the "private" header
> > > file and into one under include/linux, then we could also move
> > > vfio_mdev_pci.c to the samples directory like we intended originally.
> > > I know you had tried to link things from samples and it didn't work,
> > > but is the below a better attempt at resolving this?  It commits us to
> > > exporting a bunch of functions, we'll need to decide whether that's a
> > > good idea.  Thanks,
> >
> > I played with your patch and added a crude patch to move
> > vfio-mdev-pci to samples directory. I can see below errors with
> > either CONFIG_VFIO_PCI_COMMON=y and
> > CONFIG_SAMPLE_VFIO_MDEV_PCI=y, or
> > CONFIG_VFIO_PCI_COMMON=m and
> > CONFIG_SAMPLE_VFIO_MDEV_PCI=m.
> >
> > But CONFIG_VFIO_PCI_COMMON works well with CONFIG_VFIO_PCI...
> >
> > Kernel: arch/x86/boot/bzImage is ready  (#88)
> > ERROR: "vfio_pci_fill_ids" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_err_handlers" [samples/vfio-mdev-pci/vfio-mdev-pci.ko]
> undefined!
> > ERROR: "vfio_pci_reflck_attach" [samples/vfio-mdev-pci/vfio-mdev-pci.ko]
> undefined!
> > ERROR: "vfio_pci_write" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_disable" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_reflck_put" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_refresh_config" [samples/vfio-mdev-pci/vfio-mdev-pci.ko]
> undefined!
> > ERROR: "vfio_pci_set_power_state" [samples/vfio-mdev-pci/vfio-mdev-pci.ko]
> undefined!
> > ERROR: "vfio_pci_enable" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_set_vga_decode" [samples/vfio-mdev-pci/vfio-mdev-pci.ko]
> undefined!
> > ERROR: "vfio_pci_probe_power_state" [samples/vfio-mdev-pci/vfio-mdev-pci.ko]
> undefined!
> > ERROR: "vfio_pci_mmap" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_ioctl" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > ERROR: "vfio_pci_read" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
> > scripts/Makefile.modpost:93: recipe for target '__modpost' failed
> >
> > So I'm afraid that it still cannot resolve the problem which we encountered
> > when trying to place vfio-mdev-pci in samples/.
> 
> I'm not sure what we're doing differently (with your patch applied):
> 
> $ grep VFIO ~/build/.config | grep -v ^#
> CONFIG_KVM_VFIO=y
> CONFIG_VFIO_IOMMU_TYPE1=m
> CONFIG_VFIO_VIRQFD=m
> CONFIG_VFIO=m
> CONFIG_VFIO_PCI_COMMON=m
> CONFIG_VFIO_PCI=m
> CONFIG_VFIO_PCI_VGA=y
> CONFIG_VFIO_PCI_MMAP=y
> CONFIG_VFIO_PCI_INTX=y
> CONFIG_VFIO_PCI_IGD=y
> CONFIG_VFIO_MDEV=m
> CONFIG_VFIO_MDEV_DEVICE=m
> CONFIG_SAMPLE_VFIO_MDEV_PCI=m

Hi Alex,

When facing the error in previous emai, I'm using the below
.config. I didn't compile VFIO_PCI. This may be the major difference.
And I think I found the root cause. When trying to build vfio_mdev_pci
into kernel image, it requires vfio_pci_common.ko. However, if VFIO_PCI
is not configured, the drivers/vfio/pci directory is not built. It can be fixed
by either add " obj-$(CONFIG_VFIO_PCI_COMMON) += pci/"
in drivers/vfio/Makefile or add " select VFIO_PCI" for SAMPLE_VFIO_MDEV_PCI
in samples/Kconfig. So I'll move the vfio_mdev_pci module to samples as
you suggested. Let me cook another version. :-)

yiliu@yiliu-dev:~/vfio-mdev-pci-driver/linux$ grep VFIO .config | grep -v ^#
CONFIG_KVM_VFIO=y
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=y
CONFIG_VFIO_PCI_COMMON=m
CONFIG_VFIO_MDEV=y
CONFIG_VFIO_MDEV_DEVICE=y
CONFIG_SAMPLE_VFIO_MDEV_PCI=m

> $ make O=~/build -j36 > /dev/null && echo $?
> 0
> 
> $ grep VFIO ~/build/.config | grep -v ^#
> CONFIG_KVM_VFIO=y
> CONFIG_VFIO_IOMMU_TYPE1=y
> CONFIG_VFIO_VIRQFD=y
> CONFIG_VFIO=y
> CONFIG_VFIO_PCI_COMMON=y
> CONFIG_VFIO_PCI=y
> CONFIG_VFIO_PCI_VGA=y
> CONFIG_VFIO_PCI_MMAP=y
> CONFIG_VFIO_PCI_INTX=y
> CONFIG_VFIO_PCI_IGD=y
> CONFIG_VFIO_MDEV=m
> CONFIG_VFIO_MDEV_DEVICE=m
> $ make O=~/build -j36 > /dev/null && echo $?
> 0
> 
> $ grep VFIO ~/build/.config | grep -v ^#
> CONFIG_KVM_VFIO=y
> CONFIG_VFIO_IOMMU_TYPE1=y
> CONFIG_VFIO_VIRQFD=m
> CONFIG_VFIO=y
> CONFIG_VFIO_PCI_COMMON=m
> CONFIG_VFIO_PCI=m
> CONFIG_VFIO_PCI_VGA=y
> CONFIG_VFIO_PCI_MMAP=y
> CONFIG_VFIO_PCI_INTX=y
> CONFIG_VFIO_PCI_IGD=y
> CONFIG_VFIO_MDEV=m
> CONFIG_VFIO_MDEV_DEVICE=m
> $ make O=~/build -j36 > /dev/null && echo $?
> 0
> 
> > ================= [the crude patch] =================
> > From fa860ff15ab188481141f7bd2b9cb3a1d500f24d Mon Sep 17 00:00:00 2001
> > From: Liu Yi L <yi.l.liu@intel.com>
> > Date: Sun, 15 Dec 2019 19:16:54 +0800
> > Subject: [PATCH] vfio/pci/sample: move vfio-pci-mdev to samples
> >
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/Makefile             |   2 -
> >  drivers/vfio/pci/vfio_mdev_pci.c      | 421 ----------------------------------
> >  drivers/vfio/pci/vfio_pci.c           |   2 +-
> >  drivers/vfio/pci/vfio_pci_common.c    |   2 +-
> >  drivers/vfio/pci/vfio_pci_config.c    |   2 +-
> >  drivers/vfio/pci/vfio_pci_igd.c       |   2 +-
> >  drivers/vfio/pci/vfio_pci_intrs.c     |   2 +-
> >  drivers/vfio/pci/vfio_pci_nvlink2.c   |   2 +-
> >  drivers/vfio/pci/vfio_pci_private.h   | 228 ------------------
> >  drivers/vfio/pci/vfio_pci_rdwr.c      |   2 +-
> >  include/linux/vfio_pci_private.h      | 228 ++++++++++++++++++
> 
> Of course this would not be "private" if this is the direction we
> decide to go. 

yes, if we are going this way in the end, it should definitely be split into
a "private" one and non "private" one.

> Potentially there are still things private to
> vfio-pci-common that we'd leave in the drivers directory though.  I'm
> not entirely thrilled to expose the objects outside of vfio-pci,

Will have a private .h to vfio-pci-common.ko :-)

> but
> potentially if vfio-pci had a mechanism to choose an alternate
> vfio_device_ops that provided vendor mediation extension when calling
> vfio_add_group_dev(), and common code was sharable to vendor drivers,
> it might clean up the interface Yan is proposing for adding migration
> to non-mdev devices.  Thanks,

I think it is doable as long as common code are sharable to vendor drivers.
Or maybe vendor driver just choose to consume vfio pci common codes.
Thanks for your suggestions, let me work out another version.

> 
> Alex

Regards,
Yi Liu
