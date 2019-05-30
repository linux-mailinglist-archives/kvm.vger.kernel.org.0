Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72949301F9
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 20:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfE3Sa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 14:30:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:65262 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfE3Sa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 14:30:59 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:30:58 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 30 May 2019 11:30:58 -0700
Date:   Thu, 30 May 2019 11:30:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Beulich <JBeulich@suse.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krm <rkrcmar@redhat.com>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/kvm/VMX: drop bad asm() clobber from
 nested_vmx_check_vmentry_hw()
Message-ID: <20190530183058.GC23930@linux.intel.com>
References: <5CEBA3B80200007800232856@prv1-mh.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5CEBA3B80200007800232856@prv1-mh.provo.novell.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 02:45:44AM -0600, Jan Beulich wrote:
> While upstream gcc doesn't detect conflicts on cc (yet), it really
> should, and hence "cc" should not be specified for asm()-s also having
> "=@cc<cond>" outputs. (It is quite pointless anyway to specify a "cc"
> clobber in x86 inline assembly, since the compiler assumes it to be
> always clobbered, and has no means [yet] to suppress this behavior.)
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

FWIW (mostly to satisfy my curiosity):

Fixes: bbc0b8239257 ("KVM: nVMX: Capture VM-Fail via CC_{SET,OUT} in nested early checks")

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> 
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2781,7 +2781,7 @@ static int nested_vmx_check_vmentry_hw(s
>  		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
>  		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
>  		[wordsize]"i"(sizeof(ulong))
> -	      : "cc", "memory"
> +	      : "memory"
>  	);
>  
>  	if (vmx->msr_autoload.host.nr)
> 
> 
