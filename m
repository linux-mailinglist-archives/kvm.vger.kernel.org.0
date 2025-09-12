Return-Path: <kvm+bounces-57468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC1BDB55A4B
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA3BA7A7F8E
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDC22DECCD;
	Fri, 12 Sep 2025 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hYWsS14J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72A02DEA61
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719453; cv=none; b=InjxtyLM3n2golKfcCTTVJ2gfDDARTxWWQDCDMkoYVlH+fmd1sWvuhfw9NWMQbOhaeBRRu7mqdgvqjE3MSpOHJud+OxlKA1lTqe5o3DHjYqk0xvUXkLc0wAxJB1eGAAAd2ST64mrG7TuGdAt6W7dyPifgGlDjWVO2zuTYz6Ig/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719453; c=relaxed/simple;
	bh=ibVx0FQYqXwWEPMynXAQvI8QkDm2bnd6eQ6psaEJve4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N5iJGS73itcjhxnR07xoMWvjUVM9tCFf0jmmRCVAcczaBCPmpsBwmkRawhiYQS6TYPRw13GyVG5X5zK9IaR7swKXSR3TBCB1KKaCXoFoj+MQkjT0iYB+PWLY2siST2lU0/NHar8MLm2FsgGg8jATy/DvyK2kFw7ARTIU2MnHiro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hYWsS14J; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32df93c787fso831215a91.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719451; x=1758324251; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P17T2Hc4cvt7UHogDIDzHK2g+ZOZ7+bJS/PGJRYg480=;
        b=hYWsS14Jwk96ikD54mq0ofB2+3v2+NSmjKJ2A/2Ya8o1KhlJN/UrTGyUESX2FZJ3N1
         6Y/4xb8o79ndd3/h5gEDX2Lfga6ZwIlgEkU08KjCHjSxNkMwpT+SPXeBkyihZ8jKJn2R
         McLIgMb2w8H1MW9qsBSI7sJF6aWLcTCbH94yL6NilIl8OXv5YWNWTgeJUecR2UGQjuCr
         XsIGMP6lMz0UKgiAksYSajuKyyloH8RQy0PgMNdFmIIpYgwpT/3Nb7La2dexBe0xfr7q
         Hj5yFTGhwSK/R/RrmN64K6Q6CaObEwartTFTFMPtIVe0cHOBy2P2pEIad7fPpXxZiT1E
         fOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719451; x=1758324251;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P17T2Hc4cvt7UHogDIDzHK2g+ZOZ7+bJS/PGJRYg480=;
        b=rG0tQ1foM33eLmg+8q19vvevFNC58sS3o0BToPyKpKEapLMc1OgIVqhRp/dxkdVy4B
         jbie4HHN/55dJItB1VlLLnh9znHnpUOiAMYKjzq1qT9jszvQJARDBq+RpAEXnk6lFguj
         ByLZnFy0pb6EyU6cYW0a8lyzalfpPWlPJHWt7Od6sbbUV2xK5tJ/bPLf2pi3iQf7iEny
         iXvpIcnivdep16SVfjwN+sReaBUo82qD48upMjJb2D1HzkL7fZlIMzZ84LcTq+5VoJvl
         2oe/Q2BI9FU2EtnFtOQVfzog5g2X8NJViQ6uXz8QMHD3gCPcb/hQkCjw494vd9JFeuzK
         N7mQ==
X-Gm-Message-State: AOJu0Ywh3ley3IuAULA0YAYdNL2vtIJBzEJEv/dsuNATUXCVTlgw1OYn
	VqktGDl3yCaxip/5kAbEFh4K2UmXyVBql6x02YXtR19KaUDCA3LWi8pFZN5jjYzTMOgUocUk77y
	ZDZpVbQ==
X-Google-Smtp-Source: AGHT+IGryREUWABLXeI7Y2NygSNQ1QneEizKFfgwAWaJPJ3TP/WQWkAEI/3KUf0ujNHhG9xnm/RoyAv/XdE=
X-Received: from pjbqb3.prod.google.com ([2002:a17:90b:2803:b0:32b:8eda:24e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8e:b0:32c:205d:cd5f
 with SMTP id 98e67ed59e1d1-32de4f5ca95mr5155245a91.18.1757719451148; Fri, 12
 Sep 2025 16:24:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:03 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-26-seanjc@google.com>
Subject: [PATCH v15 25/41] KVM: x86: SVM: Emulate reads and writes to shadow
 stack MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Emulate shadow stack MSR access by reading and writing to the
corresponding fields in the VMCB.

Signed-off-by: John Allen <john.allen@amd.com>
[sean: mark VMCB_CET dirty/clean as appropriate]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  3 ++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4e1fdcf56da..0c0115b52e5c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2767,6 +2767,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel_compatible(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2999,6 +3008,18 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel_compatible(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_CET);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_CET);
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		svm->vmcb->save.ssp = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_CET);
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c2316adde3cc..a42e95883b45 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -74,6 +74,7 @@ enum {
 			  * AVIC PHYSICAL_TABLE pointer,
 			  * AVIC LOGICAL_TABLE pointer
 			  */
+	VMCB_CET,	 /* S_CET, SSP, ISST_ADDR */
 	VMCB_SW = 31,    /* Reserved for hypervisor/software use */
 };
 
@@ -82,7 +83,7 @@ enum {
 	(1U << VMCB_ASID) | (1U << VMCB_INTR) |			\
 	(1U << VMCB_NPT) | (1U << VMCB_CR) | (1U << VMCB_DR) |	\
 	(1U << VMCB_DT) | (1U << VMCB_SEG) | (1U << VMCB_CR2) |	\
-	(1U << VMCB_LBR) | (1U << VMCB_AVIC) |			\
+	(1U << VMCB_LBR) | (1U << VMCB_AVIC) | (1U << VMCB_CET) | \
 	(1U << VMCB_SW))
 
 /* TPR and CR2 are always written before VMRUN */
-- 
2.51.0.384.g4c02a37b29-goog


