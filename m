Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2886C17829F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgCCSz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:55:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:29401 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCCSz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:55:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 10:55:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="438840209"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 03 Mar 2020 10:55:24 -0800
Date:   Tue, 3 Mar 2020 10:55:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] x86/split_lock: Ensure
 X86_FEATURE_SPLIT_LOCK_DETECT means the existence of feature
Message-ID: <20200303185524.GQ1439@linux.intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206070412.17400-3-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 03:04:06PM +0800, Xiaoyao Li wrote:
> When flag X86_FEATURE_SPLIT_LOCK_DETECT is set, it should ensure the
> existence of MSR_TEST_CTRL and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit.

The changelog confused me a bit.  "When flag X86_FEATURE_SPLIT_LOCK_DETECT
is set" makes it sound like the logic is being applied after the feature
bit is set.  Maybe something like:

```
Verify MSR_TEST_CTRL.SPLIT_LOCK_DETECT can be toggled via WRMSR prior to
setting the SPLIT_LOCK_DETECT feature bit so that runtime consumers,
e.g. KVM, don't need to worry about WRMSR failure.
```

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 41 +++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 2b3874a96bd4..49535ed81c22 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -702,7 +702,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
>  		tsx_disable();
>  
> -	split_lock_init();
> +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> +		split_lock_init();
>  }
>  
>  #ifdef CONFIG_X86_32
> @@ -986,9 +987,26 @@ static inline bool match_option(const char *arg, int arglen, const char *opt)
>  
>  static void __init split_lock_setup(void)
>  {
> +	u64 test_ctrl_val;
>  	char arg[20];
>  	int i, ret;
> +	/*
> +	 * Use the "safe" versions of rdmsr/wrmsr here to ensure MSR_TEST_CTRL
> +	 * and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit do exist. Because there may
> +	 * be glitches in virtualization that leave a guest with an incorrect
> +	 * view of real h/w capabilities.
> +	 */
> +	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
> +		return;
> +
> +	if (wrmsrl_safe(MSR_TEST_CTRL,
> +			test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
> +		return;
> +
> +	if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val))
> +		return;a

Probing the MSR should be skipped if SLD is disabled in sld_options, i.e.
move this code (and setup_force_cpu_cap() etc...) down below the
match_option() logic.  The above would temporarily enable SLD even if the
admin has explicitly disabled it, e.g. makes the kernel param useless for
turning off the feature due to bugs.

And with that, IMO failing any of RDMSR/WRSMR here warrants a pr_err().
The CPU says it supports split lock and the admin hasn't explicitly turned
it off, so failure to enable should be logged.

> +
>  	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
>  	sld_state = sld_warn;
>  
> @@ -1022,24 +1040,19 @@ static void __init split_lock_setup(void)
>   * Locking is not required at the moment because only bit 29 of this
>   * MSR is implemented and locking would not prevent that the operation
>   * of one thread is immediately undone by the sibling thread.
> - * Use the "safe" versions of rdmsr/wrmsr here because although code
> - * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
> - * exist, there may be glitches in virtualization that leave a guest
> - * with an incorrect view of real h/w capabilities.
>   */
> -static bool __sld_msr_set(bool on)
> +static void __sld_msr_set(bool on)
>  {
>  	u64 test_ctrl_val;
>  
> -	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
> -		return false;
> +	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
>  
>  	if (on)
>  		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>  	else
>  		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>  
> -	return !wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val);
> +	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
>  }
>  
>  static void split_lock_init(void)
> @@ -1047,15 +1060,7 @@ static void split_lock_init(void)
>  	if (sld_state == sld_off)
>  		return;
>  
> -	if (__sld_msr_set(true))
> -		return;
> -
> -	/*
> -	 * If this is anything other than the boot-cpu, you've done
> -	 * funny things and you get to keep whatever pieces.
> -	 */
> -	pr_warn("MSR fail -- disabled\n");
> -	sld_state = sld_off;
> +	__sld_msr_set(true);
>  }
>  
>  bool handle_user_split_lock(unsigned long ip)
> -- 
> 2.23.0
> 
