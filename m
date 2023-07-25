Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932B2761AA0
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 15:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjGYNxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 09:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjGYNxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 09:53:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2DF1FC4;
        Tue, 25 Jul 2023 06:53:39 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PDcGth015433;
        Tue, 25 Jul 2023 13:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kXZ9dUThnLfDHQ7dnAvekKphlAndGEx98WbuUTxGCH4=;
 b=izeabIeanVmrJQdSmfvdysr/NFb185w5BsmvFtNVGxW9kfaRh7Lddey2NSntagLN7U3I
 K2skFaQegJmAySOuMufwD1+L8GOQ4Iv8Jcn0D1Q8q778x1gUE15axRjmWDla9HEf9IYU
 Ys/odZ/QpRmadGkr3t5vWLnIxwFGx6RCc5l7cjZFuMpnc5u7Fjnva5SccVLZyhGJITAB
 6DoR44H3hcaqFGbC7hrGaI0CNO78d7ptXspgTXsnFiz8DyhjHr5LinpsW0BsZO2e6JuU
 O/hNv9QsCSDNyzIFIki7YKIecMDFpRcu4jC9nimX66uFJWlgm87bgFPsMhaG5n/7HY4S tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2f5e11tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:39 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PDcTBi016768;
        Tue, 25 Jul 2023 13:53:39 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2f5e11tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:38 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PC3Jov001872;
        Tue, 25 Jul 2023 13:53:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unjc12h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PDrZhi51773900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 13:53:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0859320040;
        Tue, 25 Jul 2023 13:53:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45952004D;
        Tue, 25 Jul 2023 13:53:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 13:53:34 +0000 (GMT)
Date:   Tue, 25 Jul 2023 14:04:36 +0200
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
Subject: Re: [PATCH v3 3/6] KVM: s390: interrupt: Fix single-stepping
 kernel-emulated instructions
Message-ID: <20230725140436.723a00ea@p-imbrenda>
In-Reply-To: <20230724094716.91510-4-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
        <20230724094716.91510-4-iii@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T8clp0a3oTGz12mUwqSMIG8cYZZyVJZc
X-Proofpoint-ORIG-GUID: rDKEaOeIaq1N02a_yC8TpQTmN34-Yn-Z
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

On Mon, 24 Jul 2023 11:44:09 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> Single-stepping a kernel-emulated instruction that generates an
> interrupt causes GDB to land on the instruction following it instead of
> the respective interrupt handler.
> 
> The reason is that kvm_handle_sie_intercept(), after injecting the
> interrupt, also processes the PER event and arranges a KVM_SINGLESTEP
> exit. The interrupt is not yet delivered, however, so the userspace
> sees the next instruction.
> 
> Fix by avoiding the KVM_SINGLESTEP exit when there is a pending
> interrupt. The next __vcpu_run() loop iteration will arrange a
> KVM_SINGLESTEP exit after delivering the interrupt.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 7cdd927541b0..d2f7940c5d03 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -583,6 +583,19 @@ static int handle_pv_notification(struct kvm_vcpu *vcpu)
>  	return handle_instruction(vcpu);
>  }
>  
> +static bool should_handle_per_ifetch(const struct kvm_vcpu *vcpu, int rc)
> +{
> +	/* Process PER, also if the instruction is processed in user space. */
> +	if (!(vcpu->arch.sie_block->icptstatus & 0x02))
> +		return false;
> +	if (rc != 0 && rc != -EOPNOTSUPP)
> +		return false;
> +	if (guestdbg_sstep_enabled(vcpu) && vcpu->arch.local_int.pending_irqs)
> +		/* __vcpu_run() will exit after delivering the interrupt. */
> +		return false;
> +	return true;
> +}
> +
>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  {
>  	int rc, per_rc = 0;
> @@ -645,9 +658,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	/* process PER, also if the instruction is processed in user space */
> -	if (vcpu->arch.sie_block->icptstatus & 0x02 &&
> -	    (!rc || rc == -EOPNOTSUPP))
> +	if (should_handle_per_ifetch(vcpu, rc))
>  		per_rc = kvm_s390_handle_per_ifetch_icpt(vcpu);
>  	return per_rc ? per_rc : rc;
>  }

