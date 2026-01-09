Return-Path: <kvm+bounces-67634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE088D0C061
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 20:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 16B99301A306
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 19:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBC72E973A;
	Fri,  9 Jan 2026 19:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nglkrs6V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740522E54CC;
	Fri,  9 Jan 2026 19:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986087; cv=none; b=YoWlAYmtAHye8VQIiV5epXq2JbD2uT9PMXazqDNJdDOOf4MZq7o2CGOl16S1vLwYe0BnEeYjocsZYM1qpZty665+7EZYaaiB3jFAvHs3wQi9O6fklDnSLXEoCm+RpUdqShuK98FPNTWWETOCu/5cemCctbAQolXNGARVCVfxhAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986087; c=relaxed/simple;
	bh=7PTXKBjvfAD9+fhj5VBqVUtSsL64VvFvp60LFk6zr00=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hok9qGXOgNN+DlC1rRzZRfB+2MCokdNvRpAV2iQIXcJOYzeCQRMdbHzCovYCSSdYqTd9qOZoXpckwHuPb/ILs0ca4X0XpF4PerZxlDSRaFqQfTA+z1nVIhL8+S9e2qGsjgaHVumEJTfYPVMK0kD0ntGh6w0U4BcDwUnMoGYshp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nglkrs6V; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767986086; x=1799522086;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=7PTXKBjvfAD9+fhj5VBqVUtSsL64VvFvp60LFk6zr00=;
  b=nglkrs6VA3xBdhLzxIaTb431Hekkb8QzbssV2rFot4afO0vZDmUdy8+r
   9mozMnwi0EVkFndZsWG5e/ey7WKKbmlngH9ag/TwWUz2wbf8jp1jiriTf
   i7v581S++mitxN4WmudwZ4PSjEncdwy/V8fKcFgyzARqSdhG/lFhSIlQh
   1XxSYNz5tKi7+HpIuRBF1V22hVNqy2tIny74J4/dsZ8hwt3Bw2oZ5lLMr
   j80bgLmVoCVB6QNTzlRuTj5GDij3tdFx0Fj2DYwK4pcUJtvSQRM45TrzI
   ySjZvIMGsGNVQMkcMGlCVpjOK3dYM01fYTvprdSQ62RIQZjpo6KPsV8xZ
   A==;
X-CSE-ConnectionGUID: LFAjU2ZvTTmtek9PKnEPdw==
X-CSE-MsgGUID: Y+6WrbLWQRGquaubo0O5wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="80824246"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="80824246"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 11:14:46 -0800
X-CSE-ConnectionGUID: ADrwN2HYRyeOKJCp+MWtow==
X-CSE-MsgGUID: maaW5xOoRjOXG1Cvd9qE+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203456685"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.223.127])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 11:14:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Date: Fri, 09 Jan 2026 12:14:29 -0700
Message-Id: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJVTYWkC/42NUQqDMBBEryL73ZS4tEnpV+8hImmyrQtqJEmDR
 bx7oyfo5xvmzawQKTBFuFcrBMoc2U8F8FSB7c30JsGuMKBEJWupRXJLNweeUjd69xmoyxR2SdD
 FGk3OliZC0edAL16O6aYt3HNMPnyPp1zv6R+juRZS3BCfxlyVVugepUTD2foR2m3bflOyicLAA
 AAA
X-Change-ID: 20260107-tdx_print_module_version-e4ca7edc2022
To: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
 kvm@vger.kernel.org
Cc: x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-e44bb
X-Developer-Signature: v=1; a=openpgp-sha256; l=2397;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=7PTXKBjvfAD9+fhj5VBqVUtSsL64VvFvp60LFk6zr00=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDJmJwfMu/GOXDZm2vLQ/4PUVvZzgq6+bpKft6e577TxH3
 eXdDuXqjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEyk4jsjw/ajJm/T7n38Zei+
 KvurrJve5feVm/+lv75uml6Rvu69qDfDf8/D4ec9GFjSy+MjGlwWBYm/f9Cyof8q20vOHbu2/rJ
 7wQQA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

=== Problem & Solution ===

Currently, there is neither an ABI, nor any other way to determine from
the host system, what version of the TDX module is running. A sysfs ABI
for this has been proposed in [1], but it may need additional discussion.

Many/most TDX developers already carry patches like this in their
development branches. It can be tricky to know which TDX module is
actually loaded on a system, and so this functionality has been needed
regularly for development and processing bug reports. Hence, it is
prudent to break out the patches to retrieve and print the TDX module
version, as those parts are very straightforward, and get some level of
debugability and traceability for TDX host systems.

=== Dependencies ===

None. This is based on v6.19-rc4, and applies cleanly to tip.git.

=== Patch details ===

Patch 1 is a prerequisite that adds the infrastructure to retrieve the
TDX module version from its global metadata. This was originally posted in [2].

Patch 2 is based on a patch from Kai Huang [3], and prints the version to
dmesg during init.

=== Testing ===

This has passed the usual suite of tests, including successful 0day
builds, KVM Unit tests, KVM selftests, a TD creation smoke test, and
selected KVM tests from the Avocado test suite.

[1]: https://lore.kernel.org/all/20260105074350.98564-1-chao.gao@intel.com/
[2]: https://lore.kernel.org/all/20260105074350.98564-2-chao.gao@intel.com/
[3]: https://lore.kernel.org/all/57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com/

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v2:
- Collect review tags (Kiryl, Rick)
- Reword commit messages for clarity (Rick)
- Move the version print get_tdx_sys_info() (Kiryl, Dave)
- Link to v1: https://patch.msgid.link/20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com

---
Chao Gao (1):
      x86/virt/tdx: Retrieve TDX module version

Vishal Verma (1):
      x86/virt/tdx: Print TDX module version during init

 arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20260107-tdx_print_module_version-e4ca7edc2022

Best regards,
--  
Vishal Verma <vishal.l.verma@intel.com>


