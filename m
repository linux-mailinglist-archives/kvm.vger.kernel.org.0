Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE7BC8F94
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfJBRSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:18:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:52665 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfJBRSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:18:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 10:18:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="275417382"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 02 Oct 2019 10:18:05 -0700
Date:   Wed, 2 Oct 2019 10:18:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 3/4] xen: Mark "xen_nopvspin" parameter obsolete and
 map it to "nopvspin"
Message-ID: <20191002171805.GD9615@linux.intel.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-4-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569847479-13201-4-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 08:44:38PM +0800, Zhenzhong Duan wrote:
> Fix stale description of "xen_nopvspin" as we use qspinlock now.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  7 ++++---
>  arch/x86/xen/spinlock.c                         | 13 +++++++------
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 4b956d8..1f0a62f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5303,8 +5303,9 @@
>  			never -- do not unplug even if version check succeeds
>  
>  	xen_nopvspin	[X86,XEN]
> -			Disables the ticketlock slowpath using Xen PV
> -			optimizations.
> +			Disables the qspinlock slowpath using Xen PV optimizations.
> +			This parameter is obsoleted by "nopvspin" parameter, which
> +			has equivalent effect for XEN platform.
>  
>  	xen_nopv	[X86]
>  			Disables the PV optimizations forcing the HVM guest to
> @@ -5330,7 +5331,7 @@
>  			as generic guest with no PV drivers. Currently support
>  			XEN HVM, KVM, HYPER_V and VMWARE guest.
>  
> -	nopvspin	[X86,KVM] Disables the qspinlock slow path
> +	nopvspin	[X86,XEN,KVM] Disables the qspinlock slow path
>  			using PV optimizations which allow the hypervisor to
>  			'idle' the guest on lock contention.
>  
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 6deb490..092a53f 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -18,7 +18,6 @@
>  static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
>  static DEFINE_PER_CPU(char *, irq_name);
>  static DEFINE_PER_CPU(atomic_t, xen_qlock_wait_nest);
> -static bool xen_pvspin = true;
>  
>  static void xen_qlock_kick(int cpu)
>  {
> @@ -68,7 +67,7 @@ void xen_init_lock_cpu(int cpu)
>  	int irq;
>  	char *name;
>  
> -	if (!xen_pvspin)
> +	if (!pvspin)
>  		return;
>  
>  	WARN(per_cpu(lock_kicker_irq, cpu) >= 0, "spinlock on CPU%d exists on IRQ%d!\n",
> @@ -93,7 +92,7 @@ void xen_init_lock_cpu(int cpu)
>  
>  void xen_uninit_lock_cpu(int cpu)
>  {
> -	if (!xen_pvspin)
> +	if (!pvspin)
>  		return;
>  
>  	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
> @@ -117,9 +116,9 @@ void __init xen_init_spinlocks(void)
>  
>  	/*  Don't need to use pvqspinlock code if there is only 1 vCPU. */
>  	if (num_possible_cpus() == 1)
> -		xen_pvspin = false;
> +		pvspin = false;

As suggested in the other patch, if you incorporate pvspin (or nopvspin)
into xen_pvspin then the param can be __initdata and the diff for this
patch will be smaller, e.g. you wouldn't need the xen_domain() shenanigans
in xen_parse_nopvspin().

> -	if (!xen_pvspin) {
> +	if (!pvspin) {
>  		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
>  		static_branch_disable(&virt_spin_lock_key);
>  		return;
> @@ -137,7 +136,9 @@ void __init xen_init_spinlocks(void)
>  
>  static __init int xen_parse_nopvspin(char *arg)
>  {
> -	xen_pvspin = false;
> +	pr_notice("\"xen_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
> +	if (xen_domain())
> +		pvspin = false;
>  	return 0;
>  }
>  early_param("xen_nopvspin", xen_parse_nopvspin);
> -- 
> 1.8.3.1
> 
