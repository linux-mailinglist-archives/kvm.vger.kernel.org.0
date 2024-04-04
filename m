Return-Path: <kvm+bounces-13547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3848986E8
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E427B26A6B
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B4712839D;
	Thu,  4 Apr 2024 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0bsc2eW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023AE8627D
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232816; cv=none; b=hNun1Vhi+CzEXgjpHaLkpBSBPjyA3g+CCO9YvkR9+75qpcG2xLchXpCspjRwCVN6ETdjCRyHyp31RmAyli2GgAx3OU+ufsbf5ZjdrhJQAdHRxkySzOoEtjDuNBztBYGTgdu7k/LF5VytKneTBnpubZe6m0Xghakuypc+Yxc/MHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232816; c=relaxed/simple;
	bh=3UZOWxvel2gxNTwrPzBwKutiH6HW6UJXahf+TYTu8Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAjKx16USLR2KPc8WYxrBAgc41FlNMacDNg7P7S8jak2UF7c6EeK6rGhgyDNrIfc722DNtflCA6i/H6m2z5PLdhH4zi0H66rsUY1yDGqNFGDssh6iXW6UknISk7ttmWQb0i/t+d7DJrUQ2z1C6ohxRCpB2WgtLEBYfnSssZr+NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0bsc2eW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IyuuUxiGnoaxGNnwqcPQ8aX2JAcsb4DAgIo+w+cUTM=;
	b=W0bsc2eW1oHcZRmdehVPIsjuXIPAkvgvu2zaE+YSYqSLsD+UfFyfSgoVFdnKZY9Mk32rGt
	KKPcRjzM/0IOTL6NVPudTrNY47G6Nn1TgndXBz1PmIC5IgiFI447luUCnBRcOGsomO1ocR
	cUW4/+z7dtIPeSeGhrwL/elzbpL2Rrk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-J2GjL78mPd-aU5DuVvTYUg-1; Thu,
 04 Apr 2024 08:13:29 -0400
X-MC-Unique: J2GjL78mPd-aU5DuVvTYUg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A5A91C05AC8;
	Thu,  4 Apr 2024 12:13:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D59DE2024517;
	Thu,  4 Apr 2024 12:13:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v5 03/17] KVM: x86: use u64_to_user_ptr()
Date: Thu,  4 Apr 2024 08:13:13 -0400
Message-ID: <20240404121327.3107131-4-pbonzini@redhat.com>
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

There is no danger to the kernel if 32-bit userspace provides a 64-bit
value that has the high bits set, but for whatever reason happens to
resolve to an address that has something mapped there.  KVM uses the
checked version of get_user() and put_user(), so any faults are caught
properly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..3d2029402513 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4842,25 +4842,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
@@ -5712,12 +5700,9 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
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
@@ -5735,13 +5720,10 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
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
2.43.0



