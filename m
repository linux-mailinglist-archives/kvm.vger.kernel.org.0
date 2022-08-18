Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AD8598562
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 16:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245114AbiHROGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 10:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245661AbiHROGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 10:06:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F8075CFE;
        Thu, 18 Aug 2022 07:06:14 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IE0gkG016987;
        Thu, 18 Aug 2022 14:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gR1gaCzyh6v5gEqbl50ozpVo3lmNtojm4C+1Oao88Vo=;
 b=tq5f/rkqaIM1RSf3YUAplqtJqzjZ8zxuj0HFMuI5db2ZYrDUDclx+J5A4f98kz975v5/
 MEU6TmNrsr2CNc1RaRbuKC8aJnN9vgYhaYyB72OP2GbHCq6HYUPcmS2TsZGWtrz/NbrB
 7mkrp//pWKDDujsM7ZMBp+1mT5jfnd/QyXgybQ4i8DAGKsQyS4bppYkPbMMSumETGGXQ
 t4ZvKI5QBaFIORD5X4Pq9eB7Fprbyg2ak6TUXuXlcIDI4zbCHggSXLeU1M6r6CYECNyE
 xdxYxqE3s4AB1cj7P8yWlDPwcu7sQcxcjw+bFl+CzmdOYtf9KG1TR2guIbhwpcQrn94Q Bw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1pthr57d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:06:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IE5CEG008471;
        Thu, 18 Aug 2022 14:06:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3hx37j4hcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:06:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IE65Vk30540214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 14:06:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAE844203F;
        Thu, 18 Aug 2022 14:06:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BB6F42042;
        Thu, 18 Aug 2022 14:06:04 +0000 (GMT)
Received: from [9.171.73.125] (unknown [9.171.73.125])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 14:06:04 +0000 (GMT)
Message-ID: <955ef95a-df7c-9e66-43ec-4495a79f51d3@linux.ibm.com>
Date:   Thu, 18 Aug 2022 16:06:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, schnelle@linux.ibm.com
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
 <20220818102305.250702-1-pmorel@linux.ibm.com>
 <f797373e-c420-718a-443d-ae98ea0368c7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <f797373e-c420-718a-443d-ae98ea0368c7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M747w6OvZAK9jK8uOMuW11tNYc0Fq5au
X-Proofpoint-GUID: M747w6OvZAK9jK8uOMuW11tNYc0Fq5au
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/18/22 15:33, Matthew Rosato wrote:
> On 8/18/22 6:23 AM, Pierre Morel wrote:
>> We have a cross dependency between KVM and VFIO.
> 
> maybe add something like 'when using s390 vfio_pci_zdev extensions for PCI passthrough'
> 
>> To be able to keep both subsystem modular we add a registering
>> hook inside the S390 core code.
>>
>> This fixes a build problem when VFIO is built-in and KVM is built
>> as a module or excluded.
> 
> s/or excluded//
> 
> There's no problem when KVM is excluded, that forces CONFIG_VFIO_PCI_ZDEV_KVM=n because of the 'depends on S390 && KVM'.

OK

> 
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
>> Cc: <stable@vger.kernel.org>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>>   arch/s390/kvm/pci.c              | 10 ++++++----
>>   arch/s390/pci/Makefile           |  2 ++
>>   arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>>   drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>>   5 files changed, 31 insertions(+), 17 deletions(-)
>>   create mode 100644 arch/s390/pci/pci_kvm_hook.c
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index f39092e0ceaa..8312ed9d1937 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>   #define __KVM_HAVE_ARCH_VM_FREE
>>   void kvm_arch_free_vm(struct kvm *kvm);
>>   
>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>> -#else
>> -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
>> -					    struct kvm *kvm)
>> -{
>> -	return -EPERM;
>> -}
>> -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
>> -#endif
>> +struct kvm_register_hook {
> 
> Nit: zpci_kvm_register_hook ?  Just to make it clear it's for zpci.

OK


> 
>> +	int (*kvm_register)(void *opaque, struct kvm *kvm);
>> +	void (*kvm_unregister)(void *opaque);
>> +};
>> +
>> +extern struct kvm_register_hook kvm_pci_hook;
> 
> Nit: kvm_zpci_hook ?

OK too,

> 
>>   
>>   #endif
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index 4946fb7757d6..e173fce64c4f 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>>    * available, enable them and let userspace indicate whether or not they will
>>    * be used (specify SHM bit to disable).
>>    */
>> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>> +static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
>>   {
>> +	struct zpci_dev *zdev = opaque;
>>   	int rc;
>>   
>>   	if (!zdev)
>> @@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>>   	kvm_put_kvm(kvm);
>>   	return rc;
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
>>   
>> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>> +static void kvm_s390_pci_unregister_kvm(void *opaque)
>>   {
>> +	struct zpci_dev *zdev = opaque;
>>   	struct kvm *kvm;
>>   
>>   	if (!zdev)
>> @@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>>   
>>   	kvm_put_kvm(kvm);
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>>   
>>   void kvm_s390_pci_init_list(struct kvm *kvm)
>>   {
>> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>>   
>>   	spin_lock_init(&aift->gait_lock);
>>   	mutex_init(&aift->aift_lock);
>> +	kvm_pci_hook.kvm_register = kvm_s390_pci_register_kvm;
>> +	kvm_pci_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>>   
>>   	return 0;
>>   }
>> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
>> index bf557a1b789c..c02dbfb415d9 100644
>> --- a/arch/s390/pci/Makefile
>> +++ b/arch/s390/pci/Makefile
>> @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>>   			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>>   			   pci_bus.o
>>   obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
>> +
>> +obj-y += pci_kvm_hook.o
> 
> I guess it doesn't harm anything to add this unconditionally, but I think it would also be OK to just include this in the CONFIG_PCI list - vfio_pci_zdev and arch/s390/kvm/pci all rely on CONFIG_PCI via CONFIG_VFIO_PCI_ZDEV_KVM which implies PCI via VFIO_PCI.

Right,CONFIG_PCI is a bool so we can put the hook in arch/s390/pci/pci.c 
and use a defined(CONFIG_PCI) to protect the initialization inside KVM.



> 
>> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
>> new file mode 100644
>> index 000000000000..9d8799b72dbf
>> --- /dev/null
>> +++ b/arch/s390/pci/pci_kvm_hook.c
>> @@ -0,0 +1,11 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * VFIO ZPCI devices support
>> + *
>> + * Copyright (C) IBM Corp. 2022.  All rights reserved.
>> + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + */
>> +#include <linux/kvm_host.h>
>> +
>> +struct kvm_register_hook kvm_pci_hook;
>> +EXPORT_SYMBOL_GPL(kvm_pci_hook);
> 
> Following the comments above, zpci_kvm_register_hook, kvm_zpci_hook ?

OK

> 
> I'm not sure if this really needs to be in a separate file or if it could just go into arch/s390/pci.c with the zpci_aipb -- If going the route of a separate file, up to Niklas whether he wants this under the S390 PCI maintainership or added to the list for s390 vfio-pci like arch/kvm/pci* and vfio_pci_zdev.

agreed no need for a separate file, it is much better.

> 
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index e163aa9f6144..3b7a707e2fe5 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   	if (!vdev->vdev.kvm)
>>   		return 0;
>>   
>> -	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
>> +	if (kvm_pci_hook.kvm_register)
>> +		return kvm_pci_hook.kvm_register(zdev, vdev->vdev.kvm);
>> +
>> +	return -ENOENT;
>>   }
>>   
>>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>> @@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>   	if (!zdev || !vdev->vdev.kvm)
>>   		return;
>>   
>> -	kvm_s390_pci_unregister_kvm(zdev);
>> +	if (kvm_pci_hook.kvm_unregister)
>> +		return kvm_pci_hook.kvm_unregister(zdev);
> 
> No need for the return here, this is a void function calling a void function.

right.

> 
> 
> Overall, this looks good to me and survives a series of compile and device passthrough tests on my end, just a matter of a few of these minor comments above.  Thanks for tackling this Pierre!
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
