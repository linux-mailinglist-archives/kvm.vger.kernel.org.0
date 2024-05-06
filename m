Return-Path: <kvm+bounces-16622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D5C8BC6D2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6743B2153E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60E313FD98;
	Mon,  6 May 2024 05:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cn7Yu3xf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F8A140394
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973447; cv=none; b=N+X37BSVSfppNdeGRTUzL2aqvLIoTxEDpXI/HwGVCGSdqG3DeYSfTv2PTypxVdfzpG4Pku2ektDVwNn4MNuC/LAARS364j27ADz3nY/hTEaCQZUz3J60fHKsW06EtvKrxqMC4do8o6YY4Pq7yVEEkw9coA/6abFh22p1Qv4Uxko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973447; c=relaxed/simple;
	bh=D6EHc+MYlAdfc+o2kFM6Dz8Wu6ceRyZIaL0nJDVlFs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ORiHHrUfPpamjykwwkqXDIiKduwFOYDDRMMXKLkL3vaKtx67j+k09Y/asrGZwPFV/qzF8wluMBn2iyziYQyOTcJj7QnrLGCjZOrNdJFk/hqDw3Ybx71HhUlpAm8KEtR4vWUZ8x+7uE42DWAk1FZxwVs5GFd1z0brhte5vIAKewU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cn7Yu3xf; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de59e612376so2632435276.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973445; x=1715578245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vZwVNkZ7iHV2DtWwDK6XMNNX462mPlO6E/QLNlxVTJw=;
        b=Cn7Yu3xftHun7haGYlQpy0Z8wmoeA8UDgdqeJ7X+rEfVm8GrGtWueKQRLApJyfz6FM
         A1xGdoczzojXsP6SjWytj4zvQVDEEZ5JJQL/4fx8/rUXkOzEagDiGGZV6bYXZ3E7ZPjC
         T54YVBWsZiWXoj6KsSPkPUOKGjNKLYsguJrY4bSMYPGIf7xXqO20xiIQab18uwysuQUw
         89FXPfx+7pJlZIWotII+kB0LEUH4vKbO5d8rDFsg6YYbFnoedMUt+/yQRsdXMhcOhmX9
         QePAZOstZxyJSyUBsyd9G90Gb6wxNvJ31/WYvaUV6NG8gCw+kpE4F7Lj+Psz3k4kBlj7
         mcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973445; x=1715578245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZwVNkZ7iHV2DtWwDK6XMNNX462mPlO6E/QLNlxVTJw=;
        b=CyJkvHO0U+IxnsFYbodV/vNo73Jlm/nEHHF8CY79I3lSt8kgY9SAW/LuQDcUyxTKSa
         Mk/krkX+w3J0SB/OquASbY2LpKMO1lUFvRIG05LbQX5+PR64Wmk5hGnotnnzRugre8El
         2eAy9BjcxvIUMMBfYzf4hpKWGDHyfQ1ssZJwAjgQGQfH90BncaftO0dnbSOfAqBwlJPe
         5L3gN05LkJKkeE0i8R7FTmq3r7evZ6HBYfIGQGwojQmGsLU0f2qdUISlW5b0ZseLDrhR
         3jQBsVoLLdqUmIEseD3THOON5xlpynIxTgFFjqvgal9YwnohNj8JmyaQLRegbdqmEndx
         bLnA==
X-Forwarded-Encrypted: i=1; AJvYcCUDt16KQiRYhPAcG7F+FdzH1VrvMLgQnN1VbIem2IjYe1Fkl1eP3yLhSwlupE8udSop2m358+bj3+QY8/1jxJZieOnQ
X-Gm-Message-State: AOJu0YxCiyNEy7QcDnDAMsYdPCiLe4cXW2C6DZk6iQsjv5JGNA5W3RNm
	7TpFl/knkpkXr8bhCCsox4M1eX5Nj0SG0BZPwfg6lmMw89LpTx0oIZnEoE6hUnhnLp8V1opG7IQ
	+h8Ub6A==
X-Google-Smtp-Source: AGHT+IHV8DeDAP+63pdULtUxntT51GOqOHE4s8M6z6I/ms6H42UOjlzX/pkKqA4Peh3G9g5w/0sXJhQIynAt
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:726:b0:dd9:2a64:e98a with SMTP id
 l6-20020a056902072600b00dd92a64e98amr1061195ybt.9.1714973445580; Sun, 05 May
 2024 22:30:45 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:35 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-11-mizhang@google.com>
Subject: [PATCH v2 10/54] KVM: x86: Extract x86_set_kvm_irq_handler() function
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

KVM needs to register irq handler for POSTED_INTR_WAKEUP_VECTOR and
KVM_GUEST_PMI_VECTOR, a common function x86_set_kvm_irq_handler() is
extracted to reduce exports function and duplicated code.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
---
 arch/x86/include/asm/irq.h |  3 +--
 arch/x86/kernel/irq.c      | 27 +++++++++++----------------
 arch/x86/kvm/vmx/vmx.c     |  4 ++--
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 2483f6ef5d4e..050a247b69b4 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -30,8 +30,7 @@ struct irq_desc;
 extern void fixup_irqs(void);
 
 #if IS_ENABLED(CONFIG_KVM)
-extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
-void kvm_set_guest_pmi_handler(void (*handler)(void));
+void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void));
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 22c10e5c50af..3ada69c50951 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -302,27 +302,22 @@ static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
 static void (*kvm_guest_pmi_handler)(void) = dummy_handler;
 
-void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
+void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
 {
-	if (handler)
+	if (!handler)
+		handler = dummy_handler;
+
+	if (vector == POSTED_INTR_WAKEUP_VECTOR)
 		kvm_posted_intr_wakeup_handler = handler;
-	else {
-		kvm_posted_intr_wakeup_handler = dummy_handler;
-		synchronize_rcu();
-	}
-}
-EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
-
-void kvm_set_guest_pmi_handler(void (*handler)(void))
-{
-	if (handler) {
+	else if (vector == KVM_GUEST_PMI_VECTOR)
 		kvm_guest_pmi_handler = handler;
-	} else {
-		kvm_guest_pmi_handler = dummy_handler;
+	else
+		WARN_ON_ONCE(1);
+
+	if (handler == dummy_handler)
 		synchronize_rcu();
-	}
 }
-EXPORT_SYMBOL_GPL(kvm_set_guest_pmi_handler);
+EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);
 
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..c2dc68a25a53 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8214,7 +8214,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void vmx_hardware_unsetup(void)
 {
-	kvm_set_posted_intr_wakeup_handler(NULL);
+	x86_set_kvm_irq_handler(POSTED_INTR_WAKEUP_VECTOR, NULL);
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
@@ -8679,7 +8679,7 @@ static __init int hardware_setup(void)
 	if (r && nested)
 		nested_vmx_hardware_unsetup();
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+	x86_set_kvm_irq_handler(POSTED_INTR_WAKEUP_VECTOR, pi_wakeup_handler);
 
 	return r;
 }
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


