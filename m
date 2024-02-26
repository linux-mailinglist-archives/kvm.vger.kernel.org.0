Return-Path: <kvm+bounces-9972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A7786805F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F182D1F25F54
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A7412EBF6;
	Mon, 26 Feb 2024 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5WMXILR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949212F39C
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974232; cv=none; b=CMGecNDuWbYTwNnSckLExiy0JZ/DrO49d3CyvHs/af4GN0Un8N6zAiJ6YCh4jvtRK7+lYuvXSlUprU3ZfyxlpH52DrGyJVzjDlv5Zqs6mlIvaG55QY6gxA+QTKV7IZKDWw4/iCJDPCXvfZwWimajZjvdV2ZI6MiXM1r9uB+c15g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974232; c=relaxed/simple;
	bh=365HX1koM5s1rKiT2wfEYWXzusfKgDR6HIIYyfQCgvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njlEh1Eoc6dYivjXjnUwPjW5yF6o3boEtqiguKCImTleOxztmYcqDzbPft6+udbmuKpfdisXhdoSPE/TgqVrHE7ZNJVD0/dNRIaA3LdUiUhC73SvOW7IHTC1tJx/ZtGS7atXZeWOUAKW1GyMhCBJbhTOm5sVStITL0dz0VNJEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R5WMXILR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrpFxJCexxYzP/66dv8sDZ2xWIWJ/QIQbY4Xg6TPt7Q=;
	b=R5WMXILRFz0LXmwV/1W1G37zd5Cct7TS8F2KYvaPY+SCcC+QnjvZObEpqdMBY82M6pBAPR
	YROG6HJDGrjytcZy+ncV8lvZUT2gTKfUphZFxG7WJWg/pjOeY0FSkbbRCOyMC7OrmZfsaj
	2StHDnI1K2D61fD5mkwT/4YT+G3J3bY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-38gKcZKRMhiuJsCSNaeXIQ-1; Mon, 26 Feb 2024 14:03:46 -0500
X-MC-Unique: 38gKcZKRMhiuJsCSNaeXIQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 130A388D543;
	Mon, 26 Feb 2024 19:03:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE074492BC6;
	Mon, 26 Feb 2024 19:03:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 02/15] KVM: x86: use u64_to_user_addr()
Date: Mon, 26 Feb 2024 14:03:31 -0500
Message-Id: <20240226190344.787149-3-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

There is no danger to the kernel if userspace provides a 64-bit value that
has the high bits set, but for whatever reason happ[ens to resolve to an
address that has something mapped there.  KVM uses the checked version
of put_user() in kvm_x86_dev_get_attr().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f3f7405e0628..14c969782d73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4791,25 +4791,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
-static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
-{
-	void __user *uaddr = (void __user*)(unsigned long)attr->addr;
-
-	if ((u64)(unsigned long)uaddr != attr->addr)
-		return ERR_PTR_USR(-EFAULT);
-	return uaddr;
-}
-
 static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr = kvm_get_attr_addr(attr);
+	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
 
 	if (attr->group)
 		return -ENXIO;
 
-	if (IS_ERR(uaddr))
-		return PTR_ERR(uaddr);
-
 	switch (attr->attr) {
 	case KVM_X86_XCOMP_GUEST_SUPP:
 		if (put_user(kvm_caps.supported_xcr0, uaddr))
@@ -5664,12 +5652,9 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
 static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 				 struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr = kvm_get_attr_addr(attr);
+	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
 	int r;
 
-	if (IS_ERR(uaddr))
-		return PTR_ERR(uaddr);
-
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET:
 		r = -EFAULT;
@@ -5687,13 +5672,10 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 				 struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr = kvm_get_attr_addr(attr);
+	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
 	struct kvm *kvm = vcpu->kvm;
 	int r;
 
-	if (IS_ERR(uaddr))
-		return PTR_ERR(uaddr);
-
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET: {
 		u64 offset, tsc, ns;
-- 
2.39.1



