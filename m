Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82649718FF9
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 03:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjFABYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 21:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjFABYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 21:24:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B5101;
        Wed, 31 May 2023 18:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685582684; x=1717118684;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MEEMrxv7tA0YbZIe/40VKopn6R+fUhfu8ONccvTrMVU=;
  b=Mpt+Z++txwoOEU/Vj6pfBZf6RRNAcgEdd29m6wfzZVkc1RLHNIIoHerb
   nfdegvTisy8Gt7TDafFUX/zW+fVhUeh1SbGt954hzxJFzHDtvIW2lrrh1
   IrZP8BlSs9h1h0ZsY80x7HJBVtA+c0heb2RM6nytRNlPh7WlNXkZqLvFr
   PKrhVjXbtCxMIzjVJvH6eCjmAWH1tvHB99ReL3+4KzvgbwuH2OhgaPZdN
   5Vqod+JKekrrnx6Ko3s9ML9buqttxM/rXr3QdVVigUGkny5LD+SJv1S4n
   AdCT781pxRg0MVdwyylnMLbZ+e6UWPZYxXxmadGziePXGdYRJqE8fBat+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="357815158"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="357815158"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 18:24:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="684634736"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="684634736"
Received: from ksauluck-mobl.amr.corp.intel.com (HELO desk) ([10.212.165.26])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 18:24:30 -0700
Date:   Wed, 31 May 2023 18:24:29 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230601012323.36te7hfv366danpf@desk>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 01:50:48AM +0100, Andrew Cooper wrote:
> On 01/06/2023 1:42 am, Josh Poimboeuf wrote:
> > So each LFENCE has a distinct purpose.  That said, there are no indirect
> > branches or unbalanced RETs between them.
> 
> How lucky are you feeling?
> 
> You're in C at this point, which means the compiler could have emitted a
> call to mem{cpy,cmp}() in place of a simple assignment/comparison.

Moving the second LFENCE to the else part of WRMSR should be possible?
So that the serialization can be achived either by WRMSR or LFENCE. This
saves an LFENCE when host and guest value of MSR_SPEC_CTRL differ.

---
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2d6e1b6c788..d32e6d172dd6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7157,8 +7157,8 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
 	    vmx->spec_ctrl != hostval)
 		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
-
-	barrier_nospec();
+	else
+		barrier_nospec();
 }
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
