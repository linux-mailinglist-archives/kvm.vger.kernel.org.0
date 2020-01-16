Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E9813DFD2
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgAPQTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:19:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:2489 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPQTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:19:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 08:19:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="219731566"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jan 2020 08:19:28 -0800
Date:   Thu, 16 Jan 2020 08:19:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200116161928.GC20561@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <20200115232738.GB18268@linux.intel.com>
 <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com>
 <877e1riy1o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877e1riy1o.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 09:51:47AM +0100, Vitaly Kuznetsov wrote:
> Liran Alon <liran.alon@oracle.com> writes:
> 
> >> On 16 Jan 2020, at 1:27, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >> 
> >> On Wed, Jan 15, 2020 at 06:10:13PM +0100, Vitaly Kuznetsov wrote:
> >>> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
> >>> with default (matching CPU model) values and in case eVMCS is also enabled,
> >>> fails.
> >> 
> >> As in, Qemu is blindly throwing values at KVM and complains on failure?
> >> That seems like a Qemu bug, especially since Qemu needs to explicitly do
> >> KVM_CAP_HYPERV_ENLIGHTENED_VMCS to enable eVMCS.
> >
> > See: https://patchwork.kernel.org/patch/11316021/
> > For more context.
> 
> Ya,
> 
> while it would certainly be possible to require that userspace takes
> into account KVM_CAP_HYPERV_ENLIGHTENED_VMCS (which is an opt-in) when
> doing KVM_SET_MSRS there doesn't seem to be an existing (easy) way to
> figure out which VMX controls were filtered out after enabling
> KVM_CAP_HYPERV_ENLIGHTENED_VMCS: KVM_GET_MSRS returns global
> &vmcs_config.nested values for VMX MSRs (vmx_get_msr_feature()).

Ah, I was looking at the call to vmx_get_vmx_msr(&vmx->nested.msrs, ...)
in vmx_get_msr().

Why not just do this in Qemu?  IMO that's not a major ask, e.g. Qemu is
doing a decent amount of manual adjustment anyways.  And Qemu isn't even
using the result of KVM_GET_MSRS so I don't think it's fair to say this is
solely KVM's fault.

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 1d10046a6c..6545bb323e 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2623,6 +2623,23 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
              MSR_VMX_EPT_UC | MSR_VMX_EPT_WB : 0);
     uint64_t fixed_vmx_ept_vpid = kvm_vmx_ept_vpid & fixed_vmx_ept_mask;

+    /* Hyper-V's eVMCS does't support certain features, adjust accordingly. */
+    if (cpu->hyperv_evmcs) {
+        f[FEAT_VMX_PINBASED_CTLS] &= ~(VMX_PIN_BASED_VMX_PREEMPTION_TIMER |
+                                       VMX_PIN_BASED_POSTED_INTR);
+        f[FEAT_VMX_EXIT_CTLS] &= ~VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+        f[FEAT_VMX_ENTRY_CTLS] &= ~VMX_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+        f[FEAT_VMX_SECONDARY_CTLS] &= ~(VMX_SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
+                                        VMX_SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+                                        VMX_SECONDARY_EXEC_APIC_REGISTER_VIRT |
+                                        VMX_SECONDARY_EXEC_ENABLE_PML |
+                                        VMX_SECONDARY_EXEC_ENABLE_VMFUNC |
+                                        VMX_SECONDARY_EXEC_SHADOW_VMCS |
+                                        /* VMX_SECONDARY_EXEC_TSC_SCALING | */
+                                        VMX_SECONDARY_EXEC_PAUSE_LOOP_EXITING);
+        f[FEAT_VMX_VMFUNC]         &= ~MSR_VMX_VMFUNC_EPT_SWITCHING;
+    }
+
     kvm_msr_entry_add(cpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
                       make_vmx_msr_value(MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
                                          f[FEAT_VMX_PROCBASED_CTLS]));
