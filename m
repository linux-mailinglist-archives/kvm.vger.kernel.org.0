Return-Path: <kvm+bounces-69450-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIxXAr+0emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69450-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:15:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3D8AA8BE
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B406A3034E1C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484F8317701;
	Thu, 29 Jan 2026 01:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O0AFbcfY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972AA1FBEB0
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649331; cv=none; b=n/53mDK6Fsbr87fY8eHqE3AbeP85BtI54mztmkNqyk8M3GmR4SAflzyAtdb6KTH8q8q/G3q7v2NF0lc6fA+GjIy9iOTR1QunHjOuH3o9O20IHrRviuIoxWRL7//WsIRyqkTwHzl2u7iFP+hz/wdaOux03P30vfA5mU8xQKKlLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649331; c=relaxed/simple;
	bh=77MNUmXLsSVzn3BT77shrDIB5ujNFeevJfDJ8rWmJzk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rVps1bt8hZyGesHrNoW4MQxtJCsJxE+jgGctqtMpy2seds6e1foBftEf8jbKuB7GGFwer3qLopj36TbSlRqG9tkYGdl0P3luzSHuu/bwaGMrvWWR1DdzVAddP6LZSpi93TWjkU7OHuQOKYzraBNGsiIgCTgAPJGM9pmQ/DvSP6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O0AFbcfY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso947766a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649328; x=1770254128; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dICzvWEdfBrtCh6Zy3BTwzQLU0rts7VP3KdYtqIFj2w=;
        b=O0AFbcfYIuqGNPzlFkLvp5SoF4BZpAK7nb19e7t38QXGaO2qfsvwTBYKrvHEWyXm5C
         A4zmRZsRNYZMG8ol4QRWb8yQmOciKKDGpMbK5o7FgpiEYtqYd4uAs0YYEe/xXbD4yWA9
         /SsarHs+C0qeYCNdZVOLj64DYKKuK9w88fsLBa2II+F5FhbjSa4EDPqrEwD9RglOrhpz
         lzR/xsEEZ7sflfPgTbyyYZhTDJeIQdaW0/4OCxURuO+fHwzfjSCNI5rJwNa32t0x3QtH
         3FkIzpVkObqPT32LcwtkAcAj2jtaxC8O3UHJ306lAw+sNIj+pN9kCVn/T5aNir4yNwD3
         zZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649328; x=1770254128;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dICzvWEdfBrtCh6Zy3BTwzQLU0rts7VP3KdYtqIFj2w=;
        b=dtz4h8H/NB4jwkJ0tqnT3DZAfWs3rb2bS/FHQwjKyzkaPZp060IUTnERBTUg7Nx1gn
         FHkJcPQ/+TEPgJg+sAsVBGDTkWlFRyn13pbHWA2mdZz5wmIys/LOjviLbhTNZf3vrnfZ
         55emvHVghnJLg1TerNnCJpY0p1x8uN9GQdj4xLHQ6a0kwIFQLIo3ii3+8IUuwHDnizBv
         arLVpIxCWVfNjnHe0E4E/OF9a90xQ0ZhJkSu6nsp4R/OJt0oxJqt4vkAj7KbI6zxiEC7
         wE8Fz5Mjn8PzAoRMX21lJSkenr/rLFwtSi1qb09Ws3HUMMDw1mkPUXPsb5KzHGTpSQD7
         8isw==
X-Forwarded-Encrypted: i=1; AJvYcCW9vazkHr157FLwY4XqBifpvk07hrd+yoWtCnD/Ilg+qcZ3ytZgt25M3jNEuAfTwzsOFPg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG38elguQhOpeN3xGG7Omw4wiWUiRxHe5GwBenSqbNVD3EOfdo
	VWhgyWPOTd5Sxrvqgvsz9lo1KK0NHLnusYZGDy9X3L4DIGBBcfmGCmlnTxQUlSsRLC4l+iyHo28
	qOBJ1cA==
X-Received: from pjee4.prod.google.com ([2002:a17:90b:5784:b0:353:3177:9547])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc4:b0:352:d168:fc4
 with SMTP id 98e67ed59e1d1-353fed88b65mr5574963a91.32.1769649327950; Wed, 28
 Jan 2026 17:15:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-1-seanjc@google.com>
Subject: [RFC PATCH v5 00/45] TDX: Dynamic PAMT + S-EPT Hugepage
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69450-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 5A3D8AA8BE
X-Rspamd-Action: no action

This is a combined series of Dynamic PAMT (from Rick), and S-EPT hugepage
support (from Yan).  Except for some last minute tweaks to the DPAMT array
args stuff, a version of this based on a Google-internal kernel has been
moderately well tested (thanks Vishal!).  But overall it's still firmly RFC
as I have deliberately NOT addressed others feedback from v4 of DPAMT and v3
of S-EPT hugepage (mostly lack of cycles), and there's at least one patch in
here that shouldn't be merged as-is (the quick-and-dirty switch from struct
page to raw pfns).

My immediate goal is to solidify the designs for DPAMT and S-EPT hugepage.
Given the substantial design changes I am proposing, posting an end-to-end
RFC seemed like a much better method than trying to communicate my thoughts
piecemeal.

As for landing these series, I think the fastest overall approach would be
to land patches 1-4 asap (tangentially related cleanups and fixes), agree
on a design (hopefully), and then hand control back to Rick and Yan to polish
their respective series for merge.

I also want to land the VMXON series[*] before DPAMT, because there's a nasty
wart where KVM wires up a DPAMT-specific hook even if DPAMT is disabled,
because KVM's ordering needs to set the vendor hooks before tdx_sysinfo is
ready.  Decoupling VMXON from KVM solves that problem, because it lets the
TDX subsystem parse sysinfo before TDX is loaded.

Beyond that dependency, I am comfortable landing both DPAMT and S-EPT hugepage
support without any other prereqs, i.e. without an in-tree way to light up
the S-EPT hugepage code due to lack of hugepage support in guest_memfd.
Outside of the guest_memfd arch hook for in-place conversion, S-EPT hugepage
support doesn't have any direction dependencies/conflicts with guest_memfd
hugepage or in-place conversion support (which is great, because it means we
didn't totally botch the design!).  E.g. Vishal's been able to test this code
precisely because it applies relatively cleanly on an internal branch with a
whole pile of guest_memfd changes.

Applies on kvm-x86 next (specifically kvm-x86-next-2026.01.23).

[*] https://lore.kernel.org/all/20251206011054.494190-1-seanjc@google.com

P.S. I apologize if I clobbered any of the Author attribution or SoBs.  I
     was moving patches around and synchronizing between an internal tree
     and this upstream version, so things may have gotten a bit wonky.

Isaku Yamahata (1):
  KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table
    splitting

Kiryl Shutsemau (12):
  x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>
  x86/tdx: Add helpers to check return status codes
  x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
  x86/virt/tdx: Allocate reference counters for PAMT memory
  x86/virt/tdx: Improve PAMT refcounts allocation for sparse memory
  x86/virt/tdx: Add tdx_alloc/free_control_page() helpers
  x86/virt/tdx: Optimize tdx_alloc/free_control_page() helpers
  KVM: TDX: Allocate PAMT memory for TD and vCPU control structures
  KVM: TDX: Get/put PAMT pages when (un)mapping private memory
  x86/virt/tdx: Enable Dynamic PAMT
  Documentation/x86: Add documentation for TDX's Dynamic PAMT
  x86/virt/tdx: Get/Put DPAMT page pair if and only if mapping size is
    4KB

Rick Edgecombe (3):
  x86/virt/tdx: Simplify tdmr_get_pamt_sz()
  x86/tdx: Add APIs to support get/put of DPAMT entries from KVM, under
    spinlock
  KVM: x86/mmu: Prevent hugepage promotion for mirror roots in fault
    path

Sean Christopherson (22):
  x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's 0-based level
  KVM: x86/mmu: Update iter->old_spte if cmpxchg64 on mirror SPTE
    "fails"
  KVM: TDX: Account all non-transient page allocations for per-TD
    structures
  KVM: x86: Make "external SPTE" ops that can fail RET0 static calls
  KVM: TDX: Drop kvm_x86_ops.link_external_spt(), use
    .set_external_spte() for all
  KVM: x86/mmu: Fold set_external_spte_present() into its sole caller
  KVM: x86/mmu: Plumb the SPTE _pointer_ into the TDP MMU's
    handle_changed_spte()
  KVM: x86/mmu: Propagate mirror SPTE removal to S-EPT in
    handle_changed_spte()
  KVM: x86: Rework .free_external_spt() into .reclaim_external_sp()
  KVM: Allow owner of kvm_mmu_memory_cache to provide a custom page
    allocator
  KVM: x86/mmu: Allocate/free S-EPT pages using
    tdx_{alloc,free}_control_page()
  *** DO NOT MERGE *** x86/virt/tdx: Don't assume guest memory is backed
    by struct page
  x86/virt/tdx: Extend "reset page" quirk to support huge pages
  KVM: x86/mmu: Plumb the old_spte into kvm_x86_ops.set_external_spte()
  KVM: TDX: Hoist tdx_sept_remove_private_spte() above
    set_private_spte()
  KVM: TDX: Handle removal of leaf SPTEs in .set_private_spte()
  KVM: TDX: Add helper to handle mapping leaf SPTE into S-EPT
  KVM: TDX: Move S-EPT page demotion TODO to tdx_sept_set_private_spte()
  KVM: x86/mmu: Add Dynamic PAMT support in TDP MMU for vCPU-induced
    page split
  KVM: guest_memfd: Add helpers to get start/end gfns give
    gmem+slot+pgoff
  *** DO NOT MERGE *** KVM: guest_memfd: Add pre-zap arch hook for
    shared<=>private conversion
  KVM: x86/mmu: Add support for splitting S-EPT hugepages on conversion

Xiaoyao Li (1):
  x86/virt/tdx: Add API to demote a 2MB mapping to 512 4KB mappings

Yan Zhao (6):
  x86/virt/tdx: Enhance tdh_mem_page_aug() to support huge pages
  x86/virt/tdx: Enhance tdh_phymem_page_wbinvd_hkid() to invalidate huge
    pages
  KVM: TDX: Add core support for splitting/demoting 2MiB S-EPT to 4KiB
  KVM: x86: Introduce hugepage_set_guest_inhibit()
  KVM: TDX: Honor the guest's accept level contained in an EPT violation
  KVM: TDX: Turn on PG_LEVEL_2M

 Documentation/arch/x86/tdx.rst              |  21 +
 arch/x86/coco/tdx/tdx.c                     |  10 +-
 arch/x86/include/asm/kvm-x86-ops.h          |   9 +-
 arch/x86/include/asm/kvm_host.h             |  36 +-
 arch/x86/include/asm/shared/tdx.h           |   1 +
 arch/x86/include/asm/shared/tdx_errno.h     | 104 +++
 arch/x86/include/asm/tdx.h                  | 127 ++--
 arch/x86/include/asm/tdx_global_metadata.h  |   1 +
 arch/x86/kvm/Kconfig                        |   1 +
 arch/x86/kvm/mmu.h                          |   4 +
 arch/x86/kvm/mmu/mmu.c                      |  34 +-
 arch/x86/kvm/mmu/mmu_internal.h             |  11 -
 arch/x86/kvm/mmu/tdp_mmu.c                  | 315 ++++----
 arch/x86/kvm/mmu/tdp_mmu.h                  |   2 +
 arch/x86/kvm/vmx/tdx.c                      | 468 +++++++++---
 arch/x86/kvm/vmx/tdx.h                      |   5 +-
 arch/x86/kvm/vmx/tdx_arch.h                 |   3 +
 arch/x86/kvm/vmx/tdx_errno.h                |  40 -
 arch/x86/virt/vmx/tdx/tdx.c                 | 762 +++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h                 |   6 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   7 +
 include/linux/kvm_host.h                    |   5 +
 include/linux/kvm_types.h                   |   2 +
 virt/kvm/Kconfig                            |   4 +
 virt/kvm/guest_memfd.c                      |  71 +-
 virt/kvm/kvm_main.c                         |   7 +-
 26 files changed, 1576 insertions(+), 480 deletions(-)
 create mode 100644 arch/x86/include/asm/shared/tdx_errno.h
 delete mode 100644 arch/x86/kvm/vmx/tdx_errno.h


base-commit: e81f7c908e1664233974b9f20beead78cde6343a
-- 
2.53.0.rc1.217.geba53bf80e-goog


