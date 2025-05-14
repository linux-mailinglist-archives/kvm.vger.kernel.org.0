Return-Path: <kvm+bounces-46604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 624E2AB7A38
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB104178BF8
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761326C399;
	Wed, 14 May 2025 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xN3xVQ5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE37322DF86
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266256; cv=none; b=TTKMNHGTgICSRyv3CZ/fvn0C7pc2BK7MzNCG1jzMuJoA1H/hLvcSG327L/5u9lw6EZrz2bvwgkXSj1ndWsNnzRd4RoPL1TY3lpjNC8GCbRBVBdjAs5M2aKAou5YMkCFPjAVpB0zDAc84cGy7e5dhzRU9vOXb3OwX1WKlrLdZc1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266256; c=relaxed/simple;
	bh=W4BuF5k7B7Tw/7iEJJF+2Dr7h9c8MMcjTfURTwwSkno=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fNQgbNxqTtX5e/j609lAFY6wOMW1kbQhGvuOOVNMJ9OgYmwqEui4zuOFCEJ/rV0uVOhiurwFh+KL1y1+BFgXJYJta8Ofha9qDtOBs5RgtGrmzSTHW8m7rwC30RRDi+QBgxAWQBzqEOALyYHCSFJePVcNKLYenoDPFXyK0eRx1Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xN3xVQ5M; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c4b072631so348551a91.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266254; x=1747871054; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cgpRGOQjA/CW069YjbpUEsTR9l1DVf09U2PvTNruEdk=;
        b=xN3xVQ5MBlt7ING8YtP7kdoFTcQQYr+idO4YOSfyE8Ov36J/U2IVYS69BUq7bVUYvk
         BgUcHYh3wUgg+HuAv60t/SlMBOdOk4cGiJnIS0Ht5RH1DGVfbZ2sVTPn/vv/m44tInVj
         sghXHb0U4NYVnjbsFBqKd9Go64SNTHw+S5Ty10gTT+6bSQp5lXMl3eXVy16vTNcx8Loy
         sKlMvcW0WKkxHK8W50y8zkgqrH7QGGuoHNOrw2bMMWFaFsH81PApXdSLEJteHTaP+69r
         wh9fYBCV4naU0lR5QDBaDCFSGq85ixY16itXygSnvMzesmHzpaZm/nc1n/qkKDfXr2ty
         Yyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266254; x=1747871054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cgpRGOQjA/CW069YjbpUEsTR9l1DVf09U2PvTNruEdk=;
        b=eHFSidtEE+Cki2ggQP93Su6jcKVnqttFqg/PWsWShVjucDsZ7b+pPySDVt5x/vTNNJ
         YzNMiMAFt7jz880vFwFtRBvQI8XPsNkGrP00OLanG5/fEn38kP9Qze+qTrgLmwCf5Ic6
         PxQuvXw9Gw7w//+RvbbRrGd2wuZJtdBGnSZn00SxwraUpS1sjT7Nw4NObofNnAHQtyeI
         Fll7XC18cq1Nf+rSp3Ytigc82jvovFrmMn8NUVEN62ThmYgbkoVIkMUniwKQCaJP/xOA
         ACIs4InaPzq3mZc+/AhJzMWmG1JseyhSiW422Fe6hj35UUCES+sj9+01p61v5jswNDjD
         5aFg==
X-Gm-Message-State: AOJu0Yz4Dh2PJYXYX+bResMf1w/yoFOtur8z7ymHy79J/4olV5kfQebs
	j1Dasc7FseyNXTqBpncdbJR/sbmjz0YmOq9AmsrqqKdyZC6aP37I3NilxdiIO/T0C+0RFQvuUzu
	M3oLejhGFuAKYVJ7H3oqfsdI7NIn59BY9AGK6HzqZb82p7jJ6freFFJFzg+h8SJmqcyAB/zThgd
	RzAqAfZARLbOrB1ZrsoiuPh8+o2MWX+HY94QvEZeyl/d+JP5dlHfh/P0Y=
X-Google-Smtp-Source: AGHT+IGCW/uG3koL7ZmUpNQ3fu2bu9Qxb+Pwj1sAO0kEu9QYRpIBgr98bzhS9ZJB60f0G+PEHbBrD9llUcw4LLEWwA==
X-Received: from pjboh6.prod.google.com ([2002:a17:90b:3a46:b0:2f4:465d:5c61])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d4f:b0:2fe:a336:fe63 with SMTP id 98e67ed59e1d1-30e5190763cmr782897a91.24.1747266253599;
 Wed, 14 May 2025 16:44:13 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:28 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <d8cab3a09f541bebb327decc043d830da3384f9c.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 49/51] KVM: selftests: Update private_mem_conversions_test.sh
 to test with HugeTLB pages
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

Update test script to also test HugeTLB support for guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Change-Id: I7c6cc25d6b86e1e0dc74018f46c7e2796fab6357
---
 .../kvm/x86/private_mem_conversions_test.sh   | 29 ++++++++++++++-----
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
index 5dda6916e071..0d2c5fa729fd 100755
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
@@ -57,6 +57,17 @@ backing_src_types+=( shmem )
 	backing_src_types+=( shared_hugetlb ) || \
 	echo "skipping shared_hugetlb backing source type"
 
+private_mem_backing_src_types=( private_mem_guest_mem )
+[ -n "$hugepage_default_enabled" ] && \
+	private_mem_backing_src_types+=( private_mem_hugetlb ) || \
+	echo "skipping private_mem_hugetlb backing source type"
+[ -n "$hugepage_2mb_enabled" ] && \
+	private_mem_backing_src_types+=( private_mem_hugetlb_2mb ) || \
+	echo "skipping private_mem_hugetlb_2mb backing source type"
+[ -n "$hugepage_1gb_enabled" ] && \
+	private_mem_backing_src_types+=( private_mem_hugetlb_1gb ) || \
+	echo "skipping private_mem_hugetlb_1gb backing source type"
+
 set +e
 
 TEST_EXECUTABLE="$(dirname "$0")/private_mem_conversions_test"
@@ -66,17 +77,21 @@ TEST_EXECUTABLE="$(dirname "$0")/private_mem_conversions_test"
 
 	for src_type in "${backing_src_types[@]}"; do
 
-		set -x
+		for private_mem_src_type in "${private_mem_backing_src_types[@]}"; do
 
-                $TEST_EXECUTABLE -s "$src_type" -n $num_vcpus_to_test
-		$TEST_EXECUTABLE -s "$src_type" -n $num_vcpus_to_test -m $num_memslots_to_test
+			set -x
 
-                $TEST_EXECUTABLE -s "$src_type" -n $num_vcpus_to_test -g
-		$TEST_EXECUTABLE -s "$src_type" -n $num_vcpus_to_test -m $num_memslots_to_test -g
+			$TEST_EXECUTABLE -s "$src_type" -p "$private_mem_src_type" -n $num_vcpus_to_test
+			$TEST_EXECUTABLE -s "$src_type" -p "$private_mem_src_type" -n $num_vcpus_to_test -m $num_memslots_to_test
 
-		{ set +x; } 2>/dev/null
+			$TEST_EXECUTABLE -s "$src_type" -p "$private_mem_src_type" -n $num_vcpus_to_test -g
+			$TEST_EXECUTABLE -s "$src_type" -p "$private_mem_src_type" -n $num_vcpus_to_test -m $num_memslots_to_test -g
 
-		echo
+			{ set +x; } 2>/dev/null
+
+			echo
+
+		done
 
 	done
 )
-- 
2.49.0.1045.g170613ef41-goog


