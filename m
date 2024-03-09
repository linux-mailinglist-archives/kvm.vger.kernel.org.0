Return-Path: <kvm+bounces-11432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39006876E8F
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D69181F22798
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8D13839D;
	Sat,  9 Mar 2024 01:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="plY1J/gm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A72E374F5
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947664; cv=none; b=JVC2v9O8gcq7GGnj14cMzHy7bXbKRgiNxEYZPpWUPDJ9ZJF5RQB6fxo7okwn3xodHyvMwwlbyRXtac8cd1/OjTj0brn0BM69b4otdnCg8499H/77GDIUmO+Z/qsv7DlkEsfVUAl9aswawKembVsgfoQ0/LTUi0iGqivOFzDEnUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947664; c=relaxed/simple;
	bh=0Bygn6FGfK7hczQ7MYvkTd3Y6tG5a7KkroAmIU0tSQ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=quQH1zbEuQMnqFfClmO7Xhev3304hM7peooSuL3PyvXEpL105SLMSj6qkEQ76hOoSdzdQn14i9QMlVlr9ZQ0thXfspBYyqwrrw1wxS8rtTh55uxB/AWp8FDsg2WqeZ9nQ2bmjszN2Wqz73IPSshXvL3pxZLZ9GgWzhJWN/VLRoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=plY1J/gm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-29b5af6b4dfso2095988a91.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947662; x=1710552462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mjAr6s0HGaO3+5h8Ie2u9Yey208VqmWXwMYkWSzg22A=;
        b=plY1J/gmNz6wZzKK2ZA1+jU0sa+jwCVQHQDpuenOf/sgRWPlCVno6kGzlo/iK3J1we
         N6jfA6o+GxzXbAl5Y6bjj7moO8N58i3jE7qj6azR0loNGPTq1Yh7Dy4nSHZ6vG47okLD
         vVc0lxmSMoQxELo+weYjvDAYIg0WnoUHsGlNpf2EMkGN0s8qm9L17PRYbpLZowxnukp4
         teHYPb/YAiXO0EwlFdtEcWPrp/3PguZrMW/qKRaSMeIZADGaDFwqecRL9EK/s6Az/28a
         qP66Dj7TcqDiwTjGlf5PL2TgPVMcbPoQKZoW/xrHv9JNQmLR3Ji7YlwpUkFsdjfMitet
         PC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947662; x=1710552462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjAr6s0HGaO3+5h8Ie2u9Yey208VqmWXwMYkWSzg22A=;
        b=GYKwfaXomyG4Kk+NmXcxMxiu1W97qBJvHgF8sxlJXZa2eRuaghiKTG2qD2Bdh/QN8w
         h96GROYNd+sEwGF3HXyogbqtBdg63dJkVctrtjS4L4vYcMmytFXrJJHkcRgbo081+qZL
         i0iEr92nI2GaD+M4IvFYWXE6EPswJjdviw7Rzhx11gyqbbMPodvmmJNXDUTIasiW7tkU
         i/wlYMBU7jnaM0t7TMDDVmXwW8xp3rSgyuwoKXmUo3WnroXRe/VQ27vc/TsebPHhHa62
         TLbwKzmydWhNcWb0Vh+2k7G2Emxgfz8CmWCcVkOht1eI/iDO3+qj7vgfOf89wKmRIJcd
         6fhA==
X-Forwarded-Encrypted: i=1; AJvYcCWgECsQAMjiMD9PXAl6ad/SyCvbvkc27A6LaguhvXDO244dXY3ZFKR1rKPcxEtk9I7Wq6naAGldtXUKNy/LFaayCAoZ
X-Gm-Message-State: AOJu0YxlyfsmhybppYDDHW3vg0/z406tDZqq8+8qu7pW102peRyWAgVK
	dk48+IJUTQU4WmTDqlovthOTH1iF4Rq2D71HQSkXn0CEHUXeoMxDsPzFItSSFUty4maKQ447aR/
	QzQ==
X-Google-Smtp-Source: AGHT+IGsNNKjWe5wisyM7/b0FQKlpNvDtTNfaGIHuq9cW8kK/Cxbk+EhF7GpV5gmkbYL414F+r8ZBDlG/hY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:38cc:b0:29b:c58e:8a53 with SMTP id
 nn12-20020a17090b38cc00b0029bc58e8a53mr15336pjb.0.1709947661557; Fri, 08 Mar
 2024 17:27:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:22 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-7-seanjc@google.com>
Subject: [PATCH v6 6/9] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 82a35aba7d2b..4ad8696c25af 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1228,21 +1228,32 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 
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
2.44.0.278.ge034bb2e1d-goog


