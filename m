Return-Path: <kvm+bounces-55010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD923B2C98F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F4E85C3283
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D54258CDC;
	Tue, 19 Aug 2025 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iB5/CQ/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A7C214A6A;
	Tue, 19 Aug 2025 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755620694; cv=none; b=Z4Zue2pniLN+v2MVkt2VA4pWKaY2j1YJg/z5xMtw3JGt1ysVTOX5IKN50qPLbP7yhCQzYUo8UaLoWbcNGeR7pw/AK9Kkt79SdAXYIxBJhvaUMJcjmryl44u9vEV8N+Qzq7S0JihZ3TIHWodVUrcVmRJB765omxi/rO7eE9nbee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755620694; c=relaxed/simple;
	bh=wUMFXw1ikUbmB37qJt2ibITa/9ZqIPjHsM1j5azCU4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mifwlnbosPl4GUWebrOqUhACmyZz6qsNnCvYbSP55PEXYm57Gp6vAfthu1iy0I2a+atrdrVEc0m5tRkhBmQK6teG/TGpW+qc9kn4sO4yA483zmqMEtZZGs1k/IU41ckGgtI/uOHiSFMHVKaelMyXQuOi8jR2bPEK+bwBC3MQZGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iB5/CQ/M; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755620693; x=1787156693;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wUMFXw1ikUbmB37qJt2ibITa/9ZqIPjHsM1j5azCU4k=;
  b=iB5/CQ/M2s/ysjnxv6SwT+Nvb2QzUNr29Y+Q7W9JFaA0xvE7N+GZNDvT
   iiZz/2aOcfuEdOWYcYxua+1r9l/HI51+wH9twPaUBFsPNYAzLgthbMaio
   5BolKH5cb9hjdiz6NWwMc5jOYSB1yok9F79fa43cdfVSyPr7LzvKxWpD1
   h+kSWYzrvL+MD2o2laTPQJM78t5fxsPQjfllVnj6exEmKnUuEoM9Id5rJ
   A2niQsRTbHig/7ZTpKzREL9zJ8vMY3RLBkh31e1101PLwVu1ucZ9UDlvL
   BSvBXOBhKmhBfUI72KDtuKl3oCFGRALkh9J+7Cp7F0hGNnXzCb69q9G0e
   Q==;
X-CSE-ConnectionGUID: mMWjWCKUSZauacWiQeS7kQ==
X-CSE-MsgGUID: k7nnzYZTQQq5N8P3XRubhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="60499961"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="60499961"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:24:52 -0700
X-CSE-ConnectionGUID: ej1sGgTwQ4isbWvve7ZHiQ==
X-CSE-MsgGUID: GuIRkF9eQ56PRI60pne5pA==
X-ExtLoop1: 1
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.66])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:24:46 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH RESEND V2 0/2] Fixes for recovery for machine check in TDX/SEAM non-root mode
Date: Tue, 19 Aug 2025 19:24:33 +0300
Message-ID: <20250819162436.137625-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi


Here is V2 of a small fix related to recovery for machine check in TDX/SEAM
non-root mode, and a small tidy-up.


Changes in V2:

    x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM
    non-root mode
      Mask address when it is read
      Amend struct mce addr description

    KVM: TDX: Do not clear poisoned pages
      Patch dropped

    x86/mce: Remove MCI_ADDR_PHYSADDR
      New patch


The issue was noticed as part of work to determine the conditions under
which TDX private memory needs to be cleared after being reclaimed.
For guests with a large amount of memory, clearing all private pages during
VM shutdown can take minutes, so we are looking at when that can be
skipped.  A future patch will deal with that.

One thing that was investigated was the effect of deliberately corrupting a
TDX guest private page by writing to it on the host, and then reading it
on the guest, which results in a machine check as expected, but revealed
the issue addressed in patch 1.

There are 2 outstanding issues:

1. It is assumed that once the TDX VM is shutdown that the memory is
returned to the allocator.  That is true at present, but may not be in the
future.  Consider, for example, patch set "New KVM ioctl to link a gmem
inode to a new gmem file" :

      https://lore.kernel.org/r/cover.1747368092.git.afranji@google.com/

2. Currently, KVM TDX does not cater for the TDX VM to enter a FATAL error
state, where the only operation permitted is to tear down the VM.  KVM just
carries on, hitting various errors, but in particular, memory reclaim fails
because it is not following the teardown procedure, and all guest private
memory is leaked.


Adrian Hunter (2):
      x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM non-root mode
      x86/mce: Remove MCI_ADDR_PHYSADDR

 arch/x86/include/asm/mce.h      | 3 ---
 arch/x86/include/uapi/asm/mce.h | 2 +-
 arch/x86/kernel/cpu/mce/core.c  | 9 ++++++---
 drivers/cxl/core/mce.c          | 2 +-
 drivers/edac/skx_common.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)


Regards
Adrian

