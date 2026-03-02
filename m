Return-Path: <kvm+bounces-72351-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIIeEGxUpWnR9AUAu9opvQ
	(envelope-from <kvm+bounces-72351-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 10:12:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D56901D558F
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 10:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C0D030642C8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 09:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47D7385500;
	Mon,  2 Mar 2026 09:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJXZT90X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B138CFFD;
	Mon,  2 Mar 2026 09:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772442474; cv=none; b=f83ddYe32DKZ3tQD6b9o5Hk5IkQ5hU22WvI3gmr2M71gOdSc53vk7KvcSuC1v+Kd+vl5nhtJIkAr7c5mZ/4MCFnC6pvR3G/cyzdqMj/DMbmXFwi0rfhcYnXYebwfbDjfIF4wLoKNIu0wx/oWAPpUUi+QK5P7MAo2Fi5WeCm7bm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772442474; c=relaxed/simple;
	bh=RrNvne41GkESDMIdLFaFc2z9SiWAsQLvTma2o3qaeA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KR295580PZdapvI7liHvTLAEvhuybjDQtTGL8H28VU7XhI/gJs57y4sviEe2Itb6pkG+W0Gvb8hw7+5AcHyaCWl5FkZcmNTZ2Ntr/WhxlgGAcYHcxzR6kutEQMIzrtNTXMngBnQPUHRLlQch65/pDiX+YFfivbZnAu8Ip4clWAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RJXZT90X; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772442473; x=1803978473;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RrNvne41GkESDMIdLFaFc2z9SiWAsQLvTma2o3qaeA8=;
  b=RJXZT90XTc/HjSXa+nvoIf+PmN1y3RcpRj98KU8/4s6SRFmHz3ujB5pZ
   bEX8VXHxBATnke+zwIzry9VNYBOvgcMrttmp0p0cBFmtyiCieTw98mElG
   Bnv4rCZqJGGF4mfclwXTKf46onKLW1zsi50RpMa/71pHVM0JJ/XeD9i/x
   srviMzqCmEjNgfWCqzB7Lfx0r7nKjXZmwJj9K73FiVCnnFSvTykggXTz5
   Qr5FbGWbvhIhXgrmmauOl5cd0kLSihW69UpOOHFHFrDUfPa0a4DF5Dvcg
   NphUqUkjnPVasBiOYOsSBQDm/PXGecoHyk8vRiSI7oEx68QL4Sy/GVuI+
   Q==;
X-CSE-ConnectionGUID: wT2MvpicSTSetF8ScqqC3Q==
X-CSE-MsgGUID: kQ3WADQ6SxGlrM35VIQSPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11716"; a="72645786"
X-IronPort-AV: E=Sophos;i="6.21,319,1763452800"; 
   d="scan'208";a="72645786"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 01:07:52 -0800
X-CSE-ConnectionGUID: 4TMUvlNUTmedC+msUFah9A==
X-CSE-MsgGUID: 0zTg/96CQPqeuAf+UHFtPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,319,1763452800"; 
   d="scan'208";a="240610170"
Received: from khuang2-desk.gar.corp.intel.com ([10.124.220.16])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 01:07:49 -0800
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: shuah@kernel.org,
	shivankg@amd.com,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: selftests: Increase 'maxnode' for guest_memfd tests
Date: Mon,  2 Mar 2026 22:07:39 +1300
Message-ID: <20260302090739.464786-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72351-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D56901D558F
X-Rspamd-Action: no action

Increase 'maxnode' when using 'get_mempolicy' syscall in guest_memfd
mmap and NUMA policy tests to fix a failure on one Intel GNR platform.

On a CXL-capable platform, the memory affinity of CXL memory regions may
not be covered by the SRAT.  Since each CXL memory region is enumerated
via a CFMWS table, at early boot the kernel parses all CFMWS tables to
detect all CXL memory regions and assigns a 'faked' NUMA node for each
of them, starting from the highest NUMA node ID enumerated via the SRAT.

This increases the 'nr_node_ids'.  E.g., on the aforementioned Intel GNR
platform which has 4 NUMA nodes and 18 CFMWS tables, it increases to 22.

This results in the 'get_mempolicy' syscall failure on that platform,
because currently 'maxnode' is hard-coded to 8 but the 'get_mempolicy'
syscall requires the 'maxnode' to be not smaller than the 'nr_node_ids'.

Increase the 'maxnode' to the number of bits of 'unsigned long' (i.e.,
64 on 64-bit systems) to fix this.  Note the 'nodemask' is 'unsigned
long', so it makes sense to set 'maxnode' to bits of 'unsigned long'
anyway.

This may not cover all systems.  Perhaps a better way is to always set
the 'nodemask' and 'maxnode' based on the actual maximum NUMA node ID on
the system, but for now just do the simple way.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90..b434612bc3ec 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -80,7 +80,7 @@ static void test_mbind(int fd, size_t total_size)
 {
 	const unsigned long nodemask_0 = 1; /* nid: 0 */
 	unsigned long nodemask = 0;
-	unsigned long maxnode = 8;
+	unsigned long maxnode = sizeof(nodemask) * 8;
 	int policy;
 	char *mem;
 	int ret;

base-commit: a91cc48246605af9aeef1edd32232976d74d9502
-- 
2.53.0


