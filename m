Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29D4226B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 12:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405295AbfFLKZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 06:25:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56267 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387563AbfFLKZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 06:25:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so5961731wmj.5
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 03:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xuz7wl9JI/1izuO7h6cmpUujshUximjTTA0wiCF4sTg=;
        b=Z9cqXPTdlasoSfn7Hoth86clB1wU4/YqPRNBxevA8dHc2bB1jjBygWjR+Ve9efQbA4
         8CMQRGiM2+FYgq2tSqA+uK8upvDVYdgh3F9e7QVzviG1IZXW4trY/SQsbXvglDB93W7p
         bYQFiO3peWuB+nkCaQSeVH1HYna3xTYpFBXt8YHMCi6fnvHj4ioMf2G+e84pV/PPur7f
         M0h25QWZV+D3pquGipgqsEx08VHKPuiNelczugCwqn72m9H/DyZb1tHBb16hYi7Kt8mE
         6pqrPDVmk2aFtvWBIJ8umRjXBKQixi7OG5emyovlO3ZNDw5BpN/b828buthegpIPrAfJ
         i3gw==
X-Gm-Message-State: APjAAAXGZhBrDqU5CwNC9tSN0OOuOicVEZnh/p77DVWrNsnOJUfyMQNp
        nNxeJXujdrak+9hyHG7Xzz12YQ==
X-Google-Smtp-Source: APXvYqyvXjwdxbX8PPfz/CW94/F08nXOpdTiba2085ImP1ZnWBDiUcxjjeVDZN0HlcN+tUZgfwgZfw==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr22199755wmc.133.1560335146039;
        Wed, 12 Jun 2019 03:25:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f2sm13793660wru.31.2019.06.12.03.25.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 03:25:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley \(EOSG\)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting reenlightenment vector
In-Reply-To: <20190612093506.GH3436@hirez.programming.kicks-ass.net>
References: <20190611212003.26382-1-dima@arista.com> <20190612093506.GH3436@hirez.programming.kicks-ass.net>
Date:   Wed, 12 Jun 2019 12:25:44 +0200
Message-ID: <87tvcvdrrr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Jun 11, 2019 at 10:20:03PM +0100, Dmitry Safonov wrote:
>> KVM support may be compiled as dynamic module, which triggers the
>> following splat on modprobe:
>> 
>>  KVM: vmx: using Hyper-V Enlightened VMCS
>>  BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/466 caller is debug_smp_processor_id+0x17/0x19
>>  CPU: 0 PID: 466 Comm: modprobe Kdump: loaded Not tainted 4.19.43 #1
>>  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  06/02/2017
>>  Call Trace:
>>   dump_stack+0x61/0x7e
>>   check_preemption_disabled+0xd4/0xe6
>>   debug_smp_processor_id+0x17/0x19
>>   set_hv_tscchange_cb+0x1b/0x89
>>   kvm_arch_init+0x14a/0x163 [kvm]
>>   kvm_init+0x30/0x259 [kvm]
>>   vmx_init+0xed/0x3db [kvm_intel]
>>   do_one_initcall+0x89/0x1bc
>>   do_init_module+0x5f/0x207
>>   load_module+0x1b34/0x209b
>>   __ia32_sys_init_module+0x17/0x19
>>   do_fast_syscall_32+0x121/0x1fa
>>   entry_SYSENTER_compat+0x7f/0x91
>> 
>> The easiest solution seems to be disabling preemption while setting up
>> reenlightment MSRs. While at it, fix hv_cpu_*() callbacks.
>> 
>> Fixes: 93286261de1b4 ("x86/hyperv: Reenlightenment notifications
>> support")
>> 
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Cathy Avery <cavery@redhat.com>
>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
>> Cc: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
>> Cc: Mohammed Gamal <mmorsy@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>> Cc: Roman Kagan <rkagan@virtuozzo.com>
>> Cc: Sasha Levin <sashal@kernel.org>
>> Cc: Stephen Hemminger <sthemmin@microsoft.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> Cc: devel@linuxdriverproject.org
>> Cc: kvm@vger.kernel.org
>> Cc: linux-hyperv@vger.kernel.org
>> Cc: x86@kernel.org
>> Reported-by: Prasanna Panchamukhi <panchamukhi@arista.com>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> ---
>>  arch/x86/hyperv/hv_init.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> index 1608050e9df9..0bdd79ecbff8 100644
>> --- a/arch/x86/hyperv/hv_init.c
>> +++ b/arch/x86/hyperv/hv_init.c
>> @@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(hv_max_vp_index);
>>  static int hv_cpu_init(unsigned int cpu)
>>  {
>>  	u64 msr_vp_index;
>> -	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
>> +	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
>>  	void **input_arg;
>>  	struct page *pg;
>>  
>> @@ -103,7 +103,7 @@ static int hv_cpu_init(unsigned int cpu)
>>  
>>  	hv_get_vp_index(msr_vp_index);
>>  
>> -	hv_vp_index[smp_processor_id()] = msr_vp_index;
>> +	hv_vp_index[cpu] = msr_vp_index;
>>  
>>  	if (msr_vp_index > hv_max_vp_index)
>>  		hv_max_vp_index = msr_vp_index;
>> @@ -182,7 +182,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
>>  	struct hv_reenlightenment_control re_ctrl = {
>>  		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
>>  		.enabled = 1,
>> -		.target_vp = hv_vp_index[smp_processor_id()]
>>  	};
>>  	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
>>  
>> @@ -196,7 +195,11 @@ void set_hv_tscchange_cb(void (*cb)(void))
>>  	/* Make sure callback is registered before we write to MSRs */
>>  	wmb();
>>  
>> +	preempt_disable();
>> +	re_ctrl.target_vp = hv_vp_index[smp_processor_id()];
>>  	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
>> +	preempt_enable();
>> +
>>  	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
>>  }
>>  EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);
>
> This looks bogus, MSRs are a per-cpu resource, you had better know what
> CPUs you're on and be stuck to it when you do wrmsr. This just fudges
> the code to make the warning go away and doesn't fix the actual problem
> afaict.

Actually, we don't care which CPU will receive the reenlightenment
notification and TSC Emulation in Hyper-V is, of course, global. We have
code which re-assignes the notification to some other CPU in case the
one it's currently assigned to goes away (see hv_cpu_die()).

-- 
Vitaly
