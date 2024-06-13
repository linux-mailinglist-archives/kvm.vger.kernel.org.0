Return-Path: <kvm+bounces-19560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BBB906699
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 10:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 035B51F23128
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A65B1422C9;
	Thu, 13 Jun 2024 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGqoJCJR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359B213DDBD
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 08:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718267050; cv=none; b=QKQ2rLwxHSXHmf2X8kk2y1yy0jFnleGliIMRs6g3aIj1UDEi9bTtlXjij63QahqkpAnKaTQSdx3DD6QRYhIpgBL+v11BZY6IhxOs09qJHbpxTPRZBeIoPe+DjoypsgOf5PaqJ9+q+jNdyEdeEyr8cH+FiT1+hZrkGuP/t7kvm+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718267050; c=relaxed/simple;
	bh=GD//B4ZXbILPMr2n7FtV2W51L0tpiww8tpG/rxOSDeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DUlzlU2D8TKWN/BB2HgRrPL3slS+KrBcwcDTq3gRFyXGvNi9TGzwhrVVThr2FI+bKZoSjwfx5Faj9euB68ldIiS2b1fW3uOE93V7UYlcD1tBxsfTGgd8rEWJHsimcvI/vIPsEshnmxQuGniJOT4OzJkU+U4laEfMX2fBhrgXakE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGqoJCJR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718267048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KLRQFDUj8PtpuJnNrTsx36yB9tP6PdLdhkC2H0VO9EQ=;
	b=SGqoJCJRRLz+gDBfFf59Ub1+dbpYZ5UVI9kGEGHoHvIW7N5yLmgAQH22R5P0+a7xWibxaU
	QvFCJttflK56GP1TSmL33bIj1M+WPZ0yWp0xWcnYcnw8MKAbboCz20Hf9hNOneaiKfLcJI
	2AEaV2AgjafkcTRX8YSeXFS8EkoUKcI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-OpD-ch7GPfqlRirsoIv02A-1; Thu,
 13 Jun 2024 04:24:03 -0400
X-MC-Unique: OpD-ch7GPfqlRirsoIv02A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4213195608E;
	Thu, 13 Jun 2024 08:24:01 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5A7A19560BF;
	Thu, 13 Jun 2024 08:23:59 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 3/3] KVM: selftests: aarch64: Add invalid filter test in pmu_event_filter_test
Date: Thu, 13 Jun 2024 04:23:41 -0400
Message-Id: <20240613082345.132336-4-shahuang@redhat.com>
In-Reply-To: <20240613082345.132336-1-shahuang@redhat.com>
References: <20240613082345.132336-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add the invalid filter test which sets the filter beyond the event
space and sets the invalid action to double check if the
KVM_ARM_VCPU_PMU_V3_FILTER will return the expected error.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 .../kvm/aarch64/pmu_event_filter_test.c       | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
index fb0fde1ed436..13b2f354c39b 100644
--- a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
@@ -8,6 +8,7 @@
  * This test checks if the guest only see the limited pmu event that userspace
  * sets, if the guest can use those events which user allow, and if the guest
  * can't use those events which user deny.
+ * It also checks that setting invalid filter ranges return the expected error.
  * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILTER
  * is supported on the host.
  */
@@ -178,6 +179,40 @@ static void destroy_vpmu_vm(void)
 	kvm_vm_free(vpmu_vm.vm);
 }
 
+static void test_invalid_filter(void)
+{
+	struct kvm_pmu_event_filter invalid;
+	int ret;
+
+	pr_info("Test: test_invalid_filter\n");
+
+	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
+
+	vpmu_vm.vm = vm_create(1);
+	vpmu_vm.vcpu = vm_vcpu_add_with_vpmu(vpmu_vm.vm, 0, guest_code);
+	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
+	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
+		       "Failed to create vgic-v3, skipping");
+
+	/* The max event number is (1 << 16), set a range largeer than it. */
+	invalid = __DEFINE_FILTER(BIT(15), BIT(15) + 1, 0);
+	ret = __kvm_device_attr_set(vpmu_vm.vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+				    KVM_ARM_VCPU_PMU_V3_FILTER, &invalid);
+	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter range "
+		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
+		    ret, errno);
+
+	/* Set the Invalid action. */
+	invalid = __DEFINE_FILTER(0, 1, 3);
+	ret = __kvm_device_attr_set(vpmu_vm.vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+				    KVM_ARM_VCPU_PMU_V3_FILTER, &invalid);
+	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter action "
+		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
+		    ret, errno);
+
+	destroy_vpmu_vm();
+}
+
 static void run_test(struct test_desc *t)
 {
 	pr_info("Test: %s\n", t->name);
@@ -300,4 +335,6 @@ int main(void)
 	TEST_REQUIRE(kvm_pmu_support_events());
 
 	run_tests();
+
+	test_invalid_filter();
 }
-- 
2.40.1


