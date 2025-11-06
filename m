Return-Path: <kvm+bounces-62147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA57C392D7
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 06:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 387F73B676E
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 05:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7B02D8796;
	Thu,  6 Nov 2025 05:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="TT2BMl2B"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob01-os7.noc.sony.co.jp (jpms-ob01-os7.noc.sony.co.jp [211.125.139.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166B11DA0E1;
	Thu,  6 Nov 2025 05:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.139.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762407479; cv=none; b=A1YvX+qg0Tz21FNzvAe0iqWi41tms6NhxioDbh1oW8GvqSDHTOYjV/kwq1E1i93bDlqWuHBjxEthFMsxV5gGlQXtNtVB61886Co3h+9Y/LA4UJS5X5562BSb47VgvCotPQ+e/vfg3gzitE5ZwKTs9sQGxXQowdOHIIEPckN4dK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762407479; c=relaxed/simple;
	bh=KtDaBvRA2fJKq5FwBl9OQltCRZcFTcs+e3TL7oJVie8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jmjv2OFrUXgFh2ur7K8UQRHEm9VUpboM9BIKnkmVsSz9MYWhWauczbrh4yzUw1uSiCOdeihPNWQLL1BxI2zX/XsCKRe5APgxyJjbfYBiDHgK/g1W3Gq5vePCcywtx+V/3DphfO9Z6I3t47WIRMKUR+mw0frLCVM0FiUhWh5adAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=fail smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=TT2BMl2B; arc=none smtp.client-ip=211.125.139.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1762407477; x=1793943477;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sOIza1LHMgbtMb4oCMCdsnyxio0kWKIyeN8q8tWiwc0=;
  b=TT2BMl2BqydKfhRssFpVoymgw5rvDuoT5PMFJP8MQBsotYARZaj1k/ko
   ZWyaH6mDlZd7OgJPD6FHIz9VgIlQ3hCCPR/XmwX8iedfvMQB+VG6A2XBY
   hesZUQCRooeVrbHKBBNTyNMZJ2B/o422fjlg16kfW3VWZ4Nq83AqSSJwL
   2RD1ojfUWNYNFgyjddlNe+hPkjfIv+xtWwKgIlUhULefJbad2VYE5fe0C
   SbkIWJk5fJHm2EJuCy+nAL3koQlgv6dE8abHsFf/GYPeSVTkpuJuKnDA8
   QGGjQXnXhGHpR75UWh0peB3QOqoCYXSkMGh4dG4Ya5qRzTeVa1K5IohLe
   w==;
Received: from unknown (HELO jpmta-ob02-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::7])
  by jpms-ob01-os7.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 14:27:37 +0900
X-IronPort-AV: E=Sophos;i="6.19,227,1754924400"; 
   d="scan'208";a="45532677"
Received: from unknown (HELO Sukrit-OptiPlex-7080..) ([IPv6:2001:cf8:1:573:0:dddd:f9c9:5652])
  by jpmta-ob02-os7.noc.sony.co.jp with ESMTP; 06 Nov 2025 14:27:37 +0900
From: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Yuan Yao <yuan.yao@intel.com>
Cc: Sukrit.Bhatnagar@sony.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Fix check for valid GVA on an EPT violation
Date: Thu,  6 Nov 2025 14:28:51 +0900
Message-ID: <20251106052853.3071088-1-Sukrit.Bhatnagar@sony.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On an EPT violation, bit 7 of the exit qualification is set if the
guest linear-address is valid. The derived page fault error code
should not be checked for this bit.

Fixes: f3009482512e ("KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid")
Signed-off-by: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>
---
 arch/x86/kvm/vmx/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index bc5ece76533a..412d0829d7a2 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -98,7 +98,7 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
 		      ? PFERR_PRESENT_MASK : 0;
 
-	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
+	if (exit_qualification & EPT_VIOLATION_GVA_IS_VALID)
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
-- 
2.43.0


