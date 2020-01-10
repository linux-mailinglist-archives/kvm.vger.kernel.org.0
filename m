Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235D21375DF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 19:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgAJSKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 13:10:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:2311 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgAJSKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 13:10:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 10:10:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="423676880"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jan 2020 10:10:52 -0800
Date:   Fri, 10 Jan 2020 10:10:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 05/10] x86: spp: Introduce user-space SPP
 IOCTLs
Message-ID: <20200110181053.GH21485@linux.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-6-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102061319.10077-6-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 02, 2020 at 02:13:14PM +0800, Yang Weijiang wrote:
> User application, e.g., QEMU or VMI, must initialize SPP
> before gets/sets SPP subpages, the dynamic initialization is to
> reduce the extra storage cost if the SPP feature is not not used.
> 
> Co-developed-by: He Chen <he.chen@linux.intel.com>
> Signed-off-by: He Chen <he.chen@linux.intel.com>
> Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++
>  arch/x86/kvm/mmu/spp.c          | 44 +++++++++++++++
>  arch/x86/kvm/mmu/spp.h          |  9 ++++
>  arch/x86/kvm/vmx/vmx.c          | 15 ++++++
>  arch/x86/kvm/x86.c              | 95 ++++++++++++++++++++++++++++++++-
>  include/uapi/linux/kvm.h        |  3 ++
>  6 files changed, 169 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f5145b86d620..c7a9f03f39a7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1238,6 +1238,10 @@ struct kvm_x86_ops {
>  
>  	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +
> +	int (*init_spp)(struct kvm *kvm);
> +	int (*flush_subpages)(struct kvm *kvm, u64 gfn, u32 npages);
> +	int (*get_inst_len)(struct kvm_vcpu *vcpu);

If this is necessary, which hopefully it isn't, then get_insn_len() to be
consistent with other KVM nomenclature.

A comment for the series overall, it needs a lot of work to properly order
code between patches.  E.g. this patch introduces get_inst_len() without
any justification in the changelog and without a user.  At best it's
confusing, at worst this series will be impossible to bisect.
