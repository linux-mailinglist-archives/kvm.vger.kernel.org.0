Return-Path: <kvm+bounces-59964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E586EBD6EE9
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A38E7409446
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CE62E2F08;
	Tue, 14 Oct 2025 01:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b5eYmufe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18942C0293;
	Tue, 14 Oct 2025 01:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404258; cv=none; b=ujAohBOsgqrCDjkJ0bFIvuXOnTOUPOXZwXKDgMb75fxdRZdPzFE3nWFLMA9XkHi6ILfOyveu/Qj9KZCLUtA4curqmxKcM7VEjfrhkmk1QEy6EmR27XQf41JzI/3IcF9PGShQsmdlq3lPT51XGRVGY523niLQXB/dRWxCSlJZeEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404258; c=relaxed/simple;
	bh=Pm45zGaYPyq5l4l7efesn2scxVs7fyqBRFKo4aRrHf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FP27tSSDYIz1ti6RVygRYaTSw+nB9taBCu3A38JjgxhquJJ8NxMHBKQWyPI7ivKCh/KnCAMGvr4s2sL/B6jvXWU292GubmO8SJf5x0mBWSM//iGhwk5Khovebhh2Ec7FiOJ7aXrBAkeKwP5zYvm1fKszB2MpWxIW/5jDCKRyaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b5eYmufe; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1i1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1i1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404215;
	bh=kz8coyzoOOO7TNq5vADJk9RNm1dpop3qleyprSd53Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5eYmufeeUiR1I+tUrJ9uz6bCxbXo1rjWiJRnNcJY5pqG3Hy/EcotGhhditJYV2kS
	 BKZUcaigqiTpyfWZu+nZVqG7C05Lb0FyVTVN71467zOVw8QSsRZwr/KFtU5LqRflK/
	 CpWRyNk+NXWwApTjkys6VfYu4cxonn2bqfWDmoPqBVqSuhaexyjCDFCrlOchKPSjPq
	 QShpQ3Xej9udd9qq6JcpkJ59cC8Ao9B5zjJOM+IxAZd5/VrA37LRe5QQaBaw7KtXIs
	 7owc0+OPlX/jtUTfNfmGzLxPLUe8A3p+A126bj7dxiWerCEpdmz6+GgDucK79Tbudu
	 nCuX4humh0iQQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 21/21] KVM: nVMX: Allow VMX FRED controls
Date: Mon, 13 Oct 2025 18:09:50 -0700
Message-ID: <20251014010950.1568389-22-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
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
index 0867c1f09999..c8edbe9c7e00 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7443,7 +7443,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		 * advertise any feature in it to nVMX until its nVMX support
 		 * is ready.
 		 */
-		msrs->secondary_exit_ctls &= 0;
+		msrs->secondary_exit_ctls &= SECONDARY_VM_EXIT_SAVE_IA32_FRED |
+					     SECONDARY_VM_EXIT_LOAD_IA32_FRED;
 	}
 }
 
@@ -7459,7 +7460,7 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_CET_STATE;
+		VM_ENTRY_LOAD_CET_STATE | VM_ENTRY_LOAD_IA32_FRED;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b92fc81af5c4..c1a6547bc0aa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7975,6 +7975,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+	cr4_fixed1_update(X86_CR4_FRED,       eax, feature_bit(FRED));
 
 #undef cr4_fixed1_update
 }
-- 
2.51.0


