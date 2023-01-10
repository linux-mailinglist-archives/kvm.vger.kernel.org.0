Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D830664C26
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbjAJTQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjAJTQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:16:04 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9747F08;
        Tue, 10 Jan 2023 11:15:57 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AIi4fT025981;
        Tue, 10 Jan 2023 19:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8qLRSieZJKfiFTp09cd3lxTGmbf7d8GkKTXy8vOVObs=;
 b=rjuuulTF635OLwG5dI3ZK9jbc2+wAoyiPmARf3DNRQSvKfEVyP1vxbZqqWoS7okGsGxA
 7Zp93N8mag8gPTVTKvwfmiUG0ACmmQQD2pVC7tyX90QlWBfcb9TVQtX1+GUJhJVe8doO
 F/EAr/uARa0hLC5qLq+OEYcK4lZPkgxeqMIJw7w9riNT1KIvGe1RKEfgog2zwbkeUDNf
 xGz7ln8/x13s00gUQLMUfGsQhF8qCNj2fNPhGiDMetDARmcTCVtsDSfTsRfTu9RqBSDh
 pxG6BCf9/VUu6mkINwCGdSofc5x44Klqr3z1M8OF7DpZaeqgosHLMXjj9Fv2tpEgF5C4 bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1dj9gqwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 19:15:56 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AIoYMI017576;
        Tue, 10 Jan 2023 19:15:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1dj9gqvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 19:15:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30AIeVnD024687;
        Tue, 10 Jan 2023 19:15:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3my0c6nb3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 19:15:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AJFo0t25035302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 19:15:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2AFE20040;
        Tue, 10 Jan 2023 19:15:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CF7E2004D;
        Tue, 10 Jan 2023 19:15:50 +0000 (GMT)
Received: from [9.171.9.121] (unknown [9.171.9.121])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 19:15:50 +0000 (GMT)
Message-ID: <f4203dea-93a9-6903-d635-c36ff47337c9@linux.ibm.com>
Date:   Tue, 10 Jan 2023 20:15:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] KVM: s390: interrupt: use READ_ONCE() before cmpxchg()
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230109145456.2895385-1-hca@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20230109145456.2895385-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W9Jlib-x6Ip48vHTvV5S9c5z7zPigdX7
X-Proofpoint-ORIG-GUID: jqIG8YIw-bxIsQrSNz78ZG2_QqzRyp7y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_07,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=888
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 phishscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 09.01.23 um 15:54 schrieb Heiko Carstens:
> Use READ_ONCE() before cmpxchg() to prevent that the compiler generates
> code that fetches the to be compared old value several times from memory.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Looks sane.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

In case you want to take it via the s390 tree:
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
> 
> v2: make it compile
> 
> arch/s390/kvm/interrupt.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 1dae78deddf2..ab26aa53ee37 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -83,8 +83,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>   		struct esca_block *sca = vcpu->kvm->arch.sca;
>   		union esca_sigp_ctrl *sigp_ctrl =
>   			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
> +		union esca_sigp_ctrl new_val = {0}, old_val;
>   
> +		old_val = READ_ONCE(*sigp_ctrl);
>   		new_val.scn = src_id;
>   		new_val.c = 1;
>   		old_val.c = 0;
> @@ -95,8 +96,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>   		struct bsca_block *sca = vcpu->kvm->arch.sca;
>   		union bsca_sigp_ctrl *sigp_ctrl =
>   			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
> +		union bsca_sigp_ctrl new_val = {0}, old_val;
>   
> +		old_val = READ_ONCE(*sigp_ctrl);
>   		new_val.scn = src_id;
>   		new_val.c = 1;
>   		old_val.c = 0;
> @@ -126,16 +128,18 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>   		struct esca_block *sca = vcpu->kvm->arch.sca;
>   		union esca_sigp_ctrl *sigp_ctrl =
>   			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl old = *sigp_ctrl;
> +		union esca_sigp_ctrl old;
>   
> +		old = READ_ONCE(*sigp_ctrl);
>   		expect = old.value;
>   		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
>   	} else {
>   		struct bsca_block *sca = vcpu->kvm->arch.sca;
>   		union bsca_sigp_ctrl *sigp_ctrl =
>   			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl old = *sigp_ctrl;
> +		union bsca_sigp_ctrl old;
>   
> +		old = READ_ONCE(*sigp_ctrl);
>   		expect = old.value;
>   		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
>   	}
