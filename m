Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB1AA2C0B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfH3BGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:06:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:39895 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfH3BGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:06:17 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 18:06:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="381844739"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 29 Aug 2019 18:06:15 -0700
Date:   Thu, 29 Aug 2019 18:06:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] KVM: x86: always stop emulation on page fault
Message-ID: <20190830010615.GC27970@linux.intel.com>
References: <1567066988-23376-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1567066988-23376-2-git-send-email-jan.dakinevich@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567066988-23376-2-git-send-email-jan.dakinevich@virtuozzo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 08:23:18AM +0000, Jan Dakinevich wrote:
> inject_emulated_exception() returns true if and only if nested page
> fault happens. However, page fault can come from guest page tables
> walk, either nested or not nested. In both cases we should stop an
> attempt to read under RIP and give guest to step over its own page
> fault handler.
> 
> Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")

Commit ids should be at least 12 chars, the full tag should be

  Fixes: 6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")

You can force this in your git config, e.g.

  git config --global core.abbrev 12

Both patches in this series should probably have

  Cc: <stable@vger.kernel.org>


Reviewed-and-tested-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Cc: Denis Lunev <den@virtuozzo.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd78..6bf7b55 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6537,8 +6537,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
>  						emulation_type))
>  				return EMULATE_DONE;
> -			if (ctxt->have_exception && inject_emulated_exception(vcpu))
> +			if (ctxt->have_exception) {
> +				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR);
> +				WARN_ON_ONCE(exception_type(ctxt->exception.vector)
> +					== EXCPT_TRAP);
> +				inject_emulated_exception(vcpu);
>  				return EMULATE_DONE;
> +			}
>  			if (emulation_type & EMULTYPE_SKIP)
>  				return EMULATE_FAIL;
>  			return handle_emulation_failure(vcpu, emulation_type);
> -- 
> 2.1.4
> 
