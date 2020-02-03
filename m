Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7927215120C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 22:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgBCVp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 16:45:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:39531 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgBCVp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 16:45:26 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 13:45:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="254203850"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 03 Feb 2020 13:45:24 -0800
Date:   Mon, 3 Feb 2020 13:45:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 1/6] x86/split_lock: Add and export
 get_split_lock_detect_state()
Message-ID: <20200203214524.GJ19638@linux.intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203151608.28053-2-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 11:16:03PM +0800, Xiaoyao Li wrote:
> get_split_lock_detect_state() will be used by KVM module to get sld_state.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/cpu.h  | 12 ++++++++++++
>  arch/x86/kernel/cpu/intel.c | 12 ++++++------
>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index ff6f3ca649b3..167d0539e0ad 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -40,11 +40,23 @@ int mwait_usable(const struct cpuinfo_x86 *);
>  unsigned int x86_family(unsigned int sig);
>  unsigned int x86_model(unsigned int sig);
>  unsigned int x86_stepping(unsigned int sig);
> +
> +enum split_lock_detect_state {
> +	sld_off = 0,
> +	sld_warn,
> +	sld_fatal,
> +};
> +
>  #ifdef CONFIG_CPU_SUP_INTEL
> +extern enum split_lock_detect_state get_split_lock_detect_state(void);
>  extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
>  extern void switch_to_sld(unsigned long tifn);
>  extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
>  #else
> +static inline enum split_lock_detect_state get_split_lock_detect_state(void)
> +{
> +	return sld_off;
> +}
>  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
>  static inline void switch_to_sld(unsigned long tifn) {}
>  static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index db3e745e5d47..a810cd022db5 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -33,12 +33,6 @@
>  #include <asm/apic.h>
>  #endif
>  
> -enum split_lock_detect_state {
> -	sld_off = 0,
> -	sld_warn,
> -	sld_fatal,
> -};
> -
>  /*
>   * Default to sld_off because most systems do not support split lock detection
>   * split_lock_setup() will switch this to sld_warn on systems that support
> @@ -968,6 +962,12 @@ cpu_dev_register(intel_cpu_dev);
>  #undef pr_fmt
>  #define pr_fmt(fmt) "x86/split lock detection: " fmt
>  
> +enum split_lock_detect_state get_split_lock_detect_state(void)
> +{
> +	return sld_state;
> +}
> +EXPORT_SYMBOL_GPL(get_split_lock_detect_state);

I'm pretty sure KVM doesn't need to differentiate between warn and fatal if
its #AC interceptor is routed through handle_user_split_lock().  I.e. this
can return a boolean without exporting the enum.

bool is_split_lock_detect_enabled(void)
{
	return sld_state != sld_off;
}

> +
>  static const struct {
>  	const char			*option;
>  	enum split_lock_detect_state	state;
> -- 
> 2.23.0
> 
