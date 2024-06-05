Return-Path: <kvm+bounces-18882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 547D68FCA91
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:40:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BB27B21B51
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB34F193080;
	Wed,  5 Jun 2024 11:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cfJdKqh0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691CD7346E;
	Wed,  5 Jun 2024 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717587597; cv=none; b=Vfjcdzq9dJSv6vO/wn2rBqUuA2qEtgFFQzuduZGy+2GmpW1JhiUmsSgzD4cTTJ/tC9Ppe6IXqZ6KgI4aU0N2fLHPJkUBJemgRPI48kMkk5po7iRpSQ/BXjn1cZyTHrMjCvcuwdCy6diNx0gKGSwy2O6V230LIJPoJBaNtffh9/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717587597; c=relaxed/simple;
	bh=3ufVBHAl/Eurt1fBy7lzd272GOXOTn26bjjfK5Niaxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AXUXj6iT17enKanfqIhcDv+mBQKmNEkhlKoio1CZHCoaQ3SY96n69n1U8ieeCNioRBj+9TTKwkyYtX/fvKC8CtAWbVuTJwvFApJqCbPsoQr0BTYKdbo3wrEYBDfZFmBd3YEoLkf3sksfBLocqDoBW4YAyWW8XqoIb0OV94/Gaj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cfJdKqh0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455BQeCb031365;
	Wed, 5 Jun 2024 11:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : message-id : mime-version :
 subject : to; s=pp1; bh=CZTkS5V4PNzzO1xyaJ6beEHHqAc/m2eKAPYXuiWJJuI=;
 b=cfJdKqh0Dd704u9karCyMjS8BDleVjG8GndW1PERvvFxcXDKubnF+pzRyBd4LNGSwkeV
 yn82VWEASiAxkEksO8ULPrk5ju9E3pLbegDAAhF3cpvUn7wuEOMDluLHo2skr4cQ1unI
 foW11+l00dmYGjbuWvUeSETPhA1mmva2RPSHKvN2LlNQyTat3VcTzk2vnQWZjEw/oPmR
 91RW/0zewm9NvHEG31XlRu76RkkMnQrtw6u1zkCQYbfFkTZ/ouA+7HzYME++xa8e1Zg2
 gxS2tbAsYvwjGeTbSLYhdpGARPnNDAHynE+2eZIm3baA5t6OBYlduCPdX5t2pmzxzYP4 Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjns38786-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:34 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455BdYmd016552;
	Wed, 5 Jun 2024 11:39:34 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjns38784-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:34 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4558Osn4008501;
	Wed, 5 Jun 2024 11:39:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0v1me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455BdRUi52822518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 11:39:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D96C20049;
	Wed,  5 Jun 2024 11:39:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C3E320040;
	Wed,  5 Jun 2024 11:39:25 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 11:39:25 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Fix doorbell emulation for v2 API on PPC
Date: Wed,  5 Jun 2024 17:09:08 +0530
Message-ID: <20240605113913.83715-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j0spQTd4JPjx1BMLCnyss22liLlh8t7n
X-Proofpoint-ORIG-GUID: OhXi_eozsTRZczUX3Q2kgFULivil3rW6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=586 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050088

Doorbell emulation for KVM on PAPR guests is broken as support for DPDES
was not added in initial patch series [1].
Add DPDES support and doorbell handling support for V2 API. 

[1] lore.kernel.org/linuxppc-dev/20230914030600.16993-1-jniethe5@gmail.com

Changes in v2:
1. Split DPDES support into its own patch

Gautam Menghani (2):
  arch/powerpc/kvm: Add DPDES support in helper library for Guest state
    buffer
  arch/powerpc/kvm: Fix doorbell emulation for v2 API

 Documentation/arch/powerpc/kvm-nested.rst     | 4 +++-
 arch/powerpc/include/asm/guest-state-buffer.h | 3 ++-
 arch/powerpc/include/asm/kvm_book3s.h         | 1 +
 arch/powerpc/kvm/book3s_hv.c                  | 5 +++++
 arch/powerpc/kvm/book3s_hv_nestedv2.c         | 7 +++++++
 arch/powerpc/kvm/test-guest-state-buffer.c    | 2 +-
 6 files changed, 19 insertions(+), 3 deletions(-)

-- 
2.45.1


