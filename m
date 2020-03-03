Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950911782AF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgCCS7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:59:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:53031 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbgCCS7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:59:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 10:59:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="233734546"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2020 10:59:11 -0800
Date:   Tue, 3 Mar 2020 10:59:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/8] x86/split_lock: Add and export
 split_lock_detect_enabled() and split_lock_detect_fatal()
Message-ID: <20200303185911.GR1439@linux.intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-5-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206070412.17400-5-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 03:04:08PM +0800, Xiaoyao Li wrote:
> These two functions will be used by KVM to check whether host's
> sld_state.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/cpu.h  |  4 ++++
>  arch/x86/kernel/cpu/intel.c | 12 ++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 2b20829db450..f5172dbd3f01 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -46,6 +46,8 @@ unsigned int x86_stepping(unsigned int sig);
>  extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
>  extern void switch_to_sld(unsigned long tifn);
>  extern bool handle_user_split_lock(unsigned long ip);
> +extern bool split_lock_detect_enabled(void);
> +extern bool split_lock_detect_fatal(void);
>  #else
>  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
>  static inline void switch_to_sld(unsigned long tifn) {}
> @@ -53,5 +55,7 @@ static inline bool handle_user_split_lock(unsigned long ip)
>  {
>  	return false;
>  }
> +static inline bool split_lock_detect_enabled(void) { return false; }
> +static inline bool split_lock_detect_fatal(void) { return false; }
>  #endif
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index ff27d026cb4a..b67b46ea66df 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -1131,3 +1131,15 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
>  	if (ia32_core_caps & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
>  		split_lock_setup();
>  }
> +
> +bool split_lock_detect_enabled(void)
> +{
> +	return sld_state != sld_off;
> +}
> +EXPORT_SYMBOL_GPL(split_lock_detect_enabled);

Hmm, ideally this would be static inline.  Patch 8 (to expose SLD to the
guest) queries this in vmx_vcpu_run(), I'd prefer to avoid the extra
CALL+RET in that path.

> +bool split_lock_detect_fatal(void)
> +{
> +	return sld_state == sld_fatal;
> +}
> +EXPORT_SYMBOL_GPL(split_lock_detect_fatal);

split_lock_detect_fatal() isn't used in this series, it shouldn't be added.

> -- 
> 2.23.0
> 
