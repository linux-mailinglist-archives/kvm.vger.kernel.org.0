Return-Path: <kvm+bounces-23934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E9694FD13
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDE1DB21F37
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B4323774;
	Tue, 13 Aug 2024 05:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eglsBmZH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C61C286;
	Tue, 13 Aug 2024 05:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723525870; cv=none; b=Yj7ta6pJRtASci2mtOWwCob8e/QiX3yqKQ+Z31SrINBlDI255H2uAlscleG/0SQlVnpMKJwAEPP0Uiqu7Rxi873NMWIjrYqnYrwDXS7nOTQEkQUG1OryT1duv4c+T5EXnGyM+I9cKgp5IMr8xZX8x/4ZxcpeeNpIPgv+sHrqo5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723525870; c=relaxed/simple;
	bh=l5S9FP2gPA30fS5/wtCl98JtX22K66jXcZthdK+osnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WhJTiY0tElzgg7RfoRmkc1uDPV1z8MYC1px9KyaHSXRuiMQFVofrxewPDsjg+rTc2S6cudNeGUQtzuBRX0YXg6DXV7dg+3wKRfI60TbiWX3v6VPm6Kkfdmvdkl6m9fRTkesx6kLupPz1TRWEWR3BMeZkk/WgQoQHKOTBR/Y5oCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eglsBmZH; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723525870; x=1755061870;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l5S9FP2gPA30fS5/wtCl98JtX22K66jXcZthdK+osnA=;
  b=eglsBmZHCgRnCGVUVomiNVADzGtY4U914GK2RcIzXCdPZ1O1oj7kdSAh
   /nBstjl7LwnPaMm8fORpt3wb4NQevAuNF4Vzw0RbWEbHqsv0u8YWZ81EO
   wqFEJ6kvujhurdx3iglxaIYoDjV5oZ8/PFlE/JlF6a+T3i8czjdOE/KaM
   7dfScZOE5TS0vIa39q+DqsJSG4EoFRNqkhWCLDJsbJQJqY7IM0d/gNtAN
   RWrgAlBGmHLy3w9PsYmfm9BZaxc9w3PiSiegDsFFchijdr/RNeh0YWhE6
   W0OG5IdrG2uOFiI+q+DgOD0vZV1WMGpzwZNUrUsnm7u8fROtYGTfXg3B7
   g==;
X-CSE-ConnectionGUID: 6MN+h7SNRt6klPvGycohXg==
X-CSE-MsgGUID: 1ZWrqFMDSCyMRIvUiEVimg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32239355"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32239355"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:11:09 -0700
X-CSE-ConnectionGUID: 76AqA+ntTjOqikgLMO+mnA==
X-CSE-MsgGUID: MizJilJVT/SsMd1qsJqnOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58185520"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:11:04 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 0/2] KVM: x86: Check hypercall's exit to userspace generically
Date: Tue, 13 Aug 2024 13:12:54 +0800
Message-ID: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently in kvm_emulate_hypercall, KVM_HC_MAP_GPA_RANGE is checked
specifically to decide whether a KVM hypercall needs to exit to userspace
or not.  Do the check based on the hypercall_exit_enabled field of
struct kvm_arch.

Also use the API is_kvm_hc_exit_enabled() to replace the opencode.

---
v2:
- Check the return value of __kvm_emulate_hypercall() before checking
  hypercall_exit_enabled to avoid an invalid KVM hypercall nr.
  https://lore.kernel.org/kvm/184d90a8-14a0-494a-9112-365417245911@linux.intel.com/
- Add a warning if a hypercall nr out of the range of hypercall_exit_enabled
  can express.

Binbin Wu (2):
  KVM: x86: Check hypercall's exit to userspace generically
  KVM: x86: Use is_kvm_hc_exit_enabled() instead of opencode

 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 6 +++---
 arch/x86/kvm/x86.h     | 7 +++++++
 3 files changed, 12 insertions(+), 5 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.43.2


