Return-Path: <kvm+bounces-36751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63212A2083B
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F1063A3919
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 10:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283FF19CC37;
	Tue, 28 Jan 2025 10:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fbb+QJaZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09CC1991CA;
	Tue, 28 Jan 2025 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738058813; cv=none; b=Rzy/P1cMP5hgC6i6MYmkbOLH57dtdeyBnmI4u7ME8BlCmXtO/r3Y8pZVptzrKdQJN/MhWfOqndna3tTfwkgqMe4wtH2BC/dDxBf/B+ipJgRT3eEPY+EfZxhfdGKMPQYF2A302bflrpySn0m9vaNpt2iNllrPChPgCH9lnSQ89mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738058813; c=relaxed/simple;
	bh=2E8zLUIEzGdm2RSIAvXGBITmAUKAxYTEu7BL5x1hP4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FqlI4MKkCbQVh1FecL3XpsyeGjjdyFDbOX2C8evrWMudE0ixZ9b6s6usGmx13KWWqwhzF+7fvpaSnQwznSXfLQguEDJxTOr9OzMts0W2QTGKqkKOUSIgbbjj1ktK00zr2B0zf1R6XLG3EsfwM9N9TNDLC7RHkGEEiLuEl1wrs8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fbb+QJaZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50S7X4gN023133;
	Tue, 28 Jan 2025 10:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=XR2rOUG5ikxchzU3fGdSo45XJt5oSJckhqbghmvTb
	Aw=; b=fbb+QJaZuCiB5xXy6rrQH3maE8PdEPWQEVUxSL0dKM4GqesuXEnS1L7Ax
	t2YJfuSMlzNCCXhzED42L+0clHrsrXM1DQU7Euqdoz1VL40AoNdzq6z310M4lRK1
	yrLuB8ffI5GPWOvvbBn986YGeFip+J4kxOTjtdaiEKt+t34EkVQnB7NmdQ6yaUXl
	EmYA7PbQYxBDwfl4XxtWnF/SgB7usTWTUDM6ICQamFySBjf7vCcLqHnWnOAfFa6v
	zx9HqqgJZhKSZwXXjHasNUl4Ijjsf0bFVGF6Nmo6JTNwBWnPWmhiW63blbWq+d47
	9mCzuAuE7oTyXb39VKopLlhSadfWQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44etxrrmmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:06:49 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50S9YKkB028064;
	Tue, 28 Jan 2025 10:06:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44dbskamua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:06:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50SA6iVQ55116084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 10:06:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB76F20238;
	Tue, 28 Jan 2025 10:06:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57CB020236;
	Tue, 28 Jan 2025 10:06:44 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.179.13.59])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jan 2025 10:06:44 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: Improve out-of-source builds
Date: Tue, 28 Jan 2025 11:06:37 +0100
Message-ID: <20250128100639.41779-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9HoaioEuTqFrChHPmTcXzzvRoJfJso7u
X-Proofpoint-GUID: 9HoaioEuTqFrChHPmTcXzzvRoJfJso7u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxlogscore=665
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501280073


Marc Hartmayer (2):
  s390x/Makefile: Make sure the linker script is generated in the build
    directory
  s390x/Makefile: Add auxinfo.o to cflatobjs

 s390x/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


base-commit: 0ed2cdf3c80ee803b9150898e687e77e4d6f5db2
-- 
2.48.1


