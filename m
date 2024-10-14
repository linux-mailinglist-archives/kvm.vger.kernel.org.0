Return-Path: <kvm+bounces-28710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C375999BF48
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 07:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A14D280DB1
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 05:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3709B13AD2B;
	Mon, 14 Oct 2024 05:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EjuIS0Q2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2510F1804E;
	Mon, 14 Oct 2024 05:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728882109; cv=none; b=kwGyOQy0TekceHLUFFJZ4puVkiBtvA0QpYU71l7h/47pqxvr0p6DFFZ+yM1NOJFg13OXbmuCmQF2H+IyaMKaOpTPbnDf2xOLdfPMK00WfDCTC/oG/9VmCO56KlL6nDNJ6s4ky4BmR9Jds7pnrlIUF7i1FmOnEiZSF9oCag1vV1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728882109; c=relaxed/simple;
	bh=YQNIqpnXngZWhi/aJCruSivBm8gOysW+5qKPkdNBfDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PTADwx1i3ZxmIF44uAERiTu7Niv0ywZqH1FqwPephCnB+8FbJGPYt2xylJGf2oY1MJxPCUQpV+/klZRgx5VJvibIAq80649gduUKFS7+vUP//dODQoQvoGh2O9roy8jPsYeh1lTpa/WWakj4VhcG2M3Rx5RtDs3d210Q9KVzvS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EjuIS0Q2; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728882107; x=1760418107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YQNIqpnXngZWhi/aJCruSivBm8gOysW+5qKPkdNBfDI=;
  b=EjuIS0Q2PXdQSyedin6GFfKpvigPOsHlqRQQJ5DH6y6FnABt7wN5WVK9
   CJe3+ciVuYPd6d7O7rQ79MOGZ5VtXF6iNPNUU5QXopnhKjrCuQX0rvisZ
   OHO3I7VeJHkABYCgF8lKhh7IZ9alAZBbqNxXNkd+a/JcWVZ8urJxuSO1y
   NK4mZc+ijbDg5knuk21WL61q1dQC18ke2Mx8TSie4FoRL6yamJtFRT3xa
   JaA4Aa59gYRr73JuQaXwxTLsG2+y3+hbEArvh7oZ7+00VkbpF8fflquAr
   Q1iotc7dcAr6KkfClc08UyfuZldXWRSpekpCstc9yPqwRQH3jHVlvBv5e
   g==;
X-CSE-ConnectionGUID: 8Ol1yq/FQaqnr1v4/+dVSA==
X-CSE-MsgGUID: 4kN7VA1kR+C6XHTDEolVNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="53635245"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="53635245"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 22:01:45 -0700
X-CSE-ConnectionGUID: KY7a8L4UQWqt4lR8nk9GzA==
X-CSE-MsgGUID: 8pKGXwuPTAOo3NAY3aMVLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="77331512"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 22:01:43 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v2] KVM: VMX: Remove the unused variable "gpa" in __invept()
Date: Mon, 14 Oct 2024 12:59:31 +0800
Message-ID: <20241014045931.1061-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the unused variable "gpa" in __invept().

The INVEPT instruction only supports two types: VMX_EPT_EXTENT_CONTEXT (1)
and VMX_EPT_EXTENT_GLOBAL (2). Neither of these types requires a third
variable "gpa".

The "gpa" variable for __invept() is always set to 0 and was originally
introduced for the old non-existent type VMX_EPT_EXTENT_INDIVIDUAL_ADDR
(0). This type was removed by commit 2b3c5cbc0d81 ("kvm: don't use bit24
for detecting address-specific invalidation capability") and
commit 63f3ac48133a ("KVM: VMX: clean up declaration of VPID/EPT
invalidation types").

Since this variable is not useful for error handling either, remove it to
avoid confusion.

No functional changes expected.

Cc: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
--
v2:
Add the missing must_be_zero 64 bits.
---
 arch/x86/kvm/vmx/vmx.c     |  5 ++---
 arch/x86/kvm/vmx/vmx_ops.h | 16 ++++++++--------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a4438358c5e..c0f4bb506a58 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -481,10 +481,9 @@ noinline void invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
 			ext, vpid, gva);
 }
 
-noinline void invept_error(unsigned long ext, u64 eptp, gpa_t gpa)
+noinline void invept_error(unsigned long ext, u64 eptp)
 {
-	vmx_insn_failed("invept failed: ext=0x%lx eptp=%llx gpa=0x%llx\n",
-			ext, eptp, gpa);
+	vmx_insn_failed("invept failed: ext=0x%lx eptp=%llx\n", ext, eptp);
 }
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 93e020dc88f6..633c87e2fd92 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -15,7 +15,7 @@ void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
 void invvpid_error(unsigned long ext, u16 vpid, gva_t gva);
-void invept_error(unsigned long ext, u64 eptp, gpa_t gpa);
+void invept_error(unsigned long ext, u64 eptp);
 
 #ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 /*
@@ -312,13 +312,13 @@ static inline void __invvpid(unsigned long ext, u16 vpid, gva_t gva)
 	vmx_asm2(invvpid, "r"(ext), "m"(operand), ext, vpid, gva);
 }
 
-static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
+static inline void __invept(unsigned long ext, u64 eptp)
 {
 	struct {
-		u64 eptp, gpa;
-	} operand = {eptp, gpa};
-
-	vmx_asm2(invept, "r"(ext), "m"(operand), ext, eptp, gpa);
+		u64 eptp;
+		u64 reserved_0;
+	} operand = { eptp, 0 };
+	vmx_asm2(invept, "r"(ext), "m"(operand), ext, eptp);
 }
 
 static inline void vpid_sync_vcpu_single(int vpid)
@@ -355,13 +355,13 @@ static inline void vpid_sync_vcpu_addr(int vpid, gva_t addr)
 
 static inline void ept_sync_global(void)
 {
-	__invept(VMX_EPT_EXTENT_GLOBAL, 0, 0);
+	__invept(VMX_EPT_EXTENT_GLOBAL, 0);
 }
 
 static inline void ept_sync_context(u64 eptp)
 {
 	if (cpu_has_vmx_invept_context())
-		__invept(VMX_EPT_EXTENT_CONTEXT, eptp, 0);
+		__invept(VMX_EPT_EXTENT_CONTEXT, eptp);
 	else
 		ept_sync_global();
 }

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.43.2


