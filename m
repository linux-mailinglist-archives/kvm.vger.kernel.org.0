Return-Path: <kvm+bounces-69964-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBIsO99OgWlMFgMAu9opvQ
	(envelope-from <kvm+bounces-69964-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 02:26:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF6AD35E8
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 02:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24E13305583C
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 01:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A97822D4DC;
	Tue,  3 Feb 2026 01:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="WXlwHa6B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9A3B1BD;
	Tue,  3 Feb 2026 01:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770081859; cv=none; b=tWJBfQ07lEwxHvIA05iKYqGHWZJbdsOqHwEudKfk6DT55gvTG6WuSy0eXGXf/BWov748/hCSJ0s3f9zA1fyHd/VnMiNA5Q2WiTRQcJR/uyTA2bM39Ud6g+j1pBygfZLhw9yZyDtdQETIld61Z7TsiVRFp0yHs/edQxGqLa/+c1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770081859; c=relaxed/simple;
	bh=h+6I+BL4iHOXIFHjt9HIZpkeu7KhFs4lJ7XJ+EUajCA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=Mwuj89lnd5Obj3eKRv5eR6L2fbZ5s3gpvVkadx9j1tvc6T4Cj9TzEhRCxvbONJD8hAIQ8jGEhc4NASEMQyux3WztZilFI+PcsAq8teciGz72SH6jqQur2Wgh04Q6t4CxTUiXKCyleRlUkSIPGl5ClbaFf5tfeG/xAYx8sKJeVVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=WXlwHa6B; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6130c1Il791433;
	Mon, 2 Feb 2026 17:24:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=s25T3k7r0JOjMjHsLR
	MlMb86LHiB76Nx3BRCScyA5Q0=; b=WXlwHa6BCiuvqGyjKC57K0I/cVdXYEqfc5
	SxC409eY53wKo3daVvPhx7purcOzoawcDUGfEAXNY1XtqJWtZx6Za1qyXHRNQxjR
	6WiBURao49BxfvwPku7KmOutUhATPhVrirsO0R4zwGwFLBdYJa0/L/lD6GiU5rdF
	Xss1+NE+KfPrZ51VNlGNwD8R1gKCmGcrFhImKMROtKrqHF0nz6pMqq+8e35N8DnA
	BCCbqz92O7in8ba2dzhCh4IG45WRuEZM+cSwLOFgJRMK4xna7Dqoak/fDuL9Q1JE
	NRIpi4F11yQs9hLYlfNgngxExKOYoju3Med2prXX1li0Z46kvqzQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c36n2gcrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 02 Feb 2026 17:24:10 -0800 (PST)
Received: from devvm6375.cco0.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Tue, 3 Feb 2026 01:24:10 +0000
From: Ted Logan <tedlogan@fb.com>
Date: Mon, 2 Feb 2026 17:23:53 -0800
Subject: [PATCH v2] vfio: selftests: only build tests on arm64 and x86_64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260202-vfio-selftest-only-64bit-v2-1-9c3ebb37f0f4@fb.com>
X-B4-Tracking: v=1; b=H4sIAClOgWkC/42NQQ6CMBBFr0Jm7Zi2VgRX3sOwoGUqkyAlbdNIC
 He3cgKX7yX//Q0iBaYI92qDQJkj+7mAOlVgx35+EfJQGJRQtZAXgdmxx0iTSxQT+nlasdaGE2q
 lrrIxA5n+BmW+BHL8OdLPrvDIMfmwHk9Z/uwf0SxR4tC0vRWt1lbIhzNn69/Q7fv+BcYqSW+9A
 AAA
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
        Shuah Khan <shuah@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>,
        Ted Logan
	<tedlogan@fb.com>
X-Mailer: b4 0.13.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDAwOCBTYWx0ZWRfX4TIj+Yu2tXA5
 Nv6dYxkv0I35+Hg4G98OAeAlfXKyR6o3ayisqg4w/cjD12xVmLrIaD9MmZWt49CUnjE5YDWtI+I
 sl/RFht41d80r46b8GHSoD9i43bs5f4rsH06bvOFRcJqNaQjDGnEndmQpOO40S7Bta5TXzpenoY
 dMe6YpSv3NdeUP3PyE03ONV68H2xJmSCGi34D84uLEAUNlvl8LT327JaKPOB9pu30rv1u29Vsyo
 xou+Cg1QUdLYdvEb3vXcLNkRRxs1A+H6i3vn5TdG6QE7o40ADajb34GmlUwsme9q3mzi6ItG6In
 v8iGV0ABA1iex/oNQ1SMvetxKzsMzPWqbpOl3K58IWVI/pvj+/IbIDS3b+OQiMIJ8dj8Lt8p2k4
 WtE9bqrxse8BnAzLr1Qf+Ewn2J96f/UXTCDfMvLj7njhB/m3LzL4IziZ+E5Qy9/NJrw/y4LTl11
 MJFrYtolarZih8k2Jmw==
X-Proofpoint-ORIG-GUID: CBxq1KeonE8ZAXep-AKoNOM9VZeuS8zc
X-Proofpoint-GUID: CBxq1KeonE8ZAXep-AKoNOM9VZeuS8zc
X-Authority-Analysis: v=2.4 cv=IM0PywvG c=1 sm=1 tr=0 ts=69814e3a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=FOH2dFAWAAAA:8 a=bS1NuYFVCXJi6kBHAy0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
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
	TAGGED_FROM(0.00)[bounces-69964-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fb.com:email,fb.com:dkim,fb.com:mid]
X-Rspamd-Queue-Id: 4EF6AD35E8
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
Changes in v2:
- Add white space around arch checks
- Clean up uname command
- Link to v1: https://lore.kernel.org/r/20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com
---
 tools/testing/selftests/vfio/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index ead27892ab65..8e90e409e91d 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,3 +1,10 @@
+ARCH ?= $(shell uname -m)
+
+ifeq (,$(filter $(ARCH),arm64 x86_64))
+# Do nothing on unsupported architectures
+include ../lib.mk
+else
+
 CFLAGS = $(KHDR_INCLUDES)
 TEST_GEN_PROGS += vfio_dma_mapping_test
 TEST_GEN_PROGS += vfio_dma_mapping_mmio_test
@@ -28,3 +35,5 @@ TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
+
+endif

---
base-commit: c3cbc276c2a33b04fc78a86cdb2ddce094cb3614
change-id: 20260130-vfio-selftest-only-64bit-422518bdeba7

Best regards,
-- 
Ted Logan <tedlogan@fb.com>


