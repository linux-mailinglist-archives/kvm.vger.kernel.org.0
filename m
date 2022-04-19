Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94795067CE
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 11:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349709AbiDSJlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 05:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbiDSJlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 05:41:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D42D1FA78;
        Tue, 19 Apr 2022 02:38:37 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23J8KMuP024662;
        Tue, 19 Apr 2022 09:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XEOti7R01r9+X9g9SumuO2qSLV9aBc3CWZyGnBUxQh4=;
 b=XqWe7iz1muV9InL39BBI1Kz5xkFhfmwH8PwT5rkHKR6vhVPnoGKbjQxKf0ckcpwBXtJo
 4iPnXO67BE44/LHuVu9aQ4TuYrb/Dc5WbyW4Eh3NiPDoF3L9HZJFOQT9uRs4e+G0Y5P3
 Y+qaUjc3R5pFQaoA6OW9Fc3pMUw6BDzjLrSEQEU+cMqgR4qhJP/pg2tXkZ+QycaMO0xM
 LVeeLV4R3HLfcNULnZYFzeLsIgci4dcfvY4YXZhh2o1EIpa/lc4uGKoBwtTOralw0AF3
 XwPHw0KzaERdgXq/sJ4xNXf5cZfj6/+PUY9OUa5PqjcMYFG515iS8cuUkQ348P2eKBRH wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75qbd7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:38:36 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23J9X9bj025861;
        Tue, 19 Apr 2022 09:38:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75qbd6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:38:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23J9D9Kg016292;
        Tue, 19 Apr 2022 09:38:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8m3gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:38:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23J9cUuT26935572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 09:38:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B27842047;
        Tue, 19 Apr 2022 09:38:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11BA442045;
        Tue, 19 Apr 2022 09:38:29 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 09:38:28 +0000 (GMT)
Message-ID: <7c63e8fd-33ad-506c-c62f-fd42d0bb2833@linux.ibm.com>
Date:   Tue, 19 Apr 2022 11:41:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 18/21] vfio-pci/zdev: different maxstbl for interpreted
 devices
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-19-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404174349.58530-19-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wfTaQHu0p41pqeYVxiHNkI-ObJkmVBaf
X-Proofpoint-GUID: N1yjHkAYMmRkHB6CpMiZNu7UH5_7U5ZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_03,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190052
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 19:43, Matthew Rosato wrote:
> When doing load/store interpretation, the maximum store block length is
> determined by the underlying firmware, not the host kernel API.  Reflect
> that in the associated Query PCI Function Group clp capability and let
> userspace decide which is appropriate to present to the guest.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>


Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   drivers/vfio/pci/vfio_pci_zdev.c | 6 ++++--
>   include/uapi/linux/vfio_zdev.h   | 4 ++++
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 4a653ce480c7..d3ca58d9d8ec 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -44,14 +44,16 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_group cap = {
>   		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_GROUP,
> -		.header.version = 1,
> +		.header.version = 2,
>   		.dasm = zdev->dma_mask,
>   		.msi_addr = zdev->msi_addr,
>   		.flags = VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH,
>   		.mui = zdev->fmb_update,
>   		.noi = zdev->max_msi,
>   		.maxstbl = ZPCI_MAX_WRITE_SIZE,
> -		.version = zdev->version
> +		.version = zdev->version,
> +		.reserved = 0,
> +		.imaxstbl = zdev->maxstbl
>   	};
>   
>   	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index 78c022af3d29..77f2aff1f27e 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -50,6 +50,10 @@ struct vfio_device_info_cap_zpci_group {
>   	__u16 noi;		/* Maximum number of MSIs */
>   	__u16 maxstbl;		/* Maximum Store Block Length */
>   	__u8 version;		/* Supported PCI Version */
> +	/* End of version 1 */
> +	__u8 reserved;
> +	__u16 imaxstbl;		/* Maximum Interpreted Store Block Length */
> +	/* End of version 2 */
>   };
>   
>   /**
> 

-- 
Pierre Morel
IBM Lab Boeblingen
