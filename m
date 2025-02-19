Return-Path: <kvm+bounces-38532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3854BA3AEEA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FE063ADBA3
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2321AAA02;
	Wed, 19 Feb 2025 01:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WBc9F342"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DF319F103
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928440; cv=none; b=HRFpjQZ+35HBvaeyeCThcdqbLHS0bAK652hIDg9U3xuOu5eiK52QljdFqB18bU95zr3JNP/UsQC62oaJW6ekUyAViQWYuwYzMbx4oqtyUSEJJc2AKdqZy0ZAiBpNzO6DpXKZhS/gi7Di67w2p8qRvtmHsAHICTrwND+hANFkykk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928440; c=relaxed/simple;
	bh=4qE5F9QWe3d5A9/GJCtcN7m+vBvm8zcYETmt15oXBYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GX29NFLECJSb2kSP3h8xgqN+zemiHpPaiVu0MfAVBA1+zS+ec4ohqy7FsazCnv5fltwIy6aYocp7XW+ELNF8qJLMlAYC6fQa4NnOqHGjYNeHteoGaoM/dTgQbyS1D8cBFqwSWCWm5dTHCcrhCr9HnEXexNVojFyLC3VnQB3zf6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WBc9F342; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220f87a2800so137812585ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928438; x=1740533238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aOyRwh3cs/Bv/kD6e4Ko51Wq3Y7FnlmGeIcwci8wsgs=;
        b=WBc9F342lfYIevxHs0qS3XG/3NIcYsMWlUs+1k5TmQKlMv1sUQTFJiu2ZwM3o8Yskz
         CerjFuZyokoT25mP9qI+zavc6Q0VcbdA/erqmnVkMQo9NSn8rZi3P2buhFsO6EMgh0Fk
         jjyEE5r43ECdMINv11AeDbVRP2g0GzhmKtbbq8Ix+/1wcdOJUrGPJQIAwkyYM03eNQye
         e9gbAV2d9cPjSIAVHYJogZCOfZlIrbVZw97iNlS8WiYiC1dU2KY5Zb15xn0nmySYMjqX
         ICHl28jH2AxdjW/+jq4cf8AhBBMJn5zu4jV5fSh11dQGwuAC29uSxzeLECt7zcGpFZR/
         p82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928438; x=1740533238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOyRwh3cs/Bv/kD6e4Ko51Wq3Y7FnlmGeIcwci8wsgs=;
        b=DC2EJMf3Jttx9S6Febq/j7thVmc6einawjJ+t+o455NtRCDgwakDBk9z0lhDGeKDjt
         l9c8x/UGFQSRjUivLhc4mfRK6zohO6sE/hvL3Ma9GcjP8MJMMBjbbW5kyEm5PlOBAq9D
         KOVW/wcKb7vzNneYVVprpcW9GUYinfSlAeQRtX7XRjE+heAeCpeqnCQyou+i/I/qdfHR
         3FCKuOiK6HSgqQlEnmLfRsdu6upaggzdw9P/h+rvIg5Ryh6j7GpBHSiXCHBlUtnBvRf1
         rAAzL1prP5k0zH230IkeXMihzmZ8o7qh3QjOrx4fGLM0d+Cie3eBA9laqy91o12p1F/h
         0klg==
X-Gm-Message-State: AOJu0YygHbILn2wrStXR62cifHC55YtfOAA5ZqlL2ahrTfySHJvDSbr+
	YM5c67w5pkSY+/v7sa0Rffa52clgXyzvQ4CAp6ZF3FHKESljM1H4ZfJTidOpmLmrKk87STjE3IY
	Dlg==
X-Google-Smtp-Source: AGHT+IF+YqB2BsGnTBgkZ7aSO4/b+DJSSz7i3scaotfvDL8sIJxSg/XtkrgUinD2Rx2q79WIomlg2wu4Wbk=
X-Received: from pgbfm14.prod.google.com ([2002:a05:6a02:498e:b0:ad5:4477:da5b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d9c:b0:1ee:d6ff:5abd
 with SMTP id adf61e73a8af0-1eed6ff5f5emr1048651637.14.1739928438279; Tue, 18
 Feb 2025 17:27:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:27:01 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-7-seanjc@google.com>
Subject: [PATCH 06/10] KVM: SVM: Simplify request+kick logic in SNP AP
 Creation handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Drop the local "kick" variable and the unnecessary "fallthrough" logic
from sev_snp_ap_creation(), and simply pivot on the request when deciding
whether or not to immediate force a state update on the target vCPU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8425198c5204..7f6c8fedb235 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3940,7 +3940,6 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	struct vcpu_svm *target_svm;
 	unsigned int request;
 	unsigned int apic_id;
-	bool kick;
 	int ret;
 
 	request = lower_32_bits(svm->vmcb->control.exit_info_1);
@@ -3958,18 +3957,10 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 	target_svm = to_svm(target_vcpu);
 
-	/*
-	 * The target vCPU is valid, so the vCPU will be kicked unless the
-	 * request is for CREATE_ON_INIT.
-	 */
-	kick = true;
-
 	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
 
 	switch (request) {
 	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
-		kick = false;
-		fallthrough;
 	case SVM_VMGEXIT_AP_CREATE:
 		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
 			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
@@ -4014,7 +4005,11 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 	target_svm->sev_es.snp_ap_waiting_for_reset = true;
 
-	if (kick) {
+	/*
+	 * Unless Creation is deferred until INIT, signal the vCPU to update
+	 * its state.
+	 */
+	if (request != SVM_VMGEXIT_AP_CREATE_ON_INIT) {
 		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
 		kvm_vcpu_kick(target_vcpu);
 	}
-- 
2.48.1.601.g30ceb7b040-goog


