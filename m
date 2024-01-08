Return-Path: <kvm+bounces-5819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D22826FD3
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:30:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 760061F2318F
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50A045BF3;
	Mon,  8 Jan 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YlkZH4AG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853944C96;
	Mon,  8 Jan 2024 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408DLoul021543;
	Mon, 8 Jan 2024 13:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ogelmsm/mxtfhIFSXl0PUewEJYkOYZsxX5ZI6Pz0kv0=;
 b=YlkZH4AGstMGMdX32/v0GJ1tXKzByOTd3XcYRp/rQ/Li8Ho5xD5uTCUfsHRAg58yI4YB
 MRsVJ275tTsN20Ki/GtePCOI5MLDkKCV7dcNfvv7nzavtllWLsUgJ/PFsyTu+44XNtdS
 iHsNP3WqT7YD3nYIfXVGyJkiEDd5toPUKM4109W2nvWObdjtgO9XU4K0rlZq0UBOr05b
 Ctjscjo6cZ4N0qPZWbtQOoDjObae5lmGF9Qu8MgTi8WMnjTXXw1Xi/LJKnc8l6ShT6zV
 O+ri/z0SGuLYE7S/fl1hCWECFjTPdcS3Uwsqm3E7AASpfRi9tq2gh/2wlhF4tAnCNgNV fA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf1uypspq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408DTK10025748;
	Mon, 8 Jan 2024 13:29:50 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf1uypsp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408CJ8l6022819;
	Mon, 8 Jan 2024 13:29:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfhjy888y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:49 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408DTkqD19399392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 13:29:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0527820043;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1D5420040;
	Mon,  8 Jan 2024 13:29:45 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 13:29:45 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/5] s390x: Dirty cc before executing tested instructions
Date: Mon,  8 Jan 2024 13:29:16 +0000
Message-Id: <20240108132921.255769-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KTwi0UwcFhQczEunx9RE8f05rhj2rJrP
X-Proofpoint-GUID: L75n27QJf1n0GSoc1kcpg_u0KA54Dh0W
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=8 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 mlxlogscore=104
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=8
 suspectscore=0 mlxscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080115

A recent s390 KVM fixpatch [1] showed us that checking the cc is not
enough when emulation code forgets to set the cc. There might just be
the correct cc in the PSW which would make the cc check succeed.

This series intentionally dirties the cc for sigp, uvc, some io
instructions and sclp to make cc setting errors more apparent. I had a
cursory look through the tested instructions and those are the most
prominent ones with defined cc values.

Since the issue appeared in PQAP my AP test series is now dependent on
this series.

[1] https://lore.kernel.org/kvm/20231201181657.1614645-1-farman@linux.ibm.com/

Janosch Frank (5):
  lib: s390x: Add spm cc shift constant
  lib: s390x: sigp: Dirty CC before sigp execution
  lib: s390x: uv: Dirty CC before uvc execution
  lib: s390x: css: Dirty CC before css instructions
  s390x: sclp: Dirty CC before sclp execution

 lib/s390x/asm/arch_def.h |  2 ++
 lib/s390x/asm/sigp.h     |  6 +++++-
 lib/s390x/asm/uv.h       |  6 +++++-
 lib/s390x/css.h          | 18 ++++++++++++++----
 s390x/mvpg.c             |  6 ++++--
 s390x/sclp.c             |  5 ++++-
 6 files changed, 34 insertions(+), 9 deletions(-)

-- 
2.40.1


