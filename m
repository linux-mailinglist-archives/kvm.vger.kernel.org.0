Return-Path: <kvm+bounces-9520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 563F1860FBD
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D60391F23659
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DA17E780;
	Fri, 23 Feb 2024 10:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GxFC1CYp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC25664D7
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684866; cv=none; b=pOSn/AtjJl9C7zWZrin598FTtuGz/Ruin23cAyb7YTIuBngdHeaI1Mr5mXXp+YCgtNysv6269bMg4x2mtYD1Rssp59sotRva48DRMexIUguUW7CPl1mjqZyy+jZ4YsMNcLpGk7na1Lmi0Q13iGvi7iZuaDooxNSet368vrIQ8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684866; c=relaxed/simple;
	bh=G5tKkyjprqLewL3O1LDTvZquCuMpAlrU/ub17lN3RL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BWvIExB/2eO4u1hJSt4xkmDPi159eF2aSLFGp3ZU0C2Ig6FK8RHlR9AezaEbYIsybx/s9/nYAd34H102YawiRsuioowfGHr1NEnYtxMDtEAnHcl8IXqf+2croLmUjxU154sFvN963ResLoHkm98xOg0ajFKQlAMH3AikLhvJhZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GxFC1CYp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708684863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LiCqbXFLA/UyGnlYUq9cP+Y4tIkdjEj7HNX9/TX+2pE=;
	b=GxFC1CYpyvXbSpcz2LksCXlH9ieG6yLz/8cPp5476qIRsp0FpBCHt/GgyuESt6uSW1Ah0T
	vs2lemsYHGrr+kNNVfMJ4seM8XDEkr5ucvfM3BTLr7YT02Lkn7I223OiKkiMOqAABH8aE6
	ag9eWPLDfZ3r3/T2c5tHlFzG8G1kClU=
Received: from mimecast-mx02.redhat.com (66.187.233.88 [66.187.233.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-2Tu4Y4_uNRWlVLT0SWqalQ-1; Fri,
 23 Feb 2024 05:40:11 -0500
X-MC-Unique: 2Tu4Y4_uNRWlVLT0SWqalQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA4F6185A784;
	Fri, 23 Feb 2024 10:40:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3C27112132A;
	Fri, 23 Feb 2024 10:40:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v2 02/11] KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
Date: Fri, 23 Feb 2024 05:40:00 -0500
Message-Id: <20240223104009.632194-3-pbonzini@redhat.com>
In-Reply-To: <20240223104009.632194-1-pbonzini@redhat.com>
References: <20240223104009.632194-1-pbonzini@redhat.com>
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20240209183743.22030-3-pbonzini@redhat.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 | 52 +++++++++++++++++++-----------
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 378ed944b849..ac8b7614e79d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -122,6 +122,7 @@ KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
+KVM_X86_OP_OPTIONAL(dev_get_attr)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d271ba20a0b2..0bcd9ae16097 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1769,6 +1769,7 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 #endif
 
+	int (*dev_get_attr)(u64 attr, u64 *val);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf10a9073a09..8746530930d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4804,37 +4804,53 @@ static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
 	return uaddr;
 }
 
-static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
+static int __kvm_x86_dev_get_attr(struct kvm_device_attr *attr, u64 *val)
 {
-	u64 __user *uaddr = kvm_get_attr_addr(attr);
+	int r;
 
 	if (attr->group)
 		return -ENXIO;
 
+	switch (attr->attr) {
+	case KVM_X86_XCOMP_GUEST_SUPP:
+		r = 0;
+		*val = kvm_caps.supported_xcr0;
+		break;
+	default:
+		r = -ENXIO;
+		if (kvm_x86_ops.dev_get_attr)
+			r = kvm_x86_ops.dev_get_attr(attr->attr, val);
+		break;
+	}
+
+	return r;
+}
+
+static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr;
+	int r;
+	u64 val;
+
+	r = __kvm_x86_dev_get_attr(attr, &val);
+	if (r < 0)
+		return r;
+
+	uaddr = kvm_get_attr_addr(attr);
 	if (IS_ERR(uaddr))
 		return PTR_ERR(uaddr);
 
-	switch (attr->attr) {
-	case KVM_X86_XCOMP_GUEST_SUPP:
-		if (put_user(kvm_caps.supported_xcr0, uaddr))
-			return -EFAULT;
-		return 0;
-	default:
-		return -ENXIO;
-	}
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
2.39.1



