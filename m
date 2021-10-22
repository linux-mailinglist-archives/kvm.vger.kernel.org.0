Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5508437642
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 14:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhJVMDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 08:03:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhJVMC5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 08:02:57 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MBHb0C022982;
        Fri, 22 Oct 2021 08:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zbRAtwbV0yx67PeGyPkZkCwM8yZfQr/7TLO3pF+OYUg=;
 b=r3corEGgRfdR+8wy4ZseE1eNgoqiyxWMtXXE55xcq7njryWzp/LIpN30f+FX8XQ85Nzc
 jQGXaTziNV2ghFloQzQu2F+oVPLQH4O98d9G9F6zYfnGpHvtK7J47GXwncCw7UGvns+1
 BgIAq4jI/fXqOcSryCA2PGHc7dFO5W03f7RHcM6C96wKpyLSe8A67CcKIXUvoY2M+Uyu
 6kVljgL5n11CP89P0E7YKv+TUGP+NmvNLmu6DLo81mTEs36J/2+ytELjg7FZRpCgeTs+
 TH3AlH4bt2hxKiVoRheJQClPYsX5wonJCO45w3zUpW/xf19UsC9bPasxVGV6uYHpbvUv UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buva1rs3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:00:39 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19MBqgj6028213;
        Fri, 22 Oct 2021 08:00:38 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buva1rrxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:00:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MBwOZE014818;
        Fri, 22 Oct 2021 12:00:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcbg020-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 12:00:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MBsGoj54657294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 11:54:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D50C6520A4;
        Fri, 22 Oct 2021 12:00:14 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.90.70])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6302E52098;
        Fri, 22 Oct 2021 12:00:14 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Fix handle_sske page fault handling
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211022112913.211986-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <723441ee-2744-32c3-1820-3307bf98fce5@de.ibm.com>
Date:   Fri, 22 Oct 2021 14:00:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211022112913.211986-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5BDpXmbaeVuyn_Hee4-TZah6CmyQHddD
X-Proofpoint-ORIG-GUID: VJ6xXjgpbgs1XHnPggM7BzaDLY2U2HD5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 22.10.21 um 13:29 schrieb Janis Schoetterl-Glausch:
> Retry if fixup_user_fault succeeds.

Maybe rephrase that with a more verbose description (e.g. if fixup_user_fault succeeds
we return EAGAIN and thus we ust retry the loop and  blabla....)

> The same issue in handle_pfmf was fixed by
> a11bdb1a6b78 (KVM: s390: Fix pfmf and conditional skey emulation).
> 
> Fixes: bd096f644319 ("KVM: s390: Add skey emulation fault handling")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Patch itself looks good:

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/kvm/priv.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 53da4ceb16a3..417154b314a6 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -397,6 +397,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
>   		mmap_read_unlock(current->mm);
>   		if (rc == -EFAULT)
>   			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> +		if (rc == -EAGAIN)
> +			continue;
>   		if (rc < 0)
>   			return rc;
>   		start += PAGE_SIZE;
> 
