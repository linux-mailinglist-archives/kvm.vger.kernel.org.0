Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA3A30D9E1
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 13:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhBCMis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 07:38:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:31173 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhBCMis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 07:38:48 -0500
IronPort-SDR: ut+pHBYZv39zJn1U+De3v39w9dqp8i0YrmFLpV+Gy+wIlWUwXH/EplTZzHc1kGt/5QkBuQfG/f
 6GA2qms1R+Mw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="168141275"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="168141275"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 04:38:02 -0800
IronPort-SDR: zOvKmxyMEh5/wZg7/SDXUExUwH6TO4jXWQDp31ZzbgxqVMYPCooiT3hV10/VaIHvitEvGZ+NAw
 hrDu1BWfMV3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="433390944"
Received: from unknown (HELO localhost) ([10.239.159.166])
  by orsmga001.jf.intel.com with ESMTP; 03 Feb 2021 04:38:00 -0800
Date:   Wed, 3 Feb 2021 20:50:16 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v15 07/14] KVM: VMX: Emulate reads and writes to CET MSRs
Message-ID: <20210203125016.GA6080@local-michael-cet-test>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-8-weijiang.yang@intel.com>
 <6a743d57-8128-b5db-ddc1-9dd4c4c1004e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a743d57-8128-b5db-ddc1-9dd4c4c1004e@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 12:57:41PM +0100, Paolo Bonzini wrote:
> On 03/02/21 12:34, Yang Weijiang wrote:
> > MSRs that are switched through XSAVES are especially annoying due to the
> > possibility of the kernel's FPU being used in IRQ context. Disable IRQs
> > and ensure the guest's FPU state is loaded when accessing such MSRs.
> 
> Good catch!  This should be in x86.h and named kvm_get/set_xsave_msr because
> it's not VMX specific.  The commit message should also be there as a
> comment.
Thanks a lot for reviewing! These words came from Sean! :-D
>
> In addition,
> 
> > +	case MSR_IA32_S_CET:
> > +		if (!cet_is_control_msr_accessible(vcpu, msr_info))
> > +			return 1;
> > +		msr_info->data = vmcs_readl(GUEST_S_CET);
> > +		break;
> > +	case MSR_IA32_U_CET:
> > +		if (!cet_is_control_msr_accessible(vcpu, msr_info))
> > +			return 1;
> > +		vmx_get_xsave_msr(msr_info);
> > +		break;
> 
> these two might as well be the same "case" for symmetry with the handling of
> WRMSR.
> 
> I've fixed this up locally, since these patches will not be pushed to Linus
> until the corresponding bare metal support is there.
Got it!
> 
> Paolo
