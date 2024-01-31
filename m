Return-Path: <kvm+bounces-7623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A29B844D14
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F63C1C24F9A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63F7481A7;
	Wed, 31 Jan 2024 23:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRbSw60z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B95D40BEE
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743865; cv=none; b=n+hrWornIreLGq+GRRXKfZoNj1HS8PNzJs4I/YPIFdvL9QhCN9WlXK4xKJpV2MaFTrZNibmtvjD7VO2oCzKi3zgXaEBh7cv+ZSJu4793blHlCNFFaJKz5u5BdikLr6e/K6GGMzqiyC7Z6sT6hbBSdZlYUlCecuvV7gzq19zxHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743865; c=relaxed/simple;
	bh=egLDFiRNJB+gLZ9vOhV8oqUV2GakvOlt+YHEeaEXTHo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QliHR7WfpXxZut/ORNaevoEFWziHtsisy8M3y6uFL5kES8uMS3c81AlotcaDMYLVbKITWkXMD+X7oQYY9ctjfNEFv6vc8XogasPKH5G1HA6KC+zLMowN1y0j+ZtXnBvpBlokd6yPkxG0S6UihVELPEQhZT1x4ZmfgVb+jVbqNuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TRbSw60z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706743861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iYdr1te2ILd/6IkmSv7D89eUotSlyqhI35b5jGhDKoM=;
	b=TRbSw60zZTNI5Hmb+IiPYNuy7zj0lIOnySq7wZ8KNVOEvzEIIzc1qE8eSYWJLiyhnyslq3
	g4wTTd09fOrnlSzW3CI/tOKEd2LmKXEVCJKpdmaEaQHDWkPWqUQyCTj6ipKfFWInidZc4U
	XFHx3s3QMTQkA8kTGP1nGmA9M/6/Vmc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-YRnxORxcPxeonId5K0r4iQ-1; Wed, 31 Jan 2024 18:30:57 -0500
X-MC-Unique: YRnxORxcPxeonId5K0r4iQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CF97867944;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 85273C2590D;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 7/8] KVM: define __KVM_HAVE_GUEST_DEBUG unconditionally
Date: Wed, 31 Jan 2024 18:30:55 -0500
Message-Id: <20240131233056.10845-8-pbonzini@redhat.com>
In-Reply-To: <20240131233056.10845-1-pbonzini@redhat.com>
References: <20240131233056.10845-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Since all architectures (for historical reasons) have to define
struct kvm_guest_debug_arch, and since userspace has to check
KVM_CHECK_EXTENSION(KVM_CAP_SET_GUEST_DEBUG) anyway, there is
no advantage in masking the capability #define itself.  Remove
the #define __KVM_HAVE_GUEST_DEBUG from architecture-specific
headers.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/include/uapi/asm/kvm.h   | 1 -
 arch/powerpc/include/uapi/asm/kvm.h | 1 -
 arch/s390/include/uapi/asm/kvm.h    | 1 -
 arch/x86/include/uapi/asm/kvm.h     | 1 -
 include/uapi/linux/kvm.h            | 3 +--
 5 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9c1040dad4eb..964df31da975 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -37,7 +37,6 @@
 #include <asm/ptrace.h>
 #include <asm/sve_context.h>
 
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_VCPU_EVENTS
 
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index a96ef6b36bba..1691297a766a 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -28,7 +28,6 @@
 #define __KVM_HAVE_PPC_SMT
 #define __KVM_HAVE_IRQCHIP
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_GUEST_DEBUG
 
 /* Not always available, but if it is, this is the correct offset.  */
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index fee712ff1cf8..05eaf6db3ad4 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 
 #define __KVM_S390
-#define __KVM_HAVE_GUEST_DEBUG
 
 struct kvm_s390_skeys {
 	__u64 start_gfn;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index c5e682ee7726..0ad6bda1fc39 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -42,7 +42,6 @@
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_MSIX
 #define __KVM_HAVE_MCE
 #define __KVM_HAVE_PIT_STATE2
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 00d5cecd057d..fd5aa4bf77f7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -16,6 +16,11 @@
 
 #define KVM_API_VERSION 12
 
+/*
+ * Backwards-compatible definitions.
+ */
+#define __KVM_HAVE_GUEST_DEBUG
+
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -689,9 +690,7 @@ struct kvm_enable_cap {
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 #define KVM_CAP_USER_NMI 22
-#ifdef __KVM_HAVE_GUEST_DEBUG
 #define KVM_CAP_SET_GUEST_DEBUG 23
-#endif
 #ifdef __KVM_HAVE_PIT
 #define KVM_CAP_REINJECT_CONTROL 24
 #endif
-- 
2.39.0



