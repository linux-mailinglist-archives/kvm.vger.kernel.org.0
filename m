Return-Path: <kvm+bounces-5018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1A181B34C
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0001C24EA0
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DD34F602;
	Thu, 21 Dec 2023 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cwcTYooc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27571219F2;
	Thu, 21 Dec 2023 10:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BLACaxq011023;
	Thu, 21 Dec 2023 10:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jqbsORu1MQpIwN5rbeBu1mQI0jvudEl3p6HR4G0NeSM=;
 b=cwcTYoocIrc+eAtRIHVA+hnbM2vv6pB8HevEDJySAmukw1o73n72ivrebDHyHEni55WO
 nHTcHHJIERiGH0D3vyvzcjPfzBU0M3TsDQI10q8kjHVj2mIZc67+zGMMgZ4vNJcvEk89
 cTdUalATK0JSUAnAMGUGWx/IBbqg8IHQWW3KIBuJHPnWd79ma5wHAk6qjTEO3Mv5F5FI
 6CIQqNWYIK3iXjrADP/wzB/lnHj6zEfqv1V44iQaE14Z9BjjNh2TY1e6aUiSA6MHsLb1
 hRIq4ONVh5o6uURAvOI673BWSrWjLVBgG/FVVZby+IoIljXz6kHotb64OtlezCtnbIf0 Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v4kdag0xc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Dec 2023 10:14:02 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BLADDas012373;
	Thu, 21 Dec 2023 10:14:01 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v4kdag0wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Dec 2023 10:14:01 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BL7fBlG027076;
	Thu, 21 Dec 2023 10:14:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1rekbww4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Dec 2023 10:14:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BLADvJR21365302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Dec 2023 10:13:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7517920063;
	Thu, 21 Dec 2023 10:13:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B1D2004F;
	Thu, 21 Dec 2023 10:13:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.48.80])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 21 Dec 2023 10:13:56 +0000 (GMT)
Date: Thu, 21 Dec 2023 11:13:54 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: vsie: fix race during shadow creation
Message-ID: <20231221111354.7ebdac53@p-imbrenda>
In-Reply-To: <20231220125317.4258-1-borntraeger@linux.ibm.com>
References: <20231220125317.4258-1-borntraeger@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ip1O-onPBRSoqMHNUrl7HRMas4LI-d6F
X-Proofpoint-ORIG-GUID: UJX4soE44QQAUkiQ5ULpOxbd3V5sb6-u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-21_04,2023-12-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 mlxlogscore=978 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312210075

On Wed, 20 Dec 2023 13:53:17 +0100
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Right now it is possible to see gmap->private being zero in
> kvm_s390_vsie_gmap_notifier resulting in a crash.  This is due to the
> fact that we add gmap->private == kvm after creation:
> 
> static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>                                struct vsie_page *vsie_page)
> {
> [...]
>         gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
>         if (IS_ERR(gmap))
>                 return PTR_ERR(gmap);
>         gmap->private = vcpu->kvm;
> 
> Let children inherit the private field of the parent.
> 
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
> Cc: <stable@vger.kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> v1->v2: let the child inherit private from parent instead of accessing
>         the parent in the notifier
>  arch/s390/kvm/vsie.c | 1 -
>  arch/s390/mm/gmap.c  | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 8207a892bbe2..db9a180de65f 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1220,7 +1220,6 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>  	gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
>  	if (IS_ERR(gmap))
>  		return PTR_ERR(gmap);
> -	gmap->private = vcpu->kvm;
>  	vcpu->kvm->stat.gmap_shadow_create++;
>  	WRITE_ONCE(vsie_page->gmap, gmap);
>  	return 0;
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 6f96b5a71c63..8da39deb56ca 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -1691,6 +1691,7 @@ struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce,
>  		return ERR_PTR(-ENOMEM);
>  	new->mm = parent->mm;
>  	new->parent = gmap_get(parent);
> +	new->private = parent->private;
>  	new->orig_asce = asce;
>  	new->edat_level = edat_level;
>  	new->initialized = false;


