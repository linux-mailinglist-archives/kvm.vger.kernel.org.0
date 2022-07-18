Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D8577BE6
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 08:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiGRGwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 02:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGRGwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 02:52:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B5AE0C8;
        Sun, 17 Jul 2022 23:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658127137; x=1689663137;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=noTc/cBrpSAUZk+3ypYxCHmUWcNG3pn6t86Bk9BalFc=;
  b=XgFMIOgZsWkfIenAFgmPHc0lSvEJ47xzlejPo1BOY/5zTRKJhiL7GuGc
   GoJ03B9mG+0WGvlgWYaDDz+zIzk5pjt4wZn1Co0RIpNmkt9bhoXPn2Giu
   yzCZk1u3wUOPprzBSIdO4VDfyAWFg3ImusE6IB2GflR74iXvGAbbgegNY
   yhW5xYabL2dKrrJ6RIOxna2FSNC3qS4VMc62dWVAmOWbHhLUym+DBIpX/
   yfKmuAnPeeheSGWB/Xcjk0aZFnt/hQqV8uA3FPh34+g8Y8c3Ny56UHcRK
   bvGgm/ISjhD+gEn2ed2PEoTyT6y7L+pRpJb+vSHHI3kClRt/KiHaUl9Su
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="269172430"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="269172430"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 23:52:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="624603590"
Received: from yangxuan-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.171.3])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 23:52:07 -0700
Date:   Mon, 18 Jul 2022 14:52:05 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: X86: Initialize 'fault' in
 kvm_fixup_and_inject_pf_error().
Message-ID: <20220718065205.j4tsv7tpq4vsmcvp@linux.intel.com>
References: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
 <20220715114211.53175-2-yu.c.zhang@linux.intel.com>
 <YtF+CF2FkS7Ho1d5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtF+CF2FkS7Ho1d5@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 02:47:36PM +0000, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Yu Zhang wrote:
> > kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
> > e.g., to add RSVD flag) and inject the #PF to the guest, when guest
> > MAXPHYADDR is smaller than the host one.
> > 
> > When it comes to nested, L0 is expected to intercept and fix up the #PF
> > and then inject to L2 directly if
> > - L2.MAXPHYADDR < L0.MAXPHYADDR and
> > - L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
> >   same MAXPHYADDR value && L1 is using EPT for L2),
> > instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
> > and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
> > may happen on all L2 #PFs.
> > 
> > However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
> > may cause the fault.async_page_fault being NOT zeroed, and later the #PF
> > being treated as a nested async page fault, and then being injected to L1.
> > So just fix it by initialize the 'fault' value in the beginning.
> 
> Ouch.
> 
> > Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
> > Reported-by: Yang Lixiao <lixiao.yang@intel.com>
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 031678eff28e..3246b3c9dfb3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12983,7 +12983,7 @@ EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
> >  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
> >  {
> >  	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
> > -	struct x86_exception fault;
> > +	struct x86_exception fault = {0};
> >  	u64 access = error_code &
> >  		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
> 
> As stupid as it may be to intentionally not fix the uninitialized data in a robust
> way, I'd actually prefer to manually clear fault.async_page_fault instead of
> zero-initializing the struct.  Unlike a similar bug fix in commit 159e037d2e36
> ("KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()"),
> this code actually cares about async_page_fault being false as opposed to just
> being _initialized_.
> 
> And if another field is added to struct x86_exception in the future, leaving the
> struct uninitialized means that if such a patch were to miss this case, running
> with various sanitizers should in theory be able to detect such a bug.  I suspect
> no one has found this with syzkaller due to the need to opt into running with
> allow_smaller_maxphyaddr=1.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f389691d8c04..aeed737b55c2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12996,6 +12996,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
>                 fault.error_code = error_code;
>                 fault.nested_page_fault = false;
>                 fault.address = gva;
> +               fault.async_page_fault = false;
>         }
>         vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
>  }
> 

Fair enough. Thanks!

B.R.
Yu
