Return-Path: <kvm+bounces-21993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D2B937E38
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 107461F23DEC
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06671494C8;
	Fri, 19 Jul 2024 23:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="znOsomye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740CB1487FF
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433091; cv=none; b=RmCiSCzc6UaCYaKf5wT/OqyQjjlaBrxmEH9EatlGCjXcjjUGnZYEdh40/aqmMPx3zNNNiI+zKLcSLDjBJHhOArBkyhH3BXrZK5bt6LpGQ8F178M+UExaP/Mcz9Aij0uLoEXOOdn5Tdzx7lq2+BrB5dK78aTg8Kml0nN5ot5GTJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433091; c=relaxed/simple;
	bh=LPH8q9W4fShc7MD86NNRowGmzhOW/kmQBwXTLxhGfcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QsG8TjsumNwFCNTKKKekpytcXVxVaXxxyIsSdkz7OdJuVMGRBSzUPdvqc1SEK4wiA7wJDgkeqvDS9UvEtkJBIyGkiH9IsSMwOrR1iZrr0XH3mrCkezVT5yZnwo9a7ZdAM6jVemXJ6XOF1KgPRsocL+jEPPl9FnTpxtknKYYFk6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=znOsomye; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb685d5987so2128948a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433089; x=1722037889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rEJGCMpMk3RIfu2QMQ4nUitiZAubqCnC3LYp6iaILlU=;
        b=znOsomyeF6udBTvEt251PI3t3XPmo5EOLU5WVaDq8p1zjZuAkAMAVZ8aKmr/dpbrnl
         nOy3m/I3SUfeZRX+0bDgC3RUvheiYJe1d2jp85ZZ9Gp+25rmqkAiD5sbBLAyoBTMd9hd
         SDoJSP56C/Emkq6BdKwsDb2xePyRq+BSP3bYXY1B9GgsmXzDSQhdfVxyz4nd2Dn+CtuO
         cUIlDIOgUb75OMkQ5Utxr7faP0eZ0EgkwLV13OG4Z3X5K4y7GmRnktkEaADMprFdfCbN
         mLpW3UsHSVme845xuKp6RoP4zI2NL6U+RQM0GA7WJuqNYVqPMMC2ZQlXc0fClqK4KwRk
         M4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433089; x=1722037889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rEJGCMpMk3RIfu2QMQ4nUitiZAubqCnC3LYp6iaILlU=;
        b=aCBVeVZ5HDMsHaPZA/wFeTyVC2tZAHvdixDAA9moKFHQKawIyl28A9TQEdyPg3F0Ot
         aZbIEzROr2sKKqFTNDcHBOz2Yw3VyyVuluELEt4b4onOt58IohsoTRKbJYNi5KkRCVnZ
         tMu4AEzlNYtvZQK5v3ZDVgvGthYOd+icnQAo9C7YCfC/YbMQvSMiBmHZbgP2eUfoWh+F
         s5VfEZG7gNhVikaJmmpRwh1wlcajM34eo7Ooq1hhqPfvEXYWw8UqsTh0ictkExLwY/aV
         DWeEXkAl+u/61K9TUPb8X3hFmNbu0313KLsUCjfTbYgpC5nBluyn2sum6GgA1bX7I+Aa
         Jvbw==
X-Gm-Message-State: AOJu0Yzl7H8cAZWK/QIfsRkPIHYl5o5pSm+WODH2IQRy4ENPQ9WMi9Ug
	AHD10lfm5VopvbYCO0E2XSK3RLL3hwhf74TcbKD8FgEmiXDrsqa6IDK2N9JnEPOEnzmouRgxaIh
	H7g==
X-Google-Smtp-Source: AGHT+IFNSTCJ4CN2s2b9vbf+ii17GENMZV/5sakKmq6+fG9OzPne60xcEuzETwhtYlL5iJJ6q//VK1rZGY4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7884:b0:2bd:f679:24ac with SMTP id
 98e67ed59e1d1-2cd15e5389dmr4232a91.0.1721433088762; Fri, 19 Jul 2024 16:51:28
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:51:07 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-11-seanjc@google.com>
Subject: [PATCH v2 10/10] KVM: selftests: Play nice with AMD's AVIC errata
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

When AVIC, and thus IPI virtualization on AMD, is enabled, the CPU will
virtualize ICR writes.  Unfortunately, the CPU doesn't do a very good job,
as it fails to clear the BUSY bit and also allows writing ICR2[23:0],
despite them being "RESERVED MBZ".  Account for the quirky behavior in
the xapic_state test to avoid failures in a configuration that likely has
no hope of ever being enabled in production.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xapic_state_test.c   | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index a940adf429ef..a72bdc4c5c52 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -13,6 +13,7 @@
 struct xapic_vcpu {
 	struct kvm_vcpu *vcpu;
 	bool is_x2apic;
+	bool has_xavic_errata;
 };
 
 static void xapic_guest_code(void)
@@ -79,12 +80,17 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
 	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
 	icr = (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
-	if (!x->is_x2apic)
-		val &= (-1u | (0xffull << (32 + 24)));
-	else if (val & X2APIC_RSVD_BITS_MASK)
+	if (!x->is_x2apic) {
+		if (!x->has_xavic_errata)
+			val &= (-1u | (0xffull << (32 + 24)));
+	} else if (val & X2APIC_RSVD_BITS_MASK) {
 		return;
+	}
 
-	TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
+	if (x->has_xavic_errata)
+		TEST_ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY);
+	else
+		TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 }
 
 static void __test_icr(struct xapic_vcpu *x, uint64_t val)
@@ -209,6 +215,15 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&x.vcpu, xapic_guest_code);
 	x.is_x2apic = false;
 
+	/*
+	 * AMD's AVIC implementation is buggy (fails to clear the ICR BUSY bit),
+	 * and also diverges from KVM with respect to ICR2[23:0] (KVM and Intel
+	 * drops writes, AMD does not).  Account for the errata when checking
+	 * that KVM reads back what was written.
+	 */
+	x.has_xavic_errata = host_cpu_is_amd &&
+			     get_kvm_amd_param_bool("avic");
+
 	vcpu_clear_cpuid_feature(x.vcpu, X86_FEATURE_X2APIC);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
-- 
2.45.2.1089.g2a221341d9-goog


