Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C6526B745
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgIPAUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:20:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:12001 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgIPATa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 20:19:30 -0400
IronPort-SDR: 20pYhSKqPiwk/SDZ7GzIm0aHIdQkv6WAxVP+hf0v2mYq60jzWQKS377KOyntgGGV+GXstCv5Lw
 4IOSpX4I4aLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="220930309"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="220930309"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 17:19:28 -0700
IronPort-SDR: 5V0QjOsQmqOXQo0oWNhYHs7itGqThN7qeZlHs640iNf84b/zRYT6OKx1spC29y0IvEo4B2IAup
 vfeiLeB5r+Hw==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="507789024"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 17:19:27 -0700
Date:   Tue, 15 Sep 2020 17:19:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
Message-ID: <20200916001925.GL8420@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 12:22:05PM -0500, Tom Lendacky wrote:
> On 9/14/20 5:59 PM, Sean Christopherson wrote:
> > Given that we don't yet have publicly available KVM code for TDX, what if I
> > generate and post a list of ioctls() that are denied by either SEV-ES or TDX,
> > organized by the denier(s)?  Then for the ioctls() that are denied by one and
> > not the other, we add a brief explanation of why it's denied?
> > 
> > If that sounds ok, I'll get the list and the TDX side of things posted
> > tomorrow.
> 
> That sounds good.

TDX completely blocks the following ioctl()s:

  kvm_vcpu_ioctl_interrupt
  kvm_vcpu_ioctl_smi
  kvm_vcpu_ioctl_x86_setup_mce
  kvm_vcpu_ioctl_x86_set_mce
  kvm_vcpu_ioctl_x86_get_debugregs
  kvm_vcpu_ioctl_x86_set_debugregs
  kvm_vcpu_ioctl_x86_get_xsave
  kvm_vcpu_ioctl_x86_set_xsave
  kvm_vcpu_ioctl_x86_get_xcrs
  kvm_vcpu_ioctl_x86_set_xcrs
  kvm_arch_vcpu_ioctl_get_regs
  kvm_arch_vcpu_ioctl_set_regs
  kvm_arch_vcpu_ioctl_get_sregs
  kvm_arch_vcpu_ioctl_set_sregs
  kvm_arch_vcpu_ioctl_set_guest_debug
  kvm_arch_vcpu_ioctl_get_fpu
  kvm_arch_vcpu_ioctl_set_fpu

Looking through the code, I think kvm_arch_vcpu_ioctl_get_mpstate() and
kvm_arch_vcpu_ioctl_set_mpstate() should also be disallowed, we just haven't
actually done so.

There are also two helper functions that are "blocked".
dm_request_for_irq_injection() returns false if guest_state_protected, and
post_kvm_run_save() shoves dummy state.

TDX also selectively blocks/skips portions of other ioctl()s so that the
TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
injection restrictions are due to direct injection not being allowed (except
for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
exception injection is completely disallowed.

  kvm_vcpu_ioctl_x86_get_vcpu_events:
	if (!vcpu->kvm->arch.guest_state_protected)
        	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);

  kvm_arch_vcpu_put:
        if (vcpu->preempted && !vcpu->kvm->arch.guest_state_protected)
                vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);

  kvm_vcpu_ioctl_x86_set_vcpu_events:
	u32 allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING |
			    KVM_VCPUEVENT_VALID_SIPI_VECTOR |
			    KVM_VCPUEVENT_VALID_SHADOW |
			    KVM_VCPUEVENT_VALID_SMM |
			    KVM_VCPUEVENT_VALID_PAYLOAD;

	if (vcpu->kvm->arch.guest_state_protected)
		allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING;


  kvm_arch_vcpu_ioctl_run:
	if (vcpu->kvm->arch.guest_state_protected)
		kvm_sync_valid_fields = KVM_SYNC_X86_EVENTS;
	else
		kvm_sync_valid_fields = KVM_SYNC_X86_VALID_FIELDS;


In addition to the more generic guest_state_protected, we also (obviously
tentatively) have a few other flags to deal with aspects of TDX that I'm
fairly certain don't apply to SEV-ES:

  tsc_immutable - KVM doesn't have write access to the TSC offset of the
                  guest.

  eoi_intercept_unsupported - KVM can't intercept EOIs (doesn't have access
                              to EOI bitmaps) and so can't support level
                              triggered interrupts, at least not without
                              extra pain.

  readonly_mem_unsupported - Secure EPT (analagous to SNP) requires RWX
                             permissions for all private/encrypted memory.
                             S-EPT isn't optional, so we get the joy of
                             adding this right off the bat...
