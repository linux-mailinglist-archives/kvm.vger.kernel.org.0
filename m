Return-Path: <kvm+bounces-63424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D4292C6628B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 21:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 582F935A6B9
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76FCC32C932;
	Mon, 17 Nov 2025 20:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OZsNnu7I"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA13431A54B
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763413016; cv=none; b=p86kATdKxuUIaWuLYuZ+vDBLLPIRsNd5l9R829cIcIAfi6UJ9oPMMaOEhUhqFPrHDbPGUuv/DjyiDQzpPvIX2tA0MYP9kHpMSpb9Bm83B3PzGUKeNe6Jjwm57ievIEFvKOHzY5aHALXAF+jRGZTESMNFjIjKhxAy6wc/bWY0GPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763413016; c=relaxed/simple;
	bh=7AA6c/lfXJUeymPyVT+nndsCTKG59YOpPBWGbO2fA5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aqi8YC/nDYxSC5WEg7uWUM/m6WhC8IYFp5I1RVMkQEJs6mWHNs/b4RinIGeKMbM3ZvmQKJGwXo9880fYhrt+xALg9Krz4TID2dhKC4eahQ8f1PLd9bGJtzmjrqzYMjVVdISb6kn0YWC+frtvdAfSnaECNtShqO6ebofsmq4SSCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OZsNnu7I; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Nov 2025 20:56:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763413008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0qydeoI/bTcKkglrYbwTwTRg/httXtHnD+YB0z4hMv8=;
	b=OZsNnu7IpsBfstcOADfIUEla5R+E+NIbVFEbZoMGZEFrVQ9k1vaoGulBmMX4dA6809F0oL
	TpKZZbQ2E+J7HSMqLInV+WfCAYSdK0kWsKisTAwTenYMjsSicL3SbuLnuVT2jIwk48c3gu
	3wZAJCKSwQF+K/qSiN6Uk4TJ/tIpbcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Alexander Graf <agraf@suse.de>, Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>, 
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] KVM: x86: nSVM: Improve virtualization of VMCB12
 G_PAT
Message-ID: <tjefqpdnrdi2urqtjbgvcw4qlphcnmglnipeherrnn6plj72yn@hdgl4o4sohvc>
References: <20251107201151.3303170-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107201151.3303170-1-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 07, 2025 at 12:11:23PM -0800, Jim Mattson wrote:
> There are several problems with KVM's virtualization of the G_PAT
> field when nested paging is enabled in VMCB12.
> 
> * The VMCB12 G_PAT field is not checked for validity when emulating
>   VMRUN.  (APM volume 2, section 15.25.4: Nested Paging and
>   VMRUN/#VMEXIT)
> 
> * RDMSR(PAT) and WRMSR(PAT) from L2 access L1's PAT MSR rather than
>   L2's Guest PAT register. (APM volume 2, section 15.25.2: Replicated
>   State)
> 
> * The L2 Guest PAT register is not written back to VMCB12 on #VMEXIT
>   from L2 to L1. (APM volume 3, Section 4: "VMRUN")
> 
> * The value of L2's Guest PAT register is not serialized for
>   save/restore when a checkpoint is taken while L2 is active.
> 
> Commit 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2
> guest") left this comment in nested_vmcb02_compute_g_pat():
> 
>       /* FIXME: merge g_pat from vmcb01 and vmcb12.  */
> 
> This comment makes no sense. It is true that there are now three
> different PATs to consider: L2's PAT for guest page tables, L1's PAT
> for the nested page tables mapping L2 guest physical addresses to L1
> guest physical addresses, and L0's PAT for the nested page tables
> mapping L1 guest physical addresses to host physical
> addresses. However, if there is any "merging" to be done, it would
> involve the latter two, and would happen during shadow nested page
> table construction. (For the record, I don't think "merging" the two
> nested page table PATs is feasible.) In any case, the VMCB12 G_PAT
> should be copied unmodified into VMCB02.
> 
> Maybe the rest of the current implementation is a consistent quirk
> based on the existing nested_vmcb02_compute_g_pat() code that bypasses
> L1's request in VMCB12 and copies L1's PAT MSR into vmcb02
> instead. However, an L1 hypervisor that does not intercept accesses to
> the PAT MSR would legitimately be surprised to find that its L2 guest
> can modify the hypervisor's own PAT!
> 
> The commits in this series are in an awkward order, because I didn't
> want to change nested_vmcb02_compute_g_pat() until I had removed the
> call site from svm_set_msr().
> 
> The first two commits should arguably be one, but I tried to deal with
> the serialization issue separately from the RDMSR/WRMSR issue, despite
> the two being intertwined.
> 
> I don't like the ugliness of KVM_GET_MSRS saving the L2 Guest PAT
> register during a checkpoint, but KVM_SET_MSRS restoring the
> architectural PAT MSR on restore (because when KVM_SET_MSRS is called,
> L2 is not active). The APM section on replicated state offers a
> possible out:
> 
>   While nested paging is enabled, all (guest) references to the state
>   of the paging registers by x86 code (MOV to/from CRn, etc.) read and
>   write the guest copy of the registers
> 
> If we consider KVM_{GET,SET}_MSRS not to be "guest" references, we
> could always access the architected PAT MSR from userspace, and we
> could grab 64 bits from the SVM nested state header to serialize L2's
> G_PAT. In some ways, that seems cleaner, but it does mean that
> KVM_{GET,SET}_MSR will access L1's PAT, which is irrelevant while L2
> is active.
> 
> Hence, I am posting this series as an RFC.

A little bit more context here, the APM is a bit unclear about how
PAT/gPAT are actually handled. Specifically, whether or not gPAT is
context switched with the PAT MSR on VMRUN and #VMEXIT or not.

On one hand, the APM mentions that with nested paging, paging registers
are replicated and are loaded on VMRUN (in section 15.25.2 in Vol. 2):

  Most processor state affecting paging is replicated for host and
  guest.  This includes the paging registers CR0, CR3, CR4, EFER and
  PAT. CR2 is not replicated but is loaded by VMRUN. The MTRRs are not
  replicated.

  While nested paging is enabled, all (guest) references to the state of
  the paging registers by x86 code (MOV to/from CRn, etc.) read and
  write the guest copy of the registers; the VMM's versions of the
  registers are untouched and continue to control the second level
  translations from guest physical to system physical addresses. In
  contrast, when nested paging is disabled, the VMM's paging control
  registers are stored in the host state save area and the paging
  control registers from the guest VMCB are the only active versions of
  those registers.

This gives the impression that gPAT is loaded into the PAT MSR on
VMRUN, and switched back on #VMEXIT.

However, the APM also have multiple hints about PAT being different from
the other paging registers, and that gPAT might be a hidden register
different from PAT MSR:

- Looking at the pseudocode for VMRUN in Vol. 3 in the APM:
  * The part with "save host state to physical memory indicated in the
    VM_HSAVE_PA MSR:" does not include host PAT.

  * The part with "from the VMCB at physical address rAX, load guest
    state:" has:

        IF (NP_ENABLE == 1)
            gPAT // Leaves host hPAT register unchanged.

- Similarly, the pseudocode for #VMEXIT does not include restoring PAT
  as part of the host state. Also, the part with "save guest state to
  VMCB:" specifies "gPAT" not "PAT" being saved to the VMCB.

- In Vol 2, Table B-4:  VMSA Layout, State Save Area
  for SEV-ES, EFER, CR0, CR3, and CR4 are swap type A, but gPAT has no
  swap type and a note: "Swapped for guest, not used in host mode."

So it's unclear how the hardware actually handles gPAT. This RFC
implements the second interpretation, that gPAT is not loaded into the
architerctural PAT MSR on VMRUN, and that guest accesses are redirect to
this hidden gPAT register. This complicates things like save/restore, as
Jim mentioned.

The alternative would be loading L2's PAT (or the gPAT set by L1 for L2)
into the architectural state when entering guest mode, similar to EFER
and other paging registers, which would considerably simplify things,
especially save/restore. This, however, may not be the architectural
behavior.

From the guest prespective it should be more-or-less the same thing,
which makes me inclined to the simpler approach. However, I am not sure
if there could be any repercussions from not following the architecture,
assuming the architecture is really not loading gPAT into the PAT MSR.

It would be great if someone from AMD could clarify the architectural
behavior here and voice their opinion about which approach we should
take here.

Side-note: If we follow the simple approach, we can probably disable
intercepts to PAT completely when NPT is enabled, as guest accesses to
PAT are redirected to the gPAT (whatever that is) anyway. It probably
won't buy us much tho.

> 
> Jim Mattson (6):
>   KVM: x86: nSVM: Shuffle guest PAT and PAT MSR in
>     svm_set_nested_state()
>   KVM: x86: nSVM: Redirect PAT MSR accesses to gPAT when NPT is enabled
>     in vmcb12
>   KVM: x86: nSVM: Copy current vmcb02 g_pat to vmcb12 g_pat on #VMEXIT
>   KVM: x86: nSVM: Cache g_pat in vmcb_ctrl_area_cached
>   KVM: x86: nSVM: Add validity check for the VMCB12 g_pat
>   KVM: x86: nSVM: Use cached VMCB12 g_pat in VMCB02 when using NPT
> 
>  arch/x86/include/uapi/asm/kvm.h |  2 ++
>  arch/x86/kvm/svm/nested.c       | 35 +++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.c          | 25 +++++++++++++++--------
>  arch/x86/kvm/svm/svm.h          |  1 +
>  4 files changed, 53 insertions(+), 10 deletions(-)
> 
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

