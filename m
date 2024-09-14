Return-Path: <kvm+bounces-26925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E157979127
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 15:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BA1C282CA9
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 13:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD13E1CF7D7;
	Sat, 14 Sep 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXt7qx2Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC5B1805E
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726321859; cv=none; b=Umfav4rGH+dAfypmuomYuqorPQ8gtWO8AJYoKuLPNQaw86nDXBuFPLxpfhNGnIoEnzq3H9hBXYfnZGmAKWzu904Yeg4swxTEI7pIvNAyAhAP5KvxrJulZFoDKEwuALI2IiU8cgwjhUM/c2nB8vnWWqjlp6w/MFUZt5WU/IgHO3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726321859; c=relaxed/simple;
	bh=Lwz+pNol4HlRg31rinEmeULNQ6rvRjfKPLTNLO1WW9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DsPp5J5pxcDBAw4UVFzeqb/gFzgI6wYkGdCyIi+9ZUZseEF1qMV6DzEwGj/3TqpGcmRZtx+yyNUfz942B6B/v80QaaK1s6ILcNK6BWI2UWHcfOv8FC78bFxTiMDDa9cRpAkNb9v8WPXKvgpqNejKCdmRScsjCGxN3bKPgkKwuO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZXt7qx2Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726321857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1oAqGa7KkjEVmRjNXepp4Ih4AhDHzizRuS4x1X2HPI4=;
	b=ZXt7qx2ZzUx9JwUyUQ94d+yNWDZQ70u19jY+rmTC67ufVx+peYtvgil6o+qUvcxZ9AWgbH
	sx4Mh9IldcDUp9uWTOihtP+Nt2tJ74RLaumYcL2tSPYiogvWF7WuBKdz7Es6UevDGJVqI+
	BLGaTTQpQ6KwIi7ev7JeNvj+kH/t1I4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-qtigvvKnMfOxU9ogD9bx1Q-1; Sat, 14 Sep 2024 09:50:55 -0400
X-MC-Unique: qtigvvKnMfOxU9ogD9bx1Q-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374c960ee7aso1338727f8f.3
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 06:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726321854; x=1726926654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1oAqGa7KkjEVmRjNXepp4Ih4AhDHzizRuS4x1X2HPI4=;
        b=Is/HgS1DYWrJ35CpSbFkmEdO27uIUEvwi/9El3irjNuJqYrPA7vZG2iiiG/ocYIC0B
         3x9T8S4uU3D90rS8mWJcCUxsJ8FFZyx6iJ/P+lDVnwV+PyRPekPPQsKNqYVq2zLtP4ST
         sH9if34H57e6ooORvjLvp6SLlobCNojnjsUk3Avp0+8kEGaR5GjFkuP6lYzyd3ZrOxpw
         PBvqe/G4eSiOVyh66VV/uzE/HNpshvLBfSPx22ov9Q6ETIhRL3YPDHMRZnjsk8/Adh/u
         /8YZPS8FZLycShnSYDfpN2JxWqDxFdaDiyDE3qN4r13MKadxxx0gHFOd6ns1jxY+KUqq
         dWxg==
X-Gm-Message-State: AOJu0Yyy6baeBYIQjXsew54JdLpWnyI9zfcMwgC1BpXb1KDfb30jhahr
	zYcR1croYr51svSFxqBqT8rTcD9fQEZ0+zzvkHALWZPZc4k8iI8hBV4bo4rp3qcvy1Zp1Inr3dv
	9uAgLfhhdaGV0IO+nsCHqltSxBTfMHrp0e+tly+naoMYuAW9njllBzgxPXnXSnUsNgvD2xczRLi
	LZPZlPU5aoQJKe8bc07V/WFOJo4cT0FzGijREJSg==
X-Received: by 2002:adf:c651:0:b0:374:c847:831 with SMTP id ffacd0b85a97d-378d6243cdemr5064641f8f.55.1726321853826;
        Sat, 14 Sep 2024 06:50:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF55RDGCzJQP6IMNLoubksSCvVVWIY89Kk5/dGmuenY7szqKv3gR/+p2LloNZb63EXcao91rMFHlsTKKXidxuA=
X-Received: by 2002:adf:c651:0:b0:374:c847:831 with SMTP id
 ffacd0b85a97d-378d6243cdemr5064626f8f.55.1726321853317; Sat, 14 Sep 2024
 06:50:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com> <20240914011348.2558415-4-seanjc@google.com>
In-Reply-To: <20240914011348.2558415-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 14 Sep 2024 15:50:42 +0200
Message-ID: <CABgObfYkLond4fvObybhn4pGcbATc5chRJtmxU2yE6rLG4PkeQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.12
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2024 at 3:14=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> The bulk of the changes are to clean up the thorny "unprotect and retry" =
mess
> that grew over time.  The other notable change is to support yielding in =
the
> shadow MMU when zapping rmaps (simply a historic oversight, AFAICT).

This conflicts with the "zap modified memslot only" series that is in kvm/n=
ext.

The resolution is nice since it's possible to reuse the new
kvm_unmap_gfn_range()

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8cd758913282..1f59781351f9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7064,17 +7064,10 @@ static void kvm_mmu_zap_memslot_leafs(
         .end =3D slot->base_gfn + slot->npages,
         .may_block =3D true,
     };
-    bool flush =3D false;

     write_lock(&kvm->mmu_lock);

-    if (kvm_memslots_have_rmaps(kvm))
-        flush =3D kvm_handle_gfn_range(kvm, &range, kvm_zap_rmap);
-
-    if (tdp_mmu_enabled)
-        flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
-
-    if (flush)
+    if (kvm_unmap_gfn_range(kvm, &range))
         kvm_flush_remote_tlbs_memslot(kvm, slot);

     write_unlock(&kvm->mmu_lock);

(Pardon the whitespace damage!)

Paolo

> The following changes since commit 47ac09b91befbb6a235ab620c32af719f82083=
99:
>
>   Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.12
>
> for you to fetch changes up to 9a5bff7f5ec2383e3edac5eda561b52e267ccbb5:
>
>   KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded equiva=
lent (2024-09-09 20:22:08 -0700)
>
> ----------------------------------------------------------------
> KVM x86 MMU changes for 6.12:
>
>  - Overhaul the "unprotect and retry" logic to more precisely identify ca=
ses
>    where retrying is actually helpful, and to harden all retry paths agai=
nst
>    putting the guest into an infinite retry loop.
>
>  - Add support for yielding, e.g. to honor NEED_RESCHED, when zapping rma=
ps in
>    the shadow MMU.
>
>  - Refactor pieces of the shadow MMU related to aging SPTEs in prepartion=
 for
>    adding MGLRU support in KVM.
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> Sean Christopherson (33):
>       KVM: x86/mmu: Clean up function comments for dirty logging APIs
>       KVM: x86/mmu: Decrease indentation in logic to sync new indirect sh=
adow page
>       KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
>       KVM: x86/mmu: Reword a misleading comment about checking gpte_chang=
ed()
>       KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with a more descripti=
ve helper
>       KVM: x86/mmu: Trigger unprotect logic only on write-protection page=
 faults
>       KVM: x86/mmu: Skip emulation on page fault iff 1+ SPs were unprotec=
ted
>       KVM: x86: Retry to-be-emulated insn in "slow" unprotect path iff sp=
 is zapped
>       KVM: x86: Get RIP from vCPU state when storing it to last_retry_eip
>       KVM: x86: Store gpa as gpa_t, not unsigned long, when unprotecting =
for retry
>       KVM: x86/mmu: Apply retry protection to "fast nTDP unprotect" path
>       KVM: x86/mmu: Try "unprotect for retry" iff there are indirect SPs
>       KVM: x86: Move EMULTYPE_ALLOW_RETRY_PF to x86_emulate_instruction()
>       KVM: x86: Fold retry_instruction() into x86_emulate_instruction()
>       KVM: x86/mmu: Don't try to unprotect an INVALID_GPA
>       KVM: x86/mmu: Always walk guest PTEs with WRITE access when unprote=
cting
>       KVM: x86/mmu: Move event re-injection unprotect+retry into common p=
ath
>       KVM: x86: Remove manual pfn lookup when retrying #PF after failed e=
mulation
>       KVM: x86: Check EMULTYPE_WRITE_PF_TO_SP before unprotecting gfn
>       KVM: x86: Apply retry protection to "unprotect on failure" path
>       KVM: x86: Update retry protection fields when forcing retry on emul=
ation failure
>       KVM: x86: Rename reexecute_instruction()=3D>kvm_unprotect_and_retry=
_on_failure()
>       KVM: x86/mmu: Subsume kvm_mmu_unprotect_page() into the and_retry()=
 version
>       KVM: x86/mmu: Detect if unprotect will do anything based on invalid=
_list
>       KVM: x86/mmu: WARN on MMIO cache hit when emulating write-protected=
 gfn
>       KVM: x86/mmu: Move walk_slot_rmaps() up near for_each_slot_rmap_ran=
ge()
>       KVM: x86/mmu: Plumb a @can_yield parameter into __walk_slot_rmaps()
>       KVM: x86/mmu: Add a helper to walk and zap rmaps for a memslot
>       KVM: x86/mmu: Honor NEED_RESCHED when zapping rmaps and blocking is=
 allowed
>       KVM: x86/mmu: Morph kvm_handle_gfn_range() into an aging specific h=
elper
>       KVM: x86/mmu: Fold mmu_spte_age() into kvm_rmap_age_gfn_range()
>       KVM: x86/mmu: Add KVM_RMAP_MANY to replace open coded '1' and '1ul'=
 literals
>       KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded eq=
uivalent
>
>  arch/x86/include/asm/kvm_host.h |  14 +-
>  arch/x86/kvm/mmu/mmu.c          | 522 ++++++++++++++++++++++------------=
------
>  arch/x86/kvm/mmu/mmu_internal.h |   3 +
>  arch/x86/kvm/mmu/mmutrace.h     |   1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  63 ++---
>  arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
>  arch/x86/kvm/x86.c              | 133 +++-------
>  7 files changed, 368 insertions(+), 374 deletions(-)
>


