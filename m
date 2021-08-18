Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0CB3EFE2B
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 09:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbhHRHr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 03:47:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238014AbhHRHr1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 03:47:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I7WSvU121113;
        Wed, 18 Aug 2021 03:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eJB6fTRU9cbwtN+NHePzNgp+wq+hrto0ebgKHTEg/aA=;
 b=UBgwNwpqF5nVgn4zfY6VYhGqjW/Tl240ZQ+seZ32cs/hAN1hDQWfrgkNt0to8cXr0KeP
 7/tTBL1KVEN4oMKrHCcFd6e7ulqgYM4H434ag8Dk8zrqG3vU2r9dimAAIsf7tyA+pogN
 iAFlc7hTTU2/WsFvCd0pX6PkUMaO3AndFOYx1vSaqT/i/jgYBVQcX1d+TLo3FPUIQX1R
 CF/zoMjY+eKyWXmhyLtsAlvJOr6H4O8BY7oH5TXT63rHoRS41mmQHzVziEr425N7ybfW
 23ujPzW0aob4EBBkgexzDKvNpmxrv1qkQX0HpQwKQPz3JrSC6MOs7iK/M1oHiuzq+p3o dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agfdxf1fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 03:46:53 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I7WqBw122267;
        Wed, 18 Aug 2021 03:46:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agfdxf1f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 03:46:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I7gxdW025587;
        Wed, 18 Aug 2021 07:46:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8e4sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 07:46:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I7klld26149366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 07:46:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D5D2A405F;
        Wed, 18 Aug 2021 07:46:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 980C4A4064;
        Wed, 18 Aug 2021 07:46:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.181])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 07:46:46 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     david@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
 <20210816150718.3063877-2-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <81df4ea7-edb0-5b94-a500-1526230fca22@linux.ibm.com>
Date:   Wed, 18 Aug 2021 09:46:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816150718.3063877-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z4q2UCb3VdKcjunKotQ8BGbUCKNayC_o
X-Proofpoint-ORIG-GUID: mmJ2mAMFCyM-aoW9BMauN7GCcTXyCIIk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_02:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/21 5:07 PM, Janis Schoetterl-Glausch wrote:
> Introduce a helper function for guest frame access.
> Rewrite the calculation of the gpa and the length of the segment
> to be more readable.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c | 48 +++++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index b9f85b2dc053..df83de0843de 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -827,11 +827,26 @@ static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  	return 0;
>  }
>  
> +static int access_guest_frame(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
> +			      void *data, unsigned int len)
> +{
> +	gfn_t gfn = gpa_to_gfn(gpa);
> +	unsigned int offset = offset_in_page(gpa);
> +	int rc;
> +
> +	if (mode == GACC_STORE)
> +		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
> +	else
> +		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
> +	return rc;
> +}
> +
>  int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		 unsigned long len, enum gacc_mode mode)
>  {
>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	unsigned long _len, nr_pages, gpa, idx;
> +	unsigned long nr_pages, gpa, idx;
> +	unsigned int seg;
>  	unsigned long pages_array[2];
>  	unsigned long *pages;
>  	int need_ipte_lock;
> @@ -855,15 +870,12 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		ipte_lock(vcpu);
>  	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
>  	for (idx = 0; idx < nr_pages && !rc; idx++) {
> -		gpa = *(pages + idx) + (ga & ~PAGE_MASK);
> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
> -		if (mode == GACC_STORE)
> -			rc = kvm_write_guest(vcpu->kvm, gpa, data, _len);
> -		else
> -			rc = kvm_read_guest(vcpu->kvm, gpa, data, _len);
> -		len -= _len;
> -		ga += _len;
> -		data += _len;
> +		gpa = pages[idx] + offset_in_page(ga);
> +		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
> +		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
> +		len -= seg;
> +		ga += seg;
> +		data += seg;
>  	}
>  	if (need_ipte_lock)
>  		ipte_unlock(vcpu);
> @@ -875,19 +887,17 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  		      void *data, unsigned long len, enum gacc_mode mode)
>  {
> -	unsigned long _len, gpa;
> +	unsigned long gpa;
> +	unsigned int seg;
>  	int rc = 0;
>  
>  	while (len && !rc) {
>  		gpa = kvm_s390_real_to_abs(vcpu, gra);
> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
> -		if (mode)
> -			rc = write_guest_abs(vcpu, gpa, data, _len);
> -		else
> -			rc = read_guest_abs(vcpu, gpa, data, _len);
> -		len -= _len;
> -		gra += _len;
> -		data += _len;
> +		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
> +		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
> +		len -= seg;
> +		gra += seg;
> +		data += seg;
>  	}
>  	return rc;
>  }
> 

