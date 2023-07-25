Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29F761CE3
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjGYPGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjGYPGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:06:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE5A1BD9;
        Tue, 25 Jul 2023 08:06:08 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEVtNi016560;
        Tue, 25 Jul 2023 15:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1k7YwFZNMVYDvJZvEifx7yBWa4+icSlxnWV0CPZiZac=;
 b=pKXiovDCyQAdoG20wyaeM6gvT1sR90NL2db/pejt5mP5MoD4LLZaSZZybK2+nrdRgRum
 uW41S7GDdmRXuIWRm8cdcQEbwwiTGfoWnWroxpzjq5HoIUm7skIFJvhwvNhNSzxbvx0k
 98Io5FwL4VvcGYEeufaXyLSzkdv+YZtn5rde8y7t8/vwbTcEGb88M/uCCv6VCcVBg+RR
 C9euamSQzp4W8XtPIMGaPVgY5tTCeOXJQHBQOhIkQCjR3r7Y+MFnb7u4eK6I60fe4XyF
 lQPCc8/Wxfs+Xw4XKl2o4VTLSVPpuB/X7yySrFiI4xS+/nong595mHFYk7gLuQ3tN3k8 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2g7wsbp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 15:06:06 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PEW9Du018651;
        Tue, 25 Jul 2023 15:05:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2g7wsaww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 15:05:36 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PDevFx001981;
        Tue, 25 Jul 2023 15:05:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0temvwgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 15:05:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PF595e26083968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 15:05:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD76B2004D;
        Tue, 25 Jul 2023 15:05:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4679420040;
        Tue, 25 Jul 2023 15:05:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 15:05:09 +0000 (GMT)
Date:   Tue, 25 Jul 2023 17:04:52 +0200
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
Subject: Re: [PATCH v4 2/6] KVM: s390: interrupt: Fix single-stepping into
 program interrupt handlers
Message-ID: <20230725170452.5d856439@p-imbrenda>
In-Reply-To: <20230725143857.228626-3-iii@linux.ibm.com>
References: <20230725143857.228626-1-iii@linux.ibm.com>
        <20230725143857.228626-3-iii@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nW2NeXFKM4wkwjsnsUGCNTJHtYXKsnKO
X-Proofpoint-GUID: aPhtxfBj8DcinikJd-sl8aJQZzpLAVbd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jul 2023 16:37:17 +0200
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/intercept.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 954d39adf85c..e54496740859 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -228,6 +228,21 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
>  
>  #define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
>  
> +static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
> +{
> +	if (!guestdbg_enabled(vcpu) || !per_event(vcpu))
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
> +
>  static int handle_prog(struct kvm_vcpu *vcpu)
>  {
>  	psw_t psw;
> @@ -242,7 +257,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
>  	if (kvm_s390_pv_cpu_is_protected(vcpu))
>  		return -EOPNOTSUPP;
>  
> -	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
> +	if (should_handle_per_event(vcpu)) {
>  		rc = kvm_s390_handle_per_event(vcpu);
>  		if (rc)
>  			return rc;

