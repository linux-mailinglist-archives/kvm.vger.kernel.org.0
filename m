Return-Path: <kvm+bounces-54714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34123B27384
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB8539E4BA4
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC1E20DD42;
	Fri, 15 Aug 2025 00:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TvqmdVpv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27FD1FF5EC
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216757; cv=none; b=OfkgNIRmxpryyUYqT2gETcjpuw4Cxjlyjv6Vj0OGsktYnuLm/bqsfOVONDeJQxj7Htb4Wrnn+cJ7U4xKo/ySij3T6qCjfc8F0vfwMxPzD5urJoglO7wtjalRWkUPYtq3tglHgId8Bn+uAuveKMMDfoqNH6yJFQh96jokKs7p0v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216757; c=relaxed/simple;
	bh=K45y4oY618XxqPpW0fSd+M48YvCVJ5OhxcpoKJCPJLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fIFyDK6Aju3Z65M/1PKkn55IFgVhKrLgHhhcOMuS/MwG5hCTHp9m4b4fZf66dckipXU6+MaKXMLEDs4dMmaTNzNnZspIJoANJ4FpMhORtd2cMye5sGy+E9TzEM58ZrWA2OQENyFG40+3bMAc+avxqi571Dd3pr/tRRL/uNZnV/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TvqmdVpv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e1f439so1473543a91.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216755; x=1755821555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A081K7Vxl6mjJzXEGmaHtEMcM0O3QUXdDAu/aDF05mY=;
        b=TvqmdVpvY/zWAxyxp+LBS78F/dqrCLAIpPNVxEBDvgOtf27t6irErUMg0vqp7BHHym
         XQBtVNP3raT1m7x3iu7VHCA+kbchYgOkOLU6JTgaGKofTjcn8Ns5E46Edq0/SKd1C+oj
         WlURRKFt/OLJFmlWIekzk2svqgB+QACHkunewOINHnyWebx+MT9ngR15A97nzGzp6mkx
         cNjDnDOCBw54pSg4oSAqDSXapefr+jMb5BUjuXm+7Noe/SI0TGBVMwmEjU1IzGJNVEcG
         +VfCF3HRYZKP4icpnDbpo6mOFULGhqs3rGe3jP+gI2P4Z4AAvM+2606i/9Qe3+l6pPPy
         RClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216755; x=1755821555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A081K7Vxl6mjJzXEGmaHtEMcM0O3QUXdDAu/aDF05mY=;
        b=BGiK8uhqUY1Eo2aQqFq4qemjXURNjl6d/pujOnyXxRjqgBC31kepMbkjDF/y3wZ7mq
         PysFyze3qakuR5ZDvYd9WZJGIeUak+fX27S8qAAByAIEbVILnytdn9SCd7fK/Vln6AYv
         n8DfxHy3ytBHb6TarskcCULigloUZ31aql6iOGwXL6Qu+3PZgbaFLDufbvMDtQx1RgQD
         A/v4pcUjpvhsBdct3fXONe7PVpjXQweLbkJ4xjVZazJZqdkc4IXWIoDOYZXMgbymU8lT
         +1OfCGsRG/+5CA9MlhkqjzmRdgJvMHr4hZxb1R9Eznoa29L0He3lSpp4b2D21KZJV8Pp
         0G6Q==
X-Gm-Message-State: AOJu0YxUjoAuXPGZa0muhUzk458MH7bJ/dweOABba7cfXnsUvGquzFzy
	onEw7csUvFevNFsPK5fw2I+eV6GwW6/3R/P19/fDXhR/D4RPAJNVXbRxoPMpEAFe+NSMuvlMylk
	Qgs/QoQ==
X-Google-Smtp-Source: AGHT+IHyQTBLqAZEkEEr74CWBCFhJKsIaas1PzPmgFEdWLst5iOyF6eTrA8Q7itvt8DfCaBEBiBohqtDZ/4=
X-Received: from pjbst7.prod.google.com ([2002:a17:90b:1fc7:b0:321:6ddc:33a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:278a:b0:323:28ac:3c59
 with SMTP id 98e67ed59e1d1-32341ec4ad6mr240224a91.13.1755216755117; Thu, 14
 Aug 2025 17:12:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:57 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-14-seanjc@google.com>
Subject: [PATCH 6.1.y 13/21] KVM: VMX: Handle KVM-induced preemption timer
 exits in fastpath for L2
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 7b3d1bbf8d68d76fb21210932a5e8ed8ea80dbcc ]

Eat VMX treemption timer exits in the fastpath regardless of whether L1 or
L2 is active.  The VM-Exit is 100% KVM-induced, i.e. there is nothing
directly related to the exit that KVM needs to do on behalf of the guest,
thus there is no reason to wait until the slow path to do nothing.

Opportunistically add comments explaining why preemption timer exits for
emulating the guest's APIC timer need to go down the slow path.

Link: https://lore.kernel.org/r/20240110012705.506918-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18ceed9046a9..4db9d41d988c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5948,13 +5948,26 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 	if (vmx->req_immediate_exit)
 		return EXIT_FASTPATH_EXIT_HANDLED;
 
+	/*
+	 * If L2 is active, go down the slow path as emulating the guest timer
+	 * expiration likely requires synthesizing a nested VM-Exit.
+	 */
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	kvm_lapic_expired_hv_timer(vcpu);
 	return EXIT_FASTPATH_REENTER_GUEST;
 }
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	handle_fastpath_preemption_timer(vcpu);
+	/*
+	 * This non-fastpath handler is reached if and only if the preemption
+	 * timer was being used to emulate a guest timer while L2 is active.
+	 * All other scenarios are supposed to be handled in the fastpath.
+	 */
+	WARN_ON_ONCE(!is_guest_mode(vcpu));
+	kvm_lapic_expired_hv_timer(vcpu);
 	return 1;
 }
 
@@ -7138,7 +7151,12 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
+	/*
+	 * If L2 is active, some VMX preemption timer exits can be handled in
+	 * the fastpath even, all other exits must use the slow path.
+	 */
+	if (is_guest_mode(vcpu) &&
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_PREEMPTION_TIMER)
 		return EXIT_FASTPATH_NONE;
 
 	switch (to_vmx(vcpu)->exit_reason.basic) {
-- 
2.51.0.rc1.163.g2494970778-goog


