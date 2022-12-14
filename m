Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA5164C27C
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 04:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiLNDAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 22:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbiLNDAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 22:00:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A94913F7F;
        Tue, 13 Dec 2022 19:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670986843; x=1702522843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L3c/NxFD0YBcLEtM9TVNwIbvZtr+4RUOZ/EzsLxV6mc=;
  b=VsdXMz+yo5Bd6DeS7wQ5IrjJNMfRHv3vJ2lrWt9ydM8NdlNj8oBya/ga
   iP3z/oeVn+Qk1yww2rJSy9VqccLedki18pbBDSRrYtI063ZRsbGZ2s/d4
   mjL6Q30HzAwT7FK2heJAhZLuaXzSbLwB7Lpp7vZ6FJprk5MDOzaO9VJIP
   FpRrz2LwzeJhiGiEh+iiOK86uOt89RbGwdoRLjpTs+K1YemObR//d/Izd
   bErHi8UJlwI+bSGDmdn1rilPyLLG3P9fIKAw7jgAkJXgAKlwIa7fLa5Ic
   kUsWYx6cSHcT3ZIWqvUfqgC0xd15E9QTixQ9Su1e773395dyIwIqcSx8v
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="316999573"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="316999573"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 19:00:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="650927956"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="650927956"
Received: from jliu4-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.215.175])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 19:00:40 -0800
Date:   Wed, 14 Dec 2022 11:00:37 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 0/4] KVM: nVMX: Fix 2nd exec controls override goofs
Message-ID: <20221214030037.4qz6v6fvfx6of32n@linux.intel.com>
References: <20221213062306.667649-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213062306.667649-1-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 06:23:02AM +0000, Sean Christopherson wrote:
> Fix bugs in KVM's (mis)handling of secondary execution controls.
> 
> KVM overrides the secondary execution control VMX MSR during KVM_SET_CPUID.
> Similar to the somewhat recent reverts
> 
>   8805875aa473 ("Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"")
>   9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control"")
> 
> undo misguided KVM behavior where KVM overrides allowed-1 settings in the
> secondary execution controls in response to changes to the guest's CPUID
> model.  To avoid breaking userspace that doesn't take ownership of the
> VMX MSRs, go hands off if and only if userpace sets the MSR in question.
> 
> Before fixing that, fix another bug it was hiding where the umwait/tpause
> control was being exposed to L1 for nVMX only after KVM_SET_CPUID, and
> harden KVM against similar bugs in the future.
> 
> v2: Fix the ENABLE_USR_WAIT_PAUSE bug too. [Aaron]
> 
> v1: https://lore.kernel.org/all/20221110005706.1064832-1-seanjc@google.com
> 
> Sean Christopherson (4):
>   KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1
>   KVM: nVMX: Don't stuff secondary execution control if it's not
>     supported
>   KVM: nVMX: Don't muck with allowed sec exec controls on CPUID changes
>   KVM: selftests: Test KVM's handling of VMX's sec exec MSR on
>     KVM_SET_CPUID

BTW, we may need another patch to remove the obsolete comments in
nested_vmx_setup_ctls_msrs():

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6f4411b613e..42ceddcafd3e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6854,11 +6854,6 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
        msrs->procbased_ctls_low &=
                ~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);

-       /*
-        * secondary cpu-based controls.  Do not include those that
-        * depend on CPUID bits, they are added later by
-        * vmx_vcpu_after_set_cpuid.
-        */
        msrs->secondary_ctls_low = 0;

        msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;

B.R.
Yu
