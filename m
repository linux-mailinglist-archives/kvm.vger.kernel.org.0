Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F97A662ABC
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjAIQDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjAIQDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:03:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD31D0D4;
        Mon,  9 Jan 2023 08:03:50 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309FL7Xc015963;
        Mon, 9 Jan 2023 16:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=foMnHzTcJhE1OB25m5g2nN/Qijb9TqQf2o1tQuw9Dac=;
 b=sTR4ZxQlqjqlT88dFiweZBW+z7dOsNcyH0Mj+jCVquhb8IFZOiOcvRy97zN0McZiYwTP
 47uyAOp6yjN6GTLX8XeZ79hiLYhzxdRQLKrk8XEJRAfOGYj8FRpZZk/Cz6uoVpPUBkUR
 TQnoJaSVtNkS+qC36m/5bBlv3g//klBTzUQH4lQHrTiZUHedB8x1laiY171lmezqHtsu
 tL/clSnxtGqsOqdZKT25V4rqvJdejCn1OJgAjJTTFSjwi8sBjGn1bJMyL2rZU73STmmQ
 dMOKHGV+MV++BsSxKmmLKWtSP1jMv81M2HVnu2Xiq03+TFGb/fPUfOsCmKIEDFRBTVFp UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myj6jjpqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 16:03:50 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309FtOkI024134;
        Mon, 9 Jan 2023 16:03:49 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myj6jjpp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 16:03:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3098ti3b024704;
        Mon, 9 Jan 2023 16:03:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3my0c6k665-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 16:03:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309G3hmO49152340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 16:03:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6AFE20049;
        Mon,  9 Jan 2023 16:03:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BA3C20043;
        Mon,  9 Jan 2023 16:03:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.4.251])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Mon,  9 Jan 2023 16:03:43 +0000 (GMT)
Date:   Mon, 9 Jan 2023 17:03:41 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: interrupt: use READ_ONCE() before
 cmpxchg()
Message-ID: <20230109170341.6d3edc7b@p-imbrenda>
In-Reply-To: <20230109145456.2895385-1-hca@linux.ibm.com>
References: <20230109145456.2895385-1-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5T46g9dGXCgn6OyAowMtmuMtyNQ7Z96M
X-Proofpoint-GUID: SqoaB9pIu61Qn1_q_Bvu7ue_YjBHWEbu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_09,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=844 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Jan 2023 15:54:56 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> Use READ_ONCE() before cmpxchg() to prevent that the compiler generates
> code that fetches the to be compared old value several times from memory.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> 
> v2: make it compile
> 
> arch/s390/kvm/interrupt.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 1dae78deddf2..ab26aa53ee37 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -83,8 +83,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  		struct esca_block *sca = vcpu->kvm->arch.sca;
>  		union esca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
> +		union esca_sigp_ctrl new_val = {0}, old_val;
>  
> +		old_val = READ_ONCE(*sigp_ctrl);
>  		new_val.scn = src_id;
>  		new_val.c = 1;
>  		old_val.c = 0;
> @@ -95,8 +96,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  		struct bsca_block *sca = vcpu->kvm->arch.sca;
>  		union bsca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
> +		union bsca_sigp_ctrl new_val = {0}, old_val;
>  
> +		old_val = READ_ONCE(*sigp_ctrl);
>  		new_val.scn = src_id;
>  		new_val.c = 1;
>  		old_val.c = 0;
> @@ -126,16 +128,18 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>  		struct esca_block *sca = vcpu->kvm->arch.sca;
>  		union esca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl old = *sigp_ctrl;
> +		union esca_sigp_ctrl old;
>  
> +		old = READ_ONCE(*sigp_ctrl);
>  		expect = old.value;
>  		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
>  	} else {
>  		struct bsca_block *sca = vcpu->kvm->arch.sca;
>  		union bsca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl old = *sigp_ctrl;
> +		union bsca_sigp_ctrl old;
>  
> +		old = READ_ONCE(*sigp_ctrl);
>  		expect = old.value;
>  		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
>  	}

