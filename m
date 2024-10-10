Return-Path: <kvm+bounces-28367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42809997F24
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00CB12852F4
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A08B1CEAA9;
	Thu, 10 Oct 2024 07:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="stqA+4xv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510E1CDFBF;
	Thu, 10 Oct 2024 07:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728544357; cv=none; b=Zy2PfgjfBz+Fd9nWhPSKq/+G6gjBEdf3ZhsXKk2DmictkYLdNwMRwWcncvZh+Sh2ya38UOIiu8HVl/HLrPp8wTrYemSFlPsz8/bQTWgwSFD+JjhlElpXSKNHJymOdPEwx/erkoPi7xgZDNStXE43QAFndtK276HEeGC4nIXB67w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728544357; c=relaxed/simple;
	bh=1EZapPF1hggFvw6L+H4iQFPdyS1ZreY2fue4a95wUxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uKlGapmnNx8R8ILNe84rrDFTn/o6tbnpku2EOPOigtGHVd4vUGpTLNUQnSeEgVh+ieqbVAEiGwkXJyiQlai6tELa32Bh6m0B5o3xdXLD3dRHorJuaVj+dVQ3b3BHW9VZCAWbLZtWMxs2xw3CIXUDXxFwGWZ57u1R/5hAmmLAA/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=stqA+4xv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A6X4LI028451;
	Thu, 10 Oct 2024 07:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=xerd8OyYHbwNlzK1cVQ+/Yh9WEOoj30N1hCO85B
	q+CU=; b=stqA+4xvn4W6sYQ8arWRETjZxLZX5XdXhI27XJn9kha+Ymgh7JJtH34
	TbCxvwaBK9NSFOV51812FXH+VBIxeodxkIMg6U+OkOIfhMHZOiQA18CWdotjU6OP
	UQQVNuTA6L55mpcqTpS1a+qm+SGNb5wvtPnOvjIO2E36Q78ALiPSKy5Z73irkw/R
	FillaSEi6YeN/7dPB9EO/jO2HKC0kFaYuk4LPoMA9XKMrdTmHgpM+tJ3xj+QIdoo
	9J7NETF5SA8Tg5Px3MI4kuGy4rGGAeBQAQMM3GsZY0irgUilfMGJZgkhRRuiWlEJ
	lYURKFwvkxQuRVrm3uphcCh6FlUB1fg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4269rn86b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:33 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A7CXkb013143;
	Thu, 10 Oct 2024 07:12:33 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4269rn86b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A72Lph010703;
	Thu, 10 Oct 2024 07:12:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 423j0jp4dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A7CT5L47186360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 07:12:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D6AF2004F;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC4912004D;
	Thu, 10 Oct 2024 07:12:28 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Oct 2024 07:12:28 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/2] s390x: add tests for diag258
Date: Thu, 10 Oct 2024 09:11:50 +0200
Message-ID: <20241010071228.565038-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lz_dE5V4fD3uY8aRjtMgY9FkaOm0cSD4
X-Proofpoint-GUID: uIMzoKMKxV6BEcTTN3Gpj7DvsOST15oD
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_04,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=720
 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410100045

v4:
---
* fix alignment (thanks Claudio)

v3:
---
* reverse christmas tree (thanks Claudio)
* test invalid refcodes first since other test rely on it (thanks Claudio)
* use an invalid refbk to detect whether diag is available

v2:
---
* do not run test under TCG

Add tests for diag258 handling on s390x.

There recently was a bugfix in the kernel:
https://lore.kernel.org/r/20240917151904.74314-2-nrb@linux.ibm.com

This adds tests for it.

Nico Boehr (2):
  s390x: edat: move LC_SIZE to arch_def.h
  s390x: add test for diag258

 lib/s390x/asm/arch_def.h |   1 +
 s390x/Makefile           |   1 +
 s390x/diag258.c          | 259 +++++++++++++++++++++++++++++++++++++++
 s390x/edat.c             |   1 -
 s390x/unittests.cfg      |   3 +
 5 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 s390x/diag258.c

-- 
2.46.2


