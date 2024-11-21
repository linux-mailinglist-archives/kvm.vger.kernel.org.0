Return-Path: <kvm+bounces-32255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0459D4C5B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA5A71F22800
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20741D5CD4;
	Thu, 21 Nov 2024 11:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k/sF9tj3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01561CD1EE;
	Thu, 21 Nov 2024 11:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732190076; cv=none; b=MtqsIHAiUlr94vk4n7/feBgEmHAnCh+rzmJs0kjutAEC4APj4oipP9YHuULbT+a6PsyujgNmG6yEcZCixxdLtsDLEgTX3obd8UANOMzcjCA0q3x5TlTxkeLzEXEEc/IMwc0mV2p+lUuqmRWnQ5qJZZit9+xXlGGTwD12cWimBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732190076; c=relaxed/simple;
	bh=bUk+v7mZMk9BXc2nQ992y5Tda10wwmT7kOocDNd27kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdggrC5am0NuMhKbHopZ6dTZfmZkzalI3eErHEzZnUPbrmIyysH7398yxN8yqKz9WzU4y+ih72uKPrKdTErHNJsn2sOsfnjmxCTDebZQOZux/K/PdyX8GhFDULWUbx0r1YdzzRQ/VTLl4rn4njI6+NkQ0Rx+gY3/U0xsvxI0L1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k/sF9tj3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732190075; x=1763726075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bUk+v7mZMk9BXc2nQ992y5Tda10wwmT7kOocDNd27kY=;
  b=k/sF9tj32ipEI+oVTNfoNHieIqwhdhuXnX9KmhdzJYu+XLY/FpNERK7O
   P1qSUhq1/Y+RCZzhKF/RHhS+RtEhmeZaF2NA3Dr8u4pF9/HL9EYsFX8cX
   /HG+2YfJU+48ss7YLG6X5asLE+hzCk9jvddj1O2/49HWSZh/jIvBNoBhQ
   1woZQ0yT7t+H04w/9EwDurVu5o5gjw4wz+z8Npr5Cw+GPJc1wMo4COgcx
   h9SezAWiYYoOIjMkq+apoK79Fh2k5FazUyDdg7FM1afnpGiWLgTSuWnvt
   VUklZssc66DGS4Led8wix5Kz9oURp0fU51fq/gRg0u5tGJiBkYb6/q2r/
   w==;
X-CSE-ConnectionGUID: Kl7MSZUmRwiR29Pzs2wUzw==
X-CSE-MsgGUID: d/Sbup4ZQKuIODv+2lprnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="35964530"
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="35964530"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 03:54:35 -0800
X-CSE-ConnectionGUID: FYhsAv2STdWj1Fcnv29ZzA==
X-CSE-MsgGUID: +PwED7cqS/2aiYU5zEdFUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="90354127"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 03:54:30 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Date: Thu, 21 Nov 2024 19:51:39 +0800
Message-ID: <20241121115139.26338-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This SEPT SEAMCALL retry proposal aims to remove patch
"[HACK] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT"
[1] at the tail of v2 series "TDX MMU Part 2".

==brief history==

In the v1 series 'TDX MMU Part 2', there were several discussions regarding
the necessity of retrying SEPT-related SEAMCALLs up to 16 times within the
SEAMCALL wrapper tdx_seamcall_sept().

The lock status of each SEAMCALL relevant to KVM was analyzed in [2].

The conclusion was that 16 retries was necessary because
- tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.

  When the TDX module detects that EPT violations are caused by the same
  RIP as in the last tdh_vp_enter() for 6 consecutive times, tdh_vp_enter()
  will take SEPT tree lock and contend with tdh_mem*().

- tdg_mem_page_accept() can contend with other tdh_mem*().


Sean provided several good suggestions[3], including:
- Implement retries within TDX code when the TDP MMU returns
  RET_PF_RETRY_FOZEN (for RET_PF_RETRY and frozen SPTE) to avoid triggering
  0-step mitigation.
- It's not necessary for tdg_mem_page_accept() to contend with tdh_mem*()
  inside TDX module.
- Use a method similar to KVM_REQ_MCLOCK_INPROGRESS to kick off vCPUs and
  prevent tdh_vp_enter() during page uninstallation.

Yan later found out that only retry RET_PF_RETRY_FOZEN within TDX code is
insufficient to prevent 0-step mitigation [4].

Rick and Yan then consulted TDX module team with findings that:
- The threshold of zero-step mitigation is counted per vCPU.
  It's of value 6 because

    "There can be at most 2 mapping faults on instruction fetch
     (x86 macro-instructions length is at most 15 bytes) when the
     instruction crosses page boundary; then there can be at most 2
     mapping faults for each memory operand, when the operand crosses
     page boundary. For most of x86 macro-instructions, there are up to 2
     memory operands and each one of them is small, which brings us to
     maximum 2+2*2 = 6 legal mapping faults."
  
- Besides tdg_mem_page_accept(),  tdg_mem_page_attr_rd/wr() can also 
  contend with SEAMCALLs tdh_mem*().

So, we decided to make a proposal to tolerate 0-step mitigation.

==proposal details==

The proposal discusses SEPT-related and TLB-flush-related SEAMCALLs
together which are required for page installation and uninstallation.

These SEAMCALLs can be divided into three groups:
Group 1: tdh_mem_page_add().
         The SEAMCALL is invoked only during TD build time and therefore
         KVM has ensured that no contention will occur.

         Proposal: (as in patch 1)
         Just return error when TDX_OPERAND_BUSY is found.

Group 2: tdh_mem_sept_add(), tdh_mem_page_aug().
         These two SEAMCALLs are invoked for page installation. 
         They return TDX_OPERAND_BUSY when contending with tdh_vp_enter()
	 (due to 0-step mitigation) or TDCALLs tdg_mem_page_accept(),
	 tdg_mem_page_attr_rd/wr().

         Proposal: (as in patch 1)
         - Return -EBUSY in KVM for TDX_OPERAND_BUSY to cause RET_PF_RETRY
           to be returned in kvm_mmu_do_page_fault()/kvm_mmu_page_fault().
         
         - Inside TDX's EPT violation handler, retry on RET_PF_RETRY as
           long as there are no pending signals/interrupts.

         The retry inside TDX aims to reduce the count of tdh_vp_enter()
         before resolving EPT violations in the local vCPU, thereby
         minimizing contentions with other vCPUs. However, it can't
         completely eliminate 0-step mitigation as it exits when there're
         pending signals/interrupts and does not (and cannot) remove the
         tdh_vp_enter() caused by KVM_EXIT_MEMORY_FAULT.

         Resources    SHARED  users      EXCLUSIVE users
         ------------------------------------------------------------
         SEPT tree  tdh_mem_sept_add     tdh_vp_enter(0-step mitigation)
                    tdh_mem_page_aug
         ------------------------------------------------------------
         SEPT entry                      tdh_mem_sept_add (Host lock)
                                         tdh_mem_page_aug (Host lock)
                                         tdg_mem_page_accept (Guest lock)
                                         tdg_mem_page_attr_rd (Guest lock)
                                         tdg_mem_page_attr_wr (Guest lock)

Group 3: tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove().
         These three SEAMCALLs are invoked for page uninstallation, with
         KVM mmu_lock held for writing.

         Resources     SHARED users      EXCLUSIVE users
         ------------------------------------------------------------
         TDCS epoch    tdh_vp_enter      tdh_mem_track
         ------------------------------------------------------------
         SEPT tree  tdh_mem_page_remove  tdh_vp_enter (0-step mitigation)
                                         tdh_mem_range_block   
         ------------------------------------------------------------
         SEPT entry                      tdh_mem_range_block (Host lock)
                                         tdh_mem_page_remove (Host lock)
                                         tdg_mem_page_accept (Guest lock)
                                         tdg_mem_page_attr_rd (Guest lock)
                                         tdg_mem_page_attr_wr (Guest lock)

         Proposal: (as in patch 2)
         - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only
           once.
         - During the retry, kick off all vCPUs and prevent any vCPU from
           entering to avoid potential contentions.

         This is because tdh_vp_enter() and TDCALLs are not protected by
         KVM mmu_lock, and remove_external_spte() in KVM must not fail.



SEAMCALL                Lock Type        Resource 
-----------------------------Group 1--------------------------------
tdh_mem_page_add        EXCLUSIVE        TDR
                        NO_LOCK          TDCS
                        NO_LOCK          SEPT tree
                        EXCLUSIVE        page to add

----------------------------Group 2--------------------------------
tdh_mem_sept_add        SHARED           TDR
                        SHARED           TDCS
                        SHARED           SEPT tree
                        HOST,EXCLUSIVE   SEPT entry to modify
                        EXCLUSIVE        page to add


tdh_mem_page_aug        SHARED           TDR
                        SHARED           TDCS
                        SHARED           SEPT tree
                        HOST,EXCLUSIVE   SEPT entry to modify
                        EXCLUSIVE        page to aug

----------------------------Group 3--------------------------------
tdh_mem_range_block     SHARED           TDR
                        SHARED           TDCS
                        EXCLUSIVE        SEPT tree
                        HOST,EXCLUSIVE   SEPT entry to modify

tdh_mem_track           SHARED           TDR
                        SHARED           TDCS
                        EXCLUSIVE        TDCS epoch

tdh_mem_page_remove     SHARED           TDR
                        SHARED           TDCS
                        SHARED           SEPT tree
                        HOST,EXCLUSIVE   SEPT entry to modify
                        EXCLUSIVE        page to remove


[1] https://lore.kernel.org/all/20241112073909.22326-1-yan.y.zhao@intel.com
[2] https://lore.kernel.org/kvm/ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com
[3] https://lore.kernel.org/kvm/ZuR09EqzU1WbQYGd@google.com
[4] https://lore.kernel.org/kvm/Zw%2FKElXSOf1xqLE7@yzhao56-desk.sh.intel.com

Yan Zhao (2):
  KVM: TDX: Retry in TDX when installing TD private/sept pages
  KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal

 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu/mmu.c          |   2 +-
 arch/x86/kvm/vmx/tdx.c          | 102 +++++++++++++++++++++++++-------
 3 files changed, 85 insertions(+), 21 deletions(-)

-- 
2.43.2


