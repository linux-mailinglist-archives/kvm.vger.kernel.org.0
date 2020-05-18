Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAF81D7DCB
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgERQHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:07:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:39482 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgERQHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 12:07:21 -0400
IronPort-SDR: bB2wZcfza31q8u/CKeuS/KjNfC7jvR/2IKCCW2s9bz1odqCqmkFDvqh0sffvaviomHJcC5tf1Z
 w++NNwzTmZ/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 09:07:20 -0700
IronPort-SDR: ban6HNM1oWSr+nAEJvwkqVjMI2Hc53rxsTp5Fk6TWMpOVFWKkdcWGNPhSu6cHKo9XpClz7kWP8
 sGzfOoPJ3sUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="254480084"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 18 May 2020 09:07:20 -0700
Date:   Mon, 18 May 2020 09:07:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
Message-ID: <20200518160720.GB3632@linux.intel.com>
References: <20200515161919.29249-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515161919.29249-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 12:19:19PM -0400, Paolo Bonzini wrote:
> Instructions starting with 0f18 up to 0f1f are reserved nops, except those
> that were assigned to MPX.

Well, they're probably reserved NOPs again :-D.

> These include the endbr markers used by CET.

And RDSPP.  Wouldn't it make sense to treat RDSPP as a #UD even though it's
a NOP if CET is disabled?  The logic being that a sane guest will execute
RDSSP iff CET is enabled, and in that case it'd be better to inject a #UD
than to silently break the guest.

Extending that logic to future features, wouldn't it then make sense to
keep the current #UD behavior for all opcodes to avoid silently breakage?
I.e. change only the opcodes for endbr (which consume only 2 of 255 ModRMs
for 0f 1e) to be NOPs.

> List them correctly in the opcode table.
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index de5476f8683e..d0e2825ae617 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4800,8 +4800,12 @@ static const struct opcode twobyte_table[256] = {
>  	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_10_0f_11),
>  	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_10_0f_11),
>  	N, N, N, N, N, N,
> -	D(ImplicitOps | ModRM | SrcMem | NoAccess),
> -	N, N, N, N, N, N, D(ImplicitOps | ModRM | SrcMem | NoAccess),
> +	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 4 * prefetch + 4 * reserved NOP */
> +	D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
> +	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
> +	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
> +	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
> +	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* NOP + 7 * reserved NOP */
>  	/* 0x20 - 0x2F */
>  	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
>  	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
> -- 
> 2.18.2
> 
