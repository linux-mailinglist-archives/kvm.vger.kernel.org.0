Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCD03E41CB
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhHIIta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:49:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:30257 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234068AbhHIIt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 04:49:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214675998"
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="214675998"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 01:49:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="514842352"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Aug 2021 01:49:03 -0700
Date:   Mon, 9 Aug 2021 17:02:15 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 13/15] KVM: x86/vmx: Clear Arch LBREn bit before
 inject #DB to guest
Message-ID: <20210809090215.GA31980@intel.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-14-git-send-email-weijiang.yang@intel.com>
 <fde88a8a-fd9b-b192-caae-105224d78b47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fde88a8a-fd9b-b192-caae-105224d78b47@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021 at 01:08:32PM +0800, Like Xu wrote:
> On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> >Per ISA spec, need to clear the bit before inject #DB.
> 
> Please paste the SDM statement accurately so that the reviewers
> can verify that the code is consistent with the documentation.
>
Thanks Like! Sure, will add the description in commit message.

> >
> >Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >---
> >  arch/x86/kvm/vmx/vmx.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 70314cd93340..31b9c06c9b3b 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -1601,6 +1601,21 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
> >  		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
> >  }
> >+static void flip_arch_lbr_ctl(struct kvm_vcpu *vcpu, bool on)
> >+{
> >+	if (vcpu_to_pmu(vcpu)->event_count > 0 &&
> 
> Ugh, this check seems ridiculous/funny to me.
Do you expect aditional bit-check for INTEL_PMC_IDX_FIXED_VLBR in 
pmu->pmc_in_use?

> 
> >+	    kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> >+		u64 lbr_ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
> >+
> >+		if (on)
> >+			lbr_ctl |= 1ULL;
> >+		else
> >+			lbr_ctl &= ~1ULL;
> >+
> >+		vmcs_write64(GUEST_IA32_LBR_CTL, lbr_ctl);
> >+	}
> >+}
> 
> ...
