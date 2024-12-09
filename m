Return-Path: <kvm+bounces-33275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 314519E88F2
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:13:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24FAC1887401
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A9512DD88;
	Mon,  9 Dec 2024 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KVT71w7M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B5B198A06;
	Mon,  9 Dec 2024 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706392; cv=none; b=UzST+GxfkW08i628+Gw++nQCikS0t4yncNC8QSmYaLu5j6viJyuDykkMEgg9HmgAcCk6kEL3GbOUjhG57EOcVhhe7Zujym28/SkrPaIJj5p3wwuhwdHe8lxYbhHQxXUxWAWIlMAV+MZn+WP9sH7QIhBUvxbW7pSyA5u+qVT4V6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706392; c=relaxed/simple;
	bh=4v5ktAJ4eUM8f/xgeO4bFswBrCl93dXKIkHWLrFrJ4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEBljhmmsT/IhG0z0ZyaX9Z1w09hFO86lOhtNifl93faqGkfYyUqMXXxEQ4YYerqw6lGxsHIU+SujJ6nalBquuJYrSVUk/SZmXgeqeAovqZrF0dksS1iy7uEoZ+Gr4Ri9vcKAbbQOWSwGV0rgkyhiGN7jRe4XPv1+Q11S+QO+zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KVT71w7M; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706392; x=1765242392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4v5ktAJ4eUM8f/xgeO4bFswBrCl93dXKIkHWLrFrJ4I=;
  b=KVT71w7MHfMCQQOar52nqbQNXh6kzQphxHBZF0FltRMttIMqJPuCGDFw
   xRv/nUSiD9DWy/H4fZRY3rcSqOSotHwUx8W0D11NdCgr96ziDeZQ7hPli
   ZirZLJ+P2ao0zUxFOEIZPQnKFa3O+mVFZCDzurw/f+ge5OpPWZtwYMb36
   Pfn+/ge1ksp60HM+Eb5AwEL5FtsxAq54aE2YEtdN34RVfHrvKRPBc+xlb
   9sDLzFvx9gtH0v7rLyczRWtdsR620mXWZwQBx9cEcsfvJh3xIM5Tv4zjs
   DZX2JF6wlRyBEpvhVCUCpgyeNpI8bIpfQ8TjK0VLmXs6OrGLPtxIgnyJE
   A==;
X-CSE-ConnectionGUID: SIu7ohWnTA+GWgF2ahPg9w==
X-CSE-MsgGUID: 3PKakckzTJKNfzGuQmidHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833763"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833763"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:31 -0800
X-CSE-ConnectionGUID: 6tIQv7acS3WLyLYdKpdtzQ==
X-CSE-MsgGUID: tfKVLisrSsCgHWVWy42Sfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402580"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:27 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 16/16] KVM: TDX: Handle EXIT_REASON_OTHER_SMI
Date: Mon,  9 Dec 2024 09:07:30 +0800
Message-ID: <20241209010734.3543481-17-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle VM exit caused by "other SMI" for TDX, by returning back to
userspace for Machine Check System Management Interrupt (MSMI) case or
ignoring it and resume vCPU for non-MSMI case.

For VMX, SMM transition can happen in both VMX non-root mode and VMX
root mode.  Unlike VMX, in SEAM root mode (TDX module), all interrupts
are blocked. If an SMI occurs in SEAM non-root mode (TD guest), the SMI
causes VM exit to TDX module, then SEAMRET to KVM. Once it exits to KVM,
SMI is delivered and handled by kernel handler right away.

An SMI can be "I/O SMI" or "other SMI".  For TDX, there will be no I/O SMI
because I/O instructions inside TDX guest trigger #VE and TDX guest needs to
use TDVMCALL to request VMM to do I/O emulation.

For "other SMI", there are two cases:
- MSMI case.  When BIOS eMCA MCE-SMI morphing is enabled, the #MC occurs in
  TDX guest will be delivered as an MSMI.  It causes an EXIT_REASON_OTHER_SMI
  VM exit with MSMI (bit 0) set in the exit qualification.  On VM exit, TDX
  module checks whether the "other SMI" is caused by an MSMI or not.  If so,
  TDX module marks TD as fatal, preventing further TD entries, and then
  completes the TD exit flow to KVM with the TDH.VP.ENTER outputs indicating
  TDX_NON_RECOVERABLE_TD.  After TD exit, the MSMI is delivered and eventually
  handled by the kernel machine check handler (7911f145de5f x86/mce: Implement
  recovery for errors in TDX/SEAM non-root mode), i.e., the memory page is
  marked as poisoned and it won't be freed to the free list when the TDX
  guest is terminated.  Since the TDX guest is dead, follow other
  non-recoverable cases, exit to userspace.
- For non-MSMI case, KVM doesn't need to do anything, just continue TDX vCPU
  execution.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts breakout:
- Squashed "KVM: TDX: Handle EXIT_REASON_OTHER_SMI" and
  "KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI". (Chao)
- Rewrite the changelog.
- Remove the explicit call of kvm_machine_check() because the MSMI can
  be handled by host #MC handler.
- Update comments according to the code change.
---
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 6a9f268a2d2c..f0f4a4cf84a7 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -34,6 +34,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 #define EXIT_REASON_SIPI_SIGNAL         4
+#define EXIT_REASON_OTHER_SMI           6
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fb7f825ed1ed..3cf8a4e1fc29 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1813,6 +1813,27 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_handle_external_interrupt(vcpu);
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
+	case EXIT_REASON_OTHER_SMI:
+		/*
+		 * Unlike VMX, SMI in SEAM non-root mode (i.e. when
+		 * TD guest vCPU is running) will cause VM exit to TDX module,
+		 * then SEAMRET to KVM.  Once it exits to KVM, SMI is delivered
+		 * and handled by kernel handler right away.
+		 *
+		 * The Other SMI exit can also be caused by the SEAM non-root
+		 * machine check delivered via Machine Check System Management
+		 * Interrupt (MSMI), but it has already been handled by the
+		 * kernel machine check handler, i.e., the memory page has been
+		 * marked as poisoned and it won't be freed to the free list
+		 * when the TDX guest is terminated (the TDX module marks the
+		 * guest as dead and prevent it from further running when
+		 * machine check happens in SEAM non-root).
+		 *
+		 * - A MSMI will not reach here, it's handled as non_recoverable
+		 *   case above.
+		 * - If it's not an MSMI, no need to do anything here.
+		 */
+		return 1;
 	default:
 		break;
 	}
-- 
2.46.0


