Return-Path: <kvm+bounces-64265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A759C7BE1D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9F92B4EF7F5
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CA630E0FF;
	Fri, 21 Nov 2025 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TURhejT1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385E030CD9B
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764499; cv=none; b=cdZ2mU643UtG+hbS3MufP0OJlrynxX0NGaUI6RsdHta/uKpOq2lo+mPNlhp7lvrJggBAa4hEVgdhDE6ZdGmKAzxJsK92FjHKStEa/R85lzfJVLyldJvI8HOjUdmYTBv7YGf0eLb/+CceH4vZZZLIjLTLpLILCKogM9IBRkuNxuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764499; c=relaxed/simple;
	bh=7Xe3qDH6ZKzsQpPuowUY9HUcV1Hk4sOsCTpbpwGJBT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LV6iMYy3dxTheP4Z81RvfRZQWY516mV1G2TB6DS+Q34VJza/SRU4TzlT/5q28SDtQsi0d1ACY+1+puDZ1tTZeuv96rOHYP5kOBoWpjN0FH2olRA5cPhMn/whdOdp0BnikYbFZtbBa6jsyoO73hHTe80IWvuPhyckCL660ZOs+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TURhejT1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2980ef53fc5so80522685ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763764492; x=1764369292; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1mfMySPMjnmJsOaOUb/BM+KRAPsIyAYo55wsBBcQK4Q=;
        b=TURhejT1dvyi7bFcfoIg4SGIYf/svS9dS0ve13WBZBtR7K/nCel45Ckni8MCRtGiU1
         jOQhsOt4xpDvjnibUthGDitnKOrYG1a1xZCUttPkuim+MzBlwthjW0synzOPE2Y8D8sl
         jWLj9xzy3f1QlQ7bI3o9POo/+HuhWhunBPxLab2DML+iHuSZl1WBOsmbngjgWld77ZT+
         OB+iUvKih4nKPWKY37ju1NP81H96nV7oOR2XCNgRLu5VHDIpTNx5CBvaw0fhMmSlrqkN
         CP1Uw1iFOZCb2gp174xFAHTmDVtRHGA4PqbZ1/r46MiMhlQUlBox9ixp0Sp5EgpdKXs8
         g99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764492; x=1764369292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1mfMySPMjnmJsOaOUb/BM+KRAPsIyAYo55wsBBcQK4Q=;
        b=aTXmjMfx+EqKF3KZ2R9OTMCptFvPnRxud+bbObiRAzdd8mt6nHwp7KeSu6D8MgKYmY
         c6DsJCJYnQ34OmtvRZalrnshd8Ay7YwMqjYTURP3s5S7IU6tm243yOvVZuZu+76e8Olq
         vCWN5POoDRKp4YxKM0XPKXoz/eu2G8Z3nDYoxYjM/+Awx01TdjfQCI4BcrKqWdcR6OQE
         2+WlC1ND2AoBvtPqKQxfM9Rs/5e4lGv31U9l+VbAPQdO8Q6D/OaStY93xRs9T8Diycjs
         hGH5g+azE1WUm5jHR8gMvwofxf35+DBkRzS3LEgbVWiBg//+xehYP0YQTQf9vPlbiHOq
         WkgQ==
X-Gm-Message-State: AOJu0YyoEC2gDkf8XDZsa6m2xShL/GcroODJvPXlY+NFYSlZeBgZb2l5
	4gXoON0wmnENK9/3Z1t+scEdIXUUZWqHe4GatWxjYfZAWM0vd0gH2elxNHb8cDM2tsp09wiFPmU
	Y+HTdQg==
X-Google-Smtp-Source: AGHT+IFj9RuRV1UAsJsdC2BoWHM8pJJQOrksLgBpTc07xLXfaxVjVM2sIZK/7aS0zyKbjdcsJJO13/uH/RU=
X-Received: from plot21.prod.google.com ([2002:a17:902:8c95:b0:298:321b:1fa8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f706:b0:297:c889:ba37
 with SMTP id d9443c01a7336-29b6c6a4a1fmr45042745ad.41.1763764491941; Fri, 21
 Nov 2025 14:34:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:34:42 -0800
In-Reply-To: <20251121223444.355422-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121223444.355422-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121223444.355422-4-seanjc@google.com>
Subject: [PATCH v3 3/5] KVM: nVMX: Precisely mark vAPIC and PID maps dirty
 when delivering nested PI
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Explicitly mark the vmcs12 vAPIC and PI descriptor pages as dirty when
delivering a nested posted interrupt instead of marking all vmcs12 pages
as dirty.  This will allow marking the APIC access page (and any future
 vmcs12 pages) as dirty in nested_mark_vmcs12_pages_dirty() without over-
dirtying in the nested PI case.  Manually marking the vAPIC and PID pages
as dirty also makes the flow a bit more self-documenting, e.g. it's not
obvious at first glance that vmx->nested.pi_desc is actually a host kernel
mapping of a vmcs12 page.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d4ef33578747..d0cf99903971 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4027,7 +4027,8 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	nested_mark_vmcs12_pages_dirty(vcpu);
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
 	return 0;
 
 mmio_needed:
-- 
2.52.0.rc2.455.g230fcf2819-goog


