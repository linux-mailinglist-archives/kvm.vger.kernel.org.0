Return-Path: <kvm+bounces-51481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0BEAF72A9
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630EE1723C0
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12E42E3B07;
	Thu,  3 Jul 2025 11:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NwTIC4nJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535072874E1;
	Thu,  3 Jul 2025 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751542866; cv=none; b=Ob1uXclwZY0AkjztlkgIlT6IGPe5ETeiELe4PiFDxrZbzvXyn0oeXULZ7BYY4XLXGesKaiam6H6Ckb0Gd31lG3TiqE4wcUBkQBFPOo2/22cAgjET2XIGbg0axBdu7+3NZjLWUEjx1gKP8lJs6cVCMYGHy1KjX8wfOCMf5wWmr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751542866; c=relaxed/simple;
	bh=6qPqpJXg5+oCqQJZY+fO18sbOYuQGrvgvxm7wMrOMsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=atuL/Vx1u0TmlICtzwMxIUwrI722W5M/eCorRYoRf5GVYTClo7HK1Yzxpa7LLOE7Znn8rBIwPRnTdvqF2kt4FpZ1zeh3WFlzkPcX9Vl2iP7MexRZ68KHXizTPD33w1a0fBGFXRzuQSCVZvnlXnJCNeShM3+LefwELTfHAYhjpto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NwTIC4nJ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751542864; x=1783078864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6qPqpJXg5+oCqQJZY+fO18sbOYuQGrvgvxm7wMrOMsw=;
  b=NwTIC4nJxaWmQOF00+iFJ5oatDp7nCQbCjh2OOlkL77wFnQvUWhyFz7x
   +NS0vIgwsgWoTNH7bIIbAvuOtcV9adjo84DKDkD2sPnxKYZki476JnSqg
   WlkCmx5cJblI26Mb2tdcpW/2gu+nsQh2ShjMbOpJz2krh60pUIHhRc3Q0
   kVBDqKSX78LvSeHU5E0BZ6H1CcMVm83Ea8TdTCf+eePTtx0xyQtm1CCRf
   T5QItEmdPKXBwCUNDkV77vtkJPpeyTzk0zyOZ1MZlXlOWVFLB6CgozbMB
   1qMF9ATiDhO6B5R9ets9/hS36nZHcvM377VD1Ci/iRnvzprsm7LGw0PmM
   A==;
X-CSE-ConnectionGUID: JaP3jmn6Sa6NFHTKi8lDig==
X-CSE-MsgGUID: SoSU3cPZSWK3XmZAZ4aquw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="57673608"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="57673608"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 04:41:03 -0700
X-CSE-ConnectionGUID: MeFpQ6/eT/mWvp1FCI2ToA==
X-CSE-MsgGUID: rXu6xaM7Rv6cBWHP1miNsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="155096142"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 04:40:58 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com,
	vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH 0/2] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Thu,  3 Jul 2025 14:40:36 +0300
Message-ID: <20250703114038.99270-1-adrian.hunter@intel.com>
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

Here are 2 small self-explanatory patches related to clearing TDX private
pages.

Patch 1 is a minor tidy-up.

In patch 2, by skipping the clearing step, shutdown time can improve by
up to 40%.


Adrian Hunter (2):
      x86/tdx: Eliminate duplicate code in tdx_clear_page()
      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present

 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 19 -------------------
 arch/x86/virt/vmx/tdx/tdx.c | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 19 deletions(-)


Regards
Adrian

