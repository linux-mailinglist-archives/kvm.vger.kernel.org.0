Return-Path: <kvm+bounces-9581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E96C861DF3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C58571F24967
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC43157E9C;
	Fri, 23 Feb 2024 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfei++X/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F5D15531D
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720965; cv=none; b=E+3IifE9bRYWvThQp14dizO8Lf9H3igLsrMTqDxG5uvVAl24BhjQUHhcOvwgg5FZtyIejQq0cApdg1quZ7FSCPPFJbgDeOczSpfAhIYU5/btC6sgaQWWd0OI2b5dHus3EoUYk3s8oRheBgUkx3PapSZhUIoprD8XyahEBYBa9og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720965; c=relaxed/simple;
	bh=I0QVUNXtcgHX8n+zXfP8ri6kLK8vFj5GkBmrqx6hkTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fIlNBtQXCzEHdhHP5PS8ElYxlShrzeO9IfZuwiti1I7UdnThG0czFJN5KTxjIFYdAbT7g4MJud5iOWuBeoF/5Iz0yoHHE5LA8cxuQ15MP6fYX2jGdcVXFLAAj1ac6nJIO0S6wlsiwUA3IB8UOjDIxZ9ecuDO66Zpkj1K4Mq4I3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfei++X/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4e4572980so579827b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720963; x=1709325763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5BA83Ml2Mr+6P5rMV7bzjFJqA1AMsjlfbBOavKz4yto=;
        b=mfei++X/8SGIFDOL2LCuIu1hXggibnEx8AZecEBJ/Vd6TkZzzqo3zsLJyKux5UUYnm
         H6hLi6WImwNgBh+GxuoebXbCMgQvolOgHTFLBqeaSIJMh22XVTE3SeqF50iY5CW3gKqH
         /nuJ7exVV/dUt/0y8axQTlobK1/vTLiT0I+bs9AqUFf1OXItxJ/AMG+exoYjzMI7WG7H
         pisiTybLZR7gFe7n2G2G1G3Uh9azthWDhLmtE3JI2DGqciFVfE6PT//zsX8ExmqUZ+nx
         qLpNsJ9u42wUFbewIr2hSLu7J/LQovikjBd0RlwFe2TkgwxOr/GgPcj/jCD68ABmlDjj
         Q6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720963; x=1709325763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5BA83Ml2Mr+6P5rMV7bzjFJqA1AMsjlfbBOavKz4yto=;
        b=pmtFbuFDO8NqqNcTEcIfhGKKguD8oqHJWnY5xFFLa6wEIIxjVWpdI8HlvC8ACZH0et
         4fIzOF+s4LuGTFR7mKSkOknMZmpou+7b/WTyTT5hPYU8zlZ5Emq3lT/XMti4jMXOt9js
         pm6CsNRqkmPYwBr7kzxH1K5GkX+wB82yOeVD8Af4pcjF2yZuaB+Q/qkimu27PSfREpR7
         kkjCZhaukHv13IUNX9f5lCWdDH92DueRvJkkGeC+DR5r8iZsOZ+Qe0kRnoT3AXfWARAD
         MtONpx6t6ZdQOSZaPOi+uQj6YroMDeUvQ85a0gxvgzfG3oOeeEmSLFaPwePmTg5l0aeu
         IMYQ==
X-Gm-Message-State: AOJu0Yw865omUJMp5DZzjV8xqCFi8DeO+LpeTs4QeXinbUEKKOz1SFOS
	PX8hp60NIBrnhpAXGInBREQWC/vz+/aquGcazVMrIOGUYHBNuCRMC/AdiTSR2jjiQ2wanq8ccIy
	peA==
X-Google-Smtp-Source: AGHT+IF6noekl4xL/9jHPYxwalCxxEyfgFoPNHuQpPMbIgWGu3MhiabwvcM3s3NwiWHJzCCpsnEGI9goKxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:179b:b0:6e4:74d9:6a3f with SMTP id
 s27-20020a056a00179b00b006e474d96a3fmr76652pfg.1.1708720962721; Fri, 23 Feb
 2024 12:42:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:29 -0800
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-5-seanjc@google.com>
Subject: [PATCH 4/8] KVM: SVM: Clobber RAX instead of RBX when discarding spec_ctrl_intercepted
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

POP @spec_ctrl_intercepted into RAX instead of RBX when discarding it from
the stack so that __svm_sev_es_vcpu_run() doesn't modify any non-volatile
registers.  __svm_sev_es_vcpu_run() doesn't return a value, and RAX is
already are clobbered multiple times in the #VMEXIT path.

This will allowing using the host save area to save/restore non-volatile
registers in __svm_sev_es_vcpu_run().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/vmenter.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 0026b4a56d25..edbaadaacba7 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -350,8 +350,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 */
 	UNTRAIN_RET_VM
 
-	/* "Pop" @spec_ctrl_intercepted.  */
-	pop %rbx
+	/* "Pop" and discard @spec_ctrl_intercepted. */
+	pop %rax
 
 	pop %rbx
 
-- 
2.44.0.rc0.258.g7320e95886-goog


