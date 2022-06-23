Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83F55732B
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 08:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiFWGe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 02:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiFWGeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 02:34:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E7B38DB2;
        Wed, 22 Jun 2022 23:34:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25N4ZmGo029275;
        Thu, 23 Jun 2022 06:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ivouve314BzSQTYmhbx7zKJw5GkyqQ3+NZn0Y50glXA=;
 b=naVifPKRtohRFRuJsTk1nU6F5ZjQvCPrG5b9Z9F7v94BDlGcjTm+S5iph/4tOLKxDiA/
 eeFmKv8BQ62swMGtSkHnK+t6xmUBLvcNJ/bIkXmRGw/SZoZ40CW8wxbLZHTqBEHRos+u
 13+nfO3lKC8EXoWXmdkiQIf+PuhxVmWzjRZXTVfkVR05BNpTNHZGqkPfgIi9ESzKG22n
 8jsNRLOLrbUKfGArBIYAMalcLSwAX/lhcZG4e67/4i9vviohqJe+w0vAXAQRbQZHnEI2
 YthAfBpB6VNXNkdhNnQnrC1Gq8KsQ7grIWxIiyD7HtZZsAMTzB4MELPir5Ab9brFIzBX tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvedq6k82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 06:34:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25N6Qgkb026302;
        Thu, 23 Jun 2022 06:34:20 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvedq6k77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 06:34:20 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25N65mNe003030;
        Thu, 23 Jun 2022 06:34:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3gv3mb8tnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 06:34:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25N6YEik21954942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 06:34:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D28DA405F;
        Thu, 23 Jun 2022 06:34:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB9AA4054;
        Thu, 23 Jun 2022 06:34:13 +0000 (GMT)
Received: from [9.145.6.211] (unknown [9.145.6.211])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jun 2022 06:34:13 +0000 (GMT)
Message-ID: <afee9027-1c4d-5c9c-8726-0b751cc13f46@linux.ibm.com>
Date:   Thu, 23 Jun 2022 08:34:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] KVM: s390: drop unexpected word 'and' in the comments
Content-Language: en-US
To:     Jiang Jian <jiangjian@cdjrlc.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220622140720.7617-1-jiangjian@cdjrlc.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220622140720.7617-1-jiangjian@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0_9K9oypSQMSUEHSxIR5Hz2ge2JTTeiH
X-Proofpoint-GUID: Sw8cJhq6-4Ns5-NNeo46kSMLGlZTjnHh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_03,2022-06-22_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 clxscore=1011 mlxlogscore=841 phishscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230023
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 16:07, Jiang Jian wrote:
> there is an unexpected word 'and' in the comments that need to be dropped
> 
> file: arch/s390/kvm/interrupt.c
> line: 705
> 
> * Subsystem damage are the only two and and are indicated by
> 
> changed to:
> 
> * Subsystem damage are the only two and are indicated by
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>

Thanks, queued

> ---
>   arch/s390/kvm/interrupt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index af96dc0549a4..1e3fb2d4d448 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -702,7 +702,7 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
>   	/*
>   	 * We indicate floating repressible conditions along with
>   	 * other pending conditions. Channel Report Pending and Channel
> -	 * Subsystem damage are the only two and and are indicated by
> +	 * Subsystem damage are the only two and are indicated by
>   	 * bits in mcic and masked in cr14.
>   	 */
>   	if (test_and_clear_bit(IRQ_PEND_MCHK_REP, &fi->pending_irqs)) {

