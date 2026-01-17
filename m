Return-Path: <kvm+bounces-68423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6832FD38B17
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:18:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 86DC0301B8A4
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18A421FF30;
	Sat, 17 Jan 2026 01:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkF/KUV0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9760B6D1A7
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612689; cv=none; b=a568zh8Xkzwj6gO8OLT6UFvUPI9D4GnwefYBPtPfQFCDboJpzcnI9JQpZXvdHF1NLR04bsG5zRCmHyT8eDP3oZygzeOhI+tlZckH1PnRsXmAMeg/eKEHtQBN9zbQiY9KAMhblnO/aXPvxmi3r62/SotUl83jMd7hl8IeJsOrfJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612689; c=relaxed/simple;
	bh=w7jOopBKAsOvzRXrsvabqYkwvIVcHNW6Lo4RVZLUNCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mxDRLp9VXWYvpx+pYmP+xMZ16LTvSq3PXFDgO6ujxI+pcqbJiQmZK6+SKTES1YBuFu6rCWHh/cufgDOQc1IvMb7NpTrqCFGvvWaGiYzuxGgWSf3tSysGEsZZWeie2GIviL2YlHDkVXcIfHKxYlkHjtN38no5LBKlZtXltyPOMlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkF/KUV0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768612688; x=1800148688;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w7jOopBKAsOvzRXrsvabqYkwvIVcHNW6Lo4RVZLUNCw=;
  b=DkF/KUV0JzK8tECBjfPFOuwrfqjXL0K22V1fb18l1cqfdcckLRHFOzit
   IhJP8JMSQ8Z66jpMlqMQPj0/AlogBncKcSRa9jhs3MLy1W5he1G+VK8O/
   C3ClHCG0+cidJnaDTyPKo9TKLMpJk1FgsY3nYgn6wgbRplCHbRhZ/VDHj
   tYKVcvbP6BrnhX4DxQlPbF1fXszVc/efICrC2G2iAXOuP7R4u+YPbov2A
   QoYx8qa5j7XBNwMNgLWiyVFG15ptArGaf/KQZMMOBu0vzXatCJNgJpfx1
   m6n1Hagf/8L+UiliMQxbEUWZc1Q9Tum3II+gSFSH/6I/YwAij1A69g92Y
   w==;
X-CSE-ConnectionGUID: 8wOGFe5yRz20k4x5TVGSGg==
X-CSE-MsgGUID: i1hdi+McTWe6CKvTlX3UyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69131142"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69131142"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:07 -0800
X-CSE-ConnectionGUID: GiPwZMx5TkueL1hlMkFzwg==
X-CSE-MsgGUID: OGVleIAPSyCX3IVDb2McVg==
X-ExtLoop1: 1
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:06 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 0/7] target/i386: Misc PMU, PEBS, and MSR fixes and improvements
Date: Fri, 16 Jan 2026 17:10:46 -0800
Message-ID: <20260117011053.80723-1-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a set of mostly independent fixes and small
improvements in target/i386 related to PMU, PEBS, and MSR handling.

The patches are grouped into a single series for review convenience;
they are not tightly coupled and can be applied individually.

Dapeng Mi (3):
  target/i386: Don't save/restore PERF_GLOBAL_OVF_CTRL MSR
  target/i386: Support full-width writes for perf counters
  target/i386: Save/Restore DS based PEBS specfic MSRs

Zide Chen (4):
  target/i386: Disable unsupported BTS for guest
  target/i386: Gate enable_pmu on kvm_enabled()
  target/i386: Make some PEBS features user-visible
  target/i386: Increase MSR_BUF_SIZE and split KVM_[GET/SET]_MSRS calls

 target/i386/cpu.c     |  15 ++--
 target/i386/cpu.h     |  20 +++++-
 target/i386/kvm/kvm.c | 162 +++++++++++++++++++++++++++++++++++-------
 target/i386/machine.c |  35 +++++++--
 4 files changed, 191 insertions(+), 41 deletions(-)

-- 
2.52.0


