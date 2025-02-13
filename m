Return-Path: <kvm+bounces-38094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2DFA34F0A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD3327A41D8
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB3224BBF5;
	Thu, 13 Feb 2025 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jeFZh/b5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE128A2CB;
	Thu, 13 Feb 2025 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477292; cv=none; b=fDCQvex7JsMmr8JE/aIDeKe0YNuHBmNxbuI4GtX0n4S3AL7h1feFS6JJNGeKnHYd3nmNP/S9By4BakUrBo3jAystOi/PFRRDKaLJ1OW9pBA8D/pdFvXBdKig8hmk1mh+RTH0od71nnf1A35BcS95DdDIWE7Uw/fSD1DA0axXuhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477292; c=relaxed/simple;
	bh=/r3+TgwrcVNhcjjGk6MYwTF8/FYhXyZWt6nZveFqRCA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VztKYBneTnqzJSZWPLBC87+Y0pw1wgvlX7WZZFm2W+KC+wYD1GXHl+k+KTGT0HeXtN2x2kCVGoC0GDlY4LFcX/fGITSTEMJtR6y6Q9APnPO4QA0fcN9dXi/TbfEU1s5GVh6w3iTMSo5wur2LLdA0pnUxTfef8Ce6h5jICOjkMFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jeFZh/b5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51DFmht0015123;
	Thu, 13 Feb 2025 20:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=r5NxNiwraLIrNf0oBP87fGsOB1KMBN9QlY+MdUMin
	ck=; b=jeFZh/b5AOiu8EiCNQPNf5A4SAONRzLl8ww9R/zAjDGbm0QQCVWZLfdvQ
	/gIFwlwOX+B4zRSMAkt9n1Rd2NSoAaPWjmjCD0XDNdtEPvW8Rfphmi2h8+1oEBf+
	Z8Ju4lCi9aAtO/E9J0U6j/Uh234c/KdSFVkrhuHO68CsUlRIZvcEAf6bXpicYciM
	EXPQhtZidBSByzVAyEEexH6CMlChYzuMfAb9C38pxFO7MZf+d/vZnHlMtreMaeGq
	CsCQVtuZDKCwkeTQEMsELEsRn8uYsyFI0VUMjTavlHrh6roLERDBvsHXUgK28pu/
	+gVtGT+K7sFtZU/9n9DrcNQuEtR0Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44sceq3v2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Feb 2025 20:08:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51DJIQMf016689;
	Thu, 13 Feb 2025 20:08:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pk3kg16f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Feb 2025 20:08:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51DK83ST47055162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 20:08:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90DA320040;
	Thu, 13 Feb 2025 20:08:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E723020043;
	Thu, 13 Feb 2025 20:08:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.41.52])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Feb 2025 20:08:02 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v1 0/2] KVM: s390: fix two newly introduced bugs
Date: Thu, 13 Feb 2025 21:07:53 +0100
Message-ID: <20250213200755.196832-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sdEkEZAj3C-5UiFAw238kVX4oCYCSkRL
X-Proofpoint-ORIG-GUID: sdEkEZAj3C-5UiFAw238kVX4oCYCSkRL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_08,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxlogscore=494
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502130141

* fix race when making a page secure (hold pte lock again)
* fix issues when splitting folios (use split_huge_page_to_list_to_order())

This should fix the issues I have seen, which I think/hope are also the same
issues that David found.

Claudio Imbrenda (2):
  KVM: s390: fix issues when splitting folios
  KVM: s390: pv: fix race when making a page secure

 arch/s390/include/asm/gmap.h |  2 +-
 arch/s390/include/asm/uv.h   |  2 +-
 arch/s390/kernel/uv.c        | 19 +++++++++++++++++--
 arch/s390/kvm/gmap.c         | 16 ++++++++++------
 arch/s390/mm/gmap.c          | 11 ++++++++---
 5 files changed, 37 insertions(+), 13 deletions(-)

-- 
2.48.1


