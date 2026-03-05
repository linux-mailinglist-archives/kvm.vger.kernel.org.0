Return-Path: <kvm+bounces-72907-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKcrDtfCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72907-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:52:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FB0216907
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88665313BAFB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B52F423172;
	Thu,  5 Mar 2026 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VdDshT8c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38E23FFAC7;
	Thu,  5 Mar 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732684; cv=none; b=seMs+94K1lJvKmH7k0lXq7Z146KWD+OTem7NultykBtsSgiXW2IoNTD3kOiIJ3zwVmTMzMtj6JZ3bQPOoEKxOzj/4v4Z3unJQoNiWzY9Xij6NSeIePeJCSLjKCnVkLs/mjcfqE7QetVeTuxQtlLu1v1wS8vb1xOvYHSUBNMLGFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732684; c=relaxed/simple;
	bh=HDc12PQVv3ZBF2lEZk6jS6/6hE2E9STlZ/ISpWqGmls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhVrMBEL+HDi09rLa7JvXaukabApbNk3lPwOP+orJWaY7acpM9rxAEgFnH4hZFRzIsTwXGt04MjX/NIc4BkOWxdr4K3V2XITGxDcXa8CQf/nq6ugCu7fzxNCBwihq2PDPX46mXLH6DBReeqOy0K7BZnjuOYWhWMaXYmSJrShMVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VdDshT8c; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732683; x=1804268683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HDc12PQVv3ZBF2lEZk6jS6/6hE2E9STlZ/ISpWqGmls=;
  b=VdDshT8cSY5X7/YmRvbMV21xhEPMtczViAcPzd5vJ+4S/7U8w/MRcJqo
   5SRfWQlX6BEjef50BYZIi/7Y9vUUM+AKuagzJZBU28tUfSddHEjyKNf50
   wB/4ceiXp9r0WhWQcGCGqU9Efm//95zboaLhU+k1ieEf8wSMUVCeWR4Q3
   inYSzkc3HmCJjhIul1SXKrMpaXwE9uS6ZNTCtKKn69tzgyo9oBMP4fGMO
   HXSb/lInc35ryt/22swE2XiP3bQD7FWOPCnjjJJz1NvebzqNm2mcvlrUB
   F5q6EDR6W1tfwhctcuSO8fAA1aykia4Kj5fa8WT5oBK2dDUmqq97oh8jA
   Q==;
X-CSE-ConnectionGUID: 79kN3D2QRXmjJg3igynDfw==
X-CSE-MsgGUID: m7aU8yvWSTG4D2Jdd+l2Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701121"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701121"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:42 -0800
X-CSE-ConnectionGUID: D1BecQheSPyJrhw2SugkEg==
X-CSE-MsgGUID: JXlxc26jQNyVBIzmHQIaeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256647609"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:42 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/36] KVM: VMX: Advertise tertiary controls to the user space
Date: Thu,  5 Mar 2026 09:44:00 -0800
Message-ID: <fa5b031a0a94d26962efcafb6501a7603ed38635.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89FB0216907
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72907-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make KVM_GET_MSR_INDEX_LIST, KVM_GET_MSR_FEATURE_INDEX_LIST, KVM_GET_MSRS
to advertise MSR_IA32_VMX_PROCBASED_CTLS3 to the user space VMM like QEMU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 arch/x86/kvm/x86.c     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bac3f33f7d73..8c2ab0164714 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7214,6 +7214,9 @@ bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 		 */
 		return enable_unrestricted_guest || emulate_invalid_guest_state;
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
+		if (index == MSR_IA32_VMX_PROCBASED_CTLS3 &&
+		    !__nested_cpu_supports_tertiary_ctls(&vmcs_config.nested))
+			return false;
 		return nested;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 	case MSR_AMD64_TSC_RATIO:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1922e8699101..8a1ec0a39624 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -457,6 +457,7 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_VMX_PROCBASED_CTLS2,
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
+	MSR_IA32_VMX_PROCBASED_CTLS3,
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
-- 
2.45.2


