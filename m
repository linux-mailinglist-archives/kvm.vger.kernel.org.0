Return-Path: <kvm+bounces-58658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 011ABB9A6A4
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBB07188DEDD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5052530BB8D;
	Wed, 24 Sep 2025 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Wh5kzIr2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00F1F5F6;
	Wed, 24 Sep 2025 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758725701; cv=none; b=eqdNN6YoJx1Ed0EQ2urVz8nWIGDZCV+exLT/et9G7l3neoekGapLsYIAAmkGyBrSRdQ67fEuy7XiQzy0iBBcVfv/OT0MOeXg5TMt6h816HJIkNVee/e0BTlWnc43ZwLu0cGWNgrd/7UlfJyksn4ZjmRv3rCfzmni0QPNrKkI27k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758725701; c=relaxed/simple;
	bh=ums5rCpligBaqIOr1iJYvoJi/ipeeOOcZh64vXTzvD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n9Z6GIDikx88oJ//7YF5CzdPwAmZF/KURsrlKAj73COz+Hgw2MT8uX3PBqDN5EE0FcO6OqJ9XfknJthSVjGFPaCrcXYSBSuvGKhkBcqEqqdF8LJGMOFIA++az+SPamnRxphVRZbfrF4DRwCrQ+kglDj4txohI8U4JruBegIuI7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Wh5kzIr2; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58OEsLMt2046832
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 24 Sep 2025 07:54:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58OEsLMt2046832
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1758725665;
	bh=3fdycQ/ZLjLpUaLy9CBDdIIoh4ke95VnoYcdcc/EbPw=;
	h=From:To:Cc:Subject:Date:From;
	b=Wh5kzIr2z6Wp4F58tFAaz70gI4SIH7VBJl/HvraSIDJrmM8BhZw42VQ8k3JbskvyA
	 OoVfBRYBiqFlGYBzEvliypqTcTr5/AQN1woF1oaGXJc07OuN+u/yU95q2bvHxBsJ5O
	 YxHW18gd75h0fynGCdege3UY+B3yFZHmTYARketbD+Ll/DqvfGfwPatTU5rHnR6pOg
	 s1Z3BWKInFAWCnBl2nnC9Y93t2fV/5U+EqGd+ClpH6d+z+bgqOXJovxWgwju61vtgY
	 RuUWRE58AaJNaL6FqGADs3t+YmIhcR1fldWHFo0MvRLHp1ZhQlUQcGZi3z0H2WHPpW
	 2vqCBQInnCBXA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v1] KVM: nVMX: Use vcpu instead of vmx->vcpu when vcpu is available
Date: Wed, 24 Sep 2025 07:54:21 -0700
Message-ID: <20250924145421.2046822-1-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prefer using vcpu directly when available, instead of accessing it
through vmx->vcpu.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb70..3fca63a261f5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -761,7 +761,7 @@ static void nested_cache_shadow_vmcs12(struct kvm_vcpu *vcpu,
 				      vmcs12->vmcs_link_pointer, VMCS12_SIZE))
 		return;
 
-	kvm_read_guest_cached(vmx->vcpu.kvm, ghc, get_shadow_vmcs12(vcpu),
+	kvm_read_guest_cached(vcpu->kvm, ghc, get_shadow_vmcs12(vcpu),
 			      VMCS12_SIZE);
 }
 
@@ -780,7 +780,7 @@ static void nested_flush_cached_shadow_vmcs12(struct kvm_vcpu *vcpu,
 				      vmcs12->vmcs_link_pointer, VMCS12_SIZE))
 		return;
 
-	kvm_write_guest_cached(vmx->vcpu.kvm, ghc, get_shadow_vmcs12(vcpu),
+	kvm_write_guest_cached(vcpu->kvm, ghc, get_shadow_vmcs12(vcpu),
 			       VMCS12_SIZE);
 }
 
@@ -2749,7 +2749,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
 		vcpu->arch.pat = vmcs12->guest_ia32_pat;
 	} else if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
-		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
+		vmcs_write64(GUEST_IA32_PAT, vcpu->arch.pat);
 	}
 
 	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
@@ -3880,7 +3880,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		goto vmentry_failed;
 
 	/* Hide L1D cache contents from the nested guest.  */
-	vmx->vcpu.arch.l1tf_flush_l1d = true;
+	vcpu->arch.l1tf_flush_l1d = true;
 
 	/*
 	 * Must happen outside of nested_vmx_enter_non_root_mode() as it will

base-commit: 325fbe689e121ba11c16096f452750614767c31e
-- 
2.51.0


