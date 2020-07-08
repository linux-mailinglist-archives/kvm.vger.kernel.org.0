Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C193521800B
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgGHG6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:58:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:46706 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgGHG6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:58:32 -0400
IronPort-SDR: xHKvobqF0ZAeaxotMCfGu+6tIbZGrWCcROp9OPk7mI/l5HEP3oO8xLA6gcm4/dgYbugqWg3+DJ
 9WWiDJwNt7dQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135212687"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="135212687"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:58:32 -0700
IronPort-SDR: luJRpwLAwneuwT559bxQM/zRdHTBf/LN8vSxPKTeitFEwbaQsn4bDDMFnhvdIG7alD1mBaQ8+U
 PUgdcmCP+Axw==
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="314556583"
Received: from unknown (HELO [10.239.13.102]) ([10.239.13.102])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:58:26 -0700
Subject: Re: [PATCH v2] x86/speculation/l1tf: Add KConfig for setting the L1D
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
References: <20200702213807.2511503-1-abhishekbh@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <2dd61d8b-223b-5a61-b739-392e79f1ce92@intel.com>
Date:   Wed, 8 Jul 2020 14:58:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702213807.2511503-1-abhishekbh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/2020 5:38 AM, Abhishek Bhardwaj wrote:
> This change adds a new kernel configuration that sets the l1d cache
> flush setting at compile time rather than at run time.
> 
> Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>
> 
> ---
> 
> Changes in v2:
> - Fix typo in the help of the new KConfig.
> 
>   arch/x86/kernel/cpu/bugs.c |  8 ++++++++
>   arch/x86/kvm/Kconfig       | 17 +++++++++++++++++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0b71970d2d3d2..1dcc875cf5547 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1406,7 +1406,15 @@ enum l1tf_mitigations l1tf_mitigation __ro_after_init = L1TF_MITIGATION_FLUSH;
>   #if IS_ENABLED(CONFIG_KVM_INTEL)
>   EXPORT_SYMBOL_GPL(l1tf_mitigation);
>   #endif
> +#if (CONFIG_KVM_VMENTRY_L1D_FLUSH == 1)
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NEVER;
> +#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 2)
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_COND;
> +#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 3)
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_ALWAYS;
> +#else
>   enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
> +#endif

how about

enum vmx_l1d_flush_state l1tf_vmx_mitigation =
#if (CONFIG_KVM_VMENTRY_L1D_FLUSH == 1)
	VMENTER_L1D_FLUSH_NEVER;
#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 2)
	VMENTER_L1D_FLUSH_COND;
#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 3)
	VMENTER_L1D_FLUSH_ALWAYS;
#else
	VMENTER_L1D_FLUSH_AUTO;
#endif


