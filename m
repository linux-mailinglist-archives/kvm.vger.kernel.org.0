Return-Path: <kvm+bounces-32592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB1F9DAE73
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FE4C1670FA
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DBD2036F8;
	Wed, 27 Nov 2024 20:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/j3Sm2S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D372202F9B
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738797; cv=none; b=XOrpaCX6Th+8d7QsrLKfOUDfyeGDn1lkMaVsaJMKKwgaM4PDnTkDm/4pKEliDiQr3tQ6eX6gtPJ/j4joDau+yRlqsbOY8ia5vPXVoxAqrnzbMZQGdssu9bn5qNd2Nhb975KuRo2/gCe9EfZPd0624dc0IyFRl1VNvVAMajrBa7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738797; c=relaxed/simple;
	bh=0Sb4Q+0n13lKQuICURh4UVrldcFpp4dmMu8bBqYa5Z4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lGWtLMdObl4C+4aDX3IXnA5+ICx1NiqRASjlzybUWn2YKLR5fJXhi58x/eSlRKDiaTGWXi3GGZTCrGSlfLjZRg4vwhytbxkIZSBYGKwhm9YFvyfvcQT51TGMHhI9kLmPSrqsBzCYcG17AsFHln4srfUUKzSS9D5xAFrr+vMMgGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/j3Sm2S; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fc4206332bso65583a12.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738796; x=1733343596; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SEFFHShPWvrfysOCPzjkFHhU3REAM0/B502rfsrxTK4=;
        b=I/j3Sm2S/l2SJn6JNgGr4uD8cbZv/T7jj8fDTlAaNTyxjiiYbGJLAZ1CerVgfokmAK
         e/zpV+3bpnPRWaFnslZuWL+N3kbru3qKxWdfiIh2lDjOiWHo+kK59EI8p51m2hkDXqC2
         02PX+915Tf6BKumeQtIInp1cELb7rbvCaSfuzxHrLpDCrvH14/ZPrniXcPKVuD/3O37F
         QwF+67wXgCIziQpUu8fieTyHEyXDQu0WsQxRrNcPvep7hb1NJ5lImTzsfXFGlEO1B5yE
         xuZrciJUiEre9Tf9UaoBzqSvwOhJ87xbVeC1db3tsdJgrAS1hUi9bHcTNQVzRNQevAGa
         bWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738796; x=1733343596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SEFFHShPWvrfysOCPzjkFHhU3REAM0/B502rfsrxTK4=;
        b=Ww9h7smC4SEdiGB3jqBr7H9GIIshObvnPAUCE6U2d67YxE0Xss8YRwzHk4Dq9F3V/2
         ePcWgwxJk3GKT5ZVQ8buhvKknTgbij5V5+XT71Guc75x/1rCoE7regqNX0YzNGa4KlTS
         G08I+TB7AfHzuFEYrZJ4wvEAEiN1WuKjuN7if1bD/4c3ucjr9CjcbRsxCly1o/fSsmXX
         Im8/KmPfCoI90ip2lq+tnOIdKME3Vh2d01SuTUoowqLKx2JULH0ut2UWqxpdtjoNz/bH
         whX/U5X4InOLe7vqzmAf1/77Fs/qtS4ezzJJWYvMiLwGrBAytL7NZmyM1/l4jg5CniDf
         qdQw==
X-Gm-Message-State: AOJu0YzUUwbcmnsRpWIpgzgklEJV8hQ9iSpMfGtVxY7KDDewwzibd//c
	lOGtdHvtpaQEgikdRIqNU/VX6beti4psJbM1/7PEbC/GyxGzpL4ejN3eKT5ffeftpPZIlmuPc27
	XBPg31iwKi5GGgabjiGFeI+Tg74QaHGjolh7gexBarrkmfrDikf3zQfsQ33oO8yJP8YCMna2+p8
	B5M1X8YHV1/48iK+/4eYOw5c40GTzIX/X+1nS+ycFswdulPJb1yA==
X-Google-Smtp-Source: AGHT+IFDnJrNl2EwKhUTk9mpKqbvcRkEfQGkw2j40sPx4IsQJwryXEWkoVafi8xo4q2JWSCxTCJdnQ/xIXLI1Siy
X-Received: from pgbdl1.prod.google.com ([2002:a05:6a02:d01:b0:7fb:d719:ed47])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2451:b0:1dc:bdbd:9017 with SMTP id adf61e73a8af0-1e0e0b6c85amr7559366637.40.1732738795671;
 Wed, 27 Nov 2024 12:19:55 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:20 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-7-aaronlewis@google.com>
Subject: [PATCH 06/15] KVM: SVM: Disable intercepts for all direct access MSRs
 on MSR filter changes
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Anish Ghulati <aghulati@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Anish Ghulati <aghulati@google.com>

For all direct access MSRs, disable the MSR interception explicitly.
svm_disable_intercept_for_msr() checks the new MSR filter and ensures that
KVM enables interception if userspace wants to filter the MSR.

This change is similar to the VMX change:
  d895f28ed6da ("KVM: VMX: Skip filter updates for MSRs that KVM is already intercepting")

Adopting in SVM to align the implementations.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b982729ef7638..37b8683849ed2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1025,17 +1025,21 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	u32 i;
 
 	/*
-	 * Set intercept permissions for all direct access MSRs again. They
-	 * will automatically get filtered through the MSR filter, so we are
-	 * back in sync after this.
+	 * Redo intercept permissions for MSRs that KVM is passing through to
+	 * the guest.  Disabling interception will check the new MSR filter and
+	 * ensure that KVM enables interception if usersepace wants to filter
+	 * the MSR.  MSRs that KVM is already intercepting don't need to be
+	 * refreshed since KVM is going to intercept them regardless of what
+	 * userspace wants.
 	 */
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		u32 msr = direct_access_msrs[i].index;
-		u32 read = !test_bit(i, svm->shadow_msr_intercept.read);
-		u32 write = !test_bit(i, svm->shadow_msr_intercept.write);
 
-		/* FIXME: Align the polarity of the bitmaps and params. */
-		set_msr_interception_bitmap(vcpu, svm->msrpm, msr, read, write);
+		if (!test_bit(i, svm->shadow_msr_intercept.read))
+			svm_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
+
+		if (!test_bit(i, svm->shadow_msr_intercept.write))
+			svm_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
 	}
 }
 
-- 
2.47.0.338.g60cca15819-goog


