Return-Path: <kvm+bounces-53362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D744BB10A91
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FA29AA7C46
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454E92D46D7;
	Thu, 24 Jul 2025 12:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ly8SNqXX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051E71E4A4;
	Thu, 24 Jul 2025 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361310; cv=none; b=Ss2uAfm+b/Qe9Oegr5PNYJyuZrKN1EULEOT352wDnSv3hKUYIG6QHvJt9Ht8BJrbFfJ02yhOON0/hKaKdXHJMwL/GA0UO4BVogDvxKTGZPg/Fm5r/IMJe8y6CpY1JhJEasp6f1FsVA1QAog8cAOtkBB2nsWWaLyci/BzQ+TPhgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361310; c=relaxed/simple;
	bh=f6B8tyg4/DD96dDjC8BDeC/T9795XQNZuf4iiTQjIU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P6LhE0KUWQ1Ih1liI+HlwddxbM8XUiILyZVgkeW5srR5UXxQb9uU3dd7zbhQ6Xg9CUQgfIlZeU+rQyaRvo2gyycalhpm7kpVTXmyz6LHWOBcGWUbcD32NHLxhMwMyRduePx8RCr0q92qolkaV/r7OKrfOgi0gbU/PrKtW0+Yfjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ly8SNqXX; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753361309; x=1784897309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f6B8tyg4/DD96dDjC8BDeC/T9795XQNZuf4iiTQjIU4=;
  b=ly8SNqXXYW+VCcQ7ID/bRAsAOzs+NLZRdc+4JZstX86GIRMwVlQJwXAT
   iErDVdQ3FRgv/EDlGfjdD8ClJLDc6wZ+MRDiEZy5W/OSBIWKjDPZNEv5u
   4uGy0899rwPYZynbSF0JQVg0onqEe6iXZf6H8fualD64TA+7C/BK/9y9T
   rfTwWK0A6pQKy8Mgdb1H85STKDkgJqwgK2imb4s/CbQEGRhJw8x7Fqt75
   uTKcsYDfFbQ59Ovg4h7BZClKEMgx/r6At8/atvuX2w/a1T8Ov1fJaSwt9
   jFo++de2YJ29uTrziqYGBfFTPI+jGjLXPp9CT6v6H+cYX8/sxUPKDGGpr
   Q==;
X-CSE-ConnectionGUID: VcNMZ9TKSZmxrH5FL+qK3A==
X-CSE-MsgGUID: gnwrimpBQP+M4CE3/lYB0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="73253580"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="73253580"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:29 -0700
X-CSE-ConnectionGUID: Ow1Je+GkTqaOxwnNXcDx/w==
X-CSE-MsgGUID: 6gTtnYi0RQ+zulqJKixC2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="159460392"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.21])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:23 -0700
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
	kas@kernel.org,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V5 0/3] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Thu, 24 Jul 2025 15:48:08 +0300
Message-ID: <20250724124811.78326-1-adrian.hunter@intel.com>
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

Here are 3 small self-explanatory patches related to clearing TDX private
pages.

Patch 1 and 2 are minor tidy-ups.

In patch 3, by skipping the clearing step, shutdown time can improve by
up to 40%.


Changes in V5:

      x86/tdx: Tidy reset_pamt functions
	New patch

Changes in V4:

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Add and use tdx_quirk_reset_page() for KVM (Sean)

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Add TDX Module Base spec. version (Rick)
	Add Rick's Rev'd-by

Changes in V3:

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Explain "quirk" rename in commit message (Rick)
	Explain mb() change in commit message  (Rick)
	Add Rev'd-by, Ack'd-by tags

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Remove "flush cache" comments (Rick)
	Update function comment to better relate to "quirk" naming (Rick)
	Add "via MOVDIR64B" to comment (Xiaoyao)
	Add Rev'd-by, Ack'd-by tags

Changes in V2 (as requested by Dave):

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
	Call tdx_quirk_reset_paddr() directly

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Improve the comment


Adrian Hunter (3):
      x86/tdx: Eliminate duplicate code in tdx_clear_page()
      x86/tdx: Tidy reset_pamt functions
      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present

 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c | 36 +++++++++++++++++++-----------------
 3 files changed, 24 insertions(+), 39 deletions(-)


Regards
Adrian

