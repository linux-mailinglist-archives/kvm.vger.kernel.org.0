Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B07427240C
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgIUMnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:43:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgIUMnl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 08:43:41 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LCV9E1090209;
        Mon, 21 Sep 2020 08:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qrra0sXULDUNB2EVb+PbTcLQ4H6cQ5PFru1o8nfLTKk=;
 b=Fjr2yNsF5ugGeTUReyhDi94MkiFaAZH3aQkyTRmDtNJHwUn1oQa1J1kq8cd8OXuSxOMy
 7uJisY1nWRfzXG9+OdVwAzvKvQDPmPrpzw9hDVjcC3OV0U+Vc4Mb/cZStmA1pqwBx5c4
 lvrcCvbi+m9mvkqbKazEedNszavJNXfAPBFZHntjZITmvtNQEktxRelAA1kFItySgOc5
 fzxAb1oWWeDRRGkPwCV4Phqr5JA4QgmaCZGp1dmMQmDEtKRg9lHSUuchajH7LGbPR6HH
 NWMdJ12+kgdDy72Kj6tYhmBCt0/PF1RusYCgy23tFaeOUASQZiz6NIOWueS4cch5q+qq Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33pv0b8r4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 08:43:34 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08LCX629096161;
        Mon, 21 Sep 2020 08:43:34 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33pv0b8r4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 08:43:34 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08LCXdsw029988;
        Mon, 21 Sep 2020 12:43:33 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 33n9m8jxc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 12:43:33 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08LChVn622085974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 12:43:31 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B42A06A04D;
        Mon, 21 Sep 2020 12:43:31 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E7CB6A047;
        Mon, 21 Sep 2020 12:43:29 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.16.144])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 12:43:29 +0000 (GMT)
Subject: Re: [PATCH v5 3/3] vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks
 from is_virtfn
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
 <1599749997-30489-4-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <08afc6b2-7549-5440-a947-af0b598288c2@linux.ibm.com>
Date:   Mon, 21 Sep 2020 08:43:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1599749997-30489-4-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_03:2020-09-21,2020-09-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/20 10:59 AM, Matthew Rosato wrote:
> While it is true that devices with is_virtfn=1 will have a Memory Space
> Enable bit that is hard-wired to 0, this is not the only case where we
> see this behavior -- For example some bare-metal hypervisors lack
> Memory Space Enable bit emulation for devices not setting is_virtfn
> (s390). Fix this by instead checking for the newly-added
> no_command_memory bit which directly denotes the need for
> PCI_COMMAND_MEMORY emulation in vfio.
> 
> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

Polite ping on this patch as the other 2 have now received maintainer 
ACKs or reviews.  I'm concerned about this popping up in distros as 
abafbc551fdd was a CVE fix.  Related, see question from the cover:

- Restored the fixes tag to patch 3 (but the other 2 patches are
   now pre-reqs -- cc stable 5.8?)

Thanks,
Matt

> ---
>   drivers/vfio/pci/vfio_pci_config.c | 24 ++++++++++++++----------
>   1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d98843f..5076d01 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>   	 * PF SR-IOV capability, there's therefore no need to trigger
>   	 * faults based on the virtual value.
>   	 */
> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> +	return pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY);
>   }
>   
>   /*
> @@ -520,8 +520,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
>   
>   	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
>   
> -	/* Mask in virtual memory enable for SR-IOV devices */
> -	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
> +	/* Mask in virtual memory enable */
> +	if (offset == PCI_COMMAND && vdev->pdev->no_command_memory) {
>   		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
>   		u32 tmp_val = le32_to_cpu(*val);
>   
> @@ -589,9 +589,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
>   		 * shows it disabled (phys_mem/io, then the device has
>   		 * undergone some kind of backdoor reset and needs to be
>   		 * restored before we allow it to enable the bars.
> -		 * SR-IOV devices will trigger this, but we catch them later
> +		 * SR-IOV devices will trigger this - for mem enable let's
> +		 * catch this now and for io enable it will be caught later
>   		 */
> -		if ((new_mem && virt_mem && !phys_mem) ||
> +		if ((new_mem && virt_mem && !phys_mem &&
> +		     !pdev->no_command_memory) ||
>   		    (new_io && virt_io && !phys_io) ||
>   		    vfio_need_bar_restore(vdev))
>   			vfio_bar_restore(vdev);
> @@ -1734,12 +1736,14 @@ int vfio_config_init(struct vfio_pci_device *vdev)
>   				 vconfig[PCI_INTERRUPT_PIN]);
>   
>   		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
> -
> +	}
> +	if (pdev->no_command_memory) {
>   		/*
> -		 * VFs do no implement the memory enable bit of the COMMAND
> -		 * register therefore we'll not have it set in our initial
> -		 * copy of config space after pci_enable_device().  For
> -		 * consistency with PFs, set the virtual enable bit here.
> +		 * VFs and devices that set pdev->no_command_memory do not
> +		 * implement the memory enable bit of the COMMAND register
> +		 * therefore we'll not have it set in our initial copy of
> +		 * config space after pci_enable_device().  For consistency
> +		 * with PFs, set the virtual enable bit here.
>   		 */
>   		*(__le16 *)&vconfig[PCI_COMMAND] |=
>   					cpu_to_le16(PCI_COMMAND_MEMORY);
> 

