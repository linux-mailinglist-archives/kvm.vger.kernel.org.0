Return-Path: <kvm+bounces-7100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0FC83D66C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E84E51F2B4F4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A25913DB9D;
	Fri, 26 Jan 2024 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWAYMfU8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2735D2561B;
	Fri, 26 Jan 2024 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259403; cv=none; b=EGJ8btAxPp9mcbTcDk8YHJfZYxAP7YQXhBbVNln4Z80TynxRXMTrcmn0DaeyzqH5R5vKTaXXH83cZvDZ4I6PjmjSOsWoNCJc+GrlKtHJ8ISMFDUnYvplegsXhrNb6f1A3uFcKynSEY/kYWOxQHMnsXsiR4C7g3kMrRYpZMmy3Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259403; c=relaxed/simple;
	bh=3CbxTSm9jdE8JbYcfkb6TVTOH+n5IRNFO96I1VKzzlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NFmfqzYgROQ4yleVIAtX7s/BZyIbiNaYeq4WsoM8M+IwWIszc/Lrf5+9Ck02LGB8SmTnTXL7WwAjdo/sSRA44dp7ZFtMP0bT1OUAeHHYm+eVPAckKhGgZX+WUvhFOdxt8hx8l8nslOy0VSLcXC6CyEgt7GF2JGaqJRoCMDPzYIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jWAYMfU8; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259402; x=1737795402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3CbxTSm9jdE8JbYcfkb6TVTOH+n5IRNFO96I1VKzzlQ=;
  b=jWAYMfU8RPu0IaFuvRQOtQyOgaxv2LekqFqDUVsqeEzLEJQj4zOo89IB
   +35CDdwN1bztxJw93kc4PT6/oFeKLipMGZym56ZnZaZ3oocIIHlyjtRJM
   oyrUx+du7+Y0lnoexajugsXEaUQL3xqyM88Wu/ozUp85nUhwnPMk0ll5l
   B+Xho/sx0S1z5S9bbTrk8zvls8+hvHM9NqFHKAnYN2XLGMC/ozMHH/n2g
   TBF61mgY/nIruCSEEiZYdH3gKUC8Sp6N3GpBPVkbmGGAzOA16REyBEc1N
   Ij7AGYGudLyE7iD8+7+7qih5K7r4tePEah1e7TfYrxoFp5QllqsD93SwM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792254"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792254"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310035"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310035"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:36 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 13/41] KVM: x86/pmu: Add a helper to check if passthrough PMU is enabled
Date: Fri, 26 Jan 2024 16:54:16 +0800
Message-Id: <20240126085444.324918-14-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mingwei Zhang <mizhang@google.com>

Add a helper to check if passthrough PMU is enabled for convenience as it
is vendor neutral.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 51011603c799..28beae0f9209 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -267,6 +267,11 @@ static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
+static inline bool is_passthrough_pmu_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu_to_pmu(vcpu)->passthrough;
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
-- 
2.34.1


