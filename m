Return-Path: <kvm+bounces-13543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 536EE8986E1
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC8491F285E0
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661C886652;
	Thu,  4 Apr 2024 12:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUZeXPiV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C549185269
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232813; cv=none; b=kXfIKxBcoPyu2AHzAWgGCSCwPBMcVtkbkZoRR0gJ1MTIndtm0jcsnHDXwHWjau7QefoULXkgXAcOuPyp2f8xyQpg/KaKJxKS/pJd2m2QIT3upwxm8JSRb/NaC5GVhwmH3AeCswpEy5p8H42ith/pFROXCN7RDxaAfK7UEqCWYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232813; c=relaxed/simple;
	bh=zhGcce4/ERz6ZXZHyJI7dUofGVN8rtK2nHPx1CP1J2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E0bmegUiPmRYSPoKx/k2jGtEMfCs7rQzuxh+qZPTfHnAMetqY/YnFTDEteQhCE3E+B/jCNIK5qFs6VWBfddNcygwtQgpuLxbSUkEbkGXfQT3d4L//yxpQa4eoErZv0iPaT2L5lQPBgyttEidzfSz9iYHBJAuFfK1qU/gpC8Brwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YUZeXPiV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U36BaEhTpQCAkefSGfJEuvOHh5sEGIGPkqO1KfO5PBo=;
	b=YUZeXPiV7U2qVStrvK9ErSzD/5r7d/9zvwNT6OXiFMAUNVyCOtwSza9vQfpM8mQz4OtNFl
	Eu5YdNtzXUK/cAQbgAj5IzKKXfhO33xYjVY/Ok2954nYWSGkPxf+5x4iEwgOBwtGm3gC5i
	xNQ+M1HPfH8WXDCAKUKK6qW1vp11DII=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-efrHkHtPP8WzNQAu_AzMZw-1; Thu, 04 Apr 2024 08:13:29 -0400
X-MC-Unique: efrHkHtPP8WzNQAu_AzMZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31317185A782;
	Thu,  4 Apr 2024 12:13:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0FA52200BA91;
	Thu,  4 Apr 2024 12:13:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH v5 04/17] KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
Date: Thu,  4 Apr 2024 08:13:14 -0400
Message-ID: <20240404121327.3107131-5-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

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
 arch/x86/kvm/x86.c                 | 38 +++++++++++++++++++-----------
 3 files changed, 26 insertions(+), 14 deletions(-)

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
index 16e07a2eee19..04c430eb25cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1778,6 +1778,7 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 #endif
 
+	int (*dev_get_attr)(u32 group, u64 attr, u64 *val);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d2029402513..3934e7682734 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4842,34 +4842,44 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
-static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
+static int __kvm_x86_dev_get_attr(struct kvm_device_attr *attr, u64 *val)
 {
-	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
-
-	if (attr->group)
+	if (attr->group) {
+		if (kvm_x86_ops.dev_get_attr)
+			return static_call(kvm_x86_dev_get_attr)(attr->group, attr->attr, val);
 		return -ENXIO;
+	}
 
 	switch (attr->attr) {
 	case KVM_X86_XCOMP_GUEST_SUPP:
-		if (put_user(kvm_caps.supported_xcr0, uaddr))
-			return -EFAULT;
+		*val = kvm_caps.supported_xcr0;
 		return 0;
 	default:
 		return -ENXIO;
 	}
 }
 
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
+}
+
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



