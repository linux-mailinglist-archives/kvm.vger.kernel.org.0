Return-Path: <kvm+bounces-39511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 940ADA472A9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A493F7A5222
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54ED522DFAE;
	Thu, 27 Feb 2025 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iNc5mDBO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D411C22D4D3
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622785; cv=none; b=fiMLvr+r3k4Jj81V/jvhHfCJjn1FOu9ya0KD/04GCIbmyOIBjKISMBFck9RqEwyw23zZhMhGYGPrDlpcD6ESchq0zBr0T9bdV+D2r9+6RaQlSPkp8CTVeABt4xdqNWN2jaaWL2+Jac6L2l9hpvh4FhNZFTGMjJlFbxbumqbStdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622785; c=relaxed/simple;
	bh=c8XZYUiY0W1+X8puZluFjrjS+RyDGH52gngoWNRH5Ko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rl8EhRDyUD6ibQ3lZtS0WL/HOo/UogpIQxCDbkJAESDLmssHWLx+cHGvLPuGvXk3+1TLAkMcRSagr7QxaSSUkTbUDFqtRCaqLANoKBbRsvf6SorYUeaURq8cS+JtG7bGfceI0GvYb8/zmRTf77MdXCZqqLgAILNyt0zcxDhvdOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iNc5mDBO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc518f0564so1095861a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622783; x=1741227583; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Za0nk5QeJovZveNmDgTJSzh3R0hb/7p0/gaKYZ4C/Vs=;
        b=iNc5mDBOH6iCXAVl7fjXBB9NgQAegd+oFXUTQf6c7PPrBAeGbAM/xfNDCJqf2qRxqw
         bEwsnT1BcjunEHggVxC4KaaBcADtyp41QpGbbZp9/85769HwwPFdK7phSzJxBg1u/xgZ
         YB9QzyOrvlejcioFW7BpLj298Kkm1gJMskSZ610tAKp7DEMKb4Kf1gpCnoZUupe/JVTC
         M/ADlrlXbMYVcCf1AuRlKMQbSQLeifzjE/jaZFtR92da7oNnNv44+sEK7wOgaK6ldpHj
         Ugef1n6qwdO/HftDAw5G6R1yxYGtOVczOGODa98lJye+UP4lLyOErt3pyr9/pJQKM/M/
         KlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622783; x=1741227583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Za0nk5QeJovZveNmDgTJSzh3R0hb/7p0/gaKYZ4C/Vs=;
        b=vKxw/rWjDuUlVDKVXZWx6ZlHjkIF2GWPL8I0DxS74GpdieYFQBuOYXejPHqN4JjGVV
         zGoAWeIejEs+79Dolujqbh1pKO/BzrUKYu0bbqwGvIvNir86ve61/rGAgrHdkvBPLYNh
         UUR5q7cO5UN/9c4NHdZnFMrG1tzJ6bC1Znxo+mIYk9mTvwsxjLxa+5oICtlZtgEcSPr/
         s73IQHvfFoPz1W1Qurze1jYoCokI9isN9wM7YsFkjgJUa5gyyAXkcFCEQQyiUF0aHen3
         PTshnXG+GSkcl+VtpZJvMaapW4LZIq0ebWV7OJ2+B4sxZaPvvodtb+jntRT1HD2wT7+u
         oatw==
X-Forwarded-Encrypted: i=1; AJvYcCXRDDLiOO4/bBhyma3XSuSOpDdzCmyLP86h7q8awne6G4ndUcDGOvIAPPhy+Y7n1GqEZOU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLgqAtUxpTlSaxFmDBr1fjQ9kUPh6beRg1bZlsaUAHhR2YlzKO
	cIXIkxbodu4FNPho2Kk8sVdxQsuABcYNUXs7QmZpk+NcJyXkt1EugKbnVUY2uBlvWISs7Mrktvc
	7HA==
X-Google-Smtp-Source: AGHT+IHPEy5y9WPVcI/hX8J+CDDBk9ezIawKhLRmwSNwFlW/vj5Sb4uKTsOn6iseYydXRMp+Q/+8QjZLtQQ=
X-Received: from pjbsm1.prod.google.com ([2002:a17:90b:2e41:b0:2f8:4024:b59a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2d0:b0:2ee:b6c5:1def
 with SMTP id 98e67ed59e1d1-2fe68ad9ef3mr15165448a91.8.1740622783395; Wed, 26
 Feb 2025 18:19:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:39 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-24-seanjc@google.com>
Subject: [PATCH v2 23/38] x86/kvmclock: Refactor handling of
 PVCLOCK_TSC_STABLE_BIT during kvmclock_init()
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

Clean up the setting of PVCLOCK_TSC_STABLE_BIT during kvmclock init to
make it somewhat obvious that pvclock_read_flags() must be called *after*
pvclock_set_flags().

Note, in theory, a different PV clock could have set PVCLOCK_TSC_STABLE_BIT
in the supported flags, i.e. reading flags only if
KVM_FEATURE_CLOCKSOURCE_STABLE_BIT is set could very, very theoretically
result in a change in behavior.  In practice, the kernel only supports a
single PV clock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvmclock.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 934ee4a4c6d4..0580fe1aefa0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -304,7 +304,7 @@ static void __init kvm_sched_clock_init(bool stable)
 
 void __init kvmclock_init(void)
 {
-	u8 flags;
+	bool stable = false;
 
 	if (!kvm_para_available() || !kvmclock)
 		return;
@@ -331,11 +331,18 @@ void __init kvmclock_init(void)
 	kvm_register_clock("primary cpu clock");
 	pvclock_set_pvti_cpu0_va(hv_clock_boot);
 
-	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
+	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT)) {
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+		/*
+		 * Check if the clock is stable *after* marking TSC_STABLE as a
+		 * valid flag.
+		 */
+		stable = pvclock_read_flags(&hv_clock_boot[0].pvti) &
+			 PVCLOCK_TSC_STABLE_BIT;
+	}
+
+	kvm_sched_clock_init(stable);
 
 	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz);
 
-- 
2.48.1.711.g2feabab25a-goog


