Return-Path: <kvm+bounces-12053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 013A587F412
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 941341F22D5B
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0041E604DB;
	Mon, 18 Mar 2024 23:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BvcMvvVK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC15FBA6
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804843; cv=none; b=Ipx8sHYXFXbvUs2/tYG66i3XrI6X4DPWXguwK2y1ThUEGplogUcaMjFTHLSq+zH7NDXfNXIEBudv5sPsNkkyWb8A1BzqDNd67Von5UCIpFEmKq6utn9WwrhzwUxkPnmyizXxfOkrn/aoRFUgqFoVGbogq7g/oAL+CHPFdymgsE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804843; c=relaxed/simple;
	bh=54nyVR2dGgebG8omWQWEhwokjb41+ZuOxUUjTXEZ9U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SW9z+aLRa8+lIIwaBamS4/HJrb6Br2HV0ARIkn7C2+lFSvfH6OwvVHMEUaJ39ap8HdwrLVwDPdVs2o5g8XoSPlaWnuThuqbIZaeo2YCLtA9/Ed9LEfcv4qej9ZaCJyLMREYc9997j+hrqDPLu0n40pzBW7YXzpwa0LmQCutib80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BvcMvvVK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njlglT30so/A+1RKK68wAaixBuIYtSjbbdb5gDm3L0U=;
	b=BvcMvvVKaKoiVIxrk9peD+oLyzXkm4My/U5OVoXALFjxgFEj7DKAYjjk85T8IPhNoWCIlV
	six+UhFXxR42L4PlU5TX7WA5WRdXmFDsrMsFH9fpatDlkjknap43utzSOS1+ju9wCbZN18
	xP2elQw40c3P/exU6/kr4s+sCtDRSQ4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-dXPgK_oqMVuYSDoRB_bD7A-1; Mon,
 18 Mar 2024 19:33:55 -0400
X-MC-Unique: dXPgK_oqMVuYSDoRB_bD7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D08638000A1;
	Mon, 18 Mar 2024 23:33:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 766E61121312;
	Mon, 18 Mar 2024 23:33:54 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 04/15] KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
Date: Mon, 18 Mar 2024 19:33:41 -0400
Message-ID: <20240318233352.2728327-5-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Allow vendor modules to provide their own attributes on /dev/kvm.
To avoid proliferation of vendor ops, implement KVM_HAS_DEVICE_ATTR
and KVM_GET_DEVICE_ATTR in terms of the same function.  You're not
supposed to use KVM_GET_DEVICE_ATTR to do complicated computations,
especially on /dev/kvm.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 | 43 ++++++++++++++++++++----------
 3 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 110d7f29ca9a..5187fcf4b610 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -121,6 +121,7 @@ KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
+KVM_X86_OP_OPTIONAL(dev_get_attr)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16e07a2eee19..f6cc7bfb5462 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1778,6 +1778,7 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 #endif
 
+	int (*dev_get_attr)(u64 attr, u64 *val);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d2029402513..e8253aa8ef5e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4842,34 +4842,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
-static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
+static int __kvm_x86_dev_get_attr(struct kvm_device_attr *attr, u64 *val)
 {
-	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
+	int r;
 
 	if (attr->group)
 		return -ENXIO;
 
 	switch (attr->attr) {
 	case KVM_X86_XCOMP_GUEST_SUPP:
-		if (put_user(kvm_caps.supported_xcr0, uaddr))
-			return -EFAULT;
-		return 0;
+		r = 0;
+		*val = kvm_caps.supported_xcr0;
+		break;
 	default:
-		return -ENXIO;
+		r = -ENXIO;
+		if (kvm_x86_ops.dev_get_attr)
+			r = static_call(kvm_x86_dev_get_attr)(attr->attr, val);
+		break;
 	}
+
+	return r;
+}
+
+static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
+	int r;
+	u64 val;
+
+	r = __kvm_x86_dev_get_attr(attr, &val);
+	if (r < 0)
+		return r;
+
+	if (put_user(val, uaddr))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int kvm_x86_dev_has_attr(struct kvm_device_attr *attr)
 {
-	if (attr->group)
-		return -ENXIO;
+	u64 val;
 
-	switch (attr->attr) {
-	case KVM_X86_XCOMP_GUEST_SUPP:
-		return 0;
-	default:
-		return -ENXIO;
-	}
+	return __kvm_x86_dev_get_attr(attr, &val);
 }
 
 long kvm_arch_dev_ioctl(struct file *filp,
-- 
2.43.0



