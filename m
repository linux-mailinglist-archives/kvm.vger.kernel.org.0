Return-Path: <kvm+bounces-54712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 848E1B2737D
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7614A9E33B7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23EE1FBC91;
	Fri, 15 Aug 2025 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpVcUAZo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EC01EDA09
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216753; cv=none; b=JlKqiGdaAI4vBed8VpQQU0k85BoirFMiiEeEnzF990KUXPO+75CZ+UMuGQW+yW40CJQbGbbhBCm0UMWdyuOJwXCDiZkYaUWb/GZXeHgc5Di8cOeoUnQCci2DASw8rsR+4WFk+S0hVVbbtBZTe8wH4VReIz7q5UUk8aozenBDNwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216753; c=relaxed/simple;
	bh=LCntfj91WO8jUz7s5IHbhKB5AC6FTcDEfOnPfQM51s0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rozPVx438fpuL9+qQTQN7Kxed8HXZLA4rPD/saJbbzX1NQywsHZDh80dolebO/6kukWHQl1GAo5oUzIJ1oXy24EYMRS6Y2q/xr4VggYtKn3qkqtqW/LyCFpLxJf8vNQnTZANj7LBCTl0ExqX0HtcOA/+/Ra3bClEb0GCQwQkHu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RpVcUAZo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e017eeso1536779a91.3
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216752; x=1755821552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yKPV7LpuHxf54DscfDg8szYhzWL5y/uRD3gLziYibUE=;
        b=RpVcUAZooJRyNam/5TaanJYubJp2VutesV4Be8wudSHmmwDkQqmkZ89wrfsNzCOIVj
         tPDLUqrNyKHC9Ku0MP99T7mRp4/A6x40izHuSammaqNWrLpyeDcR78UVYJrbp/fDdgnB
         i7XiEFQcHxGInA37xpeWgYBp6skhNTHMyzV38vCiGbAXCaQRmpxBgtjxUTeaGFiRay+q
         IMhd2OwkBE2I9V6pZqsJdCo6WRhwAeHx3S8xB0QfOeIHDSUdp/ab1FW37hWN+qJZd8gw
         WfOLeYaRBgaRSC1JlbRcS2zHNBKMlvJMcgytRp54bpKE/j8pdA4Gzw3+XvyOeH46fw6e
         rQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216752; x=1755821552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yKPV7LpuHxf54DscfDg8szYhzWL5y/uRD3gLziYibUE=;
        b=NKVxV8aFOZDU8Uq/c/ICfDXGNr4RKGVwQ6J9rs/244wzApWuwq4w1d58SQd3MER1Cc
         ikAUm+aHEKX03OBixaz1HENvJ1IfH0IQGdpbr1/+oiJeHNMjKYePZXbrsFgouvo0vuEi
         D+5HIO7FwRvU6I6Nhkb2NFx3P2F3RiNOdWJT0vUX/6PSfYda8BxaaSW1OE28BN/wFPUf
         KIx+PwYyLq1oN4CNxsEImsaCx9UOtcMC6H8FyXPDtCXzjzGJRhZv1A+3AlpVuLXKFbKb
         IK1dj74+3avlwAfCokmmE2yWFt3f7Tto5U1utu5MVJN29ioNV9ECMP2WfIiCQ6GsTrWC
         lWtA==
X-Gm-Message-State: AOJu0Yw4AMrQg+fB/g/BD4+dDAOe+FKcmMALmNAETzSMw2AQbtBS/Ey9
	Mb8lVK3cE3QhkwgI2/wAhi29Na1qdtwBp9z2g97dOCD1E0t3UdbDxqGIfULRj07jOnPnbJIODIB
	yQTitaw==
X-Google-Smtp-Source: AGHT+IHx6QGco7q/Svyh1zldivJ2YnlH9/HCz3WBRxb7BjTBtbIgCAz0ycOEnw++JSEa9trdl9BE0YwnK9E=
X-Received: from pjbsl16.prod.google.com ([2002:a17:90b:2e10:b0:31f:b2f:aeed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:394e:b0:31e:3bbc:e9e6
 with SMTP id 98e67ed59e1d1-3234213f914mr241081a91.19.1755216751796; Thu, 14
 Aug 2025 17:12:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:55 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-12-seanjc@google.com>
Subject: [PATCH 6.1.y 11/21] KVM: VMX: Handle forced exit due to preemption
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
index 96bbccd9477c..c804ad001a79 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5941,12 +5941,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
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


