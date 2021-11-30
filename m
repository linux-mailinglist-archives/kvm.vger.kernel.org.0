Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1203463605
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 15:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbhK3OJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 09:09:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33360 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhK3OJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 09:09:12 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638281151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mcbj+bCt1LhWTJK3ZC+zwpXOVsK4oyc59ez8+ffOKxw=;
        b=QiOhhXMhOivM0rbq0f+06dO8N41512FnI6RYNs0+MbOnpP8z6/8doVCE0nr/WNMA0T3WN9
        LC2MXBUgY74N48xfsExCmsweYcgE4nppQ5iQbgGGrdy1zfT5H6Cb6+GYEhyiMGmxugpPb4
        fWPYoz5xsna40HPs3W/UuXVZafSw2o7Q86+xNEFGyOz/whdMCjXsdmhV/PQEpl5+bLxcX0
        nURNgrP/k6Nk9WBgUMG7ewl4nGRCs8DxYRAmPJbLFlB1PA8zTWJAuqct9jHWc723qA0bRT
        WWM6VcwQtiD1i5nqkBBUZ7hb8Yn13RD44SIUPzcjO3DhXahnrC3ZQsmlM2p/zQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638281151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mcbj+bCt1LhWTJK3ZC+zwpXOVsK4oyc59ez8+ffOKxw=;
        b=QKR6FiQ2F4rmzipAg07BQx6w4qnJrXCOOE4/X8Ux1eS9Tn0IwA5BaK5BCQbAiEdKUE6ITR
        njQYvzefz3NLR4Ag==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Q. about KVM and CPU hotplug
In-Reply-To: <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
 <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
Date:   Tue, 30 Nov 2021 15:05:50 +0100
Message-ID: <8735ndd9hd.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30 2021 at 10:28, Paolo Bonzini wrote:

> On 11/30/21 09:27, Tian, Kevin wrote:
>> 		r = kvm_arch_hardware_enable();
>> 
>> 		if (r) {
>> 			cpumask_clear_cpu(cpu, cpus_hardware_enabled);
>> 			atomic_inc(&hardware_enable_failed);
>> 			pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
>> 		}
>> 	}
>> 
>> Upon error hardware_enable_failed is incremented. However this variable
>> is checked only in hardware_enable_all() called when the 1st VM is called.
>> 
>> This implies that KVM may be left in a state where it doesn't know a CPU
>> not ready to host VMX operations.
>> 
>> Then I'm curious what will happen if a vCPU is scheduled to this CPU. Does
>> KVM indirectly catch it (e.g. vmenter fail) and return a deterministic error
>> to Qemu at some point or may it lead to undefined behavior? And is there
>> any method to prevent vCPU thread from being scheduled to the CPU?
>
> It should fail the first vmptrld instruction.  It will result in a few 
> WARN_ONCE and pr_warn_ratelimited (see vmx_insn_failed).  For VMX this 
> should be a pretty bad firmware bug, and it has never been reported. 
> KVM did find some undocumented errata but not this one!
>
> I don't think there's any fix other than pinning userspace.  The WARNs 
> can be eliminated by calling KVM_BUG_ON in the sched_in notifier, plus 
> checking if the VM is bugged before entering the guest or doing a 
> VMREAD/VMWRITE (usually the check is done only in a ioctl).  But some 
> refactoring is probably needed to make the code more robust in general.

Why is this hotplug callback in the CPU starting section to begin with?

If you stick it into the online section which runs on the hotplugged CPU
in thread context:

	CPUHP_AP_ONLINE_IDLE,

-->   	CPUHP_AP_KVM_STARTING,

	CPUHP_AP_SCHED_WAIT_EMPTY,

then it is allowed to fail and it still works in the right way.

When onlining a CPU then there cannot be any vCPU task run on the
CPU at that point.

When offlining a CPU then it's guaranteed that all user tasks and
non-pinned kernel tasks have left the CPU, i.e. there cannot be a vCPU
task around either.

Thanks,

        tglx

