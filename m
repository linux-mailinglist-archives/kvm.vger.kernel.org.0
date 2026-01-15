Return-Path: <kvm+bounces-68212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 15634D275CF
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F5453308F9A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B483C3D1CA4;
	Thu, 15 Jan 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kjNrjhea"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774063C199E
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498478; cv=none; b=RT2X/eT4n00R4GvhEHJnLRssdKpRNQEzZJBCCP+v/q/vOQFqrpfqhoxJPf/tvQxWBXN+GV0Vo902Bw9Uxm8JiSHiaaxz29FwXgfaTlLVx5EZ2wCh2qcXT5XHD5XJI9AH5TT4OCvbDrieg83xKEcgCVYPc+ma77EWbbsfhHh4f8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498478; c=relaxed/simple;
	bh=XILqFVmOsaW9D6OaK0VES3uHC4bLdcRi1kimGLm++So=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pGjnmb5pLMd69TLhwcZr5lb7dspxNh0ebP1yI67nWACc+rCPWw8Gis3R/2wuFnd4Y9M1/UaHfujFcmjClIoi3CfOagM8ulQ/0PDzAg+S9YEiZmLVlT07dSBGeX4l7ATFeb0GeyR7qfAW8Pu5CsEzMR93ejHh/eszZvNqc+8Kx2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kjNrjhea; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f8e6a5de4so11470975ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768498477; x=1769103277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vronXy/BR0vEwHHg+fBfUJp9qb/Nw8vk6MBcNfoFOWE=;
        b=kjNrjhea56eEcbQmXdWswXfhHj8tOp0lVbFQlYYT7Q/8cBcDPpZ8JnCnwsJRaL0W7I
         MQj0o/JdNZZ2pNdtmQ6Ggm2+gTCQW/htDQdHuZwKCRWcGN6ImwO2FFaQd+zc6aMI/StO
         tpVWwBKzuxYOt/Qk5/pWfO4OzFr2gy9lYUuahOh5AWPDe2cp1UcRp0OvJf7VOFZnx6Zq
         OIpAdvD8N2rxaUIzGub56QKaS1h/99FbBFodqmXlE3GQxr+sGmfJNnX5YaCzzemqyXab
         WwxWXXhjEo/ARcR9yjz1f8jDS6szjhEMWg05fTQ/jXc0tJtsTuCBX0/LiLpKdkg6Htqh
         +DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498477; x=1769103277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vronXy/BR0vEwHHg+fBfUJp9qb/Nw8vk6MBcNfoFOWE=;
        b=jnJJE4CWYJyJZnwZR589ktxMvyKRV+gReLobwzoH1uX12Meya+i7joIWbwCFfUcAkJ
         gLz1gqn8LZ+lTyScTTWva19j1JdjC/vu9NtGR0pQvfFw2JwMA4psFLezCXHt3mopIy+C
         g/vFg1Ga5fht+0CkvxuQ7qLX7ZrhoVkS53tzzVWB+/qfa16Q5673mu2KeS4pVVQeRLGK
         L00oTSLJ/p0Wp0lDPXKMPjQd2JamEH51UMhnMHRFocJWsORE68JeoeACSkh7RrOGA7rJ
         EIxUXLC/rJ2RkwFqhuAznr40+5mY786rrkQF7e0dSzSsKjBj3U2BjNzqkOki6SwesIhB
         AY1g==
X-Gm-Message-State: AOJu0YwEU84djYSRyWffV189rc4dOwAPy71el07phZX3BCs31BVila+T
	/FXDdw7octPjlIH/7PFpJ6XkLQVgLxUAHVemd1jk5r8yLtIzrtma8rpjdp3WRuoaw1Km+IbSote
	pIW4d+A==
X-Received: from plyw10.prod.google.com ([2002:a17:902:d70a:b0:2a2:f514:2116])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40cc:b0:2a1:388d:8ef3
 with SMTP id d9443c01a7336-2a71754385emr3353485ad.18.1768498476771; Thu, 15
 Jan 2026 09:34:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 15 Jan 2026 09:34:27 -0800
In-Reply-To: <20260115173427.716021-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115173427.716021-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115173427.716021-5-seanjc@google.com>
Subject: [PATCH v4 4/4] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's filtering of GUEST_INTR_STATUS when generating the shadow VMCS
bitmap now that KVM drops GUEST_INTR_STATUS from the set of supported
vmcs12 fields if the field isn't supported by hardware, and initialization
of the shadow VMCS fields omits unsupported vmcs12 fields.

Note, there is technically a small functional change here, as the vmcs12
filtering only requires support for Virtual Interrupt Delivery, whereas
the shadow VMCS code being removed required "full" APICv support, i.e.
required Virtual Interrupt Delivery *and* APIC Register Virtualizaton *and*
Posted Interrupt support.

Opportunistically tweak the comment to more precisely explain why the
PML and VMX preemption timer fields need to be explicitly checked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 34d54edb2851..edbe99a85286 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -118,9 +118,10 @@ static void init_vmcs_shadow_fields(void)
 			continue;
 
 		/*
-		 * PML and the preemption timer can be emulated, but the
-		 * processor cannot vmwrite to fields that don't exist
-		 * on bare metal.
+		 * KVM emulates PML and the VMX preemption timer irrespective
+		 * of hardware support, but shadowing their related VMCS fields
+		 * requires hardware support as the CPU will reject VMWRITEs to
+		 * fields that don't exist.
 		 */
 		switch (field) {
 		case GUEST_PML_INDEX:
@@ -131,10 +132,6 @@ static void init_vmcs_shadow_fields(void)
 			if (!cpu_has_vmx_preemption_timer())
 				continue;
 			break;
-		case GUEST_INTR_STATUS:
-			if (!cpu_has_vmx_apicv())
-				continue;
-			break;
 		default:
 			break;
 		}
-- 
2.52.0.457.g6b5491de43-goog


