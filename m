Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E51942DB24
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 16:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhJNOLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 10:11:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42840 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJNOLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 10:11:13 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634220546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K+Z9xcyAhlGhiE9Ys3ZMpsS6I+8zaTKKFDoB018524Q=;
        b=k+j8vzoYgb9TasLzlp1gxnwy27KKqytkbbQk3yS3iea+SH8k4GVs4e7JadVcy7bpdzp56O
        yR+YWd3wuismwBBDIeqA/IdvT9ddoXweCn8TBwvutTh3chQHsvgng4pkTnkXcrIj09l1Dk
        YQ+yeUGReSjo39ocKrT6hQMKIgVBvUnrBiy/WSiB+fZrpLZaxjqkGiU9xwEYbgiGeADmJ8
        JS0qoLlYd4m24wSnsM9Oixhu2vP0Stzc1SVNIPz6wWgxCcIkBG14YhU2KLD2MZg0vH4SSD
        qpxiG15zDJ8AphXsuGt+Zf+joZoOfXzq9svbLHa9VlG+mXMLceYy/GRFDne66Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634220546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K+Z9xcyAhlGhiE9Ys3ZMpsS6I+8zaTKKFDoB018524Q=;
        b=KN60iuzhEc02Xp90DjyYuXWP5nfYxfwmaELt+nfeHAbY0dksjM/SdXcytd4cTcbtSVz5SZ
        YTxYUd+Pnv1ITdDA==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
Date:   Thu, 14 Oct 2021 16:09:06 +0200
Message-ID: <87wnmf66m5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14 2021 at 11:01, Paolo Bonzini wrote:
> On 14/10/21 10:02, Liu, Jing2 wrote:
> Based on the input from Andy and Thomas, the new way would be like this:
>
> 1) host_fpu must always be checked for reallocation in 
> kvm_load_guest_fpu (or in the FPU functions that it calls, that depends 
> on the rest of Thomas's patches).  That's because arch_prctl can enable 
> AMX for QEMU at any point after KVM_CREATE_VCPU.

No.

   1) QEMU starts
   2) QEMU requests permissions via prctl()
   3) QEMU creates vCPU threads

Doing it the other way around makes no sense at all and wont work.

> 2) every use of vcpu->arch.guest_supported_xcr0 is changed to only 
> include those dynamic-feature bits that were enabled via arch_prctl.
> That is, something like:
>
> static u64 kvm_guest_supported_cr0(struct kvm_vcpu *vcpu)
> {
> 	return vcpu->arch.guest_supported_xcr0 &
> 		(~xfeatures_mask_user_dynamic | \
> 		 current->thread.fpu.dynamic_state_perm);

Bah. You can't get enough from poking in internals, right?

vcpu_create()

  fpu_init_fpstate_user(guest_fpu, supported_xcr0)

That will (it does not today) do:

     guest_fpu::__state_perm = supported_xcr0 & xstate_get_group_perm();

for you. Once.

The you have the information you need right in the guest FPU.

See?

> So something like this pseudocode is called by both XCR0 and XFD writes:
>
> int kvm_alloc_fpu_dynamic_features(struct kvm_vcpu *vcpu)
> {
> 	u64 allowed_dynamic = current->thread.fpu.dynamic_state_perm;

That's not a valid assumption.

> 	u64 enabled_dynamic =
> 		vcpu->arch.xcr0 & xfeatures_mask_user_dynamic;
>
> 	/* All dynamic features have to be arch_prctl'd first.  */
> 	WARN_ON_ONCE(enabled_dynamic & ~allowed_dynamic);
>
> 	if (!vcpu->arch.xfd_passthrough) {
> 		/* All dynamic states will #NM?  Wait and see.  */
> 		if ((enabled_dynamic & ~vcpu->arch.xfd) == 0)
> 			return 0;
>
> 		kvm_x86_ops.enable_xfd_passthrough(vcpu);
> 	}
>
> 	/* current->thread.fpu was already handled by arch_prctl.  */

No. current->thread.fpu has the default buffer unless QEMU used AMX or
something forced it to allocate a larger buffer.

> 	return fpu_alloc_features(vcpu->guest_fpu,
> 		vcpu->guest_fpu.dynamic_state_perm | enabled_dynamic);

This unconditionally calls into that allocation for every XCR0/XFD
trap ?

> }

Also you really should not wait until _all_ dynamic states are cleared
in guest XFD. Because a guest which has bit 18 and 19 available but only
uses one of them is going to trap on every other context switch due to
XFD writes.

So you check for

   (guest_xfd & guest_perm) != guest_perm)

and

   (guest_xr0 & guest_perm) != 0

If both are true, then you reallocate the buffers for _all_ permitted
states _and_ set XFD to pass through.

Thanks,

        tglx

