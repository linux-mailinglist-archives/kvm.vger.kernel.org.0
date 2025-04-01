Return-Path: <kvm+bounces-42358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64454A7801E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A799D3B1892
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBFE223322;
	Tue,  1 Apr 2025 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F1ZcQn58"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC2922258B
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523940; cv=none; b=pNrtnEUoE9vERWmHHIzTlT1wawTCb55q5vuMV+HHkIuL/CRzsQpzMUjqnrI1m1ibaRYq9U1fCtKybKxM+VIdteZca85nzNzzQ/bwx59fP8uba0dyu3ziVmRU1R4sq5bBh75TjyWn3ttZ0g0IKq+oF+g28jowAFhL6GIW5w0ydaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523940; c=relaxed/simple;
	bh=RqolX2nBYsBB1RvK+C0gqm089aXRe/tRZbLNpfcHISU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJfqsVykdZ9YIj/TFUs05i53qyENN1ArKABGwwsVipSfxbJPzIQuEohBUZqnsm/Gsj710UOISkaZdJyNWh9xDcEOBXaeMAZr2Dp9H59jGFhJ4wDrlforAxF6hgobVtUpTHQPpOzASz9iCFpbqLP4rZCEl8AIclh4OacLYr0GrhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F1ZcQn58; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/yWeFqVMRebyIXvHSXUhfNNjcs9eft8Ib/p8yK7977Q=;
	b=F1ZcQn58tH/socWyYuYFQvlkLpYktVg9GFzXT7jCn/Q3HqmcpTR9Wqnh69mW12INi9Jw/2
	r+ckAfgyQNEU4CfpW5ND9TKWWqr/b6e/FMSaABBXxS1qSzvTGz7KPsyQUlDG41wYsxLef+
	V8r4wQsCYqe9608qqTZYNgu/B2vH068=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-JFEaHDMfPJyL75a0LamuwQ-1; Tue, 01 Apr 2025 12:12:16 -0400
X-MC-Unique: JFEaHDMfPJyL75a0LamuwQ-1
X-Mimecast-MFC-AGG-ID: JFEaHDMfPJyL75a0LamuwQ_1743523935
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso37269795e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523935; x=1744128735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/yWeFqVMRebyIXvHSXUhfNNjcs9eft8Ib/p8yK7977Q=;
        b=GxVPkQqrGtnhB+JCsk0CHpkO36lSzxqchFvwvj+9poieAHOAPQ6q6QMuSBab3YS09M
         P01GwUN+KWIT1Jw9v07IKdHx66N6OdgJQcs+EL7eyvgFpPWmldFUmHb8nJxgfGrRHIsl
         MM3tv1dTC2bDgt6ZC126iv++bRwIhJDCjW5IMnxDjxvxueKPlhqdU9cmhLjNcrrIiLVo
         LIWuHS6EsIG5wtfKT0zOg6rbhXzj1wxO3bGOKwHunJCZRN8HvrMdDkQUYP4nHGP9lz+f
         5L+M+uTV7WG5amOJR5BnYzIJ9jNRggbOG6loPFhiT6MJPY+Yr3uufKVcMUXSPVBZHKIb
         PFaA==
X-Forwarded-Encrypted: i=1; AJvYcCXKmR7B7BT8lSttZ3pTceGEvYtpOWt6FUQJa0aq6+HyeiefEkHoXR/dWEZkPyxRJsv+AW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKJtQePVMMadI/RXH0kR6g/JNQbFdypHfA2fHLJp9nvmWX6RFA
	j8sppH3S+67778HpJX5HWFe9D68S5bFE/DknlQFPbu5V2F8/AJZvDWDXW6SuP9e+I0jfkuTmHj0
	RZJQH+EAYWnWAwRStuHHyynoRvyws2Vk6jYPRUL/IiM6+o262Wg==
X-Gm-Gg: ASbGnctp/WNWaEuvBdWYIHxXSFod9jU+mO/INd6iP/YRdRyxIQwyK6p+PXdKII+97FY
	4QBJWVisX3vm3iUCU3YwLKs7rBPbfa+RhJlknY53zFxs6vwBgq/ktV4Cd18MbO74ZYDPjrG3VFa
	a9X2/EfkcHmazG7h6DDn7Om/NhPIuTQUdE+R5G6nCW2yEtmSN/puteQrq5LOooaxG4ry1+tWbyv
	naHou8xlwjyo8qgRyGKNshAz2+peOU2OPTXbscHQ26fI71e6iebs44r0wYfh3Caxf1m8gM3ISM9
	81A1mRU2NMXaiu0g+HMXog==
X-Received: by 2002:a5d:584c:0:b0:391:4559:8761 with SMTP id ffacd0b85a97d-39c1211394bmr11532838f8f.36.1743523935285;
        Tue, 01 Apr 2025 09:12:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdiNekii4PSYbxjvDp66z82YdwPHoAMXYlQUesXdMmLvzhLibRLalKupSShxNYAuhAEstwpw==
X-Received: by 2002:a5d:584c:0:b0:391:4559:8761 with SMTP id ffacd0b85a97d-39c1211394bmr11532793f8f.36.1743523934852;
        Tue, 01 Apr 2025 09:12:14 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d900008d8sm158223435e9.33.2025.04.01.09.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:13 -0700 (PDT)
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
Subject: [PATCH 24/29] KVM: x86: initialize CPUID for non-default planes
Date: Tue,  1 Apr 2025 18:11:01 +0200
Message-ID: <20250401161106.790710-25-pbonzini@redhat.com>
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

Copy the initial CPUID from plane 0.  To avoid mismatches, block
KVM_SET_CPUID{,2} after KVM_CREATE_VCPU_PLANE similar to how it is
blocked after KVM_RUN; this is handled by a tiny bit of architecture
independent code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst |  4 +++-
 arch/x86/kvm/cpuid.c           | 19 ++++++++++++++++++-
 arch/x86/kvm/cpuid.h           |  1 +
 arch/x86/kvm/x86.c             |  7 ++++++-
 include/linux/kvm_host.h       |  1 +
 virt/kvm/kvm_main.c            |  1 +
 6 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 16d836b954dc..3739d16b7164 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -736,7 +736,9 @@ Caveat emptor:
     configuration (if there is) is not corrupted. Userspace can get a copy
     of the resulting CPUID configuration through KVM_GET_CPUID2 in case.
   - Using KVM_SET_CPUID{,2} after KVM_RUN, i.e. changing the guest vCPU model
-    after running the guest, may cause guest instability.
+    after running the guest, is forbidden; so is using the ioctls after
+    KVM_CREATE_VCPU_PLANE, because all planes must have the same CPU
+    capabilities.
   - Using heterogeneous CPUID configurations, modulo APIC IDs, topology, etc...
     may cause guest instability.
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 142decb3a736..44e6d4989bdd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -545,7 +545,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
-	if (kvm_vcpu_has_run(vcpu)) {
+	if (kvm_vcpu_has_run(vcpu) || vcpu->has_planes) {
 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
 		if (r)
 			goto err;
@@ -567,6 +567,23 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	return r;
 }
 
+int kvm_dup_cpuid(struct kvm_vcpu *vcpu, struct kvm_vcpu *source)
+{
+	if (WARN_ON_ONCE(vcpu->arch.cpuid_entries || vcpu->arch.cpuid_nent))
+		return -EEXIST;
+
+	vcpu->arch.cpuid_entries = kmemdup(source->arch.cpuid_entries,
+		     source->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2),
+		     GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.cpuid_entries)
+		return -ENOMEM;
+
+	memcpy(vcpu->arch.cpu_caps, source->arch.cpu_caps, sizeof(source->arch.cpu_caps));
+	vcpu->arch.cpuid_nent = source->arch.cpuid_nent;
+
+	return 0;
+}
+
 /* when an old userspace process fills a new kernel module */
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 05cc1245f570..a5983c635a70 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -42,6 +42,7 @@ static inline struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcp
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			    struct kvm_cpuid_entry2 __user *entries,
 			    unsigned int type);
+int kvm_dup_cpuid(struct kvm_vcpu *vcpu, struct kvm_vcpu *source);
 int kvm_post_set_cpuid(struct kvm_vcpu *vcpu);
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2b43d9b6543..be4d7b97367b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12412,6 +12412,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 	if (plane->plane) {
 		page = NULL;
 		vcpu->arch.pio_data = vcpu->plane0->arch.pio_data;
+		r = kvm_dup_cpuid(vcpu, vcpu->plane0);
+		if (r < 0)
+			goto fail_free_lapic;
+
+		r = -ENOMEM;
 	} else {
 		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!page)
@@ -12459,7 +12464,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
+	WARN_ON_ONCE(kvm_post_set_cpuid(vcpu));
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
 	kvm_vcpu_reset(vcpu, false);
 	kvm_init_mmu(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5cade1c04646..0b764951f461 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -344,6 +344,7 @@ struct kvm_vcpu {
 	struct mutex mutex;
 
 	/* Only valid on plane 0 */
+	bool has_planes;
 	bool wants_to_run;
 
 	/* Shared for all planes */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db38894f6fa3..3a04fdf0865d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4182,6 +4182,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm_plane *plane, struct kvm_vcpu *pl
 	if (plane->plane) {
 		page = NULL;
 		vcpu->run = plane0_vcpu->run;
+		plane0_vcpu->has_planes = true;
 	} else {
 		WARN_ON(plane0_vcpu != NULL);
 		plane0_vcpu = vcpu;
-- 
2.49.0


