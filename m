Return-Path: <kvm+bounces-17671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 179938C8B6F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C369A289541
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA6113E3FD;
	Fri, 17 May 2024 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+tL38Fj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E134914A088
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967622; cv=none; b=lonUc1aFeJnsCj9H26wsCwfC46jXw5ZM0lv64djWrU1XJfSjeISaKF5KbX0BzV/SJELWwww4+gWyp8Wx9zUkHN9nXKoYWJRvoK+6r2eHozEXaVxdXui4i9hMKqtZZRpZcMX8XZgXQvWG73r/bq1U4Z0tua8dXDYrcj4j2l5DUw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967622; c=relaxed/simple;
	bh=WpEfgTqvxMmTqgtRjBGJ9mUo4mMumn0xpoO2FP087q4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ED7SeFLX9s4LYd5cAa/ojAUby2r7VuXosNd8n6Z4hH/ca8y6AehyebmSvnKTJ9iyIktZRtEdRwsyovmKQvBwNGgAuuJ0y/39QHazn46JtFrYa4/spF1hIu+dWMnbnvpcpujuvpvJWcXBbN8nnfgxSQKabylqo7bSsk55qKy8hzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X+tL38Fj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6efefc57621so5281823b3a.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967620; x=1716572420; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0wWTJWtW4FJprikXgCXBDeS0rSMKlETzXy6OsT3CYpI=;
        b=X+tL38Fjnp0EAUOwrNdDxdUv2OejlJVUlUn8T5fo1V9Iz/IwIYbFJQhGZStQZPPJ1r
         rlM5zCjB03QIzgzkIaQqiUtGLI/Vz0wlR9EFGZF6cO3PebdJs7P1pSrITpeks6pbc61o
         JSa3fjpWGSiFH7iXdHYYVqq8rON4VshHKw/lOWpPR7JambUa7XPuyEVOOM/USGivk/LV
         6Jffs+OtmvcPtv3ws8MfRberslR4nwcnuFfNPH07W0qsZ/SVytaeb0oEf7BcGgXg/f/9
         dRxURWsbF2nCyZBHlvYr30COLOamLHODU8rz8nedkaqj3HmBRJ0MHK6nGMeMxh18esO0
         hE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967620; x=1716572420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wWTJWtW4FJprikXgCXBDeS0rSMKlETzXy6OsT3CYpI=;
        b=KH5YQjBxmMkpXag9PmQ5IFOSzPrMZIoDWxHI+eyLbVAP3ChE7xQPTEI9pqj7Raml4G
         3spo644ZGe9yt79p0sHAhjpEMkD0gpbHGzApPl7zJPz8+kbQX05TdwuTYroixd/AntrW
         gzqlfxMHXDws+QMklJrdp1AxD6iWaiYwf+NZ3+p4MIgqq8VEOWeOT9VT2Sle9Rkgq2Jf
         S4VduObteoZuisFyFRlXCx5PhMPRaUybO1SuLK2ZFBRJHorv4IpXbFoACnZ149F94Vd/
         kTpCT/Cl4NoacXihgIU+JjeLVrtnLPDoHsTAuYOiqvKRq1wsuj3QATO43URf6xIch81y
         0dKA==
X-Gm-Message-State: AOJu0YyjvPfY5w6IdFxumsaCu848/OOqANg3rRgNhehuiHHXzOwsGRHx
	g61FiMftJW3s90e3BeXWt/JVZCLrc7f9HNrFcjMdjy50nyrAZy1mRqsoRyap35sUfwJDh62+hLg
	0zQ==
X-Google-Smtp-Source: AGHT+IGVlkDMu6SgCRXvEPKEGroeOFGxol5oKg2OzOEvQ55LbhOp4rIso0qjuMbugc7tID63+956tNJ52dM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1144:b0:6f3:ecdc:1b94 with SMTP id
 d2e1a72fcca58-6f4e03a253amr307893b3a.6.1715967619193; Fri, 17 May 2024
 10:40:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:56 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-20-seanjc@google.com>
Subject: [PATCH v2 19/49] KVM: x86: Add a macro to init CPUID features that
 ignore host kernel support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add a macro for use in kvm_set_cpu_caps() to automagically initialize
features that KVM wants to support based solely on the CPU's capabilities,
e.g. KVM advertises LA57 support if it's available in hardware, even if
the host kernel isn't utilizing 57-bit virtual addresses.

Take advantage of the fact that kvm_cpu_cap_mask() adjusts kvm_cpu_caps
based on raw CPUID, i.e. will clear features bits that aren't supported in
hardware, and simply force-set the capability before applying the mask.

Abusing kvm_cpu_cap_set() is a borderline evil shenanigan, but doing so
avoid extra CPUID lookups, and a future commit will harden the entire
family of *F() macros to assert (at compile time) that every feature being
allowed is part of the capability word being processed, i.e. using a macro
will bring more advantages in the future.

Avoiding CPUID also fixes a largely benign bug where KVM could incorrectly
report LA57 support on Intel CPUs whose max supported CPUID is less than 7,
i.e. if the max supported leaf (<7) happened to have bit 16 set.  In
practice, barring a funky virtual machine setup, the bug is benign as all
known CPUs that support VMX also support leaf 7.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 77625a5477b1..a802c09b50ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -70,6 +70,18 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
 })
 
+/*
+ * Raw Feature - For features that KVM supports based purely on raw host CPUID,
+ * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
+ * Simply force set the feature in KVM's capabilities, raw CPUID support will
+ * be factored in by kvm_cpu_cap_mask().
+ */
+#define RAW_F(name)						\
+({								\
+	kvm_cpu_cap_set(X86_FEATURE_##name);			\
+	F(name);						\
+})
+
 /*
  * Magic value used by KVM when querying userspace-provided CPUID entries and
  * doesn't care about the CPIUD index because the index of the function in
@@ -682,15 +694,12 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VL));
 
 	kvm_cpu_cap_mask(CPUID_7_ECX,
-		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
 		F(SGX_LC) | F(BUS_LOCK_DETECT)
 	);
-	/* Set LA57 based on hardware capability. */
-	if (cpuid_ecx(7) & F(LA57))
-		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
 	/*
 	 * PKU not yet implemented for shadow paging and requires OSPKE
-- 
2.45.0.215.g3402c0e53f-goog


