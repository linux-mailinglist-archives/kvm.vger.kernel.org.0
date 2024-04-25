Return-Path: <kvm+bounces-15909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3408B21FE
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD45D284840
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6640C149C45;
	Thu, 25 Apr 2024 12:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CNXZqZX/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96021494C7;
	Thu, 25 Apr 2024 12:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714049579; cv=none; b=DH10TWWz7CJ3SLEspYHStwiRv29WWJjZdaz0EaqOSpr4E3LhEBH7ptY7cLdwdrQPwZZImbBUc0h9QNfKuIuzecDH+VKrcuQ8SdVyEiEjEB8HbpPcJyIdro88OXL1nB1H8PgjPc4paO7LTeI+HjsCTY+0duwV7eoE06NtEsHSpTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714049579; c=relaxed/simple;
	bh=jakCgquexdFuXk9JOlPDhLTDIX8zoGX+u4ZJbYpHYOU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W62YjifDzdwLra+8qf2uFqslXAHhoyYNRy5lbJ/otR+vD3NmYGCkVWyQmLPvZxo5ToNsjpmJ+ttg2CTLd5c2kuzjSW23e6stmf6l+oWmRwitvgAz/eaUkC1otQmPN7qiAS5CTcxJ0h/UizrK3Z8aTjx6zRNrlb0r6D5CVuOz5XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CNXZqZX/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714049578; x=1745585578;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jakCgquexdFuXk9JOlPDhLTDIX8zoGX+u4ZJbYpHYOU=;
  b=CNXZqZX/JyqHtr9cQsSZR1TB9bkF9pmAgeYll2if6vC3xl0s1ZmD9Y7U
   RxQAvWevn4NW6y1UoGf2EasMee2LTwvd7YC9H5+UQwM0goRNXRpi5AA35
   8kXKTJ5NYbuRH9+MoMhueLxULg+nSd3CnsuWvMe9/9wmCdaq6z0/p6m+1
   aRKMeEfEPALmXe+DzVsCQDSbpeyVyTbsiCzuP+QXWA1FDQTOZ04LpFf7i
   7Cct8ki5oQRfxMLMyIvs8FxvdVMRZ5bvhaPXk0fuGcjb3FmKmRq27jZfH
   1/Omdbzzjhau2SlaqH0P4KMugzXTfE1EwCkGdEU66x7/LcAeqlA1L0bmM
   w==;
X-CSE-ConnectionGUID: BW6KfjE4TmKYJoX+AKWbMw==
X-CSE-MsgGUID: I+DIf81LQ8ixcocj8VuiSA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="10267404"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="10267404"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 05:52:57 -0700
X-CSE-ConnectionGUID: eEJnGH/tTSWGDauHRzyimg==
X-CSE-MsgGUID: zM1NCbpOQAm6A2cHu8rU2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="29691887"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa003.jf.intel.com with ESMTP; 25 Apr 2024 05:52:55 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 0/3] KVM/x86: Enhancements to static calls
Date: Thu, 25 Apr 2024 20:52:49 +0800
Message-Id: <20240425125252.48963-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset introduces the KVM_X86_CALL() and KVM_PMU_CALL() macros to
streamline the usage of static calls of kvm_x86_ops and kvm_pmu_ops. The
current static_call() usage is a bit verbose and can lead to code
alignment challenges, and the addition of kvm_x86_ prefix to hooks at the
static_call() sites hinders code readability and navigation. The use of
static_call_cond() is essentially the same as static_call() on x86, so it
is replaced by static_call() to simplify the code. The changes have gone
through my tests (guest launch, a few vPMU tests, live migration tests)
without an issue.

v2->v3 changes:
- Change the KVM_X86_CALL() definition to have the parameters in their
  owen paratheses.
- Update the .get_cpl() hook in pmu.c to use KVM_X86_CALL().
  (it was omitted in v2)

v1->v2 changes:
- Replace static_call_cond() with static_call()
- Rename KVM_X86_SC to KVM_X86_CALL, and updated all the call sites
- Add KVM_PMU_CALL() 
- Add patch 4 and 5 to review the idea of removing KVM_X86_OP_OPTIONAL

Wei Wang (3):
  KVM: x86: Replace static_call_cond() with static_call()
  KVM: x86: Introduce KVM_X86_CALL() to simplify static calls of
    kvm_x86_ops
  KVM: x86/pmu: Add KVM_PMU_CALL() to simplify static calls of
    kvm_pmu_ops

 arch/x86/include/asm/kvm_host.h |  11 +-
 arch/x86/kvm/cpuid.c            |   2 +-
 arch/x86/kvm/hyperv.c           |   6 +-
 arch/x86/kvm/irq.c              |   2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  42 +++--
 arch/x86/kvm/lapic.h            |   2 +-
 arch/x86/kvm/mmu.h              |   6 +-
 arch/x86/kvm/mmu/mmu.c          |   4 +-
 arch/x86/kvm/mmu/spte.c         |   4 +-
 arch/x86/kvm/pmu.c              |  29 +--
 arch/x86/kvm/smm.c              |  44 ++---
 arch/x86/kvm/trace.h            |  15 +-
 arch/x86/kvm/x86.c              | 322 ++++++++++++++++----------------
 arch/x86/kvm/x86.h              |   2 +-
 arch/x86/kvm/xen.c              |   4 +-
 16 files changed, 259 insertions(+), 246 deletions(-)


base-commit: 44ecfa3e5f1ce2b5c7fa7003abde8a667c158f88
-- 
2.27.0


