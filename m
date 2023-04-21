Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FA16EA58E
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjDUIIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDUIIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:08:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5D05FC9;
        Fri, 21 Apr 2023 01:08:07 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L878uC015168;
        Fri, 21 Apr 2023 08:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kAMLC3oMEfc8K6g0PtdgP9CTjQH5R2bPLBwvrFMaLz4=;
 b=S1IW+4cL53dxXs8BP2ZkfziELtvwfhPcXrC4oWx/UupttHDC684g0MwnfSRDeCUPH9b7
 JOLOuo2YSmrIje7cJKwA4sBOBwPw+kYSidHCv4PUZBPG2ZU9NiQMLpEykMffjex2GwAj
 S8v9jzEmbpPLgYREq9pdsYYtgbLZMv9+hHC319eHNF8L8zLiZsFGw9sZpH4iXg4NpZQH
 4ziznAXdppRfm9UEIkLTQ7h3IjcZA4lX1CvVRNYf6S/OlXhoKrzLsgxSVbeoiUqauET0
 fpQvFcLWxEjaXHR9ADGlOar3kKnceXfosZh8Om9es6V3PSNNPpAykVmODZu0qp2LSHyD Og== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3pbb8rfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:08:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K7UVBn031974;
        Fri, 21 Apr 2023 08:07:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fkwfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:07:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L87NvP20447606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 08:07:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D98C20049;
        Fri, 21 Apr 2023 08:07:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E14C620040;
        Fri, 21 Apr 2023 08:07:22 +0000 (GMT)
Received: from [9.179.30.152] (unknown [9.179.30.152])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 08:07:22 +0000 (GMT)
Message-ID: <4e7db9f6-a199-4a95-ea14-13d7803884be@de.ibm.com>
Date:   Fri, 21 Apr 2023 10:07:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v1 1/1] KVM: s390: pv: fix asynchronous teardown for small
 VMs
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     nrb@linux.ibm.com, nsg@linux.ibm.com, frankja@linux.ibm.com,
        mhartmay@linux.ibm.com, kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
References: <20230420160149.51728-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20230420160149.51728-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cW5vCwEn10jBZeyJGwzk0rgdhJfhKnOk
X-Proofpoint-GUID: cW5vCwEn10jBZeyJGwzk0rgdhJfhKnOk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210069
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.04.23 um 18:01 schrieb Claudio Imbrenda:
> On machines without the Destroy Secure Configuration Fast UVC, the
> topmost level of page tables is set aside and freed asynchronously
> as last step of the asynchronous teardown.
> 
> Each gmap has a host_to_guest radix tree mapping host (userspace)
> addresses (with 1M granularity) to gmap segment table entries (pmds).
> 
> If a guest is smaller than 2GB, the topmost level of page tables is the
> segment table (i.e. there are only 2 levels). Replacing it means that
> the pointers in the host_to_guest mapping would become stale and cause
> all kinds of nasty issues.
> 
> This patch fixes the issue by synchronously destroying all guests with
> only 2 levels of page tables in kvm_s390_pv_set_aside. This will
> speed up the process and avoid the issue altogether.
> 
> Update s390_replace_asce so it refuses to replace segment type ASCEs.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
> ---
>   arch/s390/kvm/pv.c  | 35 ++++++++++++++++++++---------------
>   arch/s390/mm/gmap.c |  7 +++++++
>   2 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index e032ebbf51b9..ceb8cb628d62 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -39,6 +39,7 @@ struct pv_vm_to_be_destroyed {
>   	u64 handle;
>   	void *stor_var;
>   	unsigned long stor_base;
> +	bool small;
>   };
>   
>   static void kvm_s390_clear_pv_state(struct kvm *kvm)
> @@ -318,7 +319,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	if (!priv)
>   		return -ENOMEM;
>   
> -	if (is_destroy_fast_available()) {
> +	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT) {
> +		/* No need to do things asynchronously for VMs under 2GB */
> +		res = kvm_s390_pv_deinit_vm(kvm, rc, rrc);
> +		priv->small = true;
> +	} else if (is_destroy_fast_available()) {
>   		res = kvm_s390_pv_deinit_vm_fast(kvm, rc, rrc);
>   	} else {
>   		priv->stor_var = kvm->arch.pv.stor_var;
> @@ -335,7 +340,8 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
>   		return res;
>   	}
>   
> -	kvm_s390_destroy_lower_2g(kvm);
> +	if (!priv->small)
> +		kvm_s390_destroy_lower_2g(kvm);
>   	kvm_s390_clear_pv_state(kvm);
>   	kvm->arch.pv.set_aside = priv;
>   
> @@ -418,7 +424,10 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
>   
>   	/* If a previous protected VM was set aside, put it in the need_cleanup list */
>   	if (kvm->arch.pv.set_aside) {
> -		list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
> +		if (((struct pv_vm_to_be_destroyed *)kvm->arch.pv.set_aside)->small)
why do we need a cast here?

> +			kfree(kvm->arch.pv.set_aside);
> +		else
> +			list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
>   		kvm->arch.pv.set_aside = NULL;
>   	}
>   

With the comment added that Marc asked for

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

