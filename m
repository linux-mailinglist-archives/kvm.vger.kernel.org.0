Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBA3271EFE
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 11:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIUJf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 05:35:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726333AbgIUJf1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 05:35:27 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08L9V2Lu137207;
        Mon, 21 Sep 2020 05:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tDa/BnmlvpU+ia2QAuOZU71pjGJfzHX3p6UiCmbjJio=;
 b=I0+We3mc5dZtECPDjHkGfuehVaIbIBt4kT7SllnNXA/UqQlrbeaQbMhHsaX9ykqUXJ2p
 4vUoYecmu3YY7fwpjV3I0c5rlCnFngl/syiMyuESbEFizDahNLou2fNBgwtZs2UqwtQT
 kl7WhAUYjB/iATpfzdH33aib/QrnjeE1cegw4BzDdfrgM3zRgINhRIrCLj4iab2Fk4Dt
 cxElE3ScEyqgQSmL/r8bRaQbyyM+jZsEeEe1+cj5RY9r6y3YP27KHXaValOe972g+IWO
 xK4Y7neNcthMZhyzMkSzYPQMcoGVKbktXOTy9ZBKz7w6NwXsrPnLBfw7j1Ulkw4gfONE Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33ps3e93dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 05:35:26 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08L9WPBr141764;
        Mon, 21 Sep 2020 05:35:25 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33ps3e93ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 05:35:25 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08L9SQDP022256;
        Mon, 21 Sep 2020 09:35:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 33n9m80y1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 09:35:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08L9XjhF27722218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 09:33:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2232DA4060;
        Mon, 21 Sep 2020 09:35:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86DFDA405C;
        Mon, 21 Sep 2020 09:35:19 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.29.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 09:35:19 +0000 (GMT)
Subject: Re: [PATCH 1/4] s390/pci: stash version in the zpci_dev
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
 <1600529318-8996-2-git-send-email-mjrosato@linux.ibm.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <d53cf094-e3e1-2385-94ab-61225df994d2@linux.ibm.com>
Date:   Mon, 21 Sep 2020 11:35:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600529318-8996-2-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_01:2020-09-21,2020-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthew,

On 9/19/20 5:28 PM, Matthew Rosato wrote:
> In preparation for passing the info on to vfio-pci devices, stash the
> supported PCI version for the target device in the zpci_dev.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>

> ---
>  arch/s390/include/asm/pci.h | 1 +
>  arch/s390/pci/pci_clp.c     | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 99b92c3..882e233 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -179,6 +179,7 @@ struct zpci_dev {
>  	atomic64_t mapped_pages;
>  	atomic64_t unmapped_pages;
>  
> +	u8		version;
>  	enum pci_bus_speed max_bus_speed;
>  
>  	struct dentry	*debugfs_dev;
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index 7e735f4..48bf316 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -102,6 +102,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
>  	zdev->msi_addr = response->msia;
>  	zdev->max_msi = response->noi;
>  	zdev->fmb_update = response->mui;
> +	zdev->version = response->version;
>  
>  	switch (response->version) {
>  	case 1:
> 
