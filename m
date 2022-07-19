Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B21157984C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 13:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiGSLU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 07:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiGSLU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 07:20:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEBC1DA40;
        Tue, 19 Jul 2022 04:20:55 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JBFQmH005252;
        Tue, 19 Jul 2022 11:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0SowL+btytAvRiw8YuAP7SnK+GgLVLUjv/4sAZqvoes=;
 b=L3zuGi1mYc+y7sftAA5Qfmy5yAl81yfsxL9H+0M0uuXikewFPlMoKt5kz/TcbnHIVMAF
 8pJWrOFKAa1DwZchehAGD7aVvP3vrXCs1VYmxj5vkOY+IHgnT/W8+smqAVB5zDdM6XO7
 2y1Qf90cawYYUbrix5lT1uiJROowabnh76CDkoIPdg76+ElyxKHQIbjqczUBTE5yOxVF
 9s4B9EQD9Dwn50v0HGo8zeG1eOho45ByF12GRfOlMRfnVE5aWA6pqrY2kYF4mvHCO1JI
 r8bTX8iBvHBprOXUNv6Hn6oSagCRLbbUHPo2i+XTfhemV/H1rLJB05LKFx/wT+0kWTKv zQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdujs03x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 11:20:55 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JBKrnV018952;
        Tue, 19 Jul 2022 11:20:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3hbmkhs4s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 11:20:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JBKnP323986534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 11:20:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4AF142041;
        Tue, 19 Jul 2022 11:20:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77D9D4203F;
        Tue, 19 Jul 2022 11:20:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.232])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 11:20:49 +0000 (GMT)
Date:   Tue, 19 Jul 2022 13:20:47 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] s390/kvm: pv: don't present the ecall interrupt
 twice
Message-ID: <20220719132047.1888a2dd@p-imbrenda>
In-Reply-To: <20220718130434.73302-1-nrb@linux.ibm.com>
References: <20220718130434.73302-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PlRzlLdxUDpfT1EReg0cC7yBoNTA_nB7
X-Proofpoint-ORIG-GUID: PlRzlLdxUDpfT1EReg0cC7yBoNTA_nB7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=913
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207190047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jul 2022 15:04:34 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When the SIGP interpretation facility is present and a VCPU sends an
> ecall to another VCPU in enabled wait, the sending VCPU receives a 56
> intercept (partial execution), so KVM can wake up the receiving CPU.
> Note that the SIGP interpretation facility will take care of the
> interrupt delivery and KVM's only job is to wake the receiving VCPU.
> 
> For PV, the sending VCPU will receive a 108 intercept (pv notify) and
> should continue like in the non-PV case, i.e. wake the receiving VCPU.
> 
> For PV and non-PV guests the interrupt delivery will occur through the
> SIGP interpretation facility on SIE entry when SIE finds the X bit in
> the status field set.
> 
> However, in handle_pv_notification(), there was no special handling for
> SIGP, which leads to interrupt injection being requested by KVM for the
> next SIE entry. This results in the interrupt being delivered twice:
> once by the SIGP interpretation facility and once by KVM through the
> IICTL.
> 
> Add the necessary special handling in handle_pv_notification(), similar
> to handle_partial_execution(), which simply wakes the receiving VCPU and
> leave interrupt delivery to the SIGP interpretation facility.
> 
> In contrast to external calls, emergency calls are not interpreted but
> also cause a 108 intercept, which is why we still need to call
> handle_instruction() for SIGP orders other than ecall.
> 
> Since kvm_s390_handle_sigp_pei() is now called for all SIGP orders which
> cause a 108 intercept - even if they are actually handled by
> handle_instruction() - move the tracepoint in kvm_s390_handle_sigp_pei()
> to avoid possibly confusing trace messages.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Cc: <stable@vger.kernel.org> # 5.7
> Fixes: da24a0cc58ed ("KVM: s390: protvirt: Instruction emulation")
> ---
>  arch/s390/kvm/intercept.c | 15 +++++++++++++++
>  arch/s390/kvm/sigp.c      |  4 ++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 8bd42a20d924..88112065d941 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -528,12 +528,27 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
>  
>  static int handle_pv_notification(struct kvm_vcpu *vcpu)
>  {
> +	int ret;
> +
>  	if (vcpu->arch.sie_block->ipa == 0xb210)
>  		return handle_pv_spx(vcpu);
>  	if (vcpu->arch.sie_block->ipa == 0xb220)
>  		return handle_pv_sclp(vcpu);
>  	if (vcpu->arch.sie_block->ipa == 0xb9a4)
>  		return handle_pv_uvc(vcpu);
> +	if (vcpu->arch.sie_block->ipa >> 8 == 0xae) {
> +		/*
> +		 * Besides external call, other SIGP orders also cause a
> +		 * 108 (pv notify) intercept. In contrast to external call,
> +		 * these orders need to be emulated and hence the appropriate
> +		 * place to handle them is in handle_instruction().
> +		 * So first try kvm_s390_handle_sigp_pei() and if that isn't
> +		 * successful, go on with handle_instruction().
> +		 */
> +		ret = kvm_s390_handle_sigp_pei(vcpu);
> +		if (!ret)
> +			return ret;
> +	}
>  
>  	return handle_instruction(vcpu);
>  }
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 8aaee2892ec3..cb747bf6c798 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -480,9 +480,9 @@ int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu *dest_vcpu;
>  	u8 order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
>  
> -	trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
> -
>  	if (order_code == SIGP_EXTERNAL_CALL) {
> +		trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
> +
>  		dest_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
>  		BUG_ON(dest_vcpu == NULL);
>  

