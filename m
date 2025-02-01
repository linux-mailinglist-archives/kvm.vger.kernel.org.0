Return-Path: <kvm+bounces-37055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4FDA246A8
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3B543A8677
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069A518E361;
	Sat,  1 Feb 2025 02:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fjs4n93V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438C189F20
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376265; cv=none; b=KHRsi3/q/mi6Ds8dduveyVCwmO6Bpug3PHcadnxLCxDIrTGZlvpz539/MIb4ahjY40OvEsnEDpkGtPOZLgUuJT7FAQoMqRGz6H3CQc3jpsBrydlU/wVwe2M+oKWy1Tu9NiFezAi9xYd7tIBuMFlxGgOc/xSMSLXJhRlysf88Osg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376265; c=relaxed/simple;
	bh=SMb+ptqn3Y2lAemdJfa8mzgfJB25QAWQ7cmu+kYKQzc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fj7x9atIOyCmGgM/ghe9Edn2KbtZW8qREh93SXjv9cfnWv1R9HlZ4/f7LpJyFsP8a1nEySlFvCCzFNnxBuibuiglndLUvHekke20f9dciNu/W/VXFEOJm+p4Nb47BUzHMQg06NSuIHlO3bXqF8dVEWwZ+hchZZSOgvGNQdIYBtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fjs4n93V; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so7283050a91.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376263; x=1738981063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T4DEhCWG0SuSvz0a+mPR7euxpU0fSN+tQ/CkCS9MqCY=;
        b=fjs4n93VSxxTFtsT1CdCYXluuJhttoGgBXKCZxmAtD44Oii4XE++21RCHxMhwV5DVe
         /IUDAyyan5YgKx9IdDMnyPS70Zdwr1PYcaXE0T8os/NPnwHAGOEExT4VF0Rv4sON2BhD
         oXUggauFBGR85HieWhZ7xikuKMnZM3I71vUcSFNGE/jY0EMNGWb/5OH0E9rnTx3eogyd
         Yw9Y9R7Op1WuZVqqrPjIDBuGt2ZzT8l7XUtE6y8X1ChJcl0kRhrkJoOEeDreFeFKm5rl
         1FH0VtCmvvUPVjFlvjKSaQ/j7tvhmQdjdCLKVtYjHcfM82wtfp7NPqJJHcTCssoYIg+G
         4fcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376263; x=1738981063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4DEhCWG0SuSvz0a+mPR7euxpU0fSN+tQ/CkCS9MqCY=;
        b=wlkB8fOgl+QjPmH27e3oq0X1LeahIQ6qX0P9fCNZ0E7FIYgh3otknWOgy0dM5T2XR2
         ifRXLVw1P5bdQwSOzOFJbm6HIkfYu/8yuilnQzM3rmVMfu4lUWcCyBioCShvz2ERF/18
         Cr31OaE2yXBrY+UpB5ddWabjCQS+4sEzQVXn4jCL/lQra4MkP7P8SusjbtsNW9F3Op9A
         eYg8ayWMnU96pzYvJ9lKrvBF2XapJgG7i3+iR/4fbQHfZsmSeanGdqGiJ33WMCSXLsv9
         5Q3Ft4mUx3kDr5V4+wH0clbQvtyhS7hv9smqx8ihaq6o3blJtbha1mK4R6NSMF9PmW62
         XzLw==
X-Forwarded-Encrypted: i=1; AJvYcCWTT/svA8gYc37yzZ4DnFYrb0M113P9Wbk8g6YOLNPN3N7em3Gad7aIkAZn6a1Mw4/KT/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/pOld6N/TOeP4A/aaGSy1eJSKngZAp6n+yZaUVneHC3rntWLJ
	kla/KS3hUJlsB6SOVwVdNSR0OevZr7VxRjuDyB0t10oG73YGYDmDh/fSB0OxcTttwNOVYh9VoMD
	VfQ==
X-Google-Smtp-Source: AGHT+IHof1w34LjQ30XVM2gwsfD2n69eJy7Rgvm5USApfq7itvhXgigdwO4D30qo87G/8bS8xHYNlWrIUTM=
X-Received: from pjd6.prod.google.com ([2002:a17:90b:54c6:b0:2e2:9f67:1ca3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c1:b0:2ea:7cd5:4ad6
 with SMTP id 98e67ed59e1d1-2f83ac86a44mr17727640a91.32.1738376263046; Fri, 31
 Jan 2025 18:17:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:11 -0800
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-10-seanjc@google.com>
Subject: [PATCH 09/16] x86/tsc: Rejects attempts to override TSC calibration
 with lesser routine
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org, 
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org, 
	xen-devel@lists.xenproject.org, Sean Christopherson <seanjc@google.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

When registering a TSC frequency calibration routine, sanity check that
the incoming routine is as robust as the outgoing routine, and reject the
incoming routine if the sanity check fails.

Because native calibration routines only mark the TSC frequency as known
and reliable when they actually run, the effective progression of
capabilities is: None (native) => Known and maybe Reliable (PV) =>
Known and Reliable (CoCo).  Violating that progression for a PV override
is relatively benign, but messing up the progression when CoCo is
involved is more problematic, as it likely means a trusted source of
information (hardware/firmware) is being discarded in favor of a less
trusted source (hypervisor).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/tsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 47776f450720..d7096323c2c4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1260,8 +1260,13 @@ void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(void),
 
 	if (properties & TSC_FREQUENCY_KNOWN)
 		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	else if (WARN_ON(boot_cpu_has(X86_FEATURE_TSC_KNOWN_FREQ)))
+		return;
+
 	if (properties & TSC_RELIABLE)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+	else if (WARN_ON(boot_cpu_has(X86_FEATURE_TSC_RELIABLE)))
+		return;
 
 	x86_platform.calibrate_tsc = calibrate_tsc;
 	if (calibrate_cpu)
-- 
2.48.1.362.g079036d154-goog


