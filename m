Return-Path: <kvm+bounces-69403-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLHBOONXeml55QEAu9opvQ
	(envelope-from <kvm+bounces-69403-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:39:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 732F8A7D2B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 157E03039895
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1D4371077;
	Wed, 28 Jan 2026 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="4ZdcnbWS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8254E371047
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625517; cv=none; b=U0R1BmwhlUt+Q0efNOJWtN3TbDfQHpRgnLcrnTrkumFq9WemME18DgPAv7mFKNjpq9CfB7rPaMbvfGRzZXLlvxrrckie/lSQNedZS7cFGkWE0pIdDk5AQM+gWu/3jEpxjJfsppf9FvpV+yY9wjXsCTdyAQ03SazFK5D7OaAmRkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625517; c=relaxed/simple;
	bh=wdPj+AEsKkXKm1fsdKDxQKjF1X8lRnqgiXjzhdF+tso=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tCFl/umN5Fp/FbLMIh5wMQp+SN5g2phsow7CtGLGYH24WCkYEWPZAybRKXodFtYvj+s768UuYtiwx+4aNGjjRcKSmWtjK3hT+ZccQEUGbzYY5fMt7l8uv3Krd0rFdy3sA89+ReMIP0IuQvIgxMy03M9sFZmxprmxZdVlhmyHsps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=4ZdcnbWS; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60SI39Qk956042
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 10:38:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=XfrX8mUNuR0msXgMd+
	bRYSXgi24oqYnW4pxhyRlD0I8=; b=4ZdcnbWS1dZ+kSO1geYx2xCLp5xFHKy+n0
	hg/B2Ajdjjcy45PCWMkLWCqeYUCxTQg0rclVd/0KRuNxdKbr9epfzaI6hAFA6e4i
	uC1kFo0UQgZLoT5IDEvPBaPoIe8cGG9+9T419YDO32sTuJPAb+Jjx51or+7sLA0H
	cU5KybFTqIs+/BLKVmiiXLsDwgCNk/+hTMMhYsGJJV6oDOOlLBk+0CY8V4BrcV1R
	r1G4Z9h4wpD/XSbPC5pONaShaeRPMNePnJZYnbP2VC2NTY7fXJ2gvUZHHSlw7Nmm
	tmtqrAbjQh0t9qLtb9vRetPwiFrJT8JbA6o+geDyaIURueUeDdrQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4byqd60ee7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 10:38:33 -0800 (PST)
Received: from twshared22445.03.snb1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 28 Jan 2026 18:38:32 +0000
Received: by devvm6375.cco0.facebook.com (Postfix, from userid 721855)
	id AA073B4F157; Wed, 28 Jan 2026 10:38:25 -0800 (PST)
From: Ted Logan <tedlogan@fb.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
        Shuah Khan <shuah@kernel.org>
CC: Raghavendra Rao Ananta <rananta@google.com>, Alex Mastro <amastro@fb.com>,
        Ted Logan <tedlogan@fb.com>, <kvm@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        kernel
 test robot <lkp@intel.com>
Subject: [PATCH] vfio: selftests: fix format conversion compiler warning
Date: Wed, 28 Jan 2026 10:37:50 -0800
Message-ID: <20260128183750.1240176-1-tedlogan@fb.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDE1NCBTYWx0ZWRfX/tPYmix8XWBQ
 gHokelvOTSs61UZSyodMueayR6iFQLNQuvTDibjJ3Hz6+tluuMltaS5TrZsyZ4E/hqVreUTopIt
 e+6HKXlGSuXluGOxgzoeIsq9GC5/m/M5JYGI6ghbvAKwB2ru3qw649q3QPZ1laQl7fbs1F4r9xZ
 t4OUNvUmOTg/E+hocvx7EKJdqEs63/ibok/BRVOa5PX+uZa+lLJXu8arxEyuCoCvZwcXtBot2RX
 RWyN3ptj5V50DTbzrcJyTI8xXsC4Y+xFNex6wYHCttr6mTvumUiNKJr4/ELFzV4/+M8ZMyJWe0l
 hSD1q4DrRSx32DJjibpHDv+8R7lYIa3OSoeewTOv92FQNesCcPY5igc1Bstzf+3LWQeZzWCSa35
 6KVg9TdM6LTZzt+T3JtMQKyglrf3cj7cgjeLUetdqU2W6uHnqPxa1Q7QD1iq6tO7BCO6X0si1wA
 139eKQlaSF1i7y166VQ==
X-Authority-Analysis: v=2.4 cv=caHfb3DM c=1 sm=1 tr=0 ts=697a57a9 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=FOH2dFAWAAAA:8 a=dWR254cKOyREI92bUGEA:9
X-Proofpoint-ORIG-GUID: RpW5_eyJ4cM_uRM-mcfrjtnitlg3rlZw
X-Proofpoint-GUID: RpW5_eyJ4cM_uRM-mcfrjtnitlg3rlZw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_04,2026-01-28_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[fb.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[fb.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69403-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,fb.com:email,fb.com:dkim,fb.com:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tedlogan@fb.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[fb.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 732F8A7D2B
X-Rspamd-Action: no action

Use the standard format conversion macro PRIx64 to generate the
appropriate format conversion for 64-bit integers. Fixes a compiler
warning with -Wformat on i386.

Signed-off-by: Ted Logan <tedlogan@fb.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@i=
ntel.com/

---
Compiler warning fixed by patch:

   In file included from tools/testing/selftests/vfio/lib/include/libvfio=
.h:6:
   tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:49:2: warning=
: format specifies type 'unsigned long' but the argument has type 'u64' (=
aka 'unsigned long long') [-Wformat]
      49 |         VFIO_ASSERT_EQ(__iommu_unmap(iommu, region, NULL), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note:=
 expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, =3D=
=3D, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note:=
 expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",         =
                  \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);        =
                  \
         |                                           ^~~~~~~~~~

---
 tools/testing/selftests/vfio/lib/include/libvfio/assert.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/=
tools/testing/selftests/vfio/lib/include/libvfio/assert.h
index f4ebd122d9b6..a2d610e22acd 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
@@ -2,6 +2,7 @@
 #ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H
 #define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H
=20
+#include <inttypes.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/ioctl.h>
@@ -23,7 +24,7 @@
 										\
 	fprintf(stderr, "%s:%u: Assertion Failure\n\n", __FILE__, __LINE__);	\
 	fprintf(stderr, "  Expression: " #_lhs " " #_op " " #_rhs "\n");	\
-	fprintf(stderr, "  Observed: %#lx %s %#lx\n",				\
+	fprintf(stderr, "  Observed: %#" PRIx64 " %s %#" PRIx64 "\n",		\
 			(u64)__lhs, #_op, (u64)__rhs);				\
 	fprintf(stderr, "  [errno: %d - %s]\n", errno, strerror(errno));	\
 	VFIO_LOG_AND_EXIT(__VA_ARGS__);						\
--=20
2.47.3


