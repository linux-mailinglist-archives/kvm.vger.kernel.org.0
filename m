Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D9E148CE4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 18:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbgAXRZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 12:25:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:30597 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388028AbgAXRZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 12:25:14 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 09:25:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,358,1574150400"; 
   d="scan'208";a="308178111"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 24 Jan 2020 09:25:12 -0800
Date:   Fri, 24 Jan 2020 09:25:12 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200124172512.GJ2109@linux.intel.com>
References: <20200115171014.56405-3-vkuznets@redhat.com>
 <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
 <20200122054724.GD18513@linux.intel.com>
 <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
 <87eevrsf3s.fsf@vitty.brq.redhat.com>
 <20200122155108.GA7201@linux.intel.com>
 <87blqvsbcy.fsf@vitty.brq.redhat.com>
 <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com>
 <87zheer0si.fsf@vitty.brq.redhat.com>
 <87lfpyq9bk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfpyq9bk.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 23, 2020 at 08:09:03PM +0100, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Paolo Bonzini <pbonzini@redhat.com> writes:
> >
> >> On 22/01/20 17:29, Vitaly Kuznetsov wrote:
> >>> Yes, in case we're back to the idea to filter things out in QEMU we can
> >>> do this. What I don't like is that every other userspace which decides
> >>> to enable eVMCS will have to perform the exact same surgery as in case
> >>> it sets allow_unsupported_controls=0 it'll have to know (hardcode) the
> >>> filtering (or KVM_SET_MSRS will fail) and in case it opts for
> >>> allow_unsupported_controls=1 Windows guests just won't boot without the
> >>> filtering.
> >>> 
> >>> It seems to be 1:1, eVMCSv1 requires the filter.
> >>
> >> Yes, that's the point.  It *is* a hack in KVM, but it is generally
> >> preferrable to have an easier API for userspace, if there's only one way
> >> to do it.
> >>
> >> Though we could be a bit more "surgical" and only remove
> >> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES---thus minimizing the impact on
> >> non-eVMCS guests.  Vitaly, can you prepare a v2 that does that and adds
> >> a huge "hack alert" comment that explains the discussion?
> >
> > Yes, sure. I'd like to do more testing to make sure filtering out
> > SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES is enough for other Hyper-V
> > versions too (who knows how many bugs are there :-)
> 
> ... and the answer is -- more than one :-)
> 
> I've tested Hyper-V 2016/2019 BIOS and UEFI-booted and the minimal
> viable set seems to be:
> 
> MSR_IA32_VMX_PROCBASED_CTLS2: 
> 	~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> 
> MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> 	~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
> 
> MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS:
> 	~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL
>  
> with these filtered out all 4 versions are at least able to boot with >1
> vCPU and run a nested guest (different from Windows management
> partition).
> 
> This still feels a bit fragile as who knows under which circumstances
> Hyper-V might want to enable additional (missing) controls.

No strong opinion, I'm good either way.

> If there are no objections and if we still think it would be beneficial
> to minimize the list of controls we filter out (and not go with the full
> set like my RFC suggests), I'll prepare v2. (v1, actually, this was RFC).

One last idea, can we keep the MSR filtering as is and add the hack in
vmx_restore_control_msr()?  That way the (userspace) host and guest see
the same values when reading the affected MSRs, and eVMCS wouldn't need
it's own hook to do consistency checks.

@@ -1181,28 +1181,38 @@ static int
 vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 {
        u64 supported;
-       u32 *lowp, *highp;
+       u32 *lowp, *highp, evmcs_unsupported;

        switch (msr_index) {
        case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
                lowp = &vmx->nested.msrs.pinbased_ctls_low;
                highp = &vmx->nested.msrs.pinbased_ctls_high;
+               if (vmx->nested.enlightened_vmcs_enabled)
+                       evmcs_unsupported = EVMCS1_UNSUPPORTED_PINCTRL;
                break;
        case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
                lowp = &vmx->nested.msrs.procbased_ctls_low;
                highp = &vmx->nested.msrs.procbased_ctls_high;
+               if (vmx->nested.enlightened_vmcs_enabled)
+                       evmcs_unsupported = 0;
                break;
        case MSR_IA32_VMX_TRUE_EXIT_CTLS:
                lowp = &vmx->nested.msrs.exit_ctls_low;
                highp = &vmx->nested.msrs.exit_ctls_high;
+               if (vmx->nested.enlightened_vmcs_enabled)
+                       evmcs_unsupported = EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
                break;
        case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
                lowp = &vmx->nested.msrs.entry_ctls_low;
                highp = &vmx->nested.msrs.entry_ctls_high;
+               if (vmx->nested.enlightened_vmcs_enabled)
+                       evmcs_unsupported = EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
                break;
        case MSR_IA32_VMX_PROCBASED_CTLS2:
                lowp = &vmx->nested.msrs.secondary_ctls_low;
                highp = &vmx->nested.msrs.secondary_ctls_high;
+               if (vmx->nested.enlightened_vmcs_enabled)
+                       evmcs_unsupported = EVMCS1_UNSUPPORTED_2NDEXEC;
                break;
        default:
                BUG();
@@ -1210,6 +1220,9 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)

        supported = vmx_control_msr(*lowp, *highp);

+       /* HACK! */
+       data &= ~(u64)evmcs_unsupported << 32;
+
        /* Check must-be-1 bits are still 1. */
        if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))

