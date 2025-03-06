Return-Path: <kvm+bounces-40272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF22AA55771
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 21:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2033D7A9FDC
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 20:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA16275604;
	Thu,  6 Mar 2025 20:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d7zvUKZC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9597270EB8
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 20:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741292970; cv=none; b=t72jYX/ECdr/BLarBsWHcMMinxXF0cQ7nMcudfQTWorfBogoiCLusZTgl9o2EnnmKbGpGzLG9WFVxxciH/0FaMchElb9zQaATcwD4WGqq3zFLoUfrI6ABC5YLtaYmlSUcqgCkDdzCKCqmhFprXJ//PkXRGHDHnlij1JCm/Mopu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741292970; c=relaxed/simple;
	bh=8vyu3XmUOc6y+9UctpvXG0VUwJYWY/BqkHoBpdSAYZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h8LXJ8YY640vVJyRk2dFjBec8KGVaaiQzgEMj13Hvm152ge8ANCamsM9DDaeICYZGpYqhHqOoqHHv6Px1SAYvHsZ+vrwy61adKZ7A7jW0vNRcwD6QB7wXueSqsjXgGUpc9bXIddKmU4L9AEZe2jWWU0+n6dSmYP7i3ERW2XNbEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d7zvUKZC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741292967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jc3bU+07/m9HQ5f3AAk7LB5X6YU1cmlau9q/eqDjROY=;
	b=d7zvUKZChUQiUFsy6MXREKw1wK+yz7LVShCIYy4sipA891i6nOkbKlNHN4UaygEl8Wp7fs
	XS5Inv1y0Ddzy1DK9YyGdb3o6rGfgQIQmdtzQBcz76z/SsWbWURiphZ2CSRiiUZMzxFHP0
	4dXyn3Et+KNDduBIsB50DgezFBvwkJs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-7_9-8wuCMMmjEGO0x_UUyg-1; Thu, 06 Mar 2025 15:29:26 -0500
X-MC-Unique: 7_9-8wuCMMmjEGO0x_UUyg-1
X-Mimecast-MFC-AGG-ID: 7_9-8wuCMMmjEGO0x_UUyg_1741292965
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4394c0a58e7so6775995e9.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 12:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741292965; x=1741897765;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jc3bU+07/m9HQ5f3AAk7LB5X6YU1cmlau9q/eqDjROY=;
        b=jwnFGw5CV4uoEwNEt/OLE05GCHtO9otw3JQYDgNPSn4elkCqZ9sOprByvzS6Vk6p3P
         TMUd/yePsbN2dgfy8Wr1TM11UZyN+ymWyMp4UDcguvTdmYp6ZQJMGQMRs5d7oNvljWel
         zNZpFLjZ8vjfkOARDOx+l0Q64P/tRmRwKb0oPAm1SUDfW2hki33LRasJo5kkCw+t9C3O
         0dKupr4ArI36W/fxfcf9Gx9kA3EW2bs/HOEFUlaIYpRtUmt3FGRSbJiu1h3IXQcEg7Y+
         bqe2Vb6Fa9JcAXdKozRK9vJNVxRHDSSbP5CZkKeXQwx/53Bp4Xu5OV9te7nTYvcGhfM1
         v3Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXBdXF6fqgmr5HUhS8XbDfojrERRXmaPQkY66irRePS4O5xDW3RH2j65g/TT9lX5Jq6/oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0+lf5VAlRWzTm+78qjHr/UtCEeuaZV7lqj5jWPfnXPqrDUb7a
	BnJneR8VWXAVQNMYKiTauMxzTTqNFbp+8gbz4xMuzWQc3sf4qOPR/lnI6jmXMVJrLXy6/LV4hZw
	gXCkiSfPga0aVoSda1ckfkg/wG8iyyb3neEwVFFRn/KQpPWMIKA==
X-Gm-Gg: ASbGnctGVXxWxZ1afPXLPi1qY2/GYbgV/uzjCy/gRd+VJ2A8liDADlz9YvsvhQfftx5
	9schbZ1F6MDw0lgmIgqK0tSXHUGuatPGkrNyONJgUl7o7XdmewX8icPOCIx/tBJnGfmND7gU+Zq
	RzSNHsSN/rmGPytK/IOcq8k2gVlbBOusSPkC1IBDBjx0t2DwpcpRCIoG6awH41j7aQwCDmr5h+B
	sW9Iac/eIkQfuc38IL+yWj1ZjopwtBw99dY/xJQSdvX3dt9qlpn/V6RtwzHV2c0qzlbDy5JYxQY
	/c+uqmX0RLvEscm2sYo=
X-Received: by 2002:a05:600c:1c92:b0:43b:c284:5bc2 with SMTP id 5b1f17b1804b1-43c54a13899mr8094625e9.0.1741292964887;
        Thu, 06 Mar 2025 12:29:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAQSfTDDfEGt7kCQUl09IKwMyDuCnJFvs3A/ftPMnIhst0AXXgvlmr3jiXxVdhzI638oXcqg==
X-Received: by 2002:a05:600c:1c92:b0:43b:c284:5bc2 with SMTP id 5b1f17b1804b1-43c54a13899mr8094515e9.0.1741292964495;
        Thu, 06 Mar 2025 12:29:24 -0800 (PST)
Received: from [192.168.10.48] ([151.95.119.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c836sm59321245e9.37.2025.03.06.12.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 12:29:23 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH] KVM: x86: block KVM_CAP_SYNC_REGS if guest state is protected
Date: Thu,  6 Mar 2025 21:29:22 +0100
Message-ID: <20250306202923.646075-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_CAP_SYNC_REGS does not make sense for VMs with protected guest state,
since the register values cannot actually be written.  Return 0
when using the VM-level KVM_CHECK_EXTENSION ioctl, and accordingly
return -EINVAL from KVM_RUN if the valid/dirty fields are nonzero.

However, on exit from KVM_RUN userspace could have placed a nonzero
value into kvm_run->kvm_valid_regs, so check guest_state_protected
again and skip store_regs() in that case.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aaa067b79095..b416eec5c167 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4586,6 +4586,11 @@ static bool kvm_is_vm_type_supported(unsigned long type)
 	return type < 32 && (kvm_caps.supported_vm_types & BIT(type));
 }
 
+static inline u32 kvm_sync_valid_fields(struct kvm *kvm)
+{
+	return kvm && kvm->arch.has_protected_state ? 0 : KVM_SYNC_X86_VALID_FIELDS;
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -4694,7 +4699,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #endif
 	case KVM_CAP_SYNC_REGS:
-		r = KVM_SYNC_X86_VALID_FIELDS;
+		r = kvm_sync_valid_fields(kvm);
 		break;
 	case KVM_CAP_ADJUST_CLOCK:
 		r = KVM_CLOCK_VALID_FLAGS;
@@ -11503,6 +11508,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
+	u32 sync_valid_fields;
 	int r;
 
 	r = kvm_mmu_post_init_vm(vcpu->kvm);
@@ -11548,8 +11554,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	if ((kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) ||
-	    (kvm_run->kvm_dirty_regs & ~KVM_SYNC_X86_VALID_FIELDS)) {
+	sync_valid_fields = kvm_sync_valid_fields(vcpu->kvm);
+	if ((kvm_run->kvm_valid_regs & ~sync_valid_fields) ||
+	    (kvm_run->kvm_dirty_regs & ~sync_valid_fields)) {
 		r = -EINVAL;
 		goto out;
 	}
@@ -11607,7 +11614,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (kvm_run->kvm_valid_regs)
+	if (kvm_run->kvm_valid_regs && likely(!vcpu->arch.guest_state_protected))
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_vcpu_srcu_read_unlock(vcpu);
-- 
2.48.1


