Return-Path: <kvm+bounces-23327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 108D9948B8A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C53ED2812BA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE6916BE17;
	Tue,  6 Aug 2024 08:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S25DXj2o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3CC1BDA80;
	Tue,  6 Aug 2024 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933949; cv=none; b=Ar7In/iTigayqjtZTZYYZYl03ZSWfzSncCCdSWEaSTbs7xvmGfj49AQjAcq83BvUevk4bBx2SMI/WooJ68mse5UtKXY/d+44xu3A2mBxy3MyNhwoiVfamAp4Rr/tyaYXscSY6p5YiDYn9XrvXKPfopOve4to/gole9K1MYmEeQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933949; c=relaxed/simple;
	bh=MTpvAa5ZdIwtyFlgbw3nzvFRRSzTur6/doN26CKr+wU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=teBPMYMQDm1cThQbnxtc2Yc3cx6qlTXQLxM0pchWN6PmgSEsCItuxLVW4aVa1YQNX95mlxIRmzwAXa0vnyraE9CPNL+QxRPLtT6Tn1Dnih/2cHGA5VuQPU1a71qL07iXxdZo38zbypG16MdI2mYspdL8twe7it2vZaGzRwVN2Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S25DXj2o; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4766winu003006;
	Tue, 6 Aug 2024 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=+YOf7NfAOCizzjI3BD88yyJHbd
	+5feuhKgBXDm2j448=; b=S25DXj2ominhGJm85WI+3qdngEzFJl1poZ9VzhmxJ7
	FZWWcuK+x6hy2OUEaIuO0fLOENd9BBnn72y+GWyhBPcqDyE1+VG9/igtSgpnmf6g
	ul2UHF3yrOJLyAAmdK8s7SCof10vLitylHHXP71XLNlNQs3GQ+Sj7SoQFk+Yv8Sf
	oG2W+RWrJaf2RjUwNnRsSmryfmK6KHz0QNkQVhEHQv2m5dpTxaBb2hNzvpnturTB
	psKBEaLGoYCCIHWfJveTmSMqhgAILVtSfBUDzbik+8P9lZGnowcHLiUxI63cWCjn
	GUFdaZVD7hZUzN02Hl+5MHNeCk3mtb51DPQ/32DAN2kA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40uf1hr7a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4768jeMN019908;
	Tue, 6 Aug 2024 08:45:40 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40uf1hr7a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47670bIV018626;
	Tue, 6 Aug 2024 08:45:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40sxvu30w8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4768jXvB55509362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Aug 2024 08:45:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59A9C20063;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E9F620043;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, nsg@linux.ibm.com, npiggin@gmail.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/4] s390x: split off snippet and sie related code
Date: Tue,  6 Aug 2024 08:42:26 +0000
Message-ID: <20240806084409.169039-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LcgBrnGxtiFMkcj4og_H4vwOjQkrb7_X
X-Proofpoint-ORIG-GUID: atIxbGuA3_0Itp7JRH2Oyq0mL71KQfbJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_06,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=897 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408060060

The makefile is getting long and increasingly complex. Let's move the
snippet part to s390x/snippets/ and sprinkle a couple comments on top.

While we're moving things around we can split lib/s390x/sie.h into sie
architecture code and sie library code and split the sie assembly in
cpu.S into its own file.

v2:
	- Rebased on Marc's makefile patch
	- Fixed commit messages in patches 1 & 4
	- Picked up R-Bs

Janosch Frank (4):
  s390x/Makefile: Split snippet makefile rules into new file
  s390x/Makefile: Add more comments
  s390x: Move SIE assembly into new file
  lib: s390x: Split SIE fw structs from lib structs

 lib/s390x/{sie.h => asm/sie-arch.h} |  58 +------
 lib/s390x/sie.h                     | 231 +---------------------------
 s390x/Makefile                      |  45 ++----
 s390x/{cpu.S => cpu-sie.S}          |  59 +------
 s390x/cpu.S                         |  64 --------
 s390x/snippets/Makefile             |  34 ++++
 6 files changed, 49 insertions(+), 442 deletions(-)
 copy lib/s390x/{sie.h => asm/sie-arch.h} (81%)
 copy s390x/{cpu.S => cpu-sie.S} (56%)
 create mode 100644 s390x/snippets/Makefile

-- 
2.43.0


