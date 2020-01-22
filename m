Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31687144AE3
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 05:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAVEm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 23:42:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:13481 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgAVEm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 23:42:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 20:42:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,348,1574150400"; 
   d="scan'208";a="427291652"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jan 2020 20:42:56 -0800
Date:   Tue, 21 Jan 2020 20:42:56 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: X86: Add 'else' to unify fastop and execute call
 path
Message-ID: <20200122044256.GA18513@linux.intel.com>
References: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 22, 2020 at 11:21:44AM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> It also helps eliminate some duplicated code.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  arch/x86/kvm/emulate.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c7a0da45f60a..0accce94f660 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5683,11 +5683,9 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  		if (ctxt->d & Fastop) {
>  			void (*fop)(struct fastop *) = (void *)ctxt->execute;

The brackets can also be removed with a bit more cleanup, e.g. using a
typedef to handling casting ctxt->execute.  I'll send a patch that can be
applied on top and/or squashed with this one.

>  			rc = fastop(ctxt, fop);
> -			if (rc != X86EMUL_CONTINUE)
> -				goto done;
> -			goto writeback;
> +		} else {
> +			rc = ctxt->execute(ctxt);
>  		}
> -		rc = ctxt->execute(ctxt);
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
>  		goto writeback;
> -- 
> 2.19.1
> 
