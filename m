Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E88212FF3
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 01:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGBXQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 19:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGBXQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 19:16:45 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A75BC08C5C1;
        Thu,  2 Jul 2020 16:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=B/JphhCu3M1hSIG0Qr2x65szj7uszGgbufi/R0O3CrU=; b=XrCbPgWByhnDZis4NQa7dSvZdl
        lbDiqQzKHZEzRZ1EbvVukQ6KwTc1zxwQuWbMf2UQOgs62dM4gUsHtqbzlwaM6Qm5YuuknDU8kYf27
        xoPkCGduZueR5k7lba2dPlyiIfJ3c7EybO1enmRfPmtodsQzeOj536JGpPRulet3xecEb/IaIAj3H
        x8exA5FiimEzjC8ABrQ8D5VXi7ByjNQ1obo/Z/drj7kGPNPSZwUdZBLM9XRczxutW5wi5aZQvNCHL
        YSZwpNy0RlIWs50f98fWXi3Fk58pecd/qOAkXRn3w1rVsq6cMzJj0UoR8mEUkWzo9re2R2hf/D2sJ
        hhFz8wPw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jr8RT-0005Hh-1p; Thu, 02 Jul 2020 23:16:31 +0000
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
References: <20200702221237.2517080-1-abhishekbh@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a0706cff-bd94-2f2e-2c78-0f5cd4705fc4@infradead.org>
Date:   Thu, 2 Jul 2020 16:16:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200702221237.2517080-1-abhishekbh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/2/20 3:12 PM, Abhishek Bhardwaj wrote:
> This change adds a new kernel configuration that sets the l1d cache
> flush setting at compile time rather than at run time.
> 
> Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>
> 
> ---
> 
> Changes in v3:
> - Change depends on to only x86_64.
> - Remove copy paste errors at the end of the KConfig.
> 
> Changes in v2:
> - Fix typo in the help of the new KConfig.
> 
>  arch/x86/kernel/cpu/bugs.c |  8 ++++++++
>  arch/x86/kvm/Kconfig       | 13 +++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0b71970d2d3d2..1dcc875cf5547 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1406,7 +1406,15 @@ enum l1tf_mitigations l1tf_mitigation __ro_after_init = L1TF_MITIGATION_FLUSH;
>  #if IS_ENABLED(CONFIG_KVM_INTEL)
>  EXPORT_SYMBOL_GPL(l1tf_mitigation);
>  #endif
> +#if (CONFIG_KVM_VMENTRY_L1D_FLUSH == 1)
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NEVER;
> +#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 2)
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_COND;
> +#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 3)
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_ALWAYS;
> +#else
>  enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
> +#endif
>  EXPORT_SYMBOL_GPL(l1tf_vmx_mitigation);
>  
>  /*
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index b277a2db62676..1f85374a0b812 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -107,4 +107,17 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +config KVM_VMENTRY_L1D_FLUSH
> +	int "L1D cache flush settings (1-3)"
> +	range 1 3
> +	default "2"
> +	depends on KVM && X86_64
> +	help
> +	 This setting determines the L1D cache flush behavior before a VMENTER.
> +	 This is similar to setting the option / parameter to
> +	 kvm-intel.vmentry_l1d_flush.
> +	 1 - Never flush.
> +	 2 - Conditionally flush.
> +	 3 - Always flush.

No hurry on this (wait for other comments), but help text
should be indented by one tab + 2 spaces, per Documentation/process/coding-style.rst:

  Lines under a ``config`` definition
  are indented with one tab, while help text is indented an additional two
  spaces.


> +
>  endif # VIRTUALIZATION
> 
-- 
~Randy

