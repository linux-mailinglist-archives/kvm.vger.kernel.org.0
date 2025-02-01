Return-Path: <kvm+bounces-37061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 864ECA246C5
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B9123A8855
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FA01C3C11;
	Sat,  1 Feb 2025 02:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RJUUCxcX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E441C3BFC
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376275; cv=none; b=NBbhM3yP/NyYALI4nJgU0bYe2EuQTpFaOrYryOlPAQ+osSXS5KEmp4uxEFi5h/zChA15U4q4GVpLKdhgEdop5rnK2e7G6BDieXfAltfExjvS0tJz5bQoCAf2VV2pgxjFlL/XaZ+vVBud7R+4+AC7IRoQeP+t7+GReydroJjOBjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376275; c=relaxed/simple;
	bh=MHFjgcDixq+MEkE5s8mB+CTWIGx9I1EGKDIGAXqaNs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EIbc//LFHeUEvcKk4xaLli8mpCHRUhWT2J4dsgPqm63EcN6ppqw+nPZq3hfFE9eB6KYDQJIO0zYb0/mX2N1DLfdLaUwmjLWviQN1v2miNZCZ/y0SEzf7yXUQ6vU0zWCMtGYehFtt7lHF8MCGAklZjORaaMra0OzX2E9DqxZ1hOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RJUUCxcX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so7281617a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376274; x=1738981074; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLts4lXwUIqNNu2uIA1UT+VV0O42NNK5wDATllLGuXo=;
        b=RJUUCxcXVPVK376KPUS32yvH34C3xwr2s+nsiLKJPwXWXKIGpFlRIcLKcd1isn41Xc
         sTjXeli6Oi3KaEAP6xxY/jBToyEPNgBJ8bCtYu6hevil03oL+zGTHR+q0naPIU4teNjQ
         QY5wBjD3riUWSotk+i4P7+ZwIRyl42zS7ILs2Ejn11OphsB+oDZp92BlHcMt8p9XB29y
         fUu5Ba9tcafiv4dfcc022FOrDyJJyrt2hI0HRtqK3KRVbSof6yhdctw8KWlvVBxwwy5M
         1PcQOFgOZFysgFzUpiP8+ihOE5XmTgOLo1VOAnPzwiVrsLGwM4Qgi1o7IoD6Qx+RioMw
         q3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376274; x=1738981074;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MLts4lXwUIqNNu2uIA1UT+VV0O42NNK5wDATllLGuXo=;
        b=XMquweG0MN45A0G7p1EdMtXtMh+UpNhSqYMC1Rqqj6GsrBHyP8gbn6O6YOHomAW6xi
         +P93A57AgTAeJdn6v9sSAFJSikDjg31iODHZs3oTUA6pKuankhGU6Ng1+CQAobSjF7t2
         jy25ILDAZHUzE1uHK8ASjRb/cYdpO6XX0REoFK8Xnzwg5m1FftywWkvrd1CS2gyMGgbS
         dpTnBFbrKxpBjd5jQWASL2IWqucUnHZcg6NRdcTFKgUHDYg0RpObVlLxs3UIu2l1WbaN
         VDZLbeuzmezVRSO5r+SWWiAK/3QGaOwUpHgVOPzEyvGjaKjbOAycmtVLBZQpi8pxvfwJ
         YTpA==
X-Forwarded-Encrypted: i=1; AJvYcCUXjkLztuUG06u0hLrXRjACQ8tOg7aqqHmeeJ5xczddsSfMV/TzZF+75E2TOfM156iffmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPKChA2kIvCWv9YXDTzFbOtandvKEM9dr6+eDr3In+qwxFkpzC
	rhe5eqWJYVqEdYoiwAmNw371U8kL7AaBWshQQn70QtXAow9S0EBP33ThQH02fto2FNEmlyOrEro
	CWg==
X-Google-Smtp-Source: AGHT+IFZkSSDE4sQNSYE1P+oxZtfHJOA6RLwDBSraCmTI0kfGCTz9b39MqhkWv/tuyQdm2uggkOJw5pWH7U=
X-Received: from pjbfr16.prod.google.com ([2002:a17:90a:e2d0:b0:2ea:5c73:542c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c4:b0:2ee:d63f:d77
 with SMTP id 98e67ed59e1d1-2f83abd7ccfmr20755900a91.9.1738376273601; Fri, 31
 Jan 2025 18:17:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:17 -0800
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-16-seanjc@google.com>
Subject: [PATCH 15/16] x86/kvmclock: Stuff local APIC bus period when core
 crystal freq comes from CPUID
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
Content-Transfer-Encoding: quoted-printable

When running as a KVM guest with kvmclock support enabled, stuff the APIC
timer period/frequency with the core crystal frequency from CPUID.0x15 (if
CPUID.0x15 is provided).  KVM's ABI adheres to Intel's SDM, which states
that the APIC timer runs at the core crystal frequency when said frequency
is enumerated via CPUID.0x15.

  The APIC timer frequency will be the processor=E2=80=99s bus clock or cor=
e
  crystal clock frequency (when TSC/core crystal clock ratio is enumerated
  in CPUID leaf 0x15).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvmclock.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 0ec867807b84..9d05d070fe25 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -106,8 +106,18 @@ static unsigned long kvm_get_tsc_khz(void)
 {
 	unsigned int __tsc_khz, crystal_khz;
=20
-	if (!cpuid_get_tsc_freq(&__tsc_khz, &crystal_khz))
+	/*
+	 * Prefer CPUID over kvmclock when possible, as CPUID also includes the
+	 * core crystal frequency, i.e. the APIC timer frequency.  When the core
+	 * crystal frequency is enumerated in CPUID.0x15, KVM's ABI is that the
+	 * (virtual) APIC BUS runs at the same frequency.
+	 */
+	if (!cpuid_get_tsc_freq(&__tsc_khz, &crystal_khz)) {
+#ifdef CONFIG_X86_LOCAL_APIC
+		lapic_timer_period =3D crystal_khz * 1000 / HZ;
+#endif
 		return __tsc_khz;
+	}
=20
 	return pvclock_tsc_khz(this_cpu_pvti());
 }
--=20
2.48.1.362.g079036d154-goog


