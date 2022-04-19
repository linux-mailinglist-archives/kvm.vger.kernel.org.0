Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974625079EF
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 21:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353460AbiDSTOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 15:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353316AbiDSTOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 15:14:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C877D3B3F4
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:12:03 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JI7hw9020752;
        Tue, 19 Apr 2022 19:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xBsDqhFgz2SxErr+ehiqLXeiKjLkm19lQ7QrM8d/7Jg=;
 b=nhWYUd3Yv4m/gQhEZcIBzFw8WELNeticnD7lSlLtrmOgR8SehO5ExZ6q8nvC9pZdTJyk
 +cvMnMkT1QW6hKkwKHyloO+tm51SvVqpM2bLb2VkkW/9MbsxGdcGVgEfd9efo+poV3Sv
 AfoSuwoPcHIHXq+D/tWlKlfAT4c9pt6Z3BfercxBQDBAf4q5Bvr6diNBSrwrtWZsmain
 Wi4RIkfSOWcjy4rYCP2y/73RzvXqdh82rV9RAAySRMBVUvxaMmStMWCaXq0uFyF3qMy3
 hNV1lx2GuNGL9uojHLHaqWTLzCk18FMNcY9mbTss0ey0GUdIpYyQcK6RJdWRIoLTVqXg ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqdd7yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:11:58 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23JIRVkq022915;
        Tue, 19 Apr 2022 19:11:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqdd7xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:11:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23JJ2xkr016022;
        Tue, 19 Apr 2022 19:11:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u2c6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:11:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23JIx5D736503976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:59:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD44242041;
        Tue, 19 Apr 2022 19:11:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15E234203F;
        Tue, 19 Apr 2022 19:11:51 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 19:11:50 +0000 (GMT)
Message-ID: <70a9d770-08dd-cf61-7c54-8bef0c84b208@linux.ibm.com>
Date:   Tue, 19 Apr 2022 21:15:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 4/9] s390x/pci: add routine to get host function handle
 from CLP info
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-5-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OAJwUxsrmLmKX7yLIPmXOGiX7thGgbYg
X-Proofpoint-ORIG-GUID: AzmQgznA2tQbrEMrwzUYv9vjHMV_UbnB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_07,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190109
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 20:17, Matthew Rosato wrote:
> In order to interface with the underlying host zPCI device, we need
> to know it's function handle.  Add a routine to grab this from the
> vfio CLP capabilities chain.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   hw/s390x/s390-pci-vfio.c         | 83 ++++++++++++++++++++++++++------
>   include/hw/s390x/s390-pci-vfio.h |  6 +++
>   2 files changed, 73 insertions(+), 16 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 6f80a47e29..4bf0a7e22d 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -124,6 +124,27 @@ static void s390_pci_read_base(S390PCIBusDevice *pbdev,
>       pbdev->zpci_fn.pft = 0;
>   }
>   
> +static bool get_host_fh(S390PCIBusDevice *pbdev, struct vfio_device_info *info,
> +                        uint32_t *fh)
> +{
> +    struct vfio_info_cap_header *hdr;
> +    struct vfio_device_info_cap_zpci_base *cap;
> +    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +
> +    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
> +
> +    /* Can only get the host fh with version 2 or greater */
> +    if (hdr == NULL || hdr->version < 2) {
> +        trace_s390_pci_clp_cap(vpci->vbasedev.name,
> +                               VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
> +        return false;
> +    }
> +    cap = (void *) hdr;
> +
> +    *fh = cap->fh;
> +    return true;
> +}
> +
>   static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>                                   struct vfio_device_info *info)
>   {
> @@ -217,25 +238,13 @@ static void s390_pci_read_pfip(S390PCIBusDevice *pbdev,
>       memcpy(pbdev->zpci_fn.pfip, cap->pfip, CLP_PFIP_NR_SEGMENTS);
>   }
>   
> -/*
> - * This function will issue the VFIO_DEVICE_GET_INFO ioctl and look for
> - * capabilities that contain information about CLP features provided by the
> - * underlying host.
> - * On entry, defaults have already been placed into the guest CLP response
> - * buffers.  On exit, defaults will have been overwritten for any CLP features
> - * found in the capability chain; defaults will remain for any CLP features not
> - * found in the chain.
> - */
> -void s390_pci_get_clp_info(S390PCIBusDevice *pbdev)
> +static struct vfio_device_info *get_device_info(S390PCIBusDevice *pbdev,
> +                                                uint32_t argsz)
>   {
> -    g_autofree struct vfio_device_info *info = NULL;
> +    struct vfio_device_info *info = g_malloc0(argsz);
>       VFIOPCIDevice *vfio_pci;
> -    uint32_t argsz;
>       int fd;
>   
> -    argsz = sizeof(*info);
> -    info = g_malloc0(argsz);
> -
>       vfio_pci = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
>       fd = vfio_pci->vbasedev.fd;
>   
> @@ -250,7 +259,8 @@ retry:
>   
>       if (ioctl(fd, VFIO_DEVICE_GET_INFO, info)) {
>           trace_s390_pci_clp_dev_info(vfio_pci->vbasedev.name);
> -        return;
> +        free(info);
> +        return NULL;
>       }
>   
>       if (info->argsz > argsz) {
> @@ -259,6 +269,47 @@ retry:
>           goto retry;
>       }
>   
> +    return info;
> +}
> +
> +/*
> + * Get the host function handle from the vfio CLP capabilities chain.  Returns
> + * true if a fh value was placed into the provided buffer.  Returns false
> + * if a fh could not be obtained (ioctl failed or capabilitiy version does
> + * not include the fh)
> + */
> +bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev, uint32_t *fh)
> +{
> +    g_autofree struct vfio_device_info *info = NULL;
> +
> +    assert(fh);
> +
> +    info = get_device_info(pbdev, sizeof(*info));
> +    if (!info) {
> +        return false;
> +    }
> +
> +    return get_host_fh(pbdev, info, fh);
> +}
> +
> +/*
> + * This function will issue the VFIO_DEVICE_GET_INFO ioctl and look for
> + * capabilities that contain information about CLP features provided by the
> + * underlying host.
> + * On entry, defaults have already been placed into the guest CLP response
> + * buffers.  On exit, defaults will have been overwritten for any CLP features
> + * found in the capability chain; defaults will remain for any CLP features not
> + * found in the chain.
> + */
> +void s390_pci_get_clp_info(S390PCIBusDevice *pbdev)
> +{
> +    g_autofree struct vfio_device_info *info = NULL;
> +
> +    info = get_device_info(pbdev, sizeof(*info));
> +    if (!info) {
> +        return;
> +    }
> +
>       /*
>        * Find the CLP features provided and fill in the guest CLP responses.
>        * Always call s390_pci_read_base first as information from this could
> diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
> index ff708aef50..0c2e4b5175 100644
> --- a/include/hw/s390x/s390-pci-vfio.h
> +++ b/include/hw/s390x/s390-pci-vfio.h
> @@ -20,6 +20,7 @@ bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
>   S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
>                                             S390PCIBusDevice *pbdev);
>   void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
> +bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev, uint32_t *fh);
>   void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
>   #else
>   static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
> @@ -33,6 +34,11 @@ static inline S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
>   }
>   static inline void s390_pci_end_dma_count(S390pciState *s,
>                                             S390PCIDMACount *cnt) { }
> +static inline bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev,
> +                                        unsigned int *fh)
> +{
> +    return false;
> +}
>   static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
>   #endif
>   
> 

-- 
Pierre Morel
IBM Lab Boeblingen
