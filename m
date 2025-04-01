Return-Path: <kvm+bounces-42349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2F1A78000
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C3F616D728
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8958A2206BD;
	Tue,  1 Apr 2025 16:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ft2cE/M0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF60C21D5B3
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523917; cv=none; b=Ub6yzVqIxsmmdDbg/fHcwJ8lbWFVq3selG9wwZ3fv66eFT2LDeWjwcRpI4trEYokeb9ul1cjhqskEwyVQpj/baHBFSQ9b6lIlZ65iQsN0nIenfOKAk4NpzBlmUZih/D3aybxKcaPFfmLIvYOTMsUWdqohbHSuntXmh2XjhY9kMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523917; c=relaxed/simple;
	bh=aUHeMAtza3lALIkrYa7Cju0Ow+Rzlcu6X1bDd+6rBGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjH2akuUixla7ZMgt0Bw012F7004H9XmdgypX0Zyh8c4AfafUC1Xnwi87Vg3yEE9WRMAdPfelI2wwj1hXtVnoW+wpTvTOV3TwTRrphSP5LaRiYl4YlqO/n+Ft/zm37Ec12mAoygn+0VkV87h3hawON90TfV3qWTlounE2+zKVCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ft2cE/M0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DC/nMXHGZlSx0sJ7rLf3alDuDl6Zb/0M1re23sBSw4g=;
	b=Ft2cE/M07xFZ3ogA6Poez8rkp3tIhUC+FPEPrFuFXfynQ0LcD+J1srGC4S6hLujVS0Nd5g
	cDutjg8jwFjUXESWi4XyFIYdebAeV/7uM8xJD3QrVAOoc21kU3sHErnu1bt580X+gowZax
	OMQwot1VHw5q2A4WBozLLt2ZL1GyJLU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-TnQrgOVsNO2kF6Y532hU3w-1; Tue, 01 Apr 2025 12:11:52 -0400
X-MC-Unique: TnQrgOVsNO2kF6Y532hU3w-1
X-Mimecast-MFC-AGG-ID: TnQrgOVsNO2kF6Y532hU3w_1743523911
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so20138225e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523911; x=1744128711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DC/nMXHGZlSx0sJ7rLf3alDuDl6Zb/0M1re23sBSw4g=;
        b=vu1qWLH4yWY2hyCYooAobR0n2Ikmi9x3Q9EItpEw9tnwpWYmZmnoJFMeEPosx4vF90
         7l1OwA++3yn5Y9qDyyWeucludRySa02CtvLKo3BylGYa1ny4GifZ98Xi3NNDfJ25UG5Q
         t3cS7DTe1LfcrwYR9Vy+zRTHebm5Tp7Un3hwDkaZ8ahHdtAQtHxFpDq+R6ZSUiX86muL
         Dclb1wdPodfSoTbBWrnz5pNOKwiZVUgJ6nFztDAZ3aXjw6rqCkY7iKOq4l/Qq69S8eqM
         WQh46T435rti8wY6F6T6TlA7HkVFrbK/mtBhvUZ6dd0Rm0/qQCz2tXPYxZMen7QCRM8X
         dVUg==
X-Forwarded-Encrypted: i=1; AJvYcCWHVlUTFGkhcFEIBMINlwceFCJ4Rff4lWC0+/UE9zjzfhitehLih5WwPaeVKJGgj/YtsoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpfRbRKJEIih6zxCmoADqSXVUwuamBdFghkDu7UI0ivg3GM3cI
	6u4Is1kFZWwNGhrRFmW+QkIZbqcJVi+hG8WDNalzmWOeKyLBH4ZrJRF8z4ZFcJcKAn1/57bttvR
	3Sajb4JfEl/thqRqyDA/aVc+14QUfPYkV6p0yKyrrX/uCFEfuPw==
X-Gm-Gg: ASbGncvqp1zWiIsAtVUylQIMs6WF1BNkb0Z2a8tM77KKTZzN5P4Q6ePH7c14+pJY69I
	KrEltdfOF5MF4CzUvPFPC7VUhZPDGtqVK+wEVVYg9EkY9MM2iYHx3nXtchV+qs/RbRyjLSSloGV
	sDxY15YFiLePWopfVkwWtLyn/coJ2Md6z9oh+27b91JUidfjy0Jt+7IgArcwdKEbMAxtLH7N8/j
	lRFfl3F/sFYSyXJ/jr/LxIXH+owONkqnh4liWdEYhY0nzj7pkO03x7z5n37HvZCr4bcNw0KuetA
	k+liHgD//Xt0ygKuhJFBBQ==
X-Received: by 2002:a05:600c:444d:b0:43c:fe85:e4ba with SMTP id 5b1f17b1804b1-43db6248f51mr106824685e9.15.1743523910758;
        Tue, 01 Apr 2025 09:11:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6cteiO2nE177KrCSu7vAEZTo6A+KIZLn6H0SoIEEXCGg9tK9PGpoiT8WxAi5lNC52sLjZ4w==
X-Received: by 2002:a05:600c:444d:b0:43c:fe85:e4ba with SMTP id 5b1f17b1804b1-43db6248f51mr106824335e9.15.1743523910433;
        Tue, 01 Apr 2025 09:11:50 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b6588d0sm14276926f8f.7.2025.04.01.09.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:48 -0700 (PDT)
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
Subject: [PATCH 15/29] KVM: x86: pass vcpu to kvm_pv_send_ipi()
Date: Tue,  1 Apr 2025 18:10:52 +0200
Message-ID: <20250401161106.790710-16-pbonzini@redhat.com>
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/lapic.c            | 4 ++--
 arch/x86/kvm/x86.c              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8240f565a764..e29694a97a19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2334,7 +2334,7 @@ int kvm_cpu_get_extint(struct kvm_vcpu *v);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
-int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
+int kvm_pv_send_ipi(struct kvm_vcpu *source, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d8d11d9fd30a..c078269f7b1d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -861,7 +861,7 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
 	return count;
 }
 
-int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
+int kvm_pv_send_ipi(struct kvm_vcpu *source, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit)
 {
@@ -879,7 +879,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 	irq.trig_mode = icr & APIC_INT_LEVELTRIG;
 
 	rcu_read_lock();
-	map = rcu_dereference(kvm->arch.apic_map);
+	map = rcu_dereference(source->kvm->arch.apic_map);
 
 	count = -EOPNOTSUPP;
 	if (likely(map)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f699f056ce6..a527a425c55d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10101,7 +10101,7 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SEND_IPI))
 			break;
 
-		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
+		ret = kvm_pv_send_ipi(vcpu, a0, a1, a2, a3, op_64_bit);
 		break;
 	case KVM_HC_SCHED_YIELD:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
-- 
2.49.0


