Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B95A47353E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 20:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbhLMTuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 14:50:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36882 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhLMTuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 14:50:19 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639425018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=wYckKKvewtBcVFlW8nrro81h3BRkBO7Fro639TQehrs=;
        b=1gALEEOiekKQbNzJ+i/yHebFnVvq8DkQMOc03gSYbc2C1invCPu/rrUsdC98Mr463gcEWO
        Y/B5imh3Q7NG1dZFHQLgTnPXauoPkAEyleaXNWD98t3sHeG2AndgzaCwT1maSAI5s1K4Nt
        7xnde9hLIz3BNgunn8HOUWgZpKNfV2Bs7cgvk0w396wdATfO2rkrvkYRcO34MPtox4i7Ag
        b+LNuZLcGl+j50jTe/LJ7mn1qhZfZoePEPOLSrtRBEUYyUk6K3n3wq8PHCHPIXBR768Fky
        NyAImqg4BCDRFnSQgbDVIYaK4dZMKPyaikMFqIzWrtlSoTZqDGnI3HCqAZEvzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639425018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=wYckKKvewtBcVFlW8nrro81h3BRkBO7Fro639TQehrs=;
        b=WDQQ++O/y/vHVZQt6hWGa6SZlR3PBHfsvGC6O97zJvMy2IGHeVxCp0nPjwF4bY/c3YLcCW
        HrD6+R2E+SivLsBg==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
Subject: Re: [PATCH 02/19] x86/fpu: Prepare KVM for dynamically enabled states
In-Reply-To: <16c938e2-2427-c8dd-94a1-eba8f967283b@redhat.com>
Date:   Mon, 13 Dec 2021 20:50:17 +0100
Message-ID: <87v8zsthc6.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Mon, Dec 13 2021 at 13:45, Paolo Bonzini wrote:
> On 12/13/21 13:00, Thomas Gleixner wrote:
>> On Mon, Dec 13 2021 at 10:12, Paolo Bonzini wrote:
>>> Please rename to alloc_xfeatures
>> 
>> That name makes no sense at all. This has nothing to do with alloc.
>
> Isn't that the features for which space is currently allocated?

It is, but from the kernel POV this is user. :)

> Reading "user_xfeatures" in there is cryptic, it seems like it's 
> something related to the userspace thread or group that has invoked the 
> KVM ioctl.  If it's renamed to alloc_xfeatures, then this:
>
> +		missing = request & ~guest_fpu->alloc_xfeatures;
> +		if (missing) {
> +			vcpu->arch.guest_fpu.realloc_request |= missing;
> +			return true;
> +		}
>
> makes it obvious that the allocation is for features that are requested 
> but haven't been allocated in the xstate yet.

Let's rename it to xfeatures and perm and be done with it.

>> Why? Yet another export of FPU internals just because?
>
> It's one function more and one field less.  I prefer another export of 
> FPU internals, to a write to a random field with undocumented
> invariants.

We want less not more exports. :)

> For example, why WARN_ON_ONCE if enter_guest == true?  If you enter the 
> guest after the host has restored MSR_IA32_XFD with KVM_SET_MSR, the

Indeed restoring a guest might require buffer reallocation, I missed
that, duh!

On restore the following components are involved:

   XCR0, XFD, XSTATE

XCR0 and XFD have to be restored _before_ XSTATE and that needs to
be enforced.

But independent of the ordering of XCR0 and XFD restore the following
check applies to both the restore and the runtime logic:

int kvm_fpu_realloc(struct kvm_vcpu *vcpu, u64 xcr0, u64 xfd)
{
   	u64 expand, enabled = xcr0 & ~xfd;

        expand = enabled & ~vcpu->arch.guest_fpu.xfeatures;
        if (!expand)
        	return 0;
        
        return fpu_enable_guest_features(&vcpu->arch.guest_fpu, expand);
}

int fpu_enable_guest_features(struct guest_fpu *gfpu, u64 which)
{
        permission_checks();
        ...
        return fpstate_realloc(.....)
}

fpstate_realloc() needs to be careful about flipping the pointers
depending on the question whether guest_fpu->fpstate is actually active,
i.e.:

        current->thread.fpu.fpstate == gfpu->fpstate

I'm halfways done with that. Will send something soonish.

Thanks,

        tglx

       

