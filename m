Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4069146D32F
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhLHMZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 07:25:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231336AbhLHMZQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 07:25:16 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8BmHvP012274;
        Wed, 8 Dec 2021 12:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=WfX9lD9lGY+PPJZxUyaHL3Gr1JDNNiv+T9BzbcB9SQw=;
 b=efrz7R3VKvPUfKJCky6+BGOt+MsjC4Hp5SKajNn1nk8X3u2Il5P9sAR8Xkc0KOtcu8R/
 vRg+tsXng4gQ7Ja/FOg+Y0ASVAdLqXfNvu1GOXjM15bCc84TM2ZUU6Czesq/OG/pf/Bs
 q2BW+C3KqLxGECfCAwjYKmGXyfRhNNM55K3ABDHTPS69nRGYojwInqsKNJ3F+OJzgOve
 AnP4PAO+YBxAHnNcRXWhxWYZizzTM7DumDaQRv3J7VEZym+hQkWddzzPLnNH2/R0ZJ7P
 DNzYu7z+y0MmswP0yAB3CfIDCgqBa9o/PfINjbZ/Ae/JspyggNSlGumz0BiHnmI9UEBu lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctv5fgjx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:21:44 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8CFgia009891;
        Wed, 8 Dec 2021 12:21:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctv5fgjwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:21:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CIscI005433;
        Wed, 8 Dec 2021 12:21:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyy9p0u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:21:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8CLbXK28639670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 12:21:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B7B4C044;
        Wed,  8 Dec 2021 12:21:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F15AB4C046;
        Wed,  8 Dec 2021 12:21:35 +0000 (GMT)
Received: from sig-9-145-190-99.de.ibm.com (unknown [9.145.190.99])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 12:21:35 +0000 (GMT)
Message-ID: <8411f2afe9f017e531b5a69e4863b933a50f90be.camel@linux.ibm.com>
Subject: Re: [PATCH 12/32] s390/pci: get SHM information from list pci
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
Date:   Wed, 08 Dec 2021 13:21:35 +0100
In-Reply-To: <20211207205743.150299-13-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AAM2s91oLzey8KNcMLGdxzbbY7CTJKuZ
X-Proofpoint-ORIG-GUID: j9GsHi9l-wJvfEfmjKCqpL0RaLBrK09L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> KVM will need information on the special handle mask used to indicate
> emulated devices.  In order to obtain this, a new type of list pci call
> must be made to gather the information.  Remove the unused data pointer
> from clp_list_pci and __clp_add and instead optionally pass a pointer to
> a model-dependent-data field.  Additionally, allow for clp_list_pci calls
> that don't specify a callback - in this case, just do the first pass of
> list pci and exit.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h     |  6 ++++++
>  arch/s390/include/asm/pci_clp.h |  2 +-
>  arch/s390/pci/pci.c             | 19 +++++++++++++++++++
>  arch/s390/pci/pci_clp.c         | 16 ++++++++++------
>  4 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 00a2c24d6d2b..86f43644756d 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -219,12 +219,18 @@ int zpci_unregister_ioat(struct zpci_dev *, u8);
>  void zpci_remove_reserved_devices(void);
>  void zpci_update_fh(struct zpci_dev *zdev, u32 fh);
> 
---8<---
> -static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
> -			void (*cb)(struct clp_fh_list_entry *, void *))
> +int clp_list_pci(struct clp_req_rsp_list_pci *rrb, u32 *mdd,
> +		 void (*cb)(struct clp_fh_list_entry *))
>  {
>  	u64 resume_token = 0;
>  	int nentries, i, rc;
> @@ -368,8 +368,12 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
>  		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>  		if (rc)
>  			return rc;
> +		if (mdd)
> +			*mdd = rrb->response.mdd;
> +		if (!cb)
> +			return 0;

I think it would be slightly cleaner to instead de-static
clp_list_pci_req() and call that directly. Just because that makes the
clp_list_pci() still list all PCI functions and allows us to get rid of
the data parameter completely.

Also, I've been thinking about moving clp_scan_devices(),
clp_get_state(), and clp_refresh_fh() out of pci_clp.c because they are
higher level. I think that would nicely fit your zpci_get_mdd() in
pci.c with or without the above suggestion. Then we could do the
removal of the unused data parameter in that series as a cleanup. What
do you think?

>  		for (i = 0; i < nentries; i++)
> -			cb(&rrb->response.fh_list[i], data);
> +			cb(&rrb->response.fh_list[i]);
>  	} while (resume_token);
>  
>  	return rc;
> @@ -398,7 +402,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
>  	return -ENODEV;
>  }
>  
> -static void __clp_add(struct clp_fh_list_entry *entry, void *data)
> +static void __clp_add(struct clp_fh_list_entry *entry)
>  {
>  	struct zpci_dev *zdev;
>  

