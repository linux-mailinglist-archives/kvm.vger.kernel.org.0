Return-Path: <kvm+bounces-72414-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIDWIj8GpmlVJAAAu9opvQ
	(envelope-from <kvm+bounces-72414-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:50:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A5A1E4269
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7C7503185A69
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4F7391840;
	Mon,  2 Mar 2026 20:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COztYI7P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6158E390CAD;
	Mon,  2 Mar 2026 20:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484733; cv=none; b=UAb282wwWbyqyHcJsceUFmzJj9uwvcLEiHgR4LtQJLH0AtL/3/U7K/r6+luTaw3+J4TSYA6eMMv1CSaQCFxxDxEQYyJ+QMTWwuxEVBJk4Ity6pCpyxWSBxVGq1coeLV8XbPdl+mgLBCpFylbqzgRuKeWTLjEhriBhHLuBwd00Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484733; c=relaxed/simple;
	bh=5nkwyikcQXaXCi1A+f+dmyTarjj6BA0S0U62XmKtJ4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FN8iO18pIoENpAjlbpxdOMew5CxnIJtKXec1Liuaok7Ra+GDPn1M2xF0UA47z1Hhr7RC3iiK6dHFS8foLlrS6fjl7uX86IUbnOyioYG64llHmkGtkEVjwT9XkbV/9sgXGCrxlVyajBrzmLQP/z6CLGenu67KVCOPs8Qf7mkOI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COztYI7P; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772484732; x=1804020732;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5nkwyikcQXaXCi1A+f+dmyTarjj6BA0S0U62XmKtJ4E=;
  b=COztYI7POV4QYp040egfBAQLbUfY5xlj2c0Xae4NoYDB3Ckk7y3f2zCb
   USJmX669TifxdRg9sFdIgDFeuSfw91VoYBLic/j8Dozp+kgzsEon7wxS6
   BO0KANdo/YejKMStfXYF43iUp5dXzEAQgL3L4+Ne1MgGxkkygAsVB+w31
   2FKU/XHAVJ0mv3gyfbHrqfa0TDXlLuIkUgMrOmaba5IL+U4HuIoGLgLRH
   /ijS1phXO6v3zVl8WW6fwC6ZjTU2U9m2Ed8pSWw8I3YeLubCpYUvrtXTp
   7ahbg1vEzcaRcwT/EqTMI/n5ogK5JLw416Kh3C+u7LBWLxFt0OGHJSlNS
   w==;
X-CSE-ConnectionGUID: meSyS91PTzqg25b/nVnIVQ==
X-CSE-MsgGUID: mbbNM7quRWWWA7V8+TuLtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="77118637"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="77118637"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 12:52:11 -0800
X-CSE-ConnectionGUID: yS909TLyRH6Khi9IYa8F1Q==
X-CSE-MsgGUID: oR4mSGNHRmGeJzvcaF6jRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="221932550"
Received: from khuang2-desk.gar.corp.intel.com ([10.124.220.2])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 12:52:08 -0800
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: shuah@kernel.org,
	shivankg@amd.com,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [PATCH v2] KVM: selftests: Increase 'maxnode' for guest_memfd tests
Date: Tue,  3 Mar 2026 09:51:58 +1300
Message-ID: <20260302205158.178058-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25A5A1E4269
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72414-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
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

Increase the 'maxnode' to the number of bits of 'nodemask', which is
'unsigned long', to fix this.

This may not cover all systems.  Perhaps a better way is to always set
the 'nodemask' and 'maxnode' based on the actual maximum NUMA node ID on
the system, but for now just do the simple way.

Reported-by: Yi Lai <yi1.lai@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221014
Closes: https://lore.kernel.org/all/bug-221014-28872@https.bugzilla.kernel.org%2F
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v1 -> v2:
 - Add 'Reported-by' and 'Closes" tags.  - Sean
 - Use BITS_PER_TYPE().  - Sean
 - Slightly simplify changelog to simply say "increase 'maxnode' to bits
   of 'nodemask'" to reflect the code better.

---
 tools/testing/selftests/kvm/guest_memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90..cc329b57ce2e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -80,7 +80,7 @@ static void test_mbind(int fd, size_t total_size)
 {
 	const unsigned long nodemask_0 = 1; /* nid: 0 */
 	unsigned long nodemask = 0;
-	unsigned long maxnode = 8;
+	unsigned long maxnode = BITS_PER_TYPE(nodemask);
 	int policy;
 	char *mem;
 	int ret;

base-commit: a91cc48246605af9aeef1edd32232976d74d9502
-- 
2.53.0


