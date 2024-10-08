Return-Path: <kvm+bounces-28127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD099945BB
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 12:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839C51C23341
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D0417D341;
	Tue,  8 Oct 2024 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WjXMRPCw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2226A1C2DDC;
	Tue,  8 Oct 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728384332; cv=none; b=LZ6KmeON3dUQyP15NsPDDJt0JxYz3dXLbO3qua7GqAzYlMB5A2CkS6VRXCg0mq4TR9SUuHU85l6flhrLi4oiJ4jLGVFIMc5i1v517ez4/yyVpRHcF12LF0UCYwvkiobU+GBIMPQ0FSMJa4SmMNYSq+WG75UF8Fs+gXASi8ufBjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728384332; c=relaxed/simple;
	bh=BlSdS3ccmmWiiU5sC/zLNueLcx7CKTtj0OJ929lDtac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPf/4b/gf8mMwVlRcpwOzIdT5QaEAQY8WVHkRYcpe1oQJEfi0SYb5ErYIWt6AIQzHnwRRh7hvxuqP65nVRocHxOPkAMlR/nfuzpgiGdTrfm8CBKk6snNGHEx/9VQXbiCRSnj1NBXlkkhxfvFL+nWQxAqn07rW7HLnMqgc3fhSFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WjXMRPCw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728384331; x=1759920331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BlSdS3ccmmWiiU5sC/zLNueLcx7CKTtj0OJ929lDtac=;
  b=WjXMRPCwPwhBaVRx6tl+cWjYFTu/sinPicYpq1nmsZXv8yDGJmu8pE6X
   CQw9Mlf8jO8LeMfPJ87OmnQVO+6f+ENkjmib81UO7225tFqL8A4llKA9D
   C8DgoRcueRcy32PJ5L48E050Nd1Weo3rlKhcCoYafvbljFPcbglGLQmsT
   OjwCtEoglMhKSw7Wmc1WK28sXwUwGW37XXL3KzPywe9M7xq3OA4kv7M4O
   LI46pIyzYr67ITJKAV/6pZrgTwQCT8aYLmqX2hUaujxcbOxXof2zKWKO9
   1foc56ZblfwF1PrLMqcPP6QOdPm9+Z8h2Xq+94JF44RBGoq56i5G9ztqw
   w==;
X-CSE-ConnectionGUID: hVszYtOzQC+AdtpeGhkzcg==
X-CSE-MsgGUID: iJlxImQJRSOfg9fDBygpPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45033836"
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="45033836"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 03:45:29 -0700
X-CSE-ConnectionGUID: JC79l8BkR1a94kzUNvc83g==
X-CSE-MsgGUID: C9LCV7qnRpOkRrRbkkgZ1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="76166915"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.88])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 03:45:28 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 1/2] KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
Date: Tue,  8 Oct 2024 23:45:13 +1300
Message-ID: <666e991edf81e1fccfba9466f3fe65965fcba897.1728383775.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1728383775.git.kai.huang@intel.com>
References: <cover.1728383775.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sentence "... so that KVM can the AVIC doorbell to ..." doesn't have
a verb.  Fix it.

After adding the verb 'use', that line exceeds 80 characters.  Thus wrap
the 'to' to the next line.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..afd70c274692 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10576,8 +10576,8 @@ static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * deleted if any vCPU has xAPIC virtualization and x2APIC enabled, but
 	 * and hardware doesn't support x2APIC virtualization.  E.g. some AMD
 	 * CPUs support AVIC but not x2APIC.  KVM still allows enabling AVIC in
-	 * this case so that KVM can the AVIC doorbell to inject interrupts to
-	 * running vCPUs, but KVM must not create SPTEs for the APIC base as
+	 * this case so that KVM can use the AVIC doorbell to inject interrupts
+	 * to running vCPUs, but KVM must not create SPTEs for the APIC base as
 	 * the vCPU would incorrectly be able to access the vAPIC page via MMIO
 	 * despite being in x2APIC mode.  For simplicity, inhibiting the APIC
 	 * access page is sticky.
-- 
2.46.0


