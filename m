Return-Path: <kvm+bounces-53286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 016ADB0F9AD
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D49D7B42A4
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAF623372C;
	Wed, 23 Jul 2025 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dy4PbUMO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D42D228CBE;
	Wed, 23 Jul 2025 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293261; cv=none; b=QjIzMc8ZTOFYWSxtTzrsEhKSuhaYo/3SjFcVC/kxQenfZVb6GsC1g6yXeIHhtm2n5SxY68TBOiKXQDym+ntaloGcTATtuo/cPRaCFV4QgdK0WB9SaoTwubOEMxNRpVD+4tF0asEc00lADhIafMT6Otn9loBvooQLk0FbPiCK3U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293261; c=relaxed/simple;
	bh=zZDkl2sEj8bbirzJKmx0Quse7t3V4jW1l9acGjfFwwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7fanNcTibd/3aqfLxRmGUkGMLZ0ibrpK9JPgNjeP/e2m9crJcrhbEiiniSBEc14AB4Cmc4rfZNkn1QQEypWqO3FNWHJLPNYWnI0A1zr4GU9PCUbpLCb+nsoCwcl9PXun6UZCS8fLJWFGeq1LecGv4TcncYUcxm6s8Yrd4i6oBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dy4PbUMO; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf0C1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:54:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf0C1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293246;
	bh=CDamqBzQwv1MD5nS57D4yPDft2aOSRkKHs3w7oljxxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dy4PbUMOoWrK3Bd5KAKcGBcKTtaMXvSDbMnHG8Lwwe92D5u0IC/eM/4YuyZelZIWM
	 UcXtFXVw66Mb8KrhyBM4TRMZ6tTSwi0F2stVzpCqfOSnJi6o55CVprKwTsGBOsLVHd
	 D/oDcjSoimP0NStv3aMHTbiebpdDKMHZnYP3si6dSIHaSb/5AoZv30Ncifu3K1FdQb
	 VWNgFYKzY9/Ej3G7EgGpRhsjS93oC8Pdmk5c9u0sIeddNdfYwl5nEA5Ym0M+jh8w2s
	 K1lMQmKQGI3Bep42OeuiL9QbsME7Yf6kk3C0yl65gsJz+XD3NhY6SeHf/P+leNDoYZ
	 a/3RV9MXxgI6g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 22/23] KVM: nVMX: Allow VMX FRED controls
Date: Wed, 23 Jul 2025 10:53:40 -0700
Message-ID: <20250723175341.1284463-23-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
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
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 arch/x86/kvm/vmx/vmx.c    | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d215e5ade5ef..3554701ec43b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7213,7 +7213,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		 * advertise any feature in it to nVMX until its nVMX support
 		 * is ready.
 		 */
-		msrs->secondary_exit_ctls &= 0;
+		msrs->secondary_exit_ctls &= SECONDARY_VM_EXIT_SAVE_IA32_FRED |
+					     SECONDARY_VM_EXIT_LOAD_IA32_FRED;
 	}
 }
 
@@ -7228,7 +7229,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_IA32_FRED;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 90f0573c8187..3cd860ea1577 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7854,6 +7854,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+	cr4_fixed1_update(X86_CR4_FRED,       eax, feature_bit(FRED));
 
 #undef cr4_fixed1_update
 }
-- 
2.50.1


