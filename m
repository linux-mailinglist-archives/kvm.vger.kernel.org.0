Return-Path: <kvm+bounces-65065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD63C9A12E
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 49CBA4E2C5D
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149A52F83B2;
	Tue,  2 Dec 2025 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCLByWe4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3572F60C1;
	Tue,  2 Dec 2025 05:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653065; cv=none; b=FG9JlaoeZF3Xgpt+4F8pGU330yyaSaDuN8R+JHvyuMCt4Jn2i/PQFNRCyu41hCy3eugMT+mqWbMnT182kWT4F31inGgKNRndi5wGicSs7yhtfbIEptKrIBhQOSq8e3vpD5bUEiwbRFPLz2JbWEX/ZVWazzd4WzaWxJuEs+ZI2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653065; c=relaxed/simple;
	bh=2JnN+LWHudvTEWaawiNNu3VLxzIQWgftiKGm/gBSJJU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S0sX67wDxNY9z9T+0QlTqLCkYwWUQYanvUvsuFG/w4m5z1JnjTLJqLfgIqdNHR+8X7lOPeASpgci6HWYz3im5Uq4+9kaAPQaCNqqlWHMo9Emx+Zt0Ki3OxJWC52fPUhW5WbTbU/NAjcJ0+pIMvo2VLq0lYIW/5ufMR8VNLd411M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KCLByWe4; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653063; x=1796189063;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2JnN+LWHudvTEWaawiNNu3VLxzIQWgftiKGm/gBSJJU=;
  b=KCLByWe49YMSxpIBZoThKEUaBWt24VB7HLk/ZZPZ5lql+TUdTW1ydoQm
   HzK5Ts8kgn3jGzun9wrrIatrfH++P3iqjS5lXZcU5HYNQ+oKug24Ox2FJ
   TdyvnM/mWM7dUbQF6JtFilmQVqqVQnQQB8jlH+WTxWryEQrzFt8r7x1bo
   VK7J76cBaonlF4Q208Pw0zS2J5qRi22YfgjUdMUrRFPe0V006f9UHo/Ja
   EwOwuG4Q/vfvdol28hTpFexcm7+K02cCuNtCcpSHzfZoX4A8Xf7u7ujO2
   FehOLTNLhdywWqkuscCTBfvtI0ob3umCZUOGHXo3vF7DqtO2X9Y8bfuKU
   g==;
X-CSE-ConnectionGUID: UkHgnzWCT+GUBRayWjqDzQ==
X-CSE-MsgGUID: ygLE7tZ6Tpmn44VX/d52ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929815"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929815"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:15 -0800
X-CSE-ConnectionGUID: MdXwg0dZQHusGG3x3cl4Iw==
X-CSE-MsgGUID: 3RmeRrYWQHK7GM/fvh6XaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399223"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:10 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: x86@kernel.org,
	dave.hansen@linux.intel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	dan.j.williams@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 0/6] TDX: Stop metadata auto-generation, improve readability
Date: Tue,  2 Dec 2025 13:08:38 +0800
Message-Id: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi:

This addresses the common need [1][2] to stop auto-generating metadata
reading code, improve readability, allowing us to manually edit and
review metadata code in a comfortable way. TDX Connect needs to add more
metadata fields based on this series, and I believe also for DPAMT and
TDX Module runtime update.

The main changes derive from previous code & discussions before
auto-generation is introduced, including the usage of
struct field_mapping table, the build-time field size check, the concern
about awkward "ret = ret ?: " code pattern. [3]

Another concern from DPAMT [4] leads to the last patch and I realize all
optional features may face with the same problem - Optional metadata
reading should be skipped when a TDX Module doesn't support, don't fail
the whole TDX Module initialization. I use "TDX Module Extensions" as
the example and test case just because I have the TDX Connect ENV on
hand.

This series is based on Dan's tsm#devsec-phase1 [5] (convenient for my
testing), but is clean to apply to v6.18-rc7.

[1] https://lore.kernel.org/kvm/1e7bcbad-eb26-44b7-97ca-88ab53467212@intel.com/
[2] https://lore.kernel.org/all/89a4e42d-b0fd-49b0-8d51-df7bac0d5e5b@intel.com/
[3] https://lore.kernel.org/kvm/9a06e2cf469cbca2777ac2c4ef70579e6bb934d5.camel@intel.com/
[4] https://lore.kernel.org/kvm/850f7ce0571cb54bc984c79861bdfd104e097eb9.camel@intel.com/
[5] https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/log/?h=devsec-phase1


Xu Yilun (6):
  x86/virt/tdx: Move bit definitions of TDX_FEATURES0 to public header
  x86/virt/tdx: Move read_sys_metadata_field() to where it is called
  x86/virt/tdx: Refactor metadata reading with a clearer for loop
  x86/virt/tdx: Sanity check the size of each metadata field
  x86/virt/tdx: Add generic support for reading array-typed metadata
  x86/virt/tdx: Skip unsupported metadata by querying tdx_feature0

 arch/x86/include/asm/tdx.h                  |   5 +
 arch/x86/include/asm/tdx_global_metadata.h  |  12 +-
 arch/x86/virt/vmx/tdx/tdx.h                 |   3 -
 arch/x86/virt/vmx/tdx/tdx.c                 |  20 --
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 194 ++++++++++++--------
 5 files changed, 134 insertions(+), 100 deletions(-)

-- 
2.25.1


