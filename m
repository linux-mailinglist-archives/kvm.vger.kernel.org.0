Return-Path: <kvm+bounces-16204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B8D8B66FF
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 02:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 618561C22418
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 00:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE241FBA;
	Tue, 30 Apr 2024 00:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PNQcTRA5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23639161;
	Tue, 30 Apr 2024 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714437950; cv=none; b=IF9PCNoYQfv3VzuAkhRnTdrdkI6y87UfHwQJ02UMo/qYEYljUSGmTjDDmSjH0E+XDm7Z6EIiT+rMjv9raNBdF9oNqtAHvVC6xzeXXoj70uC7/cyDnkONGWio7eUoZHaBl9E2JEFweqXJMyvzkbRCLJtzHnN0cmMfbQTeEF+s1dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714437950; c=relaxed/simple;
	bh=IETNoJ731yGtO8YaT0vZ74KAZZVPCO5X4Qoc3W+b/do=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UuoDSonr0YTcl4f3UjTmdwBi5Mn6MMT+nYJ924skz6KJlqEjA94p/dIrmcbmdyt7z5NMUv+SaT74O/CMqi9ABneieo2b220Fu9S0V8fdq2OBIvCtGO2zc7uX9n4gFuPGuMjt8mTpNnC/dMXKa89DqtKKA7/SxV85QsT6TDoh3VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PNQcTRA5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714437949; x=1745973949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IETNoJ731yGtO8YaT0vZ74KAZZVPCO5X4Qoc3W+b/do=;
  b=PNQcTRA5rGbu6dBIyslDfNPLqHtMw1Z9n8I9HTo8jBxqdWCV0WmgXnAA
   14c0QmrqCy9Zv6X4gG1PYBqTCHcsam8kAxN7XbXmbWDNrkHMeSPgSY8D+
   dV97Z3F5AyvFJJ/o9TLTcRaJafRUhdYVID8bARmpnNkBXlYWNf+kF2Dc1
   2oWMwyVZ7nQm0Rc7msv7aRlBe79iuxI9b5RZpeS92OHEJGsAv01f4CqX6
   T8OmIPo1jaqC52my0B1N6UJNOiYQZiWfeI5nHPNh5QIjY70qU5to4iLyS
   jjACeNExv8h9KovjOKlMO202B0WEL/izFYjqkkiGbwAWH5qzvfJrnAkCG
   g==;
X-CSE-ConnectionGUID: 2xtlqSBpQYO6k9gwk6Je4A==
X-CSE-MsgGUID: 9gh2D53oTT2YlyXMFWM34Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10658579"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="10658579"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 17:45:48 -0700
X-CSE-ConnectionGUID: MKyKWB56SYGsWdNZKZHgDw==
X-CSE-MsgGUID: XzWcFw9oSlSGxP+NQA+HAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="31079781"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by orviesa005.jf.intel.com with ESMTP; 29 Apr 2024 17:45:46 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 0/2] vPMU code refines
Date: Tue, 30 Apr 2024 08:52:37 +0800
Message-Id: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small patchset refines the ambiguous naming in kvm_pmu structure
and use macros instead of magic numbers to manipulate FIXED_CTR_CTRL MSR
to increase readability.

No logic change is introduced in this patchset.

Dapeng Mi (2):
  KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
  KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros

 arch/x86/include/asm/kvm_host.h | 10 ++++-----
 arch/x86/kvm/pmu.c              | 26 ++++++++++++------------
 arch/x86/kvm/pmu.h              |  8 +++++---
 arch/x86/kvm/svm/pmu.c          |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c    | 36 +++++++++++++++++++--------------
 5 files changed, 46 insertions(+), 38 deletions(-)


base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
-- 
2.40.1


