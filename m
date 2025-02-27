Return-Path: <kvm+bounces-39466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A91ABA4715B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7E0A3B78FC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDC322DF8E;
	Thu, 27 Feb 2025 01:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1y5yYQbJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4501CDFCC
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619557; cv=none; b=twNGsODgofmpr6VgM+QjwQYBJirj6SCahzTDiSLHiTB1pToF1xdup//Z/rGpZDVafc23Ee6YwIKSjg3B+w79eusuJijSp6LG4+e8YtXKF0GzOryG1FdA77Hl1sufdla12BleoT3rdblDFKVpQH4uXpPBR8EQjQ5RIGUSXCVTTJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619557; c=relaxed/simple;
	bh=ihlJ9tzG+mbom6E97CofCJ2twZFC8ydoAcNMa4ieq/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=abIY4/97pBztDFqtum86EIa2ypF1oqJl/wtntQRVTWjprge7/bJhmHZUI/6xSjPXMbjC/PTG91AAE+anKI14gzcsTRJBRS59icjJPLst02wBB8gUlx1Zr7U4gy5R3eXgNaxx74o11I5jCxwrJl8e1QsyoVfZzEWmjLI/C1fgoMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1y5yYQbJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8de1297eso925486a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619555; x=1741224355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BEh4czcyv0mwjR2KnuYAlHnHA3zyOkXJCuOnzE1/d90=;
        b=1y5yYQbJIZe7LrJamcdgKbiKDM1gPax2kmBZlGbVuISqYPUr5DzcJmczf/VOsqMyXw
         n9QpFnxmkNF0Of3cxcFb0HU3BsLjmLDtPU/f28oqXLHYiQqiA5TuLx9gu8QxWblXNlEm
         QZSTAIv7bgc+n/Dwj7JtTmPV205sNYqGFOechCs1o/VU1IUFb0VBFogmfHGehx64n/QO
         OkgV5ot0orbQ6rylpCwLHshubY5j557zgamF/iaFGlSkWVKq3uq0EKhjROU3lT+YYBnA
         /oWlEwsxvDiTgDvn8EvubnbDYwHfvK49layanvqeRslra155l4y1Rob6kgyhuuI4nYO0
         Rwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619555; x=1741224355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BEh4czcyv0mwjR2KnuYAlHnHA3zyOkXJCuOnzE1/d90=;
        b=WbIulFX4S0Oj3tu2PjaMKEOD7iEgMogBMn8PZ72IsPLSN5gFHtBXLsctJOpoehWbET
         Jvj6Inn68JTrffg3A6dKrLgcc46bD7FsAd5WW+rPtd2ZbFJ3iFC/i6/NGr4Xs/oseQU/
         kf/TY/GslkwUFr1k2tXAgcMvEcBqGCqPSd3QlTQJHEb0m8pCLLHl6rlLq/jckDfe1fRX
         JktjPcWt5k7k/3FHPP7NiKEoTqH/EwPlQMDD6HlPzFI8SQPYPEcvDRYVveasafqaXgoS
         fwk01fAy843rx60GhVZRDg2u4XKku5iVQRaIyTDnDJleioP4p39ERc5fz3uNnQhMTEH1
         TUCA==
X-Gm-Message-State: AOJu0YwJ1o3pPXzjOPJnINlRTp1T15tZlc9q7PQf17mf+rAcmEjVj2u7
	PPocyDnpCcPMtjk7MpgTRzC08AdB7qZcak16xVCpg+DxuY8M5MtF5Z1gyUjsSepLFxWizjlzbTB
	/ZA==
X-Google-Smtp-Source: AGHT+IExjvD2wlKO1qXHAmeJHBp9Socb/v6Efvhq9YmZiRdyzuZ7b7PT/K+5yF4GkgpWs3T5dFKOYmAE6Qs=
X-Received: from pjbtd3.prod.google.com ([2002:a17:90b:5443:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d2:b0:2f6:e47c:1750
 with SMTP id 98e67ed59e1d1-2fea12f2a2amr2349083a91.13.1740619555492; Wed, 26
 Feb 2025 17:25:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:38 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-8-seanjc@google.com>
Subject: [PATCH v2 07/10] KVM: SVM: Use guard(mutex) to simplify SNP AP
 Creation error handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Use guard(mutex) in sev_snp_ap_creation() and modify the error paths to
return directly instead of jumping to a common exit point.

No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ccac840ee7be..dd9511a2254b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3938,7 +3938,6 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	struct vcpu_svm *target_svm;
 	unsigned int request;
 	unsigned int apic_id;
-	int ret;
 
 	request = lower_32_bits(svm->vmcb->control.exit_info_1);
 	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
@@ -3951,11 +3950,9 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 		return -EINVAL;
 	}
 
-	ret = 0;
-
 	target_svm = to_svm(target_vcpu);
 
-	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
+	guard(mutex)(&target_svm->sev_es.snp_vmsa_mutex);
 
 	switch (request) {
 	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
@@ -3963,15 +3960,13 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
 			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
 				    vcpu->arch.regs[VCPU_REGS_RAX], sev->vmsa_features);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
 			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
 				    svm->vmcb->control.exit_info_2);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		/*
@@ -3985,8 +3980,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 			vcpu_unimpl(vcpu,
 				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
 				    svm->vmcb->control.exit_info_2);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
@@ -3997,8 +3991,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	default:
 		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
 			    request);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	target_svm->sev_es.snp_ap_waiting_for_reset = true;
@@ -4012,10 +4005,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 		kvm_vcpu_kick(target_vcpu);
 	}
 
-out:
-	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
-
-	return ret;
+	return 0;
 }
 
 static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
-- 
2.48.1.711.g2feabab25a-goog


