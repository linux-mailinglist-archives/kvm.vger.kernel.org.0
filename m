Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521D49EB98
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 16:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfH0OyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 10:54:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:21708 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfH0Ox7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 10:53:59 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 07:53:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="380943529"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 27 Aug 2019 07:53:58 -0700
Date:   Tue, 27 Aug 2019 07:53:58 -0700
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
Subject: Re: [PATCH 2/3] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Message-ID: <20190827145358.GD27459@linux.intel.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1566911210-30059-3-git-send-email-jan.dakinevich@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566911210-30059-3-git-send-email-jan.dakinevich@virtuozzo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 01:07:08PM +0000, Jan Dakinevich wrote:
> x86_emulate_instruction() takes into account ctxt->have_exception flag
> during instruction decoding, but in practice this flag is never set in
> x86_decode_insn().
> 
> Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
> Cc: Denis Lunev <den@virtuozzo.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  arch/x86/kvm/emulate.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 6170ddf..f93880f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5395,6 +5395,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  					ctxt->memopp->addr.mem.ea + ctxt->_eip);
>  
>  done:
> +	if (rc == X86EMUL_PROPAGATE_FAULT)
> +		ctxt->have_exception = true;

We should add a sanity check or two on the vector since the emulator code
goes all over the place, e.g. #UD should not be injected/propagated, and
trap-like exceptions should not be handled/encountered during decode.
Note, exception_type() also warns on illegal vectors.

  WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
	       exception_type(ctxt->exception.vector) == EXCPT_TRAP);

>  	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
>  }
>  
> -- 
> 2.1.4
> 
