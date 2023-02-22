Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4585569EEF3
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 07:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjBVGtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 01:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBVGti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 01:49:38 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D1B28D0C;
        Tue, 21 Feb 2023 22:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677048576; x=1708584576;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EJEJ9lZax3pugj77Qzpsa+A63d5W5LOcYOyYqGlWL+E=;
  b=KmEmfgDXLq9PYoA6bC35iOnmds2e+739DKZHo5B3SASmdMTlTCo130C+
   poelEIwfzYhPfq3AyHpWUmletMEbGj5+zdKn3QJ+wK5/8m8Sv8dx9BGb+
   7CUCj8swDjRzf4CTa04X+Azd5hsSJXNF1rmQa9HXv+JUturBS5C0iNye6
   O9Q2SFeHgOl6W6k5MbJ4x6shFFVK+MpPYjlxnhUZe8Mj3fE7ibp1IsI+B
   bi2FMwk7CRPORyI3iRETBF5xEp2YBwGy31XhrZLfxv5390lg92viG9E1j
   vPezFk47yp3yZznSg/u0olgsclM5wuZvXfU4cpiDgtfYGgqkFRrAVOPPv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="360330472"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="360330472"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 22:49:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="704352154"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="704352154"
Received: from jiajiaz1-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.211.87])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 22:49:33 -0800
Date:   Wed, 22 Feb 2023 14:49:31 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
Message-ID: <20230222064931.ppz6berhfr4edewf@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-9-seanjc@google.com>
 <20230221152349.ulcjtbnvziair7ff@linux.intel.com>
 <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
 <Y/VYN3n/lHePiDxM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/VYN3n/lHePiDxM@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023 at 03:48:07PM -0800, Sean Christopherson wrote:
> On Tue, Feb 21, 2023, Yu Zhang wrote:
> > > Sorry, why guest_cpuid_is_intel(vcpu)? Is it becasue that a AMD host with virtual
> > > VMSAVE/VMLOAD capability will always expose this feature for all AMD guests? 
> > 
> > Oh, sorry. I missed the guest_cpuid_has() in kvm_governed_feature_check_and_set().
> > So please just ignore my 2nd question.
> > 
> > As to the check of guest_cpuid_is_intel(), is it necessary?
> 
> Yes?  The comment in init_vmcb_after_set_cpuid() says:
> 
> 		/*
> 		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
> 		 * accesses because the processor only stores 32 bits.
> 		 * For the same reason we cannot use virtual VMLOAD/VMSAVE.
> 		 */
> 
> but I'm struggling to connect the dots to SYSENTER.  I suspect the comment is
> misleading and has nothing to do 32-bit vs. 64-bit (or I'm reading it wrong) and
> should be something like:
> 
> 	/*
> 	 * Disable virtual VMLOAD/VMSAVE and intercept VMLOAD/VMSAVE if the
> 	 * guest CPU is Intel in order to inject #UD.
> 	 */
> 
> In other words, a non-SVM guest shouldn't be allowed to execute VMLOAD/VMSAVE.

Yes. Such interpretation makes sense. And vmload/vmsave shall be intercepted
if guest CPU is Intel and #UD shall be injected. I guess this is done indirectly
by judging the EFER_SVME not set in EFER in nested_svm_check_permissions()?

And as to X86_FEATURE_V_VMSAVE_VMLOAD, should the guest_cpuid_has() return true
at all for a Intel guest?

B.R.
Yu
