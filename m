Return-Path: <kvm+bounces-63058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8BFC5A4BC
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C7423A7F2B
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D126F21D5AA;
	Thu, 13 Nov 2025 22:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HN+V9lHG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A69B325483
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072208; cv=none; b=U+6WBDXvu6HjzQFjgEWaINI9j372uNL1DWcyQP+7FdZ4Ptn8qeJ8B9/HuhEhezv4nrokWp3ZlpWAIX/BZbtggxitWs1tBBRYJCBTqSfiOHTqTC1h9YbOYn5hHumVQGYjlCJm8ewjZs+DvjHngtarrHLHb9CeXidYEl8gTBsri5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072208; c=relaxed/simple;
	bh=2kopUC4g9/xhmTC6tdsbn2Hz2t/yvA1KL42sg9IjKrk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aw564opIanY365tnZrtRv+CPIEvU8Dz1AFpIbpT9hFzGSlG2Y63YFVrocZFPOwkjBHGTzDJ/oMQpZ+qDBzsVKH3gH8bX1EjtLrv+CZsSnEQmnPtrvIVUvEtbQCLNvh3SuNTnj28DznoFfdud2cKmXGB1udjU4CO68wSKxuHMoSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HN+V9lHG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3416dc5752aso3645292a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763072207; x=1763677007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uLGpD5u1+xNmrNIiKbq+lQKqzP4N6LiuHe2X/eWaHM8=;
        b=HN+V9lHGD1HLqFboRq0oX6SBPUBNwVwcuhk5+3Qici9Tc1xr+y98xyfGRyfeSsBeVC
         aMBL9bIRrY9TQx/wg9fr/XzUlalzYliEqg5H2ToVeDmX3TKGgRKIbK+iBc9OzpHivR/Z
         77a8HihsvQnjSu2RJKnBLdeqOw1/u6vSOYmoHkemcQz6EnFa6X+YiaeSOIt6tuKAZhXL
         cvKXlBsNJjkpxeXlg0QIKBNVa8zSYD5PZAu5GzcRsf2eAGt7j7fIFaSDfd0L8hZ8RUqo
         iYesq3lpDSzGYvEsoKxf/M6FGnQPAonBL6XmN2l5fSeB9s3oap8tBpKM+qJM9PbfoqT9
         00Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763072207; x=1763677007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uLGpD5u1+xNmrNIiKbq+lQKqzP4N6LiuHe2X/eWaHM8=;
        b=sR5Z8Ng07usAM/xeE0/5Il9PxmAljQe/JO4zXnuYC8GmkUZfsTYCBgwgIsgYC1T0Sb
         BCxwsF+O5y+0LGBjwOyNPJxXCO2aj4XBWhMFE5vPJA9FqnZiuGKnSUeNOeDEFLXon8Wo
         s09GSA73s15o9KgPhNeqdz7OLZvT6GRqxcSSAM2ru5iH0tmZCpZqitd2SPqkBHbVrS/q
         qqWfihPxb38HCc+sCHhogl0iHGdGUCq6eFljYxao8wmtCiw7aJVp6aRc4IKW+Yh3MR5x
         hIFerhkzS2phveZAaxbyZWpmXtNpqqANJ3btvxI4m9Qds+I5qyJ7RKTnbXDn5JrfRzOI
         wwVA==
X-Gm-Message-State: AOJu0YycDkAoR0iQ8TdnXDItkiJDaFlmyz4ykrN2x/Z+/Dr6wAsg/BpW
	AkF3kivQ4B7MANmeO0q42R2TnDjBPm+0ebxyLx0tT2LXrwtWlnxCIIJ6yZN1OMTAeJ4CnvY2jgY
	czvlgog==
X-Google-Smtp-Source: AGHT+IFcrWlYKwQtODUYyVSrZZl8AzPGS9xCGKenvs4ErgLoUW3lBmBduiKScfbuEVOMp6q0ZtzrEWY6quI=
X-Received: from pjbeu11.prod.google.com ([2002:a17:90a:f94b:b0:338:3e6b:b835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:564f:b0:340:f422:fc76
 with SMTP id 98e67ed59e1d1-343f99abe95mr900158a91.0.1763072206760; Thu, 13
 Nov 2025 14:16:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:16:41 -0800
In-Reply-To: <20251113221642.1673023-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113221642.1673023-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113221642.1673023-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Rename "fault_address" to "gpa" in npf_interception()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rename "fault_address" to "gpa" in KVM's #NPF handler and track it as a
gpa_t to more precisely document what type of address is being captured,
and because "gpa" is much more succinct.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc42bcdbb520..1fd097e8240e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1857,8 +1857,8 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int rc;
 
-	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
+	gpa_t gpa = svm->vmcb->control.exit_info_2;
 
 	/*
 	 * WARN if hardware generates a fault with an error code that collides
@@ -1872,14 +1872,14 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
 		error_code |= PFERR_PRIVATE_ACCESS;
 
-	trace_kvm_page_fault(vcpu, fault_address, error_code);
-	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
+	trace_kvm_page_fault(vcpu, gpa, error_code);
+	rc = kvm_mmu_page_fault(vcpu, gpa, error_code,
 				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 				svm->vmcb->control.insn_bytes : NULL,
 				svm->vmcb->control.insn_len);
 
 	if (rc > 0 && error_code & PFERR_GUEST_RMP_MASK)
-		sev_handle_rmp_fault(vcpu, fault_address, error_code);
+		sev_handle_rmp_fault(vcpu, gpa, error_code);
 
 	return rc;
 }
-- 
2.52.0.rc1.455.g30608eb744-goog


