Return-Path: <kvm+bounces-21513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E83B92FCDC
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:48:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB9B81F23DB4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 14:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3999C172BB1;
	Fri, 12 Jul 2024 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nc75KCV1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAE171647
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720795726; cv=none; b=Ku2ds848lvO/nTOWeKGdpeJuAGvyXWgwLGMs1PcGFdvQ/XRl2J5gNbzuzVjlcamvS90gSuiaO9MwjgDoNQMyBTFbq40T0794hTZVIwaDSKFBz12Lam7i7U6LrnPPZ8ETNakfBmGMxPamwVTZ55s+L2jv2rYrSoS8Eu2X1VD03iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720795726; c=relaxed/simple;
	bh=sBKA5wOw/8saolKPMgpYoFqxWMdR+xT7lkIyZhUM21k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=W6WkVNNd4swPPpcYUs521/6oppW+bLcYS1jHD2QxqEOPHGqTlhNkKvKpYAwVJJsM7qHj1E3KVMjvIPpJVg13C6BuHt0Y6En2W+2THq0cHrWd/t7I6VlvrJX9x1r7UzsKP3iRZAVAHNdQ/bSka1q4utOWzgNQEjuOawQSpMzVego=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nc75KCV1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1faf6103680so13312545ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 07:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720795724; x=1721400524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Csfae5IaHZ5irxSaRzc6R9nWOwPBAYNbr4c2pq1OV6o=;
        b=nc75KCV12kq06iCbspQcK78Ftb+LDGMgWYufirajxwey3MK3kmO4NHwd3zZxGVntOj
         ID0r0oyr5l5FMv2RvH33yMUyryEttQobC9wmKAtnbs5j/guPn2JeYfKGgsBKH0I1cjYW
         TRluBYIO2OiQ5FMKaE19Ai1+lHcQCHkAkgw75qMv1V7JQFDagsThB78aETJQFxBU9rVn
         5kVn3wVqnNfWfYAZHahw1v+fAli4sChHLOsLtXMeJeVRC3nTMgn1mtMRUpN0/gWz5YI0
         wKjVKrcqvrHdTh5dPrPqYreVF6xhuwXWzhoDV3tci+zx9JKAZmiiot6d5EDqquCeteXY
         xHtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720795724; x=1721400524;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Csfae5IaHZ5irxSaRzc6R9nWOwPBAYNbr4c2pq1OV6o=;
        b=Y1fyDIDWx11C92Fp2aU+Z8ozCO0wKXrSfz7boBsZJon3L98nTAvNFnoUtDM4l/bLY8
         +DYVZHJspkTzu6vu/A96J/r0pasmF2/zvnIgA2DOQ42xhcVmMl+z5GWaPLvcCDoMT1X5
         bdY0wDCkKFCbuuTtGhpll2Mv7fFGrvLhKw3p9gnS2DP/gbe8IRcnUpx7rj20+BULUhtc
         d6HnVjjxPT4fQa5UlZP/DjoGb135W3rk4QsgXpndjityWp4GpRs/ScJbkayrkWIbvdQ8
         G9JKxnqgjORtmoT4lLhPGVIiTzof7Uw3Jms8Sn6g5Pj657DpRAfq605hCMs4Y9iJNmXA
         n+Gg==
X-Gm-Message-State: AOJu0Yzapc9Yg9iGcjR9Bb+8kvvLr8rZemF/QpY7QBb1j7/ODON3BdZ/
	m8HwFWUgnZmFA0XBMbnT57ifODEVty1YGEJ3WPB/5aYtP8qOQL5OmP2sSg7Yz8wcefsOg6rSvqG
	INQ==
X-Google-Smtp-Source: AGHT+IGvE7hgPp4Cir+q8LOh2zwHROYE/mdrf2LLP/Npae94bB6VdUWcyzYzH//G6efie7ReQDu/31WzW6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f691:b0:1fb:57f4:9057 with SMTP id
 d9443c01a7336-1fbb6c15adcmr7214375ad.0.1720795724256; Fri, 12 Jul 2024
 07:48:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 07:48:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712144841.1230591-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Suppress MMIO that is triggered during task switch emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+2fb9f8ed752c01bc9a3f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Explicitly suppress userspace emulated MMIO exits that are triggered when
emulating a task switch as KVM doesn't support userspace MMIO during
complex (multi-step) emulation.  Silently ignoring the exit request can
result in the WARN_ON_ONCE(vcpu->mmio_needed) firing if KVM exits to
userspace for some other reason prior to purging mmio_needed.

See commit 0dc902267cb3 ("KVM: x86: Suppress pending MMIO write exits if
emulator detects exception") for more details on KVM's limitations with
respect to emulated MMIO during complex emulator flows.

Reported-by: syzbot+2fb9f8ed752c01bc9a3f@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This is from a syzkaller report on a Google-internal kernel, but it repros
on upstream (obviously).  There are unfortunately an absurd number of upstream
reports with "WARNING in kvm_arch_vcpu_ioctl_run" as the title, so I haven't
been able to hunt down an upstream report.

 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 994743266480..47bd8a9fdb21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11803,7 +11803,13 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
 				   has_error_code, error_code);
-	if (ret) {
+
+	/*
+	 * Report an error userspace if MMIO is needed, as KVM doesn't support
+	 * MMIO during a task switch (or any other complex operation).
+	 */
+	if (ret || vcpu->mmio_needed) {
+		vcpu->mmio_needed = false;
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;

base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
-- 
2.45.2.993.g49e7a77208-goog


