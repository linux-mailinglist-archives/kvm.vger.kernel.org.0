Return-Path: <kvm+bounces-7095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBCB83D661
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1924428AFB6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6B013AA2C;
	Fri, 26 Jan 2024 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSgn7Ve2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2E613A258;
	Fri, 26 Jan 2024 08:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259378; cv=none; b=cmKWR83tpa+TO3QRl7XvAMSrp5/CB9nOckTH7Kr0rpWIoUUIyYYdmeJvnY2i+qZYaJpCzHCdS5epsjjaZDqwiBhJSPM/jw9Yt4v7pp3u/tfPf6MfepPxzQRKDL1eLFZJNAkjCrwxknzn43dP5fKb0rjlgH2fpM7WWlLJW1RJaAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259378; c=relaxed/simple;
	bh=sk50AeICiuzbmUFMWt0doHegxV+qoCoxmVRzVH3ArVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dbMJnU+4P9zwN72mqDX0CSTU4tMbPppFzabhO4OhAfnXEyuP8mM9xoUcbFIPvXYJGJcVcFIJRfcLY47u7Qu1YiYw6RyoQeXU5OFsqKj4zOb1+QMb3W6D2eQ3j6rDFE2qsbXrI2Jgcnea795YjDmF4FeVbYVwYiKMyz03jB/4J7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSgn7Ve2; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259377; x=1737795377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sk50AeICiuzbmUFMWt0doHegxV+qoCoxmVRzVH3ArVs=;
  b=SSgn7Ve2GsgeIrbD2OlWH2YSxTGCCG6JAKsBU9f9WIxsNWU3zJfpZ2z7
   E0FS3RS2xAxmOAzgKpyt5o6xGGzMEy7AmAFyMuuCTAfQdS4kjmSMIeDzq
   R2OHtd/bOskFFNFq2ZWXOjuVtGRbDn7ImVWpdKzrlSKMgp1UEhYaIo6iX
   CRjd4sa6a5yXes0lnAXqM0MyliqlTZtZm73yEXo+/dZ59Fz2ZbIVP1/UO
   fqFb0GViCeo4bOnpyb/ZUeGQ7g8E2/iIXPb6Mz++vqEk4vtCPWgnGjaqG
   enproLrLDEVIfe0bvLTU0fdyxdVLLT6UMDUK4QTILGeMfdtyrXkxBxqZm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792137"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792137"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309950"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309950"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:11 -0800
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
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 08/41] KVM: x86/pmu: Add get virtual LVTPC_MASK bit function
Date: Fri, 26 Jan 2024 16:54:11 +0800
Message-Id: <20240126085444.324918-9-xiong.y.zhang@linux.intel.com>
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

From: Xiong Zhang <xiong.y.zhang@intel.com>

On PMU passthrough mode, guest virtual LVTPC_MASK bit must be reflected
onto HW, especially when guest clear it, the HW bit should be cleared also.
Otherwise processor can't generate PMI until the HW mask bit is cleared.

This commit add a function to get virtual LVTPC_MASK bit, so that
it can be set onto HW later.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/lapic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e30641d5ac90..dafae44325d1 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -277,4 +277,10 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 {
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
+
+static inline bool kvm_lapic_get_lvtpc_mask(struct kvm_vcpu *vcpu)
+{
+	return lapic_in_kernel(vcpu) &&
+	       (kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC) & APIC_LVT_MASKED);
+}
 #endif
-- 
2.34.1


