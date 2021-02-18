Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45C931EC1D
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhBRQQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:16:04 -0500
Received: from foss.arm.com ([217.140.110.172]:52688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232480AbhBRPxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 10:53:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08308ED1;
        Thu, 18 Feb 2021 07:52:35 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C287C3F73D;
        Thu, 18 Feb 2021 07:52:33 -0800 (PST)
Date:   Thu, 18 Feb 2021 15:51:26 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 15/21] vfio: Refactor ioport trap handler
Message-ID: <20210218155126.3d61257d@slackpad.fritz.box>
In-Reply-To: <d5a594dc-f916-d472-7504-f1bf3aa0f67a@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
        <20201210142908.169597-16-andre.przywara@arm.com>
        <d5a594dc-f916-d472-7504-f1bf3aa0f67a@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Feb 2021 14:47:31 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> Looks good, one nitpick below.
> 
> On 12/10/20 2:29 PM, Andre Przywara wrote:
> > With the planned retirement of the special ioport emulation code, we
> > need to provide an emulation function compatible with the MMIO prototype.
> >
> > Adjust the I/O port trap handler to use that new function, and provide
> > shims to implement the old ioport interface, for now.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  vfio/core.c | 51 ++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 36 insertions(+), 15 deletions(-)
> >
> > diff --git a/vfio/core.c b/vfio/core.c
> > index 0b45e78b..f55f1f87 100644
> > --- a/vfio/core.c
> > +++ b/vfio/core.c
> > @@ -81,15 +81,12 @@ out_free_buf:
> >  	return ret;
> >  }
> >  
> > -static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> > -			   u16 port, void *data, int len)
> > +static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
> > +			    void *data, int len)
> >  {
> > -	u32 val;
> > -	ssize_t nr;
> > -	struct vfio_region *region = ioport->priv;
> >  	struct vfio_device *vdev = region->vdev;
> > -
> > -	u32 offset = port - region->port_base;
> > +	ssize_t nr;
> > +	u32 val;
> >  
> >  	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_READ))
> >  		return false;
> > @@ -97,7 +94,7 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> >  	nr = pread(vdev->fd, &val, len, region->info.offset + offset);
> >  	if (nr != len) {
> >  		vfio_dev_err(vdev, "could not read %d bytes from I/O port 0x%x\n",
> > -			     len, port);
> > +			     len, offset);  
> 
> To keep things functionally identical, shouldn't that be offset +
> region->port_base? I think it's easier to identify the device when we have the PCI
> ioport address.

Yeah, true. Although I think "vfio_dev_err(vdev, ..." already indicates
the device at fault, but indeed the actual ioport address is more
canonical to use.

Thanks,
Andre
 

> 
> Thanks,
> 
> Alex
> 
> >  		return false;
> >  	}
> >  
> > @@ -118,15 +115,13 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> >  	return true;
> >  }
> >  
> > -static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> > -			    u16 port, void *data, int len)
> > +static bool _vfio_ioport_out(struct vfio_region *region, u32 offset,
> > +			     void *data, int len)
> >  {
> > -	u32 val;
> > -	ssize_t nr;
> > -	struct vfio_region *region = ioport->priv;
> >  	struct vfio_device *vdev = region->vdev;
> > +	ssize_t nr;
> > +	u32 val;
> >  
> > -	u32 offset = port - region->port_base;
> >  
> >  	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_WRITE))
> >  		return false;
> > @@ -148,11 +143,37 @@ static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> >  	nr = pwrite(vdev->fd, &val, len, region->info.offset + offset);
> >  	if (nr != len)
> >  		vfio_dev_err(vdev, "could not write %d bytes to I/O port 0x%x",
> > -			     len, port);
> > +			     len, offset);
> >  
> >  	return nr == len;
> >  }
> >  
> > +static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> > +			     u8 is_write, void *ptr)
> > +{
> > +	struct vfio_region *region = ptr;
> > +	u32 offset = addr - region->port_base;
> > +
> > +	if (is_write)
> > +		_vfio_ioport_out(region, offset, data, len);
> > +	else
> > +		_vfio_ioport_in(region, offset, data, len);
> > +}
> > +
> > +static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> > +			    u16 port, void *data, int len)
> > +{
> > +	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
> > +	return true;
> > +}
> > +
> > +static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> > +			   u16 port, void *data, int len)
> > +{
> > +	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
> > +	return true;
> > +}
> > +
> >  static struct ioport_operations vfio_ioport_ops = {
> >  	.io_in	= vfio_ioport_in,
> >  	.io_out	= vfio_ioport_out,  

