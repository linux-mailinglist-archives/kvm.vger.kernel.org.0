Return-Path: <kvm+bounces-30440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 345E89BACAD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D13C281B79
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB2218D626;
	Mon,  4 Nov 2024 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i+IZSSc/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00FD38F97
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730702516; cv=none; b=JhlVccNcbg5yT/qzqYOvNXkBuiMiYQkumLwHC55ttKRhRbmeN7dzcSsqU+HT88tRPflM2q7ZhuyOxc0trzzHMCn3Zg1uNQex52i59HzN+oRXhflaqx7AgxWyLRplUvF7+DMO8z5eutQLmRdecrNzm++Zt/FeA7C1qW5Ktld8+RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730702516; c=relaxed/simple;
	bh=3UHL3/+njCwkEFSSv1CU6vFBou+lWdss7a+3MOMdV7M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uVhh8qIS2I9+bRyouUCgK/HQGYhUT82w3S/9Fdnp47b+2s9LfQIhcbkigv+mqfW2VqKdGaz8pOR3aTg1fHjSEgwNEFxjxPe4UVhu04r1HARfaimDRsVfuvan295KWyGM+ugIG30Wa8WkmYNBHBF+R3E9jGRXaQYqUcZN2jr2BG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i+IZSSc/; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730702515; x=1762238515;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3UHL3/+njCwkEFSSv1CU6vFBou+lWdss7a+3MOMdV7M=;
  b=i+IZSSc/JQxfnqMr3dXskAVm8Hc2dCflmg5CgzHQiczdivx0ZRr9exXT
   bvFFVy6ndQYb5BnT13uMsYpLbLWxRMUPNDzarqhPwqX9Jt9OynK9nnLwx
   /S6kfKkCYf4XcJOgLse/d9wk4moPWfubr4kbHSIE61N5LYowIfK228sQ8
   YZEvwGCeR5BXHWrJHSxyjF5ckAIw98j//nHR6dmohGaBRQOGKq8wjnO7a
   mPIfG85KLIrxGi2dg98qKrir1nfe5xsF2jkR9bH0iQUqYoQLSXINQJUm5
   JDT8XopWYVSESZ5puLMpZV582ODAUy+eMUCUkha/ziMfcFDKPqoepnYT2
   g==;
X-CSE-ConnectionGUID: K1jrh8ZxRp+4AJcRs5Q23w==
X-CSE-MsgGUID: q1sEEOpIQFqT2/2uTuU4ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41776697"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41776697"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 22:41:55 -0800
X-CSE-ConnectionGUID: /p2BW9arQVSAlcRFGE/3pA==
X-CSE-MsgGUID: qyXI1mwhRQ+644etGp95bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83902884"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2024 22:41:52 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org,
	x86@kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	jiaan.lu@intel.com,
	xuelian.guo@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH 0/4] Advertise CPUID for new instructions in Clearwater Forest
Date: Mon,  4 Nov 2024 14:35:55 +0800
Message-Id: <20241104063559.727228-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Latest Intel platform Clearwater Forest has introduced new instructions
for SHA512, SM3, SM4 and AVX-VNNI-INT16.

This patch set is for advertising these CPUIDs to userspace so that guests
can query them directly. Since these new instructions can't be intercepted
and only use xmm, ymm registers, host doesn't require to do additional
enabling for guest.

These new instructions are already updated into SDM [1].

---
[1] https://cdrdv2.intel.com/v1/dl/getContent/671200

Tao Su (4):
  x86: KVM: Advertise SHA512 CPUID to userspace
  x86: KVM: Advertise SM3 CPUID to userspace
  x86: KVM: Advertise SM4 CPUID to userspace
  KVM: x86: Advertise AVX-VNNI-INT16 CPUID to userspace

 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 8 ++++----
 arch/x86/kvm/reverse_cpuid.h       | 1 +
 3 files changed, 8 insertions(+), 4 deletions(-)


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.34.1


