Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BCB24FFBA
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 16:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHXOVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 10:21:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgHXOVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Aug 2020 10:21:35 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OE37sh104032;
        Mon, 24 Aug 2020 10:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1wD5iP9XXFrhZGWRafnNIFyc1TmmQnE+W/MmRp+/g7I=;
 b=Sp02BRdgU7dAN1klrEDeEIhCPw+EQppk+YPeMU8+kuhi0lLLjjRWBdLF87xnUlzauJuc
 4EZPHRypkF3nVpJLxVl0EcMbXgk5yus07RoJC6L+aj5OSmEI/CenjLcM7m3+SrtAV/xO
 gerMW0tGxRGdyQGU768CuQBsvIw7aPtzvjjtEpTJD1keCuuxTQWt9/DxxtRj7COFJnFx
 4ZUpLsmkYlGM3vvU8ljR2tox4svqDT7AukidjQrRbpuVPuN5TEJOFEAzlDts+CLInhJn
 3qcCuJfPkVBLiGI/qCc51jgI+yuMXgPsxNBZyN2Tn5xBhC+L3RtubppE7qoBnRKkFb2c QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 334ev4rwn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 10:21:29 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07OE3gdA106661;
        Mon, 24 Aug 2020 10:21:29 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 334ev4rwmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 10:21:29 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07OEBoRP024344;
        Mon, 24 Aug 2020 14:21:28 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 332uttxasb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 14:21:28 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07OELNCH28901678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 14:21:23 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C41BE051;
        Mon, 24 Aug 2020 14:21:26 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB26CBE04F;
        Mon, 24 Aug 2020 14:21:25 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.88.114])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Aug 2020 14:21:25 +0000 (GMT)
Subject: Re: [PATCH v3] PCI: Introduce flag for detached virtual functions
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1597333243-29483-1-git-send-email-mjrosato@linux.ibm.com>
 <1597333243-29483-2-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <6917634d-0976-6f7b-6efc-a7a855686fb9@linux.ibm.com>
Date:   Mon, 24 Aug 2020 10:21:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597333243-29483-2-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/20 11:40 AM, Matthew Rosato wrote:
> s390x has the notion of providing VFs to the kernel in a manner
> where the associated PF is inaccessible other than via firmware.
> These are not treated as typical VFs and access to them is emulated
> by underlying firmware which can still access the PF.  After
> the referened commit however these detached VFs were no longer able
> to work with vfio-pci as the firmware does not provide emulation of
> the PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
> these detached VFs so that vfio-pci can allow memory access to
> them again. >
> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Polite ping - If unhappy with the approach moving in this direction, I 
have also played around with Alex's prior suggestion of a dev_flags bit 
that denotes a device that doesn't implement PCI_COMMAND_MEMORY.  Please 
advise.

> ---
>   arch/s390/pci/pci_bus.c            | 13 +++++++++++++
>   drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
>   include/linux/pci.h                |  4 ++++
>   3 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
> index 642a993..1b33076 100644
> --- a/arch/s390/pci/pci_bus.c
> +++ b/arch/s390/pci/pci_bus.c
> @@ -184,6 +184,19 @@ static inline int zpci_bus_setup_virtfn(struct zpci_bus *zbus,
>   }
>   #endif
>   
> +void pcibios_bus_add_device(struct pci_dev *pdev)
> +{
> +	struct zpci_dev *zdev = to_zpci(pdev);
> +
> +	/*
> +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
> +	 * detached from its parent PF.  We rely on firmware emulation to
> +	 * provide underlying PF details.
> +	 */
> +	if (zdev->vfn && !zdev->zbus->multifunction)
> +		pdev->detached_vf = 1;
> +}
> +
>   static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
>   {
>   	struct pci_bus *bus;
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d98843f..98f93d1 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>   	 * PF SR-IOV capability, there's therefore no need to trigger
>   	 * faults based on the virtual value.
>   	 */
> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> +	return dev_is_vf(&pdev->dev) || (cmd & PCI_COMMAND_MEMORY);
>   }
>   
>   /*
> @@ -420,7 +420,7 @@ static void vfio_bar_restore(struct vfio_pci_device *vdev)
>   	u16 cmd;
>   	int i;
>   
> -	if (pdev->is_virtfn)
> +	if (dev_is_vf(&pdev->dev))
>   		return;
>   
>   	pci_info(pdev, "%s: reset recovery - restoring BARs\n", __func__);
> @@ -521,7 +521,7 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
>   	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
>   
>   	/* Mask in virtual memory enable for SR-IOV devices */
> -	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
> +	if ((offset == PCI_COMMAND) && (dev_is_vf(&vdev->pdev->dev))) {
>   		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
>   		u32 tmp_val = le32_to_cpu(*val);
>   
> @@ -1713,7 +1713,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
>   	vdev->rbar[5] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_5]);
>   	vdev->rbar[6] = le32_to_cpu(*(__le32 *)&vconfig[PCI_ROM_ADDRESS]);
>   
> -	if (pdev->is_virtfn) {
> +	if (dev_is_vf(&pdev->dev)) {
>   		*(__le16 *)&vconfig[PCI_VENDOR_ID] = cpu_to_le16(pdev->vendor);
>   		*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(pdev->device);
>   
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8355306..7c062de 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -445,6 +445,7 @@ struct pci_dev {
>   	unsigned int	is_probed:1;		/* Device probing in progress */
>   	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
>   	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
> +	unsigned int	detached_vf:1;		/* VF without local PF access */
>   	pci_dev_flags_t dev_flags;
>   	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>   
> @@ -1057,6 +1058,8 @@ struct resource *pci_find_parent_resource(const struct pci_dev *dev,
>   void pci_sort_breadthfirst(void);
>   #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
>   #define dev_is_pf(d) ((dev_is_pci(d) ? to_pci_dev(d)->is_physfn : false))
> +#define dev_is_vf(d) ((dev_is_pci(d) ? (to_pci_dev(d)->is_virtfn || \
> +					to_pci_dev(d)->detached_vf) : false))
>   
>   /* Generic PCI functions exported to card drivers */
>   
> @@ -1764,6 +1767,7 @@ static inline struct pci_dev *pci_get_domain_bus_and_slot(int domain,
>   
>   #define dev_is_pci(d) (false)
>   #define dev_is_pf(d) (false)
> +#define dev_is_vf(d) (false)
>   static inline bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>   { return false; }
>   static inline int pci_irqd_intx_xlate(struct irq_domain *d,
> 

