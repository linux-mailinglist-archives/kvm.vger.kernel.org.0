Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940EC9E9B4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfH0NmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:42:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:18721 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfH0NmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:42:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 06:42:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="171199517"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 06:42:02 -0700
Date:   Tue, 27 Aug 2019 06:42:02 -0700
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
Subject: Re: [PATCH 1/3] KVM: x86: fix wrong return code
Message-ID: <20190827134202.GB27459@linux.intel.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1566911210-30059-2-git-send-email-jan.dakinevich@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566911210-30059-2-git-send-email-jan.dakinevich@virtuozzo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 01:07:04PM +0000, Jan Dakinevich wrote:
> x86_emulate_instruction(), the caller of x86_decode_insn(), expects
> that x86_decode_insn()'s returning value belongs to EMULATION_* name
> space. However, this function may return value from X86EMUL_* name
> space.
> 
> Although, the code behaves properly (because both X86EMUL_CONTINUE and
> EMULATION_OK are equal to 0) this change makes code more consistent and
> it is required for further fixes.
> 
> Cc: Denis Lunev <den@virtuozzo.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 718f7d9..6170ddf 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5144,7 +5144,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  	else {
>  		rc = __do_insn_fetch_bytes(ctxt, 1);
>  		if (rc != X86EMUL_CONTINUE)
> -			return rc;
> +			goto done;

Funny how things go unnoticed for years and then suddenly...

https://lkml.kernel.org/r/9bf79098-703c-e82b-7e7d-1c0a6a1023c2@redhat.com

>  	}
>  
>  	switch (mode) {
> -- 
> 2.1.4
> 
