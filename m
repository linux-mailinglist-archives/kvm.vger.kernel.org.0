Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913DC2F4FB0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 17:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbhAMQRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 11:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbhAMQRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 11:17:36 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EAEC061786;
        Wed, 13 Jan 2021 08:16:56 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10DG5Hun018438;
        Wed, 13 Jan 2021 16:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=I5ZbEghhEnmMY+HcM11oYZy7YgEzZZOdPZP5u9HA9kk=;
 b=VK1KmgqAs22na9/P3ldoP9aYZPErZtSKydCKeGTWgdJy0rxh6Zxdk4jSXSDuLx79z6is
 NmZ46CnXxJco4b9mGsdvE+BMey+34DOVkxXAbi6H3YTWRTBu+PKc3ZpRlvAPY0Uc960V
 sn7cuPMXUEoNX+sZMsXNlFboLBaMnNCOjDfxpmaxCTcZjR3t4oFPplR98b+ZoSI0DFP3
 0/8UtnK2Hgexms/WPVc2dQK1MZz49Popb/pYXMWvBH69fGzl+pLtGkSNyzVxKddgnbTi
 PjdGLmyouOwqDpnSus/ZP8ArBN8RQnlNzGLeUscZf+imQ6HvfFQA3jNWHJ7C08ewgXK3 6A== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 35y5sg2ewd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 16:16:39 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10DG4nYR020608;
        Wed, 13 Jan 2021 11:16:38 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com with ESMTP id 35y8q40rm5-1;
        Wed, 13 Jan 2021 11:16:38 -0500
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 53115249DC;
        Wed, 13 Jan 2021 16:16:38 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <ee071807-5ce5-60c1-c5df-b0b3e068b2ba@redhat.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <6026c2a4-57bf-e045-b62d-30b2490ee331@akamai.com>
Date:   Wed, 13 Jan 2021 11:16:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ee071807-5ce5-60c1-c5df-b0b3e068b2ba@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=772 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130097
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=721 suspectscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130097
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.61)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/13/21 7:53 AM, Paolo Bonzini wrote:
> On 11/01/21 17:57, Jason Baron wrote:
>> +#define DEFINE_KVM_OPS_STATIC_CALL(func)    \
>> +    DEFINE_STATIC_CALL_NULL(kvm_x86_##func,    \
>> +                *(((struct kvm_x86_ops *)0)->func))
>> +#define DEFINE_KVM_OPS_STATIC_CALLS() \
>> +    FOREACH_KVM_X86_OPS(DEFINE_KVM_OPS_STATIC_CALL)
> 
> Something wrong here?

Hmmm...not sure what you are getting at here.

> 
>> +#define DECLARE_KVM_OPS_STATIC_CALL(func)    \
>> +    DECLARE_STATIC_CALL(kvm_x86_##func,    \
>> +                *(((struct kvm_x86_ops *)0)->func))
>> +#define DECLARE_KVM_OPS_STATIC_CALLS()        \
>> +    FOREACH_KVM_X86_OPS(DECLARE_KVM_OPS_STATIC_CALL)
>> +
>> +#define KVM_OPS_STATIC_CALL_UPDATE(func)    \
>> +    static_call_update(kvm_x86_##func, kvm_x86_ops.func)
>> +#define KVM_OPS_STATIC_CALL_UPDATES()        \
>> +    FOREACH_KVM_X86_OPS(KVM_OPS_STATIC_CALL_UPDATE)
>> +
>>   struct kvm_x86_ops {
>>       int (*hardware_enable)(void);
>>       void (*hardware_disable)(void);
>> @@ -1326,6 +1385,12 @@ extern u64 __read_mostly host_efer;
>>   extern bool __read_mostly allow_smaller_maxphyaddr;
>>   extern struct kvm_x86_ops kvm_x86_ops;
>>   +DECLARE_KVM_OPS_STATIC_CALLS();
>> +static inline void kvm_ops_static_call_update(void)
>> +{
>> +    KVM_OPS_STATIC_CALL_UPDATES();
>> +}
> 
> This would become
> 
> #define KVM_X86_OP(func) \
>     DECLARE_STATIC_CALL(kvm_x86_##func,    \
>                 *(((struct kvm_x86_ops *)0)->func));
> 
> #include <asm/kvm-x86-ops.h>
> 
> static inline void kvm_ops_static_call_update(void)
> {
> #define KVM_X86_OP(func) \
>   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> #include <asm/kvm-x86-ops.h>
> }
> 
> If you need to choose between DECLARE_STATIC_CALL_NULL and DECLARE_STATIC_CALL, you can have kvm-x86-ops.h use one of two macros KVM_X86_OP_NULL and
> KVM_X86_OP.
> 
> #define KVM_X86_OP(func) \
>     DECLARE_STATIC_CALL(kvm_x86_##func,    \
>                 *(((struct kvm_x86_ops *)0)->func));
> 
> #define KVM_X86_OP_NULL(func) \
>     DECLARE_STATIC_CALL_NULL(kvm_x86_##func,    \
>                 *(((struct kvm_x86_ops *)0)->func));
> 
> #include <asm/kvm-x86-ops.h>
> 
> ...
> 
> #define KVM_X86_OP(func) \
>   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> #define KVM_X86_OP_NULL(func) \
>   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> #include <asm/kvm-x86-ops.h>
> 
> In that case vmx.c and svm.c could define KVM_X86_OP_NULL to an empty string and list the optional callbacks manually.
> 

Ok, yes, this all makes sense. So I looked at vmx/svm definitions
and I see that there are 5 definitions that are common that
don't use the vmx or svm prefix:

.update_exception_bitmap = update_exception_bitmap,
.enable_nmi_window = enable_nmi_window,
.enable_irq_window = enable_irq_window,
.update_cr8_intercept = update_cr8_intercept,
.enable_smi_window = enable_smi_window,

8 are specific to vmx that don't use the vmx prefix:

.hardware_unsetup = hardware_unsetup,
.hardware_enable = hardware_enable,
.hardware_disable = hardware_disable,
.cpu_has_accelerated_tpr = report_flexpriority,
.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
.update_pi_irte = pi_update_irte,
.complete_emulated_msr = kvm_complete_insn_gp,

and finally 7 specific to svm that don't use the svm prefix:

.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
.handle_exit = handle_exit,
.skip_emulated_instruction = skip_emulated_instruction,
.update_emulated_instruction = NULL,
.sync_pir_to_irr = kvm_lapic_find_highest_irr,
.apicv_post_state_restore = avic_post_state_restore,
.request_immediate_exit = __kvm_request_immediate_exit,


So we could set all of these to empty definitions and specifically
add the callbacks manually as you suggested. Or we could have 4
categories of macros:

1) KVM_X86_OP()  - for the usual case where we have the 'svm' or
'vmx' prefix.

2) KVM_X86_OP_NULL() - for the case where both svm and vmx want
to over-ride.

For the remaining cases I was thinking of having the VMX code
and svm code, add a define for 'VMX' or 'SVM' respectively and
then we could mark the vmx specific ones by adding something like
this to asm/kvm-x86-ops.h:

#ifndef VMX
 #define KVM_X86_OP_UNLESS_VMX(func) \
	KVM_X86_OP(func)
#else
 #define KVM_X86_OP_UNLESS_VMX(func)
#endif

and similarly for the svm specific ones:

#ifndef SVM
 #define KVM_X86_OP_UNLESS_SVM(func) \
	KVM_X86_OP(func)
#else
 #define KVM_X86_OP_UNLESS_SVM(func)
#endif


So in vmx.c you would have:

#define X86_OP(func)     .func = vmx_##func,
#define VMX 1
#include "kvm-x86-ops.h"

Or we could just use the KVM_X86_OP_NULL() macro for anything
that doesn't have a 'svm' or 'vmx' prefix as I think you were
suggesting? In that case I think there would then be 13 manual
additions for vmx and 12 for svm.

Thanks,

-Jason

