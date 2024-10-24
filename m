Return-Path: <kvm+bounces-29614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BB59AE196
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B76C61F21540
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5811C1758;
	Thu, 24 Oct 2024 09:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="CmIIy1Ft"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9C1B6D1A;
	Thu, 24 Oct 2024 09:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763718; cv=none; b=hJI6eo5bg+M3v/fMLwQiBDmYnYL/QlIXoAe4gWYbqBK47Bh6tuK4gZTAbVog4gcGjGTUehjLEXj5yxVaxVftXFuBpc/x2endWCsrdL5rmME1TLLq5PSj6ZjCwgoEQgearhuuAscJAif0aSxzSbMgAExa3/F1qKKOdSJPCkX4hJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763718; c=relaxed/simple;
	bh=O6drzlv3N80zmY7Pe/nx5UWGSkU3ccJmkWXqNPnK4jY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WslQQa28ECeBlZWKeJQJSFUghfld8CnnN8m3xQdkYBYwkkw/iQ/777BpViUtjWoF2z4G1guEBywDNeF4nLsZDH6uw08/wIkUfFzcm75DyBltltBrJj+jQyP1zRlxuU3DzSm+lyz7sh3MUUthE/aOYQvyrO3t4CdCqQbnJviqX/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=CmIIy1Ft; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729763717; x=1761299717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MmRiiZPN8/PxouBRWWyXIjMBR7ptHi0tvj2mQku4mOY=;
  b=CmIIy1FtgHOYnMZRSdFmk8BPmESvLk6tEd1/m08xTsSeCcErIPcuwrx/
   Vvj7tUJmYOzY+qmASgJmikCO70uLHi1/w2g0T0loBfomlG5Ekq6jjbiy8
   +mlmc/FIla0j3qb5TcfrAE9kz7w+cvDu21VoeaJJBv/pk69tAugGwlwHJ
   Y=;
X-IronPort-AV: E=Sophos;i="6.11,228,1725321600"; 
   d="scan'208";a="690218938"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 09:55:12 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:45954]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.247:2525] with esmtp (Farcaster)
 id 9c21d62f-0fbe-4351-baa5-5eb88fe8a31f; Thu, 24 Oct 2024 09:55:11 +0000 (UTC)
X-Farcaster-Flow-ID: 9c21d62f-0fbe-4351-baa5-5eb88fe8a31f
Received: from EX19D020UWA002.ant.amazon.com (10.13.138.222) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:55:10 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D020UWA002.ant.amazon.com (10.13.138.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:55:10 +0000
Received: from email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Thu, 24 Oct 2024 09:55:10 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com (Postfix) with ESMTPS id 8D8D540397;
	Thu, 24 Oct 2024 09:55:08 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [PATCH 3/4] KVM: allow KVM_GUEST_MEMFD_POPULATE in another mm
Date: Thu, 24 Oct 2024 09:54:28 +0000
Message-ID: <20241024095429.54052-4-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241024095429.54052-1-kalyazin@amazon.com>
References: <20241024095429.54052-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Allow calling KVM_GUEST_MEMFD_POPULATE ioctl by the process that does
not own the KVM context.
This is to enable guest_memfd population by a non-VMM process that is
useful for isolation of the memory management logic from the VMM for
security and performance reasons.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 virt/kvm/kvm_main.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e5bd2c0031bf..eb626c4bf4d7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5159,8 +5159,25 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm || kvm->vm_dead)
+	if (kvm->vm_dead)
 		return -EIO;
+
+#ifdef CONFIG_KVM_PRIVATE_MEM
+	if (ioctl == KVM_GUEST_MEMFD_POPULATE) {
+		struct kvm_guest_memfd_populate populate;
+
+		r = -EFAULT;
+		if (copy_from_user(&populate, argp, sizeof(populate)))
+			goto out;
+
+		r = kvm_gmem_guest_memfd_populate(kvm, &populate);
+		goto out;
+	}
+#endif
+
+	if (kvm->mm != current->mm)
+		return -EIO;
+
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
 		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
@@ -5383,16 +5400,6 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_gmem_create(kvm, &guest_memfd);
 		break;
 	}
-	case KVM_GUEST_MEMFD_POPULATE: {
-		struct kvm_guest_memfd_populate populate;
-
-		r = -EFAULT;
-		if (copy_from_user(&populate, argp, sizeof(populate)))
-			goto out;
-
-		r = kvm_gmem_guest_memfd_populate(kvm, &populate);
-		break;
-	}
 #endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
-- 
2.40.1


