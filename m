Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027A0DB334
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440682AbfJQRXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 13:23:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:62788 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436760AbfJQRXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 13:23:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 10:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="226245158"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 17 Oct 2019 10:23:12 -0700
Date:   Thu, 17 Oct 2019 10:23:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [RFD] x86/split_lock: Request to Intel
Message-ID: <20191017172312.GC20903@linux.intel.com>
References: <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 17, 2019 at 02:29:45PM +0200, Thomas Gleixner wrote:
> The more I look at this trainwreck, the less interested I am in merging any
> of this at all.
> 
> The fact that it took Intel more than a year to figure out that the MSR is
> per core and not per thread is yet another proof that this industry just
> works by pure chance.
> 
> There is a simple way out of this misery:
> 
>   Intel issues a microcode update which does:
> 
>     1) Convert the OR logic of the AC enable bit in the TEST_CTRL MSR to
>        AND logic, i.e. when one thread disables AC it's automatically
>        disabled on the core.
> 
>        Alternatively it supresses the #AC when the current thread has it
>        disabled.
> 
>     2) Provide a separate bit which indicates that the AC enable logic is
>        actually AND based or that #AC is supressed when the current thread
>        has it disabled.
> 
>     Which way I don't really care as long as it makes sense.

The #AC bit doesn't use OR-logic, it's straight up shared, i.e. writes on
one CPU are immediately visible on its sibling CPU.  It doesn't magically
solve the problem, but I don't think we need IPIs to coordinate between
siblings, e.g. wouldn't something like this work?  The per-cpu things
being pointers that are shared by siblings.

void split_lock_disable(void)
{
        spinlock_t *ac_lock = this_cpu_ptr(split_lock_ac_lock);

	spin_lock(ac_lock);
        if (this_cpu_inc_return(*split_lock_ac_disabled) == 1)
                WRMSR(RDMSR() & ~bit);
        spin_unlock(ac_lock);
}

void split_lock_enable(void)
{
        spinlock_t *ac_lock = this_cpu_ptr(split_lock_ac_lock);

	spin_lock(ac_lock);
        if (this_cpu_dec_return(*split_lock_ac_disabled) == 0)
                WRMSR(RDMSR() | bit);
        spin_unlock(ac_lock);
}


To avoid the spin_lock and WRMSR latency on every VM-Enter and VM-Exit,
actions (3a) and (4a) from your matrix (copied below) could be changed to
only do split_lock_disable() if the guest actually generates an #AC, and
then do split_lock_enable() on the next VM-Exit.  Assuming even legacy
guests are somewhat sane and rarely do split-locks, lazily disabling the
control would eliminate most of the overhead and would also reduce the
time that the sibling CPU is running in the host without #AC protection.


N | #AC       | #AC enabled | SMT | Ctrl    | Guest | Action
R | available | on host     |     | exposed | #AC   |
--|-----------|-------------|-----|---------|-------|---------------------
  |           |             |     |         |       |
0 | N         |     x       |  x  |   N     |   x   | None
  |           |             |     |         |       |
1 | Y         |     N       |  x  |   N     |   x   | None
  |           |             |     |         |       |
2 | Y         |     Y       |  x  |   Y     |   Y   | Forward to guest
  |           |             |     |         |       |
3 | Y         |     Y       |  N  |   Y     |   N   | A) Store in vCPU and
  |           |             |     |         |       |    toggle on VMENTER/EXIT
  |           |             |     |         |       |
  |           |             |     |         |       | B) SIGBUS or KVM exit code
  |           |             |     |         |       |
4 | Y         |     Y       |  Y  |   Y     |   N   | A) Disable globally on
  |           |             |     |         |       |    host. Store in vCPU/guest
  |           |             |     |         |       |    state and evtl. reenable
  |           |             |     |         |       |    when guest goes away.
  |           |             |     |         |       | 
  |           |             |     |         |       | B) SIGBUS or KVM exit code


> If that's not going to happen, then we just bury the whole thing and put it
> on hold until a sane implementation of that functionality surfaces in
> silicon some day in the not so foreseeable future.
> 
> Seriously, this makes only sense when it's by default enabled and not
> rendered useless by VIRT. Otherwise we never get any reports and none of
> the issues are going to be fixed.
> 
> Thanks,
> 
> 	tglx
