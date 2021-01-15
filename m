Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170092F7EE4
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbhAOPFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732392AbhAOPFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 10:05:04 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D60C0613C1;
        Fri, 15 Jan 2021 07:04:24 -0800 (PST)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10FExjQB021067;
        Fri, 15 Jan 2021 15:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=4NGpeS4WaMCORqksBK+py+vQk/geyPMnN+ZkOixm5oI=;
 b=T0L7p+Jfe699n9pw++xezCPGrALh5GOi+wbx9bYtCzEDKhreXMeJhdO2KgWjUBE3+E2F
 rpGAnA2/do2Yjrfre4xmjMfDDZeehUfqUMHzdtNUKwZ09clXXdARJ5UAzWs1tIQp+KeA
 wgK3Dq9O3AmfE2NL8ntodeIaWaY0TD0ch1RS+JlCloERKXp3klCvJdtXLc3gSR0czmzm
 R3F73kuYpnbjy2AXoXhVQF3fJjTJ80EnU0fl3N9X+/rfkDiONi+N3PA4dycdgTbeJGcV
 UHRMdBMSKmtQxqwhMCuM1zJZRa28v5ZCeXehxAjef3rmkP+GjduQp8WkQiqyqCqqTwT2 xg== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 3605hd50um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 15:03:55 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10FF3lnr004193;
        Fri, 15 Jan 2021 10:03:54 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 361qhxxn3j-1;
        Fri, 15 Jan 2021 10:03:53 -0500
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 977CF24A4C;
        Fri, 15 Jan 2021 15:03:53 +0000 (GMT)
Subject: Re: [PATCH v2 2/3] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e5cc82ead7ab37b2dceb0837a514f3f8bea4f8d1.1610680941.git.jbaron@akamai.com>
 <YAFf2+nvhvWjGImy@hirez.programming.kicks-ass.net>
 <84b2f5ba-1a16-cb01-646c-37e25d659650@redhat.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <2e2cd2d9-e010-b435-3aba-35bac1b4cc14@akamai.com>
Date:   Fri, 15 Jan 2021 10:03:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <84b2f5ba-1a16-cb01-646c-37e25d659650@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_08:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150095
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_08:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 clxscore=1015 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150095
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.18)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/15/21 8:50 AM, Paolo Bonzini wrote:
> On 15/01/21 10:26, Peter Zijlstra wrote:
>>> +#define KVM_X86_OP(func)                         \
>>> +    DEFINE_STATIC_CALL_NULL(kvm_x86_##func,                 \
>>> +                *(((struct kvm_x86_ops *)0)->func));
>>> +#define KVM_X86_OP_NULL KVM_X86_OP
>>> +#include <asm/kvm-x86-ops.h>
>>> +EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>>> +EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
>>> +EXPORT_STATIC_CALL_GPL(kvm_x86_tlb_flush_current);
>> Would something like:
>>
>>   
>> https://urldefense.com/v3/__https://lkml.kernel.org/r/20201110103909.GD2594@hirez.programming.kicks-ass.net__;!!GjvTz_vk!GbAPurpdyP1TaDRZN0NvvBkOLJhmRHzNtv0ZVIwZqNrJpMYze75mJzpUNJMRAg$
>>
>> Be useful? That way modules can call the static_call() but not change
>> it.
>>
> 
> Maybe not in these cases, but in general there may be cases where we later want to change the static_call (for example replacing jump labels with
> static_calls).
> 
> Paolo
> 

I tried this out but got:

ERROR: modpost: "__SCK__kvm_x86_cache_reg" [arch/x86/kvm/kvm-amd.ko] undefined!
ERROR: modpost: "__SCK__kvm_x86_tlb_flush_current" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "__SCK__kvm_x86_get_cs_db_l_bits" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "__SCK__kvm_x86_cache_reg" [arch/x86/kvm/kvm-intel.ko] undefined!

I'm a bit confused because we have:

#define __static_call(name)                                             \
({                                                                      \
        __ADDRESSABLE(STATIC_CALL_KEY(name));                           \
        &STATIC_CALL_TRAMP(name);                                       \
})

And so it looks to me like we need to still reference the key from the module code.

Thanks,

-Jason
