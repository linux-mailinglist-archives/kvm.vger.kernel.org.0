Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B7A766556
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 09:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbjG1H3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 03:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjG1H3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 03:29:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1CFF7;
        Fri, 28 Jul 2023 00:29:04 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S78hMZ012830;
        Fri, 28 Jul 2023 07:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KD/IaudLrc/SdyptorgWHKK1OUhVZbXzclV+/0kR1Iw=;
 b=jTQbtHsFnQTlAcI1fT0AEOhIY14Mv+cdPZViticwJVgeKaoNoG723ncnPrra2WkYIsBD
 0NBtcbX7FC/9AG9G/fLOT3lnOk4mcWP97jOk0Lq8txLikN0kDqtznbECTY0LxG0zKtQ1
 s8mlD1aN5TUh6u8Ta5QJtoQ/ARs+mlNbTkkcnT4jWGjuentYCQzoJG7f/7BU2fcQcwJb
 Z6GEvlLMe84MZADq4pJenSNjTV/zcXv9DfdpAgEHIa4WtFvepec1e29k3qh6zVYDDHIh
 8TazdFEiXyCbQyyoP3sJuxtzNxa9BkNV844/gdfkguFrOFAlIJAG6zG0UZq93gWp7g/e 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s47ew2m5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:29:03 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S7SncM004463;
        Fri, 28 Jul 2023 07:29:02 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s47ew2m5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:29:02 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S605B0016574;
        Fri, 28 Jul 2023 07:29:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0v51ukby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:29:02 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S7SxU352363546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 07:28:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F1EA20043;
        Fri, 28 Jul 2023 07:28:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD76820040;
        Fri, 28 Jul 2023 07:28:58 +0000 (GMT)
Received: from [9.152.224.114] (unknown [9.152.224.114])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 07:28:58 +0000 (GMT)
Message-ID: <7fadab86-2b7c-b934-fcfa-61046c0778b6@linux.ibm.com>
Date:   Fri, 28 Jul 2023 09:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: s390: fix sthyi error handling
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Mete Durlu <meted@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230727182939.2050744-1-hca@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20230727182939.2050744-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aisIPqm_0FrR8F7lvHu63PYejsrYVLsh
X-Proofpoint-ORIG-GUID: CF5JzXhY-R8Kch-pXJH1ziWNbjIb2ns2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307280063
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 27.07.23 um 20:29 schrieb Heiko Carstens:
> Commit 9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
> added cache handling for store hypervisor info. This also changed the
> possible return code for sthyi_fill().
> 
> Instead of only returning a condition code like the sthyi instruction would
> do, it can now also return a negative error value (-ENOMEM). handle_styhi()
> was not changed accordingly. In case of an error, the negative error value
> would incorrectly injected into the guest PSW.
> 
> Add proper error handling to prevent this, and update the comment which
> describes the possible return values of sthyi_fill().

To me it looks like this can only happen if page allocation fails? This should
not happen in normal cases (and return -ENOMEM would likely kill the guest as
QEMU would stop).
But if it happens we better stop.


Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> 
> Fixes: 9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>   arch/s390/kernel/sthyi.c  | 6 +++---
>   arch/s390/kvm/intercept.c | 9 ++++++---
>   2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kernel/sthyi.c b/arch/s390/kernel/sthyi.c
> index 4d141e2c132e..2ea7f208f0e7 100644
> --- a/arch/s390/kernel/sthyi.c
> +++ b/arch/s390/kernel/sthyi.c
> @@ -459,9 +459,9 @@ static int sthyi_update_cache(u64 *rc)
>    *
>    * Fills the destination with system information returned by the STHYI
>    * instruction. The data is generated by emulation or execution of STHYI,
> - * if available. The return value is the condition code that would be
> - * returned, the rc parameter is the return code which is passed in
> - * register R2 + 1.
> + * if available. The return value is either a negative error value or
> + * the condition code that would be returned, the rc parameter is the
> + * return code which is passed in register R2 + 1.
>    */
>   int sthyi_fill(void *dst, u64 *rc)
>   {
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 954d39adf85c..341abafb96e4 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -389,8 +389,8 @@ static int handle_partial_execution(struct kvm_vcpu *vcpu)
>    */
>   int handle_sthyi(struct kvm_vcpu *vcpu)
>   {
> -	int reg1, reg2, r = 0;
> -	u64 code, addr, cc = 0, rc = 0;
> +	int reg1, reg2, cc = 0, r = 0;
> +	u64 code, addr, rc = 0;
>   	struct sthyi_sctns *sctns = NULL;
>   
>   	if (!test_kvm_facility(vcpu->kvm, 74))
> @@ -421,7 +421,10 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>   		return -ENOMEM;
>   
>   	cc = sthyi_fill(sctns, &rc);
> -
> +	if (cc < 0) {
> +		free_page((unsigned long)sctns);
> +		return cc;
> +	}
>   out:
>   	if (!cc) {
>   		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
