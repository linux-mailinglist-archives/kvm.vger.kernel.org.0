Return-Path: <kvm+bounces-19893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E968D90DE99
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E85AC1C224CC
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7499F17838C;
	Tue, 18 Jun 2024 21:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CNylqahX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D49F13DDD2
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718746893; cv=none; b=leEzXUse9e3JOexVnvtCzcz4czvLeFE1BrJGrwasi8I7hIvUouywM/FeIAh/o4CAOZAAsvY281GcopBXU8n8gvqrogMa/pM3Nam1MRqBFsMPkoQMDBDFb5GTT++xSnfob8Qrh6aB05kYRUR7pYs3SfL/vFtEGGYF84q1VNJb3Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718746893; c=relaxed/simple;
	bh=PnuZkTnZh9BJRBAY+nP9FJkNNljhUiQV5Oq0ix7bxVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mkn8yl6V+8SRMr3qkcBlvHldAVm2YU+KOzl6lc4wHuWw/melLGObl4Fws21x/GftBGK2CIN0XP/RWP2dHJieFwRVgBEk9/imQqiCIPgD3/qGCRLHkx32i9Ow6QgRyq13ZlsmcmVKtxkLtvqyHx1pDHGzDklW2EdS28nPYmFiG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CNylqahX; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-705bbf10f90so6006544b3a.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718746891; x=1719351691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AAtPAwI2/fQskdqC7MNsbF+SEnpaoQNJkbfQr+PeWd4=;
        b=CNylqahXWa+iubRaa6BWPbgDH/eDZ4j68YhtGgVsHlO4lHOZrDwzu6LfI6mAcrzPrv
         /aqZM/P0J/Zz4pE7Q9fzUzY+trq5C9qeADVpYFnokcwXIPZjNwQhJCHHfCJGc35OWwXu
         zqWXr/b7++iA3IFzcD3W0N+6OODzzIeP/flP9OLJw/IvIiovleJt492uml2I3H1Wy9B0
         8T8cT54d0UjdMogOrn1qjENaOg0MfPqTNoahabwHqS3id9DngeKSt+RKmguhnVT5oivP
         7lrmTPtRqDs/gCPmtQt/Pgn2cBQz+DDtltWCDnrHXn1ceJl3RdBr2NasnEhyuik7IgAh
         6LAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718746891; x=1719351691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AAtPAwI2/fQskdqC7MNsbF+SEnpaoQNJkbfQr+PeWd4=;
        b=NyMSjSIJQYkpUpJF2OWUXKATqjvNvI5NNuoMYIpe1CXwxkWcwzqDg8KnMy0a3PLDJ5
         UWpj6aLnmpTDTp7jyHv1rMpSgZp6fQW02EQwmj7PsEJhlDHF8baVnZErck+jHro05Lnj
         NSOmPUlRMgmKKP/FXVtdXktgvIs/gyDfmOiF/dRLEnesKTFWtcOiDjE8y+jTMuoUtge+
         sFIQAfg1vVteFevCZ0OyLmN1fvO5B+q/Go92mEst2qx68TMU3XISmeApYEfAFTCZJVy4
         TGz40JQt5wArkJ0Z/VjlZgO5Oe44A0Yo1gWJ9iM3/n0UlXQi07fHvzd+Gh3YCUbd7o3D
         EUgQ==
X-Gm-Message-State: AOJu0YzQ8PazlIIf1xQ2iSjZfwZAQ942ahiHCCK4YY7OCY2hT7vn2y41
	qFvwyiao2n5eCxOT3BUPOKXgpqSpMfd1K4Bv9IHqhfibraq6RSv2k0dT7KBvDBPCkSib1I7759q
	0pg==
X-Google-Smtp-Source: AGHT+IEK0NfRNMup0SRyEJSpLMVi+C9N6IIgaBGqZsre7FOR+1xwXZDcD+EhWTzKv24rvoAcEBWfmfcmP08=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1c99:b0:704:1518:cca7 with SMTP id
 d2e1a72fcca58-70629d22335mr21102b3a.5.1718746891244; Tue, 18 Jun 2024
 14:41:31 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:41:22 -0700
In-Reply-To: <b8723d39903b64c241c50f5513f804390c7b5eec.1718203311.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <98ad0dab3a2c66834e50e6d465dcae47dd80758b.1717436464.git.babu.moger@amd.com>
 <b8723d39903b64c241c50f5513f804390c7b5eec.1718203311.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <171872415804.1750894.888856672412192321.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: Fix Undefined Behavior Sanitizer(UBSAN) error
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Babu Moger <babu.moger@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 12 Jun 2024 09:41:51 -0500, Babu Moger wrote:
> System throws this following UBSAN: invalid-load error when the very first
> VM is powered up on a freshly booted host machine. Happens only with 2P or
> 4P (multiple sockets) systems.
> 
> {  688.429145] ------------[ cut here ]------------
> [  688.429156] UBSAN: invalid-load in arch/x86/kvm/../../../virt/kvm/kvm_main.c:655:10
> [  688.437739] load of value 160 is not a valid value for type '_Bool'
> [  688.444760] CPU: 370 PID: 8246 Comm: CPU 0/KVM Not tainted 6.8.2-amdsos-build58-ubuntu-22.04+ #1
> [  688.444767] Hardware name: AMD Corporation Sh54p/Sh54p, BIOS WPC4429N 04/25/2024
> [  688.444770] Call Trace:
> [  688.444777]  <TASK>
> [  688.444787]  dump_stack_lvl+0x48/0x60
> [  688.444810]  ubsan_epilogue+0x5/0x30
> [  688.444823]  __ubsan_handle_load_invalid_value+0x79/0x80
> [  688.444827]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.444836]  ? flush_tlb_func+0xe9/0x2e0
> [  688.444845]  kvm_mmu_notifier_invalidate_range_end.cold+0x18/0x4f [kvm]
> [  688.444906]  __mmu_notifier_invalidate_range_end+0x63/0xe0
> [  688.444917]  __split_huge_pmd+0x367/0xfc0
> [  688.444928]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.444931]  ? alloc_pages_mpol+0x97/0x210
> [  688.444941]  do_huge_pmd_wp_page+0x1cc/0x380
> [  688.444946]  __handle_mm_fault+0x8ee/0xe50
> [  688.444958]  handle_mm_fault+0xe4/0x4a0
> [  688.444962]  __get_user_pages+0x190/0x840
> [  688.444972]  get_user_pages_unlocked+0xe0/0x590
> [  688.444977]  hva_to_pfn+0x114/0x550 [kvm]
> [  688.445007]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445011]  ? __gfn_to_pfn_memslot+0x3b/0xd0 [kvm]
> [  688.445037]  kvm_faultin_pfn+0xed/0x5b0 [kvm]
> [  688.445079]  kvm_tdp_page_fault+0x123/0x170 [kvm]
> [  688.445109]  kvm_mmu_page_fault+0x244/0xaa0 [kvm]
> [  688.445136]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445138]  ? kvm_io_bus_get_first_dev+0x56/0xf0 [kvm]
> [  688.445165]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445171]  ? svm_vcpu_run+0x329/0x7c0 [kvm_amd]
> [  688.445186]  vcpu_enter_guest+0x592/0x1070 [kvm]
> [  688.445223]  kvm_arch_vcpu_ioctl_run+0x145/0x8a0 [kvm]
> [  688.445254]  kvm_vcpu_ioctl+0x288/0x6d0 [kvm]
> [  688.445279]  ? vcpu_put+0x22/0x50 [kvm]
> [  688.445305]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445307]  ? kvm_arch_vcpu_ioctl_run+0x346/0x8a0 [kvm]
> [  688.445335]  __x64_sys_ioctl+0x8f/0xd0
> [  688.445343]  do_syscall_64+0x77/0x120
> [  688.445353]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445355]  ? fire_user_return_notifiers+0x42/0x70
> [  688.445363]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445365]  ? syscall_exit_to_user_mode+0x82/0x1b0
> [  688.445372]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445377]  ? do_syscall_64+0x86/0x120
> [  688.445380]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445383]  ? do_syscall_64+0x86/0x120
> [  688.445388]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445392]  ? do_syscall_64+0x86/0x120
> [  688.445396]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  688.445400]  ? do_syscall_64+0x86/0x120
> [  688.445404]  ? do_syscall_64+0x86/0x120
> [  688.445407]  ? do_syscall_64+0x86/0x120
> [  688.445410]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> [  688.445416] RIP: 0033:0x7fdf2ed1a94f
> [  688.445421] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89
> 		     44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41>
> 		     89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
> [  688.445424] RSP: 002b:00007fc127bff460 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  688.445429] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fdf2ed1a94f
> [  688.445432] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000016
> [  688.445434] RBP: 00005586f80dc350 R08: 00005586f6a0af10 R09: 00000000ffffffff
> [  688.445436] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> [  688.445438] R13: 0000000000000001 R14: 0000000000000cf8 R15: 0000000000000000
> [  688.445443]  </TASK>
> [  688.445444] ---[ end trace ]---

Please trim splats like this, the timestamps are uninteresting, and in most cases,
the "? ..." lines are completely superfluous.

The changelog+shortlog should also focus on what the actual bug+fix is.  The fact
that UBSAN found the issue is definitely noteworthy, but it's secondary to describing
the actual bug.

Lastly, it's definitely worth calling out that the bug is benign in practice.
kvm_mmu_notifier_invalidate_range_end() is the only caller that passes a null
handler, and it has flush_on_ret=false, i.e. won't actually consume whatever
garbage ends up in r.ret.  Not to mention that the compiler elides the entire
sequence on every build I've looked at, even an UBSAN=y builds, i.e. it likely
takes a sanitizer-heavy kernel to actually generate code that yields undefined
behavior at runtime.

    KVM: Stop processing *all* memslots when "null" mmu_notifier handler is found
    
    Bail from outer address space loop, not just the inner memslot loop, when
    a "null" handler is encountered by __kvm_handle_hva_range(), which is the
    intended behavior.  On x86, which has multiple address spaces thanks to
    SMM emulation, breaking from just the memslot loop results in undefined
    behavior due to assigning the non-existent return value from kvm_null_fn()
    to a bool.
    
    In practice, the bug is benign as kvm_mmu_notifier_invalidate_range_end()
    is the only caller that passes handler=kvm_null_fn, and it doesn't set
    flush_on_ret, i.e. assigning garbage to r.ret is ultimately ignored.  And
    for most configuration the compiler elides the entire sequence, i.e. there
    is no undefined behavior at runtime.
    
      ------------[ cut here ]------------
      UBSAN: invalid-load in arch/x86/kvm/../../../virt/kvm/kvm_main.c:655:10
      load of value 160 is not a valid value for type '_Bool'
      CPU: 370 PID: 8246 Comm: CPU 0/KVM Not tainted 6.8.2-amdsos-build58-ubuntu-22.04+ #1
      Hardware name: AMD Corporation Sh54p/Sh54p, BIOS WPC4429N 04/25/2024
      Call Trace:
       <TASK>
       dump_stack_lvl+0x48/0x60
       ubsan_epilogue+0x5/0x30
       __ubsan_handle_load_invalid_value+0x79/0x80
       kvm_mmu_notifier_invalidate_range_end.cold+0x18/0x4f [kvm]
       __mmu_notifier_invalidate_range_end+0x63/0xe0
       __split_huge_pmd+0x367/0xfc0
       do_huge_pmd_wp_page+0x1cc/0x380
       __handle_mm_fault+0x8ee/0xe50
       handle_mm_fault+0xe4/0x4a0
       __get_user_pages+0x190/0x840
       get_user_pages_unlocked+0xe0/0x590
       hva_to_pfn+0x114/0x550 [kvm]
       kvm_faultin_pfn+0xed/0x5b0 [kvm]
       kvm_tdp_page_fault+0x123/0x170 [kvm]
       kvm_mmu_page_fault+0x244/0xaa0 [kvm]
       vcpu_enter_guest+0x592/0x1070 [kvm]
       kvm_arch_vcpu_ioctl_run+0x145/0x8a0 [kvm]
       kvm_vcpu_ioctl+0x288/0x6d0 [kvm]
       __x64_sys_ioctl+0x8f/0xd0
       do_syscall_64+0x77/0x120
       entry_SYSCALL_64_after_hwframe+0x6e/0x76
       </TASK>
      ---[ end trace ]---
    
    Fixes: 071064f14d87 ("KVM: Don't take mmu_lock for range invalidation unless necessary")
    Signed-off-by: Babu Moger <babu.moger@amd.com>
    Link: https://lore.kernel.org/r/b8723d39903b64c241c50f5513f804390c7b5eec.1718203311.git.babu.moger@amd.com
    [sean: massage changelog]
    Signed-off-by: Sean Christopherson <seanjc@google.com>

Applied to kvm-x86 fixes, with the above shortlog+changelog (I am planning on
send a pull request to Paolo for a few 6.10 fixes on Thursday).  Thanks!

[1/1] KVM: Stop processing *all* memslots when "null" mmu_notifier handler is found
      https://github.com/kvm-x86/linux/commit/201de7ec31e5

--
https://github.com/kvm-x86/linux/tree/next

