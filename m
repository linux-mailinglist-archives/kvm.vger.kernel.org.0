Return-Path: <kvm+bounces-8497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6017084FFB3
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010841F243C6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E233B2BF;
	Fri,  9 Feb 2024 22:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UVTnGWNa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AA03984F
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517027; cv=none; b=kXOJ5BFLHPNqtPI37CZWP7jLFRfk+PS+2Fslrd98F/A4Q79crR95Jeks8eSqcalhO9UGL5fGr0ILKB5cTrPfdpcwV4L4LvHRnsqRiQHjeubg4qQ9FM+f6x7E+qjJbmR8cltFcmnoX4ST7m1/mVsQx7/7M3atbrVObxGLVoFRwss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517027; c=relaxed/simple;
	bh=vCfMinZ3ioVa697wfHhRMUGC7BJ9VIJaAEWf+LUoN7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t496lmJYm2fvbPyZ4Z4eizIdMm64dLp9tJzzrfgsm2LRfE1spmtq62ZTekHm5tjtSn5cXKDjxVVyR3YwJT9OLMeilMTc5r3pUgS2S4G/OmdmDLdcSaM6kypKYEOjVvYVEAepdLSizCgzBXtHNRXDBDK2Ej1t9M7Qh6h5fpUKkQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UVTnGWNa; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5fc6463b0edso27935837b3.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517025; x=1708121825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EtUmW5C5jIEQG3Xq+wKcQPGgTDr9KsPcRaFSmsaaMus=;
        b=UVTnGWNapPTQj7nVfFqDl2/bgfSHmwVxHNZhcFzxA7vYkFq6lwX/jZfACJPcurBRyg
         G38buWkRMSGsiWw6iPjl00sFZCNjYdBw19qdBJirxaBRWiGkMrDdfdxYFOLq57XcR3IF
         8ChRKcGDg/p9t6pK63ROYdf3j4ONq3rMZmtkvy34ZBib+CApXxppob4U2rJyNYbb5aGj
         eiaryjW9OKAynLTd4KE4FN9i2al6maxDaASNJVhK+mKEj1fqoc9HD5gxrb4+C1u4Vyoi
         ORgjK3PoDp870ie4tpIeSUEscuo4ThiwZe9AEH0Ls03wGUbnEzO+8PrgbuRJrmWbfFuC
         UrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517025; x=1708121825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EtUmW5C5jIEQG3Xq+wKcQPGgTDr9KsPcRaFSmsaaMus=;
        b=k31yRNg6/8r1yjM3WnEGd+fcIQVhrxjhwUfHM0StE/q9IDfRjhTbttCwh5DYDbLfye
         C0mOa6T8tYdPzCF4UOAjoUbBKEalSJ5N0XSSEIV/HFRFxDGQQHORHDDloDFHNryI3uVj
         t4sQGM6RSX312o4wM5VeuubgLpKqBqQciOTtZCh7jgpSPAWYdvpMXqh25T1CfM5+Y67M
         vqpS1cmOa9xKseqi7O3msTrm68zD50QB1sQJKV+7bTpWuXgmqixaWQX+Mjfl0t2GXKGO
         1XDCQgjUlp5bJVqEKaqBgdIyZSWc4ry13P1RHO/X8ikdcpF23QlA0RsG5lPX+1wsmjZU
         pIUg==
X-Gm-Message-State: AOJu0YynfxfCw5VoKmNhGVGCYD0YZuGGLwz5tLel/rtfzg1S/+dCZMEQ
	Q4BNFZld7375BTOZWfAjGR30B+c1C7vucQLwV8Do18MTmUCgFSqweNnunvMxXrSJwCKD7NhUNbi
	vRA==
X-Google-Smtp-Source: AGHT+IHoLzDO4enoLF12MipFfYOPxOqptTuIhXlXrM241lI+t+J+ZGQWc0jkfgWHk3zIV3gHAlO69Fo9B00=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e6cb:0:b0:604:4073:66ca with SMTP id
 p194-20020a0de6cb000000b00604407366camr98778ywe.3.1707517024940; Fri, 09 Feb
 2024 14:17:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:16:58 -0800
In-Reply-To: <20240209221700.393189-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209221700.393189-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209221700.393189-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: nVMX: Clear EXIT_QUALIFICATION when injecting an EPT Misconfig
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Explicitly clear the EXIT_QUALIFCATION field when injecting an EPT
misconfig into L1, as required by the VMX architecture.  Per the SDM:

  This field is saved for VM exits due to the following causes:
  debug exceptions; page-fault exceptions; start-up IPIs (SIPIs);
  system-management interrupts (SMIs) that arrive immediately after the
  execution of I/O instructions; task switches; INVEPT; INVLPG; INVPCID;
  INVVPID; LGDT; LIDT; LLDT; LTR; SGDT; SIDT; SLDT; STR; VMCLEAR; VMPTRLD;
  VMPTRST; VMREAD; VMWRITE; VMXON; WBINVD; WBNOINVD; XRSTORS; XSAVES;
  control-register accesses; MOV DR; I/O instructions; MWAIT; accesses to
  the APIC-access page; EPT violations; EOI virtualization; APIC-write
  emulation; page-modification log full; SPP-related events; and
  instruction timeout. For all other VM exits, this field is cleared.

Generating EXIT_QUALIFICATION from vcpu->arch.exit_qualification is wrong
for all (two) paths that lead to nested_ept_inject_page_fault().  For EPT
violations (the common case), vcpu->arch.exit_qualification will have been
set by handle_ept_violation() to vmcs02.EXIT_QUALIFICATION, i.e. contains
the information of a EPT violation and thus is likely non-zero.

For an EPT misconfig, which can reach FNAME(walk_addr_generic) and thus
inject a nEPT misconfig if KVM created an MMIO SPTE that became stale,
vcpu->arch.exit_qualification will hold the information from the last EPT
violation VM-Exit, as vcpu->arch.exit_qualification is _only_ written by
handle_ept_violation().

Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 994e014f8a50..1eebed84bb65 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -417,10 +417,12 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		vmx->nested.pml_full = false;
 		exit_qualification &= INTR_INFO_UNBLOCK_NMI;
 	} else {
-		if (fault->error_code & PFERR_RSVD_MASK)
+		if (fault->error_code & PFERR_RSVD_MASK) {
 			vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
-		else
+			exit_qualification = 0;
+		} else {
 			vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
+		}
 
 		/*
 		 * Although the caller (kvm_inject_emulated_page_fault) would
-- 
2.43.0.687.g38aa6559b0-goog


