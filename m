Return-Path: <kvm+bounces-50823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E4CAE9BFE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 677D87BCD0F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3DC25A326;
	Thu, 26 Jun 2025 10:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YO+p3nQt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116725A2BB;
	Thu, 26 Jun 2025 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934982; cv=none; b=HKhFA4U8rjXMLqigt7qoLS/W6slMM8y1h0dhRF3TPbnXvDq5xgYu3ZQb3fUzuUXBtuZZpBBlMH1Bknj62C3QmhpKGfMLGpfvdMO2mfKaTWhvOPMEv9CXGBWKPwIM/21n3e2cVtorO3GmjM3v/Dy4yM5N4gYkjRwlNOO5Stb9h7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934982; c=relaxed/simple;
	bh=CsCoE9byU2IgCA1iIlKbPKQVXTwbOzVqmOroeX9C3f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1PzVtTAwKARoOm3BaMCxB6T/mqwNIBcVJnd+iLnjnIbkxPSb5QsOET1feWNbPlDvGF3HAsmA19jVFxB5hsbAD9P8emPA1Lt31T+oBTDmAJfllp/pNLjBrxUdT1JHtqxAYDMhwg6CadHPh9NEcHs/1NNGaghcvcHrI+RPQF4q7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YO+p3nQt; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750934981; x=1782470981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CsCoE9byU2IgCA1iIlKbPKQVXTwbOzVqmOroeX9C3f8=;
  b=YO+p3nQtzpjOTSR3McggP1RwK7pRI8eH51fqWjjeNGYc11TxmEgvRFaE
   DAuEjfELk9f28VAs+3L/+B5qAATR7m2qXwL09XCuRXeGFQzSDR7CawwBS
   UhDbcRFh9v7bb0Ot0h7L5EcPUiDEulTk2UUxgddy4P+vKYN/8ZhZS7zuA
   cnm1xEJAlGMFnZGemhWi4ZI54UNwYPzesDhPk7nxVpO3eqmG/rlefEIwv
   De2XZe/RdKJ2oukWI2vmGS7w73YFqINgUezwJ8dRnHvfeiTj7qwAnNVtH
   tkEMDbAYax3MK6DvQRd5kW1+gKy12IM7lescHcadsWAQqMCH+P29W0cAU
   Q==;
X-CSE-ConnectionGUID: yrrNWl8NTB2+XdHBqVi93g==
X-CSE-MsgGUID: qUiZMSFRRKOM8B8RgWS6Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70655793"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70655793"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:41 -0700
X-CSE-ConnectionGUID: 0ZYWh4imS2ugWwG0dV36Jg==
X-CSE-MsgGUID: cW8DHNfmQAWty0ijddpglA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152784336"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.86])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:35 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with TDX partial write erratum
Date: Thu, 26 Jun 2025 22:48:49 +1200
Message-ID: <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750934177.git.kai.huang@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some early TDX-capable platforms have an erratum: A kernel partial
write (a write transaction of less than cacheline lands at memory
controller) to TDX private memory poisons that memory, and a subsequent
read triggers a machine check.

On those platforms, the old kernel must reset TDX private memory before
jumping to the new kernel, otherwise the new kernel may see unexpected
machine check.  Currently the kernel doesn't track which page is a TDX
private page.  For simplicity just fail kexec/kdump for those platforms.

Leverage the existing machine_kexec_prepare() to fail kexec/kdump by
adding the check of the presence of the TDX erratum (which is only
checked for if the kernel is built with TDX host support).  This rejects
kexec/kdump when the kernel is loading the kexec/kdump kernel image.

The alternative is to reject kexec/kdump when the kernel is jumping to
the new kernel.  But for kexec this requires adding a new check (e.g.,
arch_kexec_allowed()) in the common code to fail kernel_kexec() at early
stage.  Kdump (crash_kexec()) needs similar check, but it's hard to
justify because crash_kexec() is not supposed to abort.

It's feasible to further relax this limitation, i.e., only fail kexec
when TDX is actually enabled by the kernel.  But this is still a half
measure compared to resetting TDX private memory so just do the simplest
thing for now.

The impact to userspace is the users will get an error when loading the
kexec/kdump kernel image:

  kexec_load failed: Operation not supported

This might be confusing to the users, thus also print the reason in the
dmesg:

  [..] kexec: not allowed on platform with tdx_pw_mce bug.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4519c7b75c49..d5a85d786e61 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -347,6 +347,22 @@ int machine_kexec_prepare(struct kimage *image)
 	unsigned long reloc_end = (unsigned long)__relocate_kernel_end;
 	int result;
 
+	/*
+	 * Some early TDX-capable platforms have an erratum.  A kernel
+	 * partial write (a write transaction of less than cacheline
+	 * lands at memory controller) to TDX private memory poisons that
+	 * memory, and a subsequent read triggers a machine check.
+	 *
+	 * On those platforms the old kernel must reset TDX private
+	 * memory before jumping to the new kernel otherwise the new
+	 * kernel may see unexpected machine check.  For simplicity
+	 * just fail kexec/kdump on those platforms.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) {
+		pr_info_once("Not allowed on platform with tdx_pw_mce bug\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* Setup the identity mapped 64bit page table */
 	result = init_pgtable(image, __pa(control_page));
 	if (result)
-- 
2.49.0


