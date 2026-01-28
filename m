Return-Path: <kvm+bounces-69438-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FsrAi+Zemms8QEAu9opvQ
	(envelope-from <kvm+bounces-69438-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:18:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 96480A9E70
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3277302C647
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6680733123C;
	Wed, 28 Jan 2026 23:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h0tZIqGS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDEB2DEA6E
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642268; cv=none; b=GsCQNsjpBucq5j1uVGpaUdKjn+UfYaC3G1BpBRjhjCoIplsJak/JWhO7LacI+//W3wB7hWrlEjhSwi8j9cRkGoZBk+peJnhz6qcfywlhgu68K+BEhStPN/pRIwr66q3oZ57akQMZDAsd4FYDOn+zoiK5UiG6oc7JxftigciiuCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642268; c=relaxed/simple;
	bh=6+39BohlqHVgxOCjKzqyCTw+ClCJeAPxpVGdX6TNBB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQcog/lMpPdF4m8JZsOrCHlLb2PdYFOqObX/ii8Fg6AhOfHqHg2J+FAcvUj5C5/+xhjqZo128fzYBaHU9ImB5sW2qvl6bw1kre/e4id+2Rk6rKo4YKLMOLDqaaOlcBXfeksvqiIeAR74iW7QDjlEThlnokCk5W7CWhnCtC3FFzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h0tZIqGS; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769642265; x=1801178265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6+39BohlqHVgxOCjKzqyCTw+ClCJeAPxpVGdX6TNBB4=;
  b=h0tZIqGS/CLAtWAGYz7TQHJHlILGpfIEgWk/5KwfQB26m1YmCXm6440a
   +VnmZkoB2f4qM4p23cO46QVq1mnA5QhvQepKsZtW7vAjTKTejUIa0PJRz
   Mn8hD8WIrtdnjiIpHqEjvpEsFKyHNlePbH3VzNN0CIDSg6KrlhB7QFzGU
   UzZZDBmRTf/WemlEHgk2zgl/2fvzHk2Lo+yOyOv3ILOaoXB2qXPctdCc4
   0exBkzZpIstHmInF4XJiCXIYhv5AUdGZPs4b1jVeVgaoJabcU1bcrXdGW
   SO6Y6ec1rElZaVhV3wl9DsaRWuCMjqlzv7lBeusNPhpNgAe7Dj1YtIYdo
   A==;
X-CSE-ConnectionGUID: KZHIomDITkSCPhQtTriARQ==
X-CSE-MsgGUID: 3c26hrtFS72V7K9CXuybLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="73462353"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="73462353"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:43 -0800
X-CSE-ConnectionGUID: sh1uBdSpQ7ak5CJQl2wDHA==
X-CSE-MsgGUID: 0sB7ehxMQbiQhy6+npxnnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208001794"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:42 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V2 11/11] target/i386: Disable guest PEBS capability when not enabled
Date: Wed, 28 Jan 2026 15:09:48 -0800
Message-ID: <20260128231003.268981-12-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128231003.268981-1-zide.chen@intel.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69438-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 96480A9E70
X-Rspamd-Action: no action

When PMU is disabled, guest CPUID must not advertise Debug Store
support.  Clear both CPUID.01H:EDX[21] (DS) and CPUID.01H:ECX[2]
(DS64) in this case.

Set IA32_MISC_ENABLE[12] (PEBS_UNAVAILABLE) when Debug Store is not
exposed to the guest.

Note: Do not infer that PEBS is unsupported from
IA32_PERF_CAPABILITIES[11:8] (PEBS_FMT) being 0.  A value of 0 is a
valid PEBS record format on some CPUs.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2:
- New patch.

 target/i386/cpu.c | 6 ++++++
 target/i386/cpu.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ec6f49916de3..445361ab7a06 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9180,6 +9180,10 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
         env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
     }
 
+    if (!(env->features[FEAT_1_EDX] & CPUID_DTS)) {
+        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
+    }
+
     memset(env->dr, 0, sizeof(env->dr));
     env->dr[6] = DR6_FIXED_1;
     env->dr[7] = DR7_FIXED_1;
@@ -9474,6 +9478,8 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
             env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
         }
 
+        env->features[FEAT_1_ECX] &= ~CPUID_EXT_DTES64;
+        env->features[FEAT_1_EDX] &= ~CPUID_DTS;
         env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
     }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5ab107dfa29f..0fecf561173e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -483,6 +483,7 @@ typedef enum X86Seg {
 /* Indicates good rep/movs microcode on some processors: */
 #define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL  (1ULL << 12)
 #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
 #define MSR_IA32_MISC_ENABLE_DEFAULT    (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
                                          MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
-- 
2.52.0


