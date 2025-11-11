Return-Path: <kvm+bounces-62818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0094CC4F840
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 19:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B92773A6864
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468172C0288;
	Tue, 11 Nov 2025 18:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HAXezBSR"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0BC252292
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887350; cv=none; b=GJxLJ4ifKpnix7dvSrDkaLMFyKgXQDLX7gidocm18k4/OHapLfFzx/IJtDaQrYQ5g70yDdlccjRsshDfM/ZybELh/EwnaAXiGbxGWZOtgrw9tFlyHUerFwkHyBE7lRSLYhPNsYag7t/LlSsjxyQSDnYj4rSzauXakyqSm+FF+m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887350; c=relaxed/simple;
	bh=D3LH1D14RTYnGMZJXON1DwndSko5rujuhxnqiK1VLQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKwtYIbHQ6fSG6j8+gmxaZ8sM9EJiWXcCynR5HBk9CiiiOmvkWPisKQNRXqj7LBXDtB8HeK0JkEyvdmQlYo1kocU0wFLJXGr1x/RMdSZ5ia1S8gJnocR7zWR0DNmlwpLmp843K9wCbPpXuOAJ9indFU9kjo7c1EK72lnHGgsSLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HAXezBSR; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 11 Nov 2025 18:55:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hOi6XjO42RDCAcEGgINwcv4u2ylLtSQlkzdIS1Ook3U=;
	b=HAXezBSRKSG12htgc94ooYjp8Q3BzxPqyavlanGPJB3berpmrEiDwsyRERNw1Gv0v9kckF
	Fth4uPhwS4bh8sXnNvEJEfo9KVyJGhCp5QEQmcYHIc7yGkoxXUrGt32JFe9qROXt1fnqjG
	P01t4kaD4LXaRywdEjUVWSCy543bbXM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: nSVM: Always recalculate LBR MSR intercepts in
 svm_update_lbrv()
Message-ID: <6ving6sg3ywr23epd3fmorzhovdom5uaty4ae4itit2amxafql@iui7as55sb55>
References: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
 <20251108004524.1600006-3-yosry.ahmed@linux.dev>
 <aktjuidgjmdqdlc42mmy4hby5zc2e5at7lgrmkfxavlzusveus@ai7h3sk6j37b>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aktjuidgjmdqdlc42mmy4hby5zc2e5at7lgrmkfxavlzusveus@ai7h3sk6j37b>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 11, 2025 at 03:11:37AM +0000, Yosry Ahmed wrote:
> On Sat, Nov 08, 2025 at 12:45:20AM +0000, Yosry Ahmed wrote:
> > svm_update_lbrv() is called when MSR_IA32_DEBUGCTLMSR is updated, and on
> > nested transitions where LBRV is used. It checks whether LBRV enablement
> > needs to be changed in the current VMCB, and if it does, it also
> > recalculate intercepts to LBR MSRs.
> > 
> > However, there are cases where intercepts need to be updated even when
> > LBRV enablement doesn't. Example scenario:
> > - L1 has MSR_IA32_DEBUGCTLMSR cleared.
> > - L1 runs L2 without LBR_CTL_ENABLE (no LBRV).
> > - L2 sets DEBUGCTLMSR_LBR in MSR_IA32_DEBUGCTLMSR, svm_update_lbrv()
> >   sets LBR_CTL_ENABLE in VMCB02 and disables intercepts to LBR MSRs.
> > - L2 exits to L1, svm_update_lbrv() is not called on this transition.
> > - L1 clears MSR_IA32_DEBUGCTLMSR, svm_update_lbrv() finds that
> >   LBR_CTL_ENABLE is already cleared in VMCB01 and does nothing.
> > - Intercepts remain disabled, L1 reads to LBR MSRs read the host MSRs.
> > 
> > Fix it by always recalculating intercepts in svm_update_lbrv().
> 
> This actually breaks hyperv_svm_test, because svm_update_lbrv() is
> called on every nested transition, calling
> svm_recalc_lbr_msr_intercepts() -> svm_set_intercept_for_msr() and
> setting svm->nested.force_msr_bitmap_recalc to true.
> 
> This breaks the hyperv optimization in nested_svm_vmrun_msrpm() AFAICT.
> 
> I think there are two ways to fix this:
> - Add another bool to svm->nested to track LBR intercepts, and only call
>   svm_set_intercept_for_msr() if the intercepts need to be updated.
> 
> - Update svm_set_intercept_for_msr() itself to do nothing if the
>   intercepts do not need to be changed, which is more clutter but
>   applies to other callers as well so could shave cycles elsewhere (see
>   below).
> 
> Sean, Paolo, any preferences?
> 
> Here's what updating svm_set_intercept_for_msr() looks like:

and that diff breaks userspace_msr_exit_test :)

Here's an actually tested diff:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2fbb0b88c6a3e..88717429ba9d5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -664,24 +664,38 @@ void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool se
 {
        struct vcpu_svm *svm = to_svm(vcpu);
        void *msrpm = svm->msrpm;
+       bool recalc = false;
+       bool already_set;

        /* Don't disable interception for MSRs userspace wants to handle. */
        if (type & MSR_TYPE_R) {
-               if (!set && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+               set = set || !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ);
+               already_set = svm_test_msr_bitmap_read(msrpm, msr);
+
+               if (!set && already_set)
                        svm_clear_msr_bitmap_read(msrpm, msr);
-               else
+               else if (set && !already_set)
                        svm_set_msr_bitmap_read(msrpm, msr);
+
+               recalc |= (set != already_set);
        }

        if (type & MSR_TYPE_W) {
-               if (!set && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+               set = set || !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE);
+               already_set = svm_test_msr_bitmap_write(msrpm, msr);
+
+               if (!set && already_set)
                        svm_clear_msr_bitmap_write(msrpm, msr);
-               else
+               else if (set && !already_set)
                        svm_set_msr_bitmap_write(msrpm, msr);
+
+               recalc |= (set != already_set);
        }

-       svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-       svm->nested.force_msr_bitmap_recalc = true;
+       if (recalc) {
+               svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+               svm->nested.force_msr_bitmap_recalc = true;
+       }
 }

 void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)

---

For the record, I don't want to just use svm_test_msr_bitmap_*() in
svm_update_lbrv() because there is no direct equivalent in older kernels
as far as I can tell, so a backport would be completely inapplicable.

