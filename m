Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89FA13DFD6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgAPQVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:21:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:43485 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPQVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:21:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 08:21:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="219732066"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jan 2020 08:21:02 -0800
Date:   Thu, 16 Jan 2020 08:21:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 3/3] x86/kvm/hyper-v: don't allow to turn on
 unsupported VMX controls for nested guests
Message-ID: <20200116162101.GD20561@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-4-vkuznets@redhat.com>
 <CF37ED31-4ED0-45C2-A309-3E1E2C2E54F8@oracle.com>
 <874kwvixuq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kwvixuq.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 09:55:57AM +0100, Vitaly Kuznetsov wrote:
> Liran Alon <liran.alon@oracle.com> writes:
> 
> >> On 15 Jan 2020, at 19:10, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >> 
> >> Sane L1 hypervisors are not supposed to turn any of the unsupported VMX
> >> controls on for its guests and nested_vmx_check_controls() checks for
> >> that. This is, however, not the case for the controls which are supported
> >> on the host but are missing in enlightened VMCS and when eVMCS is in use.
> >> 
> >> It would certainly be possible to add these missing checks to
> >> nested_check_vm_execution_controls()/_vm_exit_controls()/.. but it seems
> >> preferable to keep eVMCS-specific stuff in eVMCS and reduce the impact on
> >> non-eVMCS guests by doing less unrelated checks. Create a separate
> >> nested_evmcs_check_controls() for this purpose.
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >> arch/x86/kvm/vmx/evmcs.c  | 56 ++++++++++++++++++++++++++++++++++++++-
> >> arch/x86/kvm/vmx/evmcs.h  |  1 +
> >> arch/x86/kvm/vmx/nested.c |  3 +++
> >> 3 files changed, 59 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> >> index b5d6582ba589..88f462866396 100644
> >> --- a/arch/x86/kvm/vmx/evmcs.c
> >> +++ b/arch/x86/kvm/vmx/evmcs.c
> >> @@ -4,9 +4,11 @@
> >> #include <linux/smp.h>
> >> 
> >> #include "../hyperv.h"
> >> -#include "evmcs.h"
> >> #include "vmcs.h"
> >> +#include "vmcs12.h"
> >> +#include "evmcs.h"
> >> #include "vmx.h"
> >> +#include "trace.h"
> >> 
> >> DEFINE_STATIC_KEY_FALSE(enable_evmcs);
> >> 
> >> @@ -378,6 +380,58 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
> >> 	*pdata = ctl_low | ((u64)ctl_high << 32);
> >> }
> >> 
> >> +int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
> >> +{
> >> +	int ret = 0;
> >> +	u32 unsupp_ctl;
> >> +
> >> +	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
> >> +		EVMCS1_UNSUPPORTED_PINCTRL;
> >> +	if (unsupp_ctl) {
> >> +		trace_kvm_nested_vmenter_failed(
> >> +			"eVMCS: unsupported pin-based VM-execution controls",
> >> +			unsupp_ctl);
> >
> > Why not move "CC” macro from nested.c to nested.h and use it here as-well instead of replicating it’s logic?
> >
> 
> Because error messages I add are both human readable and conform to SDM!
> :-)
> 
> On a more serious not yes, we should probably do that. We may even want
> to use it in non-nesting (and non VMX) code in KVM.

No, the CC() macro is short for Consistency Check, i.e. specific to nVMX.
Even if KVM ends up adding nested_evmcs_check_controls(), which I'm hoping
can be avoided, I'd still be hesitant to expose CC() in nested.h.
