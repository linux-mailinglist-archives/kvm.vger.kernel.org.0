Return-Path: <kvm+bounces-55437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87385B3097A
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E6971CE5AB3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8770B3128B4;
	Thu, 21 Aug 2025 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="pZbPQ0mW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2033393DE0;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815884; cv=none; b=kDPAX2v/t923IknIooaL+MwHTHIbqOViWvGC9hItNIMwTOTfH6WdzzEZ0m3MmaNf3slNIyEKzQpI7QDS1y/S0OSmA5r7DgZvrFlt3o42bLQpU4fJzWPCQO4xHPwrD1mcZyc0kJuMZpDj+NK4WAstrGa+NOpxG96MpDMnpkM/VPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815884; c=relaxed/simple;
	bh=YuPaJi2RLvihNWDcpnOY47p1x9Qb+0s5ATnmDLK1vMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlfudJGu6RyYkyjE8qgGwF7rZDq7d1kiSy/C//sW9g7LX89WCD0WS9fClUAitFnOvFiS5Dh2ZRFNUgZeFknJ3bC4J0v+JhzdfGdLocUG88ulyDCAB0qUQNBNTsl6C14Hrys7D8kGwXLOobdLqN8Znx+ruv02l9waHsYvDNzCoW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=pZbPQ0mW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOi984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:37:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOi984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815820;
	bh=3f454+pbfQO3MGqeqFMS3Z46Rpq6wwbv1vlH2uO/rig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZbPQ0mWHaWkqNlA+lMLIk1dfRvER1d3g6itJxZUFUhWZ1GEJYbHif2ig3FI0k+3P
	 VCYfS41eIJKtOhcFrdPVQV5GjOkdP6a09AEU4roxUh8iVY2Qm9EfwUPkOiR5dKNUDA
	 +sUtfYfyv8+RHMrhJTcwa7hBqsIO2f4jt2kMc1X7HXbarRGL8aOjX65z3OLfB1Zw94
	 rOL5RD0srKdZ+W7XbiKzZwQ3ossLRNvatP+UgIxrGoEgACUFEws/5b8S/jXKDuEo9j
	 Ba9KXCN5tc2Ws0ggYpBGn/QD1fL4zyhKgcEThzBXgZwYL/JJQJrNAu7o+9KTLcONyF
	 A2jwRJCt4JGbA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 20/20] KVM: nVMX: Allow VMX FRED controls
Date: Thu, 21 Aug 2025 15:36:29 -0700
Message-ID: <20250821223630.984383-21-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Allow nVMX FRED controls as nested FRED support is in place.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 arch/x86/kvm/vmx/vmx.c    | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 266115525b9e..0b266e95db60 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7436,7 +7436,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		 * advertise any feature in it to nVMX until its nVMX support
 		 * is ready.
 		 */
-		msrs->secondary_exit_ctls &= 0;
+		msrs->secondary_exit_ctls &= SECONDARY_VM_EXIT_SAVE_IA32_FRED |
+					     SECONDARY_VM_EXIT_LOAD_IA32_FRED;
 	}
 }
 
@@ -7452,7 +7453,7 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_CET_STATE;
+		VM_ENTRY_LOAD_CET_STATE | VM_ENTRY_LOAD_IA32_FRED;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ac76cb33f3de..99106750b1e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7957,6 +7957,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+	cr4_fixed1_update(X86_CR4_FRED,       eax, feature_bit(FRED));
 
 #undef cr4_fixed1_update
 }
-- 
2.50.1


