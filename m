Return-Path: <kvm+bounces-63081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B99CC5A825
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DA02F4E9597
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDC332860B;
	Thu, 13 Nov 2025 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JUHQ2zpP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA532694A
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075668; cv=none; b=nGyrnZSE2R0T8X9Q/TGt3tTDHMNtu6CPgPq93w2tA7jszMJgvd/yaurtOSxmUxGHORZtA/QEJVSkjnoHUEJo6N9avp5+u3toHQDcbeOp/hTsXxNRejZ8o8BaArLpb2G1zEiavyJOuE7tl6JZoXKD7j6U9i8hcWNFCrCSBU4VNn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075668; c=relaxed/simple;
	bh=JR4i55EnnwraNLvBXNuXt3Al4l9/hHQFLfZmXRr4mAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YbMPftSYH6UFhr+aumfRH3ciZY/7akIGI8+QB32wX9zULUEZobGR9n2SEBmU2PsbT3mikf3R8NBUIdFzgmY5801Qwl3PXHtQEC2c+Ikt5xxzX0iXEmwDzMMH4iHcV/9YyLvgzhW96aMPKb06aEkjVAgHsDLNdjGaFoT8fs2XjeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JUHQ2zpP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297d50cd8c4so39382565ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763075666; x=1763680466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6K4XIzmbFVcYaCmdHrcIwA8jDGId4vqxczM/Pzema7s=;
        b=JUHQ2zpP9NuhT0pskUkThRuPgvq0wttnR+WBrXnpk3nezLvGPDcdufgYEMG6dV6f/T
         F9AeB3CZLmCbAkO0vH9yoPhl++w4/RbgyHxKnGAz7EcXxVa++Vy79jt/tnnxof8DECEA
         PkQ8852FpssR5B0A2vF9zfPDq4y0VqY29DxDGdT8udoc8hJRfojjii5BMdUu8EOf3wat
         9riHDiz01BcgOccK9/yX/3duAPkepn8c/c5dpeg+yHbbv2pFbWNqUACScgaICxqkXPp0
         P2vw3e0HraPGKVWwo3s5qKsQllb1WXZqYeAjDdoo0O9VwAKoGNCKNSw1LI9wohrgZc73
         qjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763075666; x=1763680466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6K4XIzmbFVcYaCmdHrcIwA8jDGId4vqxczM/Pzema7s=;
        b=T0T8C3cVl5sdwDGTuL6XHkqtE1Xfoph4a/dzoOxb4IAmEKd1ioW6OCeo1KZYnyP4Fx
         Vu9v+AD7fcB46ZdbHX0jwhQTKXxDe9D/wtJOPR65nYp3uy5BTxWvjaiHAojdgDm1zgT/
         /eCsW9zZcOMUrgYAck5UzXGkbzFCHRkW/U+ZN+SuU1YHwyKFDv9c/v7PbcMaMdfLfaud
         Qn6/Q5TmpSPDlwbshhXO+J5ag4NkDVc2M4Fq3X/T/L51paCXCKJdGpN59dyiR5XF33Fj
         Zar/l9sn+7sSO+AuYno44bB97XM5NzduNrTKntVd9rL/d+rPbrcpFOUWWl5CbFqxS6Kc
         6JmA==
X-Gm-Message-State: AOJu0YwVwhArw707pJxCQqlRpcQMr6dR21zbYOP3x0b32u1905PalS7w
	iX97mjZFkamH5XlM95l9jLMUsc/ZXHUBmrTNoydwGbjg1fHshJ4yShKItUoYWaeY26LS+kx0m+E
	pnsxwLw==
X-Google-Smtp-Source: AGHT+IFAK+eKvSrfTNmaiAxotef2w19Cda5fxb9lmk5FZGG6GVNdwG91t7Ninl+LU2MbQ4i0F9ARclXTR0A=
X-Received: from plbkn8.prod.google.com ([2002:a17:903:788:b0:290:95df:d050])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:7c7:b0:298:616a:bae9
 with SMTP id d9443c01a7336-2986a73af36mr5556575ad.28.1763075666276; Thu, 13
 Nov 2025 15:14:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:14:17 -0800
In-Reply-To: <20251113231420.1695919-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113231420.1695919-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113231420.1695919-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: SVM: Skip OSVW MSR reads if KVM is treating all
 errata as present
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Don't bother reading the OSVW MSRs if osvw_len is already zero, i.e. if
KVM is already treating all errata as present, in which case the positive
path of the if-statement is one giant nop.

Opportunistically update the comment to more thoroughly explain how the
MSRs work and why the code does what it does.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5612e46e481c..0101da1a3c26 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -539,15 +539,25 @@ static int svm_enable_virtualization_cpu(void)
 
 
 	/*
-	 * Get OSVW bits.
+	 * Get OS-Visible Workarounds (OSVW) bits.
 	 *
 	 * Note that it is possible to have a system with mixed processor
 	 * revisions and therefore different OSVW bits. If bits are not the same
 	 * on different processors then choose the worst case (i.e. if erratum
 	 * is present on one processor and not on another then assume that the
 	 * erratum is present everywhere).
+	 *
+	 * Note #2!  The OSVW MSRs are used to communciate that an erratum is
+	 * NOT present!  Software must assume erratum as present if its bit is
+	 * set in OSVW_STATUS *or* the bit number exceeds OSVW_ID_LENGTH.  If
+	 * either RDMSR fails, simply zero out the length to treat all errata
+	 * as being present.  Similarly, use the *minimum* length across all
+	 * CPUs, not the maximum length.
+	 *
+	 * If the length is zero, then is KVM already treating all errata as
+	 * being present and there's nothing left to do.
 	 */
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
+	if (osvw_len && cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
 		u64 len, status = 0;
 		int err;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


