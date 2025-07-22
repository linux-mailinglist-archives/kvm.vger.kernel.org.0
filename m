Return-Path: <kvm+bounces-53121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C8DB0DA96
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73806546428
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D3828C2DE;
	Tue, 22 Jul 2025 13:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MtrjH8Wp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E8A3B19A;
	Tue, 22 Jul 2025 13:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753190171; cv=none; b=lgVnicm94IbdR9lzsyHBIl04xVUjjZYsY9QTs9lG052Hm7rU8h0ba/mjgBSTqZJzI02PN3ICdfAGPZ/kksjEH1fUzn6S9miHhVwKQO0FxkXySGw7JkHIdqEuDc38ha2kT5Ph0rPRe1AC/33F4T46bs3GOMFt235bBbIYLB9nvCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753190171; c=relaxed/simple;
	bh=2ur+ftjY34EO8tfo3ES9C3DWlfzYj9Fk8ptTogFmi1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O+B72NJ5AddVnP5wpDmi/77lcvbkSFNOvm4SVNU1huIU6nYTEBQwas7m2d3oy6toWhpj+xUzs9rFwXP5jGKQBmiuydZu9sum9lBYyANWHJDuHzyx11mHYxqiCZBF762vo0Y/VgsITuWDwSGwCC/t1ma4SZuOWsyyMLtMy9SyoIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MtrjH8Wp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753190170; x=1784726170;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2ur+ftjY34EO8tfo3ES9C3DWlfzYj9Fk8ptTogFmi1A=;
  b=MtrjH8WpD4glPakZQiR+Sb/FEZVSfStV2+IdmzAEQnTHRO3eXJoaNDf3
   +6xJCO+R9sX2Hti1W4ErDU9KewfcV1MzN3tSts3aMoLmhpjFmD6wXxQIZ
   NZzpgDO3yNyRKf95rnp7ipSt3fCL1+5YlGmu8SE3Nl9Eb4BOgDZf7DTrg
   D3Kej8EVULXTOchU54bFBbYjNdhcO0s2ncojX+7NgAx0JunFm0P3/UBIR
   FbT1V7Nu5yqUk3CbFVbDslBY+/ZVcaoOpZmJY4ta6/8P0xb9FV9Gfm3gz
   wc1mH62I/KTTrhFq/ay3lSs8FaDh3Bxaw3XDHAaeFBiBUe+dPB188NhDO
   w==;
X-CSE-ConnectionGUID: ssW2ilLuQKyhXtDN2ltk6Q==
X-CSE-MsgGUID: OlgZtIr/RlSiH1UNXPyNRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="72893078"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="72893078"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 06:15:54 -0700
X-CSE-ConnectionGUID: QwNXoEkaQLyJ79Y1adJ/bQ==
X-CSE-MsgGUID: 5Dn9xFp9TuiNoX2nzDz5gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="163695133"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.161])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 06:15:48 -0700
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
Subject: [PATCH V3 0/2] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Tue, 22 Jul 2025 16:15:31 +0300
Message-ID: <20250722131533.106473-1-adrian.hunter@intel.com>
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


Adrian Hunter (2):
      x86/tdx: Eliminate duplicate code in tdx_clear_page()
      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present

 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c | 15 ++++++++++-----
 3 files changed, 15 insertions(+), 27 deletions(-)


Regards
Adrian

