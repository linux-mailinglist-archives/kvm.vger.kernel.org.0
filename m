Return-Path: <kvm+bounces-16759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6D88BD4B1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 20:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4245B233F3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4E9158DD4;
	Mon,  6 May 2024 18:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eb6HrA0+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B013E8BA;
	Mon,  6 May 2024 18:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715020586; cv=none; b=qFO32/aZMUZqMDs4edVxmS2GSWEdqThQ1N09idqoeQb4FDnxSJjG2TR+sfWNaGVkU97cVGzAY2LPl5tKTGXeWNIfMh3f3i8naBjFkaTZjCd1GJszwwn7J72YMYVW68oJd1dMHWis6LfcQB5g8QqRqVWoKBUboZRZFR24jrklQUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715020586; c=relaxed/simple;
	bh=JCMdLmx7hIlCtOWjHewphvGoWCSoaO1qN1Iyo0V0rtg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P/VM63ooTNJDRfxb1QtVGalRRE364RlInmva6CWASj0b2REvMEi3mlAo5zRcijC0GeZ75CKk/ZOBtOGJAslF+n/yzBf29IdbF7s+yQtBh0K2Y4wfmCcK8+3DyBX1T1/aGJmqlo/O/AK9jKxOYimzUZJFTKqx/EosK4wDrjhPKGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eb6HrA0+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715020585; x=1746556585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JCMdLmx7hIlCtOWjHewphvGoWCSoaO1qN1Iyo0V0rtg=;
  b=Eb6HrA0+IVyp2sJhunKku6pJQbRR8xrl6Zgg7zCxqAwO5heq2Acf35QT
   wHnNLZ3LCkXhoIVTSlKu7agTZW95+2DvlaloTIAiCwJ1XeMya/FrS0CGc
   FlYUEu6Rrt48ogIfaq3CUkO/TmyodNYDyAxeJyjYelKjmJ5SdMa+EyMxv
   ymPfugqjKoqzAIQP9bvOEWP6ksEpdi7MQ3Z9PDbnxsID3pa/21J5SdbRg
   JQVBXhAaANKSnlxdALmVsaq4Fgll4CBlkOiO3IKP9Awih/tXxCyG/1DkC
   BegSd5YHSZZbjiE1MShVUyaSDTz5yAygonYBDPGd55v1hVdVj3jdPOb+E
   w==;
X-CSE-ConnectionGUID: N5Fd4vAISRSm7VWeB3aOkA==
X-CSE-MsgGUID: aKYfLx+TTbuy/Lgx8zaQ9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21455743"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="21455743"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:36:10 -0700
X-CSE-ConnectionGUID: Dl22qp/lSiOB0TYBDYy6EA==
X-CSE-MsgGUID: bStAaS47SbybSrCM0oz2qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="28237805"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:36:09 -0700
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
	rick.p.edgecombe@intel.com,
	yuan.yao@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V6 1/4] KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
Date: Mon,  6 May 2024 11:35:55 -0700
Message-Id: <dfa9b38cede805edaefcfa862d7fe7e05eb7342c.1715017765.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1715017765.git.reinette.chatre@intel.com>
References: <cover.1715017765.git.reinette.chatre@intel.com>
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
---
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


