Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FA059859B
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343556AbiHROUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 10:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343508AbiHROU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 10:20:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4C8AED98;
        Thu, 18 Aug 2022 07:20:26 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IEEgN1016239;
        Thu, 18 Aug 2022 14:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=HQKZXEtRVeM/Ev8gjgiuUAh0T/aCEOQ0FsNO+HcC6PU=;
 b=TtFQL3KDRnl7FmUBii6NMGMXD6lSUqtlJQ/wk/xHjhdiDj/CHl6dUXzx3Mt6fbo7yVFI
 zK7yXVaUb/pbXQ0fsxkRPpHLvc/2mqd9I/RX6LC22fhw03h5TRbKwezJFxIncxObLrzz
 NOzmGuxTv66RbRrI0LB41PD+BnIl375lm6CqGN9et+m0C26/Ywgl042mlhCYyssvxkgX
 EXiiZEQ5NJEiGjXH3Mw/0L+oVZ1TQX6sZUgFS++A7Ow61F2jts/znJ4pmn6VDLuGKEr0
 06E6ad+qKzqocaa9tQbUPV78S6ApeoIGym1YUU1xfXut6U+Ld5jYGgJEwgGyCbTv2Y2A 0g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1q0x86qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:20:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IE6hIj007618;
        Thu, 18 Aug 2022 14:20:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8x1bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:20:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IEKDjF30278106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 14:20:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E863D5204F;
        Thu, 18 Aug 2022 14:20:12 +0000 (GMT)
Received: from sig-9-145-148-40.de.ibm.com (unknown [9.145.148.40])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5256B52051;
        Thu, 18 Aug 2022 14:20:12 +0000 (GMT)
Message-ID: <25e2364a71c52651f5227c0bc3f43fd193bc2e08.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Thu, 18 Aug 2022 16:20:11 +0200
In-Reply-To: <f797373e-c420-718a-443d-ae98ea0368c7@linux.ibm.com>
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
         <20220818102305.250702-1-pmorel@linux.ibm.com>
         <f797373e-c420-718a-443d-ae98ea0368c7@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AOaX3lsyulr4ieUZvkETCXRYABXCMj2H
X-Proofpoint-GUID: AOaX3lsyulr4ieUZvkETCXRYABXCMj2H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-18 at 09:33 -0400, Matthew Rosato wrote:
> On 8/18/22 6:23 AM, Pierre Morel wrote:
> > We have a cross dependency between KVM and VFIO.
> 
> maybe add something like 'when using s390 vfio_pci_zdev extensions for PCI passthrough'
> 
> > To be able to keep both subsystem modular we add a registering
> > hook inside the S390 core code.
> > 
> > This fixes a build problem when VFIO is built-in and KVM is built
> > as a module or excluded.
> 
> s/or excluded//
> 
> There's no problem when KVM is excluded, that forces CONFIG_VFIO_PCI_ZDEV_KVM=n because of the 'depends on S390 && KVM'.
> 
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
> > Cc: <stable@vger.kernel.org>
> > ---
> >  arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
> >  arch/s390/kvm/pci.c              | 10 ++++++----
> >  arch/s390/pci/Makefile           |  2 ++
> >  arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
> >  drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
> >  5 files changed, 31 insertions(+), 17 deletions(-)
> >  create mode 100644 arch/s390/pci/pci_kvm_hook.c
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index f39092e0ceaa..8312ed9d1937 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h

I added Janosch as second S390 KVM maintainer in case he wants to chime
in.

> > @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> >  #define __KVM_HAVE_ARCH_VM_FREE
> >  void kvm_arch_free_vm(struct kvm *kvm);
> >  
> > -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> > -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
> > -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
> > -#else
> > -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
> > -					    struct kvm *kvm)
> > -{
> > -	return -EPERM;
> > -}
> > -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
> > -#endif
> > +struct kvm_register_hook {
> 
> Nit: zpci_kvm_register_hook ?  Just to make it clear it's for zpci.

Hmm, I guess one could re-use the same struct for another such KVM
dependency but I lean towards the same thinking as Matt, for now this
is for zpci so stay specific we can always generalize later.

Nit: For me hook and register together sound a bit redudant, maybe
"zpci_kvm_register"? Also question for Matt as a native speaker, should
it rather be "registration" when used as a noun here?


> 
> > +	int (*kvm_register)(void *opaque, struct kvm *kvm);
> > +	void (*kvm_unregister)(void *opaque);

I do wonder if this needs to be opague "struct zpci_dev" should be
defined even if CONFIG_PCI is unset.


> > +};
> > +
> > +extern struct kvm_register_hook kvm_pci_hook;
> 
> Nit: kvm_zpci_hook ?

Analogous to zpci_kvm_regist(er|ration) I would call the variable
simply zpci_kvm i.e. the type is a registration and the variable is the
instance of it that links zpci and kvm.

> 
> >  
> >  #endif
> > diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> > index 4946fb7757d6..e173fce64c4f 100644
> > --- a/arch/s390/kvm/pci.c
> > +++ b/arch/s390/kvm/pci.c
> > @@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
> >   * available, enable them and let userspace indicate whether or not they will
> >   * be used (specify SHM bit to disable).
> >   */
> > -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> > +static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
> >  {
> > +	struct zpci_dev *zdev = opaque;
> >  	int rc;
> >  
> >  	if (!zdev)
> > @@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> >  	kvm_put_kvm(kvm);
> >  	return rc;
> >  }
> > -EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
> >  
> > -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
> > +static void kvm_s390_pci_unregister_kvm(void *opaque)
> >  {
> > +	struct zpci_dev *zdev = opaque;
> >  	struct kvm *kvm;
> >  
> >  	if (!zdev)
> > @@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
> >  
> >  	kvm_put_kvm(kvm);
> >  }
> > -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
> >  
> >  void kvm_s390_pci_init_list(struct kvm *kvm)
> >  {
> > @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
> >  
> >  	spin_lock_init(&aift->gait_lock);
> >  	mutex_init(&aift->aift_lock);
> > +	kvm_pci_hook.kvm_register = kvm_s390_pci_register_kvm;
> > +	kvm_pci_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
> >  
> >  	return 0;
> >  }
> > diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> > index bf557a1b789c..c02dbfb415d9 100644
> > --- a/arch/s390/pci/Makefile
> > +++ b/arch/s390/pci/Makefile
> > @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
> >  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
> >  			   pci_bus.o
> >  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
> > +
> > +obj-y += pci_kvm_hook.o
> 
> I guess it doesn't harm anything to add this unconditionally, but I think it would also be OK to just include this in the CONFIG_PCI list - vfio_pci_zdev and arch/s390/kvm/pci all rely on CONFIG_PCI via CONFIG_VFIO_PCI_ZDEV_KVM which implies PCI via VFIO_PCI.
> 
> > diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
> > new file mode 100644
> > index 000000000000..9d8799b72dbf
> > --- /dev/null
> > +++ b/arch/s390/pci/pci_kvm_hook.c
> > @@ -0,0 +1,11 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * VFIO ZPCI devices support
> > + *
> > + * Copyright (C) IBM Corp. 2022.  All rights reserved.
> > + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
> > + */
> > +#include <linux/kvm_host.h>
> > +
> > +struct kvm_register_hook kvm_pci_hook;
> > +EXPORT_SYMBOL_GPL(kvm_pci_hook);
> 
> Following the comments above, zpci_kvm_register_hook, kvm_zpci_hook ?
> 
> I'm not sure if this really needs to be in a separate file or if it could just go into arch/s390/pci.c with the zpci_aipb -- If going the route of a separate file, up to Niklas whether he wants this under the S390 PCI maintainership or added to the list for s390 vfio-pci like arch/kvm/pci* and vfio_pci_zdev.

I'm fine with a separate file, pci.c is long enough as it is. I also
don't have a problem with having it maintained as part of S390 PCI but
logically I think it does fall more under arch/kvm/pci* so one could
argue it should be added in the MAINTAINERS file in that section.
If you change the struct name as I proposed above I would probably go
with "pci_kvm_register.c"

> 
> > diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> > index e163aa9f6144..3b7a707e2fe5 100644
> > --- a/drivers/vfio/pci/vfio_pci_zdev.c
> > +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> > @@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
> >  	if (!vdev->vdev.kvm)
> >  		return 0;
> >  
> > -	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
> > +	if (kvm_pci_hook.kvm_register)
> > +		return kvm_pci_hook.kvm_register(zdev, vdev->vdev.kvm);
> > +
> > +	return -ENOENT;
> >  }
> >  
> >  void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
> > @@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
> >  	if (!zdev || !vdev->vdev.kvm)
> >  		return;
> >  
> > -	kvm_s390_pci_unregister_kvm(zdev);
> > +	if (kvm_pci_hook.kvm_unregister)
> > +		return kvm_pci_hook.kvm_unregister(zdev);
> 
> No need for the return here, this is a void function calling a void function.
> 
> 
> Overall, this looks good to me and survives a series of compile and device passthrough tests on my end, just a matter of a few of these minor comments above.  Thanks for tackling this Pierre!

Yes I agree, overall this looks good to me though I'm admittedly not
very knowledgable about how to best handle module dependencies like
this. It does look cleaner than  the symbol_get() alternative we
discussed. 


