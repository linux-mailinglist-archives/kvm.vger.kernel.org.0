Return-Path: <kvm+bounces-19545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E35BF9063D6
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83DEE1F230F7
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BFA136E3F;
	Thu, 13 Jun 2024 06:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDlgTTuq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06648136E2A;
	Thu, 13 Jun 2024 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718259112; cv=none; b=d2RTaAPF9gFm/+Ej7BDZ/OLGyVobFxPl6NrkDPX5NCV5yTttCSB4UVplHt/uBGCuiRiZJJf3qcp8N28LoOeymydPy4xspcO1qf20ORyYWTAvQi1695AdBqGLlfuW0tON/QtmgulcIHZtJCI5GO9WyZCwYHuYkP5s3wAgoE8y4Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718259112; c=relaxed/simple;
	bh=aI65XLqfvR7yKM7kV8fh7r8wiyY/a5ItqUizG+26xA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4gJXqzA2ERZAMRcOnL3qknYbMPA19NQ+mMPo+k5ItIkgwiWWuhZKqLOhEwg8VHIb0kKFYcS8b8dubSYtLhlnQb7pipore0Ue2amiwlqK/nXfwQrM0rK7N4P43gKxIQCiGm8o9ynofn37w9oYRzZJi0MN+Qptxi5+qZcTnigdRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDlgTTuq; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718259111; x=1749795111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aI65XLqfvR7yKM7kV8fh7r8wiyY/a5ItqUizG+26xA4=;
  b=DDlgTTuqqZFkosuanbg8GHKFR2fLzb6LS/evNbeN3akC0LiS4pulubzn
   dz1BhNwGBR7qztwyuNkr1oEbdnwPanyZuMPc0HH5nasN+PT/0/IFt1zY1
   mOknu4ZGqRzCggDvVQrscIJQ4Evdj6zaSGST4ELkZAupPWidYLgfdWLCw
   bD2qt4jPeflRtDigv4VcRd6j5CDKiWKvwqhsctKgc4KaK3tMdSKt+d6er
   Nom+pj5HDtfznCDoqdAEfkZuoVUTxVFZ81ynVhZcK3JHC+ujwltexewFW
   L4N5uvXlkzosO8vmDazaMaR2tmTX+WZjuJ9krFasjEtirBWPd8Z+9GyNZ
   Q==;
X-CSE-ConnectionGUID: xTAjIchzRyek/wqg+SdSfA==
X-CSE-MsgGUID: RFZB+KN+TXqfWIvrLMJ1Qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="25734247"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="25734247"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:11:50 -0700
X-CSE-ConnectionGUID: mrFLflcqQZCc0+W/0STbVg==
X-CSE-MsgGUID: 6xu47AzdQh+cjWAL95oB/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="40669150"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:11:47 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 4/5] KVM: selftests: Test memslot move in memslot_perf_test with quirk disabled
Date: Thu, 13 Jun 2024 14:10:49 +0800
Message-ID: <20240613061049.11863-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240613060708.11761-1-yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
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


