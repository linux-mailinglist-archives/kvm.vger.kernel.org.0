Return-Path: <kvm+bounces-71069-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GA77KQJWj2lqQQEAu9opvQ
	(envelope-from <kvm+bounces-71069-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:49:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF1C13860E
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9209930DCE26
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DA9365A16;
	Fri, 13 Feb 2026 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijnhmrBt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpSSQUDK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2F4365A06
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771001209; cv=none; b=PDy4Jw5Jaas4YwG13Cazdn52QTg/nMOXwOvag4ByGNJKCl9kIVfpLC6KclUZguar9J6dn3f88FWch7pEI0fSGa0UoVySFayf2SoSoAiyisIm39KjMthL1fIKc9UXf0VujrB9U2r9ZycOSTfg6TQzq4ynv+T7gagqA16y1cdWi0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771001209; c=relaxed/simple;
	bh=0VJorrCNLDmll5biT00ss8hT7qU/JEiNG1R8WhBGgbE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6pxQcTsbR+1iapsiVqJ6m4tVYuRJ5DiL2Lz++x3T7PyroaZgBG4wD22pSrmrCsWUSaBt6xqH+HmGZuehes2mE5EylWvYxo8Lhzkx1iHC/kfnBQ6xyue0WT3P36qh/9s8tS1jC6GKHsSQdpFeDySYhXpUImUE32BLtHAx359wcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijnhmrBt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpSSQUDK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771001205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dv/cLXh264i91XUSFDhJ5W6sVIgqSnLYvLU3b6QBq40=;
	b=ijnhmrBtnsPDXZS9Ml28fMlQvChnPsdGoRHo7fjpNsRLc0sKglKBaqptkLaft3F9lCVot7
	SD7zHFHgu9I0Ovn26QBt1jrZeZbFW8aYb/sJ7ikCDTXSFmWy8zG0tQpBuAvjizOujC5YQF
	lymcsx1JDiwnVaLnNlTH9v2ISPmGyFI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-MDzp72_qNuiobeIemWAD0g-1; Fri, 13 Feb 2026 11:46:43 -0500
X-MC-Unique: MDzp72_qNuiobeIemWAD0g-1
X-Mimecast-MFC-AGG-ID: MDzp72_qNuiobeIemWAD0g_1771001202
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-482d8e6e13aso8059645e9.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 08:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771001201; x=1771606001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dv/cLXh264i91XUSFDhJ5W6sVIgqSnLYvLU3b6QBq40=;
        b=CpSSQUDKr43wHo31iCrBDz1hoxj0Qm94Nv5LPnAWGzfy80GPG6LYnTGsa+KbMP11Ob
         ELFWQb0Y2UujikDz2x4yFevdMHslglmw/pMwX/h6Z3ULpB4HVd6RveaLXKBHjVm4yn0e
         HQ0tMXCSWRgPCR36o7epUsuQ4xIomnW0lYE5etTVVG4S5/TyzdHQfmAI/6jHPYI2VzTA
         b2UCLjxwVKG0zBtWDIbPKT0Z4qRmjbV7bMxwbopFEqNpw/fJWtza0qIk2zrN9GkBg8SU
         8QK8zZqH+mETCV7F9xpqtjTVHPV4jo9w4VGiCrdVhzZfsNbwgl/O+VHLa4PCzcVrPVRU
         Kd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771001201; x=1771606001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dv/cLXh264i91XUSFDhJ5W6sVIgqSnLYvLU3b6QBq40=;
        b=SvFqwY2hVDwNY7wMdw1ZJrCICJLVYfQ2yHyjLGWB8fY2zN6ZgnIDJHYsRdaZvhaYDT
         VOHvJM/ENLYcWJiEyH1HP9WrIVVm6u7u4Ey3Yl7REezlD5C7r1l+ffKujPGl3UXoa9vh
         CFbrewqVU86/3UwDk82zftEZPVmRv4c7KPdbMJFpcvIL3JsSkmdITJ18Qqak3a696d/w
         m2jqHEB+KVKvJ5FYEApejG/vTbeLqofmMBE1OzKHYZJRhHArZNqBT2zBk+IwQ7XzbT0y
         +W0wFicqa5r8u4t3gEUyI/Z1yrEZuUAPEgidapPjqlhb9BcjU+kH+baqTm3jNHiXgtTW
         EfFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/vFbuiuqandprtxqpy/Zma9Vx73b7ov5t32HUmP4MJyU9a3L+JtHtwUPKZWDINN3WL78=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw+ncfSgQxT6FojqRdPlnJegpE3Ycz2053AZBoCALun/n0SdHe
	2wapTMmgmWzhR1tpXv+7+DUj8ymm6dqv1Bw7fp1ONvui7g+ByfqyRLE56vsc5Dyll7pvkT8UZwV
	2TgrGa5ejQwkLihjSjw1xj1akI7JbYIzcVR46IKeJ0QZlglDm5SgWFhlfnNB7BQ==
X-Gm-Gg: AZuq6aJq/5uOsv4DxZQGyfH6vmMOnWZT5DYNJAhR0DgFdRLYsZPbrGbnreP9L5scK9X
	A7Mp0a77ZrI9yS1HlmhpO7dEJ4C66VGv6dceOmLInMb+oAL8BU/0ScI9R2RMN/D8IV94WXlRf0O
	ZR13eUrEajdcDdbSTpbkaaK9AakB1GOn5DcD6FT0RMZSz+Rs/Zw7KZu//KJnLeUUtCgiKg1GQAy
	etTe73/zB3SPufubzRZ5wyZxNIucgy0G3MVsYEoUYx1b86pNuog8aON/S2uFZaQdoMnexaV8Xc0
	H6CKTilMZc+mQNXr01dTaBxPfbtNAqjbegmwh1U8EnIvU5NrFMICYkNI+7/fFkTG26bEXLTOuuu
	r3tQ5ZjjLwcLwDhwuSGgAIixDrIJt/H4KLmRznmJZ2o03bhwKe8fDffDQFFdadP1Ey8+Md9Fosh
	vt5GZpiCzapEEJSFThySeiwcONdA==
X-Received: by 2002:a05:600c:8b6c:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-483739fc46amr42488445e9.8.1771001201345;
        Fri, 13 Feb 2026 08:46:41 -0800 (PST)
X-Received: by 2002:a05:600c:8b6c:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-483739fc46amr42487965e9.8.1771001200806;
        Fri, 13 Feb 2026 08:46:40 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a4e149sm32898685e9.2.2026.02.13.08.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 08:46:39 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: always define KVM_CAP_SYNC_MMU
Date: Fri, 13 Feb 2026 17:46:35 +0100
Message-ID: <20260213164635.33630-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260213164635.33630-1-pbonzini@redhat.com>
References: <20260213164635.33630-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71069-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4AF1C13860E
X-Rspamd-Action: no action

KVM_CAP_SYNC_MMU is provided by KVM's MMU notifiers, which are now always
available.  Move the definition from individual architectures to common
code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 10 ++++------
 arch/arm64/kvm/arm.c           |  1 -
 arch/loongarch/kvm/vm.c        |  1 -
 arch/mips/kvm/mips.c           |  1 -
 arch/powerpc/kvm/powerpc.c     |  5 -----
 arch/riscv/kvm/vm.c            |  1 -
 arch/s390/kvm/kvm-s390.c       |  1 -
 arch/x86/kvm/x86.c             |  1 -
 virt/kvm/kvm_main.c            |  1 +
 9 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fc5736839edd..6f85e1b321dd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1396,7 +1396,10 @@ or its flags may be modified, but it may not be resized.
 Memory for the region is taken starting at the address denoted by the
 field userspace_addr, which must point at user addressable memory for
 the entire memory slot size.  Any object may back this memory, including
-anonymous memory, ordinary files, and hugetlbfs.
+anonymous memory, ordinary files, and hugetlbfs.  Changes in the backing
+of the memory region are automatically reflected into the guest.
+For example, an mmap() that affects the region will be made visible
+immediately.  Another example is madvise(MADV_DROP).
 
 On architectures that support a form of address tagging, userspace_addr must
 be an untagged address.
@@ -1412,11 +1415,6 @@ use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
 
-When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
-the memory region are automatically reflected into the guest.  For example, an
-mmap() that affects the region will be made visible immediately.  Another
-example is madvise(MADV_DROP).
-
 For TDX guest, deleting/moving memory region loses guest memory contents.
 Read only region isn't supported.  Only as-id 0 is supported.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d5b0b99fd1..7309f5084388 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -358,7 +358,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_USER_MEMORY:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ARM_PSCI:
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 9681ade890c6..41b58ec45f41 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -117,7 +117,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_READONLY_MEM:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_MP_STATE:
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b0fb92fda4d4..29d9f630edfb 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1035,7 +1035,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_READONLY_MEM:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_IMMEDIATE_EXIT:
 		r = 1;
 		break;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3da40ea8c562..00302399fc37 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -623,11 +623,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !!(hv_enabled && kvmppc_hv_ops->enable_nested &&
 		       !kvmppc_hv_ops->enable_nested(NULL));
 		break;
-#endif
-	case KVM_CAP_SYNC_MMU:
-		r = 1;
-		break;
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	case KVM_CAP_PPC_HTAB_FD:
 		r = hv_enabled;
 		break;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 66d91ae6e9b2..b4afef7e59fc 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -181,7 +181,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_USER_MEMORY:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index de645025db0f..6591ee56bf5b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -601,7 +601,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	switch (ext) {
 	case KVM_CAP_S390_PSW:
 	case KVM_CAP_S390_GMAP:
-	case KVM_CAP_SYNC_MMU:
 #ifdef CONFIG_KVM_S390_UCONTROL
 	case KVM_CAP_S390_UCONTROL:
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 391f4a5ce6dd..ac31b098bfbd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4805,7 +4805,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 #endif
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_USER_NMI:
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_IOEVENTFD:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bf5606d76f0c..51d1f7d4905e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4870,6 +4870,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 {
 	switch (arg) {
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_USER_MEMORY2:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
-- 
2.52.0


