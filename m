Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CFC1A0C98
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 13:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgDGLLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 07:11:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728075AbgDGLKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 07:10:49 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037B3TbP129964
        for <kvm@vger.kernel.org>; Tue, 7 Apr 2020 07:10:48 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082hxd3fb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 07:10:48 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 7 Apr 2020 12:10:28 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 12:10:24 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037BAek565339494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 11:10:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4FC4A405F;
        Tue,  7 Apr 2020 11:10:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34948A4054;
        Tue,  7 Apr 2020 11:10:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 11:10:40 +0000 (GMT)
Date:   Tue, 7 Apr 2020 13:10:17 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 5/5] KVM: s390: vsie: gmap_table_walk()
 simplifications
In-Reply-To: <20200403153050.20569-6-david@redhat.com>
References: <20200403153050.20569-1-david@redhat.com>
        <20200403153050.20569-6-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040711-0008-0000-0000-0000036C1B68
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040711-0009-0000-0000-00004A8DB4B4
Message-Id: <20200407131017.471d2ca4@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_03:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1011
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Apr 2020 17:30:50 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's use asce_type where applicable. Also, simplify our sanity check
> for valid table levels and convert it into a WARN_ON_ONCE(). Check if
> we even have a valid gmap shadow as the very first step.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/mm/gmap.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 24ef30fb0833..a2bd8d7792e9 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -788,19 +788,19 @@ static inline unsigned long
> *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level)
>  {
>  	const int asce_type = gmap->asce & _ASCE_TYPE_MASK;
> -	unsigned long *table;
> +	unsigned long *table = gmap->table;
>  
> -	if ((gmap->asce & _ASCE_TYPE_MASK) + 4 < (level * 4))
> -		return NULL;
>  	if (gmap_is_shadow(gmap) && gmap->removed)
>  		return NULL;
>  
> +	if (WARN_ON_ONCE(level > (asce_type >> 2) + 1))
> +		return NULL;
> +
>  	if (WARN_ON_ONCE(asce_type != _ASCE_TYPE_REGION1 &&
>  			 gaddr & (-1UL << (31 + (asce_type >> 2) *
> 11)))) return NULL;
>  
> -	table = gmap->table;
> -	switch (gmap->asce & _ASCE_TYPE_MASK) {
> +	switch (asce_type) {
>  	case _ASCE_TYPE_REGION1:
>  		table += (gaddr & _REGION1_INDEX) >> _REGION1_SHIFT;
>  		if (level == 4)

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

