Return-Path: <kvm+bounces-27718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1DF98B344
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C55541C22367
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FBD1BD016;
	Tue,  1 Oct 2024 05:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="A6fSaZ5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F20974E09;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758937; cv=none; b=lfZUZynoYnAToQsUeKXrILm7VT83e1gRXuevpoGwd8lsHKlON4KkdzpsC0IXcKb09kfG6cIwJ8Oxf9xhfzAOGbaUuuuVYpkU72aij7BviTrjcBQzvvaKGUzilaeqQg8yiMy7JTaq0575QfdmJGO4uk/nSTCI2cRCYnLzqD+1kno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758937; c=relaxed/simple;
	bh=OC9q8/0WaJQ1ajKPZH3KXjpXhUhvJLWl9lJoncDMjjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boHyS62LR+ayc8KVq8aI1rvPUX4BenZrYpUyXQpk+nSwqpX+jUUWKzutGSASUPUcKI/ryiI+CdeGuluPZ5pZv766m40gDcBhduaR6w8e3+t1zq6QPDCnYRg6RF83/ce7wrgqc9tcA+sVnuF0HOPNjYSQ6LmLqimjBXAbdZDPFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=A6fSaZ5J; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7q3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7q3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758903;
	bh=aB86Wj6xLWMx6vbkl7mBHvGR5iFDZ82fM7jlvBlgm1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6fSaZ5JysraQ0FAZ0EH7VyJxJspiHugaIbKVEgtwGMhqrWErsRtN/0+mveyoMUG/
	 DchoyhVYetJrgWNHiqrbwMuvVd81uFbdKK+LCtXqWFhBzX9Lqr69rLvGtQSG5fuErs
	 0G6/HSCI2eUiM32w0cURjShEw/D8Zieiq/TGSQVOG8YrAas5XaM/ALgPMU4QqwIVkW
	 5wDTx6v3CEjQwkkat+aVD2GSKGQgiX3EAfwpGKDn6SadTDkdvMjGglg9oc3sqc/PtJ
	 VUKEnuBd0+1BBzfvu4z7UmsnuBSLu+Z0W4tAzhpPha/G4EYm0PEWUowb7HgyGYMxEo
	 c1P0QEXnCcK5g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 27/27] KVM: nVMX: Allow VMX FRED controls
Date: Mon, 30 Sep 2024 22:01:10 -0700
Message-ID: <20241001050110.3643764-28-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
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
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 arch/x86/kvm/vmx/vmx.c    | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1fbdeea32c98..b1b4483afcda 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7159,7 +7159,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		 * advertise any feature in it to nVMX until its nVMX support
 		 * is ready.
 		 */
-		msrs->secondary_exit_ctls &= 0;
+		msrs->secondary_exit_ctls &= SECONDARY_VM_EXIT_SAVE_IA32_FRED |
+					     SECONDARY_VM_EXIT_LOAD_IA32_FRED;
 	}
 }
 
@@ -7174,7 +7175,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
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
index 522ee27a4655..ba6a7c6b6727 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7923,6 +7923,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+	cr4_fixed1_update(X86_CR4_FRED,       eax, feature_bit(FRED));
 
 #undef cr4_fixed1_update
 }
-- 
2.46.2


