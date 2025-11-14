Return-Path: <kvm+bounces-63261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5372AC5F482
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AA3854E4DFA
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C90C2FC88A;
	Fri, 14 Nov 2025 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1W6hwCM/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256182FBE0F
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153476; cv=none; b=WgKx7KcmvtayFsIKwD5icFE33ytl2n1dQPq2GfGPTDV214fNgB1OcPMwDgNQJ/yZ1QoTwIjazdllv8YPIPrp1Rve/eWvvSVsIc70k076hr4u0zJjT8E6EGR9QiOhuOAjQAKVtucqwFBty9JLB/0fjalxA1UGJ54yISKGexnoYxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153476; c=relaxed/simple;
	bh=jdSKjrHVw1kD1z76pWRk/bHYsHbnRs+JKfYF1XRkQzo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QLPnViQgsXUMqpC3U12NmzgaxHCMecGfcGES8JJ1G7SqHuUlV3+UiV50JYBknzNWP1U3p6xc6M03GJkOwWm62ie7pCeTNzGdHK7qBk5OA8Ec6CFk/hhcl1Y+z7HzyUKgIMoP4md+HHjXIWmwe2NDzD5I4w18l8lSu4QgaVYRqrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1W6hwCM/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso3199928a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153474; x=1763758274; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wt+ZxcJaGvnwjfF/rLmeGe7gA9vGkxC3E/uhiQD8M/M=;
        b=1W6hwCM/eG1OhU/QjDZuZ00gxSmq8zgrOqBNh9czaB5d/YyX4zFOWkcYlrx6AC9PDX
         +1ZF8mLg0Ict6jVfjg+pxToeKSUEPu7LrH+4MGW6NwcqHmrrGqKAIyYV3wgk293ArKp7
         QFMP8XCD4eqJhGXJRbP1FdjorHEB4aUt1nKWjZESLeu3e+7lnyVGvu5jDPdxDn67+hxg
         NnbeuOnwEzjiHLEbBRcPxYqnggOjMVkSb+dN5t1EBPH2s0rTmogNfggfbX7pXUfYD0yj
         qB71yaEdaFcttH8yRDhZB4tYtfVGY4hoez4IHXx0zv+PTyZEbqytIMU78ZRZKxCAKsyG
         2dXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153474; x=1763758274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wt+ZxcJaGvnwjfF/rLmeGe7gA9vGkxC3E/uhiQD8M/M=;
        b=U4tlnBn4dt4c+80dnAw9m+ZG7v32hStVSMueyEuDD1it8L5o9L4ltjk1D5HNP+0HvR
         EkXgKb345tegEGqkwXlyknPuUBvlzR2U3fF3yLO1Ilb971bPMTjZttKAiKGQ7qHJqXIv
         iiymJHFYZ4kW1GSRLOPADJE0NunH0WZsE1oqpaq7KGsCFpDemH4mZx5c68pFaHOLDNXC
         RFlu7fth1vj3a7ZtS40Ch6iIwlUrn3+07rHnoF8Jc0RMan/hO3u/BsLGDsWMZ70+81C0
         PKmElAoE1ZPSGLfgP7VzC0ESnU51tg2KlZFDbgBcTo/OuMqHTurGfe20Zi7zlU9Cs4iG
         O5tA==
X-Gm-Message-State: AOJu0Yx8iBQCHgJ4h/VuKY+nN9gRP3fK/CKgJU/0O/rnDaJ9cdSCJ4qv
	gS2Pek80isFyFPNQDNJEnfReNNXojv/XWaklTj9g/J5jVcjX/SDelh4NaxIhcFa8cTHWhKCOth8
	U0UB6FA==
X-Google-Smtp-Source: AGHT+IFSmh4ECM5Q1Aad6ErQWiXaaDVxfSOpqlZDqCobX4yTDVATUvY5RN64yqr6jZOToVh4YCUBsShQCqw=
X-Received: from pjbbb18.prod.google.com ([2002:a17:90b:92:b0:33d:69cf:1f82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e185:b0:33f:f22c:8602
 with SMTP id 98e67ed59e1d1-343fa6373c5mr4978131a91.26.1763153474411; Fri, 14
 Nov 2025 12:51:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:47 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 05/18] x86: cet: Use report_skip()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

report_skip() function is preferred for skipping inapplicable tests when
the necessary hardware features are unavailable. For example, with this
patch applied, the test output is as follows if IBT is not supported:

SKIP: IBT not enabled
SUMMARY: 1 tests, 1 skipped

Previously, it printed:

IBT not enabled
SUMMARY: 0 tests

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 0452851d..d6ca5dd8 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -59,12 +59,12 @@ int main(int ac, char **av)
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
-		printf("SHSTK not enabled\n");
+		report_skip("SHSTK not enabled");
 		return report_summary();
 	}
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
-		printf("IBT not enabled\n");
+		report_skip("IBT not enabled");
 		return report_summary();
 	}
 
-- 
2.52.0.rc1.455.g30608eb744-goog


