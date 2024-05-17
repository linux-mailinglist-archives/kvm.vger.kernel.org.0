Return-Path: <kvm+bounces-17670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3589F8C8B6D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B670B243B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA4A146A72;
	Fri, 17 May 2024 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cA25VLje"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21358144D35
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967619; cv=none; b=FmaOtJg02F30CRiw/GbgAvFEjjrFSUMOWwUEuNbE6gYRyPukqkqQfRzuQHSvdas7BcBm1hDoLks2xNIfQKJjLPMqpCdI79WBQURm57aB10nj8j0I/8vAZArNXV9xCJqK4lg07cxQwt7JGnKC8/0YY3Bprl8YP1E09jjLPxS7GrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967619; c=relaxed/simple;
	bh=E6LgUeDIffwkx0+8Lxw4NCEFqiek6fuwZ9kkRbcXbvc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kht02AB8FwacsLvryYv4qSlt/iR+wx7wqif1CcO+vE4XMiWp+g4ukNaAXenMgMwmknzJV84hQKRymfmIQkDlUQvgjMkj57q8aut2EcheL8ZpA5aPPTLB/WLG7YVYTm5Tsp8tG5mLq38DcMVqZGSifH+Ex1lKwA7+QpJ+DgkjkuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cA25VLje; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f46acb3537so6689721b3a.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967617; x=1716572417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fknuicu/P7ZeItkSn6tGc+U7pN3vSqibLegNNza/UIw=;
        b=cA25VLjezgJd70261B8TG0b7LIEi1s7tBOGcxegHFwnm0LzVIt1VcJUlmk4YeBS7Y3
         JYMm/B1YvO72NmrxVYD0nXvWJuLPtO5TcNwoBKwwNGBRlVHwdT0ELXQrZmzZkiI/BRqz
         gz5XQOladAGUkX9jxJtCpwSoskLs9YpoSGk5869nZFJU48sQnxyksURQnTWC3+xhXBDC
         PA4ie0T/Kt4bMyBiGiZjcQI0mbSEYCkp0ALKa1DqEqYwc+dwXppaoBz95T/X3YIymVTo
         YmTQbZAjz7/bjLdZWyrRI11dG3SoEoZ2DcvmLfTXuivn8E6KjuDE3rG56Ho31tn411BA
         9MzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967617; x=1716572417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fknuicu/P7ZeItkSn6tGc+U7pN3vSqibLegNNza/UIw=;
        b=NO2/lbuiBwc4Co+nkuEHzAvnX4oRESIiDNaOTJ0quV7Idhh2WzDKH9LSQsseW79F4O
         96qRsVyYNxTvlcj/JXz6W8gWjwk5FPz2W8xefNN+qaTp9SRhfs8KIBhxNZXWF9oNL5N6
         0/CVTLIWRvaNVC3Se/OtLqUJ9m+K1wHxzbJiXfXesO/xhJ7Cd7cNRmFaCg2RMBNcuoUc
         WAyc4thbzS3TADmT3s1Qqdh8CHmh/HbsC1S5TLouM0X+c+Snd0t34a+TwzjXG1/DsSVW
         m26utQGsz5eE8XqYCE1Xt5S+eWDjI9P1RKJkLn7/EcCrzv19MrVrVRPpptKtqMdVBu2f
         NDHw==
X-Gm-Message-State: AOJu0Yw+0E6Kcd4RW0MEV77GzlTF74m1hr7cjCgM8ubSB9YHazuLbUNW
	ojo0YLKO/oVTEx1TsaDAvkch8/qNtf4UiKtmqKlPPa59S6882KF/TUAdN+BEkGSL9dAoMEHN9YF
	+Bg==
X-Google-Smtp-Source: AGHT+IEYb9XucBtFyugqfhcxaqHJPHS9Dd4UUZVrs27sCzXHfxzBAfLUwXRfyGuC/W3LuyW1l0NFfg1t1Wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3999:b0:6ec:f3e8:46a8 with SMTP id
 d2e1a72fcca58-6f4c8e4058bmr121470b3a.1.1715967617457; Fri, 17 May 2024
 10:40:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:55 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-19-seanjc@google.com>
Subject: [PATCH v2 18/49] KVM: x86: Account for max supported CPUID leaf when
 getting raw host CPUID
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly zero out the feature word in kvm_cpu_caps if the word's
associated CPUID function is greater than the max leaf supported by the
CPU.  For such unsupported functions, Intel CPUs return the output from
the last supported leaf, not all zeros.

Practically speaking, this is likely a benign bug, as KVM uses the raw
host CPUID to mask the kernel's computed capabilities, and the kernel does
perform max leaf checks when populating boot_cpu_data.  The only way KVM's
goof could be problematic is if the kernel force-set a feature in a leaf
that is completely unsupported, _and_ the max supported leaf happened to
return a value with '1' the same bit position.  Which is theoretically
possible, but extremely unlikely.  And even if that did happen, it's
entirely possible that KVM would still provide the correct functionality;
the kernel did set the capability after all.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a51e48663f53..77625a5477b1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -571,18 +571,37 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
+{
+	struct kvm_cpuid_entry2 entry;
+	u32 base;
+
+	/*
+	 * KVM only supports features defined by Intel (0x0), AMD (0x80000000),
+	 * and Centaur (0xc0000000).  WARN if a feature for new vendor base is
+	 * defined, as this and other code would need to be updated.
+	 */
+	base = cpuid.function & 0xffff0000;
+	if (WARN_ON_ONCE(base && base != 0x80000000 && base != 0xc0000000))
+		return 0;
+
+	if (cpuid_eax(base) < cpuid.function)
+		return 0;
+
+	cpuid_count(cpuid.function, cpuid.index,
+		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
+
+	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
+}
+
 /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
 static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
-	struct kvm_cpuid_entry2 entry;
 
 	reverse_cpuid_check(leaf);
 
-	cpuid_count(cpuid.function, cpuid.index,
-		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
-
-	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
+	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
 }
 
 static __always_inline
-- 
2.45.0.215.g3402c0e53f-goog


