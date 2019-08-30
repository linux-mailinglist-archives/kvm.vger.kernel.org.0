Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217CEA2C11
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfH3BIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:08:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:29749 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbfH3BIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:08:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 18:08:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="186148955"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 29 Aug 2019 18:08:40 -0700
Date:   Thu, 29 Aug 2019 18:08:40 -0700
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
Subject: Re: [PATCH v3 2/2] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Message-ID: <20190830010840.GD27970@linux.intel.com>
References: <1567066988-23376-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1567066988-23376-3-git-send-email-jan.dakinevich@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567066988-23376-3-git-send-email-jan.dakinevich@virtuozzo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 08:23:20AM +0000, Jan Dakinevich wrote:
> x86_emulate_instruction() takes into account ctxt->have_exception flag
> during instruction decoding, but in practice this flag is never set in
> x86_decode_insn().
> 
> Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
> Cc: Denis Lunev <den@virtuozzo.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>

Same nits as last patch:

  Cc: <stable@vger.kernel.org>
  Fixes: 6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")

Reviewed-and-tested-by: Sean Christopherson <sean.j.christopherson@intel.com>


> ---
>  arch/x86/kvm/emulate.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index bef3c3c..698efb8 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5416,6 +5416,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  					ctxt->memopp->addr.mem.ea + ctxt->_eip);
>  
>  done:
> +	if (rc == X86EMUL_PROPAGATE_FAULT)
> +		ctxt->have_exception = true;
>  	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
>  }
>  
> -- 
> 2.1.4
> 
