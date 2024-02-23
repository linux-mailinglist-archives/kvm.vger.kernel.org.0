Return-Path: <kvm+bounces-9578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74723861DED
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 149131F24D5D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0580C15098C;
	Fri, 23 Feb 2024 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RyOWud10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF75149387
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720959; cv=none; b=AG3R6CuIheCFImzdGD6pfYJHRppxGvbFQKybI1ijmpac2XmiwinHxr48BIxWPx0ldrJtG6joR//ggpaPOWz3Wq5rvu2SHJB7ojAqRvt2n4G+ccgivVJ5ZrBwPKZ8tqAT1G+s1WfU4gVqM0LglbAPl/GsVuT9elOgBN3TVTV5rDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720959; c=relaxed/simple;
	bh=6ShF5KyZmeoKeVwczIN545JawDqkwUK3No4F9ATa188=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wv1AnotGc8BLpaA5GTjKZfulwHJp7F0rM+uBUz0bSAyGqgiPs3vDPGig8SPP0GlhhQUKWoe3qaxJjir6HoWjZNLgc2FN1ZfR2lCWjW9IhhflRo7XtDwZc3ZajuhefAlH+NVWEt8bE+Ww1BpTpqtXdJzzi8qoptb3Zj/GgjYDu/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RyOWud10; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-299cae4f36bso1015531a91.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720957; x=1709325757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d647qV5YXXlk1eKRQGMECxhpXnyYK5AYh5qfDVrkHVc=;
        b=RyOWud10QA5VdBHeA7MTnjX//5DW7G102NkiFYhDmENz3W0Nm1mxEejoVYD4zJRDvk
         zJdueDtusFZLRLRn7m57h4uaZY6DJnMBzkMkxVle/eNCRx20LDz8+KrT09H4tD3s+D1e
         j7K9K+XLpdT+U1VGsft22epAZBn9WbPvCb306shZ5/6a/1Rol/Zlq3SbMIbF94Cc4UqT
         0gUA32XXwguBZVdrpzadAcF8i2+pPZia3xYGQBuDx3NAwfMu4UYKHmmqeREhaufOWLtt
         11T6UXO7IGySIs6HI7bBxNK6Cy32RHKA1NFza2m8nHXGX3GXtpNujnFbP5IYbx/Z6HvQ
         EYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720957; x=1709325757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d647qV5YXXlk1eKRQGMECxhpXnyYK5AYh5qfDVrkHVc=;
        b=w0xHg+hejccrAdgX3wxk/IpNp3ufgLMCbpyeSRfBLUSSlOBY1doe2G4ubT3LZ8i/mm
         MJrp7ixCCRRbMIfEbk6WTsR8nsc5f8NTbod45r8nPp3riPr3wZgUwXFHFKTPsUtJbL1r
         I+y7FefiKC2DwSkYRie+qAVPb77PT8CFMgfh3/wYDnXDxQOhzzM5WLI7/SbiWhAlYN+j
         5fb1uosVOr9v4jezDlbR/nr/IBHF8bQ9CUpH0TiWhFjUmRPGPjnwUEv+feN6O8wyT2Iv
         pWnkg9Hq8QRclH3rU9CqHnTuXgjSjkH0lhCQdLe8w6KvgXWFISHydRLl907TuRmNlEca
         J+KA==
X-Gm-Message-State: AOJu0YyeoSUVrZZHvf/O576ZLw/VISRAdj40hx5IE7AVPlJkJ+mMe35u
	7fR1jI58V9ZLcY8338DbIjIAMhx/eKaCd7LdPkojp1F7FO+5ldBXo8S40OUltq9RS0xVJj+JH7j
	07w==
X-Google-Smtp-Source: AGHT+IG85Eo/bKisu1UinMdZey7PLDTuVrcfcBNR6TXcGUwOM3M/DeCNU42rxbMIRizLqv1Fd0FMSNF/7gw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2e8f:b0:296:de77:56c9 with SMTP id
 sn15-20020a17090b2e8f00b00296de7756c9mr2215pjb.2.1708720957080; Fri, 23 Feb
 2024 12:42:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:26 -0800
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-2-seanjc@google.com>
Subject: [PATCH 1/8] KVM: SVM: Create a stack frame in __svm_vcpu_run() for unwinding
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Unconditionally create a stack frame in __svm_vcpu_run() to play nice with
unwinding via frame pointers, at least until the point where RBP is loaded
with the guest's value.  Don't bother conditioning the code on
CONFIG_FRAME_POINTER=y, as RBP needs to be saved and restored anyways (due
to it being clobbered with the guest's value); omitting the "MOV RSP, RBP"
is not worth the extra #ifdef.

Creating a stack frame will allow removing the OBJECT_FILES_NON_STANDARD
tag from vmenter.S once __svm_sev_es_vcpu_run() is fixed to not stomp all
over RBP for no reason.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/vmenter.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 9499f9c6b077..ee5d5a30da88 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -99,6 +99,7 @@
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
+	mov  %_ASM_SP, %_ASM_BP
 #ifdef CONFIG_X86_64
 	push %r15
 	push %r14
-- 
2.44.0.rc0.258.g7320e95886-goog


