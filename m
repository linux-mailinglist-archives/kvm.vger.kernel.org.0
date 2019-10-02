Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1405AC8F73
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfJBRKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:10:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:45210 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfJBRKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:10:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 10:10:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="191001391"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 02 Oct 2019 10:10:06 -0700
Date:   Wed, 2 Oct 2019 10:10:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 1/4] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
Message-ID: <20191002171006.GB9615@linux.intel.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-2-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569847479-13201-2-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 08:44:36PM +0800, Zhenzhong Duan wrote:
> There are cases where a guest tries to switch spinlocks to bare metal
> behavior (e.g. by setting "xen_nopvspin" on XEN platform and
> "hv_nopvspin" on HYPER_V).
> 
> That feature is missed on KVM, add a new parameter "nopvspin" to disable
> PV spinlocks for KVM guest.
> 
> This new parameter is also used to replace "xen_nopvspin" and
> "hv_nopvspin".

This is confusing as there are no Xen or Hyper-V changes in this patch.
Please make it clear that you're talking about future patches, e.g.:

  The new 'nopvspin' parameter will also replace Xen and Hyper-V specific
  parameters in future patches.

> 
> The global variable pvspin isn't defined as __initdata as it's used at
> runtime by XEN guest.

Same comment as above regarding what this patch is doing versus what will
be done in the future.  Arguably you should even mark it __initdata in
this patch and deal with conflict in the Xen patch, e.g. use it only to
set the existing xen_pvspin variable.

> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
>  arch/x86/include/asm/qspinlock.h                | 1 +
>  arch/x86/kernel/kvm.c                           | 7 +++++++
>  kernel/locking/qspinlock.c                      | 7 +++++++
>  4 files changed, 19 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index c7ac2f3..4b956d8 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5330,6 +5330,10 @@
>  			as generic guest with no PV drivers. Currently support
>  			XEN HVM, KVM, HYPER_V and VMWARE guest.
>  
> +	nopvspin	[X86,KVM] Disables the qspinlock slow path
> +			using PV optimizations which allow the hypervisor to
> +			'idle' the guest on lock contention.
> +
>  	xirc2ps_cs=	[NET,PCMCIA]
>  			Format:
>  			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
> diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
> index 444d6fd..34a4484 100644
> --- a/arch/x86/include/asm/qspinlock.h
> +++ b/arch/x86/include/asm/qspinlock.h
> @@ -32,6 +32,7 @@ static __always_inline u32 queued_fetch_set_pending_acquire(struct qspinlock *lo
>  extern void __pv_init_lock_hash(void);
>  extern void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
>  extern void __raw_callee_save___pv_queued_spin_unlock(struct qspinlock *lock);
> +extern bool pvspin;
>  
>  #define	queued_spin_unlock queued_spin_unlock
>  /**
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index e820568..a4f108d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -842,6 +842,13 @@ void __init kvm_spinlock_init(void)
>  	if (num_possible_cpus() == 1)
>  		return;
>  
> +	if (!pvspin) {
> +		pr_info("PV spinlocks disabled\n");
> +		static_branch_disable(&virt_spin_lock_key);
> +		return;
> +	}
> +	pr_info("PV spinlocks enabled\n");

These prints could be confusing as KVM also disables PV spinlocks when it
sees KVM_HINTS_REALTIME.

> +
>  	__pv_init_lock_hash();
>  	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
>  	pv_ops.lock.queued_spin_unlock =
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index 2473f10..945b510 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -580,4 +580,11 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>  #include "qspinlock_paravirt.h"
>  #include "qspinlock.c"
>  
> +bool pvspin = true;

This can be __ro_after_init, or probably better __initdata and have Xen
snapshot the value for its use case.

Personal preference: I'd invert the bool and name it nopvspin to make it
easier to connect the variable to the kernel param.

> +static __init int parse_nopvspin(char *arg)
> +{
> +	pvspin = false;
> +	return 0;
> +}
> +early_param("nopvspin", parse_nopvspin);
>  #endif
> -- 
> 1.8.3.1
> 
