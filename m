Return-Path: <kvm+bounces-40081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09703A4EF35
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:12:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CB3C188BD63
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD60B277028;
	Tue,  4 Mar 2025 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xnzz1AF+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82876260384
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122748; cv=none; b=kElzjMNB6o1pn0oglBDixsn9ljNA7MqqJCLX8/zHZOqLewvK9Mq2twyRQ5pAuu+E+PJtihjn1DqgN9DpRED9pJVeeo0t8BFYJ+dYHFFBhP/O0Z0/tEEWuc7SomPe0A+JnMeV/OildnSMWfPwENSmYp0YiS3npdFQKcQK2jwSYK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122748; c=relaxed/simple;
	bh=y6qgGnd5ZMoajYRCODWj9m3PLCmcLug0Er/BJ6OhDDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AWYvajeOlYLpyLnL+eurQsYGPsadHwVahwBS5ry0KlFj0tNBBhHG3pNrmVp4IfWge+px8WHi1mpI9i0RHTPefPC/ze+emLVpUYqyYZ7W2kC/7cJv3oGKaz0X5QDvV7WJueQkpqTrppZZc/BAhgZbTQgXlOVOUAM4nebp+WzJ8yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xnzz1AF+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22366bcf24bso85127385ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 13:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741122747; x=1741727547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CyBKYw9sqcQ2PVLUXrhMEac3+jgRASv0Gacs/HY5HgI=;
        b=Xnzz1AF+Hj71UebGAzl8WYh9ekdHZLOtVspucE2QUriwRbq3pQx486M7oGP9QFQry0
         IBFcPRQ0Q4GbR8QO21aL0uL2pDefLb7N3zQenMw2BiPVRzo9foagG2byqZJQCz+VJk5Q
         woKrJt4ck+YoELRnCUeVBP549pjH+GzSsr4T/ir0f0WLA3auPR3fXbEaGrMmkJpfRDVR
         sWuTdAEajvejj7NqB8OJzhR534IDfrOtrOxVjfMx3zQ1hvTW336loGVyH6RJeS+vcywQ
         KX3O2K8A3vVQFdsb4aSnHPg178vnfBNf1JXDPb8aTb/p6cSZg9QjFqZd70WLZHVfa+Ox
         RQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741122747; x=1741727547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CyBKYw9sqcQ2PVLUXrhMEac3+jgRASv0Gacs/HY5HgI=;
        b=OlB89jmeiTwmYdwWbYUccMfVm649ySNNfro4yKk8n6TnBxmE171fSDSsmebCnnWDNb
         ZXEMCItqP4avMFN/t2q0Og+O0bw7RkDN14dwzNgnQZakN8dMsHkInKOCRq/fY4mWSDLW
         FWxJFZljRVhIVJ7msIux5fDxgU+YuEEdL24/lZjCPssaCyuQWYWNFp9K87ell8nAU5UT
         rmXYdySfXz49XXZ8NUGmOheoxdGpAe8sKmE20LOXd5OFnOVuKCwCL2tm24ld8PoidxB3
         IRf9gWiSpNSKakTfU3I6EAhL2r6XwWmIGLZLZ4AOI1XChUKDeZmgWY0JwUo9WfgDhrIn
         6yrQ==
X-Gm-Message-State: AOJu0YxGnqDBxUbpnqqNygJYXD9KGOmMY1FLtRcrcIfHa8CwoUHKuysG
	Fx0SSzAFqvC1naV8WtU4dtsTsGZcIMYAZbPGcH68KB8RMgktEfKNPSVmqyv2FXn71Wl1LJ+EnfZ
	Mgw==
X-Google-Smtp-Source: AGHT+IGmSTx5c3/S+Y9KMi+JOF9wy1Pe2LphtMtr3kQ4xVFlvgN903PenIMduyCCWEbfrnfg5SOMz29D1rw=
X-Received: from plbkh14.prod.google.com ([2002:a17:903:64e:b0:223:432c:56d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec90:b0:221:7343:80f5
 with SMTP id d9443c01a7336-223f1d8430bmr8488655ad.53.1741122746766; Tue, 04
 Mar 2025 13:12:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  4 Mar 2025 13:12:22 -0800
In-Reply-To: <20250304211223.124321-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304211223.124321-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304211223.124321-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: apic: Move helpers for querying APIC
 state to library code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Expose the helpers to query if an APIC is enabled, and in xAPIC vs. x2APIC
mode, to library code so that the helpers can be used by all tests.

No funtional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.h | 21 +++++++++++++++++++++
 x86/apic.c     | 20 --------------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 23c771ed..cac6eab1 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -5,6 +5,7 @@
 #include <stdint.h>
 
 #include "apic-defs.h"
+#include "processor.h"
 #include "smp.h"
 
 extern u8 id_map[MAX_TEST_CPUS];
@@ -67,6 +68,26 @@ void apic_setup_timer(int vector, u32 mode);
 void apic_start_timer(u32 counter);
 void apic_stop_timer(void);
 
+static inline bool is_apic_hw_enabled(void)
+{
+	return rdmsr(MSR_IA32_APICBASE) & APIC_EN;
+}
+
+static inline bool is_apic_sw_enabled(void)
+{
+	return apic_read(APIC_SPIV) & APIC_SPIV_APIC_ENABLED;
+}
+
+static inline bool is_x2apic_enabled(void)
+{
+	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD);
+}
+
+static inline bool is_xapic_enabled(void)
+{
+	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN;
+}
+
 /* Converts byte-addressable APIC register offset to 4-byte offset. */
 static inline u32 apic_reg_index(u32 reg)
 {
diff --git a/x86/apic.c b/x86/apic.c
index dd7e7834..b45fc9c1 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -10,26 +10,6 @@
 
 #define MAX_TPR			0xf
 
-static bool is_apic_hw_enabled(void)
-{
-	return rdmsr(MSR_IA32_APICBASE) & APIC_EN;
-}
-
-static bool is_apic_sw_enabled(void)
-{
-	return apic_read(APIC_SPIV) & APIC_SPIV_APIC_ENABLED;
-}
-
-static bool is_x2apic_enabled(void)
-{
-	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD);
-}
-
-static bool is_xapic_enabled(void)
-{
-	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN;
-}
-
 static void test_lapic_existence(void)
 {
 	u8 version;
-- 
2.48.1.711.g2feabab25a-goog


