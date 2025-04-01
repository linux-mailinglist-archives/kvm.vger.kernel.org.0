Return-Path: <kvm+bounces-42360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21AC3A78018
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB5871696BF
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E64224223;
	Tue,  1 Apr 2025 16:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4TYjrWV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DB92236E1
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523945; cv=none; b=WnduadQwdLO2krBzykQnB8azhxuAN3uVt/hY5M+0xAAtTOQpnWOIT1Q/bGoL98zwNVjDELhwnivAo539fQa0VcCVIUtPDsBaGcGE/pxGZYBotnWM4sVgi53xyvMJsiLx2ix/MelEFOmjzcZg1bLMenCufYivQpWCBF+ngp7ehCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523945; c=relaxed/simple;
	bh=Jr48n7DTkbCOMB/d0GEJ1ZQWRT8vQDsoeXOK//lT2/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMx6vUW7NEInjj4isWX1wWT+cQKndBQeK+HwyWUU/Hf+GAOJW0tSspXxCnXfotTPLKcgnJaa5QFkodkzzXSrh9/I+hMscOHo/Na/Lla369GVPv0t7Hw2WnQCqCDjyelwEfB+/d6f6VbHeJ+wDiqo4AiC1ZnKG5av5v9FMF2A87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4TYjrWV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMmSY+BAN+od5q2oN5V+h7YwfbF4XF3XqSY7nT/C4e4=;
	b=X4TYjrWVzd7DLnPuVWUXT9q5HKDXSU7oTjbW7VDJQFBxlqug5rM6WhTTh3UTqnx+HqbMga
	i7f+7VfM072tYnBh/xdXbNphO3HY1E3Z+a1cxbj3sDuOApEpzDk+KybVMI+T2PDci7utxk
	lbxP03WbakCbbjxPqWvi1mRzOEbuDsU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-kCOM49tqOJuyAn3m4e2Ymw-1; Tue, 01 Apr 2025 12:12:21 -0400
X-MC-Unique: kCOM49tqOJuyAn3m4e2Ymw-1
X-Mimecast-MFC-AGG-ID: kCOM49tqOJuyAn3m4e2Ymw_1743523940
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-39c184b20a2so1046832f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523940; x=1744128740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMmSY+BAN+od5q2oN5V+h7YwfbF4XF3XqSY7nT/C4e4=;
        b=a8ypUcMCZ6MlSSp3TI/RdmFrXGhsiLfjOaN0NvGZLiyepVfQFGcGaAhH0bGDQK5CR+
         CbmcunvJL1ZywDMy+ju2VPDvBSeZP8YRslPDR48ZJvECgcAvutntvMBfnwsCUDyF4Sj6
         flPnHcuJVKVKg3WGkHmCVcceV4sVecCNbBtSicMDHwpMRxMnb80CT1DnciSE3PocV+lb
         hOsKneWRFfGRiAJ+BfN+J45WSao0Q9XjhprAtX91uTQAz6klcdjglETwv3i2nHTaMxzN
         169W7b8sWprYlI4YAg6iZM8sW9q+lyEgr0K/JX7lFMo9v801BljR7stbl3/tlWK3ufMX
         jI9g==
X-Forwarded-Encrypted: i=1; AJvYcCUOtezB3b/7UqX2cHvw1APrRHCMwMPUP+T6Ed9fFVALhyBnF7k9FFUdERw2HCaJ2m7nSVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmET8ix7AgzHTPxPSQkxp0BP3a0uzK/HawqEpBFgffPcMXcF2Q
	n7Xn30pbmVb0A4se9LxVKzM/FPvzPUwiWcwn7jsNIBNr1V+c70fpcOaDuY5txtlEf4l0f3p53aG
	tysA4gWrk+JOg6x/DgAr3kv5lylFK2W/zFGGxRErLg5ZHjDLD4w==
X-Gm-Gg: ASbGncuoafiB9NvJtpFlZvCovAbZCaCM9DwCNVTny7mR+WYnYoLm34h2j55wVWcaOB+
	7qMjbEUvFtqTWWqdxB/snivSMBt4GayQlAyOE6RoFk/pmdZE60REjqc0CzwDQi8OlKxnV9lytAY
	a30r4YgsK0x5Cikgyq2aHXfg9pfUgPBGuPy1hfKq+JqT47svMLrM/odWu+tbgJzUu2AMmFbi3eN
	t8yR7fywXOaoXIzRy6zlHI0/jpG4bHfavdhqrbGWZ5QnwB7MOsQ14lMNmNBfZv3wUfR5H81MS4+
	7W+bj0t6/dqlh68NvrFb1A==
X-Received: by 2002:a05:6000:188b:b0:391:20ef:62d6 with SMTP id ffacd0b85a97d-39c120cb835mr10465205f8f.11.1743523940109;
        Tue, 01 Apr 2025 09:12:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFwlHiQzmqyX2anRC0qQyOVR2lkXQfjeA/y3ngR7h2MBX/VCdz2HKMdJUXOZo8Odrhhl0ySQ==
X-Received: by 2002:a05:6000:188b:b0:391:20ef:62d6 with SMTP id ffacd0b85a97d-39c120cb835mr10465179f8f.11.1743523939799;
        Tue, 01 Apr 2025 09:12:19 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8fbc1716sm158501095e9.15.2025.04.01.09.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:17 -0700 (PDT)
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
Subject: [PATCH 26/29] KVM: x86: enable up to 16 planes
Date: Tue,  1 Apr 2025 18:11:03 +0200
Message-ID: <20250401161106.790710-27-pbonzini@redhat.com>
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

Allow up to 16 VM planes, it's a nice round number.

FIXME: online_vcpus is used by x86 code that deals with TSC synchronization.
Maybe kvmclock should be moved to planex.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/x86.c              | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0344e8bed319..d0cb177b6f52 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2339,6 +2339,8 @@ enum {
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
 #endif
 
+#define KVM_MAX_VCPU_PLANES	16
+
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_cpu_has_extint(struct kvm_vcpu *v);
@@ -2455,6 +2457,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+int kvm_arch_nr_vcpu_planes(struct kvm *kvm);
 bool kvm_arch_planes_share_fpu(struct kvm *kvm);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4546d1049f43..86d1a567f62e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13989,6 +13989,12 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 }
 EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
 
+int kvm_arch_nr_vcpu_planes(struct kvm *kvm)
+{
+	/* TODO: use kvm_x86_ops so that SNP can use planes for VTPLs.  */
+	return kvm->arch.has_protected_state ? 1 : KVM_MAX_VCPU_PLANES;
+}
+
 bool kvm_arch_planes_share_fpu(struct kvm *kvm)
 {
 	return !kvm || kvm->arch.planes_share_fpu;
-- 
2.49.0


