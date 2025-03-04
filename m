Return-Path: <kvm+bounces-40082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14508A4EF36
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 212AF172659
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827821FDA9D;
	Tue,  4 Mar 2025 21:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n7PXUWgh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EABE277017
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122750; cv=none; b=Ajq28ma9VHMtn9bvFF74y9YfxqCeuTlBk01cUOnkpHWImnFSPWwfGFEnP0+GYpvqm+DL1ZzUdcUyZT/ikk3FE+dq2lGzqSdEo8DHkC05yaulisoCPNZO5MtLzPsCuM9RCfTKNwOzjf2cTmeahnFglY1CwuFuCG0la9/0k7ewpyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122750; c=relaxed/simple;
	bh=R2/H38BJgKv4PeSV/QR+Ybv+Cpfei3KqlHt6w0BRbxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oTUTUEPwh0lM6n5OfgN4hqMBYBKbJOJqjCxlKjP398JX2+esTKA5Mf0MbTjRskvz2sR4j36WZUm5corezLwpXieN6HxgHzXodcEli9vb9Tosmm05km/CFxwduEIj2xBnjNn8G7Ldf6NECloeItwdMoCDH7vtrkiWMOmGjTVgicE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n7PXUWgh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fec7e82f6fso7882159a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 13:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741122748; x=1741727548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SU4dAalPyEF4QXKzc+XfhsgG1WoBqJ/cuqhTLYx8iwA=;
        b=n7PXUWghmXOmw5mjumZcT+ged524k5vwaMMjGb0IrnBaCg+wRk+LnVYr/2j4nBama6
         GK1vLFNg6+i6XhUBnpE6ET03bv4d/e2R7iK/DuqsTjNrDaks0WUVQ3EhS1nzXqV4c/K1
         waRZ+S09nTUcnRON6o3NDXSg6rCG5Dkr4m6DC5PtbOSMLYOUF/Si2iJXsHE0c4EQK5OS
         Zjlg7rqlK82BzgIHoWccX5ZLKWbiB7e5jHa1CEZDfNcmSJ9CWcJbdF+K051SlqYK2MPh
         bxeXfABgC577T/GUnXleFKgw4WF8RtYr1ZRcmCC15l3yaCPnoQNSDqN9VofFNyIvpdXb
         6V/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741122748; x=1741727548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SU4dAalPyEF4QXKzc+XfhsgG1WoBqJ/cuqhTLYx8iwA=;
        b=FfijEKWMlM8+YtR5eVcE4Cb2yfwrescS9U66u3HaTGYRmoS7TaPs81IyV6/KPHcjhQ
         SNHJ3csW/aKGOOdDh4FtUM5fycUYLYkYnZJbgn5rhqPY1YQ2HkCCu45Y5xfeyf+4oWdF
         a2bmTgEn4bE0sPlXS8wRtRpISkXS0HaAVraO/YD2JpdMFVrf8IKFipyQlxTURHjO1UWH
         mqDVWEHKrEPj4gnvHkt836R6Xxd3zqpS1ykjvIIkEiVRRVILaX7UTdbvZA671OHfAXb9
         M7DZl0E/X1ivVrZyJBp0WM/pP9ahq7DuLpxwAUgDEnoxADeS+99BaI6XgNZDrNpCwURF
         R55w==
X-Gm-Message-State: AOJu0YxtXZFoAlPMaSWolHDNBRXiNRAhiUMZtl7/PLLT0FhPqXYq5qYm
	Z916BkaqOAncPIUGgFNzFcXBRmFyN6W7mcrTJtXs6w34dleSKqMpJrwn45UXjNNi8XUiyQx/qj3
	zXQ==
X-Google-Smtp-Source: AGHT+IHTZCEyKxoHM+rzsxNY4/ZeAhBWUjUoDRE9eK9aIf2B1JTbMH2+8leV7W+6gCGhCdpJb1sDS+0kWAc=
X-Received: from pjboe13.prod.google.com ([2002:a17:90b:394d:b0:2f4:4222:ebba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d648:b0:2fe:85f0:e115
 with SMTP id 98e67ed59e1d1-2ff4979d0ebmr1121733a91.26.1741122748603; Tue, 04
 Mar 2025 13:12:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  4 Mar 2025 13:12:23 -0800
In-Reply-To: <20250304211223.124321-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304211223.124321-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304211223.124321-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: nSVM: Ensure APIC MMIO tests run with
 APIC in xAPIC mode
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement prepare/restore logic for the nSVM/nNPT APIC MMIO passthrough
tests to ensure the CPU is actually running with xAPIC enabled.  As is,
the test is effectively validating KVM's KVM_X86_QUIRK_LAPIC_MMIO_HOLE,
or if x2AVIC is support, CPU behavior.

The latter (x2AVIC enabled) is especially problematic, as AMD CPUs appear
to return '0' for xAPIC reads when x2AVIC is enabled.  And because KVM
disables/inhibits AVIC and x2AVIC when running L2, the divergence in
behavior (KVM provies 0xffs, CPU provides 0s) results in test failures.

Opportunistically make the hardcoded APIC base pointer (eww) an unsigned
long literal.

Note, svm_test.finished() is invoked *before* svm_test.succeeded(), i.e.
restoring x2APIC (if it was enabled) must be done in the "check" code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_npt.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index b791f1ac..bd5e8f35 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -1,3 +1,4 @@
+#include "apic.h"
 #include "svm.h"
 #include "vm.h"
 #include "alloc_page.h"
@@ -134,8 +135,27 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 	    && (vmcb->control.exit_info_2 == read_cr3());
 }
 
+static bool was_x2apic;
+
+static void npt_apic_prepare(void)
+{
+	was_x2apic = is_x2apic_enabled();
+
+	if (was_x2apic)
+		reset_apic();
+}
+
+static void npt_apic_restore(void)
+{
+	if (was_x2apic)
+		enable_x2apic();
+
+	was_x2apic = false;
+}
+
 static void npt_l1mmio_prepare(struct svm_test *test)
 {
+	npt_apic_prepare();
 }
 
 u32 nested_apic_version1;
@@ -154,6 +174,9 @@ static bool npt_l1mmio_check(struct svm_test *test)
 	volatile u32 *data = (volatile void *)(0xfee00030);
 	u32 lvr = *data;
 
+	/* Restore APIC state *after* reading LVR. */
+	npt_apic_restore();
+
 	return nested_apic_version1 == lvr && nested_apic_version2 == lvr;
 }
 
@@ -162,6 +185,8 @@ static void npt_rw_l1mmio_prepare(struct svm_test *test)
 
 	u64 *pte;
 
+	npt_apic_prepare();
+
 	pte = npt_get_pte(0xfee00080);
 
 	*pte &= ~(1ULL << 1);
@@ -180,6 +205,8 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 
 	*pte |= (1ULL << 1);
 
+	npt_apic_restore();
+
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
 }
-- 
2.48.1.711.g2feabab25a-goog


