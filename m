Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6222C3FC6B9
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 14:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbhHaLlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 07:41:10 -0400
Received: from foss.arm.com ([217.140.110.172]:53342 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhHaLlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 07:41:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B3131FB;
        Tue, 31 Aug 2021 04:40:13 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35E873F694;
        Tue, 31 Aug 2021 04:40:12 -0700 (PDT)
Date:   Tue, 31 Aug 2021 12:39:57 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH][kvmtool] virtio/pci: Size the MSI-X bar according to
 the number of MSI-X
Message-ID: <20210831123957.32b5a8f8@slackpad.fritz.box>
In-Reply-To: <87wno1ontv.wl-maz@kernel.org>
References: <20210827115405.1981529-1-maz@kernel.org>
        <20210831121035.6b5c993b@slackpad.fritz.box>
        <87wno1ontv.wl-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Aug 2021 12:28:28 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Hi Andre,
> 
> On Tue, 31 Aug 2021 12:10:35 +0100,
> Andre Przywara <andre.przywara@arm.com> wrote:
> > 
> > On Fri, 27 Aug 2021 12:54:05 +0100
> > Marc Zyngier <maz@kernel.org> wrote:
> > 
> > Hi Marc,
> >   
> > > Since 45d3b59e8c45 ("kvm tools: Increase amount of possible interrupts
> > > per PCI device"), the number of MSI-S has gone from 4 to 33.
> > > 
> > > However, the corresponding storage hasn't been upgraded, and writing
> > > to the MSI-X table is a pretty risky business. Now that the Linux
> > > kernel writes to *all* MSI-X entries before doing anything else
> > > with the device, kvmtool dies a horrible death.
> > > 
> > > Fix it by properly defining the size of the MSI-X bar, and make
> > > Linux great again.
> > > 
> > > This includes some fixes the PBA region decoding, as well as minor
> > > cleanups to make this code a bit more maintainable.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>  
> > 
> > Many thanks for fixing this, it looks good to me now. Just some
> > questions below:

Thanks for the explanation, and keeping (void *) as there are more
instances sounds fair enough. So:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre


> >   
> > > ---
> > >  virtio/pci.c | 42 ++++++++++++++++++++++++++++++------------
> > >  1 file changed, 30 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/virtio/pci.c b/virtio/pci.c
> > > index eb91f512..41085291 100644
> > > --- a/virtio/pci.c
> > > +++ b/virtio/pci.c
> > > @@ -7,6 +7,7 @@
> > >  #include "kvm/irq.h"
> > >  #include "kvm/virtio.h"
> > >  #include "kvm/ioeventfd.h"
> > > +#include "kvm/util.h"
> > >  
> > >  #include <sys/ioctl.h>
> > >  #include <linux/virtio_pci.h>
> > > @@ -14,6 +15,13 @@
> > >  #include <assert.h>
> > >  #include <string.h>
> > >  
> > > +#define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
> > > +#define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
> > > +#define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
> > > +#define VIRTIO_MSIX_PBA_SIZE	(ALIGN_UP(VIRTIO_MSIX_TABLE_SIZE, 64) / 8)
> > > +#define VIRTIO_MSIX_BAR_SIZE	(1UL << fls_long(VIRTIO_MSIX_TABLE_SIZE + \
> > > +						 VIRTIO_MSIX_PBA_SIZE))
> > > +
> > >  static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
> > >  {
> > >  	return pci__bar_address(&vpci->pci_hdr, 0);
> > > @@ -333,18 +341,27 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
> > >  	struct virtio_pci *vpci = vdev->virtio;
> > >  	struct msix_table *table;
> > >  	u32 msix_io_addr = virtio_pci__msix_io_addr(vpci);
> > > +	u32 pba_offset;
> > >  	int vecnum;
> > >  	size_t offset;
> > >  
> > > -	if (addr > msix_io_addr + PCI_IO_SIZE) {  
> > 
> > Ouch, the missing "=" looks like another long standing bug you fixed, I
> > wonder how this ever worked before? Looking deeper it looks like the
> > whole PBA code was quite broken (allowing writes, for instance, and
> > mixing with the code for the MSIX table)?  
> 
> I don't think it ever worked. And to be fair, no known guest ever
> reads from it either. It just that as I was reworking it, some of the
> pitfalls became obvious.
> 
> >   
> > > +	BUILD_BUG_ON(VIRTIO_NR_MSIX > (sizeof(vpci->msix_pba) * 8));
> > > +
> > > +	pba_offset = vpci->pci_hdr.msix.pba_offset & ~PCI_MSIX_TABLE_BIR;  
> > 
> > Any particular reason you read back the offset from the MSIX capability
> > instead of just using VIRTIO_MSIX_TABLE_SIZE here? Is that to avoid
> > accidentally diverging in the future, by having just one place of
> > definition?  
> 
> Exactly. My first version of this patch actually failed to update the
> offset advertised to the guest, so I decided to just have a single
> location for this. At least, we won't have to touch this code again if
> we change the number of MSI-X.
> 
> >   
> > > +	if (addr >= msix_io_addr + pba_offset) {
> > > +		/* Read access to PBA */
> > >  		if (is_write)
> > >  			return;
> > > -		table  = (struct msix_table *)&vpci->msix_pba;
> > > -		offset = addr - (msix_io_addr + PCI_IO_SIZE);
> > > -	} else {
> > > -		table  = vpci->msix_table;
> > > -		offset = addr - msix_io_addr;
> > > +		offset = addr - (msix_io_addr + pba_offset);
> > > +		if ((offset + len) > sizeof (vpci->msix_pba))
> > > +			return;
> > > +		memcpy(data, (void *)&vpci->msix_pba + offset, len);  
> > 
> > Should this be a char* cast, since pointer arithmetic on void* is
> > somewhat frowned upon (aka "forbidden in the C standard, but allowed as
> > a GCC extension")?  
> 
> I am trying to be consistent. A quick grep shows at least 19
> occurrences of pointer arithmetic with '(void *)', and none with
> '(char *)'. Happy for someone to go and repaint this, but I don't
> think this should be the purpose of this patch.
> 
> Thanks,
> 
> 	M.
> 

