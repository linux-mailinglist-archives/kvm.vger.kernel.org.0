Return-Path: <kvm+bounces-52802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE42B09681
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 23:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5173C1AA7AB4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0E224502C;
	Thu, 17 Jul 2025 21:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YmBEuY8d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DD32376F7;
	Thu, 17 Jul 2025 21:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788855; cv=none; b=jLM5ECbrOGQOnkB3D7IKnwuEhttlHTri539aqMjJeQ+ftFA4eL+KxnEPgoA2YztKgLeFeV3+mxLZP5ugJuFtYJRUlVjJI3Uow1MRJ9xokpdI5djdcPmSYbAK8xyybybDWxjeA34cEni2+nOUKUu9KQPjT+pwBARdHZYrlQXa+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788855; c=relaxed/simple;
	bh=dxe4b3oYs1XGA3lOYDUbgaH5+CIfBWHOTQprCsqyW7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQlRx07q6wJX7QCxvEnmdd4u/NVUL0nM/uq04dFXAox8QIybGPzvHPg7cQBn1GRZqrI7LUF2vGCGiQch23KMtXtYzn3liyqW6QztBANZ/JvOx7FObwyEpw77vMyR0qd8aMHSFok2kjUriuG0l0+HIGUsm6ZXxi9ejLSpmVUhZGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YmBEuY8d; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752788854; x=1784324854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxe4b3oYs1XGA3lOYDUbgaH5+CIfBWHOTQprCsqyW7U=;
  b=YmBEuY8dDyrzM0O0oLrmf7UTWvNoUIfNeYRhY5J+7iH48k3j5YH34rx9
   EfNumPsyEUJDmqE0Apxf5wyjim1xq66ZAH6f6lIgFXEZAcApmHyosrlWJ
   eN9lGREVX/W9dKqBhE6eDltS/VpJylXDoHzxn3tSxJDyiXhQfNACf92MM
   0tvQEaqroWTFVR0CMSz5VkDsD1/Ar08puzbP6M8ZUDr/XcbOmkNjvSJi9
   NRZo4fWo3ubZtP4hLp90lQ37HLdhpJPMfVdZ3VcQMy5oJhqN4LH43+27F
   UHGyjm5dsLKStSXxG7vKHuzBeA/TDvoCDfAdqNHJ+GzOE1IAs+2E0p5p4
   w==;
X-CSE-ConnectionGUID: NgkPZMh3SC2KUapLKSfCBw==
X-CSE-MsgGUID: HR9Kv4x7S2C4vooMn5F8mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66527794"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="66527794"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:34 -0700
X-CSE-ConnectionGUID: h3Gq4unEQU6k0z4fWkd7+g==
X-CSE-MsgGUID: 9XSjIGwHQC21JsmDypIoVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="157295539"
Received: from vverma7-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.39])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:28 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v4 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX partial write erratum
Date: Fri, 18 Jul 2025 09:46:41 +1200
Message-ID: <8bce9b6cb33506e3a9f99e3ff966dc552417f6db.1752730040.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752730040.git.kai.huang@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
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
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 8f80a2e8cbb5..411b80a7e49d 100644
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
2.50.0


