Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC08B694057
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 10:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjBMJGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 04:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMJGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 04:06:31 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAB0E064;
        Mon, 13 Feb 2023 01:06:30 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8mm8a019305;
        Mon, 13 Feb 2023 09:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=39UL9elUUmVuV6nVSerie2D59HIqUaTWR8WCpcwVt3Y=;
 b=blv1miQryi2jdkvfEnEY2PpcZnCBP9Acy/DKe9F+YMTS7ne7MQrSWFcGRGMpTw8o2VE/
 kRKY6bbUWTjbV9PbafvYze5c0C4HtzbCWt4Fu/ArQzXfmaDocnfq1IpIGPfJaLB0rd2s
 CH6W9C/2zWqOfsTsoxgke8U4fcYPxHzk7kEy6zgUAKgDuYrtCxKl45ZCQZWV1eh++a4p
 Q+OG6gIOuuIg75LPU9Dt+JufrWiY0JL5PsLu09w+HHRPcuXUVgqvwKuUhMcgvzkmq3+0
 pPAmUDx+58tBEypvwgVlDKqnkzep83r5HtKc0qXl/5ilBzMC2iz6A8JoJyxl/CcGpl0C GA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqj1bgcsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 09:06:29 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8cxkh009367;
        Mon, 13 Feb 2023 09:06:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3np2n69t05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 09:06:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31D96NsN20644402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 09:06:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B87A120043;
        Mon, 13 Feb 2023 09:06:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 607112004B;
        Mon, 13 Feb 2023 09:06:23 +0000 (GMT)
Received: from [9.171.6.63] (unknown [9.171.6.63])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 09:06:23 +0000 (GMT)
Message-ID: <c8779382-c2f9-130d-f64a-7b3d596ab413@linux.ibm.com>
Date:   Mon, 13 Feb 2023 10:06:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: fix external interruption loop not
 always detected
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230213085520.100756-1-nrb@linux.ibm.com>
 <20230213085520.100756-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20230213085520.100756-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FvtM_XP-O9AazJe_q692HvimuS4Ud-GO
X-Proofpoint-ORIG-GUID: FvtM_XP-O9AazJe_q692HvimuS4Ud-GO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 bulkscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302130081
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 13.02.23 um 09:55 schrieb Nico Boehr:
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
> index 0ee02dae14b2..2cda8d9d7c6e 100644
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
> + *   occurred. In this case, the interrupt needs to be injected manually to
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
> +	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
> +		newpsw = vcpu->arch.sie_block->gpsw;
> +	} else {
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
