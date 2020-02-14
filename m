Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF57A15E854
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 17:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394315AbgBNQ70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 11:59:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:48333 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392624AbgBNQ7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 11:59:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 08:59:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="407045395"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 14 Feb 2020 08:59:24 -0800
Date:   Fri, 14 Feb 2020 08:59:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Qian Cai <cai@lca.pw>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
Message-ID: <20200214165923.GA20690@linux.intel.com>
References: <1581695768-6123-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581695768-6123-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 10:56:08AM -0500, Qian Cai wrote:
> arch/x86/kvm/emulate.c: In function 'x86_emulate_insn':
> arch/x86/kvm/emulate.c:5686:22: error: cast between incompatible
> function types from 'int (*)(struct x86_emulate_ctxt *)' to 'void
> (*)(struct fastop *)' [-Werror=cast-function-type]
>     rc = fastop(ctxt, (fastop_t)ctxt->execute);
> 
> Fixes: 3009afc6e39e ("KVM: x86: Use a typedef for fastop functions")
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  arch/x86/kvm/emulate.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index ddbc61984227..17ae820cf59d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5682,10 +5682,12 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  		ctxt->eflags &= ~X86_EFLAGS_RF;
>  
>  	if (ctxt->execute) {
> -		if (ctxt->d & Fastop)
> -			rc = fastop(ctxt, (fastop_t)ctxt->execute);

Alternatively, can we do -Wno-cast-function-type?  That's a silly warning
IMO.

If not, will either of these work?

			rc = fastop(ctxt, (void *)ctxt->execute);

or
			rc = fastop(ctxt, (fastop_t)(void *)ctxt->execute);

> -		else
> +		if (ctxt->d & Fastop) {
> +			fastop_t fop = (void *)ctxt->execute;
> +			rc = fastop(ctxt, fop);
> +		} else {
>  			rc = ctxt->execute(ctxt);
> +		}
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
>  		goto writeback;
> -- 
> 1.8.3.1
> 
