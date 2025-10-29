Return-Path: <kvm+bounces-61430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 451AEC1D6D4
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 548384215DD
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92300319855;
	Wed, 29 Oct 2025 21:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AuVrNRHI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9D954763;
	Wed, 29 Oct 2025 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761773175; cv=none; b=lG5RCHLVYO/geShZOsxDP7rNSlRczYUdM84EZWcwTy058j54hOh73ih1rN9BL9uUc7KZjkIuBP+fCQWkGE+x7YaZgStrpLmUh+9INBNr+0qM+gCiAM0fI03zfSjeRrgtgdV/3+wUXWpdrz8oXT8EI5v5zohulC3n7fw1F5PSr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761773175; c=relaxed/simple;
	bh=IGB37qvB9T4vmHfJISA/2oS5kdVJPeAyRTPqjRCt9B8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r8IQ0+54Hb3Uv7fjqYiy9GUsrq9IDMVlZ87mHeh2nrBPMyGhsePOhQFNpjIT5FA46dMuYEwnlVSBIyZ14NbHq8LBQ3WQQ4wrcJ/1CngMT0UqlJcoqiVxtFkYHW8PwbGbcnQQaV/IRDlUEI5O2eOTSlamw1DZ8HB4dpkiMeiWqQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AuVrNRHI; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761773173; x=1793309173;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IGB37qvB9T4vmHfJISA/2oS5kdVJPeAyRTPqjRCt9B8=;
  b=AuVrNRHICWVvnmE/93Vo4SrJscDDCr+mxKxwCK3eHVZ2YxGpDZrTro0z
   4b1fMKf4N6iRNk2XrvSeu9GLLg7wsT16okTcKOn7EhayVQ20n+1QhXUsr
   AaqmkbsbXW4PvE4gsFGnDOctxvIQ+ziKfFtF6EZBgqaXcnbRix0Qlrvc1
   O5m/BTd7661LGlnVZ3NhEV8cbOZwbZWO5dxlo/2+6D/OSMQFNOzD6hOUL
   bILMqO8GRqwDsSpHzSW5GxQM43/0BrJLC7Rty//J/BI3M8xC/NKM5PmaL
   HHkAKU7p+1aQB4tzrJdWYB40gvANqKc5uONRnrO7XFr9wRa4Kj0FLSzMO
   g==;
X-CSE-ConnectionGUID: qfvqsAJ6SxmTLm919IWKMw==
X-CSE-MsgGUID: Wdp8oBFaQEit493r7ZPeVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="75252306"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="75252306"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:26:12 -0700
X-CSE-ConnectionGUID: 20s/SqlSRiagrk0d28hd6A==
X-CSE-MsgGUID: rDSB8zy7QCaNscbZNFNPOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="185024806"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:26:11 -0700
Date: Wed, 29 Oct 2025 14:26:10 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH 0/3] Unify VERW mitigation for guests
Message-ID: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIABSGAmkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDAyML3bLUonLdslxdsyRLIyNLQ4NEoyRjJaDqgqLUtMwKsEnRsbW1ACX
 Yq1JZAAAA
X-Change-ID: 20251028-verw-vm-6b922910a2b3
X-Mailer: b4 0.14.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This series unifies the VERW execution sites in KVM, specifically
addressing inconsistencies in how MMIO Stale Data mitigation is handled
compared to other data sampling attacks (MDS/TAA/RFDS).

Problem
=======
Currently, MMIO Stale Data mitigation is handled differently from other
VERW-based mitigations. While MDS/TAA/RFDS perform VERW clearing in
assembly code, MMIO Stale Data mitigation uses a separate code path with
x86_clear_cpu_buffer() calls. This inconsistency exists because MMIO Stale
Data mitigation only needs to be applied when guests can access host MMIO,
which was previously difficult to check in assembly. The other
inconsistency is VERW execution MMIO Stale Data dependency on L1TF
mitigation.

Solution
========
Remove the VERW mitigation for MMIO in C, and use the asm VERW callsite for
all VERW mitigations in KVM. Also decoupling MMIO mitigation from L1TF
mitigation.

Roadmap:

Patch 1: Switch to VM_CLEAR_CPU_BUFFERS usage in VMX to align Intel
	 mitigations with AMD's TSA mitigation.

Patch 2: Renames cpu_buf_vm_clear to cpu_buf_vm_clear_mmio_only to
	 avoid confusion with the broader X86_FEATURE_CLEAR_CPU_BUF_VM.

Patch 3: Unifies MMIO Stale Data mitigation with other VERW-based
         mitigations.

---
Pawan Gupta (3):
      x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
      x86/mmio: Rename cpu_buf_vm_clear to cpu_buf_vm_clear_mmio_only
      x86/mmio: Unify VERW mitigation for guests

 arch/x86/include/asm/nospec-branch.h |  2 +-
 arch/x86/kernel/cpu/bugs.c           | 17 +++++++++++------
 arch/x86/kvm/mmu/spte.c              |  2 +-
 arch/x86/kvm/vmx/run_flags.h         | 12 ++++++------
 arch/x86/kvm/vmx/vmenter.S           |  8 +++++++-
 arch/x86/kvm/vmx/vmx.c               | 26 ++++++++++----------------
 6 files changed, 36 insertions(+), 31 deletions(-)
---
base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
change-id: 20251028-verw-vm-6b922910a2b3

Best regards,
-- 
Pawan



