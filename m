Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F032655402
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiLWTnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 14:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiLWTmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 14:42:47 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3159B21880;
        Fri, 23 Dec 2022 11:42:26 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2BNJg9H13006325
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 23 Dec 2022 11:42:10 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2BNJg9H13006325
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022120601; t=1671824531;
        bh=6InhouiQkFuN92U4rKDip7N9T/oVeeUpKZew3FNxOHo=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=HcYyEgJAa5XbojShSOc0wzxA5elK4pUPOu3/sqGHMVCx5VGIJLBlPH3NPuF2izdz5
         0l4igTczqb/garVMR+wkV7kW2cGtTwJe/UVneVxX2RAYVoMzBRKBqefe2G8r3Vbn54
         AhuWxvUR3XrqsChhnqaByaWKATUhnyHS1yPfbNdInvNA0jk0LGoNzNsVCLoaoeWhYN
         4hiNxpCtxbcKkUOCgCBje03otpEexRT7B7uIYYqwMQZ8qcL0aiLkPs9Cji4s+9mBUf
         WjVk+DdJ/0fJ2LN/TJ+aFaoOWkfEtRe0mfx7+LdME/xDMPYk10vhynLPX1tKQF0s1P
         NtrbD9qYuSTIw==
Date:   Fri, 23 Dec 2022 11:42:08 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Peter Zijlstra <peterz@infradead.org>, Xin Li <xin3.li@intel.com>
CC:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_23/32=5D_x86/fred=3A_update?= =?US-ASCII?Q?_MSR=5FIA32=5FFRED=5FRSP0_during_task_switch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y6GE/Fnl1tuER1fF@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com> <20221220063658.19271-24-xin3.li@intel.com> <Y6GE/Fnl1tuER1fF@hirez.programming.kicks-ass.net>
Message-ID: <C2B7B3DF-51BD-455A-8F9D-BE1C0FFA60AD@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On December 20, 2022 1:48:44 AM PST, Peter Zijlstra <peterz@infradead=2Eorg=
> wrote:
>On Mon, Dec 19, 2022 at 10:36:49PM -0800, Xin Li wrote:
>> From: "H=2E Peter Anvin (Intel)" <hpa@zytor=2Ecom>
>>=20
>> MSR_IA32_FRED_RSP0 is used during ring 3 event delivery, and needs to
>> be updated to point to the top of next task stack during task switch=2E
>>=20
>> Signed-off-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> Signed-off-by: Xin Li <xin3=2Eli@intel=2Ecom>
>> ---
>>  arch/x86/include/asm/switch_to=2Eh | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/switch_to=2Eh b/arch/x86/include/asm/=
switch_to=2Eh
>> index c08eb0fdd11f=2E=2Ec28170d4fbba 100644
>> --- a/arch/x86/include/asm/switch_to=2Eh
>> +++ b/arch/x86/include/asm/switch_to=2Eh
>> @@ -71,9 +71,13 @@ static inline void update_task_stack(struct task_str=
uct *task)
>>  	else
>>  		this_cpu_write(cpu_tss_rw=2Ex86_tss=2Esp1, task->thread=2Esp0);
>>  #else
>> -	/* Xen PV enters the kernel on the thread stack=2E */
>> -	if (static_cpu_has(X86_FEATURE_XENPV))
>> +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
>> +		wrmsrl(MSR_IA32_FRED_RSP0,
>> +		       task_top_of_stack(task) + TOP_OF_KERNEL_STACK_PADDING);
>
>Urgh, I'm assuming this is a *fast* MSR ?
>
>> +	} else if (static_cpu_has(X86_FEATURE_XENPV)) {
>> +		/* Xen PV enters the kernel on the thread stack=2E */
>>  		load_sp0(task_top_of_stack(task));
>> +	}
>>  #endif
>
>

The performance here will be addressed by WRMSRNS/WRMSRLIST=2E It is not i=
ncluded in the FRED patchset simply because there is a separate, parallel e=
nabling effort going on for those instructions (which are useful in their o=
wn right, especially for perf, and may be available before FRED) and we don=
't want unnecessary collisions=2E

Those instructions weren't public when I wrote the first version of this p=
atchset, but they are now in the ISE documentation=2E

Xin, could you add that note to the patch documentation?
