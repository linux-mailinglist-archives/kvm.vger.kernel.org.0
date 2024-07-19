Return-Path: <kvm+bounces-21984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B996D937E25
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75D48281EF4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE6A149C40;
	Fri, 19 Jul 2024 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dEK8ZuAl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9F214884F
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433073; cv=none; b=dEm9Uad+OaWaouS7D3N6Y8d73Z/QgUZcadb73SBJazxOyHfPixsEbtSTktWudssSBHwE0LUY2EDaK2qYXvjE+Ig/L1CdvBh/fogsejXPYNzsNFApkawB2XrZhYysGBhBZ7ZYhOnhVxk2CCInXgEBeiydT+7I52+2AjXOwI2VEZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433073; c=relaxed/simple;
	bh=9VC1o23EyPnmCsIUXN13mbYo4nMy/PcXMeGVi57HKHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fc8YA56kHa49YMeILNZl4raDGDRx2I/3U/vUjvIs1nuFQ/FmUe7isqKGMSgmeEnzO6YZ9OgswQ99lqdNQuXyYiCJxQywbDvqKOoHE3PuLzUOSSrcr4WmF0nHXzdji+fQgFNfpq0dTkTT2KCabIdRUXXEAdER8PTC+Oo4o5kf2bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dEK8ZuAl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70b09eb46e4so1170355b3a.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433071; x=1722037871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7GRI70QT0vlqusEkjG3FXqYLsYvXxnP78B7joN4qu0=;
        b=dEK8ZuAldsDEx2w1w+2j1cDUt0l/POihaDi5wQ0aD7+qbKYHvnyKAMX+/pVkgCVUHl
         mZvtohjQ72zq7kRuEkiq24Ay8xps3o5wgUpD94PPGlILSRh/2GIcHDG5ju0PvVCpWqF+
         oMCR0xW/s0v22yLCxycYwOSICrae0C1eNpEjlmH/ltmgX41GKnY1d5csVk0xNSBnn1ZZ
         WD7jMoSPrN/zA50JolEwvym5Su5YhLm0GoQVq6BDBGZTk3DrMVIomfHZkMg5fHDFI8rD
         AN61pF+JFdFWdI48VE0g/NaPukVM8DbL9FEqqRLlgwLK2LiHIkFpMFze5Ib2S7NS7MY/
         XoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433071; x=1722037871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7GRI70QT0vlqusEkjG3FXqYLsYvXxnP78B7joN4qu0=;
        b=OdbkOYn5FVeW103+itG9ly0y3TfWfWoYJtDlpyruRT420GSsRE0s5pETCwQ+bITsZ/
         wvSe8S4eZZqTdJKeApnv1Z2mwZ/a7w8bfOLFv54tJZV1UyP5JIFpfksQnlyOBS880xaO
         yquUiMurwbWZ0ot3qH2lKkQi/LbR2fTok/2MoUh4GTI1kLozueksQ/fmv7o6c2VJc+qD
         fxRVQvdA3RFkx8qw6QCovk3d7U0DI3nc/PCPDNW71StM8ncpr5eev2/PxiLpK4JO57Xc
         R8L7tJlJOtFjrPF2wus7g3r4AlH1PE64txnA9ud1SfviO/HYWx6v3hTYP3zBVAhu97AG
         d6jQ==
X-Gm-Message-State: AOJu0YxjsCxVArb67leFhTZSSQicti8yxWg6q4s4d0e65J0eC0rEIMqn
	94/UbVzSkLXqDGrNkTJGWGsQePTEJ8dFu+tQ06yYb9VapEGtptVzaZ9l5Z12KiBto6e0Tx6Jm95
	C7A==
X-Google-Smtp-Source: AGHT+IGzaPvQY/Gvr64S0cERzYi+DWtBU+TZAqXIrmD6fzYYJUjCv+m+z7gk6KBNOoZyk0taViygByegSz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8e06:0:b0:706:5ca6:1c6b with SMTP id
 d2e1a72fcca58-70d08602774mr4333b3a.1.1721433070968; Fri, 19 Jul 2024 16:51:10
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:50:58 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-2-seanjc@google.com>
Subject: [PATCH v2 01/10] KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Inject a #GP on a WRMSR(ICR) that attempts to set any reserved bits that
are must-be-zero on both Intel and AMD, i.e. any reserved bits other than
the BUSY bit, which Intel ignores and basically says is undefined.

KVM's xapic_state_test selftest has been fudging the bug since commit
4b88b1a518b3 ("KVM: selftests: Enhance handling WRMSR ICR register in
x2APIC mode"), which essentially removed the testcase instead of fixing
the bug.

WARN if the nodecode path triggers a #GP, as the CPU is supposed to check
reserved bits for ICR when it's partially virtualized.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7172ba59ad2..35c4567567a2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2472,7 +2472,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	 * maybe-unecessary write, and both are in the noise anyways.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
-		kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR));
+		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
 	else
 		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
 }
@@ -3186,8 +3186,21 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 	return 0;
 }
 
+#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
+
 int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 {
+	if (data & X2APIC_ICR_RESERVED_BITS)
+		return 1;
+
+	/*
+	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
+	 * only AMD requires it to be zero, Intel essentially just ignores the
+	 * bit.  And if IPI virtualization (Intel) or x2AVIC (AMD) is enabled,
+	 * the CPU performs the reserved bits checks, i.e. the underlying CPU
+	 * behavior will "win".  Arbitrarily clear the BUSY bit, as there is no
+	 * sane way to provide consistent behavior with respect to hardware.
+	 */
 	data &= ~APIC_ICR_BUSY;
 
 	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
-- 
2.45.2.1089.g2a221341d9-goog


