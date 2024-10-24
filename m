Return-Path: <kvm+bounces-29612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A73449AE18E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 663E12835CB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5AF1B85C2;
	Thu, 24 Oct 2024 09:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ObSHBuuj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB123D97A;
	Thu, 24 Oct 2024 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763694; cv=none; b=LFDjrDvdphwQBdXU8e9j7YamU7jasTjTOl69IJfYfAhZNjRVD3/f4Afa7PKnS3OP7+bS9Kot1hcR5juakV52jZx1lIJT5Ry0WNT0RkUDfK94ZulEiQJ82K2cgw+l27M/9mMZV7Xd4XJGD6ICoQcpap1of+ZRgtZOnUInT16CDUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763694; c=relaxed/simple;
	bh=Vm30obtvNBOsfRWOkhOhURf+utpftRsj6VLtVbbLf3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5h+6waBukCqWlGcTt6TjrFSpsfvdTpZAjR8MXedIxhSbtet4Yc4KkMqDKDBi0HP0at+CP/BqA421fLy8Cxb4jRfyVdm6SaZTn/wUhIYjnNvfic/pRd2FZR8vHJEco2SAWSBxxdzMaHGk+NVPNI0Vu+1PCVewwGVB81HkbZ+j5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ObSHBuuj; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729763693; x=1761299693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zGaGRh6pThs28O+PYGMQA/2BKq+XUg9DWEGRq2ZHKy0=;
  b=ObSHBuujhDJdh4qVRv4XEDEmJCpidT3u0WpgbODOIMRuz7SjrWAWwSNG
   JAjPReS6FHVgRZU1ZqPJZ6hNh9XLBTleeVI2T785DlelWs1M3Tw86Ax3o
   yUoKXBfp7+04OTcfCE+6gELphMrIsyiCVaZAoo0z7Fk2h14ATbkb0NOrT
   Q=;
X-IronPort-AV: E=Sophos;i="6.11,228,1725321600"; 
   d="scan'208";a="346285217"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 09:54:52 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:5902]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.36:2525] with esmtp (Farcaster)
 id 1d508ede-fb85-4b3c-82e1-78b54e777340; Thu, 24 Oct 2024 09:54:51 +0000 (UTC)
X-Farcaster-Flow-ID: 1d508ede-fb85-4b3c-82e1-78b54e777340
Received: from EX19D003UWB004.ant.amazon.com (10.13.138.24) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:54:45 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D003UWB004.ant.amazon.com (10.13.138.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Thu, 24 Oct 2024 09:54:45 +0000
Received: from email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Thu, 24 Oct 2024 09:54:45 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com (Postfix) with ESMTPS id 6CD5140397;
	Thu, 24 Oct 2024 09:54:43 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [PATCH 1/4] KVM: guest_memfd: add generic post_populate callback
Date: Thu, 24 Oct 2024 09:54:26 +0000
Message-ID: <20241024095429.54052-2-kalyazin@amazon.com>
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

This adds a generic implementation of the `post_populate` callback for
the `kvm_gmem_populate`.  The only thing it does is populates the pages
with data provided by userspace if the user pointer is not NULL,
otherwise it clears the pages.
This is supposed to be used by KVM_X86_SW_PROTECTED_VM VMs.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 virt/kvm/guest_memfd.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8f079a61a56d..954312fac462 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -620,6 +620,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+static int kvm_gmem_post_populate_generic(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
+				  void __user *src, int order, void *opaque)
+{
+	int ret = 0, i;
+	int npages = (1 << order);
+	gfn_t gfn;
+
+	if (src) {
+		void *vaddr = kmap_local_pfn(pfn);
+
+		ret = copy_from_user(vaddr, src, npages * PAGE_SIZE);
+		if (ret)
+			ret = -EINVAL;
+		kunmap_local(vaddr);
+	} else
+		for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++)
+			clear_highpage(pfn_to_page(pfn + i));
+
+	return ret;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-- 
2.40.1


