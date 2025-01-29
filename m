Return-Path: <kvm+bounces-36836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18605A21AA5
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 205053A2BB0
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2777F1B3937;
	Wed, 29 Jan 2025 10:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZvEvJOwa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8956D1B425C;
	Wed, 29 Jan 2025 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144829; cv=none; b=oh/Zs56KzJpKdZBxBPwH+ApHwmJ7BbRQzQUYwhi2vC/1ciB1uKoAbcNvBsf1G7glj0VjyVnOSdR8Zzl5AKHQlrum2lJG8Wk9dJTo00yj0GeWgcfrUHsxz8Bu9iNzp4TK3eaEZMwJzApSGth/zm2u3UuZBoyrYf3rdM4PWJxOHfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144829; c=relaxed/simple;
	bh=dO6/lJT7ZqiH9aGBeVqPFqVQ1A/1FHOiK7GExhREHxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQsqMpQFpBNS6Bq4vek+sU+bbMsF6N+x1lPzFjX0YWmzDd/6loI5iOZG7SoIon1mYgvMcHCSPzNDy4zQqB6GdW8HgZRVBj5J11SGnMGj8/HbZO1UpBhbImKF0P2c1/xoxvSlRmNIze0niJMfBd3tVqHrSyzVOn78eBVpAB7NZXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZvEvJOwa; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144828; x=1769680828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dO6/lJT7ZqiH9aGBeVqPFqVQ1A/1FHOiK7GExhREHxQ=;
  b=ZvEvJOwaPe24JACyCOmnN1hvAMaEM78llKToGsqFituW1uJN/jj65x/A
   Uye0Bm7WJa+w1LviwZZE3ZHwrX/WyxPKKuGvTaNYapFcSnzPWFFWf4sUg
   KU/0J2JZJJQz8JV1fDWYh0u1ruSUchWU4njYI/Z2rhvXeM9Bmeapf8uwm
   S/fRog/XFeZH4UJ2xtsMja09wY79HRnpcRU3Vl3hDEnHSON6I0524VleC
   +zGrqcFXpI9SMamMBTsLb8sHHDB+L0EFsnjS+WD6HETbwT12ONhqRy/ZB
   IqHbYIZZuBx/MSFf1FGlG/046TOiZb/w4Sw3a0s/7TAsM2lvbAsqYJrpN
   w==;
X-CSE-ConnectionGUID: A+z889jzS6GZ6NIb9azlsQ==
X-CSE-MsgGUID: IKUgD4m1R0yO+z3aiM/Axw==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036069"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036069"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:08 -0800
X-CSE-ConnectionGUID: dUZpHX8RTIOwHjHaMrEfGw==
X-CSE-MsgGUID: ytyZ5RqBQAqYXPbDYFpVWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262794"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:03 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 10/12] KVM: TDX: Disable support for TSX and WAITPKG
Date: Wed, 29 Jan 2025 11:58:59 +0200
Message-ID: <20250129095902.16391-11-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Support for restoring IA32_TSX_CTRL MSR and IA32_UMWAIT_CONTROL MSR is not
yet implemented, so disable support for TSX and WAITPKG for now.  Clear the
associated CPUID bits returned by KVM_TDX_CAPABILITIES, and return an error
if those bits are set in KVM_TDX_INIT_VM.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a0f5cdfd290b..70996af4be64 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -117,6 +117,44 @@ static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
 	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
 }
 
+#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
+
+static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 7 && entry->index == 0 &&
+	       (entry->ebx & TDX_FEATURE_TSX);
+}
+
+static void clear_tsx(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ebx &= ~TDX_FEATURE_TSX;
+}
+
+static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 7 && entry->index == 0 &&
+	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
+}
+
+static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
+}
+
+static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
+{
+	if (has_tsx(entry))
+		clear_tsx(entry);
+
+	if (has_waitpkg(entry))
+		clear_waitpkg(entry);
+}
+
+static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
+{
+	return has_tsx(entry) || has_waitpkg(entry);
+}
+
 #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
 
 static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
@@ -140,6 +178,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
 	 */
 	if (entry->function == 0x80000008)
 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
+
+	tdx_clear_unsupported_cpuid(entry);
 }
 
 static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
@@ -1214,6 +1254,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 		if (!entry)
 			continue;
 
+		if (tdx_unsupported_cpuid(entry))
+			return -EINVAL;
+
 		copy_cnt++;
 
 		value = &td_params->cpuid_values[i];
-- 
2.43.0


