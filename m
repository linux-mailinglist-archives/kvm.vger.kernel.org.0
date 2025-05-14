Return-Path: <kvm+bounces-46568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2CAAB79C5
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9ABD7BA1A8
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473B1241680;
	Wed, 14 May 2025 23:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Gv2gOpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8850A239E64
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266200; cv=none; b=p37g+aVofA9pm7wLaXgs1ENiYKIj6Fi07n7gjDOClmcyzYMSC1GOz71xUc6M6QPkI/7hYRAXKXLv1mZUBGfw8eOdfNoO8hTM+w7CuSO/B5rPtn8hRwkkfRYSTzJazYX/HiBm/ZzFj6MAJRhbiWlxoFyGk6UGbjMazVtYGuBmy9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266200; c=relaxed/simple;
	bh=W3kQvVjiVRdrC872LeW4B4Hq/K4Vu3vda0e9Fhub7Es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ylb3F/amYKehao0M/gYmP/A7Dx0I91Pq8HgBXehB0uqoQYKuuorNt8On3rjYJonf7y64KspZTZAFgqboKvlgAQyTE6MKPtGrv9Fxow2VH9Q0tJ3roY2+2BrIa5e3n/L+gXjaSP5GnoyTiVDS1l6aMnKJm8fo1Y0sF1BoMmkW57A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Gv2gOpJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ac97eda56so540977a91.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266197; x=1747870997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRU0ZRfLQjg4VVDgrWE7a1sC3dOKBaDUonPKqBXfZi4=;
        b=0Gv2gOpJPpQAk4AzrJ/7XJAFcnJMsEPsie8bZF9fQzpwfUJc4L8dyq/RwUSF08BEg/
         sjqtYSRHBaLPNT/wK+6mtuLxpQ/gEXFiXwBYoM/QbDzLdVrPMjBzKdPBxuiQsb7eXvQn
         8BHUCOb2v9seDLHOZmERG4YbzDSS+tMZ2Dx+oVkaqtNHGdQY4x2XxOCDlasr4QNJVlc2
         /sH1Jz5COfNm58JtYrXqp1NGwnHVFW46HzSyghHBIUwOsfHw8WWYyr/qV6MemPsSMoRJ
         ZTsv62ECrG5JOProNxaN6x/U9M/QyPOHlTvW3VasklLm3UD7KoJ8p+wDWfWXfEJ83o5m
         TjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266197; x=1747870997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PRU0ZRfLQjg4VVDgrWE7a1sC3dOKBaDUonPKqBXfZi4=;
        b=el9fRFlUokN+im1+VVbhTTRK0ygpOuzpl5we7OlvXcrKj+icgWPJh0f8t4gX0jo21U
         EznA4a3Jjm2RCP1J9Pl+O3n1sRc0Gj29nve90abvctYLo3MHhqAQSnG0hX95K965/ldE
         Nk8AZIyBcc5qIvUpTfGBBeb+Edk7GznmyaEGSU+MB+kFfXzT1YXtbK/uSXjhqeDwO/Tb
         xao1IBKxXpeg2/aR58PWmWcaEpAmk2fv5YHA8saJ36RHHJt73ZibZy3naN7iLEXqirHH
         KqZROq+spmYXnbS0e9LuMZrshm/Xw2Oyz3Im5KgnoMwJh86uKQE/9ImTJfBhn0tEHNdU
         vTrQ==
X-Gm-Message-State: AOJu0YyWE3GjYa8RmnBpfP3jQMNorxfgmgiJdyZQqTu8mwmhtwzMhcgw
	vfdGWQpyaq9Cr9uII2P8jfWyWs5BPHB5jE95As2+0h6OhWSeAoJgLKwqhOurhJ243EFFGZB5/rk
	phyk15vOJxoHxf7om9LUDNQ/egpFSgZJJq02c2mahcOl8fJ93VVYDjdBBimsJiB0JH8Drx+JlU8
	hiUu1hUh0KpLb4aBB0ntZy0s3SSZ3i7HjfM/0Xet4tfWEA0dO+O0K3KNo=
X-Google-Smtp-Source: AGHT+IHb7GIqu695NGHdx8kULM1l9ge1FyZ0eSB2cW4x76FAmN4jqpBALaAAXGXP8pOhY4vxYo06cCKYxIVDFuivmw==
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:305:2d2a:dfaa])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:288b:b0:2ff:693a:7590 with SMTP id 98e67ed59e1d1-30e2e62ff9emr9683927a91.33.1747266197415;
 Wed, 14 May 2025 16:43:17 -0700 (PDT)
Date: Wed, 14 May 2025 16:41:52 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <c4d4dcd297dea1eeded3f0c195f4a9767fe9c120.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 13/51] KVM: selftests: Add script to exercise private_mem_conversions_test
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

Makes testing different combinations of private_mem_conversions_test
flags easier.

Change-Id: I7647e92524baf09eb97e09bdbd95ad57ada44f4b
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/private_mem_conversions_test.sh   | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100755 tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
new file mode 100755
index 000000000000..76efa81114d2
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
@@ -0,0 +1,82 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only */
+#
+# Wrapper script which runs different test setups of
+# private_mem_conversions_test.
+#
+# Copyright (C) 2024, Google LLC.
+
+set -e
+
+num_vcpus_to_test=4
+num_memslots_to_test=$num_vcpus_to_test
+
+get_default_hugepage_size_in_kB() {
+	grep "Hugepagesize:" /proc/meminfo | grep -o '[[:digit:]]\+'
+}
+
+# Required pages are based on the test setup (see computation for memfd_size) in
+# test_mem_conversions() in private_mem_migrate_tests.c)
+
+# These static requirements are set to the maximum required for
+# num_vcpus_to_test, over all the hugetlb-related tests
+required_num_2m_hugepages=$(( 1024 * num_vcpus_to_test ))
+required_num_1g_hugepages=$(( 2 * num_vcpus_to_test ))
+
+# The other hugetlb sizes are not supported on x86_64
+[ "$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages 2>/dev/null || echo 0)" \
+  -ge "$required_num_2m_hugepages" ] && hugepage_2mb_enabled=1
+[ "$(cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages 2>/dev/null || echo 0)" \
+  -ge "$required_num_1g_hugepages" ] && hugepage_1gb_enabled=1
+
+case $(get_default_hugepage_size_in_kB) in
+	2048)
+		hugepage_default_enabled=$hugepage_2mb_enabled
+		;;
+	1048576)
+		hugepage_default_enabled=$hugepage_1gb_enabled
+		;;
+	*)
+		hugepage_default_enabled=0
+		;;
+esac
+
+backing_src_types=( anonymous )
+backing_src_types+=( anonymous_thp )
+[ -n "$hugepage_default_enabled" ] && \
+	backing_src_types+=( anonymous_hugetlb ) || \
+	echo "skipping anonymous_hugetlb backing source type"
+[ -n "$hugepage_2mb_enabled" ] && \
+	backing_src_types+=( anonymous_hugetlb_2mb ) || \
+	echo "skipping anonymous_hugetlb_2mb backing source type"
+[ -n "$hugepage_1gb_enabled" ] && \
+	backing_src_types+=( anonymous_hugetlb_1gb ) || \
+	echo "skipping anonymous_hugetlb_1gb backing source type"
+backing_src_types+=( shmem )
+[ -n "$hugepage_default_enabled" ] && \
+	backing_src_types+=( shared_hugetlb ) || \
+	echo "skipping shared_hugetlb backing source type"
+
+set +e
+
+TEST_EXECUTABLE="$(dirname "$0")/private_mem_conversions_test"
+
+(
+	set -e
+
+	for src_type in "${backing_src_types[@]}"; do
+
+		set -x
+
+                $TEST_EXECUTABLE -s "$src_type" -n $num_vcpus_to_test
+		$TEST_EXECUTABLE -s "$src_type" -n $num_vcpus_to_test -m $num_memslots_to_test
+
+		{ set +x; } 2>/dev/null
+
+		echo
+
+	done
+)
+RET=$?
+
+exit $RET
-- 
2.49.0.1045.g170613ef41-goog


