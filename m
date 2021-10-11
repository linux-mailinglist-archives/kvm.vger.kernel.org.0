Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20242880C
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhJKHtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:49:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234614AbhJKHr0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 03:47:26 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B7igUQ001218;
        Mon, 11 Oct 2021 03:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wGbAZLDJuOeViUEXUxsTVmOiu5tbptaYkZ/g6dyXDCE=;
 b=L5ldyRnNu4ikaxlz9fhOfL3G2fN9efyHRM1mCU9rUMPmUIJ7/avQj4lapwQVUvjJuDGj
 tTh3q7GJH+RKUlG2C3rZ1+bpHQ1fdG7fROtRQaUarUpleXtVpV8QAtVXwahthHkBSkpb
 vrxe8lQYjl7IGJcKnxoeVdHcHq12wkr2sVL8GU0pj2yTEpykiuDUtkttlswJLVAJi675
 HQ519C3JVK8nmYGJwyufcx/RkBEBVvBjTB+Myfds1CQ24YNZLNQMzGwbxYo0UI3sSMFd
 zJc8LalsmF+nKa36g3gfU6MBsh8+kSmFzMTEfRejz35/jj2Z4HR5+knmX0OTTVVCDFhb 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmefb369v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:45:26 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19B7SuRE010047;
        Mon, 11 Oct 2021 03:45:26 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmefb3696-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:45:26 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19B7hKsf019781;
        Mon, 11 Oct 2021 07:45:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q9342t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 07:45:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19B7dg2w46989768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 07:39:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D444AE079;
        Mon, 11 Oct 2021 07:45:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB86DAE05D;
        Mon, 11 Oct 2021 07:45:11 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.26.102])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Oct 2021 07:45:11 +0000 (GMT)
Subject: Re: [RFC PATCH v1 3/6] KVM: s390: Simplify SIGP Restart
To:     Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-4-farman@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e3b874c1-e220-5e23-bd67-ed08c261e425@de.ibm.com>
Date:   Mon, 11 Oct 2021 09:45:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3L5lYjzGzFK-9vVcb-G_2Yx58waaSrAg
X-Proofpoint-ORIG-GUID: 52cF3X1Nxv2Lgqsl_YiHgTO3jXcCkFpm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_02,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=950 suspectscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110110043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 08.10.21 um 22:31 schrieb Eric Farman:
> Now that we check for the STOP IRQ injection at the top of the SIGP
> handler (before the userspace/kernelspace check), we don't need to do
> it down here for the Restart order.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/sigp.c | 11 +----------
>   1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 6ca01bbc72cf..0c08927ca7c9 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -240,17 +240,8 @@ static int __sigp_sense_running(struct kvm_vcpu *vcpu,
>   static int __prepare_sigp_re_start(struct kvm_vcpu *vcpu,
>   				   struct kvm_vcpu *dst_vcpu, u8 order_code)
>   {
> -	struct kvm_s390_local_interrupt *li = &dst_vcpu->arch.local_int;
>   	/* handle (RE)START in user space */
> -	int rc = -EOPNOTSUPP;
> -
> -	/* make sure we don't race with STOP irq injection */
> -	spin_lock(&li->lock);
> -	if (kvm_s390_is_stop_irq_pending(dst_vcpu))
> -		rc = SIGP_CC_BUSY;
> -	spin_unlock(&li->lock);
> -
> -	return rc;
> +	return -EOPNOTSUPP;
>   }
>   
>   static int __prepare_sigp_cpu_reset(struct kvm_vcpu *vcpu,
> 

@thuth?
Question is, does it make sense to merge patch 2 and 3 to make things more obvious?
