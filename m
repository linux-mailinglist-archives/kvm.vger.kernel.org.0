Return-Path: <kvm+bounces-41408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C992A67938
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A05D519C79E9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2193B211A12;
	Tue, 18 Mar 2025 16:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0xKJEp7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBD621148A
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314855; cv=none; b=DxPt55CDImvjfosl8U57GliVOKI0ez+DgYHvSdwrd4N5DdeYr3263SOZwYZi0OsgBisQoMqf2hQpwhCz2CuAcxhY6n9RL0b0iJdZVkMNHJWMfuz2ZwuXmsH/hSFcaxG2ikn22eoLDSzY/C6pCM5w5qE+doRiB0eB/Yrqa4clJQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314855; c=relaxed/simple;
	bh=b7HRB86K5OwZ5zAqlgBkvwTyAmTPYizXlYCkXIEFrC0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X3uqVF7KM+35f3WWOdP0sUywo5qNkTrArRQzGnvdxC0M25dkfMZBBJAp+kTCkJJiSuOts8aVLXpzXvYxOPOrQhlI/FTWRzGo8h68utYnL6dVhoZtwVkvE5d6ko/Pe5HDqmTaUpc9cnkBB2vh5Lt20kyMWqyn1+8dJSwItBEwMh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0xKJEp7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43943bd1409so23521475e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314848; x=1742919648; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/4rrKqju3eVmPetDGm0h77EFquJ+/Ft9DdfJCYAypfM=;
        b=H0xKJEp7yheM0TEd56HL+igEJqVtyzHd/9FMTPuZ7fD73j8WtqA0OZGoIPkkLa5X1B
         tkok9u0himZc2mbb4amr6ClsqS97muguPtqJNk52VdkdK79IN97bQ4HlKtWb3VkVd2kL
         lmitNrvdpHLt+6WeYKBI02JQtoNTBUEbV9dnYHTmLVBjFxtGgqCPSLZtcnyLii4FY1mH
         C7amWVe6pqHl/kg83AWXUSAx9GRozsu6pu9dg3kNQpkOxfzUcomnANP/2m5N9AiMgpXq
         VoJBJoLrI7XqBWnlcqkRFpQCaFsYdUpA8fqEIkP8++KgVUKAOupAQIUVuX80mC2nwf22
         jwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314848; x=1742919648;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/4rrKqju3eVmPetDGm0h77EFquJ+/Ft9DdfJCYAypfM=;
        b=ZUoWvpG/8UCanYDAP1sgF4gqdC3IjVP+X8mTF0O4CrLYIL8QiQLiuIspzrTJNUk9LI
         mIsbbhxD0DL6qUj2NLxhpLqHqG9kUEDoXNvTT0CUoiMWv9VHey3P6AJVIbXf8m3bdtP2
         3VHiyLAzSkgg/c6+ZDdswlhu3o2ywW9JvO/im+lxUHCSEJYVAk2qZvKyVOhyAhQbrdec
         dcLlvVzDnmGfw/UeWLZtF0TKZ2qeE/MwlDTXE+/Vmq1muHqwGxH4ThzrSVILtqdq1Qwz
         7tMdVZPbik7BmHNP3wFnRpGUvw6MDvOK1bhllrPCCkbFchn/KcKnEKvGpC8SSFWVUxUh
         Fubw==
X-Gm-Message-State: AOJu0Ywzifczr1S3rpotd+x7p2WyFDVL/Ps6LRFNH+YK48UOx7cBgtLn
	rcCPiroYNKnSpr3O2l10tUjHRv6QyyZ7oRegEAoTjyPOKIhjqcSfg49BZB75KV7R3CMZ4x8WIzf
	nlv8TBCJ7QER5SubV9LDhMzejLXLK16dei+NGvcBXws5RcaYpR+AUL+AU31KkebfFC0tcX/6qiM
	8oJDCZLvDT/P9oMsstIvzQ3MU=
X-Google-Smtp-Source: AGHT+IG04C2ZXEkmNbHi/o+vaOI41oJW9kJtC264bgpL9XnkcleEAVsJcA9GCi6qC0eTEqYntjtppzIhjQ==
X-Received: from wmqe11.prod.google.com ([2002:a05:600c:4e4b:b0:43d:4038:9229])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:c00f:0:b0:43c:fe85:e4ba
 with SMTP id 5b1f17b1804b1-43d3c953a27mr27893465e9.15.1742314848297; Tue, 18
 Mar 2025 09:20:48 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:20:39 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162046.4016367-1-tabba@google.com>
Subject: [PATCH v6 0/7] KVM: Restricted mapping of guest_memfd at the host and
 arm64 support
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This series adds restricted mmap() support to guest_memfd, as well as
support for guest_memfd on arm64. Please see v3 for the context [1].

Main changes since v5 [2]:
- Freeze folio refcounts when checking them to avoid races (Kirill,
  Vlastimili, Ackerley)
- Handle invalidation (e.g., on truncation) of potentially shared memory
  (Ackerley)
- Rebased on the `KVM: Mapping guest_memfd backed memory at the host for
  software protected VMs` series [3], which entails renaming of MAPPABLE
  to SHAREABLE and a rebase on Linux 6.14-rc7.

The state diagram that uses the new states in this patch series,
and how they would interact with sharing/unsharing in pKVM [4].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
[3] https://lore.kernel.org/all/20250318161823.4005529-1-tabba@google.com/
[4] https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf

Ackerley Tng (2):
  KVM: guest_memfd: Make guest mem use guest mem inodes instead of
    anonymous inodes
  KVM: guest_memfd: Track folio sharing within a struct kvm_gmem_private

Fuad Tabba (5):
  KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
    the folio lock
  KVM: guest_memfd: Folio sharing states and functions that manage their
    transition
  KVM: guest_memfd: Restore folio state after final folio_put()
  KVM: guest_memfd: Handle invalidation of shared memory
  KVM: guest_memfd: Add a guest_memfd() flag to initialize it as shared

 Documentation/virt/kvm/api.rst                |   4 +
 include/linux/kvm_host.h                      |  56 +-
 include/uapi/linux/kvm.h                      |   1 +
 include/uapi/linux/magic.h                    |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |   7 +-
 virt/kvm/guest_memfd.c                        | 589 ++++++++++++++++--
 virt/kvm/kvm_main.c                           |  62 ++
 7 files changed, 682 insertions(+), 38 deletions(-)


base-commit: 1ea0414b447c8c96e6a6f6f953323c3df71b85a6
-- 
2.49.0.rc1.451.g8f38331e32-goog


