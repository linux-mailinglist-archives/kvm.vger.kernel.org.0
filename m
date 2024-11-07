Return-Path: <kvm+bounces-31081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0AF29C0152
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56160B21A4E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5036B1E6339;
	Thu,  7 Nov 2024 09:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAz+eqFy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2CC1E260F
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972431; cv=none; b=nid3kILHukMOeqJzockFEvZuuKwtn99uE1oYed3THunUOPJt718+EzwU08KOboCrkzPKmYq3OZQHuO71CCHGFyVwIplaQoSa2CS4XOghMsnoxB27Sbc3KM9vfTv9MNU+QiCYhYx/1i+ZovsAoQZYtTwdj1mHZtUHqKUL3TPBFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972431; c=relaxed/simple;
	bh=b8QiS4iAgyveI0VnUcGujWpksK44ypQ4/17QHKTahCI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9+IdK1vbEOCntsSgeOF8iTAAvgdz+Y9QBqGpeUtlojVFT1IzGTRhzGGECi5mAJTyyROz+DPhOidGJm0vhpxW5UWkedCekDCCr0xxZxQ+r0Nku96g5qynQGIZwjt5F4aRezBwQhIy6YXpPUk95GxswHOdlbYtixsbkxbzzrphyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAz+eqFy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730972428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TfljcNBhF9C0Z/2BV2Oaq2DDL+Em2rYM63JxIdUTLQ=;
	b=NAz+eqFyn3so1Zck8d2UhEmYpWe71tIHZAgD/B0Gkd2rmKle4RJqQlLUVtQrND0Wi7Aq5Z
	QS1mQcVt+OyHVqr2NqhsWhpkjfj3J2kGBcMZB+LUTXHxA4+EiZZzmAhXcxTy0cgorADDpF
	tmaP64ZN78cowZij+Js+tslox2RCPSc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-1h42Cmh5OJOPx15S4PD9GA-1; Thu,
 07 Nov 2024 04:40:24 -0500
X-MC-Unique: 1h42Cmh5OJOPx15S4PD9GA-1
X-Mimecast-MFC-AGG-ID: 1h42Cmh5OJOPx15S4PD9GA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F0801954B0E;
	Thu,  7 Nov 2024 09:40:22 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7765A1955F40;
	Thu,  7 Nov 2024 09:40:19 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	broonie@kernel.org,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	pbonzini@redhat.com
Subject: [PATCH  3/3] KVM: selftests: Handle dead VM in vgic_init test
Date: Thu,  7 Nov 2024 10:38:50 +0100
Message-ID: <20241107094000.70705-4-eric.auger@redhat.com>
In-Reply-To: <20241107094000.70705-1-eric.auger@redhat.com>
References: <20241107094000.70705-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Commit df5fd75ee305 ("KVM: arm64: Don't eagerly teardown the vgic on init
error") changed the way the error is handled in case of incomplete
vgic setup. Now a KVM_REQ_VM_DEAD request is sent causing subsequent
KVM ioctl to fail. This now triggers a test assertion failure in
kvm_vm_free() which calls KVM_SET_USER_MEMORY_REGION2 ioctl.

Update the test so that it checks that after the partial vgic setup
the KVM_REQ_VM_DEAD has been sent and use the new kvm_vm_dead_free()
helper to free the resources.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/3f0918bf-0265-4714-9660-89b75da49859@sirena.org.uk/
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 41 +++++++++++--------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index b3b5fb0ff0a9..845108afce5e 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -101,6 +101,12 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
 
+static void vm_dead_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_dead_free(v->vm);
+}
+
 struct vgic_region_attr {
 	uint64_t attr;
 	uint64_t size;
@@ -335,7 +341,7 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	int ret, i;
+	int i;
 
 	v = vm_gic_create_with_vcpus(gic_dev_type, 1, vcpus);
 
@@ -345,10 +351,10 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 	for (i = 1; i < NR_VCPUS; ++i)
 		vcpus[i] = vm_vcpu_add(v.vm, i, guest_code);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "dist/rdist overlap detected on 1st vcpu run");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 }
 
 /* All the VCPUs are created before the VGIC KVM device gets initialized */
@@ -356,16 +362,15 @@ static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	int ret;
 
 	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, vcpus);
 
 	subtest_dist_rdist(&v);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "dist/rdist overlap detected on 1st vcpu run");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 }
 
 #define KVM_VGIC_V2_ATTR(offset, cpu) \
@@ -415,9 +420,9 @@ static void test_v3_new_redist_regions(void)
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
-	vm_gic_destroy(&v);
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "running without sufficient number of rdists");
+	vm_dead_gic_destroy(&v);
 
 	/* step2 */
 
@@ -428,10 +433,10 @@ static void test_v3_new_redist_regions(void)
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -EBUSY, "running without vgic explicit init");
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "running without vgic explicit init");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 
 	/* step 3 */
 
@@ -604,8 +609,8 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	int ret, i;
 	uint64_t addr;
+	int i;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, vcpus);
 
@@ -626,11 +631,11 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	/* Attempt to run a vcpu without enough redist space. */
-	ret = run_vcpu(vcpus[2]);
-	TEST_ASSERT(ret && errno == EINVAL,
+	run_vcpu(vcpus[2]);
+	TEST_ASSERT(vm_dead(v.vm),
 		"redist base+size above PA range detected on 1st vcpu run");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 }
 
 static void test_v3_its_region(void)
-- 
2.41.0


