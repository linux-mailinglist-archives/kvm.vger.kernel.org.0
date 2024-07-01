Return-Path: <kvm+bounces-20759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A763791D8E8
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:29:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C943C1C214B9
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D9774079;
	Mon,  1 Jul 2024 07:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WgVZyZ5A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135941B809
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 07:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818934; cv=none; b=Bfk9WUFid6R6y6bVUMaV7J4WTEViU0ZbO1oqMZnD9agAIJQVsrqATU7okyZYVZMUqBDxeD34GqnkSQhkPCkTx69jGWpYLfZZhZNYkBcIrAbf4H24LEV0t1jaupJVoL+/PldVnkavqJxAfbs+8/0hUEVoEqBl+Vp9+fiYaQfQ9FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818934; c=relaxed/simple;
	bh=C3XgTaqXTJLfV+dYqggjwpqqsS/5TxePRukp0hfKeeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mj9r1wbl4IDwRaihsD0gAr7urC2QaD07jAmsjcZSP9B1WMooSpR2vphZbYMNhM1ZPNxJIm6vZntsrLJOmg16nRf3s+Z8RG57XbLbZYOq8KcxxYX2FZcjkTMvxEXccOZn7SGh1FhpFcFNJEUK5saBk6qwVrOFva+hJP+ciHNLJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WgVZyZ5A; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719818932; x=1751354932;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C3XgTaqXTJLfV+dYqggjwpqqsS/5TxePRukp0hfKeeE=;
  b=WgVZyZ5AjiNOXXjscmN/3j53C3Ez9HDnTpx1vBdM142vfKqjTB+PLBe3
   S9pZ2R98quoHPTJiaCjHpJefmuzn2iYh9Ve/UCabg5QSsv6L0R16uPpY9
   VJxWv6AcwwCfMq0ZBtKyMARO1roTMfGwWk26TO3lizix+12nE8Bq84kh5
   yflnPKOUWNLenWytp0p6fdvNtK5cJRRCCJFCgawWBEDP/9c8qL0hM2/iZ
   SCwX+OdZWKlIz2SR3tou64iQizYsJV1rQGJGW0qAQ8QLK8mhKYY8OWGTp
   HzqUN3dC6hCJ9M5QvewdBNvAEBVorc9uxS3LF/1J7UOqSUkpQAnRyHN4L
   Q==;
X-CSE-ConnectionGUID: 4ZFzeNRcTC2HR2T8r8RBpQ==
X-CSE-MsgGUID: am0gBbtyTgyJS0DM0uBtRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34466021"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34466021"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:51 -0700
X-CSE-ConnectionGUID: ShGVZEpSTniQ6AY79lJuWA==
X-CSE-MsgGUID: PwcOXTKiRxi/JSa8ngD/Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45520736"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:48 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	robert.hoo.linux@gmail.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v7 0/5] x86: Add test cases for LAM
Date: Mon,  1 Jul 2024 15:30:05 +0800
Message-ID: <20240701073010.91417-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated address
bits for metadata.

The patch series add test cases for KVM LAM:

Patch 1 moves struct invpcid_desc to header file for new test cases.
Patch 2 makes change to allow setting of CR3 LAM bits in vmlaunch tests.
Patch 3~5 add test cases for LAM supervisor mode and user mode, including:
- For supervisor mode
  CR4.LAM_SUP toggle
  Memory/MMIO access with tagged pointer
  INVLPG
  INVPCID
  INVVPID (also used to cover VMX instruction VMExit path)
- For user mode
  CR3 LAM bits toggle 
  Memory/MMIO access with tagged pointer

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)
---
Changelog:
v7
- Move struct invpcid_desc to header file instead of defining a new copy in lam.c.
- Rename is_la57()/lam_sup_active() to is_la57_enabled()/is_lam_sup_enabled(),
  and move them to processor.h (Sean)
- Drop cr4_set_lam_sup()/cr4_clear_lam_sup() and use write_cr4_safe() instead. (Sean)
- Add get_lam_mask() to get lam status based on the address and vCPU state. (Sean)
- Drop the wrappers for INVLPG since INVLPG never faults. (Sean)
- Drop the wrapper for INVPCID and use invpcid_safe() instead. (Sean)
- Drop the check for X86_FEATURE_PCID. (Sean)
- Rename lam_{u48,u57}_active() to is_lam_{u48,u57}_enabled(), and move them to
  processor.h (Sean)
- Test LAM userspace address in kernel mode directly to simplify the interface
  of test_ptr() since LAM identifies a address as kernel or user only based on
  the address itself.
- Add comments about the virtualization hole of CR3 LAM bits.
- Drop the check of X86_FEATURE_LA57 when check LA57. (Sean)

v6
- https://lore.kernel.org/kvm/20240122085354.9510-1-binbin.wu@linux.intel.com/

v5
- https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/

Binbin Wu (4):
  x86: Move struct invpcid_desc to processor.h
  x86: Allow setting of CR3 LAM bits if LAM supported
  x86: Add test cases for LAM_{U48,U57}
  x86: Add test case for INVVPID with LAM

Robert Hoo (1):
  x86: Add test case for LAM_SUP

 lib/x86/processor.h |  41 +++++++
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 281 ++++++++++++++++++++++++++++++++++++++++++++
 x86/pcid.c          |   6 -
 x86/unittests.cfg   |  10 ++
 x86/vmx_tests.c     |  51 +++++++-
 6 files changed, 382 insertions(+), 8 deletions(-)
 create mode 100644 x86/lam.c


base-commit: d301d0187f5db09531a1c2c7608997cc3b0a5c7d
-- 
2.43.2


