Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB37342926F
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244115AbhJKOqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:46:49 -0400
Received: from foss.arm.com ([217.140.110.172]:59816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243233AbhJKOqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 10:46:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71FD7101E;
        Mon, 11 Oct 2021 07:44:36 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C9753F694;
        Mon, 11 Oct 2021 07:44:35 -0700 (PDT)
Date:   Mon, 11 Oct 2021 15:46:16 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 6/7] vfio/pci: Print an error when offset is
 outside of the MSIX table or PBA
Message-ID: <YWROOIl0j8jXONfY@monolith.localdoman>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
 <20210913154413.14322-7-alexandru.elisei@arm.com>
 <20211006161128.4855aafa@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006161128.4855aafa@donnerap.cambridge.arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On Wed, Oct 06, 2021 at 04:11:28PM +0100, Andre Przywara wrote:
> On Mon, 13 Sep 2021 16:44:12 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> > Now that we keep track of the real size of MSIX table and PBA, print an
> > error when the guest tries to write to an offset which is not inside the
> > correct regions.
> 
> What is the actual purpose of this message? Is there anything the user can
> do about it? Shouldn't we either abort the guest or inject an error
> condition back into KVM or the guest instead?

The only way for the error message to trigger is in case of a programming error
in kvmtool - when access to the PBA BAR is enabled by the guest, kvmtool will
register the vfio_pci_msix_pba_access callback for the memory region
[pba->guest_phys_addr, pba->guest_phys_addr + pba->size) in
vfio_pci_bar_activate().

I believe kvmtool should definitely print something when it detects a
programming error. The question now becomes if kvmtool should die or continue
running the VM, as the VM can run just fine even if emulation for assigned
devices is malfunctioning. I would rather give the user the chance to safely
shutdown the VM instead of killing it outright.

Thanks,
Alex

> 
> Cheers,
> Andre
> 
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  vfio/pci.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/vfio/pci.c b/vfio/pci.c
> > index 7781868..a6d0408 100644
> > --- a/vfio/pci.c
> > +++ b/vfio/pci.c
> > @@ -249,6 +249,11 @@ static void vfio_pci_msix_pba_access(struct kvm_cpu
> > *vcpu, u64 addr, u8 *data, u64 offset = addr - pba->guest_phys_addr;
> >  	struct vfio_device *vdev = container_of(pdev, struct
> > vfio_device, pci); 
> > +	if (offset >= pba->size) {
> > +		vfio_dev_err(vdev, "access outside of the MSIX PBA");
> > +		return;
> > +	}
> > +
> >  	if (is_write)
> >  		return;
> >  
> > @@ -269,6 +274,10 @@ static void vfio_pci_msix_table_access(struct
> > kvm_cpu *vcpu, u64 addr, u8 *data, struct vfio_device *vdev =
> > container_of(pdev, struct vfio_device, pci); 
> >  	u64 offset = addr - pdev->msix_table.guest_phys_addr;
> > +	if (offset >= pdev->msix_table.size) {
> > +		vfio_dev_err(vdev, "access outside of the MSI-X table");
> > +		return;
> > +	}
> >  
> >  	size_t vector = offset / PCI_MSIX_ENTRY_SIZE;
> >  	off_t field = offset % PCI_MSIX_ENTRY_SIZE;
> 
