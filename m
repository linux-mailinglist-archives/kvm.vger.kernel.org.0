Return-Path: <kvm+bounces-53160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D629B0E13B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 18:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 132D01707DF
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F24237717;
	Tue, 22 Jul 2025 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HX0NggyI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35F61DE2B5;
	Tue, 22 Jul 2025 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753200329; cv=none; b=AqXgbmFc8mKsFrIstNnJRX6d6Kenrp9eVBzuJskF4P1w/jb56o5w6w6EpoW7v0Ftrn0LIuU5vJle1xVmPOv4V7MlfcXABOWayrt+XVDpxtPOToiQBK4WGbLahHERyi+5KMYj1gawbc3GuXU7gYpD4s2oI7TG67saU/jqRCqLB+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753200329; c=relaxed/simple;
	bh=IDAReUlRfn62n+BVcBsyf+oTuWIAfJOOv2SOIpoXlHs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IOd2/Po0mGJFax1DFbYZF1FP6u8B8+wBul/djPYLRIQOM/4A9uTtaGovbsa1pwddVtNjE6DsFYh6VVxmr3v78+XTDSqXKd1QVnskuDPNsTeUkpfZz/N56TcACPE+qZTywGtSEQKW1jSejLlo2bE6RrxHD1XUd4pNK5RhKtIXUbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HX0NggyI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MDdMNB013243;
	Tue, 22 Jul 2025 16:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=tEr1bNdXwCNYItpDv36zqKYrjNEC
	jTMDFSzBOQTt5lo=; b=HX0NggyIgdObJYX6yVsKGusQnbzSxnYqVc+nSmWyaoVJ
	MVmyxSUVYwgqiWf5rmXtlFiHbe8nhgbZ+bv2d3g637QOYme71xdsIu0sNgmirgcq
	ojm+YHsUYmnAg9sYpic7bRWgrBK2n4LWTo3hsNezSDzaCT99e1zqNzXh1suPIcKd
	65B1nua7cxeIZLf2UYoQItjV9Rs0MhPbiFRwe+xLkuCHvqS8Ya1ar230WeHLcCYt
	JlUB1UYuT19RWKu57MvOGmbfj7++MHfKqcdaH+VfkD56KVl5REFKWlQJAQfJkXeU
	kFp9vYuyFstFmEMtO26Y9IPYbrm/QcqGe0VJ4riQRA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 482bqeh5pr-40
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 16:05:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFAHsM005747;
	Tue, 22 Jul 2025 15:54:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 480tvqtqvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 15:54:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56MFsCcp55443774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 15:54:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AB6C2004B;
	Tue, 22 Jul 2025 15:54:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18DEC20043;
	Tue, 22 Jul 2025 15:54:12 +0000 (GMT)
Received: from a46lp62.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Jul 2025 15:54:12 +0000 (GMT)
From: Michael Mueller <mimu@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Michael Mueller <mimu@linux.ibm.com>, linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC PATCH] KVM: s390: selftests: work around macro is_signed_type re-definiton
Date: Tue, 22 Jul 2025 17:53:55 +0200
Message-ID: <20250722155358.111810-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=c+2rQQ9l c=1 sm=1 tr=0 ts=687fb6c4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=qEpN5gnUneW78kiv9LgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: m8QDGNiy19ydczB4IgTPo1mwsRza3AH6
X-Proofpoint-ORIG-GUID: m8QDGNiy19ydczB4IgTPo1mwsRza3AH6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDEzMSBTYWx0ZWRfX1EYDLowSiDCH
 odrmX+ytO1Yp3lLTJgd2Xz0RlKg1SOXEYQgVunwBlg6MNPIgkKDjfUFrGZewI+RDPRuKsOg/3ge
 sYFS5ObVR1o6a/udXFW13o6zzUSucdXoJ6h4C8Qi8nDX1kFnorOpa2q8fEv+b7xDhfhPDNVcO3N
 oyEs0ooSbtoVrSqJVoe3gefb5zoNzdkbM4wc/CTOH+UE51P0CpevymSf54Yj0I1O0P3Vj6BbTsk
 NuFYe7xl54/KDXOuOHxtMgZUX91QyMEROOEJJuARtscR7+2OugmMlwXspkxPhUKBohn2/vG8UU+
 kqzgiIexF1KHs+4EMsBZzRnHJY93SNUrkd4O4Wq0BtDQDI4XaO1URfF/4keAqeLj42bO+jgqgiM
 bWWQKaST+Fr+KGSi1E+1UtJpaGYYKZ7f4nXNWNzRYsS/0Licdo2kHV9Z9u2mPBd7ogf296mB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=830 suspectscore=0 adultscore=0
 bulkscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220131

The following commit creates a pre-processor warning during the KVM
selftest build as it leads to a re-definition of macro is_signed_type().

  commit fc92099902fb ("tools headers: Synchronize linux/bits.h with the kernel sources")

  $ make -C tools/testing/selftests TARGETS="kvm" all >/dev/null
  In file included from s390/ucontrol_test.c:11:
  ../kselftest_harness.h:754:9: warning: ‘is_signed_type’ redefined
    754 | #define is_signed_type(var)       (!!(((__typeof__(var))(-1)) < (__typeof__(var))1))
        |         ^~~~~~~~~~~~~~
  In file included from ./linux/tools/testing/selftests/../../../tools/include/linux/bits.h:34,
                   from ./linux/tools/testing/selftests/../../../tools/include/linux/bitops.h:14,
                   from ./linux/tools/testing/selftests/../../../tools/include/linux/hashtable.h:13,
                   from include/kvm_util.h:11,
                   from include/s390/debug_print.h:15,
                   from s390/ucontrol_test.c:10:
  ./linux/tools/testing/selftests/../../../tools/include/linux/overflow.h:31:9: note: this is the location of the previous definition
     31 | #define is_signed_type(type)       (((type)(-1)) < (type)1)
     	|         ^~~~~~~~~~~~~~
  cc1: note: unrecognized command-line option ‘-Wno-gnu-variable-sized-type-not-at-end’ may have been intended to silence earlier diagnostics

A fix resolving this issue outside this kvm selftest would be preferred.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390/ucontrol_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index d265b34c54be..d1258c1568db 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -8,6 +8,16 @@
  *  Christoph Schlameuss <schlameuss@linux.ibm.com>
  */
 #include "debug_print.h"
+
+/*
+ * header debug_print.h leaves macro is_signed_type()
+ * behind which is defined in "linux/overflow.h"
+ * header "kselftest_harness.h" re-defines it.
+ */
+#ifdef is_signed_type
+#undef is_signed_type
+#endif
+
 #include "kselftest_harness.h"
 #include "kvm_util.h"
 #include "processor.h"
-- 
2.50.1


