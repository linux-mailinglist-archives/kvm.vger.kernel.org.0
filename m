Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03F360CB6F
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 14:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiJYMBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 08:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiJYMBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 08:01:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0E36580A;
        Tue, 25 Oct 2022 05:01:00 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB7wBe006398;
        Tue, 25 Oct 2022 12:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uLeYOHBR/bVtF33uRCYysPzk+QyTRFVXI8G06nTS6Fw=;
 b=JfN5MqyMCyS6b2uiM3G/e4/p/x6dusaYqVeF7Ef86e0DsKKC95EBZXQvgpgfyEcXIiZt
 rngkcdYf6c9OhP6j/KR/muh0cCEZGg/FWGEfwJIH9+sa+R3VF2cSXiL1gR/DnPwe2Tbf
 E/EStk/zLuEJUGl+/e7l5w4cnBhQWq7MY1vDzGktMxioDl5WHlkfwPbcUMH7Ox0Ndp85
 rrpK1yfflz7pCpg6Wa+sGO4BfmbDxTR590xroyVUviAowUKquz3tMJciDnqserVbU543
 1h5PISlIsa2zzHjyi2Xcm9kf0CF/k796QE1oHtd/wHYUrS0gdLl0+v9NdyyJwyudEhvw Qg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvyfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 12:00:59 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBoE9o023486;
        Tue, 25 Oct 2022 12:00:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3kc8594e40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 12:00:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PC0sTI1376790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 12:00:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C2B5A405B;
        Tue, 25 Oct 2022 12:00:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD31A4054;
        Tue, 25 Oct 2022 12:00:53 +0000 (GMT)
Received: from [9.171.5.17] (unknown [9.171.5.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 12:00:53 +0000 (GMT)
Message-ID: <86b97f95-9995-a64f-363f-3c5dc3ed57c7@linux.ibm.com>
Date:   Tue, 25 Oct 2022 14:00:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [v2] KVM: s390: pv: fix external interruption loop not always
 detected
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20221005122050.60625-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221005122050.60625-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R1BGS0umfWG8iHnUnFPr51Hi4mR-QHB0
X-Proofpoint-ORIG-GUID: R1BGS0umfWG8iHnUnFPr51Hi4mR-QHB0
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 05.10.22 um 14:20 schrieb Nico Boehr:
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
> Also update the comments to explain better what is happening.
> 
> [1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> ---
>   arch/s390/kvm/intercept.c | 32 ++++++++++++++++++++++++--------
>   1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 88112065d941..ea43463b102e 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -271,10 +271,18 @@ static int handle_prog(struct kvm_vcpu *vcpu)
>    * handle_external_interrupt - used for external interruption interceptions
>    * @vcpu: virtual cpu
>    *
> - * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
> - * the new PSW does not have external interrupts disabled. In the first case,
> - * we've got to deliver the interrupt manually, and in the second case, we
> - * drop to userspace to handle the situation there.
> + * This interception occurs if:
> + * - the CPUSTAT_EXT_INT bit was already set when the external interrupt
> + *   occured. In this case, the interrupt needs to be injected manually to
> + *   preserve interrupt priority.
> + * - the external new PSW has external interrupts enabled, which will cause an
> + *   interruption loop. We drop to userspace in this case.
> + *
> + * The latter case can be detected by inspecting the external mask bit in the
> + * external new psw.
> + *
> + * Under PV, only the latter case can occur, since interrupt priorities are
> + * handled in the ultravisor.
>    */
>   static int handle_external_interrupt(struct kvm_vcpu *vcpu)
>   {
> @@ -285,10 +293,18 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
>   
>   	vcpu->stat.exit_external_interrupt++;
>   
> -	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
> -	if (rc)
> -		return rc;
> -	/* We can not handle clock comparator or timer interrupt with bad PSW */
> +	if (kvm_s390_pv_cpu_is_protected(vcpu))
> +		newpsw = vcpu->arch.sie_block->gpsw;
> +	else {
> +		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/*
> +	 * Clock comparator or timer interrupt with external interrupt enabled
> +	 * will cause interrupt loop. Drop to userspace.
> +	 */
>   	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
>   	    (newpsw.mask & PSW_MASK_EXT))
>   		return -EOPNOTSUPP;
