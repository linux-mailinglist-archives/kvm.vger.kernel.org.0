Return-Path: <kvm+bounces-70381-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEB3EbgkhWlV9AMAu9opvQ
	(envelope-from <kvm+bounces-70381-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:16:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F8AF84B8
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A613D3015466
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 23:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958B133C1A6;
	Thu,  5 Feb 2026 23:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WFxM0hwo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97662C026C
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 23:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770333354; cv=none; b=fNnpEbrATTXftloLuz+heiVlG7ls3+rx18V36RTJ9siTBvfKCfeIgQ5uI9+fa7Mxo/OP85xVIEPfNuNPSytmcoZj4aRaGsT7JfiILm+Vsfejyq8SFh9U3wtw6NmaumG5dzDDuZcQYtDNdqZqOl9PRQvrif6eDKMzshN80Y3j+gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770333354; c=relaxed/simple;
	bh=z38i7xJ8mEcWy9tZkax+kUeEbeGtqWOfE4+kMi9dRjs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=t0xpNK531oy7FyXjSIxcC/oHQRMoJo0LpXliiDTmClZx7BuzyK0f7pF6eG2Q0oiHl3Zg9HGgLiEgNAPvOdTquDFFPMU8gOCXl2RnLCUcb7Iz7mZbDu8OCDWrQxp5wPsLB/fcS8clBbXC99rF+ck5/clFD1i/wafAyo5GiP29dfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WFxM0hwo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f2381ea85so2269685ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 15:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770333354; x=1770938154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pr9RaIefez2nBGuJOdeMmo4gmWbUowIaURWL9SUM80k=;
        b=WFxM0hwoRq9mbj2QvzsGXoyieuDGBO8yN7TMYHrb90+yazFQf2bJYCJrHMuU+oXY2R
         W46g706Vcc5c3ENls6lK3SlOo2MYQ0d4mUfY1GkvCFMisiWEMSjo1hRlLmr754hDAbzq
         O1sZcZZ97KZYQ+ydutPYI9xJCbLVLeGdbB1Dvsli6jYSBXOzZSVAYlcwTJdlE3+Q/FnT
         kvIBRBcBC7tcMqu7thrqRJ9T9PnuK+N1CLqeSaETYhfTNqi0V+zP1Qr6rZVjNp70dW/l
         lkjmxSN9GvGmAICWYLQoj1RRS5u96s/+lE50A7ay2sEEcNV4uLATvm86sUhKk3ZtE994
         ulJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770333354; x=1770938154;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pr9RaIefez2nBGuJOdeMmo4gmWbUowIaURWL9SUM80k=;
        b=NQaenFdp6FE93gOeb1VFs4qAEYnXfYuTD6WO1f311vzyh0tAqb8xSgMsQe5IuPmsOI
         DwfBHXnB86FaogZa/A0cJpSMmMEtnh+9kBTIonToy33wc/Td4/6aA/amMNf+O/YYYgHJ
         jTJL9xQ0K6oP7u52IpB9Hfb9Ouh9EKaUoGxkEzzMFj/Rv00NDHKzz/2KjDZqcoXp49Vl
         H5bJnvAWNuo29gKFFbwjy4Szj6oqwjuAgEG6Dmotg+oRlkp0mG7pwuSEYUTBY6Y2gY9p
         g2MUE3pUj7BaAzDno95iOUGSr4X39BVuFbFWlGH+18amrgvthnDUrqjnyfRqyKNFTGpx
         jR0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgX8ki9rk14eJOTN4Dih3uUyae2RX9sfQeyNWJAL2C6vcvLA+eoORPiEdf0aTbV1M3vfw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV1n1FuMXbUVq8qhw7zJ/AswTnS27SSu3elrfDDAyQ34CUOp3w
	zafh46p9KtiIa4mAqd+bOR36LdwaKQ8CcG7Qmx999Hr0lea+QbKy1ICSOFUJqZEkMGt3wsk4h5h
	NWsvxJhxrlBbULA==
X-Received: from pjblp12.prod.google.com ([2002:a17:90b:4a8c:b0:352:c761:3cf])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1246:b0:2a9:410:2413 with SMTP id d9443c01a7336-2a95192ab1dmr7613285ad.29.1770333354123;
 Thu, 05 Feb 2026 15:15:54 -0800 (PST)
Date: Thu,  5 Feb 2026 15:15:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205231537.1278753-1-jmattson@google.com>
Subject: [PATCH v2] Introduce KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Josh Hilke <jrhilke@google.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70381-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D6F8AF84B8
X-Rspamd-Action: no action

Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC to allow L1 to set FREEZE_IN_SMM
in vmcs12's GUEST_IA32_DEBUGCTL field, as permitted prior to
commit 6b1dd26544d0 ("KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
while running the guest").  The quirk is enabled by default for backwards
compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 for
consistency with the constraints on WRMSR(IA32_DEBUGCTL).

Note that the quirk only bypasses the consistency check. The vmcs02 bit is
still owned by the host, and PMCs are not frozen during virtualized SMM.
In particular, if a host administrator decides that PMCs should not be
frozen during physical SMM, then L1 has no say in the matter.

Fixes: 095686e6fcb4 ("KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 Documentation/virt/kvm/api.rst  | 10 ++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 23 +++++++++++++++++++----
 4 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d04b4bdd60c1..325e565ff99e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8482,6 +8482,16 @@ KVM_X86_QUIRK_IGNORE_GUEST_PAT      By default, on Intel platforms, KVM ignores
                                     guest software, for example if it does not
                                     expose a bochs graphics device (which is
                                     known to have had a buggy driver).
+
+KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC
+				    By default, KVM relaxes the consistency
+				    check for GUEST_IA32_DEBUGCTL in vmcb12
+				    to allow FREEZE_IN_SMM to be set.  When
+				    this quirk is disabled, KVM requires
+				    this bit to be cleared.  Note that the
+				    vmcs02 bit is still completely
+				    controlled by the host, regardless of
+				    the quirk setting.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..1669d4797f0b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2485,7 +2485,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
 	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
-	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
+	 KVM_X86_QUIRK_IGNORE_GUEST_PAT |	\
+	 KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC)
 
 #define KVM_X86_CONDITIONAL_QUIRKS		\
 	(KVM_X86_QUIRK_CD_NW_CLEARED |		\
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 846a63215ce1..76128958bbca 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -476,6 +476,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
 #define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
+#define KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC	(1 << 10)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 248635da6766..9bd29b9375fb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3300,10 +3300,25 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
 		return -EINVAL;
 
-	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
-	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-		return -EINVAL;
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
+		u64 debugctl = vmcs12->guest_ia32_debugctl;
+
+		/*
+		 * FREEZE_IN_SMM is not virtualized, but allow L1 to set it
+		 * in VMCB12's DEBUGCTL under a quirk for backwards
+		 * compatibility.  Note that the quirk only relaxes the
+		 * consistency check. The vmcb02 bit is still under the
+		 * control of the host. In particular, if a host
+		 * administrator decides to clear the bit, then L1 has no
+		 * say in the matter.
+		 */
+		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC))
+			debugctl &= ~DEBUGCTLMSR_FREEZE_IN_SMM;
+
+		if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+		    CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))
+			return -EINVAL;
+	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
 	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))

base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.53.0.rc2.204.g2597b5adb4-goog


