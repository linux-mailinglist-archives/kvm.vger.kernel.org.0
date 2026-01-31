Return-Path: <kvm+bounces-69757-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAh1Aa5GfWk/RQIAu9opvQ
	(envelope-from <kvm+bounces-69757-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 01:02:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 539CABF7AB
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 01:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57A0D302926B
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8707F1A5B84;
	Sat, 31 Jan 2026 00:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="u8IPBsSd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401EADDAB;
	Sat, 31 Jan 2026 00:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817757; cv=none; b=pCs/XicSeGGqb58c5zjyc9VJsmZswolLd0MB/GEB5Hi0iH07qoBDtbjMPofmRR3vFhnScqkwIgfj+Ms8FkBLW8Y/eWlQF2BUl0WTQRt4e0sLDlSUe2wBprObAnKwxI7ZMILzNYvfAS4IQdZib5KunTpj2226tbuwDsbwb73BRSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817757; c=relaxed/simple;
	bh=ROriuGZ2shqP/DISbG6aVAP27Yp+LZde6oERbMk2rt4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=NcLL6+NMXDuh1oGbBbNP1BR1Mb1zoekbjlpQI+uA/ViCkga79uSNv2XiLgfbZVxLkqPUDuvZrKUEKaaa0EyjmhBjYPZUqNH15QGf/wn7tekq++pNxTODb/wCL9lfwrBjbU6gtuI71JzpX62G7MNPiiOBHVNNkVeqwKlrpI8O+bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=u8IPBsSd; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKmhAr3625665;
	Fri, 30 Jan 2026 16:02:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=jRuuDNAg+bEi4XQKCi
	9JomUGnRgi2UhvYJe+qDFfrvQ=; b=u8IPBsSdGFq8Xbt4bZvQWi1KoVtxidkY9F
	a33KQeL//5pWhpk3RQ62yussb+g8NuCiI4K0NlNZy4cPYIXybrc7dx18HkB3vwy5
	33sudMwUBDq1UFnS/RkoQ0RvQSIBk7tH/rWxjpLLSGCgvA/m2OoSRRSlfWIrF3hW
	wr2VQd/bZa48buWee7AYBY+LQnHnFZV6eYXOgxk9nQDrnN6twLll4a6WExuniEDF
	5JjfK452yV1dZOuoqdDgXp3x9Qc2ASYz3HrJgxrGJusNLXc0zmfUGKgtOLGSgdPz
	7wjsQUlfziMdywWSbuyNcjdcc6wOBOA9AwEcxL55Q1QiIrAHu9MQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c140s9t68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 30 Jan 2026 16:02:29 -0800 (PST)
Received: from devvm6375.cco0.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sat, 31 Jan 2026 00:02:28 +0000
From: Ted Logan <tedlogan@fb.com>
Date: Fri, 30 Jan 2026 16:02:16 -0800
Subject: [PATCH] vfio: selftests: only build tests on arm64 and x86_64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com>
X-B4-Tracking: v=1; b=H4sIAIhGfWkC/x3MTQqEMAxA4atI1hNo6y9eZZiF1VQD0kpTyoh4d
 4vLb/HeBUKRSWCsLoiUWTj4Av2pYN4mvxLyUgxGmU7pWmF2HFBod4kkYfD7iV1jOWFjTKsHu5C
 deij5Ecnx/11/f/f9AG40UitqAAAA
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
        Shuah Khan <shuah@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>,
        Ted Logan
	<tedlogan@fb.com>
X-Mailer: b4 0.13.0
X-Authority-Analysis: v=2.4 cv=MYBhep/f c=1 sm=1 tr=0 ts=697d4695 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=FOH2dFAWAAAA:8 a=dWR254cKOyREI92bUGEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: T1QNM0hRWSmF5D7-kv-9kIBpMHFLr6aO
X-Proofpoint-GUID: T1QNM0hRWSmF5D7-kv-9kIBpMHFLr6aO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE5NyBTYWx0ZWRfX/XO5+IKmIu86
 Dk/C+M991Y8hT/SNpf4o+KdgWhZOTTBX3LDiF3VvHo6RA/VBcCxPhDfGezLvmPK9B6S6uTvA0sx
 Si8qugoyI6pPnHo9RGmR9skIEKbx+GxPcvrM55cO8yys+jCArHKBWGgvem2SGFo+0KVtCHbEprb
 WE0L/+lMr6/CW4DkOy1ZVvR7x0f48SSgvBobR91AUSOSbwYRy6WHdPRcJzUGh2cu3pjNi8WhWOT
 7F0eZCAgRbQA6zSzq+Ut1CajqH7mFmT9ZNg9pJdHFKeqZLYJ6/aYCAYby4crSbm/s5ikayvSIIC
 gMf5MbWOiRBlKSj3JovW3x1xaC14HS8wuGAehY54qDSRb/xZk0pkuEKwjzvnd3eJhbDUIMyzHjF
 TGWdxZc1Khenja8UEz3W8oycPDRmf+Wr8fj+H1CoxORowLzzLQ3798KOAjlXD/S6u4M2nrMaxD3
 JYOpPvv8ijZ/n4bLnwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_04,2026-01-30_04,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fb.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[fb.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[fb.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69757-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tedlogan@fb.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fb.com:email,fb.com:dkim,fb.com:mid,intel.com:email]
X-Rspamd-Queue-Id: 539CABF7AB
X-Rspamd-Action: no action

Only build vfio self-tests on arm64 and x86_64; these are the only
architectures where the vfio self-tests are run. Addresses compiler
warnings for format and conversions on i386.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@intel.com/
Signed-off-by: Ted Logan <tedlogan@fb.com>
---
Do not build vfio self-tests for 32-bit architectures, where they're
untested and unmaintained. Only build these tests for arm64 and x86_64,
where they're regularly tested.

Compiler warning fixed by patch:

   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:6:
   tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:49:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      49 |         VFIO_ASSERT_EQ(__iommu_unmap(iommu, region, NULL), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
---
 tools/testing/selftests/vfio/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index ead27892ab65..eeb63ea2b4da 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,3 +1,10 @@
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+
+ifeq (,$(filter $(ARCH),arm64 x86_64))
+nothing:
+.PHONY: all clean run_tests install
+.SILENT:
+else
 CFLAGS = $(KHDR_INCLUDES)
 TEST_GEN_PROGS += vfio_dma_mapping_test
 TEST_GEN_PROGS += vfio_dma_mapping_mmio_test
@@ -28,3 +35,4 @@ TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
+endif

---
base-commit: c3cbc276c2a33b04fc78a86cdb2ddce094cb3614
change-id: 20260130-vfio-selftest-only-64bit-422518bdeba7

Best regards,
-- 
Ted Logan <tedlogan@fb.com>


