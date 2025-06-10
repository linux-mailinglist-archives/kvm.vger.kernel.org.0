Return-Path: <kvm+bounces-48879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B563CAD4358
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B5F6176CD9
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72E92673AA;
	Tue, 10 Jun 2025 19:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G9yPsler"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FB9264FA0
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585282; cv=none; b=ZtiDOqSPdcqKSxfhYCuY8seZmmWSWU0hHsXwdhj+ao3M+LtF7ySSBo5tKnG9SVMMgowV1lhC4UkoXyzdD3auuyCk/atpndzg8+/sBRbFqdneoTFXzjkGEMe7FCyjyCKzrvHltRA1cJzcucs+ObSXqsgsVQCcUqA0YCZNikCgl4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585282; c=relaxed/simple;
	bh=8khWAmilG6i7CQJQs17Hw1ghwzvOjS5SeviDLVe3aKY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bovaj2PvxPLNPcmtzdJosQxa4fiyS3hFcnj4Nn/Jql2rXfHLHUoXc0pSfd4dTIxrSpczALEgsuDdaZKUS/Txp/XaFMUt/2AmST+oN6Cjkx5plJuWYtDM0L/im4qM4VQ23cKSaRTSiMrUVUc7uPUOTfgQl/gKwWsThRvNr4NjL6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G9yPsler; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fa1a84565so2010892a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585281; x=1750190081; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MF/Rl0NwZGttJnicH+8isp/X93B/iTvhATdre0+YfJM=;
        b=G9yPslerczGSUGMCXQoxNXqNEZpscKafh4n+sZgKXW6Mz3k0+oVtxo4S4/8mnglcr6
         3Sos0u4fPIlOrqHadj8w6kc7rmUyamzVOlvEE7Xas1pvGrSFaBB+LZ0XZtpHuUXIUEal
         2fHVGw1p/1ZF8lI8dDaz+gwXr4qmp4NHf9VZjRJLZwvGqCnZgug93f99TWbRViKmGrzy
         KA/wFMS3t7u6q4WNuP1kkoBv2SDcUPFzksk8jc1nQewaxTwvN+A4eQyWtsfFbyZejbnR
         iWdhL11uJG+9iuvRYg7FlXc38IJQcJFAMBS/wJqGABdREnAH6xLoTxyBz75h9crsXe7M
         5cRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585281; x=1750190081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MF/Rl0NwZGttJnicH+8isp/X93B/iTvhATdre0+YfJM=;
        b=Ud4IEmB5BWqXBE841/VzTu8wMlruUybBJXm8JDEaQbW8BZiChzk+UZQbLqgAjjBgsj
         w0tfB631+P5SNTf9CbqWVrELeU0Ru7FJiHIs87pLmagkMvVLfGpdrek52FklRW5+75bI
         t4Meab6JHut2+I1MPzCza80kvqHG5GCzgmPXkMc3YxuFgcQ5i4TRE3XTPElYW75G4VRS
         ZtIsk9fJqA3+J/ATwAFHNjMHURXuRQrL78tDo/eW2GjlZO+lrOoJy55c/PZEWcIQolO+
         l4kf2gF00/2T4i15WybM0M8dl2H7jMaUWk1a/ZvLKBHAzO/qs7l3iazjj9e4WjLX1Xwa
         bi/g==
X-Gm-Message-State: AOJu0YxFOxb4Iy81o95NHA4+/9s/CJ5Jm37Bzh22gen1lDJAN1HiQsBB
	MTS5GWMusPRAptj93rSTMfvn2rq0FCiANOyOcAwkrqPu0bOqByG/S3s2Raberzruy2m8ZTI+HwJ
	uP73L1g==
X-Google-Smtp-Source: AGHT+IEkvJLr+rSoLhofW3RHJY0NjGFK8EP3LnZIlq8Z2Ub/p3semfYc0JYU9v83YbbRgk97MH1+TOePQAI=
X-Received: from pfbiv12.prod.google.com ([2002:a05:6a00:66cc:b0:747:b0ae:799b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9013:b0:20d:df67:4921
 with SMTP id adf61e73a8af0-21f88f95f28mr116413637.4.1749585280845; Tue, 10
 Jun 2025 12:54:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:14 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-14-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 13/14] x86/sev: Use amd_sev_es_enabled() to
 detect if SEV-ES is enabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Use amd_sev_es_enabled() in the SEV string I/O test instead manually
checking the SEV_STATUS MSR.

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/amd_sev.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 4ec45543..3e80d28b 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -19,15 +19,6 @@
 
 static char st1[] = "abcdefghijklmnop";
 
-static void test_sev_es_activation(void)
-{
-	if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
-		printf("SEV-ES is enabled.\n");
-	} else {
-		printf("SEV-ES is not enabled.\n");
-	}
-}
-
 static void test_stringio(void)
 {
 	int st1_len = sizeof(st1) - 1;
@@ -52,7 +43,8 @@ int main(void)
 		goto out;
 	}
 
-	test_sev_es_activation();
+	printf("SEV-ES is %senabled.\n", amd_sev_es_enabled() ? "" : "not ");
+
 	test_stringio();
 
 out:
-- 
2.50.0.rc0.642.g800a2b2222-goog


