Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD4A6EA6F8
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDUJae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjDUJa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:30:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65612A26E;
        Fri, 21 Apr 2023 02:30:27 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L9Q1Ge025833;
        Fri, 21 Apr 2023 09:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=OnaZDqGJzYOgn+jjBtWhBdkxp+OjDc8eoNZ6NLYBILY=;
 b=fq2Lv7T9WpJGyQXJj/wiOw1HxEAEo+4JYw8r3ee0fLB+wB//kWTaBr36y3Tx4bXKVOp+
 6jpSpoSVS7QCiUlEwQzS5eatpeLwaikQsrjkwcEiXynJ7STvUU/COxirA3rSQzlP2Ia+
 Ysc4kIIJLfFcrAa4J3EsNvsTJcu2Qjxj3UuL1rosTuG1NbpGShd1kYI26UVs3kS+Svo+
 W1TlqCiOmqiRyfFwHACrBHJKpl7WdCd3nRLLh3apAia81wqBVxit7B6+fD/KDPuAmJiA
 CQcT/vDCq3znsT2sIwVqK+k/CdDXEDocweMcvvsk7UHJ67koZnrnZRZHsa00S/AZUY4q Fw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3qusr346-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 09:30:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K7UVEh031974;
        Fri, 21 Apr 2023 09:30:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fkxtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 09:30:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L9UIFg48562610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 09:30:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3A5920040;
        Fri, 21 Apr 2023 09:30:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4958A20043;
        Fri, 21 Apr 2023 09:30:17 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.5.49])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 21 Apr 2023 09:30:17 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: fix asynchronous teardown for
 small VMs
In-Reply-To: <20230421085036.52511-2-imbrenda@linux.ibm.com>
References: <20230421085036.52511-1-imbrenda@linux.ibm.com>
 <20230421085036.52511-2-imbrenda@linux.ibm.com>
Date:   Fri, 21 Apr 2023 11:30:16 +0200
Message-ID: <87pm7xd1lj.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RatK862w1Mcqm3ISPLGXP4eTykvfF1AG
X-Proofpoint-ORIG-GUID: RatK862w1Mcqm3ISPLGXP4eTykvfF1AG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_03,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio Imbrenda <imbrenda@linux.ibm.com> writes:

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
> ---
>  arch/s390/kvm/pv.c  | 5 +++++
>  arch/s390/mm/gmap.c | 7 +++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index e032ebbf51b9..3ce5f4351156 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -314,6 +314,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	 */
>  	if (kvm->arch.pv.set_aside)
>  		return -EINVAL;
> +
> +	/* Guest with segment type ASCE, refuse to destroy asynchronously */
> +	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
> +		return -EINVAL;
> +
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 5a716bdcba05..2267cf9819b2 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2833,6 +2833,9 @@ EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
>   * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
>   * @gmap: the gmap whose ASCE needs to be replaced
>   *
> + * If the ASCE is a SEGMENT type then this function will return -EINVAL,
> + * otherwise the pointers in the host_to_guest radix tree will keep pointing
> + * to the wrong pages, causing use-after-free and memory corruption.
>   * If the allocation of the new top level page table fails, the ASCE is not
>   * replaced.
>   * In any case, the old ASCE is always removed from the gmap CRST list.
> @@ -2847,6 +2850,10 @@ int s390_replace_asce(struct gmap *gmap)
>  
>  	s390_unlist_old_asce(gmap);
>  
> +	/* Replacing segment type ASCEs would cause serious issues */
> +	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
> +		return -EINVAL;

As discussed... not sure if this is a valid scenario or if it can be
considered a bug if it happens.

> +
>  	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
>  	if (!page)
>  		return -ENOMEM;
> -- 
> 2.40.0

IMO, much better.

Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>
