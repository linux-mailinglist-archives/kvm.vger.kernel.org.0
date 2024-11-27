Return-Path: <kvm+bounces-32585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7799E9DAE5B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFA2C1611C5
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85456201277;
	Wed, 27 Nov 2024 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cmthb+Si"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE6A202F71
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738229; cv=none; b=N9GI+m9f/eHXi6mv8jZwb2ieox/6SJtpHAlpCTvVyTM7q32muzizU+hPEcsiBN/az6l3mZ4LQF3dVaB2CKJ3TDDrAsDc72OJhvUUoLDTEnZL3F85ttZ5D8Z71aF47luKY9bzAY7LchE4kLJwrsQDY76/ltTiGs7q0LOJWsdpecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738229; c=relaxed/simple;
	bh=52pdzx8rTe5dCMj07CjQEs6GrtRLXgVxwx4XbmkuAng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJPPBi5IV6lqiV2yEFJ4n1Wgl36J24A0ctAnnQYg4qyMJ10x/ScW7kf0j2shYIXsliqko6WiJEVpOKw4b4EVhkl7Pa0cZWk4ygMWyxtZoxauAl8Dv6rGCPGJrniwlrv7CzoFidMxv76Wj9lozJqHRsj5F2euXsmD3vubFeV4P/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cmthb+Si; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732738227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Osu+JlXIFqkDN7a1RzYyy5wX2zZ0R8KOgTVlLLKwRTM=;
	b=Cmthb+SiyzlGuLOvY+Y6Aq7QH7AQtgiSqOdqKQKeSYOetwW25rAzdjStGr2iRfNYvMedb8
	6ovjVZDZDE0hjB+TZAHX+w0GIFWwG92v8l9AtFCev08fUb3Wzfp/JHrVykseGH4Oy/JNTG
	V4MlBSgcpCk2LdbLH2tlWI229JrnHB8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-_USOMyVePUWlQgj6h0nTeQ-1; Wed,
 27 Nov 2024 15:10:23 -0500
X-MC-Unique: _USOMyVePUWlQgj6h0nTeQ-1
X-Mimecast-MFC-AGG-ID: _USOMyVePUWlQgj6h0nTeQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E57F195419D;
	Wed, 27 Nov 2024 20:10:22 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFD2F1955F43;
	Wed, 27 Nov 2024 20:10:21 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com
Subject: [PATCH 2/3] KVM: VMX: Refactor VMX module init/exit functions
Date: Wed, 27 Nov 2024 15:10:18 -0500
Message-ID: <20241127201019.136086-3-pbonzini@redhat.com>
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
index 92d35cc6cd15..6772e560ac7b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -167,3 +167,35 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static void vt_exit(void)
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
index 893366e53732..6793a8cc5c60 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8590,23 +8590,16 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
 	vmx_cleanup_l1d_flush();
-}
 
-static void vmx_exit(void)
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
 
@@ -8650,21 +8643,9 @@ static int __init vmx_init(void)
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
index 43f573f6ca46..1813caac1cea 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -756,4 +756,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
+int vmx_init(void);
+void vmx_exit(void);
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.43.5



