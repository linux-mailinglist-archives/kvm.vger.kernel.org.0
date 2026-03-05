Return-Path: <kvm+bounces-72967-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMQvI4sbqmnALQEAu9opvQ
	(envelope-from <kvm+bounces-72967-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:10:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C9D1219B5B
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 620783042277
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 00:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F87F242D6C;
	Fri,  6 Mar 2026 00:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RtXBH9lu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EB422068D;
	Fri,  6 Mar 2026 00:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772755837; cv=none; b=iL2sh6flevmiyWhg183K4fyLHVkwsQ7Uay8AQEpK7iSgi31j0SMkLtZjEZRp79KGy2d4VWmt6Jp4UA7cmyiOBz7GgV8nGwVQ4VtMeY7eGsRQ7gBtaFyEpQv7rfrgFXCXWthB3REexomD1d+h6RaoqJ7TsmtvmMTu3D8QVfRLmwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772755837; c=relaxed/simple;
	bh=lLocTOXlbgafdjFvplBTTLVVWz+FDe49720sngxtzSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JzLfHVzbphUQ82L7zzwgolVnKkUxUEw1q0BGaocngptrKcdbqUg7Nkr1qK1GRbtMZlYEFe/jsmau1+faoisgGrhGJRNJ5b6piB7mZcgciRQFl+dhSWJU05lkbUpxdEKBvAj3VMj61dJ9Gjux6TEgIEZbIkltdc1ulmNwZq+xea0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RtXBH9lu; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 625NsGjG4147232
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 5 Mar 2026 15:54:20 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 625NsGjG4147232
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772754860;
	bh=ameKleR5OB5H0bF/o5GGL7Wy/BENbPUOMSGbTW1I0YY=;
	h=From:To:Cc:Subject:Date:From;
	b=RtXBH9lubzHSI/sQuNr/mHQbHoWpjZ1V/dOWS0v2DijqNfr36EaEt+Hn7IjJdJVsh
	 CN1R3A/nxJ6gtBWCKQiM9IPHfplnq1mjj8Bez/b0a5k2AWoU9Gi27Bbwl0l5SX3bnj
	 T57nmEsBDxz+fP9DO03WaxCIaOUyDbOvXALP/5HI/+VTxxTmJPGphqDbpS3b2MvXyk
	 sLTDjaXelt7jdfRoFOzNXYHHbN9rRFFCLfME2wfwg7/SboIgnKn6Lmnz8hEz1W1+hu
	 pa9t0kMM35mg08abjhXq1ZjuW6UcWVj6GPsgQV65Es8kbHJeTe6NHZ7aK8yFjeD7QF
	 WGHapGap6spRg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com
Subject: [PATCH v1] KVM: VMX: Remove unnecessary parentheses
Date: Thu,  5 Mar 2026 15:54:16 -0800
Message-ID: <20260305235416.4147213-1-xin@zytor.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C9D1219B5B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72967-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zytor.com:dkim,zytor.com:email,zytor.com:mid]
X-Rspamd-Action: no action

From: Xin Li <xin@zytor.com>

Drop redundant parentheses; & takes precedence over &&.

Signed-off-by: Xin Li <xin@zytor.com>
---
 arch/x86/kvm/vmx/capabilities.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4e371c93ae16..0dad9e7c4ff4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -107,7 +107,7 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 
 static inline bool cpu_has_load_cet_ctrl(void)
 {
-	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE;
 }
 
 static inline bool cpu_has_save_perf_global_ctrl(void)
@@ -162,7 +162,7 @@ static inline bool cpu_has_vmx_ept(void)
 static inline bool vmx_umip_emulated(void)
 {
 	return !boot_cpu_has(X86_FEATURE_UMIP) &&
-	       (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC);
+	       vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC;
 }
 
 static inline bool cpu_has_vmx_rdtscp(void)
@@ -376,9 +376,9 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
 static inline bool cpu_has_vmx_intel_pt(void)
 {
-	return (vmcs_config.misc & VMX_MISC_INTEL_PT) &&
-		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
-		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
+	return vmcs_config.misc & VMX_MISC_INTEL_PT &&
+	       vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA &&
+	       vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL;
 }
 
 /*

base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 
2.53.0


