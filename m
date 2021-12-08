Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9634946D7F7
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 17:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbhLHQWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 11:22:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236749AbhLHQWe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 11:22:34 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8GG58C020344;
        Wed, 8 Dec 2021 16:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=NCVsya2U6FmqSo37J3HNnQHPSsS7M2ZWP1KLU3Y4UD4=;
 b=fgkUSJgy2i8xMHsCcOFZDe+MwaKKwHB2H05bwreZ8C1ZAJ4PrZMVJI30I6eJszNP43LC
 JMinebb1fpbBsvNYgkz2jWypCG6CgwkNSmFfrj0FKCzAcrl6rKvcy21GcpEVwd57Kxvr
 +2QeIHRu4vudkrrrkmVXJFDXSNOJzIpQmQVV+G+62685dyejF9GWQg9iaJEFPcEoFHaz
 YwBxG1jHEbXHu3td98O/Ar2yPP2PhaWGqgryv2IHaQtwrP2IjG6/FY3x4JktpS1IVdnT
 a57G/ypbAFu6gyJm8/m30hVuejUx70dgXHXQ/GJrbHNKM8K4eKQW/h++QgNPLdQJ44C9 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctya4s65g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 16:19:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8G54Ox012586;
        Wed, 8 Dec 2021 16:19:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctya4s64k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 16:19:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8FvJsD005136;
        Wed, 8 Dec 2021 16:18:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb1qjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 16:18:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8GIsmT29688268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 16:18:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EC9AAE057;
        Wed,  8 Dec 2021 16:18:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10D37AE058;
        Wed,  8 Dec 2021 16:18:53 +0000 (GMT)
Received: from sig-9-145-190-99.de.ibm.com (unknown [9.145.190.99])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 16:18:52 +0000 (GMT)
Message-ID: <74f8b38e4b36b0cdb0bcef9430c1c47e42ae4b6c.camel@linux.ibm.com>
Subject: Re: [PATCH 10/32] s390/pci: stash dtsm and maxstbl
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Dec 2021 17:18:52 +0100
In-Reply-To: <20211207205743.150299-11-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-11-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jkjmmkSFqowyWrT0yD_RcrrfzKAb9S3r
X-Proofpoint-ORIG-GUID: m1LAx3SUuIM3ATFnS5ex6fxp5aqHGsYP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112080096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> Store information about what IOAT designation types are supported by
> underlying hardware as well as the largest store block size allowed.
> These values will be needed by passthrough.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h     | 2 ++
>  arch/s390/include/asm/pci_clp.h | 6 ++++--
>  arch/s390/pci/pci_clp.c         | 2 ++
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 2474b8d30f2a..1a8f9f42da3a 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -126,9 +126,11 @@ struct zpci_dev {
>  	u32		gd;		/* GISA designation for passthrough */
>  	u16		vfn;		/* virtual function number */
>  	u16		pchid;		/* physical channel ID */
> +	u16		maxstbl;	/* Maximum store block size */
>  	u8		pfgid;		/* function group ID */
>  	u8		pft;		/* pci function type */
>  	u8		port;
> +	u8		dtsm;		/* Supported DT mask */
>  	u8		rid_available	: 1;
>  	u8		has_hp_slot	: 1;
>  	u8		has_resources	: 1;
> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> index 3af8d196da74..124fadfb74b9 100644
> --- a/arch/s390/include/asm/pci_clp.h
> +++ b/arch/s390/include/asm/pci_clp.h
> @@ -153,9 +153,11 @@ struct clp_rsp_query_pci_grp {
>  	u8			:  6;
>  	u8 frame		:  1;
>  	u8 refresh		:  1;	/* TLB refresh mode */
> -	u16 reserved2;
> +	u16			:  3;
> +	u16 maxstbl		: 13;	/* Maximum store block size */
>  	u16 mui;
> -	u16			: 16;
> +	u8 dtsm;			/* Supported DT mask */
> +	u8 reserved3;
>  	u16 maxfaal;
>  	u16			:  4;
>  	u16 dnoi		: 12;
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index e9ed0e4a5cf0..bc7446566cbc 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -103,6 +103,8 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
>  	zdev->max_msi = response->noi;
>  	zdev->fmb_update = response->mui;
>  	zdev->version = response->version;
> +	zdev->maxstbl = response->maxstbl;
> +	zdev->dtsm = response->dtsm;
>  
>  	switch (response->version) {
>  	case 1:

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

