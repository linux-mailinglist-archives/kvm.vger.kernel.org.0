Return-Path: <kvm+bounces-42341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93150A77FEA
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D0E91890B67
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CE5215160;
	Tue,  1 Apr 2025 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQtI8A26"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3952144C3
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523895; cv=none; b=tkkxEg9aTFu6fwFAAq0mEvYWFYSTaa57uMCTX0ZkaFaxGf0dBH4VK0eCdWdISSDdyt2edUS5sB1fMUkCM6t2BZYeR59cFo0S2bu/0NVMwqR2V5UcCv443BmzlVSaiau5JcuG1hAMMkp63imPUTTDnLD0+BaD7lvhE+ygsMFOsu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523895; c=relaxed/simple;
	bh=U6yMn8cBq8sVKBGacb4GZasvrwVKcSNV989ya6C5aGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezl7ZP1xrDHRAmuPCXCtkr/dmJTLGNJRpqzJi1OeI8zZC59x5a4aeid8WINVZGRYcepG6qgeJN4e8DfEA/evDedKYb6NvULz+xMLZvLKZJnIHsSCNhmh9GFjXgy7ceOMBQxBqOci+JuD++wkyT92po8fm5vnjrKavilDiMKQoFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQtI8A26; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cb+CmZ3WRWsV/9FrwrAoBArv5drunjdteeEUhGgbJHE=;
	b=CQtI8A26YnHrQt+6Qg0Bk+apGVLrlhynA0T2Py6NMZ4mwskgTs3I3QxcCh9j82COwGIvuO
	gDIaJo4k0j/Jyu5vXxnO4+SSmXzblBIKK0bI37U7RlNJgOM2g03TgaV71osqEOS/VoL86b
	76z58bQDeSNMYdtP/Bgw4HoHdakS0uA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-YyhRx63DNua0tz1SKOm8iw-1; Tue, 01 Apr 2025 12:11:31 -0400
X-MC-Unique: YyhRx63DNua0tz1SKOm8iw-1
X-Mimecast-MFC-AGG-ID: YyhRx63DNua0tz1SKOm8iw_1743523890
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3978ef9a284so2694217f8f.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523890; x=1744128690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cb+CmZ3WRWsV/9FrwrAoBArv5drunjdteeEUhGgbJHE=;
        b=qXuS3nZrp+7CYTbFBRnmiNgEBKlNufYFy+C846SITi6G9yqhVy/GEVQK98ihJXPHsV
         DHfLrQAqxL95uMlKctHF/v5XMRV7KSAToYF0hMhkAYOSPQOlprnr8o0fbNw6FOosJ1IK
         2mFiZTYQ/+2xTmLb3v87d79I9Vofn1jYpLtiZ5ivWTPjJ+csu2bTl6oJzcXQ//d6pGc8
         cFaAaEvxKoar966KlL8gLCAQnTB1Ho/JJdLUY5ZnBW1IKFDak/ZrbcJD3mDjNEWa1Tff
         PoVmP0rJUnWTzXRWNjbTKGHPyQpS0GiH0bjssPcy9zxcd3B2pt2RYyQthDB5SJeifhjZ
         oP0A==
X-Forwarded-Encrypted: i=1; AJvYcCXl9IlHlYvWhPZXoESPumKe2jVMGxierIdX1ZO/BWc+Uxhjk29EpucH1JYqL+L43eamJXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnAhcH2kZGOXMa1gUwgp8AiSfCDIPn8C2gNmWAfcrstczvmxHZ
	npjXJvzwFXQhw5lXmv/rOvsZnppP5NSgwRUG7NCmzsxO8HKf8mqKl9XaEuSKtzqGnOkthTyAdVO
	SuqCJo5zBd9ckbddX3Fs/JTpRCXXK7dROyR6eeGci2pdi9dz5zrmCGOT6uw==
X-Gm-Gg: ASbGncsq9v+j5+gswM7eqjXZACiTSrqZg7BbUdHQqENaQJX0MfoZU2SdyjkUJ+uahG7
	l4ShVLU9fM4V74qYmwSDBDhANa+eixvB3fB+m9XsZxWAGCDDIFA2rBL8SOcKjl8G/mPho3m5QY/
	p3ePgmrL1vgS80EZYWlrDZC9+fqItREy6eowX5zZGY9aq9Qq/k/uV2w91O5W4vXBFNgzbEYZHgw
	6WJ6mh9DQlhc9Y6Wp7KsxJOdmwy3rjszItsrN/Fuu5c+0Zqbttk8f7GNLM7P0ccoumRdC5DLk0E
	CEjGcSIOQIZFRcimMx25Kg==
X-Received: by 2002:a05:6000:2406:b0:39c:1424:2827 with SMTP id ffacd0b85a97d-39c1424288amr10394879f8f.15.1743523890032;
        Tue, 01 Apr 2025 09:11:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4bSLgkcclAnLgXImQoVywXonho7NhGNG6jPdFeVRkXIeTp4vzQ53xbuKaIBnWKYfV8gHRsg==
X-Received: by 2002:a05:6000:2406:b0:39c:1424:2827 with SMTP id ffacd0b85a97d-39c1424288amr10394829f8f.15.1743523889638;
        Tue, 01 Apr 2025 09:11:29 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b663617sm14614220f8f.34.2025.04.01.09.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:28 -0700 (PDT)
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
Subject: [PATCH 08/29] KVM: move vcpu_array to struct kvm_plane
Date: Tue,  1 Apr 2025 18:10:45 +0200
Message-ID: <20250401161106.790710-9-pbonzini@redhat.com>
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

Different planes may have only a subset of the vCPUs available in
the initial plane, therefore vcpu_array must also be moved to
struct kvm_plane.  New functions allow accessing the vCPUs of
a struct kvm_plane and, as usual, the older names automatically
go through kvm->planes[0].

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h | 29 +++++++++++++++++++++--------
 virt/kvm/kvm_main.c      | 22 +++++++++++++++-------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0db27814294f..0a91b556767e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -763,6 +763,7 @@ struct kvm_memslots {
 
 struct kvm_plane {
 	struct kvm *kvm;
+	struct xarray vcpu_array;
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_locks (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
@@ -795,7 +796,6 @@ struct kvm {
 	struct kvm_memslots __memslots[KVM_MAX_NR_ADDRESS_SPACES][2];
 	/* The current active memslot set for each address space */
 	struct kvm_memslots __rcu *memslots[KVM_MAX_NR_ADDRESS_SPACES];
-	struct xarray vcpu_array;
 
 	struct kvm_plane *planes[KVM_MAX_VCPU_PLANES];
 
@@ -990,20 +990,20 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 				      !refcount_read(&kvm->users_count));
 }
 
-static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
+static inline struct kvm_vcpu *kvm_get_plane_vcpu(struct kvm_plane *plane, int i)
 {
-	struct kvm_vcpu *vcpu = xa_load(&kvm->vcpu_array, i);
+	struct kvm_vcpu *vcpu = xa_load(&plane->vcpu_array, i);
 	if (vcpu && unlikely(vcpu->plane == -1))
 		return NULL;
 
 	return vcpu;
 }
 
-#define kvm_for_each_vcpu(idx, vcpup, kvm)			\
-	xa_for_each(&kvm->vcpu_array, idx, vcpup)		\
+#define kvm_for_each_plane_vcpu(idx, vcpup, plane_)				\
+	xa_for_each(&(plane_)->vcpu_array, idx, vcpup)		\
 		if ((vcpup)->plane == -1) ; else		\
 
-static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
+static inline struct kvm_vcpu *kvm_get_plane_vcpu_by_id(struct kvm_plane *plane, int id)
 {
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long i;
@@ -1011,15 +1011,28 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 	if (id < 0)
 		return NULL;
 	if (id < KVM_MAX_VCPUS)
-		vcpu = kvm_get_vcpu(kvm, id);
+		vcpu = kvm_get_plane_vcpu(plane, id);
 	if (vcpu && vcpu->vcpu_id == id)
 		return vcpu;
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	kvm_for_each_plane_vcpu(i, vcpu, plane)
 		if (vcpu->vcpu_id == id)
 			return vcpu;
 	return NULL;
 }
 
+static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
+{
+	return kvm_get_plane_vcpu(kvm->planes[0], i);
+}
+
+#define kvm_for_each_vcpu(idx, vcpup, kvm)				\
+	kvm_for_each_plane_vcpu(idx, vcpup, kvm->planes[0])
+
+static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
+{
+	return kvm_get_plane_vcpu_by_id(kvm->planes[0], id);
+}
+
 void kvm_destroy_vcpus(struct kvm *kvm);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eba02cb7cc57..cd4dfc399cad 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -481,12 +481,19 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 void kvm_destroy_vcpus(struct kvm *kvm)
 {
+	int j;
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_vcpu_destroy(vcpu);
-		xa_erase(&kvm->vcpu_array, i);
+	for (j = ARRAY_SIZE(kvm->planes) - 1; j >= 0; j--) {
+		struct kvm_plane *plane = kvm->planes[j];
+		if (!plane)
+			continue;
+
+		kvm_for_each_plane_vcpu(i, vcpu, plane) {
+			kvm_vcpu_destroy(vcpu);
+			xa_erase(&plane->vcpu_array, i);
+		}
 	}
 
 	atomic_set(&kvm->online_vcpus, 0);
@@ -1110,6 +1117,7 @@ static struct kvm_plane *kvm_create_vm_plane(struct kvm *kvm, unsigned plane_id)
 	plane->kvm = kvm;
 	plane->plane = plane_id;
 
+	xa_init(&plane->vcpu_array);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	xa_init(&plane->mem_attr_array);
 #endif
@@ -1137,7 +1145,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	mutex_init(&kvm->slots_arch_lock);
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
-	xa_init(&kvm->vcpu_array);
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
@@ -3930,6 +3937,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	int nr_vcpus, start, i, idx, yielded;
 	struct kvm *kvm = me->kvm;
+	struct kvm_plane *plane = kvm->planes[me->plane];
 	struct kvm_vcpu *vcpu;
 	int try = 3;
 
@@ -3967,7 +3975,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 		if (idx == me->vcpu_idx)
 			continue;
 
-		vcpu = xa_load(&kvm->vcpu_array, idx);
+		vcpu = xa_load(&plane->vcpu_array, idx);
 		if (!READ_ONCE(vcpu->ready))
 			continue;
 		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
@@ -4192,7 +4200,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 */
 	vcpu->plane = -1;
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
+	r = xa_insert(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
 	WARN_ON_ONCE(r == -EBUSY);
 	if (r)
 		goto unlock_vcpu_destroy;
@@ -4228,7 +4236,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 kvm_put_xa_erase:
 	mutex_unlock(&vcpu->mutex);
 	kvm_put_kvm_no_destroy(kvm);
-	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
+	xa_erase(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
-- 
2.49.0


