Return-Path: <kvm+bounces-54732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91038B273D6
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D6723A4A9A
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB4A1E51FE;
	Fri, 15 Aug 2025 00:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/WYLAKy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759201C5F13
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217559; cv=none; b=YoxJbNXPQ9SOmIRc1aFL9Pr5g7w9RwXGee60abA0BYoSz2VLTsywjLQI3CgyhxJjkB2TWYviganZttiRij59sC1JiOsJTftbypMCNW3d4mZ8/7vxX+iwwSuveGFLj7g1qZrd8oeO81xhLeM+fC0LZeiuVm4pfrmt7SYIkfgjKrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217559; c=relaxed/simple;
	bh=8dGhxK/JkgmBijADhNtAV6zAXFcteW9wwepKGar5Zv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mc8PmunMJmJaC8tPJFxhItvpO9LWGYKLpNB9x1B87JEgBMcnTZsbTH7NvURb+avAJfXoBiae33e4kz0VZRXF/OmVLi8TOH0BdpMHa5yrJXIYeEt0K9Rlw88DChFeCSkZVN2p4KYL4mh3/zRqQin55uVmg4TINbtAas9+l1m+UHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/WYLAKy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471751e03aso914401a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217557; x=1755822357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cctxdklEYGo3fsEjZ/qF2IryNO6hLou1BdjReTJ9XXQ=;
        b=x/WYLAKyPzs2CL6sPf0o7Ll0xvt5/KwbBtdEANFg3BKB9u39F511GvVNb0U86Pzlxg
         h4AaShVchL0WznGa4RG0EPyssNlikjIObdFzZZnCjaBIWKTgHvsteKuHKkrrXicA+fcp
         SYnrTatOAsxjv8h33TNrJYRJ9WfJRvhU3nxGOb97MuUzqU+v9QRniYyHwcHX4otIRLVl
         EIZPcRkR7ESWl50UxeCrUCmf35jlLuDzmXTBSZ1C0yRDjdCtwWR07zwLIOUWO4ZJ6zD3
         Y1w+ONHFYGYi7M/yPU+q1+scZdaaed1Y8NXtT+uQiQPBzTsBCURoDRrJjVp0oc5qhfcg
         M43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217557; x=1755822357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cctxdklEYGo3fsEjZ/qF2IryNO6hLou1BdjReTJ9XXQ=;
        b=bN7oPux+cgPoBU2ihVXfM14cAv74GNn0VqxJ7/nNkj3p8HDQXV/fDzXa4Fe115C3h5
         bGy/py0BT4B61BkV7FXn08UKpsRgPiA2u3VbppbjsrxPUAB5ixPXqJ4bHxYWxDPVPxAz
         pgb6ulMHR5x6Dp8cmlY0FRzuTs1CGOX6nuDp5yax6IAfgzYtz9ER7v/YU4hBwHd8+oEG
         ZpbcrOV6FHQ5TdfOuCqidfwZjBCNJDY3sgg4pwjYfg8UHcBzUOop9O9ur8BLF5kMGL7Z
         wB2sQN4XSH+tXK8CkoiFuyHJSXFEDEpbBnLW3gM43BZLsp7/Lt4qOqHjx8f8DgOEhl6e
         4XmQ==
X-Gm-Message-State: AOJu0Yy6W85iSDeUfiaTGzR2hFsE33Y5VXDf9+9Db+lQP/xZxMQIrh/R
	FiWR7degsIO3z/kQUZrVi3XQaE2o8QE2wbfGS6bXdQFJMpkpD7yjI1EwZeg5J7fxvxbkKO+HyaK
	niixDuQ==
X-Google-Smtp-Source: AGHT+IGvH9IFV195y28sIIwLG3aGx7vkoPdbO7saKYfTqg5i8QnHd16IdWLXrxZFrfkhUCUiw6yuZNROGVc=
X-Received: from pghm22.prod.google.com ([2002:a63:f616:0:b0:b47:35f:5e80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748c:b0:23f:fd87:4279
 with SMTP id adf61e73a8af0-240d2d889f8mr371554637.8.1755217556680; Thu, 14
 Aug 2025 17:25:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:27 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-8-seanjc@google.com>
Subject: [PATCH 6.6.y 07/20] KVM: x86: Snapshot the host's DEBUGCTL after
 disabling IRQs
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 189ecdb3e112da703ac0699f4ec76aa78122f911 ]

Snapshot the host's DEBUGCTL after disabling IRQs, as perf can toggle
debugctl bits from IRQ context, e.g. when enabling/disabling events via
smp_call_function_single().  Taking the snapshot (long) before IRQs are
disabled could result in KVM effectively clobbering DEBUGCTL due to using
a stale snapshot.

Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed16f97d1320..22a191a37e41 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4823,7 +4823,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10782,6 +10781,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-- 
2.51.0.rc1.163.g2494970778-goog


