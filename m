Return-Path: <kvm+bounces-6127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80ADE82BB1B
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A45528A2F8
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 06:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76285C8EB;
	Fri, 12 Jan 2024 06:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQu2wX9/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34675C8E2
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 06:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705039252; x=1736575252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CFaXaJE8pqhFzAfuqNSjwEDriCGzZfa0L5Y2u7P2GR8=;
  b=nQu2wX9/vPIYIppYhE8gwUPUm3+sQeT1jZApFR367O6bPnu48a5ESx0E
   0tLavF8eWpbqcE0+xl9iSZBWWn/a+Wstm1v/dEyWgCno2H2XO0i6UMdlD
   HygervgDLrJ4VJkwxMhk5WRBSBU0fT7143QlVFB6mvXXHzcpRwcFU+NAk
   wuiZcyit7E0GOHmzdqIBUs3dDkj+5Jp5WKxBH2Cd3qtNwxdGpAQgAzro+
   Ts3emH5uJHnDoZ7t5tCSC7SyiBdxxc0vqjwc+4Wg7K0IsFwj6Lf70dIm3
   0vf78ewP0bRXmG0hGf/fAwT8jYwC5aN/DQzWmabhs2A/sNF6GOJQULZTw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="5815749"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="5815749"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 22:00:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="873274692"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="873274692"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.2.99])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 22:00:46 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v4 0/2] Add support for LAM in QEMU
Date: Fri, 12 Jan 2024 14:00:40 +0800
Message-Id: <20240112060042.19925-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated
address bits for metadata and masks the metadata bits before using them as
linear addresses to access memory.

When the feature is virtualized and exposed to guest, it can be used for 
efficient
address sanitizers (ASAN) implementation and for optimizations in JITs and 
virtual machines.

The KVM patch series can be found in [2].

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)
[2] https://lore.kernel.org/kvm/20230913124227.12574-1-binbin.wu@linux.intel.com

---
Changelog
v4:
- Add a reviewed-by from Xiaoyao for patch 1.
- Mask out LAM bit on CR4 if vcpu doesn't support LAM in cpu_x86_update_cr4() (Xiaoyao)

v3:
- https://lists.gnu.org/archive/html/qemu-devel/2023-07/msg04160.html

Binbin Wu (1):
  target/i386: add control bits support for LAM

Robert Hoo (1):
  target/i386: add support for LAM in CPUID enumeration

 target/i386/cpu.c    | 2 +-
 target/i386/cpu.h    | 9 ++++++++-
 target/i386/helper.c | 4 ++++
 3 files changed, 13 insertions(+), 2 deletions(-)


base-commit: f614acb7450282a119d85d759f27eae190476058
-- 
2.25.1


