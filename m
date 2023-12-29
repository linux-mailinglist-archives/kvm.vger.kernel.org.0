Return-Path: <kvm+bounces-5312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 615C981FC8E
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 03:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17B221F24120
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 02:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE79F1FC6;
	Fri, 29 Dec 2023 02:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNYxQ4ao"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4817C4;
	Fri, 29 Dec 2023 02:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703816832; x=1735352832;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jO8UhDDE9XLWPmFjFMmJQX6DOZ0dsIfTQRQHqWpFqgQ=;
  b=JNYxQ4aoFewzKrykJpuMByWR4j1fD3gKj8EMN3UUSoI2TI2vWFJPog/q
   TFPVUN9bxmIouUYwDM/yRpB8moxs3/mju6h2ScdytFRcfZZgzE/w2uVV7
   p4AsLXdsCuC16/efgJolpTNeIwtcQLfgCcuMu36dOMqII3BnhNY8tV9DB
   h4qfVSslAAbjjBZUpuXbPTugfj4Mp/a55gZcpugx7NU7ZAUQfHZg9+JEX
   PqiLQDX3VtEMqO7dh/60guHYuzvNZmdQCCt0RDbte2DWyEq9Pmun3NlLm
   nsEqsdDr1gqxHP8Uk0rl83Eeoh1m0Hil59hPrvt22MR3+0jlaL+qc3XOZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10937"; a="10187546"
X-IronPort-AV: E=Sophos;i="6.04,313,1695711600"; 
   d="scan'208";a="10187546"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 18:27:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10937"; a="754909732"
X-IronPort-AV: E=Sophos;i="6.04,313,1695711600"; 
   d="scan'208";a="754909732"
Received: from spr.sh.intel.com ([10.239.53.116])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 18:27:06 -0800
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Report up-to-date exit qualification to userspace
Date: Fri, 29 Dec 2023 10:26:52 +0800
Message-Id: <20231229022652.300095-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use vmx_get_exit_qual() to read the exit qualification.

vcpu->arch.exit_qualification is cached for EPT violation only and even
for EPT violation, it is stale at this point because the up-to-date
value is cached later in handle_ept_violation().

Fixes: 70bcd708dfd1 ("KVM: vmx: expose more information for KVM_INTERNAL_ERROR_DELIVERY_EV exits")
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40e3780d73ae..46d6ee3c52e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6510,7 +6510,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
 		vcpu->run->internal.data[0] = vectoring_info;
 		vcpu->run->internal.data[1] = exit_reason.full;
-		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
+		vcpu->run->internal.data[2] = vmx_get_exit_qual(vcpu);
 		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
 			vcpu->run->internal.data[ndata++] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);

base-commit: 8ed26ab8d59111c2f7b86d200d1eb97d2a458fd1
-- 
2.40.0


