Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA351B611B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgDWQjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 12:39:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:51293 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgDWQjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 12:39:49 -0400
IronPort-SDR: homFFEGGG4utyNlcGxcrHDBREt3vAhqeGUjVpe4go6ljd27h5WGLNvdLAus3YGuaF/FS8ajEFN
 EpiNfKxxMR7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 09:39:49 -0700
IronPort-SDR: boS1UWXK/pG63LvSnmxRtSBoGCn3Bs55q91PEJzZeMSGS0vdOyGeKt9j4Ex/PQAp4u5rxzpe/7
 df5nRD/YyltA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="256043220"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 09:39:49 -0700
Date:   Thu, 23 Apr 2020 09:39:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 1/9] KVM: VMX: Introduce CET VMX fields and flags
Message-ID: <20200423163948.GA25564@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-2-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:38PM +0800, Yang Weijiang wrote:
> If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored
> from below VMCS fields at VM-Exit:
>   HOST_S_CET
>   HOST_SSP
>   HOST_INTR_SSP_TABLE
> 
> If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded
> from below VMCS fields at VM-Entry:
>   GUEST_S_CET
>   GUEST_SSP
>   GUEST_INTR_SSP_TABLE
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---

...

> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 5e090d1f03f8..e938bc6c37aa 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -94,6 +94,7 @@
>  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>  #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>  #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_LOAD_HOST_CET_STATE             0x10000000
>  
>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>  
> @@ -107,6 +108,7 @@
>  #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>  #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>  #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> +#define VM_ENTRY_LOAD_GUEST_CET_STATE           0x00100000

I think it probably make senses to drop HOST/GUEST from the controls,
i.e. VM_{ENTER,EXIT}_LOAD_CET_STATE.  The SDM doesn't qualify them with
guest vs. host, nor does KVM qualify any of the other entry/exit controls
that are effective guest vs. host.
