Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7BB59874F
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245443AbiHRPXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344321AbiHRPW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:22:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B692D80F6B;
        Thu, 18 Aug 2022 08:22:53 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IFE438014591;
        Thu, 18 Aug 2022 15:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=w2WkAmw1vMYK3whQms3To1iQqiK3ykCTrO6Ea1r0yJc=;
 b=Ta9fYT7wFUkS+8pk22c+iwzEhVO/M44aOUFRjck0/nVKZDUsKroKwVGIY2bBbi8XrFY2
 8I/fT2diZI9RrtgbuxT8Cl08X3X9HP5kLJ9FQsHXJn8r+Rn9QansdfkQuyh1ahfYBJX5
 aGA228e1KScsztvW6+GiQ7Jp88T9529+AoSIGBxD9SYAEMnrce359VTO8viRyBiTpjBX
 zhE1DbhsOyB2QY4SRR5NVJE5Oud0gOEQIdHo9+uECnirtnmC8fIIQmwYQz4C7UCsarvR
 vn0gxbUlE3RP5OYMLY3qt5nsTob2r5n2dRX3aTbj3nebALqDxKRpFjigltmm9u3olMKx Xg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1qvr89hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 15:22:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IFLA8a014952;
        Thu, 18 Aug 2022 15:22:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3hx3k94jwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 15:22:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IFMfM720054428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 15:22:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63684A405C;
        Thu, 18 Aug 2022 15:22:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2C15A405B;
        Thu, 18 Aug 2022 15:22:40 +0000 (GMT)
Received: from sig-9-145-148-40.de.ibm.com (unknown [9.145.148.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 15:22:40 +0000 (GMT)
Message-ID: <d780fd99ceef548b4bd815cf991d10602cb97b27.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Thu, 18 Aug 2022 17:22:40 +0200
In-Reply-To: <d874d06d-359d-0cc2-283b-cf4cfd5789e9@linux.ibm.com>
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
         <20220818102305.250702-1-pmorel@linux.ibm.com>
         <f797373e-c420-718a-443d-ae98ea0368c7@linux.ibm.com>
         <25e2364a71c52651f5227c0bc3f43fd193bc2e08.camel@linux.ibm.com>
         <d874d06d-359d-0cc2-283b-cf4cfd5789e9@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4PSPYNb_nc8_a0FxTY3APbduT1U3O3bb
X-Proofpoint-GUID: 4PSPYNb_nc8_a0FxTY3APbduT1U3O3bb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-18 at 11:13 -0400, Matthew Rosato wrote:
> On 8/18/22 10:20 AM, Niklas Schnelle wrote:
> > On Thu, 2022-08-18 at 09:33 -0400, Matthew Rosato wrote:
> > > On 8/18/22 6:23 AM, Pierre Morel wrote:
> > > > We have a cross dependency between KVM and VFIO.
> > > 
> > > maybe add something like 'when using s390 vfio_pci_zdev extensions for PCI passthrough'
> > > 
> > > > To be able to keep both subsystem modular we add a registering
> > > > hook inside the S390 core code.
> > > > 
> > > > This fixes a build problem when VFIO is built-in and KVM is built
> > > > as a module or excluded.
> > > 
> > > s/or excluded//
> > > 
> > > There's no problem when KVM is excluded, that forces CONFIG_VFIO_PCI_ZDEV_KVM=n because of the 'depends on S390 && KVM'.
> > > 
> > > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
> > > > Cc: <stable@vger.kernel.org>
> > > > ---
> > > >  arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
> > > >  arch/s390/kvm/pci.c              | 10 ++++++----
> > > >  arch/s390/pci/Makefile           |  2 ++
> > > >  arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
> > > >  drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
> > > >  5 files changed, 31 insertions(+), 17 deletions(-)
> > > >  create mode 100644 arch/s390/pci/pci_kvm_hook.c
> > > > 
> > > > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > > > index f39092e0ceaa..8312ed9d1937 100644
> > > > --- a/arch/s390/include/asm/kvm_host.h
> > > > +++ b/arch/s390/include/asm/kvm_host.h
> > 
> > I added Janosch as second S390 KVM maintainer in case he wants to chime
> > in.
> > 
> > > > @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> > > >  #define __KVM_HAVE_ARCH_VM_FREE
> > > >  void kvm_arch_free_vm(struct kvm *kvm);
> > > >  
> > > > -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> > > > -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
> > > > -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
> > > > -#else
> > > > -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
> > > > -					    struct kvm *kvm)
> > > > -{
> > > > -	return -EPERM;
> > > > -}
> > > > -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
> > > > -#endif
> > > > +struct kvm_register_hook {
> > > 
> > > Nit: zpci_kvm_register_hook ?  Just to make it clear it's for zpci.
> > 
> > Hmm, I guess one could re-use the same struct for another such KVM
> > dependency but I lean towards the same thinking as Matt, for now this
> > is for zpci so stay specific we can always generalize later.
> 
> Yes, let's keep this zpci-specific. 
> 
> > Nit: For me hook and register together sound a bit redudant, maybe
> > "zpci_kvm_register"? Also question for Matt as a native speaker, should
> > it rather be "registration" when used as a noun here?
> > 
> 
> Maybe just drop the 'register'.  If there is a need for a 3rd function later, for example, it might not be related to registration.

Yes, that sounds good and makes sense so "zpci_kvm_hook".

> 
> e.g. struct kvm_zpci_hook {
>    ...
> };
> 
> extern struct kvm_zpci_hook zpci_kvm;
> 
---8<---
> > > 
> > > > diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
> > > > new file mode 100644
> > > > index 000000000000..9d8799b72dbf
> > > > --- /dev/null
> > > > +++ b/arch/s390/pci/pci_kvm_hook.c
> > > > @@ -0,0 +1,11 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * VFIO ZPCI devices support
> > > > + *
> > > > + * Copyright (C) IBM Corp. 2022.  All rights reserved.
> > > > + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
> > > > + */
> > > > +#include <linux/kvm_host.h>
> > > > +
> > > > +struct kvm_register_hook kvm_pci_hook;
> > > > +EXPORT_SYMBOL_GPL(kvm_pci_hook);
> > > 
> > > Following the comments above, zpci_kvm_register_hook, kvm_zpci_hook ?
> > > 
> > > I'm not sure if this really needs to be in a separate file or if it could just go into arch/s390/pci.c with the zpci_aipb -- If going the route of a separate file, up to Niklas whether he wants this under the S390 PCI maintainership or added to the list for s390 vfio-pci like arch/kvm/pci* and vfio_pci_zdev.
> > 
> > I'm fine with a separate file, pci.c is long enough as it is. I also
> > don't have a problem with having it maintained as part of S390 PCI but
> > logically I think it does fall more under arch/kvm/pci* so one could
> > argue it should be added in the MAINTAINERS file in that section.
> > If you change the struct name as I proposed above I would probably go
> > with "pci_kvm_register.c"
> 
> OK, no problem with me for a separate file then, or maintaining said file.  But I guess not pci_kvm_register.c per my comments above

Yes, let's go with pci_kvm_hook.c then

> 


