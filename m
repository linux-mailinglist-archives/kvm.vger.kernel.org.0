Return-Path: <kvm+bounces-15984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC498B2CCA
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C030C288F7A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB6C17AD8B;
	Thu, 25 Apr 2024 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7P0PYrr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1FD156242;
	Thu, 25 Apr 2024 22:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714082835; cv=none; b=WkY7liyaNs0CEANJa9UechP17Ed6DRKmv4ypHg+7AiAyh2OTbwi06e3MyJ+quNgN57CcxaqrIB+5Ayg4ABQE7iRd8Lm98hc6MsxuDwVku8atdHN36fBkxWKuL88H6Rlr0+CNJc3qzLKv/MShlZxgmpfVFRkDnpbTQsKzfOctg+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714082835; c=relaxed/simple;
	bh=1qDixauO6x0Pyd9QSSsnF1wJukXfiH4Aj2/qUYukcgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pgQVYTrM9U1ApNMlexiAeFYdPZJUMqfrdolAVxUTSiZ+BBKg5EVSlfSmTukMcYxcHBExtcKKGqOuZh3m21dZ6Gu2SnlsGaRQnePEWyYO+RcOpXbVj/0MET++7TsIF/wbmk39aZwrdJ61qXZtS8T9F0FMMAoilUspcckKmhf//9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7P0PYrr; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714082833; x=1745618833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1qDixauO6x0Pyd9QSSsnF1wJukXfiH4Aj2/qUYukcgg=;
  b=i7P0PYrrt8zMEnHgMolHBrGNC/KrDc6f2kQGNdyd4FMiXzGvpo5oJrYj
   3aaOx2RHgtPZC67sL3CDp2Pin9Yb7qBzkjM1OyHhJPxh79h2nzk4U9mPD
   e2w99tnrHxY44yvIi6l+oWBdClWlhl/CJ79dYa7vsEB0m3VVw50ec66+y
   j92KcHxceK6IZoOsJqL44mwP6C+yH/CszZQGPj5LrClugGPmrTBeBfmjx
   glOkX0GBMFcaPfrHm4rY2dVJB9GBZjNSpNo0nwD3Al4ePUECwTOWV7e8w
   QqBRdHWYyib5yNVOsHbInyx+oBIuZwvdancyRceF9h7vBWX0oXtKdXDU9
   w==;
X-CSE-ConnectionGUID: c/dSdYIWRqSLNBEppRiUSQ==
X-CSE-MsgGUID: GElXD7oXRyKGZN5sOmlATQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13585398"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="13585398"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:07:11 -0700
X-CSE-ConnectionGUID: oawdXQ3fTtWsBkoUVQFeSg==
X-CSE-MsgGUID: JobcZGFiTgObl/H5GHSx/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25185083"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:07:12 -0700
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
Subject: [PATCH V5 1/4] KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
Date: Thu, 25 Apr 2024 15:06:59 -0700
Message-Id: <76a659d0898e87ebd73ee7c922f984a87a6ab370.1714081726.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1714081725.git.reinette.chatre@intel.com>
References: <cover.1714081725.git.reinette.chatre@intel.com>
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
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
[reinette: rework changelog]
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v5:
- Add Rick's Reviewed-by tag.

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


