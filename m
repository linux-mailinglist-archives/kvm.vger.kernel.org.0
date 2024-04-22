Return-Path: <kvm+bounces-15473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E268AC818
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4975283CEA
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A865103E;
	Mon, 22 Apr 2024 08:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ekqEMJpx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644E652F9B;
	Mon, 22 Apr 2024 08:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713775964; cv=none; b=oAuaPQ0/C7JbJv9bJq3sfrSFXMVg9hvuwea2S5UmywtBpbYGTHQVGGkJaw5coGF4yhwWqdYWCI1CpAfHPMdaKDz7RenRsL+Jqa5+kmgr4MmccjS7mAQjdNVExVrZNImXBnE5atdDmQl8WBGvADWsn4AQ3DLNOmRKXjtLfyt6CGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713775964; c=relaxed/simple;
	bh=wvC3r31r/dnZ/Aer2+n+k3UMKWG3Kakej/Pn2Amk9kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KopLPfZkDr0CoS+waFN0zoRxmHJDGYLn32sv5SpBF2WuU+Gx2WPGG5aW3S2msKXkCeDc/FwA5AQxJa61oQU4qUfqsMG/99a1MjU7pONC6cpGO8So3e9esYVCiLMqkQRfBROjlh3C0bkwvSUPBa4jcjxGNacC1IpClsKIUTvfTJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ekqEMJpx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43M8HUpl005727;
	Mon, 22 Apr 2024 08:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dRfBgUXTFeRUe+bgqycMr9Bno2Q7MZS2kPSIFxmpW5s=;
 b=ekqEMJpxCzR6e/JCvInq2gsOI+p3VYW32rC9IC47XAlewjYrMw+exuV6pwWqeMeQzMfF
 kKyNjbAU6pZiduLBZ8VB5K0LbF7nTneCB/QMz9iVFA27ZvrnNMpPUSrq9+dG69zTbMW1
 rLVXfEJ04iz9JyFycz34j6IqhzE9fg6iX3J67HCMesxT1WMddHggsl0thoQ911wB/gv2
 Uvmj60JNcGaTx89NEw17t4YTpjtNv4y1K7XhzTr95kFE8oUseTZivZaB6zauL6Lbmd2f
 w3VaiCOJi35WtmADzdM6CWW0U06a9atOCRJKLoABtNGrhALPeWHzUxSdAkfHuqc+JiAf 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnm8gr2e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:52:41 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43M8qeBE024013;
	Mon, 22 Apr 2024 08:52:40 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnm8gr2e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:52:40 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43M5OsiX020908;
	Mon, 22 Apr 2024 08:52:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmrdypuj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:52:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43M8qWN516253330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 08:52:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C139D2004E;
	Mon, 22 Apr 2024 08:52:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 892DD2004B;
	Mon, 22 Apr 2024 08:52:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 08:52:32 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/1] s390x: cmm: test no-translate bit after reset
Date: Mon, 22 Apr 2024 10:51:49 +0200
Message-ID: <20240422085232.21097-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tqJcVworsWH1Mrp-Yw-AjoWVQNBn-s_R
X-Proofpoint-ORIG-GUID: vb2TWc1znH6VulPDHbgqZ6tBASDCz-0h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_05,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404220038

v2:
---
* fix reverse christmas tree



Nico Boehr (1):
  s390x: cmm: test no-translate bit after reset

 s390x/cmm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

-- 
2.41.0


