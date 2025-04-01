Return-Path: <kvm+bounces-42351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D439A78007
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 770C53AFC94
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD7420E026;
	Tue,  1 Apr 2025 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xr20Axfc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ECE221569
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523921; cv=none; b=tgjf/mUpifJJxlTqa/WF8UfuVWzYRDFrun/HF1nj/36ppblO7d0ZvmTDi6dVLc//z2iREbMJ1tB2gfdWO7IzsYI/g5nbWUjqafwQhXdN66Iz2r/k9/7uuxz0hO++EIXurUznbu+02cf3r2APLzITTAwXEQzVcCBGx511dbOnlic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523921; c=relaxed/simple;
	bh=2CI/mkWBrTgnbik9OCHRAn1y+W1g2QV9UjWHcVB514o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOdkVkc8kU1IqT6xPxZ5lHLF4jDgADmiGQNN0MtBjt1maO3OJmYGQO+lVcI+JeYoQv5zS1ecaCSI1GaIOOQ/F/uv90rGBcqEA8cIbgaNT3I32F9soAirsBodS3a2GNYVG63myPjWZgqqTYNWXqUDFtIUfpRbmeMVNHkmK68ppW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xr20Axfc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jloFR1LDGvNeXK6NZWVsMX9b3AeMl8ttvkfYFFUhR2s=;
	b=Xr20Axfc8Hi19FQm961vQVoduSaE+7HSCBt0AX64eeHJduUsFLe34N8UkiK7nHAAj3Ka2I
	/nX9MfNq5Mrqqt+Yd3iXOeSmt/F9r84RxMTeOhzxM4IyOxcfU0z09ut4rffdz1do1ODdsL
	Q2xh9aw0EuK0RK02TMeyoPVndrcBAqA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-hf8uBGwOMmOPy9gxzkVrCA-1; Tue, 01 Apr 2025 12:11:57 -0400
X-MC-Unique: hf8uBGwOMmOPy9gxzkVrCA-1
X-Mimecast-MFC-AGG-ID: hf8uBGwOMmOPy9gxzkVrCA_1743523916
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d51bd9b41so51391015e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523916; x=1744128716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jloFR1LDGvNeXK6NZWVsMX9b3AeMl8ttvkfYFFUhR2s=;
        b=kbrts2+UVFYOhl41SzKo1q8dm8A7+LPVruVqt/PGZx0VtFXxliygX9nLjN4IFDk80E
         5+UoPLNGg9NOnzq5fclJV9vIQews4SyaU8MZIJ7i5BGcPNopaQX7jVQGEdNcD2w8bHmH
         HEQiKxE7P2GWm9EjM2rSNFfU0aDg+Jvg9e1I9G6pbirsRucOd/gBX8+z7eTD6olIciN0
         yp1fr9ZFaRom1AZt6+UKIAr58g3m2Hu3bdWeS0vE1L/wxGuXi4d1nyrUjLxOeroyu8mk
         ZU8bRD4QBly3i5tERBojooseQ7TJR9orVsOsx7/hxOgPGbZ+Z1nBOtAv6Xqew3R6/yY4
         I4/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQp2RWTpwq8hqcrZuXmCjOHU9OdJof/OjSX7WEv7y+6imC+nBETQtJ4z7Q7RAg8RZGORs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFd9mdm7I+rRJOZw2MUMTpAnEW+gbGzixE48S05dnzp49l0/wx
	6AvwYIU/HHhE1aKit6Rfx/8oGOxk5cTNxq3KAf9SWzENmbSz6Kg9LP3t8vI9UDVu35FEAqKq85D
	rn8au38YqSt8LECw4KJmYGy3hc5ik+4yqKLVRMtn8IZGagSgheQ==
X-Gm-Gg: ASbGncuiXEOFz/tgNot11OoSMsFEEOvlFOrrFknUZdUTeTtJOPKxYylRZolQN4PIjiU
	117bqb+64Cif11oNfGXVQcJDmIYdwF8tWN9e+Tvw/TJiaPldxb85cT7D11B5p865jc6I+cKuLD+
	Azy+CQaJ+qLAwcy5dx3/kKdXC63M/8HwS/ZODwzNyYEhQNgtAnNWo53ZCKkt1cQO/vHJClDhNXg
	AuFNmgTuuqAc5ZTG25QKFsx4yF5qGgrjkY9ivrPGU/kyI5WfACz7Y27Sdx0jC1nfVjI1mep3ObU
	9oyvGCNKi1cyIWrunnuzFw==
X-Received: by 2002:a05:600c:3b9d:b0:43c:fe15:41c9 with SMTP id 5b1f17b1804b1-43db6227a09mr118810525e9.9.1743523916376;
        Tue, 01 Apr 2025 09:11:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeSHmn91hmeZ7x284dZn+qQrcC5V3D8Ul3VDkKtIvDkX2ROgQp+v6dSPuSJJ1Vzfw+gbjPKg==
X-Received: by 2002:a05:600c:3b9d:b0:43c:fe15:41c9 with SMTP id 5b1f17b1804b1-43db6227a09mr118810055e9.9.1743523915943;
        Tue, 01 Apr 2025 09:11:55 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82efe9d1sm203529975e9.24.2025.04.01.09.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:53 -0700 (PDT)
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
Subject: [PATCH 17/29] KVM: x86: block creating irqchip if planes are active
Date: Tue,  1 Apr 2025 18:10:54 +0200
Message-ID: <20250401161106.790710-18-pbonzini@redhat.com>
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

Force creating the irqchip before planes, so that APICV_INHIBIT_REASON_ABSENT
only needs to be removed from plane 0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 6 ++++--
 arch/x86/kvm/x86.c             | 4 ++--
 include/linux/kvm_host.h       | 1 +
 virt/kvm/kvm_main.c            | 1 +
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e1c67bc6df47..16d836b954dc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -882,6 +882,8 @@ On s390, a dummy irq routing table is created.
 Note that on s390 the KVM_CAP_S390_IRQCHIP vm capability needs to be enabled
 before KVM_CREATE_IRQCHIP can be used.
 
+The interrupt controller must be created before any extra VM planes.
+
 
 4.25 KVM_IRQ_LINE
 -----------------
@@ -7792,8 +7794,8 @@ used in the IRQ routing table.  The first args[0] MSI routes are reserved
 for the IOAPIC pins.  Whenever the LAPIC receives an EOI for these routes,
 a KVM_EXIT_IOAPIC_EOI vmexit will be reported to userspace.
 
-Fails if VCPU has already been created, or if the irqchip is already in the
-kernel (i.e. KVM_CREATE_IRQCHIP has already been called).
+Fails if VCPUs or planes have already been created, or if the irqchip is
+already in the kernel (i.e. KVM_CREATE_IRQCHIP has already been called).
 
 7.6 KVM_CAP_S390_RI
 -------------------
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f70d9a572455..653886e6e1c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6561,7 +6561,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = -EEXIST;
 		if (irqchip_in_kernel(kvm))
 			goto split_irqchip_unlock;
-		if (kvm->created_vcpus)
+		if (kvm->created_vcpus || kvm->has_planes)
 			goto split_irqchip_unlock;
 		/* Pairs with irqchip_in_kernel. */
 		smp_wmb();
@@ -7087,7 +7087,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			goto create_irqchip_unlock;
 
 		r = -EINVAL;
-		if (kvm->created_vcpus)
+		if (kvm->created_vcpus || kvm->has_planes)
 			goto create_irqchip_unlock;
 
 		r = kvm_pic_init(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 16a8b3adb76d..152dc5845309 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -883,6 +883,7 @@ struct kvm {
 	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
+	bool has_planes;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb04fe6f8a2c..db38894f6fa3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5316,6 +5316,7 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 		return fd;
 
 	plane = kvm_create_vm_plane(kvm, id);
+	kvm->has_planes = true;
 	if (IS_ERR(plane)) {
 		r = PTR_ERR(plane);
 		goto put_fd;
-- 
2.49.0


