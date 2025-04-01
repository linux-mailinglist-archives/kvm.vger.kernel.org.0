Return-Path: <kvm+bounces-42336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CD1A77FE0
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C96AE16C0CC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A681520E33F;
	Tue,  1 Apr 2025 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jQTmboQU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113AB20D51D
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523882; cv=none; b=OWZH5ldVEAicMlmyy1BUlO2PlYQ/qeU+/Im1hhQNTUaQlPN7XN5vJt1BK0rFNaH8HNSMy2H+TO5D9PW8DgO5b3B3wd63AVzzClHkznEDemrVhq9coJ2sU/3mtCfBwwfMqMIdgRAT2DBZbM3USrNgMOv3IEBOhE+IhBh0Xd0r45s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523882; c=relaxed/simple;
	bh=yRG3ANAcWURe86N1hf41BIQjs3HGQuEMu8uGmCkgimo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+tMjoSh7IinBE2FV6Plpn354b00Joehz2hY4UaruXtENdktyti/9bNrVMkaAAPPBo9W+R/P96YmjWqqQhr58s34BoswEy9ZI/UvcI7JuUQLxoTqadCQh4G6dmECb7sB1eZlnETMO48W8AVYYkXpdHNrYQ/x/IJiWvlnTlwSqjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jQTmboQU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C5sOJ1ZN51NGUB7AKsam1Z/J0Y4Aw58lesO8LZ+8PjM=;
	b=jQTmboQUYm7AoQG4afW+4LsLoLJM4fNyTxzVoDgfJlOeQYKS+RCGwYXwzmi6H6HxRvWEl1
	MMgPXB0aAluNlXOE/O1weYNEx5cy+Ev7SiyQyEvGS7Dpc/0sgDHIo5l/bXct72kdVsEwxb
	fhSZOY5+ncNFb8AjUv8/s0PEzDwTW6c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-1hH7ZBF4MuCK_9jPWL6E_Q-1; Tue, 01 Apr 2025 12:11:19 -0400
X-MC-Unique: 1hH7ZBF4MuCK_9jPWL6E_Q-1
X-Mimecast-MFC-AGG-ID: 1hH7ZBF4MuCK_9jPWL6E_Q_1743523878
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d0a037f97so35531455e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523878; x=1744128678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5sOJ1ZN51NGUB7AKsam1Z/J0Y4Aw58lesO8LZ+8PjM=;
        b=Grdt1BK8ahLGU+uarszeAXpynmaPqIamX5MHZzOkSGQcUkxnIid9Z6cKcRY0nSMjyF
         i8n/VQDUszsF0+tT4qpbbNGU2wbJ9W3rEdSUxmCXgwgJcL2DbRB50tPVecjw0I98FYMi
         1wbNML34UESn9HaJBHQnF5P3wm6VBvNeILvqw4n+YB1/0x/Yd3igjc/ZG8tBc/Uy0PSJ
         5h0vm2uvY1VZy9OnQk2CfteRm/Jo917kmaOxWwpqfi5GASSjreGLZ5VMcoKpWnA0SZjb
         Bo+8v8LuePIm/zSCOx+iol9J30wyEen8VIU4QtI+OnjNH+4TPlQnmZsILkAs0BQsdrKN
         oPmw==
X-Forwarded-Encrypted: i=1; AJvYcCWG66Kf/5N7OMyUZJ1TIRxebO/WgYIoEJ8fxfEIM70SDt5Ssffz1B9SAvnnC4imjRcsm68=@vger.kernel.org
X-Gm-Message-State: AOJu0YybhQr4N2Ek4sNX5WDiNR7vo7W2tj4HTxSYak3DU5OllirQKZKM
	8mVtgn54GjJQVdNdFxJKg/azETDKl1ROy4HL/sYIA2tP0KToVBlnU8g/gHrflDqzJjTwtZ1YJk2
	CG5NK036R9gA08PBhBhqmFDOTqKluAKLvCjOXvZHqK0WKeNHUmQ==
X-Gm-Gg: ASbGncvA5JysaoRl8acp/93JLW2pWsNLp7fFRfXdZ6WHdOFQVjbGhIsfVk3dfEP6lXS
	ohlYnVHQR++FwGpeBjMBitSuGZyI8DwFA0c49g3et7dJDgMFB+mlCpIx44UOl9Rl2pw98DvrayT
	KERMJTIJT/87Q3glJlOkZqxj4xzq+8FhVGvWzCYKB2N5hOuVrbu9x3UGCoZcrYMKWksfxzNkHdQ
	4PB0TcjBwScO+WYg4gsv6vYupgoukZiQrCFNLqSkM7i7YhHCy9l/3LZbKx05BWX5lsBLO0OsuGM
	aPHG2qwkMfNT/NFNb1zfLw==
X-Received: by 2002:a05:600c:198f:b0:43b:ca39:6c7d with SMTP id 5b1f17b1804b1-43db61d8326mr133339065e9.3.1743523877715;
        Tue, 01 Apr 2025 09:11:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbyCKX5Aqf5nXfh6DE7+ASXGOt8qcrXWAlRQRnDUDahaaum0QoMpdBp6Nw+tK1Bgywmh1HQw==
X-Received: by 2002:a05:600c:198f:b0:43b:ca39:6c7d with SMTP id 5b1f17b1804b1-43db61d8326mr133338495e9.3.1743523877277;
        Tue, 01 Apr 2025 09:11:17 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b7a4294sm14189742f8f.89.2025.04.01.09.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:15 -0700 (PDT)
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
Subject: [PATCH 03/29] KVM: add plane info to structs
Date: Tue,  1 Apr 2025 18:10:40 +0200
Message-ID: <20250401161106.790710-4-pbonzini@redhat.com>
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

Add some of the data to move from one plane to the other within a VM,
typically from plane N to plane 0.

There is quite some difference here because while separate planes provide
very little of the vm file descriptor functionality, they are almost fully
functional vCPUs except that non-zero planes(*) can only be ran indirectly
through the initial plane.

Therefore, vCPUs use struct kvm_vcpu for all planes, with just a couple
fields that will be added later and will only be valid for plane 0.  At
the VM level instead plane info is stored in a completely different struct.
For now struct kvm_plane has no architecture-specific counterpart, but this
may change in the future if needed.  It's possible for example that some MMU
info becomes per-plane in order to support per-plane RWX permissions.

(*) I will restrain from calling them astral planes.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h  | 17 ++++++++++++++++-
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c8f1facdb600..0e16c34080ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -84,6 +84,10 @@
 #define KVM_MAX_NR_ADDRESS_SPACES	1
 #endif
 
+#ifndef KVM_MAX_VCPU_PLANES
+#define KVM_MAX_VCPU_PLANES		1
+#endif
+
 /*
  * For the normal pfn, the highest 12 bits should be zero,
  * so we can mask bit 62 ~ bit 52  to indicate the error pfn,
@@ -332,7 +336,8 @@ struct kvm_vcpu {
 #ifdef CONFIG_PROVE_RCU
 	int srcu_depth;
 #endif
-	int mode;
+	short plane;
+	short mode;
 	u64 requests;
 	unsigned long guest_debug;
 
@@ -367,6 +372,8 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
+	struct kvm_vcpu *plane0;
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 	/*
 	 * Cpu relax intercept or pause loop exit optimization
@@ -753,6 +760,11 @@ struct kvm_memslots {
 	int node_idx;
 };
 
+struct kvm_plane {
+	struct kvm *kvm;
+	int plane;
+};
+
 struct kvm {
 #ifdef KVM_HAVE_MMU_RWLOCK
 	rwlock_t mmu_lock;
@@ -777,6 +789,9 @@ struct kvm {
 	/* The current active memslot set for each address space */
 	struct kvm_memslots __rcu *memslots[KVM_MAX_NR_ADDRESS_SPACES];
 	struct xarray vcpu_array;
+
+	struct kvm_plane *planes[KVM_MAX_VCPU_PLANES];
+
 	/*
 	 * Protected by slots_lock, but can be read outside if an
 	 * incorrect answer is acceptable.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..7d0a86108d1a 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -11,6 +11,7 @@ struct kvm_interrupt;
 struct kvm_irq_routing_table;
 struct kvm_memory_slot;
 struct kvm_one_reg;
+struct kvm_plane;
 struct kvm_run;
 struct kvm_userspace_memory_region;
 struct kvm_vcpu;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f6c947961b78..67773b6b9576 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1095,9 +1095,22 @@ void __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
 }
 
+static struct kvm_plane *kvm_create_vm_plane(struct kvm *kvm, unsigned plane_id)
+{
+	struct kvm_plane *plane = kzalloc(sizeof(struct kvm_plane), GFP_KERNEL_ACCOUNT);
+
+	if (!plane)
+		return ERR_PTR(-ENOMEM);
+
+	plane->kvm = kvm;
+	plane->plane = plane_id;
+	return plane;
+}
+
 static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
+	struct kvm_plane *plane0;
 	struct kvm_memslots *slots;
 	int r, i, j;
 
@@ -1136,6 +1149,13 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	snprintf(kvm->stats_id, sizeof(kvm->stats_id), "kvm-%d",
 		 task_pid_nr(current));
 
+	plane0 = kvm_create_vm_plane(kvm, 0);
+	if (IS_ERR(plane0)) {
+		r = PTR_ERR(plane0);
+		goto out_err_no_plane0;
+	}
+	kvm->planes[0] = plane0;
+
 	r = -ENOMEM;
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
@@ -1227,6 +1247,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
 out_err_no_srcu:
+	kfree(kvm->planes[0]);
+out_err_no_plane0:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
 	return ERR_PTR(r);
@@ -1253,6 +1275,10 @@ static void kvm_destroy_devices(struct kvm *kvm)
 	}
 }
 
+static void kvm_destroy_plane(struct kvm_plane *plane)
+{
+}
+
 static void kvm_destroy_vm(struct kvm *kvm)
 {
 	int i;
@@ -1309,6 +1335,11 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	xa_destroy(&kvm->mem_attr_array);
 #endif
+	for (i = 0; i < ARRAY_SIZE(kvm->planes); i++) {
+		struct kvm_plane *plane = kvm->planes[i];
+		if (plane)
+			kvm_destroy_plane(plane);
+	}
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
 	kvm_disable_virtualization();
@@ -4110,6 +4141,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	}
 	vcpu->run = page_address(page);
 
+	vcpu->plane0 = vcpu;
 	kvm_vcpu_init(vcpu, kvm, id);
 
 	r = kvm_arch_vcpu_create(vcpu);
-- 
2.49.0


