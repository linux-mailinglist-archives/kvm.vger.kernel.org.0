Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C1919FA1C
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 18:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgDFQ2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 12:28:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:4896 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728789AbgDFQ2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 12:28:50 -0400
IronPort-SDR: rnJ+G5HW21XJr2NURsa2kGyuOB8ZvugmyrXDFYY+tpxMQCBkPZgfjYIbFToi4hv/+DujQevCZG
 KRFgc8o4Xflw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 09:28:49 -0700
IronPort-SDR: sB/zNWGQ39luR3pwa6YScUfdibT5ijwjwOs6a8Tlty9M/DF70otkfEMjQ6LfDT7vrwNG0TrIWG
 xf2+EJHScIiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,351,1580803200"; 
   d="scan'208";a="285939692"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2020 09:28:49 -0700
Date:   Mon, 6 Apr 2020 09:28:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: Remove unnecessary exception trampoline in
 vmx_vmenter
Message-ID: <20200406162848.GF21330@linux.intel.com>
References: <20200406151641.67698-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406151641.67698-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 06, 2020 at 05:16:41PM +0200, Uros Bizjak wrote:
> The exception trampoline in .fixup section is not needed, the exception handling code can jump directly to the label in .text section.

Changelog need to be wrapped at 75 chars, and "label in .text section"
should be "label in the .text section".

Nits aside,

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 81ada2ce99e7..56d701db8734 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -58,12 +58,8 @@ SYM_FUNC_START(vmx_vmenter)
>  	ret
>  4:	ud2
>  
> -	.pushsection .fixup, "ax"
> -5:	jmp 3b
> -	.popsection
> -
> -	_ASM_EXTABLE(1b, 5b)
> -	_ASM_EXTABLE(2b, 5b)
> +	_ASM_EXTABLE(1b, 3b)
> +	_ASM_EXTABLE(2b, 3b)
>  
>  SYM_FUNC_END(vmx_vmenter)
>  
> -- 
> 2.25.1
> 
