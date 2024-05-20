Return-Path: <kvm+bounces-17788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 108FB8CA1B4
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F3361F220A0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F71613AD07;
	Mon, 20 May 2024 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZdU4HJ7n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC1313AA2B
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227992; cv=none; b=D0jWfNGsOz1dk4aQW8o5cMwhZocae//cN4RnlLr5roS4mmMS3NRWbuvUy0fCJQuc4DTQNEqWL5IHeatNE0M6bGV036l4Sqjw81CmFWgNSlmfQXoW08WP9VoDQhu+Ay+7NI140I6xjugB28Zof7rmEf4Suykw2hit+voriL9xzRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227992; c=relaxed/simple;
	bh=yUkPu18Z/1PbKTKD5A8QxorqNx8khoboW45vRZxml5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LWEZNrD9mC4+c/bdQOegmmjnwgI0X7Igq7A29hoWaK4XpZA6N84/I4EIn4LbChfKRoywtCtwbXzZYitMnqRqOX2cLQWI8El9IImcIRp86umnQZO7zNKlgPU9UM7dSzlT0VFkjAJdCFtxIK8k5HoFzeaeD3GNa8mS0mL8Vpjiiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZdU4HJ7n; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so11420617a12.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227991; x=1716832791; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7Sk8BnVQSc6MVe/dmYjYOYM96iMxBdRWu+SsqCOXmME=;
        b=ZdU4HJ7n7czbBWQRlX7G3Pc4uiWfe47ijSJ5M4XFiziT5fmXD+0LerVXFAerC5vx+b
         6cEW/hK08hFNd2Wtafc1yRQV6znBRItdToiNL/chnjFM+ppNyfx9sGQ2aKhvzvwuQAcR
         EWBUE5Vzk0qRur+Jr31qC6HrOrJYAlPlqHJCXQjtG28Dcz1o8d8WvysFIilKmbVSqG1L
         lEhfMvvdXOocvBd59sp6ONuashsJxooT/lKJ0sp6SaN78LIWynMtz9R/GBeLdEOkFhvF
         0nhh5TiKp3MJ82Swf6j5G83zD4cDONQ12Cu+bE/RawqbGKabxrB3hfw/C4p+IBqMyAic
         ww3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227991; x=1716832791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Sk8BnVQSc6MVe/dmYjYOYM96iMxBdRWu+SsqCOXmME=;
        b=nWQpm6Aw/S5uVzf2eRUnHlTpl3zR8yOZf4qCA/iyTEhRXDRSXNebBDUIfigJAfRYFP
         hjyJVV0II3vCYxzrY8WxOwYkV2/T0nzevz0ci31vDfANPokmWk7fWh8e6gmvOaJqku9W
         xOt3dCDsWClDvut1/FYZjBDHhXhYHurpQDHbc7dBpxST0Quor+7DfZBWKfF0lm2IVnAM
         ta1wr0pfWL4v3NCIyXtb1Lf1L+8tjK9w0cN8dlsLcLMK93OLnKNJD8Y5BwkOrs1N3GDK
         bTeZUe/RZEXme+EVdG6OI3HV4wgW17K7Hxa/xM0ezI8ajX4WQJjSzTq5nvPk09ILHgUG
         6YSw==
X-Gm-Message-State: AOJu0YzeBBPNA3U2cZ8yTLOeAAoADWo6nOZEbbQrQwXi0V8hS4L9cgNK
	Be8f0fNEttDVH+Js7BhL2u8XjU0mRC74HXRQECa17niKYtlIQPlZjVmTny1VvVwDiPFxorpC/IU
	8lg==
X-Google-Smtp-Source: AGHT+IGf0mUs/PSfN+brKkdvoY3kL704LHKJ3uTIGXPA4KXjjs86MdpBglhfcfuC6v3hvCfgLcz6DieI7Pg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:614f:0:b0:5ee:3ef7:a3c9 with SMTP id
 41be03b00d2f7-63744e04e8bmr70384a12.10.1716227990701; Mon, 20 May 2024
 10:59:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:25 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-11-seanjc@google.com>
Subject: [PATCH v7 10/10] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use macros in vmx_restore_vmx_misc() instead of open coding everything
using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
and reserved bits into separate variables, and add a comment explaining
the subset logic (it's not immediately obvious that the set of feature
bits is NOT the set of _supported_ feature bits).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog, drop #defines]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3fdb4a1c7e43..bd7266a368a0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1344,16 +1344,29 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved_bits =
-		/* feature */
-		BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) | BIT_ULL(15) |
-		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
-		/* reserved */
-		GENMASK_ULL(13, 9) | BIT_ULL(31);
+	const u64 feature_bits = VMX_MISC_SAVE_EFER_LMA |
+				 VMX_MISC_ACTIVITY_HLT |
+				 VMX_MISC_ACTIVITY_SHUTDOWN |
+				 VMX_MISC_ACTIVITY_WAIT_SIPI |
+				 VMX_MISC_INTEL_PT |
+				 VMX_MISC_RDMSR_IN_SMM |
+				 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
+				 VMX_MISC_VMXOFF_BLOCK_SMI |
+				 VMX_MISC_ZERO_LEN_INS;
+
+	const u64 reserved_bits = BIT_ULL(31) | GENMASK_ULL(13, 9);
+
 	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
 				       vmcs_config.nested.misc_high);
 
-	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
+	BUILD_BUG_ON(feature_bits & reserved_bits);
+
+	/*
+	 * The incoming value must not set feature bits or reserved bits that
+	 * aren't allowed/supported by KVM.  Fields, i.e. multi-bit values, are
+	 * explicitly checked below.
+	 */
+	if (!is_bitwise_subset(vmx_misc, data, feature_bits | reserved_bits))
 		return -EINVAL;
 
 	if ((vmx->nested.msrs.pinbased_ctls_high &
-- 
2.45.0.215.g3402c0e53f-goog


