Return-Path: <kvm+bounces-9584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E8B861DFB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F41D51C22FD9
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C10E159590;
	Fri, 23 Feb 2024 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bpT+2oIB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2141158D8C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720972; cv=none; b=iSA0NQ7PzGXW6Yas8wf46Dv2j1Q/avClWySlpwl1n7F8M6RuYUNBQ7tOXssLQxGhktEWppNnnPHAFEXD7aiUzwudYVbNwMlnKgp4ATSGKaL1JzkhCMywpgO9RtDihS0lOlclEvLBttjSc+8gPIChgCERWjjMJzGbfODpTyL1zHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720972; c=relaxed/simple;
	bh=x8JOCHKvKb4ozY0sAwrZiWMcGVvJkG+syIMQG5Dq5oA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XE1kGwoOYdI3fLvJrtpGAdlTwL7e8nnfk67gZNzEv5KaaqzO2Pa1Lj9OSE1Uby5n1575JG1J2ylEknR027OReNHRvSk9uejvbxhWySrYA+pgEocik3o0oWmIFCC/FCWKp3rqu/4UDOffGGw+lgc0QSZ1xbCPJ0ePUZRjb0JZo9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bpT+2oIB; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so2328715276.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720970; x=1709325770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FfzNCmRZ0S/1zY2q7LR3gyLGd166iHY+ytisyKJMCXE=;
        b=bpT+2oIBtxQEZ5sHzyTYn58ZEVbChWKoqeyVU7YgevVPbxsTMBbkFVxnBJ2vrYKRED
         QVN4vsNproJH7drfX9lXIMKf5c1rouM4YcdATbY/b4sWyk/Q1ZzxlWMvoS80slMAGfra
         37omCqmeSOl548rP/Zdrj6j3fNT3aguQ97cFoprNR1E4U3MB1Q65cG7ycfMx8R7UcXLL
         NEXu2JUzFVQ6K32SstHAn4i5RWT9etYIDGIrn6YmotxX9sd8boKnROT2pkzCad9T+Te1
         JavvoSrkDBcpSRHGVAGbc5a3rngICnIHoGwNbGY6qNJ64a+CW4XuLMDVLqMzIa4W9nyL
         D5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720970; x=1709325770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfzNCmRZ0S/1zY2q7LR3gyLGd166iHY+ytisyKJMCXE=;
        b=vJGhjC0yklDo0mUkv7hIF0BvKG32SoXOS3Jrym/xyl+2n8k2goH7AzqJhb/NsfWEam
         RFEbQB6VdirEIVG5byI8/BwLBghA8ynrxOD2KOYr71CVqWkoO2TrwgFTz2C4rAwozYBE
         X3gCNnaVStt+ng1VS1kdjIFiyPU9BCcdNE3LknTMqAUiR5li50LHgIZUzDbvCuKYXKx1
         Y95XtR3nkbwnWuIerbUZV88Bgt0keodo1LCDQymaZmKQeOHnbG6bV7hCI7NjwUc8bQgC
         FKfGTiQXEl5TleFHw4oNzF1BrUbq2k1REyNjKJhFr/jGY2dVtdhJjwe5fY18rA5eh+LV
         eh5Q==
X-Gm-Message-State: AOJu0Yy1fbokyd7UPBGZostpxSr+oP4/VhOJ7NtQk7hPAgaxu38gWU0d
	5ACpfU3zSh9aaHlVw8syV54DoTmXYo+nW4Bz/BXCUbcsaSgL07adxQYtlfVkolGrWWDusuzsacF
	ALA==
X-Google-Smtp-Source: AGHT+IGV/hthBaiJp1W+WKWwI6YRWoUvbR1xriGM2Y9FcbsRPxmHxnvvDAebYds6DGtRf3myzVI02QFezT4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2602:b0:dc6:519b:5425 with SMTP id
 dw2-20020a056902260200b00dc6519b5425mr242656ybb.11.1708720969888; Fri, 23 Feb
 2024 12:42:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:32 -0800
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223204233.3337324-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-8-seanjc@google.com>
Subject: [PATCH 7/8] KVM: SVM: Create a stack frame in __svm_sev_es_vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM uses the host save area to context switch RBP, i.e.
preserves RBP for the entirety of __svm_sev_es_vcpu_run(), create a stack
frame using the standared FRAME_{BEGIN,END} macros.

Note, __svm_sev_es_vcpu_run() is subtly not a leaf function as it can call
into ibpb_feature() via UNTRAIN_RET_VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/vmenter.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 48cdba47622c..5461c23ee762 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -3,6 +3,7 @@
 #include <asm/asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/bitsperlong.h>
+#include <asm/frame.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include "kvm-asm-offsets.h"
@@ -312,6 +313,8 @@ SYM_FUNC_END(__svm_vcpu_run)
  * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
+	FRAME_BEGIN
+
 	/*
 	 * Save non-volatile (callee-saved) registers to the host save area.
 	 * Except for RAX and RSP, all GPRs are restored on #VMEXIT, but not
@@ -362,6 +365,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 */
 	UNTRAIN_RET_VM
 
+	FRAME_END
 	RET
 
 	RESTORE_GUEST_SPEC_CTRL_BODY
-- 
2.44.0.rc0.258.g7320e95886-goog


