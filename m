Return-Path: <kvm+bounces-7716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1FF845A4C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20821C261DE
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99265F49F;
	Thu,  1 Feb 2024 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cF8AHt9d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4005F49C;
	Thu,  1 Feb 2024 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706797580; cv=none; b=mX7SBSCQCaWyFjSrwghfPPIcd+M215jPL7/+MArhCJiEC27dOtpuDLXre1A8izNmLCHm4BMG6vp2B8b4tL1BV/uDv4yG1/K6cqr9jaAj5/0DDQ0h6Ky3jrwCvnqgpWnVdNA57OjwNdO0/dSWyRtRNgMhOgN23YqzTFQ+ol7+uyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706797580; c=relaxed/simple;
	bh=05fvYJTIYrHs5RXEX9QREKE0/qxpQs4wFgKHMmSQt6o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SEuDFBHDPnxNIpp5tCi8HCLvsWfyl1DSttKZdepFVg91fCPca3rCQVxxYYinHbFB/iQKTTgvUYOpv2qf9gQcABYAiX/93kVxLEr8t99rWSYixX06BAVyR9Rz0M5f18OwRr6+WI3xuIUlex+J3wXm8fclzisoP1+oAxvbMaazBdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cF8AHt9d; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411EPHA7013100;
	Thu, 1 Feb 2024 14:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eXbOCaoA9+cZPJllKgRVs7rwLDqtS3QcWhVFmtV36xg=;
 b=cF8AHt9dtYLKAnKOgK5wVJbxifHOp85kLdvs9E7hwNdc8U7gUSqi5tauAqmqVLZzvYfJ
 lRsWC6Nb/+KRWYfHjm4rFHY+HaKce4JyeXUOcrFfRSgUrhZew962xVSBu9pb619b4eoh
 ghZKaLQLQfVgpVWR5e9qOJ2GDBzv+ke2U3g8uG6NZSSnuq/s73cxEfygXPpNDiCokq2u
 jr++TWkPUwcuf55RQnwLITXw5Rwreqw0kAAUyEfObjlCQ/dk6R5nUtpn/SombtmVTut/
 Iltq+vZoB/TA36UT/ueYLMlJ38S/Q3mL27PNL8wLlOU6/Xf3hcNPC+tOjgQDQz6CQdC0 BA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0b8737d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:44 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411EPgQB013851;
	Thu, 1 Feb 2024 14:25:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0b87379q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:42 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411BTk4c007295;
	Thu, 1 Feb 2024 14:25:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwev2m7bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:25:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411EPWDp46138014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 14:25:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3242520043;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A8CC2004D;
	Thu,  1 Feb 2024 14:25:32 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Feb 2024 14:25:31 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests RFC 0/2] lib: s390x: Inline asm cleanup
Date: Thu,  1 Feb 2024 14:23:54 +0000
Message-Id: <20240201142356.534783-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TKn4pDQOh_ZF4Km5H7u_uXNXre-NrSgf
X-Proofpoint-GUID: UrA51FwGqupa0ZyOF-dlKGKKOyrl9sDD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=535 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402010114

The library should not have unnamed inline assembly arguments for the
sake of readability. This series names the arguments and removes
unused ones.

Janosch Frank (2):
  lib: s390x: sigp: Name inline assembly arguments
  lib: s390x: css: Name inline assembly arguments and clean them up

 lib/s390x/asm/sigp.h | 10 +++---
 lib/s390x/css.h      | 76 ++++++++++++++++++++++----------------------
 2 files changed, 43 insertions(+), 43 deletions(-)

-- 
2.40.1


