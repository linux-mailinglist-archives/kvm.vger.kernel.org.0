Return-Path: <kvm+bounces-70050-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LoeKoY9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70050-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:25:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1C1DD8A4
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E85FF30760F9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72DB3E8C7D;
	Tue,  3 Feb 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VrsuOCqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69F136CDF7;
	Tue,  3 Feb 2026 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142667; cv=none; b=VJGxvwp1hUn+RYN4+GNtFCaEdrEaToH5xW/b6czX5atcG2MXvXFcFNi/joREET4U6kJS0mcJn7g5V+u/x6JOlMUjyKmxi3lzgNlD8wMpzzLEpRGLvpodyA2ybY8FfidjKysbqEHMzxYPJfXfCHjCcegiOcvS/m201EQ9HO7AXbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142667; c=relaxed/simple;
	bh=voz3+s1ChUumlWHWsfQ5GQcF6eeXX1XtQLaRACWTxXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCp5+vooDdRnGfpPpfgnkhtzCsnjMxS52ys5+F4z4dzJGoeXDg2qG7J3DDy0uvV1km07kei8rUiPbF/xKaCeB4O+GU7qS2DQd9CeGSh8yjlFUMvzSjqt+qs41UdJOIf2yA3LUeYn/a6zReIHMm7ItTFho0WiJzmYGYfPWuRPyCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VrsuOCqt; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142666; x=1801678666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=voz3+s1ChUumlWHWsfQ5GQcF6eeXX1XtQLaRACWTxXg=;
  b=VrsuOCqtZEoc0mIgsuZ8QrMSc8Hlxt4XCveOY7Xba/jA6HhAwTPBbNff
   AmWbw7MeXxNCX3G7Rxi5zvcXRbnotWt9w/s44L6mlJaLk6NwQZybiY4SN
   fZLfCnd/U/vkzpigsVyPfFIY4WjqIwutvNYxJgau2rGealm4H+4f5EFXE
   LgkklYNiFjHPsrdjjmrLi9+BhXsnZuqIx1N8AbyPC1Tg4OhQapxZ+G5VI
   S9TF/4bq0SGs53tH7K2ac20cqpMyBpQ03mVezNzjF/s6igdgrkV2EDuyJ
   ZcGnzcFVeGxSq/0ByQf/zQQjonYO3le2XJnMSyDvKS9UQrLOuiXhiEZvU
   w==;
X-CSE-ConnectionGUID: iVqjwV3zR1WzCjSPAJlJ5A==
X-CSE-MsgGUID: ZX6AP1/lSGKgR9RoHpHjeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745818"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745818"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:43 -0800
X-CSE-ConnectionGUID: RoSHYyc2RLyxazbLlGPhIQ==
X-CSE-MsgGUID: 9/K4KgYyQQKQIPcO2LwDiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605495"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:42 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 16/32] KVM: nVMX: Add VM entry checks related to APIC timer virtualization
Date: Tue,  3 Feb 2026 10:16:59 -0800
Message-ID: <7d0817ab09b55e055c344418008083d7049ab39b.1770116051.git.isaku.yamahata@intel.com>
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
	TAGGED_FROM(0.00)[bounces-70050-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 5F1C1DD8A4
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add checks of VMX controls for APIC timer virtualization on VM entries.

The spec adds some checks on VMX controls related to the APIC timer
virtualization on VM entry.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 66adc1821671..c8b42c880300 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3064,6 +3064,12 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 	    CC(!vmcs12->tsc_multiplier))
 		return -EINVAL;
 
+	if (nested_cpu_has_guest_apic_timer(vmcs12) &&
+	    (CC(!nested_cpu_has_vid(vmcs12)) ||
+	     CC(nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING)) ||
+	     CC(vmcs12->virtual_timer_vector > 255)))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.45.2


