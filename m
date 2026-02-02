Return-Path: <kvm+bounces-69954-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AOCdLNwqgWlgEgMAu9opvQ
	(envelope-from <kvm+bounces-69954-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:53:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDDDD27FF
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5158308E522
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AB037F8CC;
	Mon,  2 Feb 2026 22:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="thTIMi7R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B453542D9
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071803; cv=none; b=ex521ztVHQeu9iSlFizF9kXNrNRu5qyT+ra0dJClj0lsUCNyI5sKxJcWn8x8IUJVEncoIa3UnYpWeHmcMUFOzmhlXP3rOqlAMKYDQjmhSEjZPIQkC9ODf/HOYiqWDmRU4PQ3vR/W2ir+jQIDiaVZBKoWJP+ep9q3+MZoiRddLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071803; c=relaxed/simple;
	bh=rd4cIp68EbB1eyG0U+KW87jwWrcTdeVAndZQxaLa494=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CZaq9Lw2WQpeEwf8RPyyB+79030/Tq6PITMmtUoZc6vE09N6RCEf/R86a1IuH43umOM3MkPqX/YqE3TtU+LXbPdSHj/zmej7IbOKyuAjWPHcLyU8U4FdnL7HJ/MZFrWkBkczw601RFN6uTsaJv2zKfcEzreTn2KNGPrDgqISSls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=thTIMi7R; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso8810069a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071801; x=1770676601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DNNh9ZOREYZL1Quu16G4IBTWGm7mHiJACM3HXRVQXaY=;
        b=thTIMi7R10CmJ7h4L4g8xyXXORnwNcO4/PV0atTb+I76KQ6viRGbgHmbbk1St9I+P5
         S7QqsZBtPf0emvDIsdmb/KngyHaKsl0w2n/sU9IPaIEQl0B30MIdLaUlp3kcYpcFRv90
         nF6PhEGUsKGGGlhF9QTVfFPe5xt2ND2c6FkK2a+ed8Igxie58ai99UOS96S1oNQ0P6JB
         KtW5pRfEMDUN5Ffm1sdP2pMAM8MUSu43yoBgj35H2BnNCYT4/vYNAx6m8AmnuM1BxyyT
         H+brF8OsiIY6ajDi2qoGJbgcpcqHab0rbTRg7zWPQH5khH++OFe7Fuot7/kuCOLtoPWY
         zNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071801; x=1770676601;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DNNh9ZOREYZL1Quu16G4IBTWGm7mHiJACM3HXRVQXaY=;
        b=HXRYBA8nnRADpgRrOJ7cjEx2uJeg8bH7AN8wT1N2zbKSHlTXJRjDCrnw8aQWob205j
         ZPjERe7vvg0njVTyQEgsiryFJh7MTXT3o9Mvy0qn+RnXqpdL66aiI8di/32zp8WYwWWe
         KrlFEAAwGkPHgX9JIUqsNYrdFnKBBT5aFls4CaRyZ6ft1r06BMQ2LVRnEsVPkP8iFXAw
         VYc3hUBQNmOnL/rI/exTMasj2AJtRvjfRhzwnGjbYKnPo2EZ/ee9diW3sJHqOb0KaQl6
         a9SuZ3YsYrXqEW/ZP4FliFZV+TumCuuqh687pa4k8BvYFfIVaY8RhmdIB9dpanuv6GgV
         exPw==
X-Gm-Message-State: AOJu0YxJdWC3pD1+m9bt/v3DaQ7bVbiDpPfLQzVg0oxsfNDJM3G4m9SG
	PDT3B0iIEcdHQ39qk1PXdxLdhXy+Rgt0dc5CueTsuJHeoswwLbPoBmr+qny+b6CmUQPykW9Rr5D
	Dn6VTioD3ikQcphzrPdqvf9Kc59BTVnwU95TpHWA/m6YBmGPKNAvBWpVQFh8czbkciYOBkX7fKW
	ZgmVgW3J94b2NWryJ6vQCq6SqllSchabVkw2gvbLKvjTqPrkGs68anASVxL1A=
X-Received: from pjji9.prod.google.com ([2002:a17:90a:6509:b0:34a:bf4e:cb5c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:41:b0:340:f009:ca89 with SMTP id 98e67ed59e1d1-3543b3941c6mr11450612a91.22.1770071800689;
 Mon, 02 Feb 2026 14:36:40 -0800 (PST)
Date: Mon,  2 Feb 2026 14:36:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <cover.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 00/37] guest_memfd: In-place conversion support
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69954-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0FDDDD27FF
X-Rspamd-Action: no action

(resending to fix Message-ID)

Here's a second revision of guest_memfd In-place conversion support.

In this version, other than addressing comments from RFCv1 [1], the largest
change is that guest_memfd now does not avoid participation in LRU; it
participates in LRU by joining the unevictable list (no change from before this
series).

While checking for elevated refcounts during shared to private conversions,
guest_memfd will now do an lru_add_drain_all() if elevated refcounts were found,
before concluding that there are true users of the shared folio and erroring
out.

I'd still like feedback on these points, if any:

1. Having private/shared status stored in a maple tree (Thanks Michael for your
   support of using maple trees over xarrays for performance! [5]).
2. Having a new guest_memfd ioctl (not a vm ioctl) that performs conversions.
3. Using ioctls/structs/input attribute similar to the existing vm ioctl
   KVM_SET_MEMORY_ATTRIBUTES to perform conversions.
4. Storing requested attributes directly in the maple tree.
5. Using a KVM module-wide param to toggle between setting memory attributes via
   vm and guest_memfd ioctls (making them mututally exclusive - a single loaded
   KVM module can only do one of the two.).

This series is based on kvm/next as at 2026-01-21, and here's the tree for your
convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v2

The "Don't set FGP_ACCESSED when getting folios" patch from RFCv1 is still
useful but no longer related to conversion, and was posted separately [6].

Older series:

+ RFCv1 is at [1]
+ Previous versions of this feature, part of other series, are available at
  [2][3][4].

[1] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
[2] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
[3] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
[4] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
[5] https://lore.kernel.org/all/20250529054227.hh2f4jmyqf6igd3i@amd.com/
[6] https://lore.kernel.org/all/20260129172646.2361462-1-ackerleytng@google.com/

Ackerley Tng (19):
  KVM: guest_memfd: Update kvm_gmem_populate() to use gmem attributes
  KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
  KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
  KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion
    safety check
  KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
  KVM: selftests: Test using guest_memfd for guest private memory
  KVM: selftests: Test basic single-page conversion flow
  KVM: selftests: Test conversion flow when INIT_SHARED
  KVM: selftests: Test indexing in guest_memfd
  KVM: selftests: Test conversion before allocation
  KVM: selftests: Convert with allocated folios in different layouts
  KVM: selftests: Test precision of conversion
  KVM: selftests: Test that truncation does not change shared/private
    status
  KVM: selftests: Test conversion with elevated page refcount
  KVM: selftests: Reset shared memory after hole-punching
  KVM: selftests: Provide function to look up guest_memfd details from
    gpa
  KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
  KVM: selftests: Update private_mem_conversions_test to mmap()
    guest_memfd
  KVM: selftests: Add script to exercise private_mem_conversions_test

Sean Christopherson (18):
  KVM: guest_memfd: Introduce per-gmem attributes, use to guard user
    mappings
  KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
  KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem
    is defined
  KVM: Stub in ability to disable per-VM memory attribute tracking
  KVM: guest_memfd: Wire up kvm_get_memory_attributes() to per-gmem
    attributes
  KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
  KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
  KVM: Let userspace disable per-VM mem attributes, enable per-gmem
    attributes
  KVM: selftests: Create gmem fd before "regular" fd when adding memslot
  KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
  KVM: selftests: Add support for mmap() on guest_memfd in core library
  KVM: selftests: Add selftests global for guest memory attributes
    capability
  KVM: selftests: Add helpers for calling ioctls on guest_memfd
  KVM: selftests: Test that shared/private status is consistent across
    processes
  KVM: selftests: Provide common function to set memory attributes
  KVM: selftests: Check fd/flags provided to mmap() when setting up
    memslot
  KVM: selftests: Update pre-fault test to work with per-guest_memfd
    attributes
  KVM: selftests: Update private memory exits test work with per-gmem
    attributes

 Documentation/virt/kvm/api.rst                |  72 ++-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/Kconfig                          |  15 +-
 arch/x86/kvm/mmu/mmu.c                        |   4 +-
 arch/x86/kvm/x86.c                            |  13 +-
 include/linux/kvm_host.h                      |  53 +-
 include/trace/events/kvm.h                    |   4 +-
 include/uapi/linux/kvm.h                      |  17 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/guest_memfd_conversions_test.c        | 486 ++++++++++++++++++
 .../testing/selftests/kvm/guest_memfd_test.c  |  57 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 128 ++++-
 .../testing/selftests/kvm/include/test_util.h |  31 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 130 +++--
 tools/testing/selftests/kvm/lib/test_util.c   |   7 -
 .../selftests/kvm/pre_fault_memory_test.c     |   2 +-
 .../kvm/x86/private_mem_conversions_test.c    |  48 +-
 .../kvm/x86/private_mem_conversions_test.py   | 152 ++++++
 .../kvm/x86/private_mem_kvm_exits_test.c      |  36 +-
 virt/kvm/Kconfig                              |   4 +-
 virt/kvm/guest_memfd.c                        | 399 +++++++++++++-
 virt/kvm/kvm_main.c                           | 104 +++-
 23 files changed, 1590 insertions(+), 176 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_conversions_test.c
 create mode 100755 tools/testing/selftests/kvm/x86/private_mem_conversions_test.py

--
2.53.0.rc1.225.gd81095ad13-goog

