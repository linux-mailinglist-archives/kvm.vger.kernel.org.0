Return-Path: <kvm+bounces-9579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B80861DEF
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EEB11F22FB8
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE14153BEB;
	Fri, 23 Feb 2024 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I7Hxh3uX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE314F9F3
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720961; cv=none; b=pgOKpceQHISxH/ZDN89TFqHRjZ3OB6b7S52CAmmyGusOL+bM3uDms0cMTJd2f2ek9trsJX/a8mRe/lNrj7Ai6PkcmWTpyuy/+uiCwnErkSz6i2LSBAyDxZQE+T9IAA77a58DtxxjvPuOlJ/TCC1PfKIj/z8HqFYxFnMmmNwwcgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720961; c=relaxed/simple;
	bh=5TYRB9geZwbqkO8y1Zhk51uKaBiKt/CcTaK+FICMgNs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UG7UMbfpHf1mkf5VKldpPIrLerlP0OLdt78Btd4mwa8mgSqn8nwG3l2PB6iUDczvAfVQHljWtiaulpM/vLFeJHbmgxNiNkWA2DiQrKDNbEuk3h0weZLep59c6gtAcQDBCM9z5Rq5cYoeVxLnBL+DWikxVslgf2h9WD/9CAVKejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I7Hxh3uX; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso1444265276.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720959; x=1709325759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VjNX97VdvJmEYHLw9j+I1sJUr3uD5daxjuOHv2NtViI=;
        b=I7Hxh3uX8BnJaemgx0Njltxn68vW0zYIPjlZ/bw9KPcduCDk80NHhx8k30DSpCh/9d
         dq2CfWXUjrr1N43UKvhpPlJtS261/DJBWNTulG19Ekfl0r3Ppxy9ZuV33xhMqtUqNzzd
         +KVXHjDHTzoOKqA4O/Q4lyTz4Icby/+iqMh++l+Pa4fkCKQWMHpibrPMrGjIMjPeJQJF
         8D/0Cf+I8Aj9MwsyRgWg85MZs6vwW7PSFdBJ4Ydv0wfeBPC5xwnjFIDp8xPl7rA0WxaY
         MXYcTfDaT1XiPq5sqiqkZN2jmj41vVR4oINpWmlJ8EyJXql0y9qv9xKb4PXEdgV7n2xO
         ULNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720959; x=1709325759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VjNX97VdvJmEYHLw9j+I1sJUr3uD5daxjuOHv2NtViI=;
        b=D/JsOFj5TAiCkQbgO7BTfOJpVe7JlVI3CUdLVtw8gVwpeYpJh23KNj4R0pVPn0IRJC
         VpE27gbhR7mfhivjkmdHjL/4CyeBFpyrPsZ0+IEdPA4FwXMALCVyMaxphg/MAoSvg0EW
         wih4DUvrY1z11V+DsqF4dkxsK2YwSSRGuFnEs0kx2pFcIAG/Gom3IEOUo2UcAMaECItE
         FLI3kHR99tW7iZdymQSqISe+APZXnDEBjkVoDFaBLFXFZGQdON6VwFQN094Gcb7j3a0u
         cSIbGngrYvb9iAfvSp9j1blz7aPKo1dMUhnnE+eh0aJ7SqZVRG0GvjwtKKtiJ3Q8drsw
         ICmg==
X-Gm-Message-State: AOJu0Yydom464nGceDmU9KySN1ux6r9rWkwfD2BBzx5AvCaOWlbyVxUp
	KoG4QLWJSO7qOCdxTATGtDhBsFyuMfG3zZlbFGhFMkQI3Yzf8z/bVmYrAlbKdmypKEfbIdCPs9m
	yGA==
X-Google-Smtp-Source: AGHT+IFdZpJVi5VhF+3G9bjDUkDjPsA338hhzQ0X8pi1uif6S/kEVgB29+ZuBuPCDHNwZfB8yTq4+HxfzSI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:69ce:0:b0:dc7:9218:df47 with SMTP id
 e197-20020a2569ce000000b00dc79218df47mr246758ybc.5.1708720958891; Fri, 23 Feb
 2024 12:42:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:27 -0800
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: SVM: Wrap __svm_sev_es_vcpu_run() with #ifdef CONFIG_KVM_AMD_SEV
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Compile (and link) __svm_sev_es_vcpu_run() if and only if SEV support is
actually enabled.  This will allow dropping non-existent 32-bit "support"
from __svm_sev_es_vcpu_run() without causing undue confusion.

Intentionally don't provide a stub (but keep the declaration), as any sane
compiler, even with things like KASAN enabled, should eliminate the call
to __svm_sev_es_vcpu_run() since sev_es_guest() unconditionally returns
"false" if CONFIG_KVM_AMD_SEV=n.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/vmenter.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index ee5d5a30da88..7ee363d7517c 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -291,6 +291,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 
 SYM_FUNC_END(__svm_vcpu_run)
 
+#ifdef CONFIG_KVM_AMD_SEV
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
@@ -389,3 +390,4 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	_ASM_EXTABLE(1b, 3b)
 
 SYM_FUNC_END(__svm_sev_es_vcpu_run)
+#endif /* CONFIG_KVM_AMD_SEV */
-- 
2.44.0.rc0.258.g7320e95886-goog


