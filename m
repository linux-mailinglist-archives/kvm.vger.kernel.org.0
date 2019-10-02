Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7128FC8FB2
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfJBRTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:19:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:27107 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbfJBRTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:19:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 10:19:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="196066711"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 02 Oct 2019 10:19:52 -0700
Date:   Wed, 2 Oct 2019 10:19:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 4/4] x86/hyperv: Mark "hv_nopvspin" parameter obsolete
 and map it to "nopvspin"
Message-ID: <20191002171952.GE9615@linux.intel.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-5-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569847479-13201-5-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 08:44:39PM +0800, Zhenzhong Duan wrote:
> Includes asm/hypervisor.h in order to reference x86_hyper_type.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 6 +++++-
>  arch/x86/hyperv/hv_spinlock.c                   | 9 +++++----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 1f0a62f..43f922c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1436,6 +1436,10 @@
>  	hv_nopvspin	[X86,HYPER_V] Disables the paravirt spinlock optimizations
>  				      which allow the hypervisor to 'idle' the
>  				      guest on lock contention.
> +				      This parameter is obsoleted by "nopvspin"
> +				      parameter, which has equivalent effect for
> +				      HYPER_V platform.
> +
>  
>  	keep_bootcon	[KNL]
>  			Do not unregister boot console at start. This is only
> @@ -5331,7 +5335,7 @@
>  			as generic guest with no PV drivers. Currently support
>  			XEN HVM, KVM, HYPER_V and VMWARE guest.
>  
> -	nopvspin	[X86,XEN,KVM] Disables the qspinlock slow path
> +	nopvspin	[X86,XEN,KVM,HYPER_V] Disables the qspinlock slow path
>  			using PV optimizations which allow the hypervisor to
>  			'idle' the guest on lock contention.
>  
> diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
> index 07f21a0..e00e319 100644
> --- a/arch/x86/hyperv/hv_spinlock.c
> +++ b/arch/x86/hyperv/hv_spinlock.c
> @@ -12,12 +12,11 @@
>  
>  #include <linux/spinlock.h>
>  
> +#include <asm/hypervisor.h>
>  #include <asm/mshyperv.h>
>  #include <asm/paravirt.h>
>  #include <asm/apic.h>
>  
> -static bool __initdata hv_pvspin = true;
> -
>  static void hv_qlock_kick(int cpu)
>  {
>  	apic->send_IPI(cpu, X86_PLATFORM_IPI_VECTOR);
> @@ -64,7 +63,7 @@ __visible bool hv_vcpu_is_preempted(int vcpu)
>  
>  void __init hv_init_spinlocks(void)
>  {
> -	if (!hv_pvspin || !apic ||
> +	if (!pvspin || !apic ||
>  	    !(ms_hyperv.hints & HV_X64_CLUSTER_IPI_RECOMMENDED) ||
>  	    !(ms_hyperv.features & HV_X64_MSR_GUEST_IDLE_AVAILABLE)) {
>  		pr_info("PV spinlocks disabled\n");
> @@ -82,7 +81,9 @@ void __init hv_init_spinlocks(void)
>  
>  static __init int hv_parse_nopvspin(char *arg)
>  {
> -	hv_pvspin = false;
> +	pr_notice("\"hv_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
> +	if (x86_hyper_type == X86_HYPER_MS_HYPERV)
> +		pvspin = false;

Personal preference would be to keep the hv_pvspin variable and add the
extra check in hv_init_spinlocks().

>  	return 0;
>  }
>  early_param("hv_nopvspin", hv_parse_nopvspin);
> -- 
> 1.8.3.1
> 
