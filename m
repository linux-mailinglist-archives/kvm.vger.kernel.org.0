Return-Path: <kvm+bounces-54735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B413B273D8
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D604602392
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94550202996;
	Fri, 15 Aug 2025 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uF9B6J0t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C601F542A
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217564; cv=none; b=cePgiyoyNMemMD9v68nNDP4uZ1gtTgZppZO3pigMspZqQMhX5gXvIqYq6wfqw2vsP0Apfi43hzQ/LNkJcsgE8txq7KBLxq68a5unZ+0D2SQCngaZFN7b8QPQupWXbhd7SXQzVoRiakWj2QW3gTa2crybjU48UnbtVrqSrrEps2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217564; c=relaxed/simple;
	bh=YkeK0+sBHNvehHuXgNtAfc5wNbib/MDo60witDlyAkg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KXf7drVOQJD4pjV5ajXRPrhad9MkB/xWYM38l0QIzkMCzE1a/1fFNQ+wHYZosSfXyMsrW4T0dig/WZ/BgVwg0swNugkHLFm8SiATaQwE42u0ffPYijyrlNAV4pJHYn/fWdDahSllPOq9EGrpg1U8qiLQxkpHGf0XGZgE8XLbZCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uF9B6J0t; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24457f42254so31935815ad.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217563; x=1755822363; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PYvY2Sr9Oc1f4jEaee72DUuWJudzSEujeEG9ujSrm7g=;
        b=uF9B6J0t6SIqZAaYkSShyzgbqDWOmIzTExRGcU78MzF2vMi399dDxZcUjj8gSLGHhK
         vjWGEjwI0sG343M322JH8oC6mxf9ztEXd17qpNxaCQGci5y5KQZdjej+zdqlCWeDYrTt
         dejyRG1baqfICGlbM6c6vmIra/ah5yFyoR2LSk4Y2b1eMCkbYBk1uUgwJrGMINBp0lae
         4Yg8zzN3xu7jBr0e/yPZN93EFwXh6Kw17qaVzy1T3l23D69EQ+RkyRCVfFy5oIkBz1JH
         q0q5HjeJV5yyzqFPe4cFDdzTeOYl61xOUxVucHjKrwB0jR0hQQaLaWqrt85+VovAT8Vy
         riNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217563; x=1755822363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PYvY2Sr9Oc1f4jEaee72DUuWJudzSEujeEG9ujSrm7g=;
        b=XrEYROzXy1eqSscDwr2vXDDMWXooaeNkw0LVB1CkotY94xeqOI4VDuv8IDPlyqKZXS
         QBXUiVu3smj8+Fw3I4xv9D4pItWf6CVml1spTIWDU/14VxrLJeHD1JLvRFnvxqCpuUEY
         5ht1EIo6Ev4oc03A6frIJbEOC3vkYYsVs+3IVPsNLM+2gaTeduPi3aa9YgewHdbrk+lL
         cgs8bZPfH0T55J7sVi2KRjas3vYRMwbUuHLJdssMTAJYmW5VgbNRjmYDhdG06EYNo0TC
         Qr4buS3+xASXPVWDM4xLF/iakAsBn54FMfyHzmbE6YkRjy8cvc5zSouvM7jsKY7TiMZw
         U4qw==
X-Gm-Message-State: AOJu0Yy+zjdm6DFgspHXNO/Z7IfuvKzVWvV5bHiwCBrD0MtjVgUs0I8O
	GUc9GWIwjSB4x4QUOtvIDR0rfLADWMgim97iZ02W9AXv6Gj4vixGnC06/6x0D0KCCYdonxWkYfX
	eFM0QLg==
X-Google-Smtp-Source: AGHT+IHsjF30T9KKGUIEbxZ0Ho5Yny/Gtu6qUWgWc0dpfdUesJGzLVo8k9vpXMQxwjUaaSSe7yJ3zq8qLk0=
X-Received: from pjc7.prod.google.com ([2002:a17:90b:2f47:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b4c:b0:23f:f3e1:7363
 with SMTP id d9443c01a7336-2446d73e7c9mr1820395ad.23.1755217562684; Thu, 14
 Aug 2025 17:26:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:30 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-11-seanjc@google.com>
Subject: [PATCH 6.6.y 10/20] KVM: VMX: Handle forced exit due to preemption
 timer in fastpath
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 11776aa0cfa7d007ad1799b1553bdcbd830e5010 ]

Handle VMX preemption timer VM-Exits due to KVM forcing an exit in the
exit fastpath, i.e. avoid calling back into handle_preemption_timer() for
the same exit.  There is no work to be done for forced exits, as the name
suggests the goal is purely to get control back in KVM.

In addition to shaving a few cycles, this will allow cleanly separating
handle_fastpath_preemption_timer() from handle_preemption_timer(), e.g.
it's not immediately obvious why _apparently_ calling
handle_fastpath_preemption_timer() twice on a "slow" exit is necessary:
the "slow" call is necessary to handle exits from L2, which are excluded
from the fastpath by vmx_vcpu_run().

Link: https://lore.kernel.org/r/20240110012705.506918-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32b792387271..631fdd4a575a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6027,12 +6027,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
 		return EXIT_FASTPATH_REENTER_GUEST;
 
-	if (!vmx->req_immediate_exit) {
-		kvm_lapic_expired_hv_timer(vcpu);
-		return EXIT_FASTPATH_REENTER_GUEST;
-	}
+	/*
+	 * If the timer expired because KVM used it to force an immediate exit,
+	 * then mission accomplished.
+	 */
+	if (vmx->req_immediate_exit)
+		return EXIT_FASTPATH_EXIT_HANDLED;
 
-	return EXIT_FASTPATH_NONE;
+	kvm_lapic_expired_hv_timer(vcpu);
+	return EXIT_FASTPATH_REENTER_GUEST;
 }
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
-- 
2.51.0.rc1.163.g2494970778-goog


