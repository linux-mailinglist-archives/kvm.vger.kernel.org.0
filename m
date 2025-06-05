Return-Path: <kvm+bounces-48599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADABEACF7F1
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB6893AFECF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA71D27E1A1;
	Thu,  5 Jun 2025 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZqVCLn1U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C8727D760
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151608; cv=none; b=HjYCQ/5SDtkgRZQNceV2jkTKj3bBvjQ8KdF+VYwaOWAyhMRwIo7jeY3NrfOlXb9vUlo8ME/sexj/sYD9GSJOBhuI9UoFM5YIUbuq7YXh/AZzIPR0pZ1bTXavY+tHIzJ04BoK/JXxaqJhzP0Qk9t1X6OxstUXz9/urvpPfIkZi48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151608; c=relaxed/simple;
	bh=lSZ+MvQkjehqkyIcm4vx2Pu2NKQMx4rLpcOEkY8gaqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CTnN7GpyqTdFpom5qe7UtRzZu04PFk90GNQnLoqqFaHwnisHwMOXTIzSciOk9t+ADKzL9/08rqOZnoeT11xCmnkBYNWQIck4njD3YL40Y3FcYzfgbEMlQTUlXVgo21ymCIAkDZRkMNEKXfmsvxTIcXeTRPQds/ywCm+AcqEk4fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZqVCLn1U; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so1006761a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151606; x=1749756406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RGOJuomZ2MmLI/O5NquwqDhHlVe9h7umR7iIrX27BYk=;
        b=ZqVCLn1U+/EOm/d1jf3Fr4oNUP2jVPgj7yW+bY7dNC78B9JRM+PUIlcOQdj2LWu60c
         Lb7KK8/+/SIXEumsbMMNULh1n8NW3FF4t4IEYkqOUnfkQDhjQMDOv7+y+qJsJSfhvFkJ
         NH3xV8+3m7+uc3D/PVq8R8hVzl6z2o7IkGMk2G0HkvDmuPttTu+sJpleGGS4PSSA+FPy
         IfHB9+pIK2Yjm8Ogw5XdFffmBx/bTyeeyOVX68PSYKFZF6uEnyVO3vj8f8x6DRe57Nnl
         25cfqpXaoAlGwWr+IfBUoXu42RZX4WgpujqAgxuXRyb97Nb860lVWtJdEXgajVDfXM9t
         A6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151606; x=1749756406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RGOJuomZ2MmLI/O5NquwqDhHlVe9h7umR7iIrX27BYk=;
        b=EdvVTaCTMZxHF/7KlS5v4AVmOWp5v5QZnKSNclZXu8ATXxrvD3CPKIAeBNqiR4kF2P
         smtmgSUG91TD0qL8n++ikkYEuafQjdjUxY451KOdrUaWf/gW4/hLbN10RjXlDSYytKGD
         vXgnAfzP6bYI14rk8g3Iw8ZIt/94mHP7L6CG/KaqopMawisWpem2uVQWBuvKX4JBe3U8
         VeIR2xsQw6oIwoXKFmYSut38Nq0usw8ME4QJakj6OiiW8TIaipXh5wHGw07cTg5Kt0e4
         d2I2qSCAKh3a0tdqsFge4WMQkCZZSuc9ixxfSDwhu01jqB38clfIV1l+a/faNt1sNr/3
         ZLYg==
X-Gm-Message-State: AOJu0YzBwsMM5sGGmFbtYH+UoFmhO/Idw1D+J84Fbon8+MC7M326bY14
	jZCEkpVcW0DaHZUayXM4QVhTZxWVmLdLgL+cIYgm4DgwzEiOhv23P84V2oomm74sGIJNoQg6QAA
	0FHpWRg==
X-Google-Smtp-Source: AGHT+IE6rERzDIXVclKDuZp7kn4qfkVO9nLw8zpXFVmp/4Q5+s4yMz2+MbS2citLDwPA0Csy48Jox8q8+lE=
X-Received: from pjbqj7.prod.google.com ([2002:a17:90b:28c7:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:394a:b0:312:29e:9ec9
 with SMTP id 98e67ed59e1d1-3134768f796mr1405321a91.24.1749151606682; Thu, 05
 Jun 2025 12:26:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:26:41 -0700
In-Reply-To: <20250605192643.533502-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192643.533502-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192643.533502-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86/msr: Treat PRED_CMD as support if CPU
 has SBPB
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

The PRED_CMD MSR also exists if the CPU supports SBPB.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 1 +
 x86/msr.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b656ebf6..9e3659d4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -329,6 +329,7 @@ struct x86_cpu_feature {
 #define X86_FEATURE_SME_COHERENT	X86_CPU_FEATURE(0x8000001F, 0, EAX, 10)
 #define X86_FEATURE_DEBUG_SWAP		X86_CPU_FEATURE(0x8000001F, 0, EAX, 14)
 #define X86_FEATURE_SVSM		X86_CPU_FEATURE(0x8000001F, 0, EAX, 28)
+#define	X86_FEATURE_SBPB		X86_CPU_FEATURE(0x80000021, 0, EAX, 27)
 #define	X86_FEATURE_AMD_PMU_V2		X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
 
 /*
diff --git a/x86/msr.c b/x86/msr.c
index f582a584..ac12d127 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -296,7 +296,8 @@ static void test_cmd_msrs(void)
 
 	test_rdmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD");
 	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
-	    this_cpu_has(X86_FEATURE_AMD_IBPB)) {
+	    this_cpu_has(X86_FEATURE_AMD_IBPB) ||
+	    this_cpu_has(X86_FEATURE_SBPB)) {
 		test_wrmsr(MSR_IA32_PRED_CMD, "PRED_CMD", 0);
 		test_wrmsr(MSR_IA32_PRED_CMD, "PRED_CMD", PRED_CMD_IBPB);
 	} else {
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


