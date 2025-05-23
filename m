Return-Path: <kvm+bounces-47466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 541D6AC1928
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FCC57B8F94
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547B826FDB7;
	Fri, 23 May 2025 01:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FDGXcOrH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7424225D534
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962041; cv=none; b=YkgaQB05JJczxHqmoCOA4vdC+DJCA6UKOyOtAShadja/pDdg31GWG0lhQlbsPVzSxflgL/tuYhUeHJBBHbXGJdRKTM7o36tR6DQfJAfLSnZCbk7k64BOwFyGY1NSiB7jlVgChv9Ny8ZL+19dbLBC/Xk8hH+lZe4TRu92T27s8mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962041; c=relaxed/simple;
	bh=nHqa6WlMR0U01OJANRFGYwjUMNRNK2ND6QPMEXp4N18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XMF2B3mkDc1i2OS2y9Sin6XF9E/5V+jAfU2Ictb5/OyYI4VDeuORNOTudRiNQszT9Rqpb2e3uBrLK6X9crNB350nXjKZ6Q+nI3qXzNsjtO9L3N5TIAmcbqhW0gscpKZw9KmQJjvaD2aQoyq7TVBrpjHdTddEqsnHK+ziK/nGrrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FDGXcOrH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ebfc28a1eso8131904a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962038; x=1748566838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CxW6KKsPctpa5xxKfQSk3XBX60R5QhwquqFgbTrtuqU=;
        b=FDGXcOrH27gT47oZjpE7XjMJkn0KZTdi4f7vcxdbQSOgrhv15NKDihEwOwN10IDAOQ
         MZOu87NZ9tBZo6nrg0e4KiWbmSnWmMkQh0O49JCB4yUUetsbiOCZ/XutWJthlaYprBlh
         3vK0OD0zZl2S6UZgSePL6WV0znzPln/EcUE6a2Y0QVS6wqSFMoCRRnK5dawX855j736P
         SQEL/sREfxJAJ8tjDS3AFcrqZsU+v/15VF/Upkdils7J8tMWTXtQPuZeXpxeF55DS5RT
         5s7ucZvJnhFtpD8GaEcR55uczo8yUNRAMEWlkKlyT6qgJ6QmK0R3JvfFtCtEhpEsMHUx
         9QGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962038; x=1748566838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CxW6KKsPctpa5xxKfQSk3XBX60R5QhwquqFgbTrtuqU=;
        b=BXy/JuKRzrnFKH5yo+Qjx5HlBEVGoHEYVblzLSdzn2+iRv9gkVPaptOihvLpsGfpzB
         I0AMxT/QdKJRIsm0tdw3ZP7A/wkH0i7EuRoUqxFxe9axDizcIsaqY9wsK3FARW/hvruj
         CaLcvCddoh77BkFSYPUErXhIzZ6eL7u5YUG8ERnSZXW+GcPTTdWDjYAUOMFYQpLrbG2I
         onuyRQiZtijbAX1Y66btUq+8c3yeO4G2tjygwZiPUmmUcFE7RQYvG7P3/Z8XWBkNGmhz
         YLe7amNKXSHSOFvh+c7g1q2VlqcWbphw+chhmCyhAATblEeP3n31k1kUlTrujBxCfmg9
         P+8w==
X-Gm-Message-State: AOJu0YwkIfCHKdTo4eJUiHGg1JGle5JhfyEkQM2igMpBbXt4IdwyBsWZ
	Y2xmLmVVh03+285dZLZyCeN/NpKjwAzYbp+ab2YzC+Pec3odtd0jFD5Qi+H40xYPgQBIF5nKgMY
	ksOYyhA==
X-Google-Smtp-Source: AGHT+IHk8lbSET1s/ssqemmnc/hWnJF6h21Rp292LM1IvL/agAUDkDm3aH+8vSocZT0JgbvOwlT/Y0l6Lss=
X-Received: from pjbsi11.prod.google.com ([2002:a17:90b:528b:b0:30a:7c16:a1aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc2:b0:2ee:b2e6:4276
 with SMTP id 98e67ed59e1d1-30e8322593dmr39301128a91.27.1747962038018; Thu, 22
 May 2025 18:00:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:21 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-17-seanjc@google.com>
Subject: [PATCH v2 16/59] KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU
 has erratum #1235
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Disable IPI virtualization on AMD Family 17h CPUs (Zen2 and Zen1), as
hardware doesn't reliably detect changes to the 'IsRunning' bit during ICR
write emulation, and might fail to VM-Exit on the sending vCPU, if
IsRunning was recently cleared.

The absence of the VM-Exit leads to KVM not waking (or triggering nested
VM-Exit) of the target vCPU(s) of the IPI, which can lead to hung vCPUs,
unbounded delays in L2 execution, etc.

To workaround the erratum, simply disable IPI virtualization, which
prevents KVM from setting IsRunning and thus eliminates the race where
hardware sees a stale IsRunning=1.  As a result, all ICR writes (except
when "Self" shorthand is used) will VM-Exit and therefore be correctly
emulated by KVM.

Disabling IPI virtualization does carry a performance penalty, but
benchmarkng shows that enabling AVIC without IPI virtualization is still
much better than not using AVIC at all, because AVIC still accelerates
posted interrupts and the receiving end of the IPIs.

Note, when virtualizaing Self-IPIs, the CPU skips reading the physical ID
table and updates the vIRR directly (because the vCPU is by definition
actively running), i.e. Self-IPI isn't susceptible to the erratum *and*
is still accelerated by hardware.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
[sean: rebase, massage changelog, disallow user override]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 48c737e1200a..bf8b59556373 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1187,6 +1187,14 @@ bool avic_hardware_setup(void)
 	if (x2avic_enabled)
 		pr_info("x2AVIC enabled\n");
 
+	/*
+	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
+	 * due to erratum 1235, which results in missed GA log events and thus
+	 * missed wake events for blocking vCPUs due to the CPU failing to see
+	 * a software update to clear IsRunning.
+	 */
+	enable_ipiv = enable_ipiv && boot_cpu_data.x86 != 0x17;
+
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
 	return true;
-- 
2.49.0.1151.ga128411c76-goog


