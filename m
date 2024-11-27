Return-Path: <kvm+bounces-32589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBC09DAE70
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 546AA167083
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B194D202F68;
	Wed, 27 Nov 2024 20:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YrcV9T3c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84525202F9D
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738790; cv=none; b=Z+PCdSAOE8Zb7Q7JLYzmgrmgCmEacuCv8s2nOXiABv5I4AryhlXNrP3ZU3TRjI8RS0QHPrqwWJCwVda+novTALjLKtZ5ksA/e4v9dfL+zE7V9Kwqkwo1Wy67K111umJ+l11atHO4zkdLXn83E+QZtkBVAdiSN3NK0sTfY9TP1vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738790; c=relaxed/simple;
	bh=ogEn1dElzIfJG/QJnYufTDh0/Vncmiw+z9V1eqe1mbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D36MaR9+E2Lz8bDTBT62SmRbz9kKGkxS+wpLzfx30XY5yHw8YqC97cYD0eT+L/apzEps6S/Oa71WE+CvUqW0Ayz8zO7siHBHCSDX8R6x8nWfbzESa7MPZHoRB5MgS+7HhqEWkTT/m0Boz+9oNzzQORXVxp3MWt5HdAev7RYXOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YrcV9T3c; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea50564395so1019646a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738789; x=1733343589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZmPbbGo+TCggACq8xeI+04Q4CHspffd8paLkrS4Ah0=;
        b=YrcV9T3ctuIe96S8/IzjdD204ZDZYKnzjMhIaMPWrpIH86iSzHs5AfCsoESjQBfPY6
         LiDN0q3w+LYoYAa4QOfKwRiUAsw40QhOGMFlvRd2eNtV4NjosFmRmAQFewz0t7piS56l
         LzQxJcdp7ZBUIv3gjgIDOGWWr844MKv6Hdjs5vdcR7zbnd5pClZbRUIULwqYPzdK+mnd
         yU48AE6rVpxayUbXgcHjGYqA3Toi8QKzu3UGcG/lbj7iTG1P7Qq2ddrjpqIRPB/9WfV7
         VozzCQCIJGUOwo8b5DvUMsUsaCbLHCwjq5gYy85/I6xAAJNQSEb6YKG9jVtzWY6bHX0Y
         NFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738789; x=1733343589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZmPbbGo+TCggACq8xeI+04Q4CHspffd8paLkrS4Ah0=;
        b=AxP/Zk4vFeQ4vm2FFU4xBsJrH7o9wALIDHxHeqIo/5SCiGmK0C9zPRD+EW32+g2bTf
         0evh2nX5dw0K+UcbRqispzdXhptWQa5mLewW0sSFJXgLf5AndSuPnWLTBX2gvBSGYNFF
         5mCGgjhhMVQoDRxu+8DAKrE+gLDWbUm3hTDQtWAdKXBUGlPQKo+OgQiQnnqqWV1UiJuJ
         A/YOqgOAQowXV3Bc2nl+jQVSEjfr0Pu19VNlMxR/jsrkkpOiHk+y23tOyRZ1zCMvGPTc
         5QH+G0bT4+XdvqC4hWsHHHT9I8sLmkyIzRkp0dHKx5T84R7qI9WqHjZqK4sHDMTXJech
         Ykbg==
X-Gm-Message-State: AOJu0YyzbN5ywje/FwFQo5KrzkBoZjhml81BhigGV+dqx5/UMzv3grC1
	iMiYmS/PiSBiHr0vU4v5JBAlKLnTWPQx3gwvhAtCSPd7G+g4+SJV8Jwq6nz3SNXB3NtP5LpIht8
	ufFB2gYMfEz+bPOmQGG0ynClGr/PAe06P7ugSGrdRZ0raal5mpC+fg8pbQMlZbT/GxUoSHUm6GT
	hBFQ3CthBYScRiFHMJasB73aXes5+c3lljJhaa78WzAczJtUGYnA==
X-Google-Smtp-Source: AGHT+IEIt5jiq1ueJDDA2kC+ZAzGm6+CvzMikEFnLqs2uy/7I7ZXXWhEg7DQ6yfJwipo0F8Yw4robE20WftzHgL7
X-Received: from pjtd11.prod.google.com ([2002:a17:90b:4b:b0:2ea:5613:4d5d])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4f85:b0:2ea:8aac:6ac1 with SMTP id 98e67ed59e1d1-2ee25b06600mr958860a91.15.1732738788647;
 Wed, 27 Nov 2024 12:19:48 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:17 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-4-aaronlewis@google.com>
Subject: [PATCH 03/15] KVM: SVM: Invert the polarity of the "shadow" MSR
 interception bitmaps
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Note, a "FIXME" tag was added to svm_msr_filter_changed().  This will
be addressed later in the series after the VMX style MSR intercepts
are added to SVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm/svm.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7433dd2a32925..f534cdbba0585 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -781,14 +781,14 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
 
 	/* Set the shadow bitmaps to the desired intercept states */
 	if (read)
-		__set_bit(slot, svm->shadow_msr_intercept.read);
-	else
 		__clear_bit(slot, svm->shadow_msr_intercept.read);
+	else
+		__set_bit(slot, svm->shadow_msr_intercept.read);
 
 	if (write)
-		__set_bit(slot, svm->shadow_msr_intercept.write);
-	else
 		__clear_bit(slot, svm->shadow_msr_intercept.write);
+	else
+		__set_bit(slot, svm->shadow_msr_intercept.write);
 }
 
 static bool valid_msr_intercept(u32 index)
@@ -934,9 +934,10 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	 */
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		u32 msr = direct_access_msrs[i].index;
-		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
-		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
+		u32 read = !test_bit(i, svm->shadow_msr_intercept.read);
+		u32 write = !test_bit(i, svm->shadow_msr_intercept.write);
 
+		/* FIXME: Align the polarity of the bitmaps and params. */
 		set_msr_interception_bitmap(vcpu, svm->msrpm, msr, read, write);
 	}
 }
@@ -1453,6 +1454,10 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
+	/* All MSRs start out in the "intercepted" state. */
+	bitmap_fill(svm->shadow_msr_intercept.read, MAX_DIRECT_ACCESS_MSRS);
+	bitmap_fill(svm->shadow_msr_intercept.write, MAX_DIRECT_ACCESS_MSRS);
+
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
-- 
2.47.0.338.g60cca15819-goog


