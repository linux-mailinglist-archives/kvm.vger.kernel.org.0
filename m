Return-Path: <kvm+bounces-48019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BAEAC840A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45F24166741
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B812E21D5BF;
	Thu, 29 May 2025 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J0fS9Ld5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6723421FF2D
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557192; cv=none; b=i/+BmAw3ax4I3xnjl5yHvyuXCRSOTGBBQLThksejhOmY+Dhj6s4jgMQTckOUYgDkvj4SiuDp3ISTkxMBBZOYb50Vi/lZ68UjkOm6cRzjBP6Dca/Cv4AX9X41T7Ttb1LjdUzC/jn6HG7mx0yTobJOf99C9fsKoeACn9KPzq4OPQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557192; c=relaxed/simple;
	bh=kTJU+BCpy+YfnmNVK0XXos503sjQaoFOT3vknQpOyIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eMPF//fJGKu/EYl9+abJg1d4EG3ema0yGBqYanep+97tWgaajJCrsZ7lSwGG872ogC4k2y8pYlTrsiC8pJhC2C4zSPfTgXxsIkAcdQ2ImZVnJyX00yrhygabeEJioxQExuEZt9Uy8xQFJ6rbYzwS0NS75OsYr+a1PtZD1W1UcQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J0fS9Ld5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26db9af463so1570237a12.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557191; x=1749161991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Nbpri48BJbTJkPhI+6+t1fCLMj96eqwMn5c+krAapnw=;
        b=J0fS9Ld5qWs0H3IQXzxFzURYmX3S9eVM1OGO6iuzIAfnvh0A/jVP3NprEtDVPvpaj5
         pMCiYKfYWBgCHnlq5lxmYdNyJRjpui/DbqdZM897ThuMm8IFDhJF9eSonRbCvg+1iUUc
         sqAi/yZfKd6AmuCRbNj98a2eL1H0mcd5bAAjszlEOuUBL4PhFH6487Tz+eHfqVAYaLQZ
         Xtm189rBPXOVvJaaZLxOuA44JKiTP2trtJ32muoiU7506SHk/452zgj3yORfoSuD9nHD
         GhhGklYAnUf83z9Ti0eQIxBNouDhk6MHq6NofOYQv03J0pdWP1t25NAPnnwe0SOotwbW
         YfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557191; x=1749161991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nbpri48BJbTJkPhI+6+t1fCLMj96eqwMn5c+krAapnw=;
        b=SOdpQQynp5g1YiOO1bbapTWDMO0d7E1h8HDZwDP2QmSEn1OhYrI2oYnFlUJpa7SalS
         EuzPKjYkb35rudAW4I3nK/18tHHBD6CQ3LPtREaSb1wIyBdK0WsEzjBIz+i5CWHQN6+D
         E8NqP0dHgzcjtGTcRPnawL+ldxPWtBPD0anvMoWHXfBSCWyYKsvBrvDbNW14waWpV0Ew
         b34pAXhvrJeZMhjyhrzDvX7QZGWOiULn4A4nHAZm667YpaC/d18SQwgO5DHw03v5H2UL
         9pryhU4mL4b20SQTbG8npgs360iIhiox1+U344jVASUZARScjzlAvYtRMQ8t8kVfhRhK
         SI4Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1XLlOl8XdBxfTbklDZLOFE5nI2L3g+RhN1PhH5wJaepDoDqlvEJ2LYkzIBAIE9gS4AKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRvs7K/LAxNbueKyv2KzxSMAf/9ajUz1GT+tGsFQ2rLmxlVOdD
	oaHf+eO2e7CgG+gqJBTQTAZWs0d2drYLkiYY3TZL/O7gChFU2rvM5p+ZNj/eYDcYVPvpm8kU60y
	inDi1qg==
X-Google-Smtp-Source: AGHT+IHuwZNfPgyrnwyADF8g95T4zavwWZW00oX7NuXupAAgJ0OLZRFru6H+XVBmJZXEVD6LLJdmi6syi64=
X-Received: from pfblt12.prod.google.com ([2002:a05:6a00:744c:b0:740:b0f1:1ede])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:46c4:b0:1f5:7d57:830f
 with SMTP id adf61e73a8af0-21ad978d702mr1874768637.33.1748557190764; Thu, 29
 May 2025 15:19:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:19 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 06/16] x86: Add and use X86_PROPERTY_INTEL_PT_NR_RANGES
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a definition for X86_PROPERTY_INTEL_PT_NR_RANGES, and use it instead
of open coding equivalent logic in the LA57 testcase that verifies the
canonical address behavior of PT MSRs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 3 +++
 x86/la57.c          | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index cbfd2ee1..3b02a966 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -370,6 +370,9 @@ struct x86_cpu_property {
 
 #define X86_PROPERTY_XSTATE_TILE_SIZE		X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_TILE_OFFSET		X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
+
+#define X86_PROPERTY_INTEL_PT_NR_RANGES		X86_CPU_PROPERTY(0x14, 1, EAX,  0, 2)
+
 #define X86_PROPERTY_AMX_MAX_PALETTE_TABLES	X86_CPU_PROPERTY(0x1d, 0, EAX,  0, 31)
 #define X86_PROPERTY_AMX_TOTAL_TILE_BYTES	X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
 #define X86_PROPERTY_AMX_BYTES_PER_TILE		X86_CPU_PROPERTY(0x1d, 1, EAX, 16, 31)
diff --git a/x86/la57.c b/x86/la57.c
index 41764110..1161a5bf 100644
--- a/x86/la57.c
+++ b/x86/la57.c
@@ -288,7 +288,7 @@ static void __test_canonical_checks(bool force_emulation)
 
 	/* PT filter ranges */
 	if (this_cpu_has(X86_FEATURE_INTEL_PT)) {
-		int n_ranges = cpuid_indexed(0x14, 0x1).a & 0x7;
+		int n_ranges = this_cpu_property(X86_PROPERTY_INTEL_PT_NR_RANGES);
 		int i;
 
 		for (i = 0 ; i < n_ranges ; i++) {
-- 
2.49.0.1204.g71687c7c1d-goog


