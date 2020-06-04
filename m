Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E607E1EE784
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 17:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgFDPQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 11:16:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:12085 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbgFDPQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 11:16:39 -0400
IronPort-SDR: sV52ih0nEO33Ic+hcz1XCUEL/sm7frYGFlNfOhVUjQFQOySmmp/2Lm1DdRjklmmxs9Pkrpjg8B
 ztb2xQ5MmNQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 08:16:39 -0700
IronPort-SDR: 7rw/X5N9Mgd/AOw/kzPAHTsM03dD7lWqg3OO//GPB0QmEfXtCcVCYA3XI8b0hLyO9SKG869oLy
 wXQ2ogipqrJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="287403926"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 04 Jun 2020 08:16:38 -0700
Date:   Thu, 4 Jun 2020 08:16:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH] KVM: VMX: Always treat MSR_IA32_PERF_CAPABILITIES as a
 valid PMU MSR
Message-ID: <20200604151638.GD30223@linux.intel.com>
References: <20200603203303.28545-1-sean.j.christopherson@intel.com>
 <46f57aa8-e278-b4fd-7ac8-523836308051@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46f57aa8-e278-b4fd-7ac8-523836308051@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 09:37:59AM +0800, Xu, Like wrote:
> On 2020/6/4 4:33, Sean Christopherson wrote:
> >Unconditionally return true when querying the validity of
> >MSR_IA32_PERF_CAPABILITIES so as to defer the validity check to
> >intel_pmu_{get,set}_msr(), which can properly give the MSR a pass when
> >the access is initiated from host userspace.
> Regardless of  the MSR is emulated or not, is it a really good assumption that
> the guest cpuids are not properly ready when we do initialization from host
> userspace
> ?

I don't know if I would call it a "good assumption" so much as a "necessary
assumption".  KVM_{GET,SET}_MSRS are allowed, and must function correctly,
if they're called prior to KVM_SET_CPUID{2}.

> >The MSR is emulated so
> >there is no underlying hardware dependency to worry about.
> >
> >Fixes: 27461da31089a ("KVM: x86/pmu: Support full width counting")
> >Cc: Like Xu <like.xu@linux.intel.com>
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >
> >KVM selftests are completely hosed for me, everything fails on KVM_GET_MSRS.
> At least I tried "make --silent -C tools/testing/selftests/kvm run_tests"
> and how do I reproduce the "everything fails" for this issue ?

Hmm, I did nothing more than run the tests on a HSW system.

> Thanks,
> Like Xu
> >
> >  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> >index d33d890b605f..bdcce65c7a1d 100644
> >--- a/arch/x86/kvm/vmx/pmu_intel.c
> >+++ b/arch/x86/kvm/vmx/pmu_intel.c
> >@@ -181,7 +181,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >  		ret = pmu->version > 1;
> >  		break;
> >  	case MSR_IA32_PERF_CAPABILITIES:
> >-		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
> >+		ret = 1;
> >  		break;
> >  	default:
> >  		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
> 
