Return-Path: <kvm+bounces-55480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AA8B30FD3
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66AC81CC6BFC
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0A22E7BBA;
	Fri, 22 Aug 2025 07:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UCHofGrj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187FD393DE4;
	Fri, 22 Aug 2025 07:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846234; cv=none; b=OaXheB21t92FiGJNfAxopkVpIya/KSmgT+1+NZMnHpPvtziq25+tPpUeVbnwa5N2VYKiqQtI/tCn6Ku2q3k7CmCjbEzwCKF9YIvocjQ47zYwOkTsuCrcjbpyk5Qj5gnWOwDLCsuZ5ZIXo6B3Uxku/cMA00Rt0YPnWkAdlQod1Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846234; c=relaxed/simple;
	bh=XCl3qayLl7JOj6L2EMCm3mvwMvKaWlNWuv3okYUfiTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B9w5MYL6uLZr7lW+yKR5GQDykL/mANDE9TaLbUFlCIQxxEol0jiMolOubGoGqVg8lY/AVcE5kkcatJLAhLN5EgjSKnrxhh+WB4V1hGy6jE1uYTxejUVCWrJnBK3IMyDNA6SCma9uMKhnVdc4A8Z4B2PGpDF1r0G/CqcONwVMIxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UCHofGrj; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755846232; x=1787382232;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XCl3qayLl7JOj6L2EMCm3mvwMvKaWlNWuv3okYUfiTs=;
  b=UCHofGrjne+cp9ql9JbaDYsq+So6giJRHuB1JLGEQh5tToAk/EuxFoJ0
   oVrOyCROhZX0BrHFkZNxkjNfNb3ZCb95nuEy/PHfghopgS35jgSPsa0IW
   vITpbAqPVKmRhoIlCBDpIkLLc4JuYvPruuNbO2h1Ug5vUr+CQ4LAt3yK9
   b2tM7k4NFSpbinLXF9KhQjqFaeEppVHp4wKCQfuYbTfh92RTsH/LwxdzZ
   rQPCbMPqS1AHmUxHaVnj/0eufgSeVn27Lz8vN487zbvEtASiU8Od6LBU7
   x7q2eppFQcK7CQ3Hfzd6KjwVPojflOZ4seDbcrXGSbbOQnJ2oz/JRddsw
   A==;
X-CSE-ConnectionGUID: lpNYjd2VSIiElT/Uk8oJqQ==
X-CSE-MsgGUID: exO5lt5TTQSTa3IG7Bj9cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57169823"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="57169823"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:03:51 -0700
X-CSE-ConnectionGUID: fHDE4PQsRZiKxvARB9gzGw==
X-CSE-MsgGUID: +5ZQZcs1Ti2z7FVvpLufbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168840728"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:03:49 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/3] KVM: Fix deadlock for invalid memslots
Date: Fri, 22 Aug 2025 15:03:04 +0800
Message-ID: <20250822070305.26427-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series addresses the deadlock issue encountered with invalid memslots
during prefaulting or TDX private EPT violations.

Patches 1-2 are the new fixes from Sean.
            Patch 1 is for the prefaulting case,
            patch 2 for the TDX private EPT violation case.

Patch 3 updates the selftest for prefaulting.
        The ioctl KVM_PRE_FAULT_MEMORY is now expected to return EAGAIN
	instead of ENOENT when prefaulting GFNs in an invalid memslot.

The TDX-specific selftest is not included in this series, though it's
passed locally.

v2:
- Use Sean suggested fixes (patches 1-2).
- Updated selftest for the prefault case accordingly.
- code base: kvm-x86-next-2025.08.21

v1:
https://lore.kernel.org/all/20250519023613.30329-1-yan.y.zhao@intel.com

Sean Christopherson (2):
  KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves memslot during
    prefault
  KVM: TDX: Do not retry locally when the retry is caused by invalid
    memslot

Yan Zhao (1):
  KVM: selftests: Test prefault memory during concurrent memslot removal

 arch/x86/kvm/mmu/mmu.c                        | 10 +-
 arch/x86/kvm/vmx/tdx.c                        | 11 +++
 .../selftests/kvm/pre_fault_memory_test.c     | 94 +++++++++++++++----
 virt/kvm/kvm_main.c                           |  1 +
 4 files changed, 98 insertions(+), 18 deletions(-)

-- 
2.43.2


