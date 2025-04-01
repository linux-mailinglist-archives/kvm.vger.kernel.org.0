Return-Path: <kvm+bounces-42356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C90FA78011
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0BCC16E4B1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2205C222560;
	Tue,  1 Apr 2025 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CIgVf/80"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBEB2222A9
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523935; cv=none; b=kqWvIj23lXWCOdJtHGjvxckaIs6i4GKEfeU8T+BvWoYGrZAnvxCaUXYEjurqOVd3IRNgXjdYG4dm91nF+91dpRu9MKbB/9ONPfFD86yHSiIjc9M1zjVNLsMb3AmnFitQXbxzLHQUwMSlJQPXWf1iHTuxKgNpbEeGT0zgKSJAWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523935; c=relaxed/simple;
	bh=kQoni2s9+27EXmP2XI2+CYoemw/pJEF7XDPIcFmDe2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsTFHp5Y5NyPXR9a6JSLB6UR9s5Wsig3sEv5WSgDDffIBIXwcLuK9aHo6GtM9EYZVLwOZWupRgEO3NOJWutLsrh40+qSGd7PI5opfzuck0n06uGEp6iL7A3qLfJrkTvkjlwmfu/sXFKFQLIUP++lAty7kEs2/O891CL5SeK0r0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CIgVf/80; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ChySLp6+UIK2NHqTKpsGQPiliMxZce6mgamUWnpoK/k=;
	b=CIgVf/80JkAVEyct9qC1txCqW5Y4H4e6r7CJROF1qibDV5TJFRdkugl+wNKrR7IgAGAJHF
	fwUm7BiulzOG/DQog8b2j/k1pDQYdQdJu968YipdLXhBMiv2fvj2Mr22789/2QK5UpAQg4
	aSSgYozVEbFLtEtudSV+NCqg46EfnsE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-9nI9PuruMlGtxZYADxjpFw-1; Tue, 01 Apr 2025 12:12:11 -0400
X-MC-Unique: 9nI9PuruMlGtxZYADxjpFw-1
X-Mimecast-MFC-AGG-ID: 9nI9PuruMlGtxZYADxjpFw_1743523930
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43bd0586a73so44997145e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523930; x=1744128730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ChySLp6+UIK2NHqTKpsGQPiliMxZce6mgamUWnpoK/k=;
        b=B/fMaZ1Sbc3nB+3yG3KNBMFCS6PDurdDLcGM+vcfAo10FQB6IvwXrpwyn7qN+QiWB/
         hiYhihyYS5iHbBr8+VLglL8CZdyx3YxutldaSyG4vsoEhLXN4DeAwK1FgDX41GUN0Z11
         qO9/JZcs/PyjWoZCIGOzn5MHBuu3EAg0soAGe6eKoSJQREk4p1XI93Ma3rofTKK6Xkq7
         UCuSH5yjKdgYwV6hlC1tVlatAv4E0UBIpUzcgAuXKwLPKkzzANptLGQ3c6g2Cgla+g/y
         QMFjPhuwH1z3HTjDBdRgdpwAzbMqxgO/D4wikuXNJJMXF69TyhdlrumRk4tIcBFbID48
         ujkg==
X-Forwarded-Encrypted: i=1; AJvYcCXfs6YHfKZwX4rWGu7qQGenHhjK39XuQAijzeBR+L7Pc0yjZoncmIzd7vlpVy5odVczH6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw65kQ4oGcNyoAK0Gt28+7UCTgcMeF07idfanBrngURnHdy4aT2
	lCYWgAtiqYRrr1/pURDH/AFM/VUEI6gFVbQSDxd9YaBwGxcQhpCax1OXUa6+IA+J2xdB2hpXvOj
	ElvLcfiOLW3/ymu9kdIRGe1mY18nzQBAaC6A9cGkgqdXFRgj9+g==
X-Gm-Gg: ASbGnctzRM9XIpjEtPsHFqoIBGAzuZgeYHBfXRIe/J0qPq0Npdr/YxyWbw/+iBcRlh7
	9uKYBaueisRiIfrC3syF0K5vOCqsIkt28G5NZzSPjkw2T5+x9vGtM8zeaPD/EouYwNZYq5gEoD3
	AfcUMdFZHOosjw023dBaIZWmRFGqUx0p3LmkJeCpbDuaB+5/05QVwArhX2XBRV9+vE961e3qYDb
	+r1/84BAXm6fs0WaGpJ5BwiWie6pGf0KwVdgmb2jAJ8f3hFa9sKk0fpgmsoO/nDVkQGtDQyvaGn
	1lHhi7gkz+MUuPAOR4K5Hw==
X-Received: by 2002:a05:600c:6b6c:b0:43d:fa59:be39 with SMTP id 5b1f17b1804b1-43dfa59bf9fmr83046195e9.33.1743523930206;
        Tue, 01 Apr 2025 09:12:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZXiJ8c1MKAD59oM+jxw4s6wIAOa62pt3LsarDDoqS1UAAl1mtYiWot9iqnkG352qXMDvHFg==
X-Received: by 2002:a05:600c:6b6c:b0:43d:fa59:be39 with SMTP id 5b1f17b1804b1-43dfa59bf9fmr83045935e9.33.1743523929800;
        Tue, 01 Apr 2025 09:12:09 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8fbbfef2sm160662985e9.11.2025.04.01.09.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:08 -0700 (PDT)
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
Subject: [PATCH 22/29] KVM: x86: implement initial plane support
Date: Tue,  1 Apr 2025 18:10:59 +0200
Message-ID: <20250401161106.790710-23-pbonzini@redhat.com>
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

Implement more of the shared state, namely the PIO emulation area
and ioctl(KVM_RUN).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ebdbd08a840b..d2b43d9b6543 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11567,7 +11567,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	trace_kvm_fpu(0);
 }
 
-int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_ioctl_run_plane(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
@@ -11585,7 +11585,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-		if (!vcpu->wants_to_run) {
+		if (!vcpu->plane0->wants_to_run) {
 			r = -EINTR;
 			goto out;
 		}
@@ -11664,7 +11664,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE(vcpu->mmio_needed);
 	}
 
-	if (!vcpu->wants_to_run) {
+	if (!vcpu->plane0->wants_to_run) {
 		r = -EINTR;
 		goto out;
 	}
@@ -11687,6 +11687,25 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int plane_id = READ_ONCE(vcpu->run->plane);
+	struct kvm_plane *plane = vcpu->kvm->planes[plane_id];
+	int r;
+
+	if (plane_id) {
+		vcpu = kvm_get_plane_vcpu(plane, vcpu->vcpu_id);
+		mutex_lock_nested(&vcpu->mutex, 1);
+	}
+
+	r = kvm_vcpu_ioctl_run_plane(vcpu);
+
+	if (plane_id)
+		mutex_unlock(&vcpu->mutex);
+
+	return r;
+}
+
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
@@ -12366,7 +12385,7 @@ static int kvm_init_guest_fpstate(struct kvm_vcpu *vcpu, struct kvm_vcpu *plane0
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
-	struct page *page;
+	struct page *page = NULL;
 	int r;
 
 	vcpu->arch.last_vmentry_cpu = -1;
@@ -12390,10 +12409,15 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 
 	r = -ENOMEM;
 
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!page)
-		goto fail_free_lapic;
-	vcpu->arch.pio_data = page_address(page);
+	if (plane->plane) {
+		page = NULL;
+		vcpu->arch.pio_data = vcpu->plane0->arch.pio_data;
+	} else {
+		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!page)
+			goto fail_free_lapic;
+		vcpu->arch.pio_data = page_address(page);
+	}
 
 	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
@@ -12451,7 +12475,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
 	kfree(vcpu->arch.mci_ctl2_banks);
-	free_page((unsigned long)vcpu->arch.pio_data);
+	__free_page(page);
 fail_free_lapic:
 	kvm_free_lapic(vcpu);
 fail_mmu_destroy:
@@ -12500,7 +12524,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	free_page((unsigned long)vcpu->arch.pio_data);
+	if (!vcpu->plane)
+		free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
 }
 
-- 
2.49.0


