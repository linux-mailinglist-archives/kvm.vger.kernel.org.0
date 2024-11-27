Return-Path: <kvm+bounces-32583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EA89DAE59
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5886281BF1
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F0320408C;
	Wed, 27 Nov 2024 20:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EgUKVVD+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F3E201277
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738229; cv=none; b=pBOxMnMSzNMbrBKUpuCsomqExHHI+vkjbTKMZuEHKIHOqEZIbmVjEO98beJtWRRgM/4+HnMNLmiQnnRL/iaf+t5ATJMy30YWrDHqdo88sBIx0npW4GNplf1JdSB5NfcWGEsGpVDqbUzRHGTdX1wHPeONZiT9tP5XJpNumESsSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738229; c=relaxed/simple;
	bh=r6aFeq6PS837UNC9SFHrRCf/th1nqfXjv/BwAMo2NCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nw1mIQFVlYPBFk4B8bUsCkfglouxndHvnkimTizD8+h9BIXHvyNVkqFiLvcQrBTOcuyf/0jKjUoAgDQRAIRZH7YsvoEye64+HcK3dj/Mnio50wi77t4cLKB6l3nMQl0WEal0ro78isfysb6QhEY+NC5XRXojsRBdNTB6EVqFNk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EgUKVVD+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732738226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+M825//4HSdqz1oxZiOBdhTSc7nT0ze0JjqDLRc138=;
	b=EgUKVVD+1ecgG5FLbumhBLqpcE5eJ4mQ7JdAKqaDI1Tq3PeCNI45mz2iLZqFMhOP/TizPS
	vCkaC4NJljAtPxq5QETEuQSB6Mc2xO8jFr8maRUj8gBStd/+3mBP8kvZDczOUfLVJid8Pg
	iAGPe1FGtHO2PUPqvGMjdqCxN5KQF3M=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-hLSMnDmFNByN6JM9_Fq3UA-1; Wed,
 27 Nov 2024 15:10:22 -0500
X-MC-Unique: hLSMnDmFNByN6JM9_Fq3UA-1
X-Mimecast-MFC-AGG-ID: hLSMnDmFNByN6JM9_Fq3UA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F4B619540F0;
	Wed, 27 Nov 2024 20:10:21 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0868B19560A3;
	Wed, 27 Nov 2024 20:10:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com
Subject: [PATCH 1/3] KVM: Export hardware virtualization enabling/disabling functions
Date: Wed, 27 Nov 2024 15:10:17 -0500
Message-ID: <20241127201019.136086-2-pbonzini@redhat.com>
In-Reply-To: <20241127201019.136086-1-pbonzini@redhat.com>
References: <20241127201019.136086-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Kai Huang <kai.huang@intel.com>

To support TDX, KVM will need to enable TDX during KVM module loading
time.  Enabling TDX requires enabling hardware virtualization first so
that all online CPUs (and the new CPU going online) are in post-VMXON
state.

KVM by default enables hardware virtualization but that is done in
kvm_init(), which must be the last step after all initialization is done
thus is too late for enabling TDX.

Export functions to enable/disable hardware virtualization so that TDX
code can use them to handle hardware virtualization enabling before
kvm_init().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Message-ID: <dfe17314c0d9978b7bc3b0833dff6f167fbd28f5.1731664295.git.kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  8 ++++++++
 virt/kvm/kvm_main.c      | 18 ++++--------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9db304d14c46..3fcee4209120 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2559,4 +2559,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+int kvm_enable_virtualization(void);
+void kvm_disable_virtualization(void);
+#else
+static inline int kvm_enable_virtualization(void) { return 0; }
+static inline void kvm_disable_virtualization(void) { }
+#endif
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c5e7782fbd4a..8214efa76a6f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,8 +143,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int kvm_enable_virtualization(void);
-static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -5552,7 +5550,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int kvm_enable_virtualization(void)
+int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5597,8 +5595,9 @@ static int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_enable_virtualization);
 
-static void kvm_disable_virtualization(void)
+void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5609,6 +5608,7 @@ static void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
+EXPORT_SYMBOL_GPL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5624,21 +5624,11 @@ static void kvm_uninit_virtualization(void)
 		kvm_disable_virtualization();
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int kvm_enable_virtualization(void)
-{
-	return 0;
-}
-
 static int kvm_init_virtualization(void)
 {
 	return 0;
 }
 
-static void kvm_disable_virtualization(void)
-{
-
-}
-
 static void kvm_uninit_virtualization(void)
 {
 
-- 
2.43.5



