Return-Path: <kvm+bounces-42339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB581A77FE7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F5851890E26
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF3A210F45;
	Tue,  1 Apr 2025 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhUmYcxt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C46520D4E4
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523891; cv=none; b=gSlT/H1o6WYQiYJ7BTHbm/J1ygo0crR45sZYq4JPDZg03PUIUIrs0oB9T4/fSsYyh94XMi+mhnaFXM4uL9qypdjQUqRcL6QZynxS/JqcIwQ3WvZKkYuDpE/FvvxhCYciZp2DIGVyudcvHQOjTIOz60smu7DKjYiIvAjwrTYQfiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523891; c=relaxed/simple;
	bh=rxM4+r5oKn3FrtYxyoYERVyr2vDI5fg2rK7DFIuTtwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJd4oiJxylthshM6yl5TL3AgpueKMafVf5vRrj2xEYDg2vfeztJ6GOCTApGw6fG+46eAA7fn/xJNaweDpy/niQbgS7p4pPZHiCbL53rOJttBxquBUDIqSliiv1BPyuhPhpyVhnorCErBwTl2RhIlWaAsrK/gF0OYwd/+rD2oP4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhUmYcxt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QaUbfvoP8aPmiGrV9eVE67gclsfaX3jw4nCiV/n0Ni4=;
	b=IhUmYcxtic8Q9if2rKECo1cInoFfMkAL0cg/T0W35PE+Gnu5EbnostFWRbyHWlOlGEygoN
	PCVECvikEWwOXA/AMxqn59MDg86W7UWJz9k6HP2pXnFdyzP6zZLHKqFgagyybrzRmWaEpE
	TAMOiiGL++EPmVCL8vbFrTFKWav0DYY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-bJp1DRXIMIK20Z9sgXlYkw-1; Tue, 01 Apr 2025 12:11:25 -0400
X-MC-Unique: bJp1DRXIMIK20Z9sgXlYkw-1
X-Mimecast-MFC-AGG-ID: bJp1DRXIMIK20Z9sgXlYkw_1743523883
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cec217977so33423885e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523883; x=1744128683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QaUbfvoP8aPmiGrV9eVE67gclsfaX3jw4nCiV/n0Ni4=;
        b=dMVsxyXKBLhUeTXsmjQk8OrTkIbNhU3uy65pVzB3dBmHauOiQd0TSzd/vb2WYy/e3n
         MmJCWWyXzLRFuqDbpFSY+g0+bWlaAMIpGCerM9xryV5Q0ecyGzL14bTDpgQxSPx5TjIG
         0a+TUZ59hF++hHHm+l3WQrIh49H5flrASSmQCr2cQk9RcWBW4SZkFBUl9n9bS7PuSsKJ
         Kl/hAt5bP17ia02Iw/I0w9Vqfn5N+EVY4LaNhR/NUTW1ix0iOxZg+reIZ1iJYhvzR0vS
         4bDcWvmj2Ix7MZb+i0SVmAReribh8zqT7L05jQ+0dVW7n7gr9KO3nqQN0rNgBnnB3NLh
         Zt/A==
X-Forwarded-Encrypted: i=1; AJvYcCVQap0v+1scgOYcMTQCks2Dk4X80KxlawUjYgKSHgUxLe/Ilo18OCtdaGL7jJT7a0aFQI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWWQAG5e9q95g78iNxO46yUFSTIdnH10+3TMzlW5rjVLn91Cgd
	1LOJSEBPFsew7gE2wGeUrEnrp8mEa7f0BHVGVpxXewqVPbBjhhFFqJfYr4xLBJWBCWomgTd3CHk
	MNedkD+P5jwDRRJoEALOI9Zj0HC4PWMlxJLn+dPxTZ3NzcNlgTA==
X-Gm-Gg: ASbGncuGTbrELLqRFmtAm/P0/13Uc1ln4ZcnBeuUIpJxY1c/8B8nSyMGwdv5hVT2gZl
	E0M378wJwt4/txHIhdqoXZV73S0QitpAwKgZajCh0rzmwN8WnZnVSIthH1voBdBbdVGOnP8OeyG
	O+j3CPhItRB/cuLjmVocMfIB/X2jYLLOw/Ik0qGnQdNGf9qlkV+dLuJkbRoo+HEE1EM0XZu6DT5
	CbKPAK1NNQkVbAS0HmxTzy065Pj5/E5dJn3KOA6bo2qDzifKPVA5H88KLNTpMgObeRSV1yCOTU+
	qDlW1D0qCjmF2VIwlye+WA==
X-Received: by 2002:a05:600c:cc8:b0:43d:b3:fb1 with SMTP id 5b1f17b1804b1-43ea5f001b7mr45448985e9.27.1743523883239;
        Tue, 01 Apr 2025 09:11:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZdEWzHsg0YswCSXrdzj6ch9i3n9G2iz9TWc1mNERKBxpVsH1+e/xNG+caFFDjVEabapAovQ==
X-Received: by 2002:a05:600c:cc8:b0:43d:b3:fb1 with SMTP id 5b1f17b1804b1-43ea5f001b7mr45447655e9.27.1743523881889;
        Tue, 01 Apr 2025 09:11:21 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66ab86sm14896816f8f.51.2025.04.01.09.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:20 -0700 (PDT)
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
Subject: [PATCH 05/29] KVM: add plane support to KVM_SIGNAL_MSI
Date: Tue,  1 Apr 2025 18:10:42 +0200
Message-ID: <20250401161106.790710-6-pbonzini@redhat.com>
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

struct kvm_kernel_irq_routing_entry is the main tool for sending
cross-plane IPIs.  Make kvm_send_userspace_msi the first function to
accept a struct kvm_plane pointer, in preparation for making it available
from plane file descriptors.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h | 3 ++-
 virt/kvm/irqchip.c       | 5 ++++-
 virt/kvm/kvm_main.c      | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6bd9b0b3cbee..98bae5dc3515 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -684,6 +684,7 @@ struct kvm_kernel_irq_routing_entry {
 			u32 data;
 			u32 flags;
 			u32 devid;
+			u32 plane;
 		} msi;
 		struct kvm_s390_adapter_int adapter;
 		struct kvm_hv_sint hv_sint;
@@ -2218,7 +2219,7 @@ static inline int kvm_init_irq_routing(struct kvm *kvm)
 
 #endif
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+int kvm_send_userspace_msi(struct kvm_plane *plane, struct kvm_msi *msi);
 
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 162d8ed889f2..84952345e3c2 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -45,8 +45,10 @@ int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	return irq_rt->chip[irqchip][pin];
 }
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+int kvm_send_userspace_msi(struct kvm_plane *plane, struct kvm_msi *msi)
 {
+	struct kvm *kvm = plane->kvm;
+	unsigned plane_id = plane->plane;
 	struct kvm_kernel_irq_routing_entry route;
 
 	if (!kvm_arch_irqchip_in_kernel(kvm) || (msi->flags & ~KVM_MSI_VALID_DEVID))
@@ -57,6 +59,7 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
 	route.msi.data = msi->data;
 	route.msi.flags = msi->flags;
 	route.msi.devid = msi->devid;
+	route.msi.plane = plane_id;
 
 	return kvm_set_msi(&route, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1, false);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e83db27580da..5b44a7f9e52e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5207,7 +5207,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&msi, argp, sizeof(msi)))
 			goto out;
-		r = kvm_send_userspace_msi(kvm, &msi);
+		r = kvm_send_userspace_msi(kvm->planes[0], &msi);
 		break;
 	}
 #endif
-- 
2.49.0


