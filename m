Return-Path: <kvm+bounces-42325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 682A5A77F78
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 426E17A1CCD
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3535E20F067;
	Tue,  1 Apr 2025 15:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VztYwNuw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED820E6E7
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522557; cv=none; b=c56r4NHktgRAIfKgZ6kcWe7k3AZAbyheAAd2mXSuNvaJeaiEeJAucLLAcWeZqQSPi8yKdyOlFWrMHT7HsrBghBtdk3yb8DmapaXgRlBFoRuq+2dwxvEp25fMEI1KnfGuW9ntCPms4ICSYPV1p2Fl1VshgYz1Xzjw8lQlVk1C0lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522557; c=relaxed/simple;
	bh=vhm5JRAE6njpdjScz5UK8LdwniERJDF2bJGfN6xBYh4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K520uXbxvSEG7EBrXNp0Yi42BqnLi7QjbVXvmzWoTifxjdN3E2msbO5TNZF/ZCsNJd6fhDBmW3ENP8yhZ42KUVRouY7Ojh6P37HQ7TsXLqWAV+0TwE9fiha3C+EJSDj/EthUiykEsJfCb9bfGRu1aYQ3tjaE0aawIpUpoIiPTMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VztYwNuw; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-227ed471999so91950835ad.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743522555; x=1744127355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8wH3EOfhowl2ah+tdgIUAwIwU2yTiFV9tKRtcsqEfls=;
        b=VztYwNuw5CBmlg1pU1133QTiIJZWe/w5dJA5xCrGtbVVr1N/XvO3tqGbQPZjJHAEGe
         KMZMoiqY35jND/HUxDESZLQs87IvgTZzyT+QSGuFU5wz3+lgYkzZ8iL2EPmQL7WXsW5O
         DX4n3njQwEJGbw0V18WXrVY5fHFzfL5YryG67WFhiZeI+8iwU0ldaIbh7C69K5DSsCZJ
         qUwbavOIyVJ9x4ZyaY6xvxPdjb6pGhXUlSTJM0woBPRKvuh9cb8+XMrj5EU6Vl3Neqh1
         kUHfQk6PShDZxnkT9PTicnSxfJHj9DWZzYsrq3CQBcPR/ComwQIfrB7g8Q2O+V/83i+f
         tu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743522555; x=1744127355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8wH3EOfhowl2ah+tdgIUAwIwU2yTiFV9tKRtcsqEfls=;
        b=tzuVZ1ZAtbIbF2k47WaK6p7KdJR3aunNcYvSm33IKXh6ZidJFIv0AzuikquTjDHjEZ
         se56fRbWWrhev0Tb/2NkM7L8pUVx2/4F2nmcLZXydwE5bgnctXcXqlgapUeTZJz7DHD4
         hrL1naP9LdQJpcFpaH0p1DgVzZlWMV8kp+s4zpJAN9MNmbiwCoXa33pubPCSWTcxgWj2
         XygBGjPbK2X+X5VhE80rdfMuTZhop6nRtxkIBrntnwa4ZNfsPCfxPfZfKiNZtb+1lS+8
         UwCdl0BzNXHvhJZsm9fcs3AQ9+n1lUf8BtfNrAqCVP90ZwWLk9DVgxcksvOoFLr9zQ86
         SXOg==
X-Gm-Message-State: AOJu0YyNxVB/cgcvx4ep4mhyPYx2EzShGEbzsPApiQM3U5vD3H28OywG
	hCwngsHrmEGwdWJ6tR4A99kaO7WdodGtcFfg0LALQ5P8KYT5cZRx0D7N7eB/IzvDNFLu7s3C6Pb
	JTA==
X-Google-Smtp-Source: AGHT+IH86RKe+94T4SRRkFodCtx5qKlady13L3+LhOcM6mMcYsZC46a6axWch98wxyXO/mby85l8LBVLSYY=
X-Received: from pltl12.prod.google.com ([2002:a17:902:70cc:b0:226:342c:5750])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f693:b0:220:ca39:d453
 with SMTP id d9443c01a7336-2295be7969fmr50326595ad.17.1743522555079; Tue, 01
 Apr 2025 08:49:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:47:26 -0700
In-Reply-To: <20250401154727.835231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401154727.835231-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401154727.835231-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: VMX: Assert that IRQs are disabled when putting vCPU
 on PI wakeup list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Assert that IRQs are already disabled when putting a vCPU on a CPU's PI
wakeup list, as opposed to saving/disabling+restoring IRQs.  KVM relies on
IRQs being disabled until the vCPU task is fully scheduled out, i.e. until
the scheduler has dropped all of its per-CPU locks (e.g. for the runqueue),
as attempting to wake the task while it's being scheduled out could lead
to deadlock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..840d435229a8 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -148,9 +148,8 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct pi_desc old, new;
-	unsigned long flags;
 
-	local_irq_save(flags);
+	lockdep_assert_irqs_disabled();
 
 	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	list_add_tail(&vmx->pi_wakeup_list,
@@ -176,8 +175,6 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	 */
 	if (pi_test_on(&new))
 		__apic_send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
-
-	local_irq_restore(flags);
 }
 
 static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
-- 
2.49.0.472.ge94155a9ec-goog


