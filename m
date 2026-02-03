Return-Path: <kvm+bounces-70054-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJn6LYo9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70054-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:25:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A86C2DD8AB
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CD15E30540CE
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188133ECBCA;
	Tue,  3 Feb 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIuy1MvK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C77B36A00D;
	Tue,  3 Feb 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142670; cv=none; b=bwhMrAZtQmpZXstzZAh4bRo8tawDwAbDXXqYWi2cEBnefEDFNzCIjFKtEZPpJdZ1Jol9t1c53R2oqkMPN0Kv5M02h1kkp79Y9yAHpf1T2fWHc9QhnxITQE5EuE/fDeZG18WGrORE+sBnTF8cF+X/xBo6nTCRV4oFN2DTKRAb6WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142670; c=relaxed/simple;
	bh=CMv7tamvHKs001xtNyhXn3dY0Dc+tq4bZp/NdM6KFdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzugmGvsTBj2DsKvbOjd2EqV0u7aYAaXikGGKAzDJNTGkVSh3K2B/TjL+RW4Y6kGHYnuVooHOJ9gWPRx316ndZRDtDgKfTQJG9YbTpxR1fCJn4DMGmsL9QGqoOumf3rR7p5GiU15TNyphi38mnMU0mYDAdNR9eRlLU3ydMSc9ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIuy1MvK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142669; x=1801678669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CMv7tamvHKs001xtNyhXn3dY0Dc+tq4bZp/NdM6KFdQ=;
  b=bIuy1MvKDgLhvMpX0XKDl4Ww2xKUaIcLAzxHvGRFohk/omFlgx96DH3m
   /lOY6SLFegJm19tWAWvPP3EBc8RPXaifNXoB8Ys1KeqCaoBNscuVusx7o
   c9c+Gn3SyQiF9S4wjKZYH6ntFrXe3Ic433PtOssvsnWzJ/nP4ziBdhNl+
   6huP916VBokmYq1eleuJ4eBxdALxzeoMfIUdAcaruu1DE37qvvOOWpP7O
   DKihLIUQKIezQ61RSWLS7+SYV/j4kjtCMJudw9Go94macp+h3M1EgMovK
   S8VciDjYjhU1mmLtHHjncUNBGiwb+7ndkElPZgZqeqYMwgND8wGV65ONy
   w==;
X-CSE-ConnectionGUID: syeyx4WTQySx/hkQpY8Dgw==
X-CSE-MsgGUID: Lx/SNogMQomu4npPaza80g==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745842"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745842"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:45 -0800
X-CSE-ConnectionGUID: 4gT/6bgkT56cf/dUK+m0gw==
X-CSE-MsgGUID: Zb0qc95XQ3CdKHh5EiMPeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605516"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:44 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 21/32] KVM: VMX: Enable APIC timer virtualization
Date: Tue,  3 Feb 2026 10:17:04 -0800
Message-ID: <0107fa9de9ad238a7b1c8d8207e93f8d2e61615d.1770116051.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70054-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: A86C2DD8AB
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add TERTIARY_EXEC_GUEST_APIC_TIMER bit to
KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL as optional feature as the
supporting logic is implemented.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bdeef2e12640..b296950d855e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -588,9 +588,9 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_EPT_VIOLATION_VE)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
-/* Once apic timer virtualization supported, add TERTIARY_EXEC_GUEST_APIC_TIMER */
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-	(TERTIARY_EXEC_IPI_VIRT)
+	(TERTIARY_EXEC_IPI_VIRT |					\
+	 TERTIARY_EXEC_GUEST_APIC_TIMER)
 
 #define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
-- 
2.45.2


