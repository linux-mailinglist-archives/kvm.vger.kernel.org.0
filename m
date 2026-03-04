Return-Path: <kvm+bounces-72730-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKpfMCh6qGl0uwAAu9opvQ
	(envelope-from <kvm+bounces-72730-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:30:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C61572065B1
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AB2B83053F2F
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09103DA5AB;
	Wed,  4 Mar 2026 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="neZlrg7N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030603D34BF
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648128; cv=none; b=brPYslgTPGbxUjupUE3IZMaGyKsINay7BmJEV8Gs9dCYZcqyM22IfW226vGTeSAm5S5aW6RoR3PMAKtMI4WtQNvTZFbILOH/wB0MYsWys4lCGLFXZlr3R9uEpnHMKnoQpb6/FOqoZPylKcQokVJO7m7gcOqaeW9ckInYOQozttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648128; c=relaxed/simple;
	bh=QEP92vBSwHQx5y1RIYH9jHcfZSZY2SQok02SXDN/lGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWAIbFc/RcvGFDa88QUAF0Z0hqQbyDC/wo5kr07ZSWCLWuy6o0BvlZsJPRAHH8VPZXtiV7BKP5gqdvkGoaqJhUKLrqwMj8iHyHacUvvCkCqpuBXgQ2B0IcMto2/aNGdniwmB2VaZj2Wl9N+iHshQMzHU1nta37hMMzALTLkj/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=neZlrg7N; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648127; x=1804184127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QEP92vBSwHQx5y1RIYH9jHcfZSZY2SQok02SXDN/lGk=;
  b=neZlrg7NNAXOT7M9z7vcP6uK0+d675I+gZ9tYB2+SxbjjXLPjAdUlPR2
   II1vZ4dyXFu4T7RvgE9+iitSJJciPKklUbYMeHeY0W6RRSzA+vs9vQqN6
   PMepvch+6yMXI3/aojA9R0nE2qlq6+Uv+WTJHTxufFGKpltxPTzulb2VR
   wuEyP5JQ5HubptzBJVZb94VSA60b+fD5Zu4C7OV4WDg6o21HBGj0fQZ9W
   I4pfTqrGs0KzcI7b1SuT7q8Uaso3PQqNtNFjO5WA8US2E4Rx/siK5lui1
   Z91W+j8dlHNFZY616LgbUnVeEfqE+dkPajehW0sg9re9onaur8timwntR
   g==;
X-CSE-ConnectionGUID: dQKCB4oXTjiG8Jvw88yucA==
X-CSE-MsgGUID: VR3/K0mZTI+uLkNIHQjmxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909398"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909398"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:25 -0800
X-CSE-ConnectionGUID: QOqgkkB0QIqoSq/qQOtWlQ==
X-CSE-MsgGUID: TfQNgZRaRgydxgPG46P9AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542857"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:24 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V3 12/13] target/i386: Clean up Intel Debug Store feature dependencies
Date: Wed,  4 Mar 2026 10:07:11 -0800
Message-ID: <20260304180713.360471-13-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304180713.360471-1-zide.chen@intel.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C61572065B1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72730-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

- 64-bit DS Area (CPUID.01H:ECX[2]) depends on DS (CPUID.01H:EDX[21]).
- When PMU is disabled, Debug Store must not be exposed to the guest,
  which implicitly disables legacy DS-based PEBS.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V3:
- Update title to be more accurate.
- Make DTES64 depend on DS.
- Mark MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL in previous patch.
- Clean up the commit message.

V2: New patch.
---
 target/i386/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2e1dea65d708..3ff9f76cf7da 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1899,6 +1899,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_1_ECX,             CPUID_EXT_PDCM },
         .to = { FEAT_PERF_CAPABILITIES,       ~0ull },
     },
+    {
+        .from = { FEAT_1_EDX,               CPUID_DTS},
+        .to = { FEAT_1_ECX,                 CPUID_EXT_DTES64},
+    },
     {
         .from = { FEAT_1_ECX,               CPUID_EXT_VMX },
         .to = { FEAT_VMX_PROCBASED_CTLS,    ~0ull },
@@ -9471,6 +9475,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
             env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
         }
 
+        env->features[FEAT_1_EDX] &= ~CPUID_DTS;
         env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
     }
 
-- 
2.53.0


