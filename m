Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B595538BEA
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 09:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbiEaHXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 03:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiEaHXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 03:23:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C392692D09;
        Tue, 31 May 2022 00:23:45 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V6KnBg020552;
        Tue, 31 May 2022 07:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=RDJ15Sp2JTOkhL1E4/+9ipHSf987zp1fzYxAAV5iqow=;
 b=J2sUQwIq8MfRh+HDM4NY69hJ5wHkt/CJfLzA59MBDTgpvW/95a7Q0c3VPE/GPIUQu0Av
 oPwJMAuxqaWcpVY9OBB2NltmcYFJX8dzAJ940c0HInIAz5gqOCf55ifnwisjD87pmQyR
 Ikm9yEzEg0JnzqiYr3V73jvlbxSqZnepSMfX5vGNZQ0RPrLyctgO2Gm5xlm73uLUUZHX
 ZVxY9PTmHYj3mVOL60MQzjCE88LLUc9SmQ+WMagNSs31O3SbG9wg2ObpCHAbm4nhz6co
 RY9Y8vW6KJC5l/cP1IHr/sQl3NVjyfs6jy5TO0ZjNzjvxeOfMDCNv/3LSjZzHChvIvaV ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gddnxh0xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 07:23:44 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24V7CKnA001206;
        Tue, 31 May 2022 07:23:44 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gddnxh0x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 07:23:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24V7M5sR015901;
        Tue, 31 May 2022 07:23:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7jsnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 07:23:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24V7NcoT49873354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 07:23:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 960244C046;
        Tue, 31 May 2022 07:23:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E86E4C044;
        Tue, 31 May 2022 07:23:38 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.165.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 31 May 2022 07:23:37 +0000 (GMT)
Date:   Tue, 31 May 2022 09:23:36 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [PATCH 1/2] s390/gmap: voluntarily schedule during key setting
Message-ID: <YpXCeNF9qQMUb/pi@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220530092706.11637-1-borntraeger@linux.ibm.com>
 <20220530092706.11637-2-borntraeger@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530092706.11637-2-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PZG7l5PwC4BhZxfK0ksrzU8nC8-UHP_E
X-Proofpoint-GUID: PX9AByVKxw1xSiyGdP9SrvglvHWjRrnd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_02,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 30, 2022 at 11:27:05AM +0200, Christian Borntraeger wrote:
> With large and many guest with storage keys it is possible to create
> large latencies or stalls during initial key setting:
> 
> rcu: INFO: rcu_sched self-detected stall on CPU
> rcu:   18-....: (2099 ticks this GP) idle=54e/1/0x4000000000000002 softirq=35598716/35598716 fqs=998
>        (t=2100 jiffies g=155867385 q=20879)
> Task dump for CPU 18:
> CPU 1/KVM       R  running task        0 1030947 256019 0x06000004
> Call Trace:
> sched_show_task
> rcu_dump_cpu_stacks
> rcu_sched_clock_irq
> update_process_times
> tick_sched_handle
> tick_sched_timer
> __hrtimer_run_queues
> hrtimer_interrupt
> do_IRQ
> ext_int_handler
> ptep_zap_key
> 
> The mmap lock is held during the page walking but since this is a
> semaphore scheduling is still possible. Same for the kvm srcu.
> To minimize overhead do this on every segment table entry or large page.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 1ac73917a8d3..b8ae4a4aa2ba 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2608,6 +2608,18 @@ static int __s390_enable_skey_pte(pte_t *pte, unsigned long addr,
>  	return 0;
>  }
>  
> +/*
> + * Give a chance to schedule after setting a key to 256 pages.
> + * We only hold the mm lock, which is a rwsem and the kvm srcu.
> + * Both can sleep.
> + */
> +static int __s390_enable_skey_pmd(pmd_t *pmd, unsigned long addr,
> +				  unsigned long next, struct mm_walk *walk)
> +{
> +	cond_resched();
> +	return 0;
> +}
> +
>  static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
>  				      unsigned long hmask, unsigned long next,
>  				      struct mm_walk *walk)
> @@ -2630,12 +2642,14 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
>  	end = start + HPAGE_SIZE - 1;
>  	__storage_key_init_range(start, end);
>  	set_bit(PG_arch_1, &page->flags);
> +	cond_resched();
>  	return 0;
>  }
>  
>  static const struct mm_walk_ops enable_skey_walk_ops = {
>  	.hugetlb_entry		= __s390_enable_skey_hugetlb,
>  	.pte_entry		= __s390_enable_skey_pte,
> +	.pmd_entry		= __s390_enable_skey_pmd,
>  };
>  
>  int s390_enable_skey(void)
> -- 
> 2.35.1
> 
