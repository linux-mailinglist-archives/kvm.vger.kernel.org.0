Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E095A55CCF8
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbiF1KtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345069AbiF1KtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:49:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD2F642D;
        Tue, 28 Jun 2022 03:49:14 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAiLsd003735;
        Tue, 28 Jun 2022 10:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fmpb0wcBdoPIzWzuYUqjEOmeD8LGLBFtvd3wORyXxAw=;
 b=p6DycO9WfUbZ44RxatRdkYN5YtK367nQxEfAlAK9Il4A8qbQ2nndNJOfg+6/uq6ehzp6
 6LcUy6qB+IqAuX1OLin88SKeNOkrs1gsNLXG5zXMF7IW0vOZgyJPH/ihPAaS9JR6KnQy
 yzjCG79jGimIGFaUgh9+PVN+837N6II06/eiLDywmwBLhvAGM7Kt7LTC5/ANR9Po66XB
 zAgPfbTeq4HSw7lyB9duDIJVoFNO94TDpauWq7/chilw4/E6OfxXCT9YrC/GfyG80fUC
 3JJMrIxt0FK/6PHfROLndXeTkrl8H0L1X9KQB4nlmrZ6/xuAidpWENCGaNVLkFkfgwtk 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h005er44v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:49:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SAk8u0013577;
        Tue, 28 Jun 2022 10:49:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h005er440-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:49:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SAYuFS013631;
        Tue, 28 Jun 2022 10:49:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08vpc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:49:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SAn5o916580944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 10:49:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9124AAE045;
        Tue, 28 Jun 2022 10:49:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EEEAAE04D;
        Tue, 28 Jun 2022 10:49:04 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 10:49:04 +0000 (GMT)
Message-ID: <7a9990ca-b591-1351-8848-8d7c59449b12@linux.ibm.com>
Date:   Tue, 28 Jun 2022 12:53:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 16/21] KVM: s390: pci: add routines to start/stop
 interpretive execution
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <20220606203325.110625-17-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220606203325.110625-17-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AIQL6y6-jHRgvurYtbZJhww-7X7lCgwN
X-Proofpoint-GUID: T7_4ryaPSEX1_2JxnPiYa-SkIYvZyhHV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_05,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/6/22 22:33, Matthew Rosato wrote:
> These routines will be invoked at the time an s390x vfio-pci device is
> associated with a KVM (or when the association is removed), allowing
> the zPCI device to enable or disable load/store intepretation mode;
> this requires the host zPCI device to inform firmware of the unique
> token (GISA designation) that is associated with the owning KVM.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  18 ++++
>   arch/s390/include/asm/pci.h      |   1 +
>   arch/s390/kvm/kvm-s390.c         |  15 +++
>   arch/s390/kvm/pci.c              | 162 +++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h              |   5 +
>   arch/s390/pci/pci.c              |   4 +
>   6 files changed, 205 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 8e381603b6a7..6e83d746bae2 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>   #include <linux/kvm.h>
>   #include <linux/seqlock.h>
>   #include <linux/module.h>
> +#include <linux/pci.h>
>   #include <asm/debug.h>
>   #include <asm/cpu.h>
>   #include <asm/fpu/api.h>
> @@ -967,6 +968,8 @@ struct kvm_arch{
>   	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>   	struct kvm_s390_gisa_interrupt gisa_int;
>   	struct kvm_s390_pv pv;
> +	struct list_head kzdev_list;
> +	spinlock_t kzdev_list_lock;
>   };
>   
>   #define KVM_HVA_ERR_BAD		(-1UL)
> @@ -1017,4 +1020,19 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
> +#define __KVM_HAVE_ARCH_VM_FREE
> +void kvm_arch_free_vm(struct kvm *kvm);
> +
> +#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> +int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
> +void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
> +#else
> +static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
> +					    struct kvm *kvm)
> +{
> +	return -EPERM;
> +}
> +static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
> +#endif
> +
>   #endif
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 322060a75d9f..85eb0ef9d4c3 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -194,6 +194,7 @@ struct zpci_dev {
>   	/* IOMMU and passthrough */
>   	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>   	struct kvm_zdev *kzdev;
> +	struct mutex kzdev_lock;

I guess that since it did not exist before the lock is not there to 
protect the zpci_dev struct.
May be add a comment to say what it is protecting.


>   };
>   
>   static inline bool zdev_enabled(struct zpci_dev *zdev)
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index a66da3f66114..4758bb731199 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2790,6 +2790,14 @@ static void sca_dispose(struct kvm *kvm)
>   	kvm->arch.sca = NULL;
>   }
>   
> +void kvm_arch_free_vm(struct kvm *kvm)
> +{
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
> +		kvm_s390_pci_clear_list(kvm);
> +
> +	__kvm_arch_free_vm(kvm);
> +}
> +
>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
>   	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
> @@ -2872,6 +2880,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	kvm_s390_crypto_init(kvm);
>   
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_pci_init_list(kvm);
> +		kvm_s390_vcpu_pci_enable_interp(kvm);
> +		mutex_unlock(&kvm->lock);
> +	}
> +
>   	mutex_init(&kvm->arch.float_int.ais_lock);
>   	spin_lock_init(&kvm->arch.float_int.lock);
>   	for (i = 0; i < FIRQ_LIST_COUNT; i++)
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index b232c8cbaa81..24211741deb0 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -12,7 +12,9 @@
>   #include <asm/pci.h>
>   #include <asm/pci_insn.h>
>   #include <asm/pci_io.h>
> +#include <asm/sclp.h>
>   #include "pci.h"
> +#include "kvm-s390.h"
>   
>   struct zpci_aift *aift;
>   
> @@ -423,6 +425,166 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>   	kfree(kzdev);
>   }
>   
> +
> +/*
> + * Register device with the specified KVM. If interpetation facilities are
> + * available, enable them and let userspace indicate whether or not they will
> + * be used (specify SHM bit to disable).
> + */
> +int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> +{
> +	int rc;
> +
> +	if (!zdev)
> +		return -EINVAL;
> +
> +	mutex_lock(&zdev->kzdev_lock);
> +
> +	if (zdev->kzdev || zdev->gisa != 0 || !kvm) {
> +		mutex_unlock(&zdev->kzdev_lock);
> +		return -EINVAL;
> +	}
> +
> +	kvm_get_kvm(kvm);
> +
> +	mutex_lock(&kvm->lock);

Why do we need to lock KVM here?

just a question, I do not think it is a big problem.

> +
> +	rc = kvm_s390_pci_dev_open(zdev);
> +	if (rc)
> +		goto err;
> +
> +	/*
> +	 * If interpretation facilities aren't available, add the device to
> +	 * the kzdev list but don't enable for interpretation.
> +	 */
> +	if (!kvm_s390_pci_interp_allowed())
> +		goto out;
> +
> +	/*
> +	 * If this is the first request to use an interpreted device, make the
> +	 * necessary vcpu changes
> +	 */
> +	if (!kvm->arch.use_zpci_interp)
> +		kvm_s390_vcpu_pci_enable_interp(kvm);
> +
> +	if (zdev_enabled(zdev)) {
> +		rc = zpci_disable_device(zdev);
> +		if (rc)
> +			goto err;
> +	}
> +
> +	/*
> +	 * Store information about the identity of the kvm guest allowed to
> +	 * access this device via interpretation to be used by host CLP
> +	 */
> +	zdev->gisa = (u32)virt_to_phys(&kvm->arch.sie_page2->gisa);
> +
> +	rc = zpci_enable_device(zdev);
> +	if (rc)
> +		goto clear_gisa;
> +
> +	/* Re-register the IOMMU that was already created */
> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
> +				virt_to_phys(zdev->dma_table));
> +	if (rc)
> +		goto clear_gisa;
> +
> +out:
> +	zdev->kzdev->kvm = kvm;
> +
> +	spin_lock(&kvm->arch.kzdev_list_lock);
> +	list_add_tail(&zdev->kzdev->entry, &kvm->arch.kzdev_list);
> +	spin_unlock(&kvm->arch.kzdev_list_lock);
> +
> +	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&zdev->kzdev_lock);
> +	return 0;
> +
> +clear_gisa:
> +	zdev->gisa = 0;
> +err:
> +	if (zdev->kzdev)
> +		kvm_s390_pci_dev_release(zdev);
> +	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&zdev->kzdev_lock);
> +	kvm_put_kvm(kvm);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
> +
> +void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
> +{
> +	struct kvm *kvm;
> +
> +	if (!zdev)
> +		return;
> +
> +	mutex_lock(&zdev->kzdev_lock);
> +
> +	if (WARN_ON(!zdev->kzdev)) {

When can this happen ?

> +		mutex_unlock(&zdev->kzdev_lock);
> +		return;
> +	}
> +
> +	kvm = zdev->kzdev->kvm;
> +	mutex_lock(&kvm->lock);
> +
> +	/*
> +	 * A 0 gisa means interpretation was never enabled, just remove the
> +	 * device from the list.
> +	 */
> +	if (zdev->gisa == 0)
> +		goto out;
> +
> +	/* Forwarding must be turned off before interpretation */
> +	if (zdev->kzdev->fib.fmt0.aibv != 0)
> +		kvm_s390_pci_aif_disable(zdev, true);
> +
> +	/* Remove the host CLP guest designation */
> +	zdev->gisa = 0;
> +
> +	if (zdev_enabled(zdev)) {
> +		if (zpci_disable_device(zdev))
> +			goto out;

NIT debug trace ?

> +	}
> +
> +	if (zpci_enable_device(zdev))
> +		goto out;

NIT debug trace?

Only some questions, otherwise, LGTM

Acked-by: Pierre Morel <pmorel@linux.ibm.com>

-- 
Pierre Morel
IBM Lab Boeblingen
