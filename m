Return-Path: <kvm+bounces-39329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC14FA4695B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52DD9188DE80
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FCEF241688;
	Wed, 26 Feb 2025 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmYEEHJc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECE723C376
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593724; cv=none; b=Wfu2qO3RiDlTfylhmDqNqTgNm3twJqk+1OVofcs4Uc1Ktoe/ywbyxAENOk4ay5tsQRxXA1pa9nNvLi3ITdkl6dDtodwpnTKdZN3x9aaghRSIr6/QaL6LKfkvS43DpOxhzTj1jkwgPJj2oznGQjQLNMX6r8Qli8cvqbE57jgFcmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593724; c=relaxed/simple;
	bh=SyPxWeEML4U5XWJICBihWkXtG7olGUFXCAgtxYR2ijA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hN0EjhVGolRV9xMewcgTwMEwFMIXNJ+At5g3zroKGXU6rtTLHe6625f61B9pSyV4zGbrQ+qcAjFG9DHhz0SKxIgsOhhUoSSnaawbIHPDKCgvqP4+vgAJHRJ66QIqaixvbx8kEdXNbFMXOAzJntVdycm6avjahHJtjkf/S6LOzEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NmYEEHJc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o/JXXTfPTbLenJPukcC20+gbJ6Iqawd5bCqy88M9NtI=;
	b=NmYEEHJcPSB8vjfzQLidqIESKPvkkY+jW8YcnN//xCDIrjSRQ/sXt2dPBSbILgaIuds/wK
	lZTuWBBCBHMKSY7nC64mu4krew4sqW+SzAhM3W2JK38OiyrS/qtAXcPxi3oH5Mjv1FEqcC
	UzMb8vylXEorqesJtc6RP7pZHr+8zgs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-XHLeBMqnMcG2Fua_AvjDoA-1; Wed,
 26 Feb 2025 13:15:18 -0500
X-MC-Unique: XHLeBMqnMcG2Fua_AvjDoA-1
X-Mimecast-MFC-AGG-ID: XHLeBMqnMcG2Fua_AvjDoA_1740593717
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E48E4190F9E7;
	Wed, 26 Feb 2025 18:15:16 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE9FF1955BD4;
	Wed, 26 Feb 2025 18:15:15 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 14/33] KVM: VMX: Refactor VMX module init/exit functions
Date: Wed, 26 Feb 2025 13:14:33 -0500
Message-ID: <20250226181453.2311849-15-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Kai Huang <kai.huang@intel.com>

Add vt_init() and vt_exit() as the new module init/exit functions and
refactor existing vmx_init()/vmx_exit() as helper to make room for TDX
specific initialization and teardown.

To support TDX, KVM will need to enable TDX during KVM module loading
time.  Enabling TDX requires enabling hardware virtualization first so
that all online CPUs (and the new CPU going online) are in post-VMXON
state.

Currently, the vmx_init() flow is:

 1) hv_init_evmcs(),
 2) kvm_x86_vendor_init(),
 3) Other VMX specific initialization,
 4) kvm_init()

The kvm_x86_vendor_init() invokes kvm_x86_init_ops::hardware_setup() to
do VMX specific hardware setup and calls kvm_update_ops() to initialize
kvm_x86_ops to VMX's version.

TDX will have its own version for most of kvm_x86_ops callbacks.  It
would be nice if kvm_x86_init_ops::hardware_setup() could also be used
for TDX, but in practice it cannot.  The reason is, as mentioned above,
TDX initialization requires hardware virtualization having been enabled,
which must happen after kvm_update_ops(), but hardware_setup() is done
before that.

Also, TDX is based on VMX, and it makes sense to only initialize TDX
after VMX has been initialized.  If VMX fails to initialize, TDX is
likely broken anyway.

So the new flow of KVM module init function will be:

 1) Current VMX initialization code in vmx_init() before kvm_init(),
 2) TDX initialization,
 3) kvm_init()

Split vmx_init() into two parts based on above 1) and 3) so that TDX
initialization can fit in between.  Make part 1) as the new helper
vmx_init().  Introduce vt_init() as the new module init function which
calls vmx_init() and kvm_init().  TDX initialization will be added
later.

Do the same thing for vmx_exit()/vt_exit().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Message-ID: <3f23f24098bdcf42e213798893ffff7cdc7103be.1731664295.git.kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c  | 23 ++---------------------
 arch/x86/kvm/vmx/vmx.h  |  3 +++
 3 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 43ee9ed11291..54cf95cb8d42 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -168,3 +168,35 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static void __exit vt_exit(void)
+{
+	kvm_exit();
+	vmx_exit();
+}
+module_exit(vt_exit);
+
+static int __init vt_init(void)
+{
+	int r;
+
+	r = vmx_init();
+	if (r)
+		return r;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
+		     THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	vmx_exit();
+	return r;
+}
+module_init(vt_init);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6c56d5235f0f..5a80000d0fdd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8598,23 +8598,16 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
 	vmx_cleanup_l1d_flush();
-}
 
-static void __exit vmx_exit(void)
-{
-	kvm_exit();
-	__vmx_exit();
 	kvm_x86_vendor_exit();
-
 }
-module_exit(vmx_exit);
 
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
@@ -8658,21 +8651,9 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
-	/*
-	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
-	 * exposed to userspace!
-	 */
-	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
-		     THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	return 0;
 
-err_kvm_init:
-	__vmx_exit();
 err_l1d_flush:
 	kvm_x86_vendor_exit();
 	return r;
 }
-module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8b111ce1087c..299fa1edf534 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -760,4 +760,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
+int vmx_init(void);
+void vmx_exit(void);
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.43.5



