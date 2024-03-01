Return-Path: <kvm+bounces-10627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B690386E00B
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E71C11C21077
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62CB6CBE1;
	Fri,  1 Mar 2024 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlK8xsP0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AF820E6;
	Fri,  1 Mar 2024 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292056; cv=none; b=ThVxE5dhrXLQW5hvD7PsJB4BUDpsG1g7anIBV0tJVHbmw5FDrX5IfbqiJ//Xbq5H71O/GMdZ4A9mKJFcCx7kCmNqL1tvW/jt7hSd2dJcfRqrfmlenMaPKv45+I5/3P+DgIE369zj7jtyFyhXGRfjgTPvl9FH6Z3CtABqRDXeDUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292056; c=relaxed/simple;
	bh=pgn5iVULKfWhEYNxsAf1VZCApM0QiVchZHcnD1k0Avs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aJi2iHdtwCKSB5RJlyWjZQcxeY+mG60c0xqxfhtpxdnhuA4LuW1M1wsU6e2HqwVVW4oxvriDVTrhWKEZsHg7eJrBnLMUL9XfaLVdl2GiraqGgixNiX8kldb5UcwiNp0ptWcfBeNO4x5o0Q3XDKUEpWUBNHtdLzZEZ/BUZEaZ0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlK8xsP0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709292054; x=1740828054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pgn5iVULKfWhEYNxsAf1VZCApM0QiVchZHcnD1k0Avs=;
  b=UlK8xsP0olN2rdNy5rjYDxOaic1sJkpsR+tnKRs+QMN6g2+ATGdZ03Ha
   oHF9zDTYP4Yvul/bKT81Tzqw+4xtmuB5j6MDCr7JiV5Mwre3RJ21ftG0Q
   o5dn0Rxw4xfKV0VL+wcasOjbfKI/nIKTD8B0ylf5ns7dW1OkNiVgJp0Bn
   FXMiz6NLjcYQzn12gjA2GYCr5CmAjY2JhXPbu1nT8upOFLajjeAfLWbbJ
   ZzlcvRYBJVJSYITv04AZCsDs2rnbqAufytrytU4jJpEytp2ZvoTh9Xm4E
   ZNj8zLxEq5aUaE0iRdatqGXgC5OpIGy1P+JrDNAqLi0jN3kW9ig7RbByY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14465006"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="14465006"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:20:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="31350664"
Received: from rcaudill-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.48.180])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:20:48 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	isaku.yamahata@intel.com,
	jgross@suse.com,
	kai.huang@intel.com
Subject: [PATCH 0/5] TDX host: Provide TDX module metadata reading APIs
Date: Sat,  2 Mar 2024 00:20:32 +1300
Message-ID: <cover.1709288433.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM will need to read bunch of TDX module metadata fields to create and
run TDX guests.  In the long term, other in-kernel TDX users, e.g., VT-d
also likely will need to read metadata.  This series provides common APIs
in the TDX host code so that KVM can use.

This series has been sent out together with the v19 KVM TDX patchset, and
actually received one minor comment from Juergen [1](thanks!), which I
fixed in this series.

Now I am sending out this series separately to reduce the size of the KVM
TDX patchset.  Paolo and Sean are doing similar things [2][3].

[1]: https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/T/#mbe96ac2b6560897083afdbe1db446a75a724e4e9
[2]: https://lore.kernel.org/kvm/20240227232100.478238-21-pbonzini@redhat.com/T/
[3]: https://lore.kernel.org/kvm/20240228024147.41573-16-seanjc@google.com/T/

Kai Huang (5):
  x86/virt/tdx: Rename _offset to _member for TD_SYSINFO_MAP() macro
  x86/virt/tdx: Move TDMR metadata fields map table to local variable
  x86/virt/tdx: Unbind global metadata read with 'struct
    tdx_tdmr_sysinfo'
  x86/virt/tdx: Support global metadata read for all element sizes
  x86/virt/tdx: Export global metadata read infrastructure

 arch/x86/include/asm/tdx.h  | 22 ++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 84 +++++++++++++++++++++----------------
 arch/x86/virt/vmx/tdx/tdx.h |  2 -
 3 files changed, 71 insertions(+), 37 deletions(-)


base-commit: 5bdd181821b2c65b074cfad07d7c7d5d3cfe20bf
-- 
2.43.2


