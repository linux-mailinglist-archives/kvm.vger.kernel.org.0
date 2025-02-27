Return-Path: <kvm+bounces-39490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2409FA47227
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F34251660A7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EA21B042C;
	Thu, 27 Feb 2025 02:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zxx7mXR/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FE314A4DF
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622748; cv=none; b=qmwDwGxJHZYY6Bor53DwwF2N/kXg0nXZoJHUWvl5HlRVkNG40o4QSnN6FfCf5rJyd40QyPqs4/Oxp68Jbu6AVLq4HIa9IJvTpvKhMmpKDXCWgExJikvUvEc49Iu03XASs0EUpXsJJ7fsIdGR2J8k4OajSRxPQEhs3KBsLLy2V0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622748; c=relaxed/simple;
	bh=YIm02xTVNm0eSDO98sEQL1tUrXbpItcdQ7Va1EiMjyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DwxtEbd2vws+ayPNfscGegw4gwa6MaVwroSYcRL7DxT7d8wFAmU7sdJOcmfyrn7A65yRLTmnZsqT9bGW5jpqJIFH1JbUYpy/JiALZ33wEzvqH7yaywk9g83TnqUpk6/pX1AlI0Rtt2hhroMuEkqeeN2fWJ1+oYy3AtmUx8q9teA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zxx7mXR/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc45101191so1079379a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622746; x=1741227546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dwfv1w4tsOCmi3NCgULhIMD4IZcsOFfau2ULDYaMRLg=;
        b=Zxx7mXR/tph5hMWT+eMpiZUfB7LGnjo3vm++s+G/pOqzIlPRSB21YJk9W9ItALFEsc
         LDGTNDirm9YWggc4IQQxPUP/RG8Z17EYC9PV+t2EWJDiHFXh50A0CoWUK3ESCZxHm9kc
         /oQV/J94l19TNCfKU7fpofF0vP2Pj58nrs+8c8tHYJx7y5LQw4jG20WBvQveWqTLrWcv
         nOOmiQt48iS/OG4IrYpYzkOgd8OL2zvZaj1Pq0inJDoH86KwywJZ4UmvkDBphA7QYDpk
         taIKCdFuviMzaNpm9JaXKFYWdr8I/6psRCnzM4jBRT1DropZT+srUYkuL54B81g+vn2t
         a4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622746; x=1741227546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dwfv1w4tsOCmi3NCgULhIMD4IZcsOFfau2ULDYaMRLg=;
        b=EH9aLHlXO3X3r+TnQjfJh/txxfzE4vHhmvuyE5BGVEx2iINn9uE5n/iufLDOU1ozGo
         1pggyr1YOfQGmqUQfAhKKDIWUjX2HEmgVvDBdBPFAtbqi4mjQkbpy2wwlbAbZtx7qlZd
         EKYVZSoehXqkgT7B8SXGKS2Wz4DA90Zp5CMhQKhoIeZEGKjnb1J4WX+Eg8gB4hDktdDa
         fJ2wGwdgEM2D93rvm+1FUgMIlSXaf/BnteVO9fbsZDFg4Ef3Db0C3SWKYb1D9ZNSqujR
         gxi6zZs2JJQ6szL/OxpxNKX5gnIquaiGT3KxGaFgXWhtm0q2+vtv46b347NsGu4NNaDL
         I22A==
X-Forwarded-Encrypted: i=1; AJvYcCXnPmo4iLrdC1uEOltBnDI690XBcw0wQgA+B3dKVHvNsbNilOtYJL2G+pIw8mtq9x8Hdhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXu69kL3Fg1zFzOsOegxttJ1RGIY9EfEfwFFFrsUuvGyGdRMos
	UU/A/sQAIe8BjOKoKlHEMre5MQsB7lRrji8rN+YZ65W2kVIqgTRmFQCxh3Zyov+oNMdDJ/evzl/
	o6w==
X-Google-Smtp-Source: AGHT+IH6wZ/mGewjHTQw2W+siQpDLDG/G2QvagXg40e21ebxNRSjKEBR8DQxe4UjV6eqsE0kkd3QFpygjvI=
X-Received: from pjbsn14.prod.google.com ([2002:a17:90b:2e8e:b0:2fc:15bf:92f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d83:b0:2fc:3264:3666
 with SMTP id 98e67ed59e1d1-2fce7b221c3mr36215820a91.30.1740622746375; Wed, 26
 Feb 2025 18:19:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:18 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-3-seanjc@google.com>
Subject: [PATCH v2 02/38] x86/tsc: Add standalone helper for getting CPU
 frequency from CPUID
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Extract the guts of cpu_khz_from_cpuid() to a standalone helper that
doesn't restrict the usage to Intel CPUs.  This will allow sharing the
core logic with kvmclock, as (a) CPUID.0x16 may be enumerated alongside
kvmclock, and (b) KVM generally doesn't restrict CPUID based on vendor.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tsc.h |  1 +
 arch/x86/kernel/tsc.c      | 37 +++++++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index a4d84f721775..c3a14df46327 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -36,6 +36,7 @@ struct cpuid_tsc_info {
 };
 extern int cpuid_get_tsc_info(struct cpuid_tsc_info *info);
 extern int cpuid_get_tsc_freq(struct cpuid_tsc_info *info);
+extern int cpuid_get_cpu_freq(unsigned int *cpu_khz);
 
 extern void tsc_early_init(void);
 extern void tsc_init(void);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 93713eb81f52..bb4619148161 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -688,6 +688,24 @@ int cpuid_get_tsc_freq(struct cpuid_tsc_info *info)
 	return 0;
 }
 
+int cpuid_get_cpu_freq(unsigned int *cpu_khz)
+{
+	unsigned int eax_base_mhz, ebx, ecx, edx;
+
+	*cpu_khz = 0;
+
+	if (boot_cpu_data.cpuid_level < CPUID_LEAF_FREQ)
+		return -ENOENT;
+
+	cpuid(CPUID_LEAF_FREQ, &eax_base_mhz, &ebx, &ecx, &edx);
+
+	if (!eax_base_mhz)
+		return -ENOENT;
+
+	*cpu_khz = eax_base_mhz * 1000;
+	return 0;
+}
+
 /**
  * native_calibrate_tsc - determine TSC frequency
  * Determine TSC frequency via CPUID, else return 0.
@@ -723,13 +741,8 @@ unsigned long native_calibrate_tsc(void)
 	 * clock, but we can easily calculate it to a high degree of accuracy
 	 * by considering the crystal ratio and the CPU speed.
 	 */
-	if (!info.crystal_khz && boot_cpu_data.cpuid_level >= CPUID_LEAF_FREQ) {
-		unsigned int eax_base_mhz, ebx, ecx, edx;
-
-		cpuid(CPUID_LEAF_FREQ, &eax_base_mhz, &ebx, &ecx, &edx);
-		info.crystal_khz = eax_base_mhz * 1000 *
-			info.denominator / info.numerator;
-	}
+	if (!info.crystal_khz && !cpuid_get_cpu_freq(&cpu_khz))
+		info.crystal_khz = cpu_khz * info.denominator / info.numerator;
 
 	if (!info.crystal_khz)
 		return 0;
@@ -756,19 +769,15 @@ unsigned long native_calibrate_tsc(void)
 
 static unsigned long cpu_khz_from_cpuid(void)
 {
-	unsigned int eax_base_mhz, ebx_max_mhz, ecx_bus_mhz, edx;
+	unsigned int cpu_khz;
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return 0;
 
-	if (boot_cpu_data.cpuid_level < CPUID_LEAF_FREQ)
+	if (cpuid_get_cpu_freq(&cpu_khz))
 		return 0;
 
-	eax_base_mhz = ebx_max_mhz = ecx_bus_mhz = edx = 0;
-
-	cpuid(CPUID_LEAF_FREQ, &eax_base_mhz, &ebx_max_mhz, &ecx_bus_mhz, &edx);
-
-	return eax_base_mhz * 1000;
+	return cpu_khz;
 }
 
 /*
-- 
2.48.1.711.g2feabab25a-goog


