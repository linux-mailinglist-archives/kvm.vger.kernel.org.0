Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C213DF3B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 16:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgAPPu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 10:50:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:9875 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPPu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 10:50:59 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 07:50:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="257414987"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jan 2020 07:50:57 -0800
Date:   Thu, 16 Jan 2020 07:50:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Perform non-canonical checks in 32-bit KVM
Message-ID: <20200116155057.GB20561@linux.intel.com>
References: <20200115183605.15413-1-sean.j.christopherson@intel.com>
 <cf9a9746-e0b8-8303-afd5-b1c3a2a9ac83@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf9a9746-e0b8-8303-afd5-b1c3a2a9ac83@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 15, 2020 at 05:37:16PM -0800, Krish Sadhukhan wrote:
> 
> On 01/15/2020 10:36 AM, Sean Christopherson wrote:
> >  arch/x86/kvm/x86.h | 8 --------
> >  1 file changed, 8 deletions(-)
> >
> >diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> >index cab5e71f0f0f..3ff590ec0238 100644
> >--- a/arch/x86/kvm/x86.h
> >+++ b/arch/x86/kvm/x86.h
> >@@ -166,21 +166,13 @@ static inline u64 get_canonical(u64 la, u8 vaddr_bits)
> >  static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
> >  {
> >-#ifdef CONFIG_X86_64
> >  	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
> >-#else
> >-	return false;
> >-#endif
> >  }
> >  static inline bool emul_is_noncanonical_address(u64 la,
> >  						struct x86_emulate_ctxt *ctxt)
> >  {
> >-#ifdef CONFIG_X86_64
> >  	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
> >-#else
> >-	return false;
> >-#endif
> >  }
> >  static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
> 
> nested_vmx_check_host_state() still won't call it on 32-bit because it has
> the CONFIG_X86_64 guard around the callee:
> 
>  #ifdef CONFIG_X86_64
>         if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
>             CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
>  ...

Doh, I was looking at an older version of nested.c.  Nice catch!

> Don't we need to remove these guards in the callers as well ?

Ya, that would be my preference.
