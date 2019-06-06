Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8878F37CF2
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 21:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfFFTFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 15:05:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:47531 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbfFFTFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 15:05:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 12:05:38 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2019 12:05:37 -0700
Date:   Thu, 6 Jun 2019 12:05:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 12/13] KVM: nVMX: Don't mark vmcs12 as dirty when L1
 writes pin controls
Message-ID: <20190606190537.GL23169@linux.intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-13-sean.j.christopherson@intel.com>
 <496e9a1f-620e-d09c-c9d3-c490e289ec2e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496e9a1f-620e-d09c-c9d3-c490e289ec2e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 07:24:38PM +0200, Paolo Bonzini wrote:
> On 07/05/19 21:18, Sean Christopherson wrote:
> > Pin controls doesn't affect dirty logic, e.g. the preemption timer value
> > is loaded from vmcs12 even if vmcs12 is "clean", i.e. there is no need
> > to mark vmcs12 dirty when L1 writes pin controls.
> > 
> > KVM currently toggles the VMX_PREEMPTION_TIMER control flag when it
> > disables or enables the timer.  The VMWRITE to toggle the flag can be
> > responsible for a large percentage of vmcs12 dirtying when running KVM
> > as L1 (depending on the behavior of L2).
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I think either we wait for patch 13 to get in the wild so that
> VMX_PREEMPTION_TIMER writes do not become so frequent, or we can do
> something like

I'd prefer to get something in now.  I assume a fair number of users will
be running current/older versions of KVM as L1 for years to come.

I have no objection to shadowing pin controls.  I opted for the cheesy
approach because I couldn't provide numbers that actually showed a
performance improvement by shadowing.

> --------- 8< ------------
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: [PATCH] KVM: nVMX: shadow pin based execution controls
> 
> The VMX_PREEMPTION_TIMER flag may be toggled frequently, though not
> *very* frequently.  Since it does not affect KVM's dirty logic, e.g.
> the preemption timer value is loaded from vmcs12 even if vmcs12 is
> "clean", there is no need to mark vmcs12 dirty when L1 writes pin
> controls, and shadowing the field achieves that.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> index 4cea018ba285..eb1ecd16fd22 100644
> --- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> +++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> @@ -47,6 +47,7 @@
>  SHADOW_FIELD_RO(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
>  SHADOW_FIELD_RO(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
>  SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
> +SHADOW_FIELD_RW(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control)
>  SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
>  SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE,
> vm_entry_exception_error_code)
>  SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
