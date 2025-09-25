Return-Path: <kvm+bounces-58822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B80BA15AC
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 22:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B30E83A32E9
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 20:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7680D2E54A0;
	Thu, 25 Sep 2025 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="caJlLDJk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892E19AD5C
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 20:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758832211; cv=none; b=Y1r+55kud8hEk2PjY+t+PDqgM1D4YgPPzGVaL24C5C3AFrKQc7EENsiqzxzXhB6+gbBKvuoR1oeUCbvj5DQFHmy1bEVTmaVJBSZyUGzBuE5l+1RGgx8h3iKeg64JD7Cj6o5xzlY9QFAy+FhJVpLtdfbk3r67srmvSp2Nm6WZQ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758832211; c=relaxed/simple;
	bh=L35q1vuBSDOl7MaYa1hpVyLoad727cO65oWhEkClfdI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hrWBZbXMmAxA8kjZ3hWdjU9bMlQgTc6e6Erp+wuKBReId61/Dy2/pMkGo8BVI2k3m5fd0XbnltZ0vGDV9Gy3b70+VxoYmCVPAUcY/kwJaZNA/4yMHhfH1fU+cd3xmD4CZXOJCw7tyHsvpvE64ZOD803q4kVXsmyF/M3VqWtg7Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=caJlLDJk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so1334302a91.1
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 13:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758832209; x=1759437009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fUhQfuZQ49Qk6kF+H3E3oMnEtXpR0FIyehqJ5ObyXOo=;
        b=caJlLDJkqQY03IDpNtHokSJD4TSbs7zcBpZXiPbb+Fycv+T6Il7uL5CG5hckzbmtxD
         PqZMG+Z/VBKu9fS0oRGjgU1p5G3963eF7dF/8S6WvujgY5OMxsJMyOHGQ/2UXFbZWUFh
         J59BLUdw1F1o7w2lkvOCI9TpXkinNUI9tQyvtm/iKpLr1lYeTh7XANLXky/TUZJ35LB7
         ee/iva4Mn+VAPkoe1gSWTlfGf5IfycNzOl1GAwvq/CTRXZjxh26IhHlQgAkxhe5AENyl
         JY4dZ+6wt8I3pRRq+USJXeLSx3k89U69vFBeHyAX43J+LN02GCagxbkREH6/R0uAwNhc
         2BQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758832209; x=1759437009;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fUhQfuZQ49Qk6kF+H3E3oMnEtXpR0FIyehqJ5ObyXOo=;
        b=R3vZhWd95puRvhoXs1VS6XYlRA45mv5KCTkFVdFq6QRp3ptui4CBWGSQ5uoCf4usgW
         IYVAPkDb2XTZGM8Rc90UVxqYyZvhDaXsb+m+4SNOlQPDSQBLIBhqTVvgFaRSMErkGamL
         4HbFUtzRiLawtYhONPv5Dvoa4P/9ji4bl2XU7GUsI6NPXypx27F24hW3YVvFmYuhjIhh
         PI2M+LcyeOUG2Y34nxaK0iptcQpZUjRDNkeV7qd1iWJBHE8xR4wfHuMwB74mOb8SQbwE
         RsatSFuw+z+citG4RF3Gc14bleSXrBqm4TjuISeSA8Ji4YU45xnVQxRGo7FMsXmvx/pe
         uh4g==
X-Forwarded-Encrypted: i=1; AJvYcCXaoP0b479R/m1w+AuJEje7HIjOtXGb998zJ7roN22/r5yhCCrw39QnVc/nHv+t3p1JvAk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy1DROf15jVA6lE0A3uViJOQWnbLcAiv+3UyuKgn0uAh/2U9Nd
	gThN3NwElRWywtD6yNCTpUpqxALOrCkem4zxfaKpartCwKWzzGXZr9Jq/2/4K0HKbQ9Zj/OnbsB
	4ujtFQuEIOOWauA==
X-Google-Smtp-Source: AGHT+IEpADWjBInJevT1rnwxJnYk5LLarY2R9oiv6N/HEC1VxtOmQ+GZ+gaxN23ts7uJlWq6TnuMyA6b9Xczsw==
X-Received: from pjot21.prod.google.com ([2002:a17:90a:9515:b0:32e:6111:40ac])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e710:b0:32e:ae12:9d32 with SMTP id 98e67ed59e1d1-3342a22beffmr4772179a91.11.1758832209587;
 Thu, 25 Sep 2025 13:30:09 -0700 (PDT)
Date: Thu, 25 Sep 2025 13:29:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.570.gb178f27e6d-goog
Message-ID: <20250925202937.2734175-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Advertise EferLmsleUnsupported to userspace
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Manali Shukla <manali.shukla@amd.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
it cannot support a 0-setting of this bit.

Set the bit in KVM_GET_SUPPORTED_CPUID to advertise the unavailability
of EFER.LMSLE to userspace.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 751ca35386b0..f9b593721917 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -338,6 +338,7 @@
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
 #define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
+#define X86_FEATURE_EFER_LMSLE_MBZ	(13*32+20) /* EFER.LMSLE must be zero */
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..e0426e057774 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
 		F(AMD_STIBP),
 		F(AMD_STIBP_ALWAYS_ON),
 		F(AMD_IBRS_SAME_MODE),
+		EMULATED_F(EFER_LMSLE_MBZ),
 		F(AMD_PSFD),
 		F(AMD_IBPB_RET),
 	);
-- 
2.51.0.570.gb178f27e6d-goog


