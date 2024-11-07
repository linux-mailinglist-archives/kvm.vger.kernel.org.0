Return-Path: <kvm+bounces-31078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 964FD9C014E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E9F51F22674
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8791E25FC;
	Thu,  7 Nov 2024 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UP/8Y1x4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AB41D79BB
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972428; cv=none; b=e5MextLN1IyLzXYcuZ2LKhpqupMh6LllhyBqydV8vNwijmzbke1fZo8XnKH2O1sXvkvX1t5rgVKIs590YwJV5yuHNk1CcCq32s9DbgIQQNuyUij8DnJIKRgujt1tE+zz3kcbikioOu8a1GZC+/7V56WUEjS7uRykmK0B0ZZZYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972428; c=relaxed/simple;
	bh=cBg1qqMZy09oDzfSRdllAKvEmmg2QeJtF/7tXt+wK1Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Phn2BwxV5LjJLiLxjlD4huH9uqIWbPjOv8SGG22d6Zi8ha+piD7ViIiXunX9DpdCvVUrfFxVup7nWmmbMv/AM1/G2NKhjus9HNmdI04rP/wUXAFTpgKU1BghbOuy8BJLjmuSf4HQTDkkJUF+F9n1ZtO3JOHYBMb8rfnMY7X8r4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UP/8Y1x4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730972425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KtsnR0uVveSGf9j1BUUQ1tqA3+oQh/kCsttRmTjgonY=;
	b=UP/8Y1x4Zzex1ICNhtHKRDXvKf+PwFrOBEtMR4kv/vGnsjBUe0+C9j/77k8Xmp6BB/vz+B
	Crm+cWaD43ICIfjG+zDEc+Nh3EJcXT52E3SXSi6TAoaT+jNnhYP0udvR0kJTeeBhiO3bWR
	dtg24vrwQ7btuZ+lmcXhOSt5XsqbSkM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-Sbhb7S26Md2r_BCz682lZg-1; Thu,
 07 Nov 2024 04:40:21 -0500
X-MC-Unique: Sbhb7S26Md2r_BCz682lZg-1
X-Mimecast-MFC-AGG-ID: Sbhb7S26Md2r_BCz682lZg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D69C51979043;
	Thu,  7 Nov 2024 09:40:10 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 050EA1956054;
	Thu,  7 Nov 2024 09:40:05 +0000 (UTC)
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
Subject: [PATCH 0/3] KVM: arm64: Handle KVM_REQ_VM_DEAD in vgic_init test
Date: Thu,  7 Nov 2024 10:38:47 +0100
Message-ID: <20241107094000.70705-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Mark reported that df5fd75ee305 ("KVM: arm64: Don't eagerly
teardown the vgic on init error") causes vgic_init test
assertion failure. This is due to the fact that now an
incomplete vgic setup causes a KVM_REQ_VM_DEAD request to
be sent. vgic_init test checks such kind of incomplete setups.
As a consequence some KVM IOCTL's fail on the clean up path
(kvm_vm_free) and cause assertion failures in the test.

This series fixes that by checking the VM state and avoid to
call KVM IOCTL's after the occcurence of such failure.

Best regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/vgic_init_dead_v1

Eric Auger (3):
  KVM: selftests: Introduce vm_dead()
  KVM: selftests: Introduce kvm_vm_dead_free
  KVM: selftests: Handle dead VM in vgic_init test

 .../testing/selftests/kvm/aarch64/vgic_init.c | 41 +++++++++++--------
 .../testing/selftests/kvm/include/kvm_util.h  | 28 +++++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 25 ++++++++---
 3 files changed, 62 insertions(+), 32 deletions(-)

-- 
2.41.0


