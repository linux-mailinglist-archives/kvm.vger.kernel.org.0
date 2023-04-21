Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7795A6EA665
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDUI5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjDUI5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:57:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E3E974F;
        Fri, 21 Apr 2023 01:57:14 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L8iVOM029805;
        Fri, 21 Apr 2023 08:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1V8I5CRWhrmCoyHXvlTmWNq0DUz11es/0vfP2ki7TGk=;
 b=IABlR9MsM02mNhXif65n9hRQdo6s06OUtkO9T6KuImyZP3vmw/GS75j4+St+PPAmnJ/r
 DMBkUa4cYKcqRFwRLh/SEiwH4V4WIJBv2aMW52fdV1hG1qyMWcMqDESg1NCoeF7kya6+
 kBvfDPCnGWPK83yTotYmxOmoqSD2Wkytmkw7Fz6+4B2fzPe+9n2dM+v2HU/w4hi09DWq
 GR7H/PqD8TDSVqrKdRAaD9jZao60JNTpX6NawErWM6nQPRvBL+DKliKlbAkXBKitFHaC
 C2kSCMig3n7oToRyUOk82VD0Tw8CVcbBGOGxQzsukJiJCnQvn/hMafhXn7+vh4PCc1/R UA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3q81getm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:57:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K3LPoK000502;
        Fri, 21 Apr 2023 08:57:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pykj6b8je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:57:11 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L8v5ij13304450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 08:57:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D9B620043;
        Fri, 21 Apr 2023 08:57:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B749F20040;
        Fri, 21 Apr 2023 08:57:04 +0000 (GMT)
Received: from [9.171.46.158] (unknown [9.171.46.158])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 08:57:04 +0000 (GMT)
Message-ID: <0b0c7df7-c67c-03ad-03b8-9e2480dc3e2e@linux.ibm.com>
Date:   Fri, 21 Apr 2023 10:57:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: fix asynchronous teardown for small
 VMs
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        mhartmay@linux.ibm.com, kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
References: <20230421085036.52511-1-imbrenda@linux.ibm.com>
 <20230421085036.52511-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230421085036.52511-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MwPYt8rIRjr07XRRI3NuR2RFJmUculEB
X-Proofpoint-GUID: MwPYt8rIRjr07XRRI3NuR2RFJmUculEB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304210074
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/23 10:50, Claudio Imbrenda wrote:
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
> This patch fixes the issue by disallowing asynchronous teardown for
> guests with only 2 levels of page tables. Userspace should (and already
> does) try using the normal destroy if the asynchronous one fails.
> 
> Update s390_replace_asce so it refuses to replace segment type ASCEs.
> This is still needed in case the normal destroy VM fails.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")

Since QEMU will do a normal PV disable on a rc != 0 this should work out 
just fine. The less code to fix this, the better.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kvm/pv.c  | 5 +++++
>   arch/s390/mm/gmap.c | 7 +++++++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index e032ebbf51b9..3ce5f4351156 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -314,6 +314,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	 */
>   	if (kvm->arch.pv.set_aside)
>   		return -EINVAL;
> +
> +	/* Guest with segment type ASCE, refuse to destroy asynchronously */
> +	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
> +		return -EINVAL;
> +
>   	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>   	if (!priv)
>   		return -ENOMEM;
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 5a716bdcba05..2267cf9819b2 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2833,6 +2833,9 @@ EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
>    * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
>    * @gmap: the gmap whose ASCE needs to be replaced
>    *
> + * If the ASCE is a SEGMENT type then this function will return -EINVAL,
> + * otherwise the pointers in the host_to_guest radix tree will keep pointing
> + * to the wrong pages, causing use-after-free and memory corruption.
>    * If the allocation of the new top level page table fails, the ASCE is not
>    * replaced.
>    * In any case, the old ASCE is always removed from the gmap CRST list.
> @@ -2847,6 +2850,10 @@ int s390_replace_asce(struct gmap *gmap)
>   
>   	s390_unlist_old_asce(gmap);
>   
> +	/* Replacing segment type ASCEs would cause serious issues */
> +	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
> +		return -EINVAL;
> +
>   	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
>   	if (!page)
>   		return -ENOMEM;

