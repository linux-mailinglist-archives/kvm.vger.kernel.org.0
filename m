Return-Path: <kvm+bounces-58560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1AD2B969E1
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAC6A18988C5
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9BF265298;
	Tue, 23 Sep 2025 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AHJUA1vr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FED14EC73
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641868; cv=none; b=ewxuIcMJvGzOzoOubuKhKKmkzYlF0AHNdEI7azZpTrdIJ3gIhqYMi53QzAil26VG7PTeJ5GHZdr6v0jl5QmeSQyIgC/YlRcecBioUt6nW23t8vRK4rqsewBtLdRAOPJp0sSjQ5Ojv6SGyaf1JtCMlmm44g77MKs/CGrzF6g3g0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641868; c=relaxed/simple;
	bh=4swEKEjr9ZfU+UhcssFhlBXgoat9+0rZuV4f1sVbGQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZbXJ16LiK+vegIf2u0DcRRV/ZmW8onjwk48imDh59GAHB7ukpgVrmGeXCziNvvrbbxg2KTcgOAHJAqhwmsJkWQ01ESCqSOlDuzp4scrVmj5R1UI3Y03uLgLgLiFOrktNSfCFZWLQT5OQJ5TVkxAh45fUy/X4QYV00OiCpWrpcqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AHJUA1vr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2681623f927so55199225ad.0
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758641866; x=1759246666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RPQBXX/kV1DT6qccrRylEa2l6eEjE9QWLJ5e48WHMIs=;
        b=AHJUA1vrowf9iGV/k69rs8bWenM5WVB/6ero/JywlrgUES2exNT6+QZwldL3BvlTRg
         9/nbI9k79EkZbdd83irH3kV+unZHYmo+rbOrPf2iyqgjPjvgNVK979JRGs9Bf85Q6oe5
         pqp/DrZx1cBa/vWs5SUOCToh69SVbClFB9i5BADXhYipMbsO0hgJ/dt/eTognteqN5CM
         ikM6wpnkEFuz/cdOSNg1oBZ8aTGeYej80vo9OFvwRfEOkKmKSOScTXFW8qg0DI27+QtW
         7S1Kdc9Hi14bqDCml/+vNWqb8r8DGhI+eiAiebd5D4IKtmJyf/3gLdgsG764yJagLs+M
         ogGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758641866; x=1759246666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RPQBXX/kV1DT6qccrRylEa2l6eEjE9QWLJ5e48WHMIs=;
        b=czWBzuuczxXfBbCRVnCc+9RNZVdfYSPAkaxQEQ0siJOORhP61nNHLZ1kO1ihP97Lvb
         b4swLPWzaplT0Vbj2mFHuGJ6VNN6AfVEM0or/2rt1SU4W2lNZhi5eZMJ6LKidk1RI3is
         K0KK6IehVTgKkiAfTFj0QpVnoXiWBOsrVn5JEw5zQ4e4+utrKtEq0dYc2bnu8RFFFDU0
         H0usaghNyFOXNfE3P3/Kd0GgoXzoQZuz+yac/VpdGyfI41BPJx7V94Hr9NBWQEdncCKr
         fTjTENWb0DmKgLmiK/aUtjEWL9sMlNbWpDkgWFRgI/dR8UG7jQG4EtM1wquAdcKrX68B
         AsjA==
X-Gm-Message-State: AOJu0Yz2GF4XwnluBqKsN/SiUSy+Jsw8WVF/o9szIZnynCwnnIFOyWlS
	/OHhD8Aq4rigLnNaizVi6jsLzPbtrugxQyy3wC/hkJJJgiMO3ks0YIrmIWtTEVt0ruYLKSkkqfi
	cCeyO0w==
X-Google-Smtp-Source: AGHT+IErLLqmD/PORlhyxU7jOUm4C+LioX2IifX5+KrKCfJkXml7M7iR2w0tUMSLgBWIeNxBWpYKDngkc0Y=
X-Received: from pjtt1.prod.google.com ([2002:a17:90a:1c81:b0:332:8389:c569])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2442:b0:24c:ed95:2725
 with SMTP id d9443c01a7336-27cc28bc310mr34259705ad.4.1758641866139; Tue, 23
 Sep 2025 08:37:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Sep 2025 08:37:37 -0700
In-Reply-To: <20250923153738.1875174-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250923153738.1875174-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250923153738.1875174-2-seanjc@google.com>
Subject: [PATCH v3 1/2] KVM: x86: Add helper to retrieve current value of user
 return MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

In the user return MSR support, the cached value is always the hardware
value of the specific MSR. Therefore, add a helper to retrieve the
cached value, which can replace the need for RDMSR, for example, to
allow SEV-ES guests to restore the correct host hardware value without
using RDMSR.

Cc: stable@vger.kernel.org
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
[sean: drop "cache" from the name, make it a one-liner, tag for stable]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17772513b9cc..14236006266b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2376,6 +2376,7 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
+u64 kvm_get_user_return_msr(unsigned int slot);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e07936efacd4..801bf6172a21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -675,6 +675,12 @@ void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
 }
 EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
 
+u64 kvm_get_user_return_msr(unsigned int slot)
+{
+	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
+}
+EXPORT_SYMBOL_GPL(kvm_get_user_return_msr);
+
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-- 
2.51.0.534.gc79095c0ca-goog


