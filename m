Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FDF215A30
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 17:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgGFPBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 11:01:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:1771 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgGFPBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 11:01:48 -0400
IronPort-SDR: gdygv/P6C2GNO3sjtMQuOnODrauRvPzyFNlU4WnIsdHsNOnwUPxPiEEOL7xO/YFRybAtHwzMqk
 bMyP+3XNg5xA==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="146504673"
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="146504673"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 08:01:47 -0700
IronPort-SDR: C8I4Rf7q1jd2VoYzmkyAUPZEW/3Zv9xkokghzFMebXW85QNKgh2gMe+j02eX4umH5PRW8lFkgD
 R/gQwJYiroAQ==
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="315191035"
Received: from smtp.ostc.intel.com ([10.54.29.231])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 08:01:46 -0700
Received: from localhost (mtg-dev.jf.intel.com [10.54.74.10])
        by smtp.ostc.intel.com (Postfix) with ESMTP id 5832C637E;
        Mon,  6 Jul 2020 08:01:46 -0700 (PDT)
Date:   Mon, 6 Jul 2020 08:01:46 -0700
From:   mark gross <mgross@linux.intel.com>
To:     Abhishek Bhardwaj <abhishekbh@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
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
Subject: Re: [PATCH] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
Message-ID: <20200706150146.GA21121@mtg-dev.jf.intel.com>
Reply-To: mgross@linux.intel.com
References: <20200702161916.2456342-1-abhishekbh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702161916.2456342-1-abhishekbh@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 09:19:16AM -0700, Abhishek Bhardwaj wrote:
> This change adds a new kernel configuration that sets the l1d cache
> flush setting at compile time rather than at run time.

Why is this desired?

--mark

> 
> Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>
> ---
> 
>  arch/x86/kernel/cpu/bugs.c |  8 ++++++++
>  arch/x86/kvm/Kconfig       | 17 +++++++++++++++++
>  2 files changed, 25 insertions(+)
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
> index b277a2db62676..f82a0c564e931 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -107,4 +107,21 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +config KVM_VMENTRY_L1D_FLUSH
> +	int "L1D cache flush settings (1-3)"
> +	range 1 3
> +	default "2"
> +	depends on KVM && X86 && X86_64
> +	help
> +	 This setting determines the L1D cache flush behavior before a VMENTER.
> +	 This is similar to setting the option / parameter to
> +	 kvm-intel.vmentry_l1d_flush.
> +	 1 - Never flush.
> +	 2 - Conditinally flush.
> +	 3 - Always flush.
> +
> +# OK, it's a little counter-intuitive to do this, but it puts it neatly under
> +# the virtualization menu.
> +source "drivers/vhost/Kconfig"
> +
>  endif # VIRTUALIZATION
> -- 
> 2.27.0.212.ge8ba1cc988-goog
> 
