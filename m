Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F08636A51
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 21:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiKWT7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 14:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiKWT5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 14:57:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2E42DFF
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669233319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j3dxfZ3Nx+gRHeQ3GOY4Y3fAAOJM3/0qRH8nPud9yng=;
        b=cYNWD3BeBHc+fLY4PIwjpMt13aAbxdpfxi/TQ2R1brj4KYwlRs5rNKVqON0n6wUcnp+uhE
        gP0SKgNOy5A8E6SSLnVW84hj4WQ1lh67XoP8KWju75BYC6t3ozFIO2rNjvzyFrAIPEyHeE
        p9Zz/LM4WOVxkEHJD6fmoyuEx3pEUDY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-411-9IHAgQsJPN2Ts2lwtvumZA-1; Wed, 23 Nov 2022 14:55:18 -0500
X-MC-Unique: 9IHAgQsJPN2Ts2lwtvumZA-1
Received: by mail-io1-f69.google.com with SMTP id bf14-20020a056602368e00b006ce86e80414so9593482iob.7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3dxfZ3Nx+gRHeQ3GOY4Y3fAAOJM3/0qRH8nPud9yng=;
        b=cB93nX9Gqp56K21HuhGy3k0CSFhfeZqbhSdt+oXI3NbSRv0LiYlBCyhTKVovCb4V1+
         TprD5lnw+PYWCwWJhFgBNPhFj18spwEkCD3/6W4KfA7Z3la17/ZfJkKVb8K6ChSIhWYj
         aG/7y15AdnJBFRFpKr3JrtZ0wUBPxyUBdtmlj/O/9G57B+t9segVZnTVMgZxwxcio13v
         Zt7zKLFB3NDPiJPuOrkgUTgInWP6XIU+gWTDnD+pZiNPiAPUmN2+gQ0/p8qLT10pNe6I
         eOaAxhOicxdCJsjRhzEXb0dpXJ59xqVeS5fcBGAe3vw1e7Ym489Gu0V3A7BAbERDcG0S
         +Bsw==
X-Gm-Message-State: ANoB5pn5YboUAJI368iigdUXNCC5IqtebgVtnxMNOb8s25kqxTGu01BU
        Bcm/nDTN9Y73iYd4rSI52wLRsUuMlyul+fXJoID8gSLd6wyYwsksQkoxqHOsAsgcyeIqbY7Jatc
        C5wX0BaRHdPz9
X-Received: by 2002:a05:6e02:ef0:b0:302:c56c:c924 with SMTP id j16-20020a056e020ef000b00302c56cc924mr4878109ilk.252.1669233317079;
        Wed, 23 Nov 2022 11:55:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6ScbCCR5OAJ8zoXarOh4IKEVQqJPcyV+vYP/EIjdQHxxIMP1SSsV9yBIzDTtBoN3zLx9cfAg==
X-Received: by 2002:a05:6e02:ef0:b0:302:c56c:c924 with SMTP id j16-20020a056e020ef000b00302c56cc924mr4878095ilk.252.1669233316810;
        Wed, 23 Nov 2022 11:55:16 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b21-20020a056602331500b006ccc36c963fsm6600750ioz.43.2022.11.23.11.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 11:55:15 -0800 (PST)
Date:   Wed, 23 Nov 2022 12:55:14 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     chenxiang <chenxiang66@hisilicon.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v2] vfio/pci: Verify each MSI vector to avoid invalid
 MSI vectors
Message-ID: <20221123125514.5bf83fa8.alex.williamson@redhat.com>
In-Reply-To: <86k03loouy.wl-maz@kernel.org>
References: <1669167756-196788-1-git-send-email-chenxiang66@hisilicon.com>
        <86k03loouy.wl-maz@kernel.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 12:08:05 +0000
Marc Zyngier <maz@kernel.org> wrote:

> On Wed, 23 Nov 2022 01:42:36 +0000,
> chenxiang <chenxiang66@hisilicon.com> wrote:
> > 
> > From: Xiang Chen <chenxiang66@hisilicon.com>
> > 
> > Currently the number of MSI vectors comes from register PCI_MSI_FLAGS
> > which should be power-of-2 in qemu, in some scenaries it is not the same as
> > the number that driver requires in guest, for example, a PCI driver wants
> > to allocate 6 MSI vecotrs in guest, but as the limitation, it will allocate
> > 8 MSI vectors. So it requires 8 MSI vectors in qemu while the driver in
> > guest only wants to allocate 6 MSI vectors.
> > 
> > When GICv4.1 is enabled, it iterates over all possible MSIs and enable the
> > forwarding while the guest has only created some of mappings in the virtual
> > ITS, so some calls fail. The exception print is as following:
> > vfio-pci 0000:3a:00.1: irq bypass producer (token 000000008f08224d) registration
> > fails:66311
> > 
> > To avoid the issue, verify each MSI vector, skip some operations such as
> > request_irq() and irq_bypass_register_producer() for those invalid MSI vectors.
> > 
> > Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> > ---
> > I reported the issue at the link:
> > https://lkml.kernel.org/lkml/87cze9lcut.wl-maz@kernel.org/T/
> > 
> > Change Log:
> > v1 -> v2:
> > Verify each MSI vector in kernel instead of adding systemcall according to
> > Mar's suggestion
> > ---
> >  arch/arm64/kvm/vgic/vgic-irqfd.c  | 13 +++++++++++++
> >  arch/arm64/kvm/vgic/vgic-its.c    | 36 ++++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/vgic/vgic.h        |  1 +
> >  drivers/vfio/pci/vfio_pci_intrs.c | 33 +++++++++++++++++++++++++++++++++
> >  include/linux/kvm_host.h          |  2 ++
> >  5 files changed, 85 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
> > index 475059b..71f6af57 100644
> > --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> > +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> > @@ -98,6 +98,19 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >  	return vgic_its_inject_msi(kvm, &msi);
> >  }
> >  
> > +int kvm_verify_msi(struct kvm *kvm,
> > +		   struct kvm_kernel_irq_routing_entry *irq_entry)
> > +{
> > +	struct kvm_msi msi;
> > +
> > +	if (!vgic_has_its(kvm))
> > +		return -ENODEV;
> > +
> > +	kvm_populate_msi(irq_entry, &msi);
> > +
> > +	return vgic_its_verify_msi(kvm, &msi);
> > +}
> > +
> >  /**
> >   * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
> >   */
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 94a666d..8312a4a 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -767,6 +767,42 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
> >  	return 0;
> >  }
> >  
> > +int vgic_its_verify_msi(struct kvm *kvm, struct kvm_msi *msi)
> > +{
> > +	struct vgic_its *its;
> > +	struct its_ite *ite;
> > +	struct kvm_vcpu *vcpu;
> > +	int ret = 0;
> > +
> > +	if (!irqchip_in_kernel(kvm) || (msi->flags & ~KVM_MSI_VALID_DEVID))
> > +		return -EINVAL;
> > +
> > +	if (!vgic_has_its(kvm))
> > +		return -ENODEV;
> > +
> > +	its = vgic_msi_to_its(kvm, msi);
> > +	if (IS_ERR(its))
> > +		return PTR_ERR(its);
> > +
> > +	mutex_lock(&its->its_lock);
> > +	if (!its->enabled) {
> > +		ret = -EBUSY;
> > +		goto unlock;
> > +	}
> > +	ite = find_ite(its, msi->devid, msi->data);
> > +	if (!ite || !its_is_collection_mapped(ite->collection)) {
> > +		ret = E_ITS_INT_UNMAPPED_INTERRUPT;
> > +		goto unlock;
> > +	}
> > +
> > +	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
> > +	if (!vcpu)
> > +		ret = E_ITS_INT_UNMAPPED_INTERRUPT;  
> 
> I'm sorry, but what does this mean to the caller? This should never
> leak outside of the ITS code.
> 
> > +unlock:
> > +	mutex_unlock(&its->its_lock);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Queries the KVM IO bus framework to get the ITS pointer from the given
> >   * doorbell address.
> > diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> > index 0c8da72..d452150 100644
> > --- a/arch/arm64/kvm/vgic/vgic.h
> > +++ b/arch/arm64/kvm/vgic/vgic.h
> > @@ -240,6 +240,7 @@ int kvm_vgic_register_its_device(void);
> >  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
> >  void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
> >  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
> > +int vgic_its_verify_msi(struct kvm *kvm, struct kvm_msi *msi);
> >  int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
> >  int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> >  			 int offset, u32 *val);
> > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> > index 40c3d7c..3027805 100644
> > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/vfio.h>
> >  #include <linux/wait.h>
> >  #include <linux/slab.h>
> > +#include <linux/kvm_irqfd.h>
> >  
> >  #include "vfio_pci_priv.h"
> >  
> > @@ -315,6 +316,28 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
> >  	return 0;
> >  }
> >  
> > +static int vfio_pci_verify_msi_entry(struct vfio_pci_core_device *vdev,
> > +		struct eventfd_ctx *trigger)
> > +{
> > +	struct kvm *kvm = vdev->vdev.kvm;
> > +	struct kvm_kernel_irqfd *tmp;
> > +	struct kvm_kernel_irq_routing_entry irq_entry;
> > +	int ret = -ENODEV;
> > +
> > +	spin_lock_irq(&kvm->irqfds.lock);
> > +	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> > +		if (trigger == tmp->eventfd) {
> > +			ret = 0;
> > +			break;
> > +		}
> > +	}
> > +	spin_unlock_irq(&kvm->irqfds.lock);
> > +	if (ret)
> > +		return ret;
> > +	irq_entry = tmp->irq_entry;
> > +	return kvm_verify_msi(kvm, &irq_entry);  
> 
> How does this work on !arm64? Why do we need an on-stack version of
> tmp->irq_entry?

Not only on !arm64, but in any scenario that doesn't involve KVM.
There cannot be a hard dependency between vfio and kvm.  Thanks,

Alex

PS - What driver/device actually cares about more than 1 MSI vector and
doesn't implement MSI-X?

> 
> > +}
> > +
> >  static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
> >  				      int vector, int fd, bool msix)
> >  {
> > @@ -355,6 +378,16 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
> >  		return PTR_ERR(trigger);
> >  	}
> >  
> > +	if (!msix) {
> > +		ret = vfio_pci_verify_msi_entry(vdev, trigger);
> > +		if (ret) {
> > +			kfree(vdev->ctx[vector].name);
> > +			eventfd_ctx_put(trigger);
> > +			if (ret > 0)
> > +				ret = 0;
> > +			return ret;
> > +		}
> > +	}  
> 
> Honestly, the whole things seems really complicated to avoid something
> that is only a harmless warning . How about just toning down the
> message instead?
> 
> 	M.
> 

