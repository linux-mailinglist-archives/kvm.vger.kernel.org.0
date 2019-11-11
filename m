Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED5F7746
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKKPAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:00:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKPAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:00:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmWUU112017;
        Mon, 11 Nov 2019 14:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Aw3n/NGCKepXhXPI8k6tnOfYauE1E+r2KFX4bsTX2pk=;
 b=gh9pPPufBbS4gmhrOSpdetJA7eLe3ZSZ4T7VDdkipRccus7XehJ1dS2XrDcNL+UwPhHH
 xnOgBiW9EfhDhyEmWtILPxFAs/PxNoJuF7MuJvO0FnmubhXHgzP/xu5UmvB+YFmOjU8e
 kyQ47toh5LK/Itr6sbz9E4W1SrIaz3wpDuD84tJs8IBYwmxs+raVYyt32ee6gHhT1waJ
 pm1z+UCLoVeKNgGfvzbqSsE1cZBMOGBgF26S1BHwy8RuVB54RIV1DSLaspl3FRn2usdF
 FsCsmCIXJQkwlmqPZvBDMJxt0T/4GawLmM7amn2J0yl2kiJy/Zu79XXMKNbH0kz//rvk Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qfbf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:59:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmeuk181513;
        Mon, 11 Nov 2019 14:59:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w67km691t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:59:09 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABEx8JU028858;
        Mon, 11 Nov 2019 14:59:08 GMT
Received: from [10.175.169.52] (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 14:59:08 +0000
Subject: Re: [PATCH v1 1/3] KVM: VMX: Consider PID.PIR to determine if vCPU
 has pending interrupts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-2-joao.m.martins@oracle.com>
 <67bca655-fea3-4b57-be3c-7dc58026b5d9@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <030dd147-8c4f-d6e3-85a8-ee743ce4d5b0@oracle.com>
Date:   Mon, 11 Nov 2019 14:59:03 +0000
MIME-Version: 1.0
In-Reply-To: <67bca655-fea3-4b57-be3c-7dc58026b5d9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 2:46 PM, Paolo Bonzini wrote:
> On 06/11/19 18:56, Joao Martins wrote:
>> Commit 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
>> introduced vmx_dy_apicv_has_pending_interrupt() in order to determine
>> if a vCPU have a pending posted interrupt. This routine is used by
>> kvm_vcpu_on_spin() when searching for a a new runnable vCPU to schedule
>> on pCPU instead of a vCPU doing busy loop.
>>
>> vmx_dy_apicv_has_pending_interrupt() determines if a
>> vCPU has a pending posted interrupt solely based on PID.ON. However,
>> when a vCPU is preempted, vmx_vcpu_pi_put() sets PID.SN which cause
>> raised posted interrupts to only set bit in PID.PIR without setting
>> PID.ON (and without sending notification vector), as depicted in VT-d
>> manual section 5.2.3 "Interrupt-Posting Hardware Operation".
>>
>> Therefore, checking PID.ON is insufficient to determine if a vCPU has
>> pending posted interrupts and instead we should also check if there is
>> some bit set on PID.PIR.
>>
>> Fixes: 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 31ce6bc2c371..18b0bee662a5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6141,7 +6141,10 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>>  
>>  static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
>>  {
>> -	return pi_test_on(vcpu_to_pi_desc(vcpu));
>> +	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>> +
>> +	return pi_test_on(pi_desc) ||
>> +		!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
>>  }
>>  
>>  static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> 
> Should we check the bitmap only if SN is false?  We have a precondition
> that if SN is clear then non-empty PIR implies ON=1 (modulo the small
> window in vmx_vcpu_pi_load of course), so that'd be a bit faster.

Makes sense;

The bitmap check was really meant for SN=1.

Should SN=0 we would be saving ~22-27 cycles as far as I micro-benchmarked a few
weeks ago. Now that you suggest it, it would be also good for older platforms too.

Cheers,
	Joao
