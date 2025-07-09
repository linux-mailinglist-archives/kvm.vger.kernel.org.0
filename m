Return-Path: <kvm+bounces-51873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0D2AFDF4F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 081C81BC24BC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8354326A1D9;
	Wed,  9 Jul 2025 05:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A9ykDp+9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D821B6D08;
	Wed,  9 Jul 2025 05:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752039508; cv=none; b=odbDwWtgB4tDTxrALdBh8XeTVcyd7PdJVZPyiez6lrbgcNQ1r0I2NtG5cT0lXEbm6FfpsAcgUdPI4PZhfCKEofxRaMw5NTS0HONo3yHgCGC+l/fMejEjdNd8hxj8fCOYaN0F0wFQoJndn4DGMGRX0aziblHJ5twwBoq3V+5hQwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752039508; c=relaxed/simple;
	bh=WUBqk7E011dzmyg3K9cyVhh9qRzOB5Xh2/z8QE+EXTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkL0W6LlyrH4VpxA58sd7/PpBQRBTIb0/0Mi7qZZz+udIHbfrlT4Avp/+Ju0BGvtfrRqMjA165/amyxkBKS4KSBBSzrHxD3Nlm42qQ//u0DuTjsb8jfk87erhICxuG5SkrMQTQ5Wbqz/tGdfAZNqomf6vcoCs5to1J0zmhzcXEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A9ykDp+9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752039507; x=1783575507;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WUBqk7E011dzmyg3K9cyVhh9qRzOB5Xh2/z8QE+EXTA=;
  b=A9ykDp+93qQLgf/54kh6JHDzkSWAAdaDbpABhGXl5CNrSK1qlgtGA9rz
   oUkXbIs1HwBdmLyNdl8SWVWrhGYM+b5zG7qtdjJGbMI/RNMlE92tyCxBp
   M3R521z6LzWLx5ncpD/JwNu6ppexvvldEVEHGPsCVkJ3NsgW/J+5FmPiM
   3eIaxSCgq4Gv5fMHBCjg8Ucu3jFCpmkGmOxvgLowDsXMsDCzIscaQXhlU
   SX7sOTpkw7+/baNaQSzm/B57D1retX1g9nreZdDw26eQKxYEMwcXSvG1m
   stetF6NW5ZyY58k8kMcMFbUOxZzcFFGNWKYNJ4STGhkwRMpDY4PJa+uRC
   Q==;
X-CSE-ConnectionGUID: dBxVQUBLQaCf9XniIG7LkA==
X-CSE-MsgGUID: k0mmwugCTGiDPl/MPaGieQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64871153"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64871153"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:38:23 -0700
X-CSE-ConnectionGUID: 8fiJ6TpMSLasbS9l8OF+Mg==
X-CSE-MsgGUID: CoWV9E92Sli9QlXcppXhxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155799366"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.68])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:38:20 -0700
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	nikunj@amd.com,
	bp@alien8.de,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Improve KVM_SET_TSC_KHZ handling for CoCo VMs
Date: Wed,  9 Jul 2025 17:37:58 +1200
Message-ID: <cover.1752038725.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series follows Sean's suggestions [1][2] to:

 - Reject vCPU scope KVM_SET_TSC_KHZ ioctl for TSC protected vCPU
 - Reject VM scope KVM_SET_TSC_KHZ ioctl when vCPUs have been created

.. in the discussion of SEV-SNP Secure TSC support series.

This series has been sanity tested with TDX guests using today's Qemu:

 - With this series Qemu can still run TDX guests successfully.
 - With some hack to the Qemu, both VM and vCPU scope KVM_SET_TSC_KHZ
   ioctls failed as expected.

Currently only TDX guests are TSC protected.  The SEV-SNP Secure TSC
support will enable protected TSC too and can also benefit from this
series.

[1]: https://lore.kernel.org/kvm/aG0uUdY6QPnit6my@google.com/
[2]: https://lore.kernel.org/kvm/aG2k2BFBJHL-szZc@google.com/

Kai Huang (2):
  KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest
  KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU has been created

 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)


base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
-- 
2.50.0


