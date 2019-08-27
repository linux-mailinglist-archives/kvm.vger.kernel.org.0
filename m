Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EE09EB83
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 16:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbfH0Ouc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 10:50:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:26254 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfH0Ouc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 10:50:32 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 07:50:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="171219686"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 07:50:30 -0700
Date:   Tue, 27 Aug 2019 07:50:30 -0700
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
Subject: Re: [PATCH 3/3] KVM: x86: always stop emulation on page fault
Message-ID: <20190827145030.GC27459@linux.intel.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1566911210-30059-4-git-send-email-jan.dakinevich@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566911210-30059-4-git-send-email-jan.dakinevich@virtuozzo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Cc Peng Hao and Yi Wang

On Tue, Aug 27, 2019 at 01:07:09PM +0000, Jan Dakinevich wrote:
> inject_emulated_exception() returns true if and only if nested page
> fault happens. However, page fault can come from guest page tables
> walk, either nested or not nested. In both cases we should stop an
> attempt to read under RIP and give guest to step over its own page
> fault handler.
> 
> Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
> Cc: Denis Lunev <den@virtuozzo.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  arch/x86/kvm/x86.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93b0bd4..45caa69 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6521,8 +6521,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
>  						emulation_type))
>  				return EMULATE_DONE;
> -			if (ctxt->have_exception && inject_emulated_exception(vcpu))
> +			if (ctxt->have_exception) {
> +				inject_emulated_exception(vcpu);
>  				return EMULATE_DONE;
> +			}


Yikes, this patch and the previous have quite the sordid history.


The non-void return from inject_emulated_exception() was added by commit

  ef54bcfeea6c ("KVM: x86: skip writeback on injection of nested exception")

for the purpose of skipping writeback.  At the time, the above blob in the
decode flow didn't exist.


Decode exception handling was added by commit

  6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")

but it was dead code even then.  The patch discussion[1] even point out that
it was dead code, i.e. the change probably should have been reverted.


Peng Hao and Yi Wang later ran into what appears to be the same bug you're
hitting[2][3], and even had patches temporarily queued[4][5], but the
patches never made it to mainline as they broke kvm-unit-tests.  Fun side
note, Radim even pointed out[4] the bug fixed by patch 1/3.

So, the patches look correct, but there's the open question of why the
hypercall test was failing for Paolo.  I've tried to reproduce the #DF to
no avail.

[1] https://lore.kernel.org/patchwork/patch/850077/
[2] https://lkml.kernel.org/r/1537311828-4547-1-git-send-email-penghao122@sina.com.cn
[3] https://lkml.kernel.org/r/20190111133002.GA14852@flask
[4] https://lkml.kernel.org/r/20190111133002.GA14852@flask
[5] https://lkml.kernel.org/r/9835d255-dd9a-222b-f4a2-93611175b326@redhat.com

>  			if (emulation_type & EMULTYPE_SKIP)
>  				return EMULATE_FAIL;
>  			return handle_emulation_failure(vcpu, emulation_type);
> -- 
> 2.1.4
> 
