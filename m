Return-Path: <kvm+bounces-46582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA9CAB79E0
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09DE81BA671B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBF3253B68;
	Wed, 14 May 2025 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U0uki/0s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873A325332D
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266222; cv=none; b=teKg89Azxu9LlZODn9NQP8YyYwd6IuQOVzXM9fvyV86u87euGCR7EVjOLk03qk4D7YqyinyYdgjnvFXsgyf3w3pzPY6VdO/WO2uOQ6bQ2CCcCfAn1p87xanR7MqKqBHQC2a52RGX8lWJTbemD9tPUGaXzXU7hUubzVcpqmLIpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266222; c=relaxed/simple;
	bh=VN6Zy91LaMiTbU6A7di8uTmOZRNoQlpEPvLShP2HHx8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HZoY8Fxy4K0/MCa+1XUB2hRTz5pHthff7hhoP3sR8OwFLAckMoYFDqqdVITeZnmcJfbXyVQjr8xHLNQ6xKk+18GhVqBODfeCGznSGF470cbnQI+UCzTLHTK9l3t7qvL570H2nFKRhW1O3F+FqoX1DTN/wrctQzCLfVC80C1KziY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U0uki/0s; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b269789425bso262943a12.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266220; x=1747871020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xjDNmSUtedoYx4zVHC06mLM1phpXgQwReFmVa/WU1hs=;
        b=U0uki/0sHvm8k8xtxoaYlZmDnzu8OEgp+rRgXhwS3cuoKRMcEfOyw+S636V5AwXVtx
         wynt/BnK6rgvpB3vYvJH70ROUvx99i/x57joBNDTxzU+fRHfCnQ+Vrb/119R0yjNyIZP
         Q/af0K5SNYzzI7cFLG5q2VlvfQTtM9lRB+4DV/mn0d4IvAG9jHRAbSKRXgrgRCUbbzRW
         JFWsxA+xkxd+E582P93aPvEzVq9V8vuu/7gT8SRnpEg3Hs1dmldiDX7jElk0Bj7Gw1Vi
         z9U5TtvR2kUNm0Wl0MdUFZKCwDXEq/Tv8XhtfgS/UWJjso1yRI6U9Ex/Dy1h/P2x91dH
         GbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266220; x=1747871020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xjDNmSUtedoYx4zVHC06mLM1phpXgQwReFmVa/WU1hs=;
        b=tAhwh/TaqAh6YFdf/VRpsYTDTT9c2YNvZC+wITrCUXzIfi+ZYxULIyk7t3Bkd5M8zP
         rznSRZT/N6y8HEf1ZGJx7sr9DE0p7Z4FIDpWzKB8JxooVVvm7Vx6cskPB/DIoL7C2NoS
         dOum4ucj2jzPJx3bJKaiNHvvP4BTdHTrZK5krLDe5c4szJ7IEdVxXCtAPg/RaBetuo1C
         L3CggefIR2qoz4EK4vMFDsMftQGrygLbsU+38cx8enI0CUX9O0nBGkEflI4D9k3Rrff+
         /ZsYVBm1W0+Xx/77tQMDDaiarD0e6IUaHfvQrI1OOVjUJOQeR8R1oQ+noWEhOfP35b0Z
         /O/w==
X-Gm-Message-State: AOJu0YweyCLWEMhv7PfDWMKf/dWnolpiKMWf0WZbvFu9QiV5HTWlCqDi
	15mmsS8rYKLLbUNpWOzdftVRh0WqXnzVksQOzijRcQKkxpaLPlHqHLRJ5Ld1pRiQcXMAA8vwRiE
	t0dD79ixg3Abm/Jt2GqK/ZGZmGfEk4gZ5KoLlfBYLxQgAPw/j3TlVn/Y3QP9xnkaQGm77oRzySp
	rJcZeNyPCnDAIaGLtrb3F6QlNpFBePzirXgKqenF8lT+jQcEwG/Q1WLIs=
X-Google-Smtp-Source: AGHT+IF1YPUusmAbmb3ZD3GPQhCrYy6/top7yw+u+NgqlU9DG8yUspI8ex9oYsbLJOClXn04qHIYKawEAR+7VdCYWQ==
X-Received: from pfbbd12.prod.google.com ([2002:a05:6a00:278c:b0:740:555:f7af])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3949:b0:1ee:dded:e5b with SMTP id adf61e73a8af0-215ff11a531mr7641318637.24.1747266219362;
 Wed, 14 May 2025 16:43:39 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:06 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <779107f1ff8c79095ca0b2d7921e4c54e20861ad.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 27/51] mm: hugetlb: Expose hugetlb_subpool_{get,put}_pages()
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

This will allow hugetlb subpools to be used by guestmem_hugetlb.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I909355935f2ab342e65e7bfdc106bedd1dc177c9
---
 include/linux/hugetlb.h | 3 +++
 mm/hugetlb.c            | 6 ++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index c59264391c33..e6b90e72d46d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -119,6 +119,9 @@ struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 					      long min_hpages, bool use_surplus);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
+long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta);
+long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
+
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
 int move_hugetlb_page_tables(struct vm_area_struct *vma,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d22c5a8fd441..816f257680be 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -205,8 +205,7 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
  * only be different than the passed value (delta) in the case where
  * a subpool minimum size must be maintained.
  */
-static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
-				      long delta)
+long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta)
 {
 	long ret = delta;
 
@@ -250,8 +249,7 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
  * The return value may only be different than the passed value (delta)
  * in the case where a subpool minimum size must be maintained.
  */
-static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
-				       long delta)
+long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta)
 {
 	long ret = delta;
 	unsigned long flags;
-- 
2.49.0.1045.g170613ef41-goog


