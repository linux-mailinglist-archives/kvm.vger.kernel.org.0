Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9BD48D5E2
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 11:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiAMKim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 05:38:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231825AbiAMKil (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 05:38:41 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DARQjJ006992;
        Thu, 13 Jan 2022 10:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3HmBQb7XO9KZ+/0xjR1dhFAy4NqdJHgq5yScIoHxlDU=;
 b=rP9zrS9iJDOgTQBvhweFQDPr2o8NSdIPzN/UH/6ss7oihyZ4j6xEHxiYCPPCj+TQszne
 GsEtzxr7ZKb/2WJzpazEYhFcVyB9G0shumRJ8ixgYRO3RGuYon2bZOMIxq97W3ENiy1M
 awSlp/grpPY146n3KlER1WYIxyCruQaE3rwhGCgaB0279xzb58U1HAfJ4z2280OGZkTY
 HKcrheim8DsnKIslAj6YsCBSeVT6IWgH4lkySimFeW8Af9VHt9ElTo5ByDal2pJ9IN9C
 caM8rfSt+WhHJ3hAqP7kxLQNH1vSaLWRlgIBXeNt6ZE6Q+gbqgTBdEMQHfo3HPxaAF3r 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djjbj87dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 10:38:41 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DAYhhB012989;
        Thu, 13 Jan 2022 10:38:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djjbj87cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 10:38:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DAXk6l011936;
        Thu, 13 Jan 2022 10:38:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3df1vk1gv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 10:38:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DAcZJi44695890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 10:38:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DB474C071;
        Thu, 13 Jan 2022 10:38:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE7074C070;
        Thu, 13 Jan 2022 10:38:34 +0000 (GMT)
Received: from [9.145.16.55] (unknown [9.145.16.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 10:38:34 +0000 (GMT)
Message-ID: <096cf759-5859-f073-2641-3c8527210045@linux.ibm.com>
Date:   Thu, 13 Jan 2022 11:38:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v6 11/17] s390/mm: KVM: pv: when tearing down, try to
 destroy protected pages
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
 <20211203165814.73016-12-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211203165814.73016-12-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rPl4-xpE9FrEx1U2o7KOnwtlMybZhBtL
X-Proofpoint-GUID: oaXAR14KS5X6UCL9kBNhiKPEaqgvdpyq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_02,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 17:58, Claudio Imbrenda wrote:
> When ptep_get_and_clear_full is called for a mm teardown, we will now
> attempt to destroy the secure pages. This will be faster than export.
> 
> In case it was not a teardown, or if for some reason the destroy page
> UVC failed, we try with an export page, like before.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/pgtable.h | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 23ca0d8e058a..c008b354573e 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1118,9 +1118,14 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>   	} else {
>   		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>   	}
> +	/* Nothing to do */
> +	if (!mm_is_protected(mm) || !pte_present(res))
> +		return res;
>   	/* At this point the reference through the mapping is still present */
> -	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);

Add comment:
The notifier should have tried to destroy the cpus which allows us to 
destroy pages. So here we'll try to destroy the pages but if that fails 
we fall back to a normal but slower export.

> +	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
> +		return res;
> +	/* If could not destroy, we try export */
> +	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> 

