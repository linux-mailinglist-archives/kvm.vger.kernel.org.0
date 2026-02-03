Return-Path: <kvm+bounces-70052-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yON/Ggc+gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70052-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:27:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D74D8DD903
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05F2330709AC
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461EF3E9F6D;
	Tue,  3 Feb 2026 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQl/B27c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEDA3DA7FB;
	Tue,  3 Feb 2026 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142669; cv=none; b=K+rsFZmOZip6fq+sB3TSEslYfbn7TXMq0ejRl2JQoi5UJitG7hmBuUPVtkPX1M+XOnY8BH2h7SIHUOrWIPZXyE7NB3bGqgzoIxQYUlJ3ciuyXImCYIcusp/psJnZi0NTuCAnlJZmQoxLAE7BNCRzo6Nz9+uzzKm4IIYFevg/ksE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142669; c=relaxed/simple;
	bh=VjG2YAysFSwDRuY/3SPr+aLhDFhOkSIB0MlGU+9VGuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYcB+MoNs+z5qw2ZDkW6JBzmQiO/iLK5jj6WR5ceOOV9n4FXUWcZfgihQzVwpieuepkhADngWMdQNa5Zp861cp+AhpUpvBoZkAhtnaKv1zc98EPSNpqB4FhB7LE6WnWv4wgUsgnDNMj7o5RWUQPnNkq/SrdFOdDbFLdVILnz0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQl/B27c; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142668; x=1801678668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VjG2YAysFSwDRuY/3SPr+aLhDFhOkSIB0MlGU+9VGuk=;
  b=EQl/B27cNx57edW79EPEEjTGwRqqJWS0XHRaWOeR9YeuWVqzefKZcpCy
   EwjAHKkx9fbXzUcL2pnE0bLbv3h8YIRGIAynwVviS06E/Fh3vemYqNOVE
   IXEggR8TGPbZyuMynrdTha5lO2KHG9ir3iCLU+t7DNxsklRqGBzhZZSB4
   wTIKhFW7/Ug00+TSW6VVXX833ztOsqV+xIcv7YdD4o0+oH7K+JougyNZh
   wxGiTa/zckADmhtwh/CXmPOi5YreJKv/FzcXOd+NNdewRgUdn0Ejoq8sW
   s0oy4zft5aKfypNG9TOnf+uk3MmpIa1KXznvFWtJmEIa4YNbRghiR2Oel
   g==;
X-CSE-ConnectionGUID: 2DyFIYnqTAKOvVUl3JFsoA==
X-CSE-MsgGUID: ZiZZb6CIQ7iZFQCdfJBsDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745833"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745833"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:44 -0800
X-CSE-ConnectionGUID: 5NCJ0TZTS2uP92aNJwa1OQ==
X-CSE-MsgGUID: ioY4IeAvR42f3y2+Vc8hrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605510"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:44 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 19/32] KVM: VMX: Advertise tertiary controls to the user space
Date: Tue,  3 Feb 2026 10:17:02 -0800
Message-ID: <2e7175eeceb0c38bad5322e20db4acc6ab38cc83.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70052-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D74D8DD903
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
index 41c94f5194f6..50d4390d41f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7146,6 +7146,9 @@ bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
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
index 2a72709aeb03..beeee88e3878 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -446,6 +446,7 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_VMX_PROCBASED_CTLS2,
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
+	MSR_IA32_VMX_PROCBASED_CTLS3,
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
-- 
2.45.2


