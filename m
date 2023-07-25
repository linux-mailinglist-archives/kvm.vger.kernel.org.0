Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9230761AA6
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjGYNxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 09:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjGYNxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 09:53:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8AB1FC0;
        Tue, 25 Jul 2023 06:53:39 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PDeFrA021874;
        Tue, 25 Jul 2023 13:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ToUYj46kmQdSwxw1juQudcMV/fW1m/kYbKVi9qquqqs=;
 b=KIBD6Lj/RIF6ObIzRL1zIbuT3IWWVEeoYdk//yhk1HXbcPpO7nUKLgRgqpq7Nja+IwEu
 HlZy59QKeYyJcLbW1uClZhbhHbtRFnanon3Wuvki6CpZOOscKA7w46REsve5m7Wdb16L
 eVheEwC682L3DOOi+5fBvkj6E5NLnnS21zoBhJb/V7eNFBJS7g3/qvsGhAhg3Rpw8zLM
 e7rk3EKbAG1vLZ7vC8EstwccVhDu0rCxB7orw58xGCORt5A+71quF2m86aVHRGGDWpr5
 ZGHDgDRxxoiU4YHFXoAEsSmGpuQx3Q+2JvUKLtIKEFoGSJcNq/ryQuk4bMuHFaLjA177 wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2063bebk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:38 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PDrYfl013183;
        Tue, 25 Jul 2023 13:53:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2063beb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:37 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PCqHAD014406;
        Tue, 25 Jul 2023 13:53:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stxvp1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PDrX8t20579038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 13:53:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4332B20043;
        Tue, 25 Jul 2023 13:53:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0C2D2004B;
        Tue, 25 Jul 2023 13:53:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 13:53:32 +0000 (GMT)
Date:   Tue, 25 Jul 2023 10:58:56 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
Subject: Re: [PATCH v3 2/6] KVM: s390: interrupt: Fix single-stepping into
 program interrupt handlers
Message-ID: <20230725105856.0ea59d3d@p-imbrenda>
In-Reply-To: <20230724094716.91510-3-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
        <20230724094716.91510-3-iii@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tl9_KK56J5DU5tJenNFZI1xYkUo3a1xD
X-Proofpoint-ORIG-GUID: Kaz41tGpfMuZGg6lA1tVihq6fDilPEsr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307250119
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jul 2023 11:44:08 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> Currently, after single-stepping an instruction that generates a
> specification exception, GDB ends up on the instruction immediately
> following it.
> 
> The reason is that vcpu_post_run() injects the interrupt and sets
> KVM_GUESTDBG_EXIT_PENDING, causing a KVM_SINGLESTEP exit. The
> interrupt is not delivered, however, therefore userspace sees the
> address of the next instruction.
> 
> Fix by letting the __vcpu_run() loop go into the next iteration,
> where vcpu_pre_run() delivers the interrupt and sets
> KVM_GUESTDBG_EXIT_PENDING.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 954d39adf85c..7cdd927541b0 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -226,7 +226,22 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -#define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
> +static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
> +{
> +	if (!guestdbg_enabled(vcpu))
> +		return false;
> +	if (!(vcpu->arch.sie_block->iprcc & PGM_PER))

why not  if (!per_event(vcpu))  ?

maybe you can even merge it with the previous if:

if (!guestdbg_enabled(vcpu) || !per_event(vcpu))
	return false;

this is closer to the old code too

> +		return false;
> +	if (guestdbg_sstep_enabled(vcpu) &&
> +	    vcpu->arch.sie_block->iprcc != PGM_PER) {
> +		/*
> +		 * __vcpu_run() will exit after delivering the concurrently
> +		 * indicated condition.
> +		 */
> +		return false;
> +	}
> +	return true;
> +}
>  
>  static int handle_prog(struct kvm_vcpu *vcpu)
>  {
> @@ -242,7 +257,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
>  	if (kvm_s390_pv_cpu_is_protected(vcpu))
>  		return -EOPNOTSUPP;
>  
> -	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
> +	if (should_handle_per_event(vcpu)) {
>  		rc = kvm_s390_handle_per_event(vcpu);
>  		if (rc)
>  			return rc;

