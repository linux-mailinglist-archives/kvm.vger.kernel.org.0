Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB4A43900F
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 09:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhJYHK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 03:10:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230305AbhJYHKx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 03:10:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P3WMk5017680;
        Mon, 25 Oct 2021 03:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k2ChBLW25Iimg7zHT6ky7uJ4CkJ459lBXNUHjlhewDM=;
 b=CQ6QsWE1VR8M0c2Q0VAPROEMg4t1iY/PhAgJV4aqEFRBZyJ/NkJDpaxPtSga9o9/xM8b
 hNL0mdeuzk/33jLu0yUBZgGZ8PJ2iJNTFOyThq50nHoNq9LmJd/hv5isKvzGRVao3Jk9
 j5e7nxXuYmxnsOZVr24JGjqkQj5L8LiBtvlOpKHJaURxjH1n/M7LJRB1856X52QvMgAe
 js5fS+xdOd2Bf6yPsbFse+OIY7CQB9l2Q4weayKUpqqkja/uQVhPtJ5OXUGOO1lWyhGX
 ygYRqvzuU6Diarh9XFhGKvz2gPKNeuCRvVcx+/RhIO/5+obNgDJ2cbo0IsZ8dr+YeVmU 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvydftueh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:08:30 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19P6fVOI025330;
        Mon, 25 Oct 2021 03:08:30 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvydftudu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:08:30 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P72fiR001480;
        Mon, 25 Oct 2021 07:08:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bva199af2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 07:08:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P78O813932900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 07:08:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4103311C064;
        Mon, 25 Oct 2021 07:08:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9747E11C04A;
        Mon, 25 Oct 2021 07:08:23 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.42.28])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 07:08:23 +0000 (GMT)
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
 <723441ee-2744-32c3-1820-3307bf98fce5@de.ibm.com>
 <20211022152648.26536-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <4c81140a-add0-8593-7941-55822b45df3c@de.ibm.com>
Date:   Mon, 25 Oct 2021 09:08:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211022152648.26536-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vUmC-TwrnLUkF7psBH1hOR4gBfGF5Vpw
X-Proofpoint-GUID: 7Qs5CkG2AkM0G92wxwHVaDib-x4M2Qte
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 22.10.21 um 17:26 schrieb Janis Schoetterl-Glausch:
> On Fri, Oct 22, 2021 at 02:00:13PM +0200, Christian Borntraeger wrote:
>> Am 22.10.21 um 13:29 schrieb Janis Schoetterl-Glausch:
>>> Retry if fixup_user_fault succeeds.
>>
>> Maybe rephrase that with a more verbose description (e.g. if fixup_user_fault succeeds
>> we return EAGAIN and thus we ust retry the loop and  blabla....)
>>
> Done
> 
> [...]
> -- >8 --
> Subject: [PATCH v2] KVM: s390: Fix handle_sske page fault handling
> 
> If handle_sske cannot set the storage key, because there is no
> page table entry or no present large page entry, it calls
> fixup_user_fault.
> However, currently, if the call succeeds, handle_sske returns
> -EAGAIN, without having set the storage key.
> Instead, retry by continue'ing the loop without incrementing the
> address.
> The same issue in handle_pfmf was fixed by
> a11bdb1a6b78 (KVM: s390: Fix pfmf and conditional skey emulation).
> 
> Fixes: bd096f644319 ("KVM: s390: Add skey emulation fault handling")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

thanks applied.
