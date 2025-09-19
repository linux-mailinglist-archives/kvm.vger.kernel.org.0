Return-Path: <kvm+bounces-58262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2ACB8B856
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B6BC1C23F33
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1274302CBF;
	Fri, 19 Sep 2025 22:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEjFZMh4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9531C301489
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321249; cv=none; b=pxEKBLSCPjFdKH0r8X3fUKMsbqNka4MJzeNOcN2CDJ51tpNQGRPtGJz7IushiH3u+CtOCbDByTEcQ8eNSTx6CuRgPhM9TaG5L3KofPg9FjWq8n5b0A56BRhc3XYdTNGthIoDHRtz97BGDyvbe0RJgTvCiOKDb0U1trelGKSJkhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321249; c=relaxed/simple;
	bh=q6umMK6qW+JPWfNi7ZBDx+lHcmQ5ye31wZcLqFrPb/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m82frVFWBJ1AniNmSFNMZeWe/wuYIZeR9eOxx1IrADrpwDnj30tlKdtjPLSLRiIAXhh7/E47OKCP9AIBif3QIL3D/8VpypzitkCObkwgfgn2xdmAVT8/Nr4UCG4yA6U+viuyi+606YxMp9P7C78WJqKEEQRBylsWHJeGVtmqxVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mEjFZMh4; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24457f59889so29950435ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321247; x=1758926047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jwjFFCg0dTIdXUahdn/F9Z3j7jQ6PDvcYGKOHRJDRJk=;
        b=mEjFZMh4z8PcQStuDd51JX5C8tXJiHgrgA88Ud4I6tparAeSEIMADaTr5VMvsxc4CG
         Rsg00W+iEf1pFkTRJ6logERhD1gnByxZ9Ywxjoo/5/E6M9uDCntj74Zo6uyR9UtqQgk7
         CqMhxnz5TYR8wKdgnPcOeFpY9akkxPBK+Idv+PYDdo5f/5jqPCC/MHwN3JJ7gC8mFvAG
         uTharGTBy08ukDabUhZJH1YKK7FwBMAZenVNMuWX087MufVDeonHzfIXN9gn/GY/78Wl
         2GHJXWxvKhpuos3Ekgb0DQa30BcI0dI1uU+d8KMOgmr9HoF6UsU3oZVXmP4y0GPwR6vn
         U69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321247; x=1758926047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwjFFCg0dTIdXUahdn/F9Z3j7jQ6PDvcYGKOHRJDRJk=;
        b=G4Apyin4srahopTRAgaMPJwMSqnOH8QQnSEqc5orApgi2QWvUqjJw7tHGOvvLig8OU
         2cYChIz5wH5EHcutyEM8JKHnb6s/5IXrtAH7F+0l9wtIRAsvEOAXXA2LCXZCZwEku7ho
         DDusgjsx4haCvCDytTm9895SjWE1PSosTmPS0ouWeEEPSyS7JoSMdBhpQehdPZaCNQg1
         tqicWFuM2qlfRcXcvhdEhdsp3QEIm1TSF0MnNyCsFRbyvWEj+NfOShpasQgYPKXNTT/N
         k9/uqg/XKxn3/UAeqWy7nugDKoIswmPDeYszg6PaJWjEcbF2ABcczWh2mXAY5qgW2LuP
         p4XQ==
X-Gm-Message-State: AOJu0YxgvcjoJdCjYxQ+2jbZXMfTyC4n2vHOvYmW11NK5yt9Gj1yLn8t
	8cIdmk9HrOiXOoPuArTu5v6sUSXQR3obOdPRBRtmW4TotEhmsN27aSLgnuqTtsVbQGpMRz0KWBL
	9sv3afg==
X-Google-Smtp-Source: AGHT+IGC4ec144TqZsVwl31X4iIc+jUWFa9rB1zY9Uxm0DUf1TDCRwL54bqXZIygdGVad++/qbIZMsJ1wFk=
X-Received: from pjoo3.prod.google.com ([2002:a17:90b:5823:b0:32d:a0b1:2b03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50c:b0:26e:49e3:55f0
 with SMTP id d9443c01a7336-26e49e38a46mr27196105ad.16.1758321246864; Fri, 19
 Sep 2025 15:34:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:41 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-35-seanjc@google.com>
Subject: [PATCH v16 34/51] KVM: nVMX: Advertise new VM-Entry/Exit control bits
 for CET state
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Advertise the LOAD_CET_STATE VM-Entry/Exit control bits in the nested VMX
MSRS, as all nested support for CET virtualization, including consistency
checks, is in place.

Advertise support if and only if KVM supports at least one of IBT or SHSTK.
While it's userspace's responsibility to provide a consistent CPU model to
the guest, that doesn't mean KVM should set userspace up to fail.

Note, the existing {CLEAR,LOAD}_BNDCFGS behavior predates
KVM_X86_QUIRK_STUFF_FEATURE_MSRS, i.e. KVM "solved" the inconsistent CPU
model problem by overwriting the VMX MSRs provided by userspace.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 024bfb4d3a72..a8a421a8e766 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7178,13 +7178,17 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
 		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
 		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		msrs->exit_ctls_high &= ~VM_EXIT_LOAD_CET_STATE;
+
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
 }
@@ -7200,11 +7204,16 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		msrs->exit_ctls_high &= ~VM_ENTRY_LOAD_CET_STATE;
+
 	/* We support free control of debug control loading. */
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
 }
-- 
2.51.0.470.ga7dc726c21-goog


