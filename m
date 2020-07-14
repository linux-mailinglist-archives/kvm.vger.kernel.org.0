Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0AB21E552
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 03:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGNBpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 21:45:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:36251 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNBpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 21:45:43 -0400
IronPort-SDR: 49R/pTLZzk5GmOU5JlLXSxrw8vbIjrq/uQseHPNVDaANjzIvIToNuHeuw7AY8xIybi6u9cAyWk
 AKHFg6CYDO5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="233625380"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="233625380"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 18:45:42 -0700
IronPort-SDR: 8KiZszk0n6gHzyqnZmwij3sNxT5adP1q6i8wX4Jtq85W0WKHIFD7Q5NReP7Oo0nbZpBej0kByG
 hl4sCHAr9f7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="268520726"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2020 18:45:40 -0700
Date:   Mon, 13 Jul 2020 18:45:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        "Gomez Iglesias, Antonio" <antonio.gomez.iglesias@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mark Gross <mgross@linux.intel.com>,
        Waiman Long <longman@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] x86/bugs/multihit: Fix mitigation reporting when KVM is
 not in use
Message-ID: <20200714014540.GH29725@linux.intel.com>
References: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 06:18:54PM -0700, Pawan Gupta wrote:
> On systems that have virtualization disabled or KVM module is not
> loaded, sysfs mitigation state of X86_BUG_ITLB_MULTIHIT is reported
> incorrectly as:
> 
>   $ cat /sys/devices/system/cpu/vulnerabilities/itlb_multihit
>   KVM: Vulnerable
> 
> System is not vulnerable to DoS attack from a rogue guest when:
>  - KVM module is not loaded or
>  - Virtualization is disabled in the hardware or
>  - Kernel was configured without support for KVM
> 
> Change the reporting to "Currently not affected (KVM not in use)" for
> such cases.

This is all kinds of backwards.  Virtualization being disabled in hardware
is very, very different than KVM not being loaded.  One requires at the
very least a kernel reboot to change, the other does not.

And just because the kernel isn't configured for KVM doesn't mean VMX can't
be used, there are plenty of out-of-tree hypervisors that utilize VMX.

Ignoring the above issues, choosing KVM module load as the line in the sand
where the kernel suddenly becomes vulnerable is arbitrary.  Arguably, KVM
isn't vulnerable until it actually starts running a guest.

IMO, the sane/safe route would be to print e.g. "VMX not supported" when
VMX isn't supported or is disabled via FEAT_CTL.  And then if you want to
reflect current state, add another condition that checks hardware CR4.VMXE
and prints e.g. "VMX currently disabled".  The latter case still seems
somewhat dubious, but it's a lot better than keying off KVM being loaded.

> Reported-by: Nelson Dsouza <nelson.dsouza@linux.intel.com>
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../admin-guide/hw-vuln/multihit.rst          |  5 +++-
>  arch/x86/include/asm/processor.h              |  6 +++++
>  arch/x86/kernel/cpu/bugs.c                    | 24 +++++++++----------
>  arch/x86/kvm/mmu/mmu.c                        |  9 +++++--
>  4 files changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/admin-guide/hw-vuln/multihit.rst b/Documentation/admin-guide/hw-vuln/multihit.rst
> index ba9988d8bce5..842961419f3e 100644
> --- a/Documentation/admin-guide/hw-vuln/multihit.rst
> +++ b/Documentation/admin-guide/hw-vuln/multihit.rst
> @@ -82,7 +82,10 @@ The possible values in this file are:
>         - Software changes mitigate this issue.
>       * - KVM: Vulnerable
>         - The processor is vulnerable, but no mitigation enabled
> -
> +     * - Currently not affected (KVM not in use)
> +       - The processor is vulnerable but no mitigation is required because
> +         KVM module is not loaded or virtualization is disabled in the hardware or
> +         kernel was configured without support for KVM.
>  
>  Enumeration of the erratum
>  --------------------------------
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 03b7c4ca425a..830a3e7725af 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -989,4 +989,10 @@ enum mds_mitigations {
>  	MDS_MITIGATION_VMWERV,
>  };
>  
> +enum itlb_multihit_mitigations {
> +	ITLB_MULTIHIT_MITIGATION_OFF,
> +	ITLB_MULTIHIT_MITIGATION_FULL,
> +	ITLB_MULTIHIT_MITIGATION_NO_KVM,
> +};
> +
>  #endif /* _ASM_X86_PROCESSOR_H */
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0b71970d2d3d..97f66a93f2be 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1395,8 +1395,15 @@ void x86_spec_ctrl_setup_ap(void)
>  		x86_amd_ssb_disable();
>  }
>  
> -bool itlb_multihit_kvm_mitigation;
> -EXPORT_SYMBOL_GPL(itlb_multihit_kvm_mitigation);
> +/* Default to KVM not in use, KVM module changes this later */
> +enum itlb_multihit_mitigations itlb_multihit_mitigation = ITLB_MULTIHIT_MITIGATION_NO_KVM;
> +EXPORT_SYMBOL_GPL(itlb_multihit_mitigation);
> +
> +static const char * const itlb_multihit_strings[] = {
> +	[ITLB_MULTIHIT_MITIGATION_OFF]		= "KVM: Vulnerable",
> +	[ITLB_MULTIHIT_MITIGATION_FULL]		= "KVM: Mitigation: Split huge pages",
> +	[ITLB_MULTIHIT_MITIGATION_NO_KVM]	= "Currently not affected (KVM not in use)",
> +};
>  
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"L1TF: " fmt
> @@ -1553,25 +1560,18 @@ static ssize_t l1tf_show_state(char *buf)
>  		       l1tf_vmx_states[l1tf_vmx_mitigation],
>  		       sched_smt_active() ? "vulnerable" : "disabled");
>  }
> -
> -static ssize_t itlb_multihit_show_state(char *buf)
> -{
> -	if (itlb_multihit_kvm_mitigation)
> -		return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
> -	else
> -		return sprintf(buf, "KVM: Vulnerable\n");
> -}
>  #else
>  static ssize_t l1tf_show_state(char *buf)
>  {
>  	return sprintf(buf, "%s\n", L1TF_DEFAULT_MSG);
>  }
> +#endif
>  
>  static ssize_t itlb_multihit_show_state(char *buf)
>  {
> -	return sprintf(buf, "Processor vulnerable\n");
> +	return sprintf(buf, "%s\n",
> +		       itlb_multihit_strings[itlb_multihit_mitigation]);
>  }
> -#endif
>  
>  static ssize_t mds_show_state(char *buf)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d6a0ae7800c..e089b9e565a5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -50,7 +50,7 @@
>  #include <asm/kvm_page_track.h>
>  #include "trace.h"
>  
> -extern bool itlb_multihit_kvm_mitigation;
> +extern enum itlb_multihit_mitigations itlb_multihit_mitigation;
>  
>  static int __read_mostly nx_huge_pages = -1;
>  #ifdef CONFIG_PREEMPT_RT
> @@ -6158,7 +6158,12 @@ static bool get_nx_auto_mode(void)
>  
>  static void __set_nx_huge_pages(bool val)
>  {
> -	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
> +	nx_huge_pages = val;
> +
> +	if (val)
> +		itlb_multihit_mitigation = ITLB_MULTIHIT_MITIGATION_FULL;
> +	else
> +		itlb_multihit_mitigation = ITLB_MULTIHIT_MITIGATION_OFF;
>  }
>  
>  static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
> -- 
> 2.21.3
> 
