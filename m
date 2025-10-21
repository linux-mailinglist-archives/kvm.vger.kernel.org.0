Return-Path: <kvm+bounces-60620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7EEBF514F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6032A3A8B2E
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593062BE655;
	Tue, 21 Oct 2025 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z9hVZa9A"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73429405
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032928; cv=none; b=qDRDfmbP1/F88Py19pFANJ2uJ51OallnWsAivE642VhziRMuCK0VUVSXHzH9cdJWj9EgkvvC+NRn+dMumbTgwjWuzPeLNsI4yiljtplJEd/A5H+lSBM3Yz7InTX4LdkqitazHYBzJ84tQ6K59GS8RVJhAoroEuhJNCuL7A7ZCgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032928; c=relaxed/simple;
	bh=b1bunJvRMwHVDZOsTzIFfalAs34FSJTHmxHtOoMRcyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ve3w7/j7O2+9M4dua8Xb61z9ttL79mOYwL3j9I1wDFAD4JkLyFAUvWoMfXikxMVY9bvBax+e8OeAKSns1I1faNdM5T1w2qNtmc1cpVdIM6mvETZ6o968pYTISfYfDKp2AdFOWdyCXn88Y/uHeghtp+jxMUFq0Js401J41qZmsFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z9hVZa9A; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+HGmEgjIusKwLuq4N4ktk6GF6BiFVs5iCdCBOce2dE=;
	b=Z9hVZa9ASBWP6zxAjwDcGhvEBiB5+aNiB2eqDPWPXp0dMMXWU2znE+k3JeD0Z7YJCvBI8k
	QCuywtfpBBRk2puijp01KLjhzcv2aQ7lbmmREGm2PnMt+s/3kbVmefPAK1FcQZY8ECxv3j
	NWsboke81jrfv57Fi9cVsvSDdaDXHMc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 10/23] KVM: selftests: Stop using __virt_pg_map() directly in tests
Date: Tue, 21 Oct 2025 07:47:23 +0000
Message-ID: <20251021074736.1324328-11-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace __virt_pg_map() calls in tests by high-level equivalent
functions, removing some loops in the process.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/mmu_stress_test.c      | 6 ++----
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 6a437d2be9fa4..21c0f8e6552cd 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -361,11 +361,9 @@ int main(int argc, char *argv[])
 
 #ifdef __x86_64__
 		/* Identity map memory in the guest using 1gb pages. */
-		for (i = 0; i < slot_size; i += SZ_1G)
-			__virt_pg_map(vm, gpa + i, gpa + i, PG_LEVEL_1G);
+		virt_map_level(vm, gpa, gpa, slot_size, PG_LEVEL_1G);
 #else
-		for (i = 0; i < slot_size; i += vm->page_size)
-			virt_pg_map(vm, gpa + i, gpa + i);
+		virt_map(vm, gpa, gpa, slot_size >> vm->page_shift);
 #endif
 	}
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index 077cd0ec3040e..a3b7ce1559812 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -621,7 +621,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < NTEST_PAGES; i++) {
 		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
 		gpa = addr_hva2gpa(vm, pte);
-		__virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK, PG_LEVEL_4K);
+		virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK);
 		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
 	}
 
-- 
2.51.0.869.ge66316f041-goog


