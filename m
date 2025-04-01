Return-Path: <kvm+bounces-42348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2D1A77FFC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42EC16C129
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5857021D581;
	Tue,  1 Apr 2025 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0aONPLX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B1B20E005
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523913; cv=none; b=K2SdPi0sE9n7effMILZKl2Ue0EIxVt+94kyrLhEQi68Q4HyosU0Rs4qZ0JJ38w72Ev/BjbrauocljcVP/gD6vmlD8piBekzRx66FmIBInpL+KkaVHzPLNyRayKq1LXO4mcE8rwMWj83Ukz1mbBWji5FsghYYbBIm3/MbVgG7k2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523913; c=relaxed/simple;
	bh=RefrmAkQ0L+4IQy+OTCdYSqXd/r04zNM+VND4kN61fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+WSlLalzdAOh6O/my3dEa++OoVirvYXQjmU82CXHY/Wxbb2Fw3tLWnjiA2zyU1JoqRfFd97SHf7rDSEH5EqWUbKJm9Z8VFN+updJcXDQz2U64VdBZw8XssgM9NyXf+UisjUAsj9Sz8iheHye2Mecu5Q5qsERExdKgCfN0EPOKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0aONPLX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIfnqOGSQOH72XfcWRssGMHV1iaqS8FYDinT6SkIDjk=;
	b=L0aONPLXxzvdHp1JIHZC+0II1jdX5vchpaXb0RO/OK5wQyt21U1J0+bPRJ+d9+fhZvxXjq
	2t6N+XMpLPV4qhW2UZ242esbb7msukr+Gmf5jpMPc010CsVSAvA0aNrGB4Idhb0mMNVGt3
	lUVHTH16v9GK3QRo2b1L6l6vqEvUrnU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-dBvFaTtcNYW-uprC807mmQ-1; Tue, 01 Apr 2025 12:11:49 -0400
X-MC-Unique: dBvFaTtcNYW-uprC807mmQ-1
X-Mimecast-MFC-AGG-ID: dBvFaTtcNYW-uprC807mmQ_1743523908
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d3b211d0eso33421435e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523908; x=1744128708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIfnqOGSQOH72XfcWRssGMHV1iaqS8FYDinT6SkIDjk=;
        b=ilR7ke+JcKENpV/QciLVTseFyHiCBrCWt5CMoOOWWKR9eCchnx6nLY2WhcJJTkzxat
         TpslJ76tCxE7GzrEIDwOsSXTvnPm6xRTKQYYTsVEB2VZ+Gi2Q2X9krDpV+9cScD33EiV
         xz55nVhucLU71Li8/4Rj+IKwREbycq3zPo3Eb4F+tljU94RJXwUmoID+UYXPgZplQECO
         ww295qJMZ99BfY6vXnK1xt/m97Ck4BKTSSyQJWPwBaC/edtSLxIZY1TuY3uHoD1DhkPx
         y55ArbC6ZRyG4sUlib/bxn2rtL7siEseQWNORsUPHT9/t8WOOWmfDCwEWzJtEGffVwJu
         IAUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1GoroZYUDxJLKIAwVqIdSHFSl208JOSesDsvoo+rtumNJo785MnZ4WgEWPpFwnQuuFx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMcESFv7sQ/3hxUwfjWtfsXFUsAc6pAxNlyGSfYhTuiajttOyz
	l2FyfqxD7tqIy9s7vHySQkCGvGTJGCyLI9CMrRBkTLcYHgqtZkOW3pPYAAe8lyj9WRS4KNdU8J6
	vIFvM5aIB7HUlTZpTNYBY0prOOYkW+aDRN1XNbQvFUMq0WSOs0w==
X-Gm-Gg: ASbGncs7VTja0E7mY6suX1uhsTTzSTmt90Ezog19BXPRgHoUufcfPc0zzcKaPOxy6O6
	sfmdYWnA5oONFQcgFyRpdxm5mWGkvUiqBuKa5KMz26FPnA/mEqtdSe9gAyCjcV409hRjlS7eDEW
	aGTbz6YWh+T1HquUFJif3INNkB/s0N1B8f3ZqAbPtCbmTTF6I4ckI1EFuiT3h2aOI2DgtkcXmYP
	LVpkIRLSaIKkINNAOX4/8bW2hPTGyYP8o6ReT8HBbJ/10PO/9IELT8DFxce2vob0yF16TcK+2Ty
	V5JDSw1IxhHyD5cazW9HXw==
X-Received: by 2002:a05:6000:18a2:b0:39c:dfa:e86c with SMTP id ffacd0b85a97d-39c27efc018mr542258f8f.13.1743523907993;
        Tue, 01 Apr 2025 09:11:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEH9kQ+udDvKebNrdMvaVgGuN+oLXLUK6O9cvy6KAk/oIwzHbZqyR7QPJ1CTGQr9niaqGFOA==
X-Received: by 2002:a05:6000:18a2:b0:39c:dfa:e86c with SMTP id ffacd0b85a97d-39c27efc018mr542224f8f.13.1743523907620;
        Tue, 01 Apr 2025 09:11:47 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66ad1esm14707692f8f.52.2025.04.01.09.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:46 -0700 (PDT)
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
Subject: [PATCH 14/29] KVM: pass plane to kvm_arch_vcpu_create
Date: Tue,  1 Apr 2025 18:10:51 +0200
Message-ID: <20250401161106.790710-15-pbonzini@redhat.com>
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

Pass the plane to architecture-specific code, so that it can also share
backing data between plane 0 and the non-zero planes.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/arm.c       | 2 +-
 arch/loongarch/kvm/vcpu.c  | 2 +-
 arch/mips/kvm/mips.c       | 2 +-
 arch/powerpc/kvm/powerpc.c | 2 +-
 arch/riscv/kvm/vcpu.c      | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/x86/kvm/x86.c         | 2 +-
 include/linux/kvm_host.h   | 2 +-
 virt/kvm/kvm_main.c        | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94fae442a8b8..3df9a7c164a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -427,7 +427,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	int err;
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 470c79e79281..71b0fd05917f 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1479,7 +1479,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	unsigned long timer_hz;
 	struct loongarch_csrs *csr;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 77637d201699..fec95594c041 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -275,7 +275,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	int err, size;
 	void *gebase, *p, *handler, *refill_start, *refill_end;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index a39919dbaffb..359ca3924461 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -762,7 +762,7 @@ static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	int err;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 55fb16307cc6..0f114c01484e 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -107,7 +107,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	int rc;
 	struct kvm_cpu_context *cntx;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 46759021e924..8e3f8bc04a42 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3970,7 +3970,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	struct sie_page *sie_page;
 	int rc;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c8bdb139b75..9f699f056ce6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12293,7 +12293,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return kvm_x86_call(vcpu_precreate)(kvm);
 }
 
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	struct page *page;
 	int r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 99fd90c5d71b..16a8b3adb76d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1622,7 +1622,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
-int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 06fa2a6ad96f..cb04fe6f8a2c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4207,7 +4207,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm_plane *plane, struct kvm_vcpu *pl
 	vcpu->dirty_ring = &plane0_vcpu->__dirty_ring;
 	kvm_vcpu_init(vcpu, plane, id);
 
-	r = kvm_arch_vcpu_create(vcpu);
+	r = kvm_arch_vcpu_create(vcpu, plane);
 	if (r)
 		goto vcpu_free_dirty_ring;
 
-- 
2.49.0


