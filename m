Return-Path: <kvm+bounces-2730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B16387FCFD0
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 08:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E39311C20D7D
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1588A1097F;
	Wed, 29 Nov 2023 07:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jk4fVvX2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C375EE1
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 23:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701242847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9JHYtqN+twx/AtEyT3VDqnE70xU96u5kUlPvxpv06qw=;
	b=Jk4fVvX2xAu/md09BvODSHr8P6FkSujDDHtBfzZVEovocE/RyQXhHsz8M/LxPGejyHUrj2
	2rpNwnNSsxcQg1+nyXfCUkW+kWBEz2WUkrVWDJFRvSQp5WDJYERr58kDOhCDMzWqPyCCOq
	ztcOw7GsXNdWBHxzd7cLLLAFK5NBoYY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-wuFVBLUqOLii4dpAtBKsVg-1; Wed, 29 Nov 2023 02:27:24 -0500
X-MC-Unique: wuFVBLUqOLii4dpAtBKsVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30D43101A53B;
	Wed, 29 Nov 2023 07:27:24 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EAE961C060AE;
	Wed, 29 Nov 2023 07:27:23 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/5] KVM: selftests: aarch64: Introduce pmu_event_filter_test
Date: Wed, 29 Nov 2023 02:27:02 -0500
Message-Id: <20231129072712.2667337-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The test is inspired by the pmu_event_filter_test which implemented by x86. On
the arm64 platform, there is the same ability to set the pmu_event_filter
through the KVM_ARM_VCPU_PMU_V3_FILTER attribute. So add the test for arm64.

The series first move some pmu common code from vpmu_counter_access to
lib/aarch64/vpmu.c and include/aarch64/vpmu.h, which can be used by
pmu_event_filter_test. Then fix a bug related to the [enable|disable]_counter,
and at last, implement the test itself.

Changelog:
----------
v1->v2:
  - Improve the commit message.                 [Eric]
  - Fix the bug in [enable|disable]_counter.    [Raghavendra & Marc]
  - Add the check if kvm has attr KVM_ARM_VCPU_PMU_V3_FILTER.
  - Add if host pmu support the test event throught pmceid0.
  - Split the test_invalid_filter() to another patch. [Eric]

v1: https://lore.kernel.org/all/20231123063750.2176250-1-shahuang@redhat.com/

Shaoqin Huang (5):
  KVM: selftests: aarch64: Make the [create|destroy]_vpmu_vm() public
  KVM: selftests: aarch64: Move pmu helper functions into vpmu.h
  KVM: selftests: aarch64: Fix the buggy [enable|disable]_counter
  KVM: selftests: aarch64: Introduce pmu_event_filter_test
  KVM: selftests: aarch64: Add invalid filter test in
    pmu_event_filter_test

 tools/testing/selftests/kvm/Makefile          |   2 +
 .../kvm/aarch64/pmu_event_filter_test.c       | 267 ++++++++++++++++++
 .../kvm/aarch64/vpmu_counter_access.c         | 218 ++------------
 .../selftests/kvm/include/aarch64/vpmu.h      | 135 +++++++++
 .../testing/selftests/kvm/lib/aarch64/vpmu.c  |  74 +++++
 5 files changed, 502 insertions(+), 194 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vpmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vpmu.c

-- 
2.40.1


