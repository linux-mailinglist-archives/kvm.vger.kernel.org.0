Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01665995D4
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 09:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346737AbiHSHO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 03:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344799AbiHSHO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 03:14:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114AC5A834;
        Fri, 19 Aug 2022 00:14:26 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J6vJDF019555;
        Fri, 19 Aug 2022 07:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=NDqSL7LiGCY8B2iIgXomfKnfWzDtxGdDzF5js3ZXHMA=;
 b=ltGcLmgV+N0fy9GpjjEFtHUDLtpwU/ngK2jU4/d8OxLx5IXw4XZR1Sfy+8BH4t3py04Z
 vEPTSJp5QPBfbRMbOjiRe65P4g9/KG27g0k32LZWM2SQHG2sY08Wbe1jkyABjA9GpSLK
 dnbzDCEZfW1r1bviRNMSzM2ExsYwQyi7DO17j/oh3VTijBySoC/EE4ltXg/24fPlUM1s
 M6i17cQ1glZYcoyXAEi4sBnXL7jiIfMWPFsOeQC2YT6BoP40RrD/aCY49xUOIUtCZvOI
 XU/Y/5w/y8lT/cOxd0gaVO85x5PC9ATrb4HeoNf9mevDDoSqZRjcc9Ovthy8j7fkZBYU 2w== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j25q38j8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 07:14:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J75cOn009081;
        Fri, 19 Aug 2022 07:14:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3hx37j56be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 07:14:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J7E1YK27001194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 07:14:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42D89A4051;
        Fri, 19 Aug 2022 07:14:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94986A4040;
        Fri, 19 Aug 2022 07:14:00 +0000 (GMT)
Received: from sig-9-145-84-131.uk.ibm.com (unknown [9.145.84.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 07:14:00 +0000 (GMT)
Message-ID: <2ae0bf9abffe2eb3eb2fb3f84873720d39f73d4d.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, frankja@linux.ibm.com
Date:   Fri, 19 Aug 2022 09:14:00 +0200
In-Reply-To: <20220818164652.269336-1-pmorel@linux.ibm.com>
References: <20220818164652.269336-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oKmNbx1-bCpE1do3mObam7uNZX17Mf3H
X-Proofpoint-ORIG-GUID: oKmNbx1-bCpE1do3mObam7uNZX17Mf3H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_03,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208190025
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-18 at 18:46 +0200, Pierre Morel wrote:
> We have a cross dependency between KVM and VFIO when using
> s390 vfio_pci_zdev extensions for PCI passthrough
> To be able to keep both subsystem modular we add a registering
> hook inside the S390 core code.
> 
> This fixes a build problem when VFIO is built-in and KVM is built
> as a module.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")

Please don't shorten the Fixes tag, the subject line is likely also
checked by some automated tools. It's okay for this line to be over the
column limit and checkpatch.pl --strict also accepts it.

> Cc: <stable@vger.kernel.org>
> ---
>  arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>  arch/s390/kvm/pci.c              | 10 ++++++----
>  arch/s390/pci/Makefile           |  2 ++
>  arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>  drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>  5 files changed, 31 insertions(+), 17 deletions(-)
>  create mode 100644 arch/s390/pci/pci_kvm_hook.c
> 
> 
---8<---
>  
>  	kvm_put_kvm(kvm);
>  }
> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>  
>  void kvm_s390_pci_init_list(struct kvm *kvm)
>  {
> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>  
>  	spin_lock_init(&aift->gait_lock);
>  	mutex_init(&aift->aift_lock);
> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>  
>  	return 0;
>  }
> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> index bf557a1b789c..c02dbfb415d9 100644
> --- a/arch/s390/pci/Makefile
> +++ b/arch/s390/pci/Makefile
> @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>  			   pci_bus.o
>  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
> +
> +obj-y += pci_kvm_hook.o

I thought we wanted to compile this only for CONFIG_PCI?

> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
> new file mode 100644
> index 000000000000..ff34baf50a3e
---8<---

