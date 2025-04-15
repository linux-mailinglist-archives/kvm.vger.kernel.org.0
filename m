Return-Path: <kvm+bounces-43338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9247DA89B33
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 12:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E539F3AC9DA
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 10:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1C02918EA;
	Tue, 15 Apr 2025 10:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KYJXxMSB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7461AB6C8;
	Tue, 15 Apr 2025 10:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744714168; cv=none; b=TNUyJRErcHQ0siYc9niHEkinRwWBDWDVrfqK7jq7g57lQJC23CMvFZohglTfVKQEgD2UP7IHgLMFNUhcvlk3YQBzMGii0OOViMIQCUOUOprj+PFw1yYyDqCkOcuBdbN+MsYXPfIqQ2XSeUrB2lM/DhLdbe9oUVomV251JmW4lLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744714168; c=relaxed/simple;
	bh=WDYEc4Tb9IEBFj4Iu3TZbc2Wv9rHYMydvooPb1yfFqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGxuAGgjEBCbt5Hy2o2wjyGdfjaQ8csmFI3AG7JHSkGnbijjpJ/BNP/Lhi6GwRjIjwi9Qd99EGnNJH9pVh6JCLrBUZ/LZkX7MFLfZbrClhzDZOQD58hYPk/ykaYTq4vqwHDJgJCGtdCp3lAgHJdGr2UT75nVFyYrJYRreaE02yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KYJXxMSB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744714167; x=1776250167;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WDYEc4Tb9IEBFj4Iu3TZbc2Wv9rHYMydvooPb1yfFqk=;
  b=KYJXxMSBHrBGH0q5VPpMMu+1cZh1y99TLaRTExH+LMj+9HIhD3/UHO2H
   InbhYMF1BFW3ujXh8lbzhl4RGupHSndT/y/jDi9amk7NsQO1bBRiJ3t0G
   dSyi1dSC36c/Q3XVsZhU3YLu6HUoJhQDHxoMTm3LWHxgivvLWgE6hSZfA
   OlAqSFVINX/r3sicWsYaLqGqDtiGrLtaiHtos9JjnajMOaP0+HKUBu6Xb
   S1XrAD9cOdhC6KIbfcPtzNjs0d8lJyak845X0fwiykEH1GYl1+j5sS2Yg
   cIG4BGL/2yikz2AAiQIdCZ9Wj/ESOxAA70UI3zVttbBO1v31hkQmXdiMt
   Q==;
X-CSE-ConnectionGUID: fWXUbIxNTSuHWsQ4HF6HpQ==
X-CSE-MsgGUID: gh2zmkKDQ0CaMGP6KcFFiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46132891"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46132891"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 03:48:44 -0700
X-CSE-ConnectionGUID: fXaDgnDyTqyf9u/aXkFZbw==
X-CSE-MsgGUID: MXM7NXJdRRKNvxEDSTYbqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="167254348"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.254.135])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 03:48:40 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH 0/2] KVM: x86: Correct use of kvm_rip_read()
Date: Tue, 15 Apr 2025 13:48:19 +0300
Message-ID: <20250415104821.247234-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Here are a couple of tweaks to dodge kvm_rip_read() in tracepoints and
KVM_PROFILING when guest_state_protected.

This avoids, for example, hitting WARN_ON_ONCE in vt_cache_reg() for
TDX VMs.


Adrian Hunter (2):
      KVM: x86: Do not use kvm_rip_read() unconditionally in KVM tracepoints
      KVM: x86: Do not use kvm_rip_read() unconditionally for KVM_PROFILING

 arch/x86/kvm/trace.h | 13 ++++++++++---
 arch/x86/kvm/x86.c   |  3 ++-
 2 files changed, 12 insertions(+), 4 deletions(-)


Regards
Adrian

