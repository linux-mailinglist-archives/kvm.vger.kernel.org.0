Return-Path: <kvm+bounces-18965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D7368FDA4E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2041C1F2514A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CDB174EC9;
	Wed,  5 Jun 2024 23:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMGJWMAT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0730016E879
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629575; cv=none; b=l2Z1l8o8K2KkQUg1rkC8xpRsOm8n2xKZ3dEW+NqHS3aGKy3L05X9vHjVozPGgQ71t8lHLCI0ck5Xq9+TCZS8rbbjxQQWTrAPqe46D0f4qqjZXREXqhXtvuhklcK3ZRZDzfzulIwAynPXEoo5yVUNNE4kbc7vvfv9Z+tsrORh97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629575; c=relaxed/simple;
	bh=FRu/kZatnQdr9XzHy/g1OUjfeBWGEavtPQGcyQPsq5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e+9GWROayai0pZNa12KX1eXjpX2bSysScF7/HKkHclo6yiByQCbntZbQqcJ+fv5QrFEeJYejk1c3ldcvNBDNkKHs9uFomYctfd0ZGYcyBpNZ4vw/JosSU2y9fcEZXfmtj9QJqctwGhsVrX49W1OxMpBY/bUaMFOiGfMktUeuFJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iMGJWMAT; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-68196e85d64so223286a12.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629573; x=1718234373; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pvvZ8DaNbDzOA56vK/6BLcIWihuQnHvhNAp4+dw9cQU=;
        b=iMGJWMATggWfHjoOT9DVXxedxK6LCc4djxkDQmeSaBE2j0hnR3XLQ3HJdhxYzjUVwE
         iHLllx1JZcMZpjJFGSjbzO4pgadCMFeR1iipCDJ/xcuQEQdUXl23oVF19S+q9SqdUjwc
         A8uOTDqeMsXnGJnXQISU1klzpqkY7A4Ds65o1Tvju5Uv1E2t3ONOOMsG4dgaxq75Ms8o
         e8TithXEA1WLywI8HbDDheBUtMV/P6Fi194QrXMu9jjAP957MXUE6dFcc+cPOOHyQLVG
         Q3n62eqnbhrwsE9T6L1isWNdkSdIXjLdFvz5irilZ8UP93ZvKtaZ1k15t129qkULcok9
         azcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629573; x=1718234373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvvZ8DaNbDzOA56vK/6BLcIWihuQnHvhNAp4+dw9cQU=;
        b=Sn4Sp/0hmVm1gQ4W+yJpc3HR2TFhc2CSbWkr79Lh7jswLURFujZxawtsBzp5RhRYa8
         2sT7LHYf6ermJMeVafFLkg6+BGwfqWUint9jgJ8YLLWLD7NWZppXDfL866N+mJpY0TfV
         OYA5ohB3nWlzYDx2h7fHaOTfYYPjZF1vxBoUXDFzLozlxIRJML8k4bJLD7S/8gnke2Q4
         5R1uVLOrRjRAEJ3Evq8pscxp6lDlVHJZpFoLXOCosVZb19wt7SiVhgiyusprvzE7yFNN
         +09NMU1k76tC0mIImcTq64DXUH4PU7GeWCypMId6gj/nJArG7EfFR2uWZ+CF2XxbmVGh
         3+Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUWQzIQBOpbIH2A/N4xOuY/e8yq3MlMqlGhxO8g69rs5uSpTTPfjQvx/TpE/PAHo69PLZpLTIjZTlYa9wq+UevtpW5n
X-Gm-Message-State: AOJu0YyqeYwDyykPhT8DxhAJLhEmxDbWDh/pl/KVsd5mbv7/tvGoyrcp
	yrijuvfmV/Wx74vEH+2A//E/vgZGclEnpCNQDrghwxkhJ7101ODu0SjDJX2dih8Ck9OHIHLu//S
	2GA==
X-Google-Smtp-Source: AGHT+IHOil81jTTKEkgMi93RtvAaNFM2ic8gL0rWPxlBlpOJz0HjG3ROR/xU+gQkDYAzR5CBOZFKc/dmHMM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec81:b0:1f6:8033:f361 with SMTP id
 d9443c01a7336-1f6a5a12dcbmr362625ad.6.1717629573132; Wed, 05 Jun 2024
 16:19:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:14 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-7-seanjc@google.com>
Subject: [PATCH v8 06/10] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use macros in vmx_restore_vmx_basic() instead of open coding everything
using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
and reserved bits into separate variables, and add a comment explaining
the subset logic (it's not immediately obvious that the set of feature
bits is NOT the set of _supported_ feature bits).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog, drop #defines]
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3bd6c026f192..6402def985af 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1250,21 +1250,32 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 
 static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved =
-		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
-		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
+	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
+				 VMX_BASIC_INOUT |
+				 VMX_BASIC_TRUE_CTLS;
+
+	const u64 reserved_bits = GENMASK_ULL(63, 56) |
+				  GENMASK_ULL(47, 45) |
+				  BIT_ULL(31);
+
 	u64 vmx_basic = vmcs_config.nested.basic;
 
-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
+	BUILD_BUG_ON(feature_bits & reserved_bits);
+
+	/*
+	 * Except for 32BIT_PHYS_ADDR_ONLY, which is an anti-feature bit (has
+	 * inverted polarity), the incoming value must not set feature bits or
+	 * reserved bits that aren't allowed/supported by KVM.  Fields, i.e.
+	 * multi-bit values, are explicitly checked below.
+	 */
+	if (!is_bitwise_subset(vmx_basic, data, feature_bits | reserved_bits))
 		return -EINVAL;
 
 	/*
 	 * KVM does not emulate a version of VMX that constrains physical
 	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
 	 */
-	if (data & BIT_ULL(48))
+	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EINVAL;
 
 	if (vmx_basic_vmcs_revision_id(vmx_basic) !=
-- 
2.45.1.467.gbab1589fc0-goog


