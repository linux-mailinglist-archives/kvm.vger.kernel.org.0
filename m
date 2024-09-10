Return-Path: <kvm+bounces-26429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D50A9746F8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9262B1F275A6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B815C1C461A;
	Tue, 10 Sep 2024 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rPqDmIQl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424CA1C3F29
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011939; cv=none; b=FzaQSYD1LDmePFvcIXTqNNlQcEezcpXdSe/xN18qLhA9f0SxFwd//+m9+oQ0IYpT//obHVQ++1fZlqdKJ9ZCwtl7RPbah/FldniNCPiXymFPVBCDHIXSUJqQHOyIxISlrlNBrV3ZZJjgmejZAd1mIf1PG+PvJC9QmOs1+OS4h64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011939; c=relaxed/simple;
	bh=IxSPwacj2tBp9bysvRBs5+FfPIi+ClbTW7TLorZFK2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SgnyD2s/mD9AJT9Yvl0XWDLkDyWGJH+Ln37Qlh20//dbsyo0em7tehYloE3xSbXHT9Z1j024BuMSybMZsPy3fLyEthfD3j00EqSE3Z43hIiEZbu5om+i3J1KEfTFcb//cF/0zRWDHXV0ftKOAoYhMxtgSldBlk9ehpF6alVIqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rPqDmIQl; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd6d695662so17334525ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011937; x=1726616737; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mkb+NAnOFL/DwPaS2OVTOWWsNRjgIx4s2eg9q8AJrXM=;
        b=rPqDmIQlQ3K5oB6TQCGzX1Uccemcp2ErrTDQAH4e2++vmxnJEHH23MmbJ4MxezqSj3
         RV725vFACWrbT7fM01owygEYjCgT8hMnxKcL1HolZQHy4LJuswHIlJvIp9wtXLikN0Nz
         E1+XtmLZaf4hDREhDckFNACapmX55ui0gJeCUAQIPwtL972oUh7OtjcEAkAp0crlqjwR
         aFSxqs4SJUAN+5XYRl7L2ZVUXkf4EnWu0KWmJ6TjO952RUn1i9+JF7EstqdTflexRI1g
         VjVTZHlq4ci/ztTCiK9CWuy1WGYkYy1IycvMO4YxHQeqfwClW5mjVn2SWkqaPCCt/evN
         RvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011937; x=1726616737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mkb+NAnOFL/DwPaS2OVTOWWsNRjgIx4s2eg9q8AJrXM=;
        b=OWL7FjF5oTp5mJPrJf9Uvl71+55LGil5r+slZSgPn9fFEVtGeGgn6cb9/hQw6GJRE7
         O+ayUoSYKnDN6KIN1yNfty8vlJLyA8M7axWC3YW6crWMO5zDhbMlqrULtSsph20QQjIg
         2aq4jD031gaNnCAJWp7UZo63N9WstNHUMJjHgHncLGOi5HfYhDzPIT2gvy3AtDW6ieFk
         BHcv+H+4uHDyu/eaqlEjnO56tRJDASFLxPbp4nR/w0nNEfZc8JbSb6vsnk2Lzhum1AF3
         GPlVYUEDLit/tAs5RrvmVk7vUJAmDTP95OF65TYgS1MWzoo+7JkQKQvI3wML2Dmn5RkT
         wEEg==
X-Forwarded-Encrypted: i=1; AJvYcCV5WcMfRBrM9tcrrhKqNqng9WWn+rnyn1b+v0jX8bC6ZlDp20MfPLJSjpKkw5G0uBGam/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBZ4DT0XRzoMcg8rOMCHKdGYjwUcLbN6IQlowqSdDJeKNpHmr6
	tyfD4zHEeTx/LgZbtMPDWFTIYzANiMUT2I5Ywl7T6UhJAViBaI/Zlg22gZ2+GPSku1R0qtb+sHh
	EuhU9bttZiwxlx1DffzN6OA==
X-Google-Smtp-Source: AGHT+IEIVAikHARJb/9AtMZHbBPnKppzatT8jO6P6FcNUKI8bwXbpm7jyhYnZiKRc4hR4u8fz8EVE4930Msvwij+9Q==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:903:1ca:b0:1fb:8620:e113 with SMTP
 id d9443c01a7336-20752183657mr936435ad.3.1726011937387; Tue, 10 Sep 2024
 16:45:37 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:44:08 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <f2dbcc4df55633c62253acd6238ec682f2aa14c9.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 37/39] KVM: selftests: Add helper to perform madvise by memslots
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

A contiguous GPA range may not be contiguous in HVA.

This helper performs madvise, given a GPA range, by madvising in
blocks according to memslot configuration.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>

---
 tools/include/linux/kernel.h                  |  4 +--
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 30 +++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index 07cfad817d53..5454cd3272ed 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -54,8 +54,8 @@
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
-#define max_t(type, x, y)	max((type)x, (type)y)
-#define min_t(type, x, y)	min((type)x, (type)y)
+#define max_t(type, x, y)	max((type)(x), (type)(y))
+#define min_t(type, x, y)	min((type)(x), (type)(y))
 #define clamp(val, lo, hi)	min((typeof(val))max(val, lo), hi)
 
 #ifndef BUG_ON
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1576e7e4aefe..58b516c23574 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -433,6 +433,8 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
 			    bool punch_hole);
 
+void vm_guest_mem_madvise(struct kvm_vm *vm, vm_paddr_t gpa_start, uint64_t size,
+			  int advice);
 static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, uint64_t gpa,
 					   uint64_t size)
 {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9bdd03a5da90..21ea6616124c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1416,6 +1416,36 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 	}
 }
 
+void vm_guest_mem_madvise(struct kvm_vm *vm, vm_paddr_t gpa_start, uint64_t size,
+			  int advice)
+{
+	size_t madvise_len;
+	vm_paddr_t gpa_end;
+	vm_paddr_t gpa;
+
+	gpa_end = gpa_start + size;
+	for (gpa = gpa_start; gpa < gpa_end; gpa += madvise_len) {
+		struct userspace_mem_region *region;
+		void *hva_start;
+		uint64_t memslot_end;
+		int ret;
+
+		region = userspace_mem_region_find(vm, gpa, gpa);
+		TEST_ASSERT(region, "Memory region not found for GPA 0x%lx", gpa);
+
+		hva_start = addr_gpa2hva(vm, gpa);
+		memslot_end = region->region.userspace_addr +
+			      region->region.memory_size;
+		madvise_len = min_t(size_t, memslot_end - (uint64_t)hva_start,
+				    gpa_end - gpa);
+
+		ret = madvise(hva_start, madvise_len, advice);
+		TEST_ASSERT(!ret, "madvise(addr=%p, len=%lx, advice=%x) failed\n",
+			    hva_start, madvise_len, advice);
+	}
+}
+
+
 /* Returns the size of a vCPU's kvm_run structure. */
 static int vcpu_mmap_sz(void)
 {
-- 
2.46.0.598.g6f2099f65c-goog


