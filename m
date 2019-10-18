Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585B2DCF9D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 21:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443357AbfJRTwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 15:52:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:4510 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbfJRTwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 15:52:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 12:52:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="226654257"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 18 Oct 2019 12:52:06 -0700
Date:   Fri, 18 Oct 2019 12:52:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: VMX: Some minor refactor of MSR bitmap
Message-ID: <20191018195206.GG26319@linux.intel.com>
References: <20191018093723.102471-1-xiaoyao.li@intel.com>
 <20191018093723.102471-4-xiaoyao.li@intel.com>
 <20191018172741.GF26319@linux.intel.com>
 <f718d52f-690c-7595-2c18-9110b165058f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f718d52f-690c-7595-2c18-9110b165058f@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 19, 2019 at 02:39:57AM +0800, Xiaoyao Li wrote:
> On 10/19/2019 1:27 AM, Sean Christopherson wrote:
> >>@@ -6745,22 +6762,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
> >>  	if (err < 0)
> >>  		goto free_msrs;
> >>-	msr_bitmap = vmx->vmcs01.msr_bitmap;
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> >>-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> >>-	if (kvm_cstate_in_guest(kvm)) {
> >>-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
> >>-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> >>-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> >>-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
> >>-	}
> >>-	vmx->msr_bitmap_mode = 0;
> >
> >Keep this code here to be consistent with the previous change that moved
> >the guest_msrs intialization *out* of the VMCS specific function.  Both
> >are collateral pages that are not directly part of the VMCS.
> >
> 
> OK. Then this patch is unnecessary too.

I'd keep the change to skip this code if the CPU doesn't have msr bitmaps.
Performance wise it may be largely irrelevant, but it's a good change from
a readability perspective.

> 
> >I'd be tempted to use a goto to skip the code, the line length is bad
> >enough as it is, e.g.:
> >
> >	if (!cpu_has_vmx_msr_bitmap())
> >		goto skip_msr_bitmap;
> >
> >	vmx->msr_bitmap_mode = 0;
> >skip_msr_bitmap:
> >
> >>-
> >>  	vmx->loaded_vmcs = &vmx->vmcs01;
> >>  	cpu = get_cpu();
> >>  	vmx_vcpu_load(&vmx->vcpu, cpu);
> >>-- 
> >>2.19.1
> >>
