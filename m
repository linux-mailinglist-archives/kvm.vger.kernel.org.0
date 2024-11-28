Return-Path: <kvm+bounces-32697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8CD9DB122
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F11EB2732A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DB11CC8A9;
	Thu, 28 Nov 2024 01:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2o6rFoB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B871CC147
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757754; cv=none; b=fVZ7u5rAwS5B4qB44jiWeqiQbCHxIVPQCeWgrsxVsordvuBlrhiPT2SWMkiDdy6Py1cf2zndVK7mboqyZrdyueCXKZI0V42pWxHfujm21u6EoLRZrEAQWXFmeb2qBOpq34sXjDU/bK3oqr+OV6UnBL1f82Psr+GGrghSSKWq2Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757754; c=relaxed/simple;
	bh=GusLaDboOc2Zwu/wHDpZ5mNIh6wjAzVVGs0J/ZdamGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nS21LkwbAorJrtOpuKmBIEjwbh6bdB352ihp6hHsZ/pCIYagXgBrwoyohJSo313+pQbV6cQMVBIKN8tdQgAWW3OoxS6V1ZKC/wCABRKzm1z6FyijsvoCnkaGmDUpWROuepl7kqpTE0aOtkB1CXSsq5Oj0GUm8b0V0fQ2ONwqu1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2o6rFoB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea8baba60dso361456a12.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757752; x=1733362552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TObQrL7LGuqxhzdSaJ7V+btqB2g4TzQqJQbV2qpDafg=;
        b=P2o6rFoB2NaaBoyZ8UxbYfcE0Lh88bl7vxCnxYKLXZ+b6xPUlvve92aA5he+TznqTQ
         OfVIUNUtCme7xKHIeZzD4yNpOKOKhsUnI4Ei7o3aP4D9MuB+Z/2B9gnWuMS8uau9jwaV
         UhnROrTMyp6r1JKnyhMi5gRPChFK/JqHh9vY/jKsfdRIUIbgDKyrrzX8GyW114DyE6vI
         Z59kAe5J/OCr7QA9IrkkEIsiU/mf83d4MmxAkHAQzJCQI2fWJ0gCYjru5TbWjTZKlAlm
         nb5u5agf/AMxgPDpSIhUBG6Sz8J/JbCX/c0VC+FI69W4RbEEh6gR8g0cPimPRNCdsppm
         mmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757752; x=1733362552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TObQrL7LGuqxhzdSaJ7V+btqB2g4TzQqJQbV2qpDafg=;
        b=Cm2auvo9FZNj5NXoWlIbuzaSzfWwe3toBLiqis/9vYd7pOis/b90JjCuxTvXScmi84
         w8lAZfkvoAHAnsUTz4OGj6JzxGkHFtgWUFsoOPj6qawGC+NTmzOTBOSLfHObjNK1W2tp
         O+bwHX65B+owe+WmcP4QM9/Uzrcww24suWbp0l1DfcW+bDm410IkxMK405hShERpHqZW
         a9sx93icfBaDYFBEvG1ou6OnBbZ56nKP3tH5+El10To7l8bXRAhA173E+NCI4syAXdwe
         x25GBVsB3bDmb2fWE02qtRWkoT2eJ/kACcMeqrP82CS1CrUbHe0Tj0U2JwOeyKZlPIPJ
         X5GA==
X-Gm-Message-State: AOJu0YxuxAzS6N0dqcWM5Mhygr4/duQ8dYTIHS63WVTSyl0eXraSM2/k
	h0RJHzSx4G9Z+UTzJOrr5w0cPyyzkqBicvghLBVNMd3ALhTj2U8KYKjRmHj3Tn6+dFRRUNHnkWL
	dxw==
X-Google-Smtp-Source: AGHT+IFxVo5QhhnwvJ9ut/LfVQKAmUeRoyod7xZep582o0DXmEnoC8hsdWrEXWsjkKMXBel57MvjaXCxv1Y=
X-Received: from pjbqj5.prod.google.com ([2002:a17:90b:28c5:b0:2ea:9f2f:2ad9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7349:b0:1e0:d1dc:753d
 with SMTP id adf61e73a8af0-1e0e0b3fa1bmr8265692637.27.1732757752308; Wed, 27
 Nov 2024 17:35:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:13 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-47-seanjc@google.com>
Subject: [PATCH v3 46/57] KVM: x86: Drop unnecessary check that
 cpuid_entry2_find() returns right leaf
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop an unnecessary check that kvm_find_cpuid_entry_index(), i.e.
cpuid_entry2_find(), returns the correct leaf when getting CPUID.0x7.0x0
to update X86_FEATURE_OSPKE.  cpuid_entry2_find() never returns an entry
for the wrong function.  And not that it matters, but cpuid_entry2_find()
will always return a precise match for CPUID.0x7.0x0 since the index is
significant.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 16cfa839e734..7481926a0291 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -291,7 +291,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
+	if (best && boot_cpu_has(X86_FEATURE_PKU))
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-- 
2.47.0.338.g60cca15819-goog


