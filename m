Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5816A18B0
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 10:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjBXJ0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 04:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBXJ0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 04:26:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655E365CF3;
        Fri, 24 Feb 2023 01:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677230758; x=1708766758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OyeVN/6+sk6VdrZcJyIYuAz0tXwdT2zcvqJwbZL9lL0=;
  b=PHnZ7rkMBSQntiRDnjiwtPa56ZK6e3klgxT9OgzBzxraaaLLSAVaL3LA
   6NqsN2VKvdTD76OxiFeYRql+a8jt1AoXau70+u5783hUUDBSwzByrd37p
   gBSdsheYfaZI6Kj5J1rbbFn6GbA4vAe+pz2+MNavg2xRVXzC7tqkB280o
   Ozzb/h6T9iLWfkUJi4RxwzD9CbWgn7B8S9mSDBAIeMheZG5gIfnJjyANc
   fwUz63Rk0b4NHS6SnCaT63yxd5DsO0LRJmrNQGtYQJHlqCSrF6giM59eH
   noW9tLUu5dwNZh3lUXF76Mo52UkVsvdbAJZMNGkd5f4ehy5SMqmv+doCY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="331169926"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="331169926"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:25:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="741607042"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="741607042"
Received: from moqiongz-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.215.23])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:25:55 -0800
Date:   Fri, 24 Feb 2023 17:25:52 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
Message-ID: <20230224092552.6olrcx2ryo4sexxm@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-9-seanjc@google.com>
 <20230221152349.ulcjtbnvziair7ff@linux.intel.com>
 <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
 <Y/VYN3n/lHePiDxM@google.com>
 <20230222064931.ppz6berhfr4edewf@linux.intel.com>
 <Y/ZFJfspU6L2RmQS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/ZFJfspU6L2RmQS@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 08:39:01AM -0800, Sean Christopherson wrote:
> +Maxim
> 
> On Wed, Feb 22, 2023, Yu Zhang wrote:
> > On Tue, Feb 21, 2023 at 03:48:07PM -0800, Sean Christopherson wrote:
> > > On Tue, Feb 21, 2023, Yu Zhang wrote:
> > > > > Sorry, why guest_cpuid_is_intel(vcpu)? Is it becasue that a AMD host with virtual
> > > > > VMSAVE/VMLOAD capability will always expose this feature for all AMD guests? 
> > > > 
> > > > Oh, sorry. I missed the guest_cpuid_has() in kvm_governed_feature_check_and_set().
> > > > So please just ignore my 2nd question.
> > > > 
> > > > As to the check of guest_cpuid_is_intel(), is it necessary?
> > > 
> > > Yes?  The comment in init_vmcb_after_set_cpuid() says:
> > > 
> > > 		/*
> > > 		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
> > > 		 * accesses because the processor only stores 32 bits.
> > > 		 * For the same reason we cannot use virtual VMLOAD/VMSAVE.
> > > 		 */
> > > 
> > > but I'm struggling to connect the dots to SYSENTER.  I suspect the comment is
> > > misleading and has nothing to do 32-bit vs. 64-bit (or I'm reading it wrong) and
> > > should be something like:
> > > 
> > > 	/*
> > > 	 * Disable virtual VMLOAD/VMSAVE and intercept VMLOAD/VMSAVE if the
> > > 	 * guest CPU is Intel in order to inject #UD.
> > > 	 */
> > > 
> > > In other words, a non-SVM guest shouldn't be allowed to execute VMLOAD/VMSAVE.
> > 
> > Yes. Such interpretation makes sense. And vmload/vmsave shall be intercepted
> > if guest CPU is Intel and #UD shall be injected. I guess this is done indirectly
> > by judging the EFER_SVME not set in EFER in nested_svm_check_permissions()?
> 
> Nope, my interpretation is wrong.  vmload_vmsave_interception() clears the upper
> bits of SYSENTER_{EIP,ESP}
> 
> 	if (vmload) {
> 		svm_copy_vmloadsave_state(svm->vmcb, vmcb12);
> 		svm->sysenter_eip_hi = 0;
> 		svm->sysenter_esp_hi = 0;
> 	} else {
> 		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
> 	}
> 
> From commit adc2a23734ac ("KVM: nSVM: improve SYSENTER emulation on AMD"):
>     
>     3. Disable vmload/vmsave virtualization if vendor=GenuineIntel.
>        (It is somewhat insane to set vendor=GenuineIntel and still enable
>        SVM for the guest but well whatever).
>        Then zero the high 32 bit parts when kvm intercepts and emulates vmload.
> 
> Presumably AMD hardware loads only the lower 32 bits, which would leave garbage
> in the upper bits and even leak state from L1 to L2 (again ignoring the fact that
> exposing SVM to an Intel vCPU is bonkers).
Is it because L1 is a VM migrated from Intel platform to AMD's?

So w/o commit adc2a23734ac ("KVM: nSVM: improve SYSENTER emulation on AMD"):
1> L1 could be a "GenuineIntel" with SVM capability (bizarre as it is), running
in 64-bit mode.
2> With no interception of MSR writes to the SYSENTER_EIP/ESP, L1 may set its
SYSENTER_EIP/ESP to a 64-bit value successfully (though sysenter/sysexit may
fail).
3> L2 could be in 32-bit mode. And if virtual vmload/vmsave is enabled for L1,
only lower 32 bits of those MSRs will be loaded, leaking the higher 32 bits.

Is above scenario the reason of Maxim's fix?

But why it is related to nested migration? 


> I'll opportunistically massage the comment to make it more explicit about why
> VMLOAD needs to be intercepted.
>  
> That said, clearing the bits for this seems wrong.  That would corrupt the MSRs
> for 64-bit Intel guests.  The "target" of the fix was 32-bit L2s, i.e. I doubt
> anything would notice.
> 
>     This patch fixes nested migration of 32 bit nested guests, that was
>     broken because incorrect cached values of SYSENTER msrs were stored in
>     the migration stream if L1 changed these msrs with
>     vmload prior to L2 entry.

> 
> Maxim, would anything actually break if KVM let L1 load 64-bit values for the
> SYSENTER MSRs?
> 
> > And as to X86_FEATURE_V_VMSAVE_VMLOAD, should the guest_cpuid_has() return true
> > at all for a Intel guest?
> 
> Yes, because guest CPUID is userspace controlled.  Except for emulating architectural
> side effects, e.g. size of XSAVE area, KVM doesn't sanitize guest CPUID.
> 

B.R.
Yu
