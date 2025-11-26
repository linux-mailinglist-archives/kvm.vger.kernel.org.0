Return-Path: <kvm+bounces-64584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C12C87BBB
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 067BA354E29
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DC630BB82;
	Wed, 26 Nov 2025 01:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FUwVVoXf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505B309EF2
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121504; cv=none; b=V3HIbBrIxqkJS2mt4mhvgOdw91mtvrXlGSwG/LIsUCweVfF4jJPtDhZTCFPHHaC/nEOn4plqPrQtaL9n6P2vNQdj6to+F+Rv/zTeO/E+qHDHk2cfMT6Nw2webWliNXiVF6fGIgmKKT323Zs0B1GX6IoAruNbcoS/o9bwAkMNmvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121504; c=relaxed/simple;
	bh=NBtS0CBlXmFtv2CpbX0slWjaK8zhCNujMgmGDea6e2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ssowv1i3b0rqNY1s3gYnuX6wrjGyfcZaCiygNpGm9vUvavpK9ScSFWhnqsbDsnzcTz1Do9MS8+5OkJ3kYXFS5VltTXUg1JHAOQ9wMylE6R1xF06OrHMWx57SLPX+iMAu7UJWl/jOugv+weRAl+3ZiSMnZLQZGMbQNO1kXaecHeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FUwVVoXf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34377900dbcso13502520a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121502; x=1764726302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XaVzwLvAOyYWmhSAMB3U8AHisG8g0KmgfYbsL1dCsG8=;
        b=FUwVVoXfGgsVMcgttpt+hEkQyqniNujazpgnsK4m0YOR8OLI9gbxXf7g79VrCVM7vk
         VzEM2K+atj9nygpR1grshexnEJlJjstmXVCthmNfhLiG6L4o0qh99MFH2Hhx6Qgrgbbr
         HLL8Xey8vCliI6bV6UwljnEw7WqNbQT8CAzHXeEOVeVPEyN75PdkEp2hayrFve3mkjra
         Q4KkYZzvkiNvVjHohOqE7jUNPBc2ME9cYmsRSadxLFYAcQ7pWDgKFu6AlfFKFSjnX5sr
         l5bNmcmgZ+VKuAOJFjGe7zTcOm+KWG/a2o62rmKQ/LIlY1AXU3lqB8oWw+BllmqYAQY2
         y02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121502; x=1764726302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XaVzwLvAOyYWmhSAMB3U8AHisG8g0KmgfYbsL1dCsG8=;
        b=ZRy//pou6sZHCvKvdFL5lrleT/eZ17UVGCavjNnGKaECpRRwSt2h8C1iIN5Wmcztp1
         1pjFPXGOwX/qaSQroDWgQexw85Mh2C5613i0lUTT/VXLN8OFo1a4xn2IdS/37TBjvMoJ
         QwS0sz/P9eCuJ9d7Bzj4adz8XfPLzSkDvJJy5TrsUA9OOSSqp7oKTyJWV8KzOqTRp6zl
         qX3e4T6f2XxkyecHzIq4EPN0+WGbSaP091xT8sJ7HPsCivMdAoBRIg6qK2M+TDdB9yyo
         0rfQuLjW5sOSMcJaWSFajEAIfWUzGhNiEs4DfmXA0bvfYU3r6DITnrTOa9+3Cc8wzpR3
         aIxA==
X-Gm-Message-State: AOJu0Yz4gAtQLokQrH1QBbldndoEa6dH30ZoPQeN6cUHzqqVpVlu8deR
	OZDB0lVf9u2Lg/c4u6LLCjthraRPjHT+mw7DTbufnIzXPk1aC2PXXm+Ofem5GSFaa7zdwnhXLu7
	STsegDQ==
X-Google-Smtp-Source: AGHT+IEHbUnAJ/PPChpDnvi4YEvNKo4weyF0gausUuUG+BGcxVs7nelkcFwiqxFxMpSX3Y3bSA0DtyJnh7A=
X-Received: from pjbhl6.prod.google.com ([2002:a17:90b:1346:b0:32d:e4c6:7410])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b42:b0:341:8b2b:43c
 with SMTP id 98e67ed59e1d1-34733f236d3mr17791929a91.18.1764121501897; Tue, 25
 Nov 2025 17:45:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:49 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-3-seanjc@google.com>
Subject: [GIT PULL] KVM: guest_memfd: NUMA support and other changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull NUMA mempolicy guest_memfd support, along with a handful of
guest_memfd cleanups and some tangentially related additions to KVM selftests
infrastructure.

This will conflict with kvm/master due to commit ae431059e75d ("KVM:
guest_memfd: Remove bindings on memslot deletion when gmem is dying").  The
resolution I've been using for linux-next is below.

--
diff --cc virt/kvm/guest_memfd.c
index ffadc5ee8e04,427c0acee9d7..fdaea3422c30
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@@ -623,53 -708,31 +708,49 @@@ err
        return r;
  }
  
- static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct kvm_gmem *gmem)
 -void kvm_gmem_unbind(struct kvm_memory_slot *slot)
++static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem_file *f)
  {
        unsigned long start = slot->gmem.pgoff;
        unsigned long end = start + slot->npages;
 -      struct gmem_file *f;
  
-       xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
 -      /*
 -       * Nothing to do if the underlying file was already closed (or is being
 -       * closed right now), kvm_gmem_release() invalidates all bindings.
 -       */
 -      CLASS(gmem_get_file, file)(slot);
 -      if (!file)
 -              return;
 -
 -      f = file->private_data;
 -
 -      filemap_invalidate_lock(file->f_mapping);
+       xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
  
        /*
         * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
         * cannot see this memslot.
         */
        WRITE_ONCE(slot->gmem.file, NULL);
 +}
 +
 +void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 +{
-       struct file *file;
- 
 +      /*
 +       * Nothing to do if the underlying file was _already_ closed, as
 +       * kvm_gmem_release() invalidates and nullifies all bindings.
 +       */
 +      if (!slot->gmem.file)
 +              return;
 +
-       file = kvm_gmem_get_file(slot);
++      CLASS(gmem_get_file, file)(slot);
 +
 +      /*
 +       * However, if the file is _being_ closed, then the bindings need to be
 +       * removed as kvm_gmem_release() might not run until after the memslot
 +       * is freed.  Note, modifying the bindings is safe even though the file
 +       * is dying as kvm_gmem_release() nullifies slot->gmem.file under
 +       * slots_lock, and only puts its reference to KVM after destroying all
 +       * bindings.  I.e. reaching this point means kvm_gmem_release() hasn't
 +       * yet destroyed the bindings or freed the gmem_file, and can't do so
 +       * until the caller drops slots_lock.
 +       */
 +      if (!file) {
 +              __kvm_gmem_unbind(slot, slot->gmem.file->private_data);
 +              return;
 +      }
 +
 +      filemap_invalidate_lock(file->f_mapping);
 +      __kvm_gmem_unbind(slot, file->private_data);
        filemap_invalidate_unlock(file->f_mapping);
- 
-       fput(file);
  }
  
  /* Returns a locked folio on success.  */


The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-gmem-6.19

for you to fetch changes up to 83e0e12219a402bf7b8fdef067e51f945a92fd26:

  KVM: selftests: Rename "guest_paddr" variables to "gpa" (2025-11-03 12:54:21 -0800)

----------------------------------------------------------------
KVM guest_memfd changes for 6.19:

 - Add NUMA mempolicy support for guest_memfd, and clean up a variety of
   rough edges in guest_memfd along the way.

 - Define a CLASS to automatically handle get+put when grabbing a guest_memfd
   from a memslot to make it harder to leak references.

 - Enhance KVM selftests to make it easer to develop and debug selftests like
   those added for guest_memfd NUMA support, e.g. where test and/or KVM bugs
   often result in hard-to-debug SIGBUS errors.

 - Misc cleanups.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes

Matthew Wilcox (2):
      mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
      mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies

Pedro Demarchi Gomes (1):
      KVM: guest_memfd: use folio_nr_pages() instead of shift operation

Sean Christopherson (10):
      KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
      KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
      KVM: guest_memfd: Add macro to iterate over gmem_files for a mapping/inode
      KVM: selftests: Define wrappers for common syscalls to assert success
      KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE by default
      KVM: selftests: Add additional equivalents to libnuma APIs in KVM's numaif.h
      KVM: selftests: Use proper uAPI headers to pick up mempolicy.h definitions
      KVM: guest_memfd: Add gmem_inode.flags field instead of using i_private
      KVM: guest_memfd: Define a CLASS to get+put guest_memfd file from a memslot
      KVM: selftests: Rename "guest_paddr" variables to "gpa"

Shivank Garg (7):
      mm/mempolicy: Export memory policy symbols
      KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
      KVM: guest_memfd: remove redundant gmem variable initialization
      KVM: guest_memfd: Add slab-allocated inode cache
      KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
      KVM: selftests: Add helpers to probe for NUMA support, and multi-node systems
      KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support

 fs/btrfs/compression.c                                         |   4 +-
 fs/btrfs/verity.c                                              |   2 +-
 fs/erofs/zdata.c                                               |   2 +-
 fs/f2fs/compress.c                                             |   2 +-
 include/linux/pagemap.h                                        |  18 +++--
 include/uapi/linux/magic.h                                     |   1 +
 mm/filemap.c                                                   |  23 ++++---
 mm/mempolicy.c                                                 |   6 ++
 mm/readahead.c                                                 |   2 +-
 tools/testing/selftests/kvm/arm64/vgic_irq.c                   |   2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c                 |  98 +++++++++++++++++++++++++++
 tools/testing/selftests/kvm/include/kvm_syscalls.h             |  81 ++++++++++++++++++++++
 tools/testing/selftests/kvm/include/kvm_util.h                 |  39 ++---------
 tools/testing/selftests/kvm/include/numaif.h                   | 110 ++++++++++++++++++------------
 tools/testing/selftests/kvm/kvm_binary_stats_test.c            |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c                     | 101 +++++++++++++++-------------
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c |   9 +--
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c               |   5 +-
 virt/kvm/guest_memfd.c                                         | 374 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 virt/kvm/kvm_main.c                                            |   7 +-
 virt/kvm/kvm_mm.h                                              |   9 +--
 21 files changed, 646 insertions(+), 253 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h

