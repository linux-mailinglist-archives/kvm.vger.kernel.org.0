Return-Path: <kvm+bounces-29613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D66219AE192
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38634B236E5
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DAF1C07DF;
	Thu, 24 Oct 2024 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="l4TU/9pV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29D31BD028;
	Thu, 24 Oct 2024 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763701; cv=none; b=kQc+LWsA4xD4Dokw5qryXLdeP491+LwUKPfzJOeDQA1CKT7mRyD/HuioLogHUHXN39RiQDVHiAsVJ5X5rSQKJtuG/qrY4VDT+K5jdRzEEmcT8K0qu2/tKp/p9Yb42qxvOTa/El/Aj72TJxqE+IcowsLtb7qhmGz+gDUD+0m3Y2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763701; c=relaxed/simple;
	bh=V6a1tnpgTrpi5tfy9KML/vCwRHQQ5hweosaua4JfMzk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zmr6VPkZaAZNIOsTYOORTx2KQVXJgx8CFYEXNYe2CZ/he8TRxZ7Z+cLELv+mskWnyMrH8c7dDOnZ/rx7KK1Lg+yQj53huujSRi3Z5qOBNiRIRi9N8bAlac48jn5F/fJCtWBfs+9+DSdHPgXNhWD7Sxva0aOCCO2aJGLuoIRQuXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=l4TU/9pV; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729763699; x=1761299699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z9vqie+qwxIDDZ4iRqHz/Fa2emMPN1oyvmAoTg4g0iw=;
  b=l4TU/9pVijIF8PsCFw5jtMhUC/eY/ZMgLsGuC+mEt90dU10jXMFbdkO8
   EJxCsz2IyzrjJr4H++a0nyvtbOdi3JpEwCfU9rOmdUwJe6K50b8IAjkTo
   fp9EYTVpULtmiAod+dlSO1DjezA2Kt8AIZq2YIXFoqNZ7T6O5UTWz+Rcm
   g=;
X-IronPort-AV: E=Sophos;i="6.11,228,1725321600"; 
   d="scan'208";a="346285243"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 09:54:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.38.20:48893]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.247:2525] with esmtp (Farcaster)
 id 55ebfe2c-a83b-4838-9e79-7cc1f7f0fb46; Thu, 24 Oct 2024 09:54:58 +0000 (UTC)
X-Farcaster-Flow-ID: 55ebfe2c-a83b-4838-9e79-7cc1f7f0fb46
Received: from EX19D003UWC004.ant.amazon.com (10.13.138.150) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:54:58 +0000
Received: from EX19MTAUWC002.ant.amazon.com (10.250.64.143) by
 EX19D003UWC004.ant.amazon.com (10.13.138.150) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Thu, 24 Oct 2024 09:54:58 +0000
Received: from email-imr-corp-prod-iad-all-1b-85daddd1.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Thu, 24 Oct 2024 09:54:57 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-iad-all-1b-85daddd1.us-east-1.amazon.com (Postfix) with ESMTPS id 3F8CB40332;
	Thu, 24 Oct 2024 09:54:56 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [PATCH 2/4] KVM: add KVM_GUEST_MEMFD_POPULATE ioctl for guest_memfd
Date: Thu, 24 Oct 2024 09:54:27 +0000
Message-ID: <20241024095429.54052-3-kalyazin@amazon.com>
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

The ioctl populates guest_memfd with userspace-provided data.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  9 +++++++++
 virt/kvm/guest_memfd.c   |  7 +++++++
 virt/kvm/kvm_main.c      | 10 ++++++++++
 4 files changed, 29 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db567d26f7b9..5b0347783598 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2505,6 +2505,9 @@ typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
+
+int kvm_gmem_guest_memfd_populate(struct kvm *kvm,
+				struct kvm_guest_memfd_populate *populate);
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..5d8073de0d96 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1573,4 +1573,13 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+struct kvm_guest_memfd_populate {
+	__u64 gpa;
+	__u64 size;
+	void __user *from;
+	__u64 flags;
+};
+
+#define KVM_GUEST_MEMFD_POPULATE _IOW(KVMIO,  0xd6, struct kvm_guest_memfd_populate)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 954312fac462..08630b87f0e3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -720,4 +720,11 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_populate);
+
+int kvm_gmem_guest_memfd_populate(struct kvm *kvm,
+				struct kvm_guest_memfd_populate *populate)
+{
+	return kvm_gmem_populate(kvm, populate->gpa >> PAGE_SHIFT, populate->from,
+		populate->size >> PAGE_SHIFT, kvm_gmem_post_populate_generic, NULL);
+}
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..e5bd2c0031bf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5383,6 +5383,16 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_gmem_create(kvm, &guest_memfd);
 		break;
 	}
+	case KVM_GUEST_MEMFD_POPULATE: {
+		struct kvm_guest_memfd_populate populate;
+
+		r = -EFAULT;
+		if (copy_from_user(&populate, argp, sizeof(populate)))
+			goto out;
+
+		r = kvm_gmem_guest_memfd_populate(kvm, &populate);
+		break;
+	}
 #endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
-- 
2.40.1


