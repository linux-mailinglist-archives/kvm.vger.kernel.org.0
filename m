Return-Path: <kvm+bounces-42359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4F1A78020
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5070B3AD446
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07FD2236EF;
	Tue,  1 Apr 2025 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RO0w+fnS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D8322331F
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523942; cv=none; b=SGWpzGzLkrw9Ze3e0eZ5IaZna3fuOyg2d0jI2qUK2b2DsPg/xMlzSWxvAgmgw9RAcVqX10TQPTaH+bbmJEd8C1XdcR8kfN4/qD+LsOSKTkCOrLHBrW5zK4aMRhf88/YUBe+VC3Jo+XPWhVwtluSmZ4FzlhLBvjb0bBSp1rgmb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523942; c=relaxed/simple;
	bh=pn8er/Ns1V0RvexqIaqaUyOMfeX7VOy6D1cEZq4AgVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieKtXAyt1F0r1eh/xz5Tm8DlqxxsiZmncLjuWLG9ypO4vHfwIq4yalMgfiUNCpGB3YbHAW7J7611f1Qrs94PA6INdeMBt8jYMT2QfOvPX+i/5t/WYsipZfsg/kscv1UEGySEheodHoYA3RZJxdVEeRuDJH7Te2OT9dZodchF804=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RO0w+fnS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STKQiGVrBKxKXPgyW50q0lNwcXD/6o7OaldUCF+7vOE=;
	b=RO0w+fnS2DEtpfJFYGck71MkJg2J+HiqiQxv5FwCIpuEx60Jfxqp08eHoE/N/0G8Xf1yeD
	Y2hJvXAN6jTcZ/r0l54YL7L2Xs7DfHgrBxMu7LQ9PDMnpykDqHRgHZ9qSwJr/6r/cKtBUY
	TAhDDix1H2o7OzeYxRHTD4A4j+UnQY8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-aFPionnwM8iHI04aE1bcZg-1; Tue, 01 Apr 2025 12:12:18 -0400
X-MC-Unique: aFPionnwM8iHI04aE1bcZg-1
X-Mimecast-MFC-AGG-ID: aFPionnwM8iHI04aE1bcZg_1743523938
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39131f2bbe5so2322881f8f.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523938; x=1744128738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STKQiGVrBKxKXPgyW50q0lNwcXD/6o7OaldUCF+7vOE=;
        b=BUlGA0TtEGzmDY90+ZNHtGElQo85UmRn/BrtwZYulzJZtTmPXR9dsy0/KDQ3Hr2n8O
         fxfEkbcegcZmZhRIPeDLd+i+qnufXGYsTkwoIFDjZVrksYST2lt/PCRbqtOc891IYph/
         oAmRdBDTiUe2m6GV5GU05irISYe23NzFteCY5BSDFd48BxGFeIuCfkLPSxFlq9cZgMd4
         syzIV+ncxmxR93wiEQm3/RkN+Gw159hm6Gn1FEN3i07fxjlG5bPtvgIVaG3twasUs9Rp
         rUofm0mo4FYPCo2C+D8x+gcxrgYKwD25Vuc63D9Y3w9lLey4BKL0mAh5pK1NJqfCb1tY
         iHJg==
X-Forwarded-Encrypted: i=1; AJvYcCXubbrQRGAHXZeP4WfOzRvQMSe/msGjaggEn5jnYlKIHXKiXIlWcGadFfHk90akVV2rXWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfU3XUJ3STCwg0C6brWprXuE4bZQNAa/k6jwKoCWwwSBTd2Q1X
	5nY8ZA/DF2Wsp55X2fzMjGW02pKLs9FZOISzUlVmil3bBLUFcZ5psDEYG5DNvCZNHeJWKjqwOg3
	nMfr1h6LrI+Koplq3Lk5+mDsyF4Uwm8fsrbeOmT/FVG+N1aiVSQ==
X-Gm-Gg: ASbGncuxV/cKX9CuFF1mA1lhEqaGrH41o/0S1zPcgvMsixBRDGbceaMRf15jQkX07sK
	UEMGWA3alVV57PuwHjYRoazJqUIoWXVxjXL9RYt7ZJj4/y2mmmjYvwnPJFOWdoi8rmabWTbCPMv
	iOsTwSbUuTRHgCddkuQN+4en9kZ4UzGpjadkr3xy1KoqLtNuRKCqtLuNt9utwIKBBsRoKAv9QNy
	xMlfmIsZ08oFS0pcYiOGiAPqZ07Zx/pNaAHWYtiVz6qjZ4Hlk6nWXeeFPAG4uKrZxPxIz16djO/
	Yf7WddldKI/CoYzHSVaGLA==
X-Received: by 2002:a05:6000:40e1:b0:391:2ab1:d4c2 with SMTP id ffacd0b85a97d-39c12115daamr10848572f8f.37.1743523937451;
        Tue, 01 Apr 2025 09:12:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFixcIUQZovBxbTUqE5qYkRuf8yLn9S/Hc/iFsk0oOlWsNioebYuSesp4eyH3gSeVV6bFB72A==
X-Received: by 2002:a05:6000:40e1:b0:391:2ab1:d4c2 with SMTP id ffacd0b85a97d-39c12115daamr10848526f8f.37.1743523937028;
        Tue, 01 Apr 2025 09:12:17 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8fcceaaasm160266655e9.18.2025.04.01.09.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:15 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 25/29] KVM: x86: handle interrupt priorities for planes
Date: Tue,  1 Apr 2025 18:11:02 +0200
Message-ID: <20250401161106.790710-26-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Force a userspace exit if an interrupt is delivered to a higher-priority
plane, where priority is represented by vcpu->run->req_exit_planes.
The set of planes with pending IRR are manipulated atomically and stored
in the plane-0 vCPU, since it is handy to reach from the target vCPU.

TODO: haven't put much thought into IPI virtualization.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++
 arch/x86/kvm/lapic.c            | 36 +++++++++++++++++++++++--
 arch/x86/kvm/x86.c              | 48 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  2 ++
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ac39f128a53..0344e8bed319 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -125,6 +125,7 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_PLANE_INTERRUPT		KVM_ARCH_REQ(35)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -864,6 +865,12 @@ struct kvm_vcpu_arch {
 	u64 xcr0;
 	u64 guest_supported_xcr0;
 
+	/*
+	 * Only valid in plane0.  The bitmask of planes that received
+	 * an interrupt, to be checked against req_exit_planes.
+	 */
+	atomic_t irr_pending_planes;
+
 	struct kvm_pio_request pio;
 	void *pio_data;
 	void *sev_pio_data;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 16a0e2387f2c..21dbc539cbe7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1311,6 +1311,39 @@ bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 	return ret;
 }
 
+static void kvm_lapic_deliver_interrupt(struct kvm_vcpu *vcpu, struct kvm_lapic *apic,
+					int delivery_mode, int trig_mode, int vector)
+{
+	struct kvm_vcpu *plane0_vcpu = vcpu->plane0;
+	struct kvm_plane *running_plane;
+	u16 req_exit_planes;
+
+	kvm_x86_call(deliver_interrupt)(apic, delivery_mode, trig_mode, vector);
+
+	/*
+	 * test_and_set_bit implies a memory barrier, so IRR is written before
+	 * reading irr_pending_planes below...
+	 */
+	if (!test_and_set_bit(vcpu->plane, &plane0_vcpu->arch.irr_pending_planes)) {
+		/*
+		 * ... and also running_plane and req_exit_planes are read after writing
+		 * irr_pending_planes.  Both barriers pair with kvm_arch_vcpu_ioctl_run().
+		 */
+		smp_mb__after_atomic();
+
+		running_plane = READ_ONCE(plane0_vcpu->running_plane);
+		if (!running_plane)
+			return;
+
+		req_exit_planes = READ_ONCE(plane0_vcpu->req_exit_planes);
+		if (!(req_exit_planes & BIT(vcpu->plane)))
+			return;
+
+		kvm_make_request(KVM_REQ_PLANE_INTERRUPT,
+				 kvm_get_plane_vcpu(running_plane, vcpu->vcpu_id));
+	}
+}
+
 /*
  * Add a pending IRQ into lapic.
  * Return 1 if successfully added and 0 if discarded.
@@ -1352,8 +1385,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 						       apic->regs + APIC_TMR);
 		}
 
-		kvm_x86_call(deliver_interrupt)(apic, delivery_mode,
-						trig_mode, vector);
+		kvm_lapic_deliver_interrupt(vcpu, apic, delivery_mode, trig_mode, vector);
 		break;
 
 	case APIC_DM_REMRD:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be4d7b97367b..4546d1049f43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10960,6 +10960,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 		}
+		if (kvm_check_request(KVM_REQ_PLANE_INTERRUPT, vcpu)) {
+			u16 irr_pending_planes = atomic_read(&vcpu->plane0->arch.irr_pending_planes);
+			u16 target = irr_pending_planes & vcpu->plane0->req_exit_planes;
+			if (target) {
+				vcpu->run->exit_reason = KVM_EXIT_PLANE_EVENT;
+				vcpu->run->plane_event.cause = KVM_PLANE_EVENT_INTERRUPT;
+				vcpu->run->plane_event.flags = 0;
+				vcpu->run->plane_event.pending_event_planes = irr_pending_planes;
+				vcpu->run->plane_event.target = target;
+				r = 0;
+				goto out;
+			}
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -11689,8 +11702,11 @@ static int kvm_vcpu_ioctl_run_plane(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu *plane0_vcpu = vcpu;
 	int plane_id = READ_ONCE(vcpu->run->plane);
 	struct kvm_plane *plane = vcpu->kvm->planes[plane_id];
+	u16 req_exit_planes = READ_ONCE(vcpu->run->req_exit_planes) & ~BIT(plane_id);
+	u16 irr_pending_planes;
 	int r;
 
 	if (plane_id) {
@@ -11698,8 +11714,40 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		mutex_lock_nested(&vcpu->mutex, 1);
 	}
 
+	if (plane0_vcpu->has_planes) {
+		plane0_vcpu->req_exit_planes = req_exit_planes;
+		plane0_vcpu->running_plane = plane;
+
+		/*
+		 * Check for cross-plane interrupts that happened while outside KVM_RUN;
+		 * write running_plane and req_exit_planes before reading irr_pending_planes.
+		 * If an interrupt hasn't set irr_pending_planes yet, it will trigger
+		 * KVM_REQ_PLANE_INTERRUPT itself in kvm_lapic_deliver_interrupt().
+		 */
+		smp_mb__before_atomic();
+
+		irr_pending_planes = atomic_fetch_and(~BIT(plane_id), &plane0_vcpu->arch.irr_pending_planes);
+		if (req_exit_planes & irr_pending_planes)
+			kvm_make_request(KVM_REQ_PLANE_INTERRUPT, vcpu);
+	}
+
 	r = kvm_vcpu_ioctl_run_plane(vcpu);
 
+	if (plane0_vcpu->has_planes) {
+		smp_store_release(&plane0_vcpu->running_plane, NULL);
+
+		/*
+		 * Clear irr_pending_planes before reading IRR; pairs with
+		 * kvm_lapic_deliver_interrupt().  If this side doesn't see IRR set,
+		 * the other side will certainly see the cleared bit irr_pending_planes
+		 * and set it, and vice versa.
+		 */
+		clear_bit(plane_id, &plane0_vcpu->arch.irr_pending_planes);
+		smp_mb__after_atomic();
+		if (kvm_lapic_find_highest_irr(vcpu))
+			atomic_or(BIT(plane_id), &plane0_vcpu->arch.irr_pending_planes);
+	}
+
 	if (plane_id)
 		mutex_unlock(&vcpu->mutex);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0b764951f461..442aed2b9cc6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -346,6 +346,8 @@ struct kvm_vcpu {
 	/* Only valid on plane 0 */
 	bool has_planes;
 	bool wants_to_run;
+	u16 req_exit_planes;
+	struct kvm_plane *running_plane;
 
 	/* Shared for all planes */
 	struct kvm_run *run;
-- 
2.49.0


