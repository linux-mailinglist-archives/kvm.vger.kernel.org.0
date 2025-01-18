Return-Path: <kvm+bounces-35905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7496A15AAA
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DF5E3A24F6
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CA913A86C;
	Sat, 18 Jan 2025 00:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3DkzWhMz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7A3664C6
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161762; cv=none; b=V3gy9l5sl6qIkL/tV9V5zsycE3Y8IKlZeQ5WtKTF7XdVXdfjTwND4ZkoLF7/YfDjP6Kix1XokWz6bMalSKIqDmngBAl4NSdtEPEFPDQmgAHi+fs6a21uaEfizB1rJEPSJRJaTu/zyN/k+Rr8B6BQ4a8q0h1vCmqV8V0PMhQ5oRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161762; c=relaxed/simple;
	bh=ZbA6yFmveNa2D14lROm2tOREBu6NBfrC1MBvad9WdvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=scYU7xeXiGdGcyG2C8Q7t84RnjwD00/7WPjXLlFtDFH9wM98kORKmSAtk51cAwCpOqx68qlf57tgIrNYMVAb6CN85Lg6Ak4Tztn3Uc+ovAS3yxBOp8HHFqsKgRZes/qa8GysfWzoLvi7FNr/hySujlGthqrz3MlKROHrMSpa+gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3DkzWhMz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f780a3d6e5so2457072a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161760; x=1737766560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kw+zxikeNBB4FodaQVXX0L8BbFo8TDEqg90JZgmWMqc=;
        b=3DkzWhMzh5MCMfV4hjsZjK96P3/bkvNY3EY3Ho5lKjGmCnZ2xzHPFnMlRQBDe05xVq
         WZ0OGosKwxB2JvWL70rgVxIHQxvuzPXiSmCCYY/TXutGYyOD6AaMfvzay3afCvC/Fb1/
         mD+djN8c2O5ZyS8U5OKWK9FpkzPgsEMjG3XpmpitN+rYvtvIT70p1QixlYQM5QkVOAuR
         1csML90bR1wL0gXAXmHDhHH9vBvWqTYEhVw165+nfEgCiNrac5AK2G61tqVBgk2xm+mI
         9uYsjHyYn7b04OuFoJRSauUZl8wTvCuRPo12Mojc9C8vi2Ym+RsIT4pW99ZwEIl156SY
         qIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161760; x=1737766560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kw+zxikeNBB4FodaQVXX0L8BbFo8TDEqg90JZgmWMqc=;
        b=aHSf3Aufu5Dr8t6/xpllXOY+bIu3vfoO+leVtb9u9p0PI50r02zj8qSuBkiFzKftL2
         5Lha4BtyE4Jz6NBaemZ8srkDgDXGO8SBHorsHegOxB5q3mKGGkaAND0cJ4j2kENBX5YP
         cawApajirioLdc8eEsC7xsoKlK1RPJc/EeUVjHiyxQXKaDY3n86uj7yelNFPAwNCPQ3U
         p+Ryb7JH0Y586q0+2CCiQN1Si4v9vUVaYxhuT023fYYbdWK/hQ8bZACO2inq4CXU3gER
         xc0TfHJH/RPy25kbP/4VJrL7O4OryZ0LLmJPtqrouHB/wphlBWCIF8yjWIUc6CLmFiES
         SRdA==
X-Gm-Message-State: AOJu0Yxa/5axPqfmHbbbz3AhLgfnOHGq2IqXPz2i2CJBvECUuELV5Y7h
	QF3rguuHIErQsyQDbmxCMiP29qLo4d8M6yJubtoArvZeicUtL2LaWVYqPBvom7XHfIoDmw1Ay6l
	iQw==
X-Google-Smtp-Source: AGHT+IGfcOLREVLx3eFzOTyVZ8snWmsSCngywovuBzuufyEWLRxg05P9VTYADZ/kr8UTj0njLqkpQzzSyEs=
X-Received: from pji12.prod.google.com ([2002:a17:90b:3fcc:b0:2ee:4b37:f869])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5211:b0:2ee:4513:f1d1
 with SMTP id 98e67ed59e1d1-2f782d4f34cmr5876571a91.23.1737161760718; Fri, 17
 Jan 2025 16:56:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:45 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-4-seanjc@google.com>
Subject: [PATCH 03/10] KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Drop the local pvclock_flags in kvm_guest_time_update(), the local variable
is immediately shoved into the per-vCPU "cache", i.e. the local variable
serves no purpose.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef21158ec6b2..d8ee37dd2b57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3178,7 +3178,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	struct kvm_arch *ka = &v->kvm->arch;
 	s64 kernel_ns;
 	u64 tsc_timestamp, host_tsc;
-	u8 pvclock_flags;
 	bool use_master_clock;
 #ifdef CONFIG_KVM_XEN
 	/*
@@ -3261,11 +3260,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->last_guest_tsc = tsc_timestamp;
 
 	/* If the host uses TSC clocksource, then it is stable */
-	pvclock_flags = 0;
+	vcpu->hv_clock.flags = 0;
 	if (use_master_clock)
-		pvclock_flags |= PVCLOCK_TSC_STABLE_BIT;
-
-	vcpu->hv_clock.flags = pvclock_flags;
+		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
 
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
-- 
2.48.0.rc2.279.g1de40edade-goog


