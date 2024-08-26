Return-Path: <kvm+bounces-25090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E86F95FAD6
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36851F2396B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0BC19E7E5;
	Mon, 26 Aug 2024 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MTLyfwYW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249D019E804
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705060; cv=none; b=SDeY4Ro5stDheAPj8WZosJdnkbNnNb8KhrDI8bR9aoOrG6Hb9dTmHFr2zt+Spoyb1IzZHwW6HvstQDDIqt5c4GEdcP8jIoqBPxaTW8DSUuwyYWyE5ijGyrADdJpVfSVR+AojMsc4QDwbUduvWGg3tKQAsHU9NX2tBep6Nm6S5c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705060; c=relaxed/simple;
	bh=Aa8NqcDK98lGFy3crPXQ+TfEjjdi6Ds7uzzU5PCZnys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfRYdCe0z1NGRow4ERoD3UfJob3IYkRZoecEnetCl7GFBshAbN/OwC8TzFQuPM/3PKR3G7FwbHum6FK2JcG9xDuM+Bzos7RPWXhth97QB4UNl8gP98QxzHwsOn14P49Ql59iJ1OvwrM6VrJyLeqpWBn+SRWksT2VymKwsshs//8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MTLyfwYW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RcTv8PG6WUMces5zPq/dQ8qXZuImd+6bX+nNmvbIpbY=;
	b=MTLyfwYWhsMNf4pb8kDAIarW8+NJrX1jRYCOcCCbMnphHbPayWDQNhkXv+WbsSFVFDxAaU
	faWdGVgSt1FLMgroQvR8PefnTKq3LP7LuAT7w6shXP2qaNNOoqLv+l2IrZ2lefKUKDjAYt
	k5MJntAJ+WsiM6ZzFDmViVA3hIP7cWY=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-6ZHkzoHXMkycCmARbOEhfA-1; Mon, 26 Aug 2024 16:44:17 -0400
X-MC-Unique: 6ZHkzoHXMkycCmARbOEhfA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6b41e02c293so94041137b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705056; x=1725309856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RcTv8PG6WUMces5zPq/dQ8qXZuImd+6bX+nNmvbIpbY=;
        b=DOXzrREKS3YOt/v2mkO1gKntLXDFyTRacZYZ0SVt90JwVlDo6/65gOnSnIZrqLbIZV
         SEwUFB4ZKkfvQrv9YGO6tNaTj9vI0/0ibVJ6BMBytYh2V8dKBYEliQgb8iqGtI3le/JR
         bTPNSTOff7t25kLveHkHGQbFomAxaadLGLGtnhCUDoFD3XcqQweJABLciZ47+JlEJjjE
         LTEHMZftz/G5PSR18yl3mHKhsZXuY35f3aKO0BDaV9hkvOjdcA3s5IXx4wrPK5wY79zn
         gn2jtpTB5cS7DIKz21xjQzaO5o8B1dWihVXYgdQeXOwCCtfcdhicqPhIr3HNob8MDHhe
         UYag==
X-Forwarded-Encrypted: i=1; AJvYcCVWsB7BJJpyqKCr8eaKFk7zI29ahEueMBF8rOQhjH4D6n0EwjMlNvL0otmRlbVgXeiAwWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YybSjAZyd1EkLmXoT4UP6fHpqlFjL7WcjG3qfi7gzMJ8oFn/926
	0vc4M4kEXolbHH/Lvseqx12YfYjetsLtO42I1T7C50qrpXg3P7NFId1OJauh6hbRRGl1HvYlJNW
	gBt4go6yFK1IQZm/rnDLwVTiMsB+jUTdWhl5hn12WtRMdJ8TD/A==
X-Received: by 2002:a05:690c:4246:b0:6b2:4154:e598 with SMTP id 00721157ae682-6c6262f43e4mr113946487b3.26.1724705056539;
        Mon, 26 Aug 2024 13:44:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCZvjuJnmUbtCZKJF68AHOtk4V9xJHAv9nFBXLLIOg3bv7tZNlMwBWnRJYIMuW8OX1o2s1rQ==
X-Received: by 2002:a05:690c:4246:b0:6b2:4154:e598 with SMTP id 00721157ae682-6c6262f43e4mr113946177b3.26.1724705056224;
        Mon, 26 Aug 2024 13:44:16 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:15 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 10/19] KVM: Use follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:44 -0400
Message-ID: <20240826204353.2228736-11-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the new pfnmap API to allow huge MMIO mappings for VMs.  The rest work
is done perfectly on the other side (host_pfn_mapping_level()).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb2b78e92910..f416d5e3f9c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2860,13 +2860,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool write_fault,
 			       bool *writable, kvm_pfn_t *p_pfn)
 {
+	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 	kvm_pfn_t pfn;
-	pte_t *ptep;
-	pte_t pte;
-	spinlock_t *ptl;
 	int r;
 
-	r = follow_pte(vma, addr, &ptep, &ptl);
+	r = follow_pfnmap_start(&args);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -2881,21 +2879,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		if (r)
 			return r;
 
-		r = follow_pte(vma, addr, &ptep, &ptl);
+		r = follow_pfnmap_start(&args);
 		if (r)
 			return r;
 	}
 
-	pte = ptep_get(ptep);
-
-	if (write_fault && !pte_write(pte)) {
+	if (write_fault && !args.writable) {
 		pfn = KVM_PFN_ERR_RO_FAULT;
 		goto out;
 	}
 
 	if (writable)
-		*writable = pte_write(pte);
-	pfn = pte_pfn(pte);
+		*writable = args.writable;
+	pfn = args.pfn;
 
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -2916,9 +2912,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 */
 	if (!kvm_try_get_pfn(pfn))
 		r = -EFAULT;
-
 out:
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 	*p_pfn = pfn;
 
 	return r;
-- 
2.45.0


