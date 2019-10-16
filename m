Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C03D88D3
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 08:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388047AbfJPG6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 02:58:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64506 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387860AbfJPG6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 02:58:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 23:58:11 -0700
X-IronPort-AV: E=Sophos;i="5.67,302,1566889200"; 
   d="scan'208";a="186064631"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 15 Oct 2019 23:58:07 -0700
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <bc8f5850-ba7d-45b7-a30b-5560764edcc8@intel.com>
Date:   Wed, 16 Oct 2019 14:58:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190925180931.GG31852@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/2019 2:09 AM, Sean Christopherson wrote:
> On Wed, Jun 26, 2019 at 11:47:40PM +0200, Thomas Gleixner wrote:
>> So only one of the CPUs will win the cmpxchg race, set te variable to 1 and
>> warn, the other and any subsequent AC on any other CPU will not warn
>> either. So you don't need WARN_ONCE() at all. It's redundant and confusing
>> along with the atomic_set().
>>
>> Whithout reading that link [1], what Ingo proposed was surely not the
>> trainwreck which you decided to put into that debugfs thing.
> 
> We're trying to sort out the trainwreck, but there's an additional wrinkle
> that I'd like your input on.
> 
> We overlooked the fact that MSR_TEST_CTRL is per-core, i.e. shared by
> sibling hyperthreads.  This is especially problematic for KVM, as loading
> MSR_TEST_CTRL during VM-Enter could cause spurious #AC faults in the kernel
> and bounce MSR_TEST_CTRL.split_lock.
> 
> E.g. if CPU0 and CPU1 are siblings and CPU1 is running a KVM guest with
> MSR_TEST_CTRL.split_lock=1, hitting an #AC on CPU0 in the host kernel will
> lead to suprious #AC faults and constant toggling of of the MSR.
> 
>    CPU0               CPU1
> 
>           split_lock=enabled
> 
>    #AC -> disabled
> 
>                       VM-Enter -> enabled
> 
>    #AC -> disabled
> 
>                       VM-Enter -> enabled
> 
>    #AC -> disabled
> 
> 
> 
> My thought to handle this:
> 
>    - Remove the per-cpu cache.
> 
>    - Rework the atomic variable to differentiate between "disabled globally"
>      and "disabled by kernel (on some CPUs)".
> 
>    - Modify the #AC handler to test/set the same atomic variable as the
>      sysfs knob.  This is the "disabled by kernel" flow.
> 
>    - Modify the debugfs/sysfs knob to only allow disabling split-lock
>      detection.  This is the "disabled globally" path, i.e. sends IPIs to
>      clear MSR_TEST_CTRL.split_lock on all online CPUs.
> 
>    - Modify the resume/init flow to clear MSR_TEST_CTRL.split_lock if it's
>      been disabled on *any* CPU via #AC or via the knob.
> 
>    - Modify the debugs/sysfs read function to either print the raw atomic
>      variable, or differentiate between "enabled", "disabled globally" and
>     "disabled by kernel".
> 
>    - Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
>      actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
>      guest can do WRMSR and handle its own #AC faults, but KVM doesn't
>      change the value in hardware.
> 
>        * Allowing guest to enable split-lock detection can induce #AC on
>          the host after it has been explicitly turned off, e.g. the sibling
>          hyperthread hits an #AC in the host kernel, or worse, causes a
>          different process in the host to SIGBUS.
> 
>        * Allowing guest to disable split-lock detection opens up the host
>          to DoS attacks.
> 
>    - KVM advertises split-lock detection to guest/userspace if and only if
>      split_lock_detect_disabled is zero.
> 
>    - Add a pr_warn_once() in KVM that triggers if split locks are disabled
>      after support has been advertised to a guest.
> 
> Does this sound sane?
> 
> The question at the forefront of my mind is: why not have the #AC handler
> send a fire-and-forget IPI to online CPUs to disable split-lock detection
> on all CPUs?  Would the IPI be problematic?  Globally disabling split-lock
> on any #AC would (marginally) simplify the code and would eliminate the
> oddity of userspace process (and KVM guest) #AC behavior varying based on
> the physical CPU it's running on.
> 
> 
> Something like:
> 
> #define SPLIT_LOCK_DISABLED_IN_KERNEL	BIT(0)
> #define SPLIT_LOCK_DISABLED_GLOBALLY	BIT(1)
> 
> static atomic_t split_lock_detect_disabled = ATOMIT_INIT(0);
> 
> void split_lock_detect_ac(void)
> {
> 	lockdep_assert_irqs_disabled();
> 
> 	/* Disable split lock detection on this CPU to avoid reentrant #AC. */
> 	wrmsrl(MSR_TEST_CTRL,
> 	       rdmsrl(MSR_TEST_CTRL) & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
> 
> 	/*
> 	 * If split-lock detection has not been disabled, either by the kernel
> 	 * or globally, record that it has been disabled by the kernel and
> 	 * WARN.  Guarding WARN with the atomic ensures only the first #AC due
> 	 * to split-lock is logged, e.g. if multiple CPUs encounter #AC or if
> 	 * #AC is retriggered by a perf context NMI that interrupts the
> 	 * original WARN.
> 	 */
> 	if (atomic_cmpxchg(&split_lock_detect_disabled, 0,
> 			   SPLIT_LOCK_DISABLED_IN_KERNEL) == 0)
> 	        WARN(1, "split lock operation detected\n");
> }
> 
> static ssize_t split_lock_detect_wr(struct file *f, const char __user *user_buf,
> 				    size_t count, loff_t *ppos)
> {
> 	int old;
> 
> 	<parse or ignore input value?>
> 	
> 	old = atomic_fetch_or(SPLIT_LOCK_DISABLED_GLOBALLY,
> 			      &split_lock_detect_disabled);
> 
> 	/* Update MSR_TEST_CTRL unless split-lock was already disabled. */
> 	if (!(old & SPLIT_LOCK_DISABLED_GLOBALLY))
> 		on_each_cpu(split_lock_update, NULL, 1);
> 
> 	return count;
> }
> 

Hi Thomas,

Could you please have a look at Sean's proposal and give your opinion.
