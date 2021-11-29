Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4603C4610F0
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 10:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243913AbhK2JS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 04:18:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241809AbhK2JQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 04:16:53 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AT8lRxG007693;
        Mon, 29 Nov 2021 09:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xniMcVNwzDC0ZXJ0DZ2+lUwhdveaX/rR0CI0kqYuob8=;
 b=UlxcMSJbW/3s9x3ZkqR9WZE1BQvuy+QxxKMTk+jv23a8J3paWxcRrXxmM+4pEhR6r0n+
 yGod+kQ/iJiKn5WQYK+EPgZlcPolVpuPE02oRIkobZnlW6FCOqLeo7pQuKxyS3SdCSnK
 sx/qy6GWLSg/dvB6KsSKlAPkotuL5UQf9hXsU1Fcl63UIcet7P4FI0e/gbqFitdtsezx
 hM/gcJACTgdd0YSIM8z0Qk/JJHzTvlSB8bZkKcxHogD+4oDbuiGvTyVjVYQRb0S8V7cp
 urqXb9p7cj3a7vEIyAOuPqY/hPyaa9O9ILyD+psHS7MoqXius9VPdKsjbZzvxPBaTEgI 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cmunqghy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:13:36 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AT9AE0c029080;
        Mon, 29 Nov 2021 09:13:36 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cmunqghxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:13:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AT94eFr023387;
        Mon, 29 Nov 2021 09:13:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ckca91y2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:13:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AT967qb56099292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 09:06:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A5F742056;
        Mon, 29 Nov 2021 09:13:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C583D4204D;
        Mon, 29 Nov 2021 09:13:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.116])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 09:13:28 +0000 (GMT)
Date:   Mon, 29 Nov 2021 09:59:14 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] KVM: s390: gaccess: Cleanup access to guest
 pages
Message-ID: <20211129095914.34975067@p-imbrenda>
In-Reply-To: <20211126164549.7046-4-scgl@linux.ibm.com>
References: <20211126164549.7046-1-scgl@linux.ibm.com>
        <20211126164549.7046-4-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Nv6UxSaUs-xGBatjkjXtYIvuTgozx6q
X-Proofpoint-GUID: mxbwW3crET2RqaJu_PiQ2EZW7ZsbRro2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_05,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Nov 2021 17:45:49 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Introduce a helper function for guest frame access.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

see a small nit below

> ---
>  arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index c09659609d68..9193f0de40b1 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  	return 0;
>  }
>  
> +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
> +			     void *data, unsigned int len)
> +{
> +	const unsigned int offset = offset_in_page(gpa);
> +	const gfn_t gfn = gpa_to_gfn(gpa);
> +	int rc;
> +
> +	if (mode == GACC_STORE)
> +		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);

why not just return ?

(but don't bother with a v4, it's ok anyway)

> +	else
> +		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
> +	return rc;
> +}
> +
>  int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		 unsigned long len, enum gacc_mode mode)
>  {
> @@ -896,10 +910,7 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>  	for (idx = 0; idx < nr_pages && !rc; idx++) {
>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
> -		if (mode == GACC_STORE)
> -			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
> -		else
> -			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
> +		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
>  		len -= fragment_len;
>  		data += fragment_len;
>  	}
> @@ -920,10 +931,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  	while (len && !rc) {
>  		gpa = kvm_s390_real_to_abs(vcpu, gra);
>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
> -		if (mode)
> -			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
> -		else
> -			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
> +		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
>  		len -= fragment_len;
>  		gra += fragment_len;
>  		data += fragment_len;

