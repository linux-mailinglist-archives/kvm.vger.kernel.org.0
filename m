Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8CD3B24DA
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFXCW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 22:22:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41336 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFXCWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 22:22:55 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624501236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GH4tMmSF530xBa9KAU+p/NZL8kPguEIb9ABwW/vYvM4=;
        b=eFXhM9mnauv6SSFOp37SskLaGgccXlcfdm+a2WbPecIl96hbjfL2cFkLjkvxa0RMIR4qqo
        MhJ7J3HTe5h65HmuAZvVi1tXXmvlmp77MPn7RchHQZ9y4eT8p6/NiRYR2NgAbICa+DBLOs
        4tZpztrHfMkdDFUzPS+efxTBC1IBPatglgxbKZFuFwT+jLxL9WTpnI5dLK28Q3Swu6zq+1
        dpjBmP/Of4wXZ0dVG7o+KvKwtOH8MVJlgR0X4QFsSmQ27ZLaZmj8k59C8sExrzaA+FbI35
        rZQaxWy5GznrfgF5jKhhKdhB1D375WKmOHUf9N0aolmiGb9585r3EQGlZMXxxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624501236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GH4tMmSF530xBa9KAU+p/NZL8kPguEIb9ABwW/vYvM4=;
        b=QtdtmpZp9hZmQhfLqWevWDIvwixJmRZ/izTjsEpLt8AqHzJWUGCekzFR1FejHuyqZjZO5h
        Na+NOFquAZs4JnAA==
To:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
In-Reply-To: <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com> <87o8bxcuxv.ffs@nanos.tec.linutronix.de> <20210623091935.3ab3e378.alex.williamson@redhat.com> <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com>
Date:   Thu, 24 Jun 2021 04:20:31 +0200
Message-ID: <87mtrgatqo.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin,

thank you very much for digging into this! You made my day!

On Thu, Jun 24 2021 at 00:00, Kevin Tian wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> To work with what we've got, the vfio API describes the limitation of
>> the host interfaces via the VFIO_IRQ_INFO_NORESIZE flag.  QEMU then
>> makes a choice in an attempt to better reflect what we can infer of the
>> guest programming of the device to incrementally enable vectors.  We
>
> It's a surprise to me that Qemu even doesn't look at this flag today after
> searching its code...

Indeed.

git clone https://github.com/qemu/qemu.git
cd qemu
git log -p | grep NORESIZE
+ * The NORESIZE flag indicates that the interrupt lines within the index
+#define VFIO_IRQ_INFO_NORESIZE		(1 << 3)

According to the git history of QEMU this was never used at all and I
don't care about the magic muck which might be in some RHT repository
which might make use of that.

Find below the proper fix for this nonsense which just wasted everyones
time. I'll post it officialy with a proper changelog tomorrow unless
Kevin beats me to it who actually unearthed this and surely earns the
credit.

Alex, I seriously have to ask what you were trying to tell us about this
flag and it's great value and the design related to this.

I'm sure you can submit the corresponding fix to qemu yourself.

And once you are back from lala land, can you please explain how
VFIO/PCI/MSIX is supposed to work in reality?

Thanks,

        tglx
---
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1644,8 +1644,6 @@ static long intel_vgpu_ioctl(struct mdev
 		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
 				       VFIO_IRQ_INFO_AUTOMASKED);
-		else
-			info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1018,8 +1018,6 @@ static long vfio_pci_ioctl(struct vfio_d
 		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
 				       VFIO_IRQ_INFO_AUTOMASKED);
-		else
-			info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -693,16 +693,6 @@ struct vfio_region_info_cap_nvlink2_lnks
  * automatically masked by VFIO and the user needs to unmask the line
  * to receive new interrupts.  This is primarily intended to distinguish
  * level triggered interrupts.
- *
- * The NORESIZE flag indicates that the interrupt lines within the index
- * are setup as a set and new subindexes cannot be enabled without first
- * disabling the entire index.  This is used for interrupts like PCI MSI
- * and MSI-X where the driver may only use a subset of the available
- * indexes, but VFIO needs to enable a specific number of vectors
- * upfront.  In the case of MSI-X, where the user can enable MSI-X and
- * then add and unmask vectors, it's up to userspace to make the decision
- * whether to allocate the maximum supported number of vectors or tear
- * down setup and incrementally increase the vectors as each is enabled.
  */
 struct vfio_irq_info {
 	__u32	argsz;
@@ -710,7 +700,6 @@ struct vfio_irq_info {
 #define VFIO_IRQ_INFO_EVENTFD		(1 << 0)
 #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
 #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
-#define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
 	__u32	index;		/* IRQ index */
 	__u32	count;		/* Number of IRQs within this index */
 };
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1092,9 +1092,6 @@ static int mtty_get_irq_info(struct mdev
 	if (irq_info->index == VFIO_PCI_INTX_IRQ_INDEX)
 		irq_info->flags |= (VFIO_IRQ_INFO_MASKABLE |
 				VFIO_IRQ_INFO_AUTOMASKED);
-	else
-		irq_info->flags |= VFIO_IRQ_INFO_NORESIZE;
-
 	return 0;
 }
 
