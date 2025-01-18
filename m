Return-Path: <kvm+bounces-35909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99995A15AB2
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1635A188BD3F
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2DA186E56;
	Sat, 18 Jan 2025 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n97VhTZ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1C1632E4
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161769; cv=none; b=XNrbcpCZ3DXyUk8Ifj7JCqUN/liFzlFucfgwMzBfgJPvQvZML3nUIBXyYXkOC5eRh32HmXBMezN04WmEw2vGnsONZWFl9lRwsP1CsDxqTfJ8coPSuAohusY+CymvUT+El9F+T9wdG8my0v6doIcnjQu1W+KAWU3D8o6FoZb/g0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161769; c=relaxed/simple;
	bh=d5eTYZ8nA+eny2dlNR6wc75KXRvXh76kClSBvOeXHgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r1CpXMrZHY4HLu+E+vRx0DgoH3WNV6GKBQvDCX+jFTUd2Ye3vx0Ia3BTrBbvD04UXmsf1OgJe70Ybz2IDMzj/xrY+3Ur57FM7fPySzkT6l1qW/npuEpiD8hB1YNIFEd/XKBlSKIVT5vzCfVqFTN/tbdeObgkag6j3PVWJBKY/lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n97VhTZ5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so7680890a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161767; x=1737766567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob51wzRnvvlVEAc5sJP3Qw2cprvn1V49Q6RmU7YLzHo=;
        b=n97VhTZ5AWGyo8Y5vEnH4a1p6lQPgq/pQ68SUvTc36dunzUw++HJJu0OAFgflN3trB
         g6Li8BFXI7ILcpVT3N9p7wfOPpKza6BIncAEzCpMXZLZiSOTtnW7xl1WkcXip/20h0av
         KGbdMGSYepIU9RsLv33lufAcfYOd3QeK4ABOTJk2/+fHT3HNC+5sTMc7ygu1GtVM0zzT
         Lk3GstfdINAQ+Rd5g9ejCeauflsw3qCPkGVd3rLcpzaBrkeMMFpjqHeO5+5HF8G58EmK
         s/d9q+sp2Rw2x4er/zgcgFUjUJGjPWcECpW4PS9WEGARfLXLycu3R/4CwuX1dQpf9FQZ
         16Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161767; x=1737766567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ob51wzRnvvlVEAc5sJP3Qw2cprvn1V49Q6RmU7YLzHo=;
        b=rnrCjjiyM4MiGDr+QM76h9asCRKJ1iqClub1eDl3NodrhHD/zQgHEPzuKOaHNop+LU
         5rjbKfhFPd/qB+SeVDfplasdOptWB8V2ySXSXrPqPq3isOWQc8LRLm6/IFDeA9mlk+28
         NyY019Q4ZsXVVzqOpk5+I4XCvUeP8cybzUwZtPawkt7hhVF1PtRkT4jTcB1d7mhn+0FO
         TSiWwVR4bMokqy6/qKllVIZALDaB7GBTFDWQZVWg32t78QAtQc+eO5nnUtZLDSG3qubt
         hMYeyz2nq4bMM4SGCfh49+Wf3UL0rSYbd1UH9tSzuZDgB+5VgDjucmZt2zfUvG/T716R
         LcNw==
X-Gm-Message-State: AOJu0Yy5h+lvAdxQkqUmx4yX7zU4B2Ea1bNFb5oQ4OlG2z20d6+4S5iR
	qkbB4uDejEah3FeA9svFgHqjk9S/fvH+RyJLKZPvA5k049C0P3wI/vwCLjox2U9wyvZAdkapUG5
	IiQ==
X-Google-Smtp-Source: AGHT+IFJ/KP3omneRh37cgcPi/MY3vB6qbRxqQ5KBdluhT/QtFH6d0BYfKGKr1KEUpIGhlgHK/uF2kMkV1E=
X-Received: from pfhx22.prod.google.com ([2002:a05:6a00:1896:b0:725:e05b:5150])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:180c:b0:725:e309:7110
 with SMTP id d2e1a72fcca58-72daf9a53acmr6846276b3a.5.1737161767271; Fri, 17
 Jan 2025 16:56:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:49 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-8-seanjc@google.com>
Subject: [PATCH 07/10] KVM: x86: Pass reference pvclock as a param to kvm_setup_guest_pvclock()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Pass the reference pvclock structure that's used to setup each individual
pvclock as a parameter to kvm_setup_guest_pvclock() as a preparatory step
toward removing kvm_vcpu_arch.hv_clock.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f3ad13a8ac7..06d27b3cc207 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3116,17 +3116,17 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	return data.clock;
 }
 
-static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
+static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
+				    struct kvm_vcpu *vcpu,
 				    struct gfn_to_pfn_cache *gpc,
 				    unsigned int offset,
 				    bool force_tsc_unstable)
 {
-	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
 
-	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
+	memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock));
 
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
@@ -3165,7 +3165,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	kvm_gpc_mark_dirty_in_slot(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
-	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
+	trace_kvm_pvclock_update(vcpu->vcpu_id, &hv_clock);
 }
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
@@ -3272,18 +3272,18 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
 			vcpu->pvclock_set_guest_stopped_request = false;
 		}
-		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
+		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->pv_time, 0, false);
 
 		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
 	}
 
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
+		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_info_cache,
 					offsetof(struct compat_vcpu_info, time),
 					xen_pvclock_tsc_unstable);
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
+		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
 					xen_pvclock_tsc_unstable);
 #endif
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
-- 
2.48.0.rc2.279.g1de40edade-goog


