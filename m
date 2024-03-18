Return-Path: <kvm+bounces-12035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D6B87F2FF
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E4D728228B
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5F25BACE;
	Mon, 18 Mar 2024 22:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oweyq+ZH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40D85A7A4
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799812; cv=none; b=WjFS//S466Vfut6CKFen3qsskem3mW593d1F2ADRci+1BwrZi8kIFtEti2Ub60pj4uyaJQHJc3AHcr0rtAI6jVRAi/bMf1ueu6I3c2x1RPoU/6p5+HuFLGFJwtid5dkFV76q4QfkcgkM0l+FFP7y9R1npll3MWC0LyURGaPFKu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799812; c=relaxed/simple;
	bh=qaJEDXwpaSJXM+1hD3fE9I/G0z5IQq6ORF3Rr7L/kFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FbqRoHhz1hnBfzjT4lpJ53Y9MzGoK2oKkLGoC6D/SDcTOIQu4yAEnEkNS1sMzHEmqNPx7KmFPieSe6xCL9x7B7MCbmNUZgek1zevJGAW5bNu7+c+EnPpfRdQNOb80DD3BjiZC+i9Hu2Uafuac68j+bwZSz+TOTjOEHa90XKedXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oweyq+ZH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gMEmPn7yUS4wreWy4Dg8bjqaNwIrv+R0K2a7wjWFE2c=;
	b=Oweyq+ZHJPFFblZSItslMbFYos30zMCI82YiJvXEJ3uBKMy8qfq4xQ9akudLl9qheSyquE
	6miew7iYxfyH2/as2OJJxDp01tdyIlg9wuLACUCdIFNPJvKDkH/ZxP7dro9n08oYQGlhR/
	EgU6Bqmo8DICtgMKPHCbFxAbP/RTjWU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-0_C0MuIrMzapy9sgm8UnZQ-1; Mon,
 18 Mar 2024 18:10:05 -0400
X-MC-Unique: 0_C0MuIrMzapy9sgm8UnZQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1DC11C04332;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B483F492BC8;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH 7/7] Documentation: kvm/sev: clarify usage of KVM_MEMORY_ENCRYPT_OP
Date: Mon, 18 Mar 2024 18:10:02 -0400
Message-ID: <20240318221002.2712738-8-pbonzini@redhat.com>
In-Reply-To: <20240318221002.2712738-1-pbonzini@redhat.com>
References: <20240318221002.2712738-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Explain that it operates on the VM file descriptor, and also clarify how
detection of SEV operates on old kernels predating commit 2da1ed62d55c
("KVM: SVM: document KVM_MEM_ENCRYPT_OP, let userspace detect if SEV
is available").

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst          | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 4f2eb441c718..84335d119ff1 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -49,12 +49,13 @@ defined in the CPUID 0x8000001f[ecx] field.
 The KVM_MEMORY_ENCRYPT_OP ioctl
 ===============================
 
-The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
-to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
-and ``ENOTTY`` if it is disabled (on some older versions of Linux,
-the ioctl runs normally even with a NULL argument, and therefore will
-likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEMORY_ENCRYPT_OP
-must be a struct kvm_sev_cmd::
+The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP, which operates on
+the VM file descriptor.  If the argument to KVM_MEMORY_ENCRYPT_OP is NULL,
+the ioctl returns 0 if SEV is enabled and ``ENOTTY`` if it is disabled
+(on some older versions of Linux, the ioctl tries to run normally even
+with a NULL argument, and therefore will likely return ``EFAULT`` instead
+of zero if SEV is enabled).  If non-NULL, the argument to
+KVM_MEMORY_ENCRYPT_OP must be a struct kvm_sev_cmd::
 
        struct kvm_sev_cmd {
                __u32 id;
-- 
2.43.0


