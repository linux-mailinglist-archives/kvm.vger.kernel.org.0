Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402DD5BC58F
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiISJiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiISJhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:37:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4860524F2B;
        Mon, 19 Sep 2022 02:37:54 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J8lwlY028868;
        Mon, 19 Sep 2022 09:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=C5ywJsIuiLJJRpnLzn6nD1FgRlL3uZF5sUItDP3ikHk=;
 b=d+XXqHtVNP0+wuWETOZtvCciqOAqJBWaEOEXRuIlMM7W3xFqkmb/zZMmlNTDUHPCSNus
 v9SZFlJ9wIXTWHK8iR8HBOillYCGx1Xz9fk4CvT4USCkAevAD8WXWwAPowf6VsXsgWfQ
 HHK01/9myIpYmC3adYap1qZ2wjZhYoV7x4oSPPWgNOnQ2bnVUmwa7xFcRtcH2XoqXaWv
 btc72Y4Br8wat485Az/Lf+B4dmuozl/5XweDejj7Rf5WpP+7BrO5YjCSJnXi9Zx9Otdz
 DmubiogC/ja1mNSfZ4R9RQTnNEQQ0vNiKE23Talc5hM1nQHUXY2EpYBTHXjZtt1DO5gj DQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jpn7s9a53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 09:37:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28J9bISv024421;
        Mon, 19 Sep 2022 09:37:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jn5gj282f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 09:37:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28J9bmft43385204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 09:37:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F3A542041;
        Mon, 19 Sep 2022 09:37:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6EB4203F;
        Mon, 19 Sep 2022 09:37:47 +0000 (GMT)
Received: from [9.171.62.75] (unknown [9.171.62.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Sep 2022 09:37:47 +0000 (GMT)
Message-ID: <33b9b086-1008-9417-5497-36d4a075e3e4@linux.ibm.com>
Date:   Mon, 19 Sep 2022 11:37:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [v1] KVM: s390: pv: fix external interruption loop not always
 detected
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220824125818.15904-1-nrb@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220824125818.15904-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kpg0hobToBG5IIXss8LG_qiEXHbF0G9l
X-Proofpoint-ORIG-GUID: kpg0hobToBG5IIXss8LG_qiEXHbF0G9l
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209190064
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24.08.22 um 14:58 schrieb Nico Boehr:
> To determine whether the guest has caused an external interruption loop
> upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
> be inspected to see whether external interrupts are enabled.
> 
> Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
> PV, KVM can only access the encrypted guest lowcore and hence the
> ext_new_psw must not be taken from guest lowcore.
> 
> handle_external_interrupt() incorrectly did that and hence was not able
> to reliably tell whether an external interruption loop is happening or
> not. False negatives cause spurious failures of my kvm-unit-test
> for extint loops[1] under PV.
> 
> Since code 20 is only caused under PV if and only if the guest's
> ext_new_psw is enabled for external interrupts, false positive detection
> of a external interruption loop can not happen.
> 
> Fix this issue by instead looking at the guest PSW in the state
> description. Since the PSW swap for external interrupt is done by the
> ultravisor before the intercept is caused, this reliably tells whether
> the guest is enabled for external interrupts in the ext_new_psw.
> 
> [1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Makes sense. Can you try to rephrase the comment of handle_external_interrupt
to explain a bit better what is going on. Right now this is

/**
  * handle_external_interrupt - used for external interruption interceptions
  * @vcpu: virtual cpu
  *
  * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
  * the new PSW does not have external interrupts disabled. In the first case,
  * we've got to deliver the interrupt manually, and in the second case, we
  * drop to userspace to handle the situation there.
  */

And maybe we want to say something about the fact that this is for loop
detection.

Otherwise looks good.

> ---
>   arch/s390/kvm/intercept.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 88112065d941..bf875da86289 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -285,9 +285,14 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
>   
>   	vcpu->stat.exit_external_interrupt++;
>   
> -	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
> -	if (rc)
> -		return rc;
> +	if (kvm_s390_pv_cpu_is_protected(vcpu))
> +		newpsw = vcpu->arch.sie_block->gpsw;
> +	else {
> +		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
> +		if (rc)
> +			return rc;
> +	}
> +
>   	/* We can not handle clock comparator or timer interrupt with bad PSW */
>   	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
>   	    (newpsw.mask & PSW_MASK_EXT))
