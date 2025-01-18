Return-Path: <kvm+bounces-35907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E6CA15AAD
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18EDB188BC88
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00762155747;
	Sat, 18 Jan 2025 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTTA0MIP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A232813D281
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161766; cv=none; b=cutQXkSG+rpL+L8RYDdtSwYH/DfeHrFqgxSu7yMpM3il16GBtHQrGLFDV8d6XTtNGRMdVDJwr4hPKYutXoMH4K8WMUBGAhYImHfpITRSzZIOm8VQTkRyUpREXpDYbPd0/eRXAJN/rpNg+MWa1n4ymJmv/TAQib33Kq+6GKiQcVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161766; c=relaxed/simple;
	bh=jxOTL3Mkz2NS4RNUG54+cI/ehiSamB2ybhpUJeSXWsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ArBi0cmJOsw9NsxHUViYnrbWZeVkybkkVUH/Jdn4RaHuAbgRIvM9t37NrDjxjESoAU8xwTbby5qZn/kmw3g4zGCnz4SlAfrYKq8QrvBp23Lc/xiEF1G6xGwoheX5BUN+d31KId7Ay5n4qXAFon7m3xputRTT32L4btejpy88QX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTTA0MIP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so7399229a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161764; x=1737766564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0gOhEmCjiyxgrlBTDB8zGSt/z/LMmY8p2MSVMeH6TEk=;
        b=GTTA0MIPojQyzISgTgsXfzLVYQPRMK+4azqIp7g6PkWBj1ADA4mh1NOqo7+UsWcjFX
         Xg16dHSTBaWZLEjA/2v4wSGAL6rxYlSN2aZQSCxYAGBgiUchq+i6ElL7C+2NMAGuFjyn
         LFzSOX5Wo3DiuTRdTJboqVxZ/w/maC0nVPdrTnJwix9T3lq9er0pCcp+Cy11BRnH7ExO
         +XrcUx1ski4D6u0+x/pVWO1C4Mu22IrhofNhRIqgDmOTpo1rS6DJ4e98lhlzd5k6ySMT
         sFE76eldvy1PCU+Xw1b332saQpaJ6ma7/1QL4VcLPuwrVddrWn1JKpvmKXDHCpOtyNld
         D3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161764; x=1737766564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gOhEmCjiyxgrlBTDB8zGSt/z/LMmY8p2MSVMeH6TEk=;
        b=BlmIXAlD02rsjIthubeIADMia0Zk8VP9wAU3sN+IxOnZXyXojgHrai6+rTf/69M6Uh
         S6lskjWDawNdVHy6BbKRBVjU+NXhaftBh/bIMXDA4pswsxv36PGOdNxbdEJXX78x3Y7/
         6+0Z4VHWGMlHz9Q2PN/EbVutipVLnWUNSpnysu3gTlmNFuoRVbxAm5EnjIik92vA3CCd
         XFSpo4OOsjOd0G5LuspDCphdA1IfFk34ipzlAU+38SvAGFg0DcBLcQdZzTnn00hkAs+1
         gUR0NxJPcAkEEXVOhIC4IjNAGe2PBc3rd+2tqgD4Y0kWBRBbx0knAviSaE0rv1qrffVh
         78DQ==
X-Gm-Message-State: AOJu0YxldjDjR9/XGykawHr64VnOcH8Aj/ZGsgBc30QLSuP2um8X9E27
	cDtEVS9iWFgVxd+6b5VjNBfEz/58K0bB4n1c5OrJFcAzdRRMy0Xdb5CNr6i7LjJ2x/BLgZh5Kjn
	KSw==
X-Google-Smtp-Source: AGHT+IFP/HSzy1wggki71dxrmmf0OyWe6VJQJ5CZsz8GbMTSoEoP0MgDzbq9mRwzPywuTYdjBynpIvGphIM=
X-Received: from pjh5.prod.google.com ([2002:a17:90b:3f85:b0:2ef:6ef8:6567])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c3:b0:2ee:59af:a432
 with SMTP id 98e67ed59e1d1-2f782d862famr6115793a91.31.1737161764011; Fri, 17
 Jan 2025 16:56:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:47 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-6-seanjc@google.com>
Subject: [PATCH 05/10] KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across PV clocks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When updating a specific PV clock, make a full copy of KVM's reference
copy/cache so that PVCLOCK_GUEST_STOPPED doesn't bleed across clocks.
E.g. in the unlikely scenario the guest has enabled both kvmclock and Xen
PV clock, a dangling GUEST_STOPPED in kvmclock would bleed into Xen PV
clock.

Using a local copy of the pvclock structure also sets the stage for
eliminating the per-vCPU copy/cache (only the TSC frequency information
actually "needs" to be cached/persisted).

Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c4d210e8a9e..5f3ad13a8ac7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3123,8 +3123,11 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
+	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
 
+	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
+
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
@@ -3144,25 +3147,25 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	 * it is consistent.
 	 */
 
-	guest_hv_clock->version = vcpu->hv_clock.version = (guest_hv_clock->version + 1) | 1;
+	guest_hv_clock->version = hv_clock.version = (guest_hv_clock->version + 1) | 1;
 	smp_wmb();
 
 	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
-	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
+	hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
 
-	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
+	memcpy(guest_hv_clock, &hv_clock, sizeof(*guest_hv_clock));
 
 	if (force_tsc_unstable)
 		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
 
 	smp_wmb();
 
-	guest_hv_clock->version = ++vcpu->hv_clock.version;
+	guest_hv_clock->version = ++hv_clock.version;
 
 	kvm_gpc_mark_dirty_in_slot(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
-	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
+	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
 }
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
-- 
2.48.0.rc2.279.g1de40edade-goog


