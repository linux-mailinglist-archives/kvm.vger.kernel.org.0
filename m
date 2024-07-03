Return-Path: <kvm+bounces-20882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFAE924DB8
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 557401F269F2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5E7168B1;
	Wed,  3 Jul 2024 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eRGN0T/G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEF71426C;
	Wed,  3 Jul 2024 02:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972815; cv=none; b=MHVw9kdSbqCesg+F8Xze7cdc/rY4t7qfyVz2lw2XHLwJNVAqcZVWL1BQXvJsNwzQDjgxXvo7RqukFTIh3HD5n+3C+3bnmur4m3cMChvaDhP3OGN4uhORFlLtL+8T9c+uZxSknWZ3jl6KZYI0JOEaMA74TEIzzohxNhzLkIjcbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972815; c=relaxed/simple;
	bh=aI65XLqfvR7yKM7kV8fh7r8wiyY/a5ItqUizG+26xA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQhUH1E5yizD1uIJGBPhfSxBqXA8Xe3PnBNYatRx7H+jzJpQSd9xlzFHM/atrKyeQZDCVJoKy2ZntMn7J6qMfA4ZzT5N7O77UZZZj4ZRR3oZZVi24STLgCBz6vkmnXLhBH2Orl7wRcwN/USScXtTwIAZ7kkuY/yBWzYC/HbYI50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eRGN0T/G; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972814; x=1751508814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aI65XLqfvR7yKM7kV8fh7r8wiyY/a5ItqUizG+26xA4=;
  b=eRGN0T/GwOBXiF6VN+5wAIMU47yJafrlShJZAGi0JBx89kknVmzFB5LB
   at0/WVNnshzF3nke+XJWY3i82gWK6OobFJrni7sW4NNV44K16Oio/+byQ
   S4VX46+gkvhNU7sYdTxHuvNx+i0bEu2mko/J6zgCK/1EQNrtUGVrpjvj9
   Ii1IAUn6gnt57SShr5nSlZnhTDMBXgRvBW+MUYr1GREcrqZV3iATMe//a
   3JMCd6dwoeNL9hHb1i6r8vpJQDSS8DOvxVvsKzqg2op0C7vKfvLULtmvR
   P11G3ZC3yaipbdmnbtH2q8RC+6vcpYYTVOzsHI1OE0fg91B+8YkuSfhZT
   Q==;
X-CSE-ConnectionGUID: ermS6fmJS2iAItfLZ4fMWQ==
X-CSE-MsgGUID: fqnJ9wpWSf620QPRuMUt4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="20082387"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="20082387"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:33 -0700
X-CSE-ConnectionGUID: fsy3HKLbR2KoJKS8+eSdwA==
X-CSE-MsgGUID: XEJaAh17QC+B6FywrAK/jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="76832525"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:29 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 4/4] KVM: selftests: Test memslot move in memslot_perf_test with quirk disabled
Date: Wed,  3 Jul 2024 10:12:19 +0800
Message-ID: <20240703021219.13939-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240703020921.13855-1-yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new user option to memslot_perf_test to allow testing memslot move
with quirk KVM_X86_QUIRK_SLOT_ZAP_ALL disabled.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 579a64f97333..893366982f77 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -113,6 +113,7 @@ static_assert(ATOMIC_BOOL_LOCK_FREE == 2, "atomic bool is not lockless");
 static sem_t vcpu_ready;
 
 static bool map_unmap_verify;
+static bool disable_slot_zap_quirk;
 
 static bool verbose;
 #define pr_info_v(...)				\
@@ -578,6 +579,9 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 	uint32_t guest_page_size = data->vm->page_size;
 	uint64_t movesrcgpa, movetestgpa;
 
+	if (disable_slot_zap_quirk)
+		vm_enable_cap(data->vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
 
 	if (isactive) {
@@ -896,6 +900,7 @@ static void help(char *name, struct test_args *targs)
 	pr_info(" -h: print this help screen.\n");
 	pr_info(" -v: enable verbose mode (not for benchmarking).\n");
 	pr_info(" -d: enable extra debug checks.\n");
+	pr_info(" -q: Disable memslot zap quirk during memslot move.\n");
 	pr_info(" -s: specify memslot count cap (-1 means no cap; currently: %i)\n",
 		targs->nslots);
 	pr_info(" -f: specify the first test to run (currently: %i; max %zu)\n",
@@ -954,7 +959,7 @@ static bool parse_args(int argc, char *argv[],
 	uint32_t max_mem_slots;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hvds:f:e:l:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "hvdqs:f:e:l:r:")) != -1) {
 		switch (opt) {
 		case 'h':
 		default:
@@ -966,6 +971,11 @@ static bool parse_args(int argc, char *argv[],
 		case 'd':
 			map_unmap_verify = true;
 			break;
+		case 'q':
+			disable_slot_zap_quirk = true;
+			TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
+				     KVM_X86_QUIRK_SLOT_ZAP_ALL);
+			break;
 		case 's':
 			targs->nslots = atoi_paranoid(optarg);
 			if (targs->nslots <= 1 && targs->nslots != -1) {
-- 
2.43.2


