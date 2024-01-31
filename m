Return-Path: <kvm+bounces-7620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F114844D89
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BFFCB34EEA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0817647A6F;
	Wed, 31 Jan 2024 23:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UnEsO57Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF503B796
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743864; cv=none; b=gynUEzpzusPrhbIzPGpXTOsxhNrM/x7YBk9HRlHVrVaY6LZ/GFzeqNOtcGng8YVEfp4dVKQgrkFpxqFUGq9ShcUgzjCdMabMLww7IZDfrWB/Ec5IN2pfhzASbGa4RyS2CFhpNfD+peeNHbQoF8w/qQq74zNE8+c9YWrm9FnIxP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743864; c=relaxed/simple;
	bh=Ux18IXW0DZHPKhYAMzyZDNK2COUwdRVoZU6iY0lsftQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nynLHYZJzwnSY8vOABYEtQpW7nvp/bdQ2YzZ0kYhzEEY8x7JM/DCb8eyUCxSS+K9260/zOYzy8jMKQRT8Y3deq9orOFcSIJ6tZQlQt+pUb2YsgFPPTbeVLNYPk9Sv3TB/ufBgnhO1/baz6cb5RLAof/XbdCeGgAlnVZOs2X04UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UnEsO57Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706743861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+BWRqwRbbb0ZjiffCmlWuwED5KeVg2ZZ25OkfKH+sE=;
	b=UnEsO57YKFpZO+S2y59uG+rAgwkI9gTFlcqB/NKalpyBNuscL56WwIBXhhonHmMZgEcw5E
	ufboqlFDyrZGPnqhWMgAwm/DXwQrQDNXiPr+hKKeiK0XUppFfk4CwbubcbEO3mAnerNVPI
	ZhR1pKGLFFl21QnWuKo6kzuTmF5f9F8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-sW8m4aLfOom1O4KLKvp6RA-1; Wed, 31 Jan 2024 18:30:57 -0500
X-MC-Unique: sW8m4aLfOom1O4KLKvp6RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D9D212501E1;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 466B5C2590D;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 5/8] KVM: arm64: move ARM-specific defines to uapi/asm/kvm.h
Date: Wed, 31 Jan 2024 18:30:53 -0500
Message-Id: <20240131233056.10845-6-pbonzini@redhat.com>
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

While this in principle breaks userspace code that mentions KVM_ARM_DEV_*
on architectures other than aarch64, this seems unlikely to be
a problem considering that run->s.regs.device_irq_level is only
defined on that architecture.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 include/uapi/linux/kvm.h          | 7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 6b8b57b97228..75809c8dc2f0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -162,6 +162,11 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
+/* Bits for run->s.regs.device_irq_level */
+#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
+#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
+#define KVM_ARM_DEV_PMU			(1 << 2)
+
 /*
  * PMU filter structure. Describe a range of events with a particular
  * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b7c8054e9d14..00d5cecd057d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1384,13 +1384,6 @@ struct kvm_enc_region {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
-/* Available with KVM_CAP_ARM_USER_IRQ */
-
-/* Bits for run->s.regs.device_irq_level */
-#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
-#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
-#define KVM_ARM_DEV_PMU			(1 << 2)
-
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
-- 
2.39.0



