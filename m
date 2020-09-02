Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD425A6D7
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 09:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIBHcv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 2 Sep 2020 03:32:51 -0400
Received: from smtpout1.mo804.mail-out.ovh.net ([79.137.123.220]:36361 "EHLO
        smtpout1.mo804.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbgIBHcu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Sep 2020 03:32:50 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.210])
        by mo804.mail-out.ovh.net (Postfix) with ESMTPS id 9C52A5D0A961;
        Wed,  2 Sep 2020 09:31:37 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 2 Sep 2020
 09:31:37 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G0018b64f145-c98b-42a4-a53b-b7c9d6e7aed3,
                    AA3809B24A0F88596FE87CA7447536A9393A4537) smtp.auth=groug@kaod.org
Date:   Wed, 2 Sep 2020 09:31:35 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
CC:     Paul Mackerras <paulus@ozlabs.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XICS: Replace the 'destroy' method
 by a 'release' method
Message-ID: <20200902093135.7324d307@bahia.lan>
In-Reply-To: <a7e1e908-3460-f6dc-78a8-8f69c031bcb0@kaod.org>
References: <159705408550.1308430.10165736270896374279.stgit@bahia.lan>
        <a7e1e908-3460-f6dc-78a8-8f69c031bcb0@kaod.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG8EX2.mxp5.local (172.16.2.72) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 21c699b7-7a9a-4457-a2fb-297c61d1c60a
X-Ovh-Tracer-Id: 5357313234836691363
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedguddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepveelhfdtudffhfeiveehhfelgeellefgteffteekudegheejfffghefhfeeuudffnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtoheptghlgheskhgrohgurdhorhhg
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Sep 2020 09:26:06 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> On 8/10/20 12:08 PM, Greg Kurz wrote:
> > Similarly to what was done with XICS-on-XIVE and XIVE native KVM devices
> > with commit 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy'
> > method by a 'release' method"), convert the historical XICS KVM device to
> > implement the 'release' method. This is needed to run nested guests with
> > an in-kernel IRQ chip. A typical POWER9 guest can select XICS or XIVE
> > during boot, which requires to be able to destroy and to re-create the
> > KVM device. Only the historical XICS KVM device is available under pseries
> > at the current time and it still uses the legacy 'destroy' method.
> > 
> > Switching to 'release' means that vCPUs might still be running when the
> > device is destroyed. In order to avoid potential use-after-free, the
> > kvmppc_xics structure is allocated on first usage and kept around until
> > the VM exits. The same pointer is used each time a KVM XICS device is
> > being created, but this is okay since we only have one per VM.
> > 
> > Clear the ICP of each vCPU with vcpu->mutex held. This ensures that the
> > next time the vCPU resumes execution, it won't be going into the XICS
> > code anymore.
> > 
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> 
> Reviewed-by: Cédric Le Goater <clg@kaod.org>
> 
> and on a P8 host, 
> 
> Tested-by: Cédric Le Goater <clg@kaod.org>
> 
> Thanks,
> 
> C. 
> 

Thanks for the review and testing !

Cheers,

--
Greg

> > ---
> >  arch/powerpc/include/asm/kvm_host.h |    1 
> >  arch/powerpc/kvm/book3s.c           |    4 +-
> >  arch/powerpc/kvm/book3s_xics.c      |   86 ++++++++++++++++++++++++++++-------
> >  3 files changed, 72 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> > index e020d269416d..974adda2ec94 100644
> > --- a/arch/powerpc/include/asm/kvm_host.h
> > +++ b/arch/powerpc/include/asm/kvm_host.h
> > @@ -325,6 +325,7 @@ struct kvm_arch {
> >  #endif
> >  #ifdef CONFIG_KVM_XICS
> >  	struct kvmppc_xics *xics;
> > +	struct kvmppc_xics *xics_device;
> >  	struct kvmppc_xive *xive;    /* Current XIVE device in use */
> >  	struct {
> >  		struct kvmppc_xive *native;
> > diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> > index 41fedec69ac3..56618c2770e1 100644
> > --- a/arch/powerpc/kvm/book3s.c
> > +++ b/arch/powerpc/kvm/book3s.c
> > @@ -878,13 +878,15 @@ void kvmppc_core_destroy_vm(struct kvm *kvm)
> >  
> >  #ifdef CONFIG_KVM_XICS
> >  	/*
> > -	 * Free the XIVE devices which are not directly freed by the
> > +	 * Free the XIVE and XICS devices which are not directly freed by the
> >  	 * device 'release' method
> >  	 */
> >  	kfree(kvm->arch.xive_devices.native);
> >  	kvm->arch.xive_devices.native = NULL;
> >  	kfree(kvm->arch.xive_devices.xics_on_xive);
> >  	kvm->arch.xive_devices.xics_on_xive = NULL;
> > +	kfree(kvm->arch.xics_device);
> > +	kvm->arch.xics_device = NULL;
> >  #endif /* CONFIG_KVM_XICS */
> >  }
> >  
> > diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
> > index 381bf8dea193..5fee5a11550d 100644
> > --- a/arch/powerpc/kvm/book3s_xics.c
> > +++ b/arch/powerpc/kvm/book3s_xics.c
> > @@ -1334,47 +1334,97 @@ static int xics_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
> >  	return -ENXIO;
> >  }
> >  
> > -static void kvmppc_xics_free(struct kvm_device *dev)
> > +/*
> > + * Called when device fd is closed. kvm->lock is held.
> > + */
> > +static void kvmppc_xics_release(struct kvm_device *dev)
> >  {
> >  	struct kvmppc_xics *xics = dev->private;
> >  	int i;
> >  	struct kvm *kvm = xics->kvm;
> > +	struct kvm_vcpu *vcpu;
> > +
> > +	pr_devel("Releasing xics device\n");
> > +
> > +	/*
> > +	 * Since this is the device release function, we know that
> > +	 * userspace does not have any open fd referring to the
> > +	 * device.  Therefore there can not be any of the device
> > +	 * attribute set/get functions being executed concurrently,
> > +	 * and similarly, the connect_vcpu and set/clr_mapped
> > +	 * functions also cannot be being executed.
> > +	 */
> >  
> >  	debugfs_remove(xics->dentry);
> >  
> > +	/*
> > +	 * We should clean up the vCPU interrupt presenters first.
> > +	 */
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		/*
> > +		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
> > +		 * (i.e. kvmppc_xics_[gs]et_icp) can be done concurrently.
> > +		 * Holding the vcpu->mutex also means that execution is
> > +		 * excluded for the vcpu until the ICP was freed. When the vcpu
> > +		 * can execute again, vcpu->arch.icp and vcpu->arch.irq_type
> > +		 * have been cleared and the vcpu will not be going into the
> > +		 * XICS code anymore.
> > +		 */
> > +		mutex_lock(&vcpu->mutex);
> > +		kvmppc_xics_free_icp(vcpu);
> > +		mutex_unlock(&vcpu->mutex);
> > +	}
> > +
> >  	if (kvm)
> >  		kvm->arch.xics = NULL;
> >  
> > -	for (i = 0; i <= xics->max_icsid; i++)
> > +	for (i = 0; i <= xics->max_icsid; i++) {
> >  		kfree(xics->ics[i]);
> > -	kfree(xics);
> > +		xics->ics[i] = NULL;
> > +	}
> > +	/*
> > +	 * A reference of the kvmppc_xics pointer is now kept under
> > +	 * the xics_device pointer of the machine for reuse. It is
> > +	 * freed when the VM is destroyed for now until we fix all the
> > +	 * execution paths.
> > +	 */
> >  	kfree(dev);
> >  }
> >  
> > +static struct kvmppc_xics *kvmppc_xics_get_device(struct kvm *kvm)
> > +{
> > +	struct kvmppc_xics **kvm_xics_device = &kvm->arch.xics_device;
> > +	struct kvmppc_xics *xics = *kvm_xics_device;
> > +
> > +	if (!xics) {
> > +		xics = kzalloc(sizeof(*xics), GFP_KERNEL);
> > +		*kvm_xics_device = xics;
> > +	} else {
> > +		memset(xics, 0, sizeof(*xics));
> > +	}
> > +
> > +	return xics;
> > +}
> > +
> >  static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
> >  {
> >  	struct kvmppc_xics *xics;
> >  	struct kvm *kvm = dev->kvm;
> > -	int ret = 0;
> >  
> > -	xics = kzalloc(sizeof(*xics), GFP_KERNEL);
> > +	pr_devel("Creating xics for partition\n");
> > +
> > +	/* Already there ? */
> > +	if (kvm->arch.xics)
> > +		return -EEXIST;
> > +
> > +	xics = kvmppc_xics_get_device(kvm);
> >  	if (!xics)
> >  		return -ENOMEM;
> >  
> >  	dev->private = xics;
> >  	xics->dev = dev;
> >  	xics->kvm = kvm;
> > -
> > -	/* Already there ? */
> > -	if (kvm->arch.xics)
> > -		ret = -EEXIST;
> > -	else
> > -		kvm->arch.xics = xics;
> > -
> > -	if (ret) {
> > -		kfree(xics);
> > -		return ret;
> > -	}
> > +	kvm->arch.xics = xics;
> >  
> >  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> >  	if (cpu_has_feature(CPU_FTR_ARCH_206) &&
> > @@ -1399,7 +1449,7 @@ struct kvm_device_ops kvm_xics_ops = {
> >  	.name = "kvm-xics",
> >  	.create = kvmppc_xics_create,
> >  	.init = kvmppc_xics_init,
> > -	.destroy = kvmppc_xics_free,
> > +	.release = kvmppc_xics_release,
> >  	.set_attr = xics_set_attr,
> >  	.get_attr = xics_get_attr,
> >  	.has_attr = xics_has_attr,
> > @@ -1415,7 +1465,7 @@ int kvmppc_xics_connect_vcpu(struct kvm_device *dev, struct kvm_vcpu *vcpu,
> >  		return -EPERM;
> >  	if (xics->kvm != vcpu->kvm)
> >  		return -EPERM;
> > -	if (vcpu->arch.irq_type)
> > +	if (vcpu->arch.irq_type != KVMPPC_IRQ_DEFAULT)
> >  		return -EBUSY;
> >  
> >  	r = kvmppc_xics_create_icp(vcpu, xcpu);
> > 
> > 
> 

