Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E4149DF6E
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 11:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiA0K3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 05:29:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229563AbiA0K3K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 05:29:10 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R9fYpo005534;
        Thu, 27 Jan 2022 10:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=i0QH81i71Tm/lFBYLPKE/sEwnm/KMMnA0Qqt2vNwhIk=;
 b=VJ+6Ti4/kCaljJQmHg2UDJ6XpK/6+C/8Ra+b0ngkfVHdFG0sbwbwiebRNodzfITIhHRC
 GCh/jPUjkSjAsoXTaqYZVrzEPhVPBDDoMpq/854/Qhz4HGuUthfqYRJw2EYLw3fYO80i
 CrNdFsAETp8Xh3X4WakCp2Ki3kbvbPGl8pGXDmWQUdwduuBKsVqnIeto0rfKZmbwjuyY
 +74RwihHS2YIgNzfMAgoYXZ0glVXIP600LjPYcOejJR+DJej6Bl6N3smx9Oawz0eulKJ
 Jgv4YO8fEK6O964HdJnvOaQjdasdE7tm/ah+1qKkHf2SJEPcdmQ4aX8P7nYfxDZVK/iU /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dus00h2dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 10:29:09 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RA1e58016950;
        Thu, 27 Jan 2022 10:29:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dus00h2d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 10:29:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RAS2J3008899;
        Thu, 27 Jan 2022 10:29:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j9p7qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 10:29:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RAT3ia9830682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 10:29:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF6C4C052;
        Thu, 27 Jan 2022 10:29:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DBB34C04E;
        Thu, 27 Jan 2022 10:29:02 +0000 (GMT)
Received: from sig-9-145-73-120.uk.ibm.com (unknown [9.145.73.120])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 10:29:02 +0000 (GMT)
Message-ID: <01e6afd408f979f0c57767d9b1d434ae355033f2.camel@linux.ibm.com>
Subject: Re: [PATCH v2 12/30] s390/pci: get SHM information from list pci
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
Date:   Thu, 27 Jan 2022 11:29:02 +0100
In-Reply-To: <20220114203145.242984-13-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
         <20220114203145.242984-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y0JMYQ6KCqVf6d1PnIiUr4ngbGpPmJ9V
X-Proofpoint-ORIG-GUID: Y2eCOO0ZdV-F5CKAuZ7Dn-J4HT2QYW41
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_02,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-14 at 15:31 -0500, Matthew Rosato wrote:
> KVM will need information on the special handle mask used to indicate
> emulated devices.  In order to obtain this, a new type of list pci call
> must be made to gather the information.  Extend clp_list_pci_req to
> also fetch the model-dependent-data field that holds this mask.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h     |  1 +
>  arch/s390/include/asm/pci_clp.h |  2 +-
>  arch/s390/pci/pci_clp.c         | 28 +++++++++++++++++++++++++---
>  3 files changed, 27 insertions(+), 4 deletions(-)
> 
---8<---
>  
> +int zpci_get_mdd(u32 *mdd)
> +{
> +	struct clp_req_rsp_list_pci *rrb;
> +	u64 resume_token = 0;
> +	int nentries, rc;
> +
> +	if (!mdd)
> +		return -EINVAL;
> +
> +	rrb = clp_alloc_block(GFP_KERNEL);
> +	if (!rrb)
> +		return -ENOMEM;
> +
> +	rc = clp_list_pci_req(rrb, &resume_token, &nentries, mdd);
> +
> +	clp_free_block(rrb);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(zpci_get_mdd);
> +
>  static int clp_base_slpc(struct clp_req *req, struct clp_req_rsp_slpc *lpcb)
>  {
>  	unsigned long limit = PAGE_SIZE - sizeof(lpcb->request);

Looks good.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>


