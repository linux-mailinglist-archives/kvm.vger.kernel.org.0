Return-Path: <kvm+bounces-34330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC3C9FAB38
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57170188445B
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 07:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1050F18F2FC;
	Mon, 23 Dec 2024 07:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lgP//1L8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7C1632F3;
	Mon, 23 Dec 2024 07:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734939541; cv=none; b=ZBcHb8GXZB5Puy55zUwAvUGjAmm/6VogwvZMJqvANMtxfDnLABQY+s6m+92Lfrh2IcA3dCQy3a1wVxW4hyi/YM1k8kWTTmchXQI8BBGBcGaQr5VkQoWujhQkxYfd+UDYvTOpoMQEMeRK9uq88ogHng9ewMC7QEfV7/XCQ8JAsiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734939541; c=relaxed/simple;
	bh=4zRF8x8lNJxwmbWMnOIUIxP89NK1/wTTOGAO7KM/rvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MYMWsWMRYwhaOtxCk/IsqJxADP39xdJDTkdQj7og1gpZmuEAnRsmThWFwHe+p0O0uhihnit9sLT/YsO5+4udUFqyK3kTJstOgbbQtfmnrTYcVUvlQ55meHw8ib5Lt6Ppr/sDzV5WnXWZ9mYWUSvcpsaduOKNxZzWB770KvS8cLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lgP//1L8; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734939540; x=1766475540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4zRF8x8lNJxwmbWMnOIUIxP89NK1/wTTOGAO7KM/rvE=;
  b=lgP//1L8qRrQIWXdmWlXLk1aXQ1SCmxyL20JVi8yEGvDrA0893qlkRw+
   RhTth4Ypjpf2eCMGlMtFNJ7wt/SAbf9sydCI2tzota72hzvJxNEw3BNFI
   2PS6RIIVGA87me/5IvGoQqgOdkGy6X9P9L/28zn/WYSefbnjPP2UgrA1b
   bU6XVEHhNPy5feASDgQXZRYVU13MlYaFo3V3/JmFmmVJ3opJAKOzv12lV
   FrU3FZxCXsVRuP/R3I2A48UP83UJ+PX8ZxQvmlP+CtbgaMdnVlqmsMXnM
   qBAUJCROjiZfyHGiGh0FgdCnK2qPnyFs5ZtYllH2Qf1NoSqRe/sru5N88
   Q==;
X-CSE-ConnectionGUID: 6daA9bJzRjWn16iHM7mqYw==
X-CSE-MsgGUID: gX1f5ebbTjaOitvWQl8Q0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="52925218"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="52925218"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 23:38:59 -0800
X-CSE-ConnectionGUID: 0WCXc+osTgWbZBFhRxho1Q==
X-CSE-MsgGUID: ZnVlLJiPQla9RiMP1ubuqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="104001721"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 23:38:57 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/2] KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
Date: Mon, 23 Dec 2024 15:04:27 +0800
Message-ID: <20241223070427.29583-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi
This series is for a bug where userspace can request KVM to reset dirty
GFNs belonging to a memslot that does not enable dirty tracking.

Patch 1 provides the fix, which can be applied to Linux 6.13-rc3. Although
the fix is a generic one, its primary motivation is to prevent userspace
from triggering write permission reduction or accessed bit clearing in
mirror SPTEs within TDX VMs. This could otherwise cause mismatches between
mirror SPTEs and the corresponding external SPTEs, and in the worst case,
lead to the removal of the external SPTEs.

Patch 2 introduces a selftest for TDX VMs to demonstrate how userspace
could trigger this bug. If necessary, this test can be ported to the
generic KVM selftest (e.g., dirty_log_test).


v2:
- Added a comment in patch 1, explaining that it's possible to try to
  update a memslot that isn't being dirty-logged if userspace is
  misbehaving. Specifically, userspace can write arbitrary data into the
  ring. (Sean)

v1:
https://lore.kernel.org/all/20241220082027.15851-1-yan.y.zhao@intel.com/

Thanks
Yan


Yan Zhao (2):
  KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
  KVM: selftests: TDX: Test dirty ring on a gmemfd slot

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/tdx_dirty_ring.c     | 231 ++++++++++++++++++
 virt/kvm/dirty_ring.c                         |   8 +-
 3 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tdx_dirty_ring.c

-- 
2.43.2


