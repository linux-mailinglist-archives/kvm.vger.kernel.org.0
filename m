Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7AF761AA4
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjGYNxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjGYNxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 09:53:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C9C100;
        Tue, 25 Jul 2023 06:53:44 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PDcG67015410;
        Tue, 25 Jul 2023 13:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=W2UXkxsqa2N+q+c0EZJNAM198SqfxnMjOPC3Pq13UQc=;
 b=i2gR+PEUST2OBNKlfhnyTqvyiEUDwitb18+AF6A5yh55HhEt7ktrpc8K6aw35B/DKAed
 npk+0QPOf3gTieImq9kDgksiGfqsK3gVBmVRlYKR8nrEYPi1qIl0esKjTHc9sZb1AZqH
 Y7tIjIEKLPSms91Ej5PXESMZgthPLsY+gOMtkqFNsxbDah+TZdU67DDbXThKROmtHoC1
 jGUe79bwn5CPwryd/rQbds4H/Mb5J3Amp8wRHwjASL5+/ZQaU5Nn+WyAPpQd1sZzoHLD
 51OcpRUO04wxmJgceqBS8MgX25b6fh0dKWA1hy6HGlxWKLlIV/d6lej/fT3K5qv8Qg0h Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2f5e11wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:43 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PDcQX4016249;
        Tue, 25 Jul 2023 13:53:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2f5e11vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:42 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PCjrYZ014373;
        Tue, 25 Jul 2023 13:53:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stxvp2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PDrcGa20513376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 13:53:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BD7020040;
        Tue, 25 Jul 2023 13:53:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 233712004B;
        Tue, 25 Jul 2023 13:53:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 13:53:38 +0000 (GMT)
Date:   Tue, 25 Jul 2023 13:56:54 +0200
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
Subject: Re: [PATCH v3 1/6] KVM: s390: interrupt: Fix single-stepping into
 interrupt handlers
Message-ID: <20230725135654.657f6b74@p-imbrenda>
In-Reply-To: <20230724094716.91510-2-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
        <20230724094716.91510-2-iii@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 69SlLMO40KsHWUY0DI6J3j31qCym75Xi
X-Proofpoint-ORIG-GUID: hqKAB85fQ7VcTqID1UX05F_YeaC5KBiL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 adultscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jul 2023 11:44:07 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> After single-stepping an instruction that generates an interrupt, GDB
> ends up on the second instruction of the respective interrupt handler.
> 
> The reason is that vcpu_pre_run() manually delivers the interrupt, and
> then __vcpu_run() runs the first handler instruction using the
> CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the second handler
> instruction.
> 
> Fix by delaying the KVM_SINGLESTEP exit until after the manual
> interrupt delivery.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/interrupt.c | 14 ++++++++++++++
>  arch/s390/kvm/kvm-s390.c  |  4 ++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 9bd0a873f3b1..85e39f472bb4 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1392,6 +1392,7 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
>  	int rc = 0;
> +	bool delivered = false;
>  	unsigned long irq_type;
>  	unsigned long irqs;
>  
> @@ -1465,6 +1466,19 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
>  			WARN_ONCE(1, "Unknown pending irq type %ld", irq_type);
>  			clear_bit(irq_type, &li->pending_irqs);
>  		}
> +		delivered |= !rc;
> +	}
> +
> +	/*
> +	 * We delivered at least one interrupt and modified the PC. Force a
> +	 * singlestep event now.
> +	 */
> +	if (delivered && guestdbg_sstep_enabled(vcpu)) {
> +		struct kvm_debug_exit_arch *debug_exit = &vcpu->run->debug.arch;
> +
> +		debug_exit->addr = vcpu->arch.sie_block->gpsw.addr;
> +		debug_exit->type = KVM_SINGLESTEP;
> +		vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
>  	}
>  
>  	set_intercept_indicators(vcpu);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d1e768bcfe1d..0c6333b108ba 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4611,7 +4611,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
>  
>  	if (!kvm_is_ucontrol(vcpu->kvm)) {
>  		rc = kvm_s390_deliver_pending_interrupts(vcpu);
> -		if (rc)
> +		if (rc || guestdbg_exit_pending(vcpu))
>  			return rc;
>  	}
>  
> @@ -4738,7 +4738,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	do {
>  		rc = vcpu_pre_run(vcpu);
> -		if (rc)
> +		if (rc || guestdbg_exit_pending(vcpu))
>  			break;
>  
>  		kvm_vcpu_srcu_read_unlock(vcpu);

