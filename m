Return-Path: <kvm+bounces-60217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E161ABE52BF
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 21:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 553404F50E4
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E287524469E;
	Thu, 16 Oct 2025 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="An1dDrui"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3698233155
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760641610; cv=none; b=gtuWgLNrpx2ykFP0iEUDzEZe30L3913NqOCQBKB+n4gdn6JVYnr2A7y6PDUzwupCRdkAfqEMFqybnNNPj2vXh9Al8NpNB4KiMt+HvmW8PAkNX0VkBl/VvLGlo0ZV+3O3fTACw5JE+3gOmOinzHBTZ2XcUcNMc+tq1gfIeRDjX/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760641610; c=relaxed/simple;
	bh=1NNZtBX4vGx4VJF0uIvn2QpszEkMNfAVIYtn426uZyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IKLdAIukxQHIMSKC6UZrxMKKKoemPHMXCsqcwdhRfikBZ/4EdJ3e9b7U/4t/gk19tTWjQz8Itdko9MoBvM+gKYR+jRg9o/yqKw/r5jTgO+w0Q+tKbN0UiKRePtzgZXpsywZqLLWkmQBWv8Haja1VMrbwr0zEoD7k6LuXLya8acw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=An1dDrui; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so1147281a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 12:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760641608; x=1761246408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2FBI/jTyFqvWpPCAAjt8bixaueCeUGyDdzttb57ymdc=;
        b=An1dDruiPvAI7UqMWxt8oiTmNQYuVOHBZJmjfc+OsYokpW2yHR5FKlxR7qzVuCX5+g
         ePOAyWxdbWYC8eTjldHaEILTFypPA7/GODBkfnw3iqCACk/z0vMWAZl2m/AaCKUAkcTA
         YZouFM+b7PPg9mvpSV2AX9ksOvXv0ARyMzPpyeXS58an47FCqbyKHzDQmhq4IO9Ni3Gr
         l81ayHXZPwJpIESNHW19hMzuCkXWbiyAKC8pjfmXIVm602x9vH3gKPPp9oeIQZAFIBTa
         UHxV2jqeH/Np6wSix4QAckqbqH5GgfURzhUJZn37vn8uQaFiVwwkiC7qveyv6RE/hoE3
         dzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760641608; x=1761246408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2FBI/jTyFqvWpPCAAjt8bixaueCeUGyDdzttb57ymdc=;
        b=n6iRJuffuAGlQDDc1yT+ymwumwHhzUZfSRPr10edHeotQQRhoiY2ixSnEHt54DY2Fd
         7yyilJbMsZhj4GUJ4TvTfz58Yxk4P0AAupQ46ipbDUqXq4uSVbfVkNVwjmt6a8OBR6zV
         N94gxKk15XfNLib89tvt8pNgb+ZsC91CDFpUbYPr325cVpoFVDjnqN+uwZ0Bf8rm1wxv
         Mqok/Z49K4z5W3CHfn+wFLzo/AE31+cY3cNalUIczm5JTVmGeSnXnDnimsaQFnSAKDDe
         VdTZam84AhSrQUyAJxAvdpnNR1yPKXjrT9umF+PP0Vo8qq/2fvaG5d9h2oWpA0p2CsAY
         gJSg==
X-Gm-Message-State: AOJu0YwK2VMk/RDg0y1HDJg/DXccf0AhEahq8LAENs80D3IrD9OKgcke
	tqLE8G4BV9GwXMwviVBBRhBlpZEGG5OawHSNqCJPOyanXHufy2KGUN1+5LGcGNc6SGUVOfqukq4
	6ifkqrA==
X-Google-Smtp-Source: AGHT+IFPCh5QHnR3s6IwP9yRM/hM8XSFNywPo88lmC/FPgqIdiJoBh5t3elf7i7+ZJStDHte/+8onCn6Xwc=
X-Received: from pjqc13.prod.google.com ([2002:a17:90a:a60d:b0:33b:ba24:b204])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b4b:b0:330:7a32:3290
 with SMTP id 98e67ed59e1d1-33bcf939e7bmr931582a91.37.1760641607748; Thu, 16
 Oct 2025 12:06:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 12:06:41 -0700
In-Reply-To: <20251016190643.80529-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016190643.80529-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016190643.80529-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: SVM: Initialize per-CPU svm_data at the end of
 hardware setup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Setup the per-CPU SVM data structures at the very end of hardware setup so
that svm_hardware_unsetup() can be used in svm_hardware_setup() to unwind
AVIC setup (for the GALog notifier).  Alternatively, the error path could
do an explicit, manual unwind, e.g. by adding a helper to free the per-CPU
structures.  But the per-CPU allocations have no interactions or
dependencies, i.e. can comfortably live at the end, and so converting to
a manual unwind would introduce churn and code without providing any
immediate advantage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..efc3a7adebef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5386,12 +5386,6 @@ static __init int svm_hardware_setup(void)
 
 	svm_hv_hardware_setup();
 
-	for_each_possible_cpu(cpu) {
-		r = svm_cpu_init(cpu);
-		if (r)
-			goto err;
-	}
-
 	enable_apicv = avic_hardware_setup();
 	if (!enable_apicv) {
 		enable_ipiv = false;
@@ -5435,6 +5429,13 @@ static __init int svm_hardware_setup(void)
 	svm_set_cpu_caps();
 
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_CD_NW_CLEARED;
+
+	for_each_possible_cpu(cpu) {
+		r = svm_cpu_init(cpu);
+		if (r)
+			goto err;
+	}
+
 	return 0;
 
 err:
-- 
2.51.0.858.gf9c4a03a3a-goog


