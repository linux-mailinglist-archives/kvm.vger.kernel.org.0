Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0757965C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 11:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiGSJcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 05:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiGSJc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 05:32:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E321838D;
        Tue, 19 Jul 2022 02:32:28 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26J9NpTX023683;
        Tue, 19 Jul 2022 09:32:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FaVGOMgZIEPuxuAo0vbXsLYKNREcDK/tcwywdh5Qbqo=;
 b=i6TlEVyWzcwETUEJHwmyr/xI1kaKN5i+9m8nqsQGsUT5gePhcHjIUqS+46+OBoZ6u4cs
 T651WYzQVuaHM0HMGW/PFfTDijEfqO7YQkwm4AuJXdd58r5O/gUWbDgaWDTsgxs+ztnw
 UPcQ1Loyvrq/CHaosprQwHg7W2M/rs7uF6NOLsX+JDNtyj1eu0OWzNskBpq5lMMxhuWN
 5aNR36A5FJdHku2vqMSRit9DEwawoaHC2R+trn1BJxpwYGov00kid34VhTgRcXGULZgT
 RNGgOq4Yhrc7e/9iejaCSAin+L+obbrqHADdB9NFbS071kV9MKObJiQ6BzgniqmMG3La tg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdsxrg6ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 09:32:27 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26J9M6J0003450;
        Tue, 19 Jul 2022 09:32:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8tx7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 09:32:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26J9WNaj19530150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 09:32:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2187BA404D;
        Tue, 19 Jul 2022 09:32:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2373A4040;
        Tue, 19 Jul 2022 09:32:22 +0000 (GMT)
Received: from [9.171.62.19] (unknown [9.171.62.19])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 09:32:22 +0000 (GMT)
Message-ID: <a89a3872-7390-fd5e-0724-e02c6f3fbf63@linux.ibm.com>
Date:   Tue, 19 Jul 2022 11:32:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v1] s390/kvm: pv: don't present the ecall interrupt twice
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220718130434.73302-1-nrb@linux.ibm.com>
 <5a189be8-db6e-64b5-4acf-fd04302b37b2@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <5a189be8-db6e-64b5-4acf-fd04302b37b2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FebT9EnQc-eGtowG7EcFIILycYnePpr_
X-Proofpoint-ORIG-GUID: FebT9EnQc-eGtowG7EcFIILycYnePpr_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 19.07.22 um 10:42 schrieb Janosch Frank:
> On 7/18/22 15:04, Nico Boehr wrote:
>> When the SIGP interpretation facility is present and a VCPU sends an
>> ecall to another VCPU in enabled wait, the sending VCPU receives a 56
>> intercept (partial execution), so KVM can wake up the receiving CPU.
>> Note that the SIGP interpretation facility will take care of the
>> interrupt delivery and KVM's only job is to wake the receiving VCPU.
>>
>> For PV, the sending VCPU will receive a 108 intercept (pv notify) and
>> should continue like in the non-PV case, i.e. wake the receiving VCPU.
>>
>> For PV and non-PV guests the interrupt delivery will occur through the
>> SIGP interpretation facility on SIE entry when SIE finds the X bit in
>> the status field set.
>>
>> However, in handle_pv_notification(), there was no special handling for
>> SIGP, which leads to interrupt injection being requested by KVM for the
>> next SIE entry. This results in the interrupt being delivered twice:
>> once by the SIGP interpretation facility and once by KVM through the
>> IICTL.
>>
>> Add the necessary special handling in handle_pv_notification(), similar
>> to handle_partial_execution(), which simply wakes the receiving VCPU and
>> leave interrupt delivery to the SIGP interpretation facility.
>>
>> In contrast to external calls, emergency calls are not interpreted but
>> also cause a 108 intercept, which is why we still need to call
>> handle_instruction() for SIGP orders other than ecall.
>>
>> Since kvm_s390_handle_sigp_pei() is now called for all SIGP orders which
>> cause a 108 intercept - even if they are actually handled by
>> handle_instruction() - move the tracepoint in kvm_s390_handle_sigp_pei()
>> to avoid possibly confusing trace messages.
> 
> Lengthy but quite informative
> 
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> Cc: <stable@vger.kernel.org> # 5.7
>> Fixes: da24a0cc58ed ("KVM: s390: protvirt: Instruction emulation")
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> 
> Since it already caused confusion:
> I plan on queuing this (via the s390 KVM tree) for 5.20 and not putting it into rc8 since we've been running with this problem for years and I've yet to see a crash because of it.

yes, makes sense.
> 
>> ---
>>   arch/s390/kvm/intercept.c | 15 +++++++++++++++
>>   arch/s390/kvm/sigp.c      |  4 ++--
>>   2 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index 8bd42a20d924..88112065d941 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -528,12 +528,27 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
>>   static int handle_pv_notification(struct kvm_vcpu *vcpu)
>>   {
>> +    int ret;
>> +
>>       if (vcpu->arch.sie_block->ipa == 0xb210)
>>           return handle_pv_spx(vcpu);
>>       if (vcpu->arch.sie_block->ipa == 0xb220)
>>           return handle_pv_sclp(vcpu);
>>       if (vcpu->arch.sie_block->ipa == 0xb9a4)
>>           return handle_pv_uvc(vcpu);
>> +    if (vcpu->arch.sie_block->ipa >> 8 == 0xae) {
>> +        /*
>> +         * Besides external call, other SIGP orders also cause a
>> +         * 108 (pv notify) intercept. In contrast to external call,
>> +         * these orders need to be emulated and hence the appropriate
>> +         * place to handle them is in handle_instruction().
>> +         * So first try kvm_s390_handle_sigp_pei() and if that isn't
>> +         * successful, go on with handle_instruction().
>> +         */
>> +        ret = kvm_s390_handle_sigp_pei(vcpu);
>> +        if (!ret)
>> +            return ret;
>> +    }
>>       return handle_instruction(vcpu);
>>   }
>> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
>> index 8aaee2892ec3..cb747bf6c798 100644
>> --- a/arch/s390/kvm/sigp.c
>> +++ b/arch/s390/kvm/sigp.c
>> @@ -480,9 +480,9 @@ int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu)
>>       struct kvm_vcpu *dest_vcpu;
>>       u8 order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
>> -    trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
>> -
>>       if (order_code == SIGP_EXTERNAL_CALL) {
>> +        trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
>> +
>>           dest_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
>>           BUG_ON(dest_vcpu == NULL);
> 
