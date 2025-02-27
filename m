Return-Path: <kvm+bounces-39509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C19A472A8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5F581889700
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2377C22CBEE;
	Thu, 27 Feb 2025 02:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U+ysUmz6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090422B5B8
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622782; cv=none; b=o/Zx1QkA6c6H7ykIXkLUpJpKzfT8nPrwhO8uftY0IBXAgYyxIB4cfOMtsfHL0x5oMfjPdwqubuFbr3LFSxMUEIZ4JPKpGXWE06+IMVAHlCVSMv9FPbizuxzAmnS0Oe/rcy/Q36Q2nWIp4Yc+TdO42L5l9Yp/P8sNZ5UT+/7UeFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622782; c=relaxed/simple;
	bh=W77bDJioIxxlTCWtlgTvtUdQUjN+l9y/G05gekf8Apg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B/lsceSUj0QXRFj3LnnOx4z+XeH5sStRWKo7XLIuuvF6gsGAgujyKipxPQhcd58qaAukjt+0EUxU6xPHSanS9nnN2aB8tLpvCxPdv5rejV2iRujPNytopW2DisfrjTJ/3QaRO8I1Bxh5iXEYGtw/go14k3oBhNMQk3Cev+a4f/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U+ysUmz6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8fa38f6eso1027027a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622780; x=1741227580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kU2lFcUz0RS/25JB9tsyegi1crsFJmJvQFST0gISHao=;
        b=U+ysUmz6K0zL0GFvBosFujLDT7MKwULHVNue4bITt0NaNhwzgJf1XdP1JpMp4qXUSA
         scRLReAuNFwgNPIf0JedSMaQ1FCmx9rei6uncVsB2FFh/RELhZdkb+b/omGFrZtvtE/M
         8/p+IVNvUChpZQYYNnVDxTQFUG7+AzzePNgYcWrCEf9RDGpW21BDps2vKCpBj/kJy5/R
         s+j5mevY7qdNugYRay7mn5nvfG0kEaKtmUhgMDzuF3N3EVAQVG1+c4K5BJX60enue39p
         J5gDTOA1bsKhHm6tHDKbl2Ldsv0KJQ12MQJWgeiqABQj7tFnYhc10XK3f2uSNQpbe8bl
         hNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622780; x=1741227580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kU2lFcUz0RS/25JB9tsyegi1crsFJmJvQFST0gISHao=;
        b=HjgFRw+x0kS2AiE37rlKs5w9L1T9bZDtPXtT1Nzc0JDexDiZd7S9928qQLAtzFlg2/
         ezuMq4xPle2e2zgMAzfwlZoLh1tEQ9Tic8XlcaF/bQwf0PNpaU8Y+zyyVq+1X2RpP0RV
         jEAAn0HRDy48ERnN+Pz9ejldUsAcHQLPpJ4elWO+BjlVGF5AqJopc0xjn75okKLyiPl+
         Wa4Lise+PN3Z2WaVBibrPryDkN9zr486KZpLD2sxKnQHVauoZF3ngFLE/m0Wx9VS2QP2
         5qRnloeMoTTPhhrWJ+F7wCgK1Ffvw5+ov6gUnaSn5sPx40fmme66Qlb16N66bKhFwIs9
         /9XQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9vaQ7YgnW/QfCoB8y2xOz+peCQKnJrgMwzQlotJbRwIrwUjWHK0SRSR/wA0idlf0IsfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVpHM6xElRNVK7nCyCR+ni4HBlWwZflWCTDFRWuDReusDt/954
	fPjKBUHTrgTO9IxkHxyXp+qC6RMxT7gbVnU3QzqJ8xPaHN6d25s6VQOtPCs6ioCyPOpoMDSx13W
	ccw==
X-Google-Smtp-Source: AGHT+IGPqE+K3f21q2ak8FFNHYsAgDpuaP0E98T4gncRvFB5lVR5BPc4qf0azJ1lc37DAZgmd7FgPnilX0Q=
X-Received: from pjbsh7.prod.google.com ([2002:a17:90b:5247:b0:2f2:e97a:e77f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc44:b0:2f6:f107:fae6
 with SMTP id 98e67ed59e1d1-2fe68cf3f5fmr12813327a91.23.1740622779809; Wed, 26
 Feb 2025 18:19:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:37 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-22-seanjc@google.com>
Subject: [PATCH v2 21/38] x86/pvclock: Mark setup helpers and related various
 as __init/__ro_after_init
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

Now that Xen PV clock and kvmclock explicitly do setup only during init,
tag the common PV clock flags/vsyscall variables and their mutators with
__init.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/pvclock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index b3f81379c2fc..a51adce67f92 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -16,10 +16,10 @@
 #include <asm/pvclock.h>
 #include <asm/vgtod.h>
 
-static u8 valid_flags __read_mostly = 0;
-static struct pvclock_vsyscall_time_info *pvti_cpu0_va __read_mostly;
+static u8 valid_flags __ro_after_init = 0;
+static struct pvclock_vsyscall_time_info *pvti_cpu0_va __ro_after_init;
 
-void pvclock_set_flags(u8 flags)
+void __init pvclock_set_flags(u8 flags)
 {
 	valid_flags = flags;
 }
@@ -153,7 +153,7 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
 	set_normalized_timespec64(ts, now.tv_sec, now.tv_nsec);
 }
 
-void pvclock_set_pvti_cpu0_va(struct pvclock_vsyscall_time_info *pvti)
+void __init pvclock_set_pvti_cpu0_va(struct pvclock_vsyscall_time_info *pvti)
 {
 	WARN_ON(vclock_was_used(VDSO_CLOCKMODE_PVCLOCK));
 	pvti_cpu0_va = pvti;
-- 
2.48.1.711.g2feabab25a-goog


