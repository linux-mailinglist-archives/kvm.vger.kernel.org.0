Return-Path: <kvm+bounces-32505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6807B9D9551
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:18:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EB52B22A29
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21021C4A13;
	Tue, 26 Nov 2024 10:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ak5TkMIW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A2618FDBA;
	Tue, 26 Nov 2024 10:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616297; cv=none; b=Hta5M13M5NmebfeXZ9zmnrwMrUKTh28L1Tie0Xg9O74ZLcP1QQjHi/RzHpLDJtsMOQq0xG+76jjZYlOCeVWPv+mtt9BiswJ+XPWSxeZ3gk3ql5tojHqboqJm+NqCdXXCzo7DMnze7f1MXR8Mw8287NaGbO6Kz/x6QIX/IrdHAfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616297; c=relaxed/simple;
	bh=zs9JylmmnkwE0IzLfay48JUyqcdCp+BfY5v804AHpHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IhZFuOMaqhDyuHDUowsGPD/NQ7O+sZxge79mGNT1svUgQ6+/gkQzwEt8JPdX9XMWcweT/z6bWh1MBFO9tTH0C9ybG67hMQEMAl1VaNfqDRgRCnpNZsvMHtDbwUNC+Lm485tYcGVt130Hrd0+0y3/WURO3Fb5tYgYYOmU8+KHBrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ak5TkMIW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616296; x=1764152296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zs9JylmmnkwE0IzLfay48JUyqcdCp+BfY5v804AHpHg=;
  b=Ak5TkMIWecBfkK2kDijs78pSjk2y5dBAyPOJxlaHFdPxO056IJmH6LM6
   fXU1IpXlyTT0apGAYnbPKAQY1tDlYGIjIbpTbIJ04tJmJGMAgRKQP0s5P
   jvWQsvggKfnRZxCLxRfG/KSMpMl3/Qrz7n2cdeTpi60qMHR6m4kbsDMz9
   BpWTAtDUbXuh6pAr6i+b0YBPhpy5N5kYm946smemaP3+xU2cSmW+ZmDkB
   CDi/mxKEh7X3LeUm2PPzztBs6eVYwIRYNuDerFanIMmP4akUUdTX4Qyan
   iM0OGYMnNlODCFbeuS6x85AxgmRxoIwwtvlrNQCub4TiASgs3WsdfNWjT
   A==;
X-CSE-ConnectionGUID: maVvBcUbQySmVmW/k07CDA==
X-CSE-MsgGUID: 5nPn4koGTVOpsSwJ2qfB1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32139843"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="32139843"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:16 -0800
X-CSE-ConnectionGUID: Lb9XLy/tT0Kq/qBqIbjTVA==
X-CSE-MsgGUID: qM0qhM4hSS+KDy3wpxu5Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96631775"
Received: from spr.sh.intel.com ([10.239.53.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:12 -0800
From: Chao Gao <chao.gao@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v2 0/6] Introduce CET supervisor state support
Date: Tue, 26 Nov 2024 18:17:04 +0800
Message-ID: <20241126101710.62492-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This v2 is essentially a resend of the v1 series. I took over this work
from Weijiang, so I added my Signed-off-by and incremented the version
number. This repost is to seek more feedback on this work, which is a
dependency for CET KVM support. In turn, CET KVM support is a dependency
for both FRED KVM support and CET AMD support.

==Background==

This series spins off from CET KVM virtualization enabling series [1].
The purpose is to get these preparation work resolved ahead of KVM part
landing. There was a discussion about introducing CET supervisor state
support [2] [3].

CET supervisor state, i.e., IA32_PL{0,1,2}_SSP, are xsave-managed MSRs,
it can be enabled via IA32_XSS[bit 12]. KVM relies on host side CET
supervisor state support to fully enable guest CET MSR contents storage.
The benefits are: 1) No need to manually save/restore the 3 MSRs when
vCPU fpu context is sched in/out. 2) Omit manually swapping the three
MSRs at VM-Exit/VM-Entry for guest/host. 3) Make guest CET user/supervisor
states managed in a consistent manner within host kernel FPU framework.

==Solution==

This series tries to:
1) Fix existing issue regarding enabling guest supervisor states support.
2) Add CET supervisor state support in core kernel.
3) Introduce new FPU config for guest fpstate setup.

With the preparation work landed, for guest fpstate, we have xstate_bv[12]
== xcomp_bv[12] == 1 and CET supervisor state is saved/reloaded when
xsaves/xrstors executes on guest fpstate.
For non-guest/normal fpstate, we have xstate_bv[12] == xcomp_bv[12] == 0,
then HW can optimize xsaves/xrstors operations.

==Performance==

We measured context-switching performance with the benchmark [4] in following
three cases.

case 1: the baseline. i.e., this series isn't applied
case 2: baseline + this series. CET-S space is allocated for guest fpu only.
case 3: baseline + allocate CET-S space for all tasks. Hardware init
        optimization avoids writing out CET-S space on each XSAVES.

the data are as follows

case |IA32_XSS[12] | Space | RFBM[12] | Drop%	
-----+-------------+-------+----------+------
  1  |	   0	   | None  |	0     |  0.0%
  2  |	   1	   | None  |	0     |  0.2%
  3  |	   1	   | 24B?  |	1     |  0.2%

Case 2 and 3 have no difference in performnace. But case 2 is preferred because
it can save 24B of CET-S space for all non-vCPU threads with just a one-line
change in patch 3:

+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;

Patch 4 and 5 have their own merits. Regardless of the approach we take, using
different FPU configuration settings for the guest and the kernel improves
readability, decouples them from each other, and arguably enhances
extensibility.

==Changelog==

v1->v2:
 - rebase onto the latest kvm-x86/next
 - Add performance data to the cover-letter
 - v1: https://lore.kernel.org/kvm/73802bff-833c-4233-9a5b-88af0d062c82@intel.com/

==Organization==

Patch1: Preserve guest supervisor xfeatures in __state_perm.
Patch2: Enable CET supervisor xstate support.
Patch3: Introduce kernel dynamic xfeature set.
Patch4: Initialize fpu_guest_cfg settings.
Patch5: Create guest fpstate with fpu_guest_cfg.
Patch6: Check invalid fpstate config before executes xsaves.

[1]: https://lore.kernel.org/all/20240219074733.122080-1-weijiang.yang@intel.com/
[2]: https://lore.kernel.org/all/ZM1jV3UPL0AMpVDI@google.com/
[3]: https://lore.kernel.org/all/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/
[4]: https://github.com/antonblanchard/will-it-scale/blob/master/tests/context_switch1.c

Sean Christopherson (1):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm

Yang Weijiang (5):
  x86/fpu/xstate: Add CET supervisor mode state support
  x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
  x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
  x86/fpu/xstate: Create guest fpstate with guest specific config
  x86/fpu/xstate: Warn if CET supervisor state is detected in normal
    fpstate

 arch/x86/include/asm/fpu/types.h  | 16 ++++++++--
 arch/x86/include/asm/fpu/xstate.h | 11 ++++---
 arch/x86/kernel/fpu/core.c        | 53 ++++++++++++++++++++++++-------
 arch/x86/kernel/fpu/xstate.c      | 35 +++++++++++++++-----
 arch/x86/kernel/fpu/xstate.h      |  2 ++
 5 files changed, 90 insertions(+), 27 deletions(-)

-- 
2.46.1


