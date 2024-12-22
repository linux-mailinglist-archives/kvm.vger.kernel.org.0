Return-Path: <kvm+bounces-34301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBCA9FA7B1
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D074416611D
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25F4194C94;
	Sun, 22 Dec 2024 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U298Tz1q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F3680B
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896097; cv=none; b=kQCVDG8HaROrc60GA0NhYXWq+EZksTsTNZts/kss+hchb2FeNhVIA7hvpU2gTfbiptZFmMdywrdY9W0rWlrYfHId1EEs+sRmI1yjfVdBCzEvvKbj/onV/0dJuCwmLsQ6px2bnQvR6lTRAwShi9Q95Wf5ypPs8An2WWsMRMO6VaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896097; c=relaxed/simple;
	bh=VpaGvHkioPZxuJVqRs+NYitCf28NTXQ1nnuggBgdVzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G4js8DsXrwGLqgGQuGCLKITELxthSl8wxOePayc2jXhgAxBC9RZwWuNY35zNWFfZD6REC8ZwnQZtqLk0+ikWbuU8yXpWjW2g7qMs91nXj3Jo9cbXRSSqfIQQIPqJcoO6KqnGbaRdNpE+GWYHIZcyPSzbGz64/25RGd+sO2HF/AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U298Tz1q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lp1xD+evB6Y/pJb2UaXlb0njWjmhti4602syzXVzzq0=;
	b=U298Tz1qwvVJc0SFDy52nNa4dyVa1lkyfufAy3lb5iitI5xbhSKJKwUyUi1I8/P/TMvZ3+
	A3nzUAXpk7dfdApS87jRUL4ynYSjGFsiiNJJdTMG1KqQT8UZTT5NRdPvJGONTHBiV4Darg
	J8ctFABYnE1yCLLUEV46n+7O7nXXzZo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-w7FIv2VPNKSYFXQQjaITaA-1; Sun,
 22 Dec 2024 14:34:49 -0500
X-MC-Unique: w7FIv2VPNKSYFXQQjaITaA-1
X-Mimecast-MFC-AGG-ID: w7FIv2VPNKSYFXQQjaITaA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D67FE19560AB;
	Sun, 22 Dec 2024 19:34:47 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3DE11956086;
	Sun, 22 Dec 2024 19:34:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v6 00/18] TDX MMU prep series part 1
Date: Sun, 22 Dec 2024 14:34:27 -0500
Message-ID: <20241222193445.349800-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi,

this is the essentially final version of the TDX MMU prep series, focusing
on supporting TDX's separation of EPT into a direct part (for shared pages)
and a part that is managed by the TDX module and cached (into a "mirror"
EPT) by KVM.

The only difference from v5 is squashing in Yan's
https://lore.kernel.org/kvm/20241104084229.29882-1-yan.y.zhao@intel.com/,
and a few comment and commit message updates.

Paolo

Isaku Yamahata (12):
  KVM: Add member to struct kvm_gfn_range to indicate private/shared
  KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
  KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
  KVM: x86/tdp_mmu: Take struct kvm in iter loops
  KVM: x86/mmu: Support GFN direct bits
  KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
  KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table
    type
  KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
  KVM: x86/tdp_mmu: Support mirror root for TDP MMU
  KVM: x86/tdp_mmu: Propagate building mirror page tables
  KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
  KVM: x86/tdp_mmu: Take root types for
    kvm_tdp_mmu_invalidate_all_roots()

Paolo Bonzini (1):
  KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks

Rick Edgecombe (5):
  KVM: x86/mmu: Zap invalid roots with mmu_lock held for write at
    uninit
  KVM: x86: Add a VM type define for TDX
  KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
  KVM: x86/tdp_mmu: Don't zap valid mirror roots in
    kvm_tdp_mmu_zap_all()
  KVM: x86/mmu: Prevent aliased memslot GFNs

 arch/x86/include/asm/kvm-x86-ops.h |   4 +
 arch/x86/include/asm/kvm_host.h    |  26 ++-
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/mmu.h                 |  31 +++
 arch/x86/kvm/mmu/mmu.c             |  50 ++++-
 arch/x86/kvm/mmu/mmu_internal.h    |  64 +++++-
 arch/x86/kvm/mmu/spte.h            |   5 +
 arch/x86/kvm/mmu/tdp_iter.c        |  10 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  21 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 325 ++++++++++++++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h         |  51 ++++-
 arch/x86/kvm/x86.c                 |   3 +
 include/linux/kvm_host.h           |   6 +
 virt/kvm/guest_memfd.c             |   2 +
 virt/kvm/kvm_main.c                |  14 ++
 15 files changed, 506 insertions(+), 107 deletions(-)

-- 
2.43.5


