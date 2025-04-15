Return-Path: <kvm+bounces-43340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA4CA89B2E
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 12:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 128D1189CF89
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 10:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A39129A3F2;
	Tue, 15 Apr 2025 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jgRn4nIc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C162918C4;
	Tue, 15 Apr 2025 10:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744714171; cv=none; b=Y4FST2/6cIUcEsmVHaUdb3WFmk5FFSBuvTxBT3kvBu1a5W3Yn4ENLEm9adwiNvO3LZfyXpdG6nb8PCMd2nO2m1m20Pw/0sZHsgMoesGMoFSSdh8ddGH3I1B2vnM6z1MBTPecUzlwQ6+tUZHL8AZnd7jE/oL5JsKVPfYpL9o7Qq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744714171; c=relaxed/simple;
	bh=Q3J1jPJUTQQiEZJQ1xvnq9l36A903ZDy8U5bkIVHr24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2x9/QilQHmeYeRdYEiY27bcSkhunUhkWpOlUIcN8Nt7MxbGQDrBNoEIvb/KhQ7bCLy9c5mt/2yDxv16OeW2AsJz9TT4RvWUoQ1WXEgpWgvL3fDY6BflRWlKq3HLIoydIoUYQHxxQfqQ2N2y81aD2rPpjwBa3wuee8qhBmRutrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jgRn4nIc; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744714170; x=1776250170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q3J1jPJUTQQiEZJQ1xvnq9l36A903ZDy8U5bkIVHr24=;
  b=jgRn4nIcFepKLmGpfpNwnxu/0JTBA56qR1mRfjlEZNGZjTuvBEnwPi+r
   JFC4f6P2n/UmXm3PMokzEup2NJZLTiqEOKS2C8jkoWL9t2naEQik/WX+H
   IkF1cBdk3yhpX3aC3mR98jch6Htuu5ULhZAcG+PehmT3t8fGBAy+Qvqu9
   HeCbBp5RPSf2C2JdsJoAKv1ECKOlDWVe1eH4bq0Tt9Bq68mCRQ0hOguSH
   lfzYXg0wdALafaoshKFTgBkRIZStrpQWmvJuSS8Fr6RHWNsXOdNug5+Vt
   4wc0HrnilU1HHesOmyUiVdnHDQsi8xYI4tqHYidNdoxSMttSovJQcciqG
   A==;
X-CSE-ConnectionGUID: bsJw0eJHSwmHkv23TdB+RA==
X-CSE-MsgGUID: kjIfrwi7SzOaodvS/PbS9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46132905"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46132905"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 03:48:53 -0700
X-CSE-ConnectionGUID: 00BXP8pcTAWJ1BnXXXbAFQ==
X-CSE-MsgGUID: 2fX4EaCISRaVrFIwWEOptQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="167254360"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.254.135])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 03:48:49 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH 2/2] KVM: x86: Do not use kvm_rip_read() unconditionally for KVM_PROFILING
Date: Tue, 15 Apr 2025 13:48:21 +0300
Message-ID: <20250415104821.247234-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250415104821.247234-1-adrian.hunter@intel.com>
References: <20250415104821.247234-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Not all VMs allow access to RIP.  Check guest_state_protected before
calling kvm_rip_read().

This avoids, for example, hitting WARN_ON_ONCE in vt_cache_reg() for
TDX VMs.

Fixes: 81bf912b2c15 ("KVM: TDX: Implement TDX vcpu enter/exit path")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 844e81ee1d96..8758f8cba488 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11130,7 +11130,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING)) {
+	if (unlikely(prof_on == KVM_PROFILING &&
+		     !vcpu->arch.guest_state_protected)) {
 		unsigned long rip = kvm_rip_read(vcpu);
 		profile_hit(KVM_PROFILING, (void *)rip);
 	}
-- 
2.43.0


