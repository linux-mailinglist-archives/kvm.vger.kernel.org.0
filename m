Return-Path: <kvm+bounces-12424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E904885E63
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59774281B97
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA8013F01A;
	Thu, 21 Mar 2024 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NhVoykaB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6113B79F;
	Thu, 21 Mar 2024 16:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711039087; cv=none; b=O9ewMgu5TuKo6cEBhu+A52MdQUehIu4uB09KmWbJHPJ5TtW5f+YC4TsIp40KDHjLOEw+OrebB1Ltzz7oRRGYLS95Ahj4GvmMksPl+qWHOtr8Qf8KIUFYOVXrX/DOVkCuJbKdmWuAr0qO7Udd6BrVlZLmQgp9iDpqLGFH+pRzO3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711039087; c=relaxed/simple;
	bh=P64UvqIPLZQFjj6ReZTc/GZtsS5RNgqfl1B0Cn1kB+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ppx/KA+9yS8fbz7+Okc4TXOJpiw7fZ2sWpCwfT/YncZGE1QFbvgvu6ignB2OycfFYkqwph1nXU3SOiWeKNLChVEEVqNX+z2pH0R7loD/PbguxlHpFhUwlqvZyOHALJweCkEE723kHIMbjej/rv3SUxqc0s20Nz+W0EzXRc1EBSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NhVoykaB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711039085; x=1742575085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P64UvqIPLZQFjj6ReZTc/GZtsS5RNgqfl1B0Cn1kB+g=;
  b=NhVoykaBhIhrkuoNWa9CUraltWqAPrnSriM39Rb5rard1Ef/AevNu6PS
   Rwwd6CAWj5pZcxrMmOSeV/QBZmLVhdopQ97dtkbkiOmJfaMGE0KF1aDwk
   ohx8S8qyl1auDj3vJxjNQFESJJp+T+bX62hOYXz4E0geqFnaeImwef0uB
   0qJ0hjnr1swvFgB3ghGW0sI0H5g/1XAVIiw8X+/N6/DCbtGfIpg9XtEz+
   8CPv3Vz2FP9HsB708PrhbgZu+/E5SdPXbpqidtAzPl4QdF74k/Gb6sdmj
   MgyC1xJ0750ahqrl5L5V7dnPhbZPB4gmtzGS6eezHc1ijgAyxs0NtWhoi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="31477562"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="31477562"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="19280010"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V4 1/4] KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
Date: Thu, 21 Mar 2024 09:37:41 -0700
Message-Id: <d815921fff4c616c8b05bff0fb9377a171c8633b.1711035400.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1711035400.git.reinette.chatre@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Remove APIC_BUS_FREQUENCY and calculate it based on nanoseconds per APIC
bus cycle.  APIC_BUS_FREQUENCY is used only for HV_X64_MSR_APIC_FREQUENCY.
The MSR is not frequently read, calculate it every time.

There are two constants related to the APIC bus frequency:
APIC_BUS_FREQUENCY and APIC_BUS_CYCLE_NS.
Only one value is required because one can be calculated from the other:
   APIC_BUS_CYCLES_NS = 1000 * 1000 * 1000 / APIC_BUS_FREQUENCY.

Remove APIC_BUS_FREQUENCY and instead calculate it when needed.
This prepares for support of configurable APIC bus frequency by
requiring to change only a single variable.

Suggested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Maxim Levitsky <maximlevitsky@gmail.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
[reinette: rework changelog]
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Changes v4:
- Modify subject to match custom: "KVM: x86/hyperv:" ->
  "KVM: x86: hyper-v:" and use standard capitalization for Hyper-V
  ("hyper-v" -> "Hyper-V").
- Rework changelog to remove pronouns ("we").
- Change logic in commit log: "APIC bus cycles per NS" -> "nanoseconds
  per APIC bus cycle".
- Fix typos. (Maxim and Xiaoyao)
- Add Maxim and Xiaoyao's Reviewed-by tags.
- Add Maxim's "Suggested-by".

Changes v3:
- Newly added according to Maxim Levitsky suggestion.

 arch/x86/kvm/hyperv.c | 2 +-
 arch/x86/kvm/lapic.h  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8a47f8541eab..1030701db967 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1737,7 +1737,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
 		break;
 	case HV_X64_MSR_APIC_FREQUENCY:
-		data = APIC_BUS_FREQUENCY;
+		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
 		break;
 	default:
 		kvm_pr_unimpl_rdmsr(vcpu, msr);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..a20cb006b6c8 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -17,7 +17,6 @@
 #define APIC_DEST_MASK			0x800
 
 #define APIC_BUS_CYCLE_NS       1
-#define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
 
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
-- 
2.34.1


