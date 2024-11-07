Return-Path: <kvm+bounces-31079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3227F9C014F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB71D283B19
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04CF71E285F;
	Thu,  7 Nov 2024 09:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tc01Ylnl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A46E1E1338
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972429; cv=none; b=Y1/VSHKZfGucUuz1ghp+XMHh59i17s8tB2bbPHFYQNVsvOYw/z4PFnSPiW0bxcOYjHYudg8nZxQCKXgCU2Q35mGMVV1RqDzTO3tQYq5nFOJuOG5iT3Xbs0zgQoexmtqnBC/BltxmzvOd0VmQsgAHl7lzl98sy1LyKHAVRuofRDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972429; c=relaxed/simple;
	bh=1Eay4UPV/KZ3jq8lAfXy0krU3Az0xu+VTrt0d1rWo1A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqPB91NRkJIOsOZ/dmv/P0xyrSGVV47YBAsSmuEdq8GekMarPsL4s6K5uWFhVK1RMJo4/r+VO3i9j7gZus+jFP3TvJg5e3gURa6wgS5SRoLp8H5kI5qXZreaXr5ZkPezcNpfx+S+1/mGzGBqMH2VtJwjj0kDnpFztZofaR1u8X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tc01Ylnl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730972426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rr3Xjz6SCyD3QOAu7F+cqtkNRB5n403qu15+Enk2bM8=;
	b=Tc01YlnliZbdQ2w5qUSsERHnEiFIN/dL/ZrwRryaQcQVd7rKR+xLkv/7s0z5mwwLJMhwyp
	tLpiXKWARdD0j6Ncdzz5qpNDn2EDIQ3IF69y5NRrlyiQtxA1fSQ7SRW+ZIqXkSRM/MlumD
	lqTeqWaqcFSxcFWFQV/igaBEUAMWoBU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-xu143bFpNKSQHhUOwdW4Iw-1; Thu,
 07 Nov 2024 04:40:22 -0500
X-MC-Unique: xu143bFpNKSQHhUOwdW4Iw-1
X-Mimecast-MFC-AGG-ID: xu143bFpNKSQHhUOwdW4Iw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03C731955EA1;
	Thu,  7 Nov 2024 09:40:15 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B8481955F40;
	Thu,  7 Nov 2024 09:40:11 +0000 (UTC)
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
Subject: [PATCH  1/3] KVM: selftests: Introduce vm_dead()
Date: Thu,  7 Nov 2024 10:38:48 +0100
Message-ID: <20241107094000.70705-2-eric.auger@redhat.com>
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

Introduce a new helper that detects whether the VM
was turned dead by a KVM_REQ_VM_DEAD request.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bc7c242480d6..90424bfe33bd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -299,13 +299,26 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 })
 
 /*
- * Assert that a VM or vCPU ioctl() succeeded, with extra magic to detect if
- * the ioctl() failed because KVM killed/bugged the VM.  To detect a dead VM,
- * probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM since before
- * selftests existed and (b) should never outright fail, i.e. is supposed to
- * return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all ioctl()s for the
+ * To detect a dead VM, probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM
+ * since before selftests existed and (b) should never outright fail, i.e. is supposed
+ * to return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all ioctl()s for the
  * VM and its vCPUs, including KVM_CHECK_EXTENSION.
  */
+static inline bool vm_dead(struct kvm_vm *vm)
+{
+	int ret = __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY);
+
+	if (ret < 1) {
+		TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Assert that a VM or vCPU ioctl() succeeded, also handling the case when
+ * the ioctl() failed because KVM killed/bugged the VM.
+ */
 #define __TEST_ASSERT_VM_VCPU_IOCTL(cond, name, ret, vm)				\
 do {											\
 	int __errno = errno;								\
@@ -315,9 +328,7 @@ do {											\
 	if (cond)									\
 		break;									\
 											\
-	if (errno == EIO &&								\
-	    __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY) < 0) {	\
-		TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");	\
+	if (vm_dead(vm)) {								\
 		TEST_FAIL("KVM killed/bugged the VM, check the kernel log for clues");	\
 	}										\
 	errno = __errno;								\
-- 
2.41.0


