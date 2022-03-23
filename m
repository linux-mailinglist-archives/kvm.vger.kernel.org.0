Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920FB4E4DB2
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 08:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbiCWIAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242375AbiCWIAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:00:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2BC32EFD;
        Wed, 23 Mar 2022 00:59:03 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N7Nj2E030074;
        Wed, 23 Mar 2022 07:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Kyr8kev9+gNTTph7gkssJCVXKyDOvFDGTXEnkQ9Nm1A=;
 b=B6+8u/0CDv/5ob/GwUFSRT4H8/y7IPlvqLyrPMNCF6UGoI8YYt0bbjlAHahPTFH/k72Q
 g59PRPxFZXWvCcqIMglw1BnPlISEQU4hf+9cP76WrGyiGHpS4kBf0ms/0hdx4zhVLB9S
 gqHFTePmDklY3g1dufRMRRptEmpbWw6Jv9bMwBatF2rt6rtisAAPajly+3RrPUyPIVK9
 9Bw9CzJ3ahdiHVBuqLJiJjSQSHRpSaVRw7Xi/VcZh1aaYEzS6yxGbJ9tI7meZTfAkfSO
 R/3KuWcXgMjBby9DNDgU6EkGjDOF4+H3JGHQxj+RYHCGO3mwQjpUYeDGX5DXNfNFNqpe aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyy4f0hub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 07:59:03 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N7VIHs023215;
        Wed, 23 Mar 2022 07:59:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyy4f0htq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 07:59:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N7ws5B018636;
        Wed, 23 Mar 2022 07:59:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej00hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 07:59:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N7wvND50200932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 07:58:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AFEA11C04A;
        Wed, 23 Mar 2022 07:58:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01ABA11C04C;
        Wed, 23 Mar 2022 07:58:57 +0000 (GMT)
Received: from [9.145.94.199] (unknown [9.145.94.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 07:58:56 +0000 (GMT)
Message-ID: <44618f05-9aee-5aa5-b036-dd838285b26f@linux.ibm.com>
Date:   Wed, 23 Mar 2022 08:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: s390: Fix lockdep issue in vm memop
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220322153204.2637400-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220322153204.2637400-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jC8grO_4q80IxcdgQp2aLwrFrCDR-3sr
X-Proofpoint-GUID: LN6PtDnGfq-7m3KgOANAn4JQeeFBSlJD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 16:32, Janis Schoetterl-Glausch wrote:
> Issuing a memop on a protected vm does not make sense,

Issuing a vm memop on a protected vm...

The cpu memop still makes sense, no?

> neither is the memory readable/writable, nor does it make sense to check
> storage keys. This is why the ioctl will return -EINVAL when it detects
> the vm to be protected. However, in order to ensure that the vm cannot
> become protected during the memop, the kvm->lock would need to be taken
> for the duration of the ioctl. This is also required because
> kvm_s390_pv_is_protected asserts that the lock must be held.
> Instead, don't try to prevent this. If user space enables secure
> execution concurrently with a memop it must accecpt the possibility of
> the memop failing.
> Still check if the vm is currently protected, but without locking and
> consider it a heuristic.
> 
> Fixes: ef11c9463ae0 ("KVM: s390: Add vm IOCTL for key checked guest absolute memory access")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Makes sense to me.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ca96f84db2cc..53adbe86a68f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2385,7 +2385,16 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
>   		return -EINVAL;
>   	if (mop->size > MEM_OP_MAX_SIZE)
>   		return -E2BIG;
> -	if (kvm_s390_pv_is_protected(kvm))
> +	/*
> +	 * This is technically a heuristic only, if the kvm->lock is not
> +	 * taken, it is not guaranteed that the vm is/remains non-protected.
> +	 * This is ok from a kernel perspective, wrongdoing is detected
> +	 * on the access, -EFAULT is returned and the vm may crash the
> +	 * next time it accesses the memory in question.
> +	 * There is no sane usecase to do switching and a memop on two
> +	 * different CPUs at the same time.
> +	 */
> +	if (kvm_s390_pv_get_handle(kvm))
>   		return -EINVAL;
>   	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
>   		if (access_key_invalid(mop->key))
> 
> base-commit: c9b8fecddb5bb4b67e351bbaeaa648a6f7456912

