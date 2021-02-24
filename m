Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD03323F94
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhBXON4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbhBXNew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:34:52 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5568DC06121F
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 05:31:13 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id e10so1681365wro.12
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 05:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dme-org.20150623.gappssmtp.com; s=20150623;
        h=to:cc:subject:in-reply-to:references:from:date:message-id
         :mime-version;
        bh=0wojTu++d3zG8QHPBKHQdj7qcA4E471xrkGjRsrDSb0=;
        b=oZd1EcmHmtQPmA9Pu8sMJZLsld9SX5t3gJrkLSULaOO9WgLtecjPiTY99HLEv2kSYy
         SizvE1GTXqP5veBcF5toHTKRgB8qF9OrBfwYf1pEa6j17wGznSMGSsna7cPXVk9UoIVt
         zffxefVmWqam2Pod7wrUyjsi9KH0y6mqvhOkQuKwXtCnJvT/DKddlu09ec2ED7F4TyDf
         /pPHQNXenaslou5LTLM8FAGQpKzoQeAFudiS2UlRS4VEyOBR4HUku5IoE9GljD5v8oo+
         PF6SgvdkmpcBmV+urNG8Eyfce456yLyRKyqet24NiKjdcUST+PLM3V1H78B+vyl5regy
         V8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:subject:in-reply-to:references:from:date
         :message-id:mime-version;
        bh=0wojTu++d3zG8QHPBKHQdj7qcA4E471xrkGjRsrDSb0=;
        b=el6O8ul9sSHi8Zg9L4ZNqKXJzdTw76h6jWXuKPwgujLWAPLFmuHBwsJLn50jBun864
         jwMWZq9ncgIpU73nyo3oMf4p0atChgxZmvxetOOGru3NPaa4Xv4F3nw91RRxzTYsjB2j
         HygWqr+AW2be4dJR4S/eCp8KZPWOd2PK4tN49rITsb2YyNrZAl90o6lojBihwHZa74fy
         dd+rMFUIk/pJqhUhf7VL4OoxLlTKUEzSWQOd8JS9WM7F72y4pcZccH1wkBPAqK3FiSgd
         oBxpOsh73/FOhxXCcW0CJqMMfOtvcpMdx+R1Hz3qvHiPvh6rAkowyNhvCzgxqY6lro7o
         fVdw==
X-Gm-Message-State: AOAM53382EcOdsyvcCeqUmxQQ/zrFJFGoT80aFX8Rzy5AHZ5LWpWRKTJ
        ZqOUVsA6fusifTHdQgHbJzJrOg==
X-Google-Smtp-Source: ABdhPJxTsG02fCn7cHHlqxULP/A5A6ze8umKX4wMVBiqa3ngsMpHsi/I0sl08ULa7nJjjgYPvZMzeQ==
X-Received: by 2002:adf:f841:: with SMTP id d1mr2607478wrq.36.1614173472040;
        Wed, 24 Feb 2021 05:31:12 -0800 (PST)
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net. [2001:8b0:bb71:7140:64::1])
        by smtp.gmail.com with ESMTPSA id h17sm2842251wrt.74.2021.02.24.05.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:31:11 -0800 (PST)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 68da51e6;
        Wed, 24 Feb 2021 13:31:10 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: dump_vmcs should not conflate EFER and
 PAT presence in VMCS
In-Reply-To: <YDWIlb0epWBcxFNr@google.com>
References: <20210219144632.2288189-1-david.edmondson@oracle.com>
 <20210219144632.2288189-3-david.edmondson@oracle.com>
 <YDWIlb0epWBcxFNr@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Wed, 24 Feb 2021 13:31:10 +0000
Message-ID: <m2zgztego1.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 2021-02-23 at 14:58:29 -08, Sean Christopherson wrote:

> On Fri, Feb 19, 2021, David Edmondson wrote:
>> Show EFER and PAT based on their individual entry/exit controls.
>> 
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 818051c9fa10..25090e3683ca 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5805,11 +5805,12 @@ void dump_vmcs(void)
>>  	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
>>  	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
>>  	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
>> -	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
>> -	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
>> -		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
>> -		       vmcs_read64(GUEST_IA32_EFER),
>> -		       vmcs_read64(GUEST_IA32_PAT));
>> +	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
>
> Not your code, and completely benign since VM_EXIT_SAVE is never set, but I
> don't like checking the VM_EXIT_SAVE_* flag as saving a field on VM-Exit has
> zero impact on whether VM-Entry succeeds or fails.  Same complaint on the PAT
> field.

Added to v3.

>> +	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
>> +		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
>
> Tying into the previous patch, I think we should print both the effective EFER
> and vmcs.EFER.  The effective EFER is relevant for several consistency checks.
> Maybe something like this?
>
> 	pr_err("EFER= 0x%016llx  ", effective_efer);
> 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
> 		pr_cont("vmcs.EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
> 	else
> 		pr_cont("vmcs.EFER not loaded\n")

Added something similar, that makes it clear where the value came from,
in v3.

>> +	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_PAT) ||
>> +	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT))
>> +		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
>>  	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
>>  	       vmcs_read64(GUEST_IA32_DEBUGCTL),
>>  	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
>> @@ -5846,10 +5847,10 @@ void dump_vmcs(void)
>>  	       vmcs_readl(HOST_IA32_SYSENTER_ESP),
>>  	       vmcs_read32(HOST_IA32_SYSENTER_CS),
>>  	       vmcs_readl(HOST_IA32_SYSENTER_EIP));
>> -	if (vmexit_ctl & (VM_EXIT_LOAD_IA32_PAT | VM_EXIT_LOAD_IA32_EFER))
>> -		pr_err("EFER = 0x%016llx  PAT = 0x%016llx\n",
>> -		       vmcs_read64(HOST_IA32_EFER),
>> -		       vmcs_read64(HOST_IA32_PAT));
>> +	if (vmexit_ctl & VM_EXIT_LOAD_IA32_EFER)
>> +		pr_err("EFER= 0x%016llx\n", vmcs_read64(HOST_IA32_EFER));
>> +	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PAT)
>> +		pr_err("PAT = 0x%016llx\n", vmcs_read64(HOST_IA32_PAT));
>>  	if (cpu_has_load_perf_global_ctrl() &&
>>  	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
>>  		pr_err("PerfGlobCtl = 0x%016llx\n",
>> -- 
>> 2.30.0
>> 

dme.
-- 
And the sign said: long haired freaky people need not apply.
