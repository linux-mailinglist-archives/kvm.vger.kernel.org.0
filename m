Return-Path: <kvm+bounces-9237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1BD85CDBF
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2C431C216E6
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 02:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00A75CB5;
	Wed, 21 Feb 2024 02:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fh5Q7uaR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E92A522C
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 02:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481427; cv=none; b=psqeCt1hMbcfoa9jSTecd4dn0Flt/npy+XeirEHAqbCR+nXVbrXLAYt0mnSsIwoFcu9XzsGjJISl2WZtuKj1JEIyA46Tz6MA559DqCJWGCYZCqJQq//uUo7ho7pN0EPujOOEy3BAVeiOwUB8WooQm3frQVwsnyLtynXdkw90K2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481427; c=relaxed/simple;
	bh=j41BACY3bbl0dJLSj+GBS3NKl9wXXB4Sfy90HrTAWok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fp0ubp5ZdiznfU82/avSaRvYksHeVCQdVAX+Oid2WY03bLiuyeCTw/rYpNHElqnB3GFBkqdtvHGOp5bepuXQcQ6GQjU8R37gZBg4NPntk1WKeyfjjM/ybpWtkauqNptdcEbs2Ekrp0hFK4Nuw8AYIGKfe/y+9cCMWqmFMmI08mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fh5Q7uaR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608835a1febso488407b3.2
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 18:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708481425; x=1709086225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gKDDhVDI/caWn5TUGufa5pdgsoyIgpZ0Gl6DWfyCRzw=;
        b=Fh5Q7uaRUFyhtMNW/LtWAS/w+WBOcLEMJXBhLKAuHPSYjInNYEhTUihpZ2yiFyAZHn
         HWQ4+EmST8/QVPjIgViS91TZ1aOp9x7m67izw+IuDv0gSQcRajNu4gAmDgRzi697Xa19
         sHI10FUJS0qQO3+UDNad5Sg3Pff2zduqlGMkNs7zfk8LKvpe00olcm96sUxTsyTZxBEd
         He2KSJzmtiQliVd8ndpOUiAGKFRzZ+F7NACHg76fzqdxzEOVqT5UVCrBF/F3zzrRrSkn
         90cXg+VB/XEmQpWXbHRBiF3Uv1/VyIuqSER+FBmsXBEJ5QpgikyQ3Gjuo94dY9DkKzqm
         yBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708481425; x=1709086225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gKDDhVDI/caWn5TUGufa5pdgsoyIgpZ0Gl6DWfyCRzw=;
        b=eOSQY468JlnrGYlBw/uasZkXwjNrUVe1zHNVmXJQuY4kVVaMkeAcqFWYYbAKVe3yh+
         Q0AklJ2lGA7UJWMCqhFj4/VLbysIMz1ovzK1ViQerJw5piI0n8YvFCdqdXN1o3hLU0KR
         bRICXo+1cbVNyZGbWpsPghouAlQv+HrPkgRFyZ0APq8+it2//i3njH/0LqgP1TBPaMK3
         X3FcEny9CPDNARRXvSKx2woKdWrADhgwAJwPZmR7S5kmCzsmxowdHb/I8rrbkb8XeGx6
         iIrfONTUdDCWf8+aonfWHKdiPev68Rr8W8KO7enx/++ou3r0KXTxAFJ2me5OmcF9JDhm
         Nk6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZ3J2fajaV7yqARk5ImTXmm1NJsJDRv38EGMnga3jUdoGdXb4T9l707meppp4VAs5Hs7vLIiXfuwyqvvaBfOrx4mst
X-Gm-Message-State: AOJu0YyLF1D+v5jLWnb9Msnd/Y14+fedjsJsue+lE1obneYPdVt4VY6k
	+UDDK/ihHBlmXZnT6RQrSwIjln3P8Qz9z27456IyKirUGNjwU2HVn/xwF45Z6i8hjtFf+wtkxDj
	BMg==
X-Google-Smtp-Source: AGHT+IH9tDjvnpoECriK92ZpQJXMS185w6jocKSNJWnIH+QG97spJ9w+fd4S7cImLl0dsTHDcu1hSiv3D5k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:494c:0:b0:608:72fe:b8a1 with SMTP id
 w73-20020a81494c000000b0060872feb8a1mr495006ywa.4.1708481425305; Tue, 20 Feb
 2024 18:10:25 -0800 (PST)
Date: Tue, 20 Feb 2024 18:10:23 -0800
In-Reply-To: <ZdRMwdkz1enYIgBM@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com> <20240209222858.396696-4-seanjc@google.com>
 <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com> <ZdOvttFKP1VVgrsA@google.com> <ZdRMwdkz1enYIgBM@yzhao56-desk.sh.intel.com>
Message-ID: <ZdVbj1F_7UlX_eAy@google.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Friedrich Weber <f.weber@proxmox.com>, Kai Huang <kai.huang@intel.com>, 
	Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 20, 2024, Yan Zhao wrote:
> On Mon, Feb 19, 2024 at 11:44:54AM -0800, Sean Christopherson wrote:
> > If KVM is using TDP, but L1 is using shadow paging for L2, then routing through
> > kvm_handle_noslot_fault() will incorrectly cache the gfn as MMIO, and create an
> > MMIO SPTE.  Creating an MMIO SPTE is ok, but only because kvm_mmu_page_role.guest_mode
> > ensure KVM uses different roots for L1 vs. L2.  But mmio_gfn will remain valid,
> > and could (quite theoretically) cause KVM to incorrectly treat an L1 access to
> > the private TSS or identity mapped page tables as MMIO.
> Why would KVM treat L1 access to the private TSS and identity mapped page
> tables as MMIO even though mmio_gfn is valid?

Because KVM doesn't need to take an EPT Violation or Misconfig to trigger emulation,
those just happen to be (by far) the most common ways KVM gets into the emulator
on modern CPUs.

> It looks that (for Intel platform) EPT for L1 will only install normal SPTEs
> (non-MMIO SPTEs) for the two private slots, so there would not have EPT
> misconfiguration and would not go to emulation path incorrectly.
> Am I missing something?

...

> > --
> > Subject: [PATCH] KVM: x86/mmu: Don't force emulation of L2 accesses to
> >  non-APIC internal slots
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 488f522f09c6..4ce824cec5b9 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4341,8 +4341,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
> >  		return RET_PF_RETRY;
> >  
> > -	if (!kvm_is_visible_memslot(slot)) {
> > -		/* Don't expose private memslots to L2. */
> > +	if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
> > +		/*
> > +		 * Don't map L1's APIC access page into L2, KVM doesn't support
> > +		 * using APICv/AVIC to accelerate L2 accesses to L1's APIC,
> > +		 * i.e. the access needs to be emulated.  Emulating access to
> > +		 * L1's APIC is also correct if L1 is accelerating L2's own
> > +		 * virtual APIC, but for some reason L1 also maps _L1's_ APIC
> > +		 * into L2.  Note, vcpu_is_mmio_gpa() always treats access to
> > +		 * the APIC as MMIO.  Allow an MMIO SPTE to be created, as KVM
> > +		 * uses different roots for L1 vs. L2, i.e. there is no danger
> > +		 * of breaking APICv/AVIC for L1.
> > +		 */
> >  		if (is_guest_mode(vcpu)) {
> >  			fault->slot = NULL;
> >  			fault->pfn = KVM_PFN_NOSLOT;
> Checking fault->is_private before calling kvm_handle_noslot_fault()?

Ya, the actual series will perform that check, this slots in halfway through.

> And do we need a centralized check of fault->is_private in kvm_mmu_do_page_fault()
> before returning RET_PF_EMULATE?

Oof, yes.

> > @@ -4355,8 +4365,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  		 * MMIO SPTE.  That way the cache doesn't need to be purged
> >  		 * when the AVIC is re-enabled.
> >  		 */
> > -		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> > -		    !kvm_apicv_activated(vcpu->kvm))
> > +		if (!kvm_apicv_activated(vcpu->kvm))
> >  			return RET_PF_EMULATE;
> Otherwise, here also needs a checking of fault->is_private?
> Maybe also for where RET_PF_EMULATE is returned when page_fault_handle_page_track()
> is true (though I know it's always false for TDX).

Ya, and practically speaking it should always be false for functional setups
(software-protected VMs don't yet play nice with shadow paging or any form of
emulation), but it's easy enough to guard against RET_PF_EMULATE in
kvm_mmu_do_page_fault().

I'm going to post _just_ patch 1 as v5 so that it can land in 6.8 (assuming I
don't screw it up again).

I'll post a separate series to tackle the refactor and is_private cleanups and
fixes as that has ballooned to 17 patches :-/

