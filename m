Return-Path: <kvm+bounces-57932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19324B81EE3
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D46C9466313
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C4C2C2361;
	Wed, 17 Sep 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VIWuz8QQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF063064A3
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144066; cv=none; b=lstHahoC13FJPpjjNRIHrhj2HeMcVb4H64rL/W8Ere9AkYy1MRY6Jos+/WszJe0PY0D99JKo7OKg2E4B2EZA+1XikSmrQX1VWVWGS+ECger6PTBstzPdDe7OvPWDPDJdpqtVzC+0xATBDhzy/Vs/YK/8gfN3MEN5OzRwFJs0ZoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144066; c=relaxed/simple;
	bh=pDJTEZNtj/3/Tm0cx5jrpbMWdY1HeE+d0X/4ISDIip0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/xs9PALnxmhlw/LJwTFnkbWBHlgDhV4DnYmGeLDEWINbMBKgSZbSZk2nOou2uWpfwdLiTojvK6a78cALTRLkf8ozZho7jvhG6zq+EWgeplSIwCKDjNGS8jcfvin42bH7PycUyx8P6pI3Leb+Ri35P6QJ8Cv5UILTUBhIFJmECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VIWuz8QQ; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftC1ZPs9gDqxN4y/O9xvdU+WH6wwoAhFgL77FVyHOpg=;
	b=VIWuz8QQTv22cCwoc5mVGqkVBlipdOMm3pbl4ojOI3tkLXNurF06zAoV1sBsrtqrPBS8Nr
	vjHZXNA3zXzz3g8qKtiA89i9ozPfF0S3BDA714oaGcYdZXH7mEd1URakFzv8xE0atBxqek
	TJiraxzSorqf0bODkXo4IHQu5zh2qzc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 02/13] KVM: arm64: selftests: Initialize VGICv3 only once
Date: Wed, 17 Sep 2025 14:20:32 -0700
Message-ID: <20250917212044.294760-3-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vgic_v3_setup() unnecessarily initializes the vgic twice. Keep the
initialization after configuring MMIO frames and get rid of the other.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/lib/arm64/vgic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/arm64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
index 4427f43f73ea..64e793795563 100644
--- a/tools/testing/selftests/kvm/lib/arm64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/vgic.c
@@ -56,9 +56,6 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 
 	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, &nr_irqs);
 
-	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
-
 	attr = GICD_BASE_GPA;
 	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_DIST, &attr);
-- 
2.47.3


