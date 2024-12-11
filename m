Return-Path: <kvm+bounces-33486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 203849ED0F0
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 17:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B75ED28F138
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 16:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBDD1DBB37;
	Wed, 11 Dec 2024 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KGdi/n/h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3A91DB933
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733933533; cv=none; b=QL+c38wXpCPbwyjx/SS4daWnhMvkzgRiyG4ZlulzRJTfpS7rgaZO8nQDsUBpjaMCdOzSW/4P4rlB63/SE0cP2T3bO/xeB1aIaPQFE2ZXPlkBP6GWSdnPx+I6QUheLTPA0rk5/z15Mru3enCDJS6mWHqM5FHunW4evm8JzKbTSbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733933533; c=relaxed/simple;
	bh=sxh1To/yhjb8w2sKZnkP7oiD210OH/wLDI3VP/Q+SpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CDum4gu/CxIf5nVJHfCIkNgiKAQ4wSdKNSIWjvgVb++2OAJpzIrDK6Qqvg04mVqC7vXJo+/tMFwzT6plbczrP+GnuNcSkstc0fzmxtco3uIny494n6WWT22Vom79xiUirOEa18azqZMwwTeJ0++p+VuqsuQQUOj3ipSecsXV+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KGdi/n/h; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166855029eso24754115ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 08:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733933531; x=1734538331; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PO/MJQgQQpgVvqe4F1wgmCkbmIxL9hrRXf99Z79sxrU=;
        b=KGdi/n/h87/dgUEzL+9qHQZHCMOUx4ZUOeOdL87wAGKf8tFhcrkpvSEi6ayEW5hb3J
         WwOnv04UPohTX2tO4L+Ci5/Odpo12thy0W2scfWLxXrbjLROn6oqt3O9yB3qYy+Lv5eN
         c81W8e+RvNf2nFcecJHsHcj6wBL9MMu5/tGBg7b7TwRrWD5eI6CwfFLOO6gNA0ol8Mjl
         Z25bSA7QxiWSIaSam1uqAo/1U0QwwxmuW+CWJLV+tlgBJe20+WJ3DM6K3VuW/9gKKzUJ
         y7wmWQY2RcYafIxm0Z67DGK/Ddm+qeBkRxU041R4DsiPlNFrS41cNzBuxsNUPJjiXfwo
         7GQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733933531; x=1734538331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PO/MJQgQQpgVvqe4F1wgmCkbmIxL9hrRXf99Z79sxrU=;
        b=ttIc22e8qjAjIUOBRdahyuCXPqJ2ig2l2rh7LJ22hKhiovc7I0Kx/PfHuF3SrppUAI
         UbDZmM8dFF40sDmarnqGztYCdn8tNrurTFFXw0/JfazehPiS5llhEhmCXeDo1LJLE5VK
         AlHEZ/NFDQF+Py3D834YoCepHy8fZbfEr28u8vUFsAd/Q1PQr7XnpyG6x7bEMIRh8/MX
         mET3/K05IIdPUzL8cZ1eZi0sjVDB1EAHoa21KlPGhRFDo95B14RhcxZ9MudINc0kvRgX
         jQ2Ibe7EZJe5xvJtO17hPO4xQ64DxVfCqqJ8rSUQdqlVBvu+563OA9vxYkJpFp8zvet0
         RpTw==
X-Gm-Message-State: AOJu0YxxCCCfhZqdjI5AFtDxtclAo4MparIFuxT63WISk9gMWzjTmfgO
	detFrCfcFLovGUjMd9XarvLbHUdv3x7gkWt1pURLlK7JKRk448CjegS678sr+WLZpoGuUhXAu6q
	Lnw==
X-Google-Smtp-Source: AGHT+IGf8qY4g2FlQW0eFOkKDrFZ+U/L4CDi23VFnrK5zuBXztUm6XTWAocvFVnM9yIQPUubcyDnFQqMuZs=
X-Received: from pldd13.prod.google.com ([2002:a17:902:c18d:b0:216:7952:a32a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecc:b0:216:2b14:b625
 with SMTP id d9443c01a7336-2177853690emr61467645ad.31.1733933531460; Wed, 11
 Dec 2024 08:12:11 -0800 (PST)
Date: Wed, 11 Dec 2024 08:12:08 -0800
In-Reply-To: <bug-219588-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219588-28872@https.bugzilla.kernel.org/>
Message-ID: <Z1m52K3Adv47opYO@google.com>
Subject: Re: [Bug 219588] New: [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 11, 2024, bugzilla-daemon@kernel.org wrote:
> I hit a bug on the intel host, this problem occurs randomly:
> [  406.127925] ------------[ cut here ]------------
> [  406.132572] WARNING: CPU: 52 PID: 12253 at arch/x86/kvm/mmu/tdp_mmu.c:1001
> tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]

Can you describe the host activity at the time of the WARN?  E.g. is it under
memory pressure and potentially swapping, is KSM or NUMA balancing active? I
have a sound theory for how the scenario occurs on KVM's end, but I still think
it's wrong for KVM to overwrite a writable SPTE with a read-only SPTE in this
situation.

And does the VM have device memory or any other type of VM_PFNMAP or VM_IO
memory exposed to it?  E.g. an assigned device?  If so, can you provide the register
state from the other WARNs?  If the PFNs are all in the same range, then maybe
this is something funky with the VM_PFNMAP | VM_IO path.

The WARN is a sanity check I added because it should be impossible for KVM to
install a non-writable SPTE overtop an existing writable SPTE.  Or so I thought.
The WARN is benign in the sense that nothing bad will happen _in KVM_; KVM
correctly handles the unexpected change, the WARN is there purely to flag that
something unexpected happen.

	if (new_spte == iter->old_spte)
		ret = RET_PF_SPURIOUS;
	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
		return RET_PF_RETRY;
	else if (is_shadow_present_pte(iter->old_spte) &&
		 (!is_last_spte(iter->old_spte, iter->level) ||
		  WARN_ON_ONCE(leaf_spte_change_needs_tlb_flush(iter->old_spte, new_spte)))) <====
		kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);

Cross referencing the register state

  RAX: 860000025e000bf7 RBX: ff4af92c619cf920 RCX: 0400000000000000
  RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000015
  RBP: ff4af92c619cf9e8 R08: 800000025e0009f5 R09: 0000000000000002
  R10: 000000005e000901 R11: 0000000000000001 R12: ff1e70694fc68000
  R13: 0000000000000005 R14: 0000000000000000 R15: ff4af92c619a1000

with the disassembly

  4885C8                          TEST RAX,RCX
  0F84EEFEFFFF                    JE 0000000000000-F1
  4985C8                          TEST R8,RCX
  0F85E5FEFFFF                    JNE 0000000000000-F1
  0F0B                            UD2
  
RAX is the old SPTE and RCX is the new SPTE, i.e. the SPTE change is:

  860000025e000bf7
  800000025e0009f5

On Intel, bits 57 and 58 are the host-writable and MMU-writable flags

  #define EPT_SPTE_HOST_WRITABLE	BIT_ULL(57)
  #define EPT_SPTE_MMU_WRITABLE		BIT_ULL(58)

which means KVM is overwriting a writable SPTE with a non-writable SPTE because
the current vCPU (a) hit a READ or EXEC fault on a non-present SPTE and (b) retrieved
a non-writable PFN from the primary MMU, and that fault raced with a WRITE fault
on a different vCPU that retrieved and installed a writable PFN.

On a READ or EXEC fault, this code in hva_to_pfn_slow() should get a writable PFN.
Given that KVM has an valid writable SPTE, the corresponding PTE in the primary MMU
*must* be writable, otherwise there's a missing mmu_notifier invalidation.

	/* map read fault as writable if possible */
	if (!(flags & FOLL_WRITE) && kfp->map_writable &&
	    get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
		put_page(page);
		page = wpage;
		flags |= FOLL_WRITE;
	}

out:
	*pfn = kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
	return npages;

Hmm, gup_fast_folio_allowed() has a few conditions where it will reject fast GUP,
but they should be mutually exclusive with KVM having a writable SPTE.  If the
mapping is truncated or the folio is swapped out, secondary MMUs need to be
invalidated before folio->mapping is nullified.

	/*
	 * The mapping may have been truncated, in any case we cannot determine
	 * if this mapping is safe - fall back to slow path to determine how to
	 * proceed.
	 */
	if (!mapping)
		return false;

And secretmem can't be GUP'd, and it's not a long-term pin, so these checks don't
apply either:

	if (check_secretmem && secretmem_mapping(mapping))
		return false;
	/* The only remaining allowed file system is shmem. */
	return !reject_file_backed || shmem_mapping(mapping);

Similarly, hva_to_pfn_remapped() should get a writable PFN if said PFN is writable
in the primary MMU, regardless of the fault type.

If this turns out to get a legitimate scenario, then I think it makes sense to
add an is_access_allowed() check and treat the fault as spurious.  But I would
like to try to bottom out on what exactly is happening, because I'm mildly
concerned something is buggy in the primary MMU.

