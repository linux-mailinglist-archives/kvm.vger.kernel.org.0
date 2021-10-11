Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916354287FE
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhJKHpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:45:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234580AbhJKHp2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 03:45:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B6aRpL028804;
        Mon, 11 Oct 2021 03:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eazA3nNV2QLHTEDgmq6pOe51oMfoJt60vLTixnbcM6I=;
 b=jN3SqKWnL6JxAa+nzwIK2joQGlHAT3Z2coCZzjUH02ZdoktOVC5mzkakphU+BYV8RIMa
 ZhgdO4jLpMb9nivduoL55n5s5p7DzJSV8/715bSTXHd+tgI1omw/nYLFL2nzVfi8E3CS
 gGe3LaENrUH8hh1MYZQ5fBZ2d2FGPro4RdP9SmeqUBX7VLkaFkcKKGu/L7x5uTK+x8IG
 /znEpIYysx+VDI0RWPdJV42OCScQyMNOpxFO0V1QWmOKzLaT6JgRMRnznc646MU3fbW6
 H9j7zAtC7w08jB3QhhT/7JivMSIG46Gw2UaKqRz6iJJztsgpoJIVWaPOlh+vPTMpsFZP 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmagr71wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:43:26 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19B7PYOw023481;
        Mon, 11 Oct 2021 03:43:26 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmagr71w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:43:26 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19B7gcA4023146;
        Mon, 11 Oct 2021 07:43:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2q9a1yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 07:43:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19B7bhra39911684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 07:37:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E48CAE05D;
        Mon, 11 Oct 2021 07:43:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 706C5AE061;
        Mon, 11 Oct 2021 07:43:12 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.26.102])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Oct 2021 07:43:12 +0000 (GMT)
Subject: Re: [RFC PATCH v1 2/6] KVM: s390: Reject SIGP when destination CPU is
 busy
To:     Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-3-farman@linux.ibm.com>
 <4c6c0b14-e148-9000-c581-db14d2ea555e@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <8d8012a8-6ea5-6e0e-19c4-d9c64e785222@de.ibm.com>
Date:   Mon, 11 Oct 2021 09:43:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4c6c0b14-e148-9000-c581-db14d2ea555e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 67m0beFZ_gcVSHOrpBcGpGBj-EemF3W_
X-Proofpoint-ORIG-GUID: n4qucRlh-utsawycDEfQGQlQRg2KJcri
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_02,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.10.21 um 09:27 schrieb Thomas Huth:
> On 08/10/2021 22.31, Eric Farman wrote:
>> With KVM_CAP_USER_SIGP enabled, most orders are handled by userspace.
>> However, some orders (such as STOP or STOP AND STORE STATUS) end up
>> injecting work back into the kernel. Userspace itself should (and QEMU
>> does) look for this conflict, and reject additional (non-reset) orders
>> until this work completes.
>>
>> But there's no need to delay that. If the kernel knows about the STOP
>> IRQ that is in process, the newly-requested SIGP order can be rejected
>> with a BUSY condition right up front.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   arch/s390/kvm/sigp.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 43 insertions(+)
>>
>> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
>> index cf4de80bd541..6ca01bbc72cf 100644
>> --- a/arch/s390/kvm/sigp.c
>> +++ b/arch/s390/kvm/sigp.c
>> @@ -394,6 +394,45 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
>>       return 1;
>>   }
>> +static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8 order_code,
>> +                    u16 cpu_addr)
>> +{
>> +    struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
>> +    int rc = 0;
>> +
>> +    /*
>> +     * SIGP orders directed at invalid vcpus are not blocking,
>> +     * and should not return busy here. The code that handles
>> +     * the actual SIGP order will generate the "not operational"
>> +     * response for such a vcpu.
>> +     */
>> +    if (!dst_vcpu)
>> +        return 0;
>> +
>> +    /*
>> +     * SIGP orders that process a flavor of reset would not be
>> +     * blocked through another SIGP on the destination CPU.
>> +     */
>> +    if (order_code == SIGP_CPU_RESET ||
>> +        order_code == SIGP_INITIAL_CPU_RESET)
>> +        return 0;
>> +
>> +    /*
>> +     * Any other SIGP order could race with an existing SIGP order
>> +     * on the destination CPU, and thus encounter a busy condition
>> +     * on the CPU processing the SIGP order. Reject the order at
>> +     * this point, rather than racing with the STOP IRQ injection.
>> +     */
>> +    spin_lock(&dst_vcpu->arch.local_int.lock);
>> +    if (kvm_s390_is_stop_irq_pending(dst_vcpu)) {
>> +        kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
>> +        rc = 1;
>> +    }
>> +    spin_unlock(&dst_vcpu->arch.local_int.lock);
>> +
>> +    return rc;
>> +}
>> +
>>   int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>>   {
>>       int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
>> @@ -408,6 +447,10 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>>           return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>       order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
>> +
>> +    if (handle_sigp_order_is_blocked(vcpu, order_code, cpu_addr))
>> +        return 0;
>> +
>>       if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
>>           return -EOPNOTSUPP;
> 
> We've been bitten quite a bit of times in the past already by doing too much control logic in the kernel instead of doing it in QEMU, where we should have a more complete view of the state ... so I'm feeling quite a bit uneasy of adding this in front of the "return -EOPNOTSUPP" here ... Did you see any performance issues that would justify this change?

It does at least handle this case for simple userspaces without KVM_CAP_S390_USER_SIGP .
