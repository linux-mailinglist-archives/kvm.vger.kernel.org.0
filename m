Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF10623DB7
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 09:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbiKJIoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 03:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiKJIo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 03:44:26 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2692E2935C;
        Thu, 10 Nov 2022 00:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668069865; x=1699605865;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kBkbc2MQ9c/NiFCQRoAmN+okU0cL5VhONw3TYm+Zy/Q=;
  b=hb93gx1CTv7oyCqCIBMIdyDEOccsHVuW92kzYNOJQvPtXxTT4x0USNYa
   MP/TCtJKuanwyJkbYXnhA4veCH0UUoxNBYlJY6ArKOCyLsHToplHSj/v3
   wAm1fs/PsDEqtFbAVTT/ywDA3fot/9aFWJxYWAxHUZ7gU+fPmuLPdBY7f
   rYreYxdFDMixja+rhYF7TENw2xxQvuBZwMhB647Z1A8P/3XFXZP9sPIac
   j6bv+ki4gC+HHQzX+XIg3dYELQkgDunGVUyCkh2CmILCxKIQRedopTCpF
   sGhPL9lgSavHVqHYDFkw8pWud1eMgceEaUjpYwfmJ4+00UptUQjqW2teb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="308879708"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="308879708"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 00:44:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="779692262"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="779692262"
Received: from shiningy-mobl1.ccr.corp.intel.com (HELO localhost) ([10.255.28.247])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 00:44:21 -0800
Date:   Thu, 10 Nov 2022 16:44:19 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Liu Jingqi <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <20221110084418.t7iv5zlfgiu77gfn@linux.intel.com>
References: <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
 <Y2Px90RQydMUoiRH@google.com>
 <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
 <Y2kfCz02tQSUkMKS@google.com>
 <20221108102120.qdlgqlgvdi6wi22u@linux.intel.com>
 <Y2qhaSr/d2ds+nqD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2qhaSr/d2ds+nqD@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> No.  Again, KVM _should never_ manipulate VMX MSRs in response to CPUID changes.
> Keeping the existing behavior would be done purely to maintain backwards
> compability with existing userspace, not because it's strictly the right thing to do.
> 
> E.g. as a strawman, a weird userspace could do KVM_SET_MSRS => KVM_SET_CPUID =>
> KVM_SET_CPUID, where the first KVM_SET_CPUID reset to a base config and the second
> KVM_SET_CPUID incorporates "optional" features.  In that case, clearing bits in
> the VMX MSRs on the first KVM_SET_CPUID would do the wrong thing if the second
> KVM_SET_CPUID enabled the relevant features.
> 
> AFAIK, no userspace actually does something odd like that, whereas there are VMMs
> that do KVM_SET_MSRS before KVM_SET_CPUID, e.g. disable a feature in VMX MSRs but
> later enable the feature in CPUID for L1.  And so disabling features is likely
> safe-ish, but enabling feature most definitely can cause problems for userspace.
> 
> Hrm, actually, there are likely older VMMs that never set VMX MSRs, and so dropping
> the "enable features" code might not be safe either.  Grr.  The obvious solution
> would be to add a quirk, but maybe we can avoid a quirk by skipping KVM's
> misguided updates if userspace has set the MSR.  That should work for a userspace
> that deliberately sets the MSR during setup, and for a userspace that blindly
> migrates the MSR since the migrated value should already be correct/sane.
> 
Oh. Just saw your new selftest code, and fininally get your point(I hope
so...).  Thanks!

> > BTW, I found my previous understanding of what vmx_adjust_secondary_exec_control()
> > currently does was also wrong. It could also be used for EXITING controls. And
> > for such flags(e.g., SECONDARY_EXEC_RDRAND_EXITING), values for the nested settings
> > (vmx->nested.msrs.secondary_ctls_high) and for the L1 execution controls(*exec_control)
> > could be opposite. So the statement:
> > 	"1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
> > 	 disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes."
> > is wrong.
> 
> No, it's correct.  The EXITING controls are just inverted feature flags.  E.g. if
> RDRAND is disabled in CPUID, KVM sets the EXITING control so that KVM intercepts
> RDRAND in order to inject #UD.
> 
> 	[EXIT_REASON_RDRAND]                  = kvm_handle_invalid_op,
> 

Well, suppose
- cpu_has_vmx_rdrand() is true;
- meanwhile guest_cpuid_has(vcpu, X86_FEATURE_RDRAND) is false.

And then, what vmx_adjust_secondary_exec_control() currently does is:
1> keep the SECONDARY_EXEC_RDRAND_EXITING set in L1 secondary proc-
based execution control.
2> and then clear the SECONDARY_EXEC_RDRAND_EXITING in the high bits
of IA32_VMX_PROCBASED_CTLS2 MSR for nested by
        vmx->nested.msrs.secondary_ctls_high &= ~control;
That means for L1 VMM, SECONDARY_EXEC_RDRAND_EXITING must be cleared
in its(VMCS12's) secondary proc-based VM-execution control, even when
rdrand is disabled in L1's and L2's CPUID.

I wonder, for native environment, if an instruction is not supported,
will the allowed 1-setting for its corresponding exiting feature in
IA32_VMX_PROCBASED_CTLS2 MSR be set, or be cleared? Maybe it should
be cleared, and executing such instruction in non-root will just get
a #UD directly instead of triggering a VM-Exit?

Note: I do not think this will cause any problem, just curious if L1
VMM can observe a behavior that's not supposed to be in native scenario(
only because what we are doing in KVM). 

B.R.
Yu

