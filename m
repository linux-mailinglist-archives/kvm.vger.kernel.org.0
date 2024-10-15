Return-Path: <kvm+bounces-28867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A03A99E33B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E27C283E7B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 09:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5EC1E3763;
	Tue, 15 Oct 2024 09:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SnZQ/82n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC6B1DF25F;
	Tue, 15 Oct 2024 09:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728986311; cv=none; b=KIo2rp6oU5DNF48uUfx0/mCSqW0BaLlWxqbSoPlwHgvYbxF7u8KCgvWZd7w9srZQEdYEJJXgmiXDMJLEhJ2aZVkz6bf+5fCNP/UOmNOiHxVTLy0nV/atn3Gwj0WXjSFMRjBleZBxksNEpUQxv+dCnvlqxd9eUtwdyB+clGd6zM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728986311; c=relaxed/simple;
	bh=EFjLdNc/R+TxB36k4XSzjZNz0ME/CSEs1oTBY4btMIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iGxH5ones7/DT225cl3Sle6bgAqoLZD8M4eyYCBKhAujRCTq8PxKU28FiH4pPoB9r5fx/d2Q4CcIj0R1OpGdBdXKxLW84ycTIbs1U1t/oB3pBI4KIx4y1oZybE6uX1+p4qc1pbImFvbPo/CzIy8xatJiw2cJQl8nZHaqhATH07o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SnZQ/82n; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728986309; x=1760522309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EFjLdNc/R+TxB36k4XSzjZNz0ME/CSEs1oTBY4btMIk=;
  b=SnZQ/82n1AFdwoBX/ydaZVH4fUU2uI2qVTW4dTETuExBB+Pcjlulk8Sj
   8KFgePBNrAIXar2tcwYzyLfR4I6+90/7KeoXiHH//9B+ESnweAo/+CQ9d
   OxF7GaruCnKbRLmVEJtjsbF0p8hkEc01XjfTiGQNfbx4TgN/8bes5uD3j
   B29I4J+NSuTPVskbrVRz5HTNTuR9o3muSus4U7Xn4hEtrQZOluBwItYs7
   4GCQhxWxkVZTHxcm6Ccdl8rJOzqs3ntlkXeLTQWa38f/+6f1XI6MnlWZ0
   szhotmXpD+7Yz3alZeDCpwdxIiAfPcCbicHv0hze0b8C+EneFNdOzPRu9
   g==;
X-CSE-ConnectionGUID: A6GiKeQ8RQu+GisCNvB+vA==
X-CSE-MsgGUID: utO2HkY7QjqY2F3XCMaqjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="53777732"
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="53777732"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 02:58:29 -0700
X-CSE-ConnectionGUID: qdNHGLVkRVa3jnbjaqTjlg==
X-CSE-MsgGUID: 2esUFg9XS0+7z8XuufHo1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="82626100"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa003.jf.intel.com with ESMTP; 15 Oct 2024 02:58:26 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 28DC1184; Tue, 15 Oct 2024 12:58:23 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Binbin Wu <binbin.wu@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and TDX
Date: Tue, 15 Oct 2024 12:58:17 +0300
Message-ID: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AMD SEV-SNP and Intel TDX have limited access to MTRR: either it is not
advertised in CPUID or it cannot be programmed (on TDX, due to #VE on
CR0.CD clear).

This results in guests using uncached mappings where it shouldn't and
pmd/pud_set_huge() failures due to non-uniform memory type reported by
mtrr_type_lookup().

Override MTRR state, making it WB by default as the kernel does for
Hyper-V guests.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: Binbin Wu <binbin.wu@intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/kvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 263f8aed4e2c..21e9e4845354 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -37,6 +37,7 @@
 #include <asm/apic.h>
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
+#include <asm/mtrr.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
@@ -980,6 +981,9 @@ static void __init kvm_init_platform(void)
 	}
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
+
+	/* Set WB as the default cache mode for SEV-SNP and TDX */
+	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
 }
 
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
-- 
2.45.2


