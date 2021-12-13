Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84A473685
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 22:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243120AbhLMVX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 16:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbhLMVX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 16:23:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B48C061574;
        Mon, 13 Dec 2021 13:23:25 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639430602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5nohn3V+Nchmlh4oPn+MsHeWYr9veg87VFNOSrB/6zU=;
        b=Z7ohmGLV+GRMk35jV4lyKQnhUa5FhdvrbizQmoOGOWhOimtgt8ldPJK3ajmPDTyeFigAVT
        ElCeqsXdIR4F6BW/IC7Axfc5hwpWUvacBKpxHpQoP/yIyzibOQU4Q024M3ma8o/+yV35hl
        94YMhMf58A/KFIoRPPe/CuiFNLKKNsJvP54+DdTn0GKSwct4iBWHrrbkgDXUi9X2KWIzg9
        p0G0zaWHQomT/grn6HO5JVBNqUy00bVrKNRlSUPWQry3mRX9hVS79r4szuranbz7XnAvjb
        NZ48uAZGv362zhx6SdXgd/a15APF71pq6CwIxENAIgza2lOCdkq54m1j6aeAUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639430602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5nohn3V+Nchmlh4oPn+MsHeWYr9veg87VFNOSrB/6zU=;
        b=tO9NWnd2naqIbE68KEjNJOANZA0U6mzhrNY514DZ9Crx2YuhcG99RUsI+bmDOt07CUktfI
        qPf1yL+y/YZDs8Aw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
In-Reply-To: <87y24othjj.ffs@tglx>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <022620db-13ad-8118-5296-ae2913d41f1f@redhat.com> <87y24othjj.ffs@tglx>
Date:   Mon, 13 Dec 2021 22:23:22 +0100
Message-ID: <87r1agtd11.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Mon, Dec 13 2021 at 20:45, Thomas Gleixner wrote:
> On Mon, Dec 13 2021 at 16:06, Paolo Bonzini wrote:
>> That said, I think xfd_update_state should not have an argument. 
>> current->thread.fpu.fpstate->xfd is the only fpstate that should be 
>> synced with the xfd_state per-CPU variable.
>
> I'm looking into this right now. The whole restore versus runtime thing
> needs to be handled differently.

We need to look at different things here:

   1) XFD MSR write emulation

   2) XFD MSR synchronization when write emulation is disabled

   3) Guest restore

#1 and #2 are in the context of vcpu_run() and

   vcpu->arch.guest_fpu.fpstate == current->thread.fpu.fpstate

while #3 has:

   vcpu->arch.guest_fpu.fpstate != current->thread.fpu.fpstate


#2 is only updating fpstate->xfd and the per CPU shadow.

So the state synchronization wants to be something like this:

void fpu_sync_guest_xfd_state(void)
{
	struct fpstate *fps = current->thread.fpu.fpstate;

	lockdep_assert_irqs_disabled();
	if (fpu_state_size_dynamic()) {
		rdmsrl(MSR_IA32_XFD, fps->xfd);
		__this_cpu_write(xfd_state, fps->xfd);
	}
}
EXPORT_SYMBOL_GPL(fpu_sync_guest_xfd_state);

No wrmsrl() because the MSR is already up do date. The important part is
that fpstate->xfd and the shadow state are updated so that after
reenabling preemption the context switch FPU logic works correctly.


#1 and #3 can trigger a reallocation of guest_fpu.fpstate and
can fail. But this is also true for XSETBV emulation and XCR0 restore.

For #1 modifying fps->xfd in the KVM code before calling into the FPU
code is just _wrong_ because if the guest removes the XFD restriction
then it must be ensured that the buffer is sized correctly _before_ this
is updated.

For #3 it's not really important, but I still try to wrap my head around
the whole picture vs. XCR0.

There are two options:

  1) Require strict ordering of XFD and XCR0 update to avoid pointless
     buffer expansion, i.e. XFD before XCR0.

     Because if XCR0 is updated while guest_fpu->fpstate.xfd is still in
     init state (0) and XCR0 contains extended features, then the buffer
     would be expanded because XFD does not mask the extended features
     out. When XFD is restored with a non-zero value, it's too late
     already.

  2) Ignore buffer expansion up to the point where XSTATE restore happens
     and evaluate guest XCR0 and guest_fpu->fpstate.xfd there.

I'm leaning towards #1 because that means we have exactly _ONE_ place
where we need to deal with buffer expansion. If Qemu gets the ordering
wrong it wastes memory per vCPU, *shrug*.

Thanks,

        tglx




