Return-Path: <kvm+bounces-18758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE278FB19E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5CC91F2390F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B815145B16;
	Tue,  4 Jun 2024 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V0a4CpxP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD03B144D21;
	Tue,  4 Jun 2024 11:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502399; cv=none; b=APo2fRiZhhfkzJM3CUXCO8mUmiKe1ICOHyTfYi84atxLsLPhxZM1z7jM4pnEhHLUtpHY0bWKLcWpvJfC0EkiOFwq3U9z2iqXeVn6St8zRsBYml0rIRthwcacCdTZT3ccdUKJ4ZCe9ibvU8sU3XUtCX7Z3Ua8k6oCS46yUBzl+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502399; c=relaxed/simple;
	bh=fXrHI4BzqsQAhwCXnAdCByAXJJYZjx3+aQqINuAeZME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lDUt8XlJP2DtSn68C2I1TFbl8ZvEHVQvatc0hcLDhOWjRjHPOXqrDNVwBRDpqUQ7NarFSCcHe4pNTbmLNIy9i86Pf2RokNC+1V6TFGLxnX3mPXqd1w/YjkbZ2lPZmcrX8mZtqjxjc2Cl+gffK7A3czBcn/wDe/lylnIEDzjuVOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V0a4CpxP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454Bh9x5017153;
	Tue, 4 Jun 2024 11:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : message-id : mime-version :
 subject : to; s=pp1; bh=SuA7ayyT4mpatcRJoJEtVcKRdmma5oXzraV0R6pV4Ts=;
 b=V0a4CpxPRra8hiw6dYeErdtKZkssuIv4inUm299STkfhfOu/MdcYdgRiZJAMawoPVQhe
 fOOcZ7RAnfLxeCrOIz9hX+Lot7aaJGhT6Oh42x71RV6NLYwySgPFhGduYRFPhmjVGRgc
 x9jmvICOEzO/Gcwf4sP2A4OsSxzmrHwz69AFboYwIqUHeoSrbQee9pJkz7Vaw8UkZGyb
 EzAfmMchNBupy+f4X0EGTJpzrgODmXswNA4r2kMjfW9gHpq510BsJFvRazBLEWIv4ynh
 HuKD/vrIymn/pPBvMhAG4NZO5I+CYpJtMikKe5IDwDHP9Saqxunyut4x23aCQaEHbB5M TA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj29qg2ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:56 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454Bxusw012474;
	Tue, 4 Jun 2024 11:59:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj29qg2ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:55 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4549FfB1031142;
	Tue, 4 Jun 2024 11:59:55 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypduk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 454Bxndg33882838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Jun 2024 11:59:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 875BE20040;
	Tue,  4 Jun 2024 11:59:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 031582004B;
	Tue,  4 Jun 2024 11:59:49 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.63.147])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Jun 2024 11:59:48 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 0/3] s390x: small Makefile improvements
Date: Tue,  4 Jun 2024 13:59:29 +0200
Message-ID: <20240604115932.86596-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9eEywCTZwc17AcCCrgd3YzroZKzu9Mn-
X-Proofpoint-ORIG-GUID: EMf2CJzz5gdd4uOFVF2lV9E-NA6iyte7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=570 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406040097

The first patch is useful anyway, the third could be dropped to be consistent
with the other architectures.

Marc Hartmayer (2):
  s390x/Makefile: snippets: Add separate target for the ELF snippets
  s390x/Makefile: snippets: Avoid creation of .eh_frame and
    .eh_frame_hdr sections

Super User (1):
  Revert "s390x: Specify program headers with flags to avoid linker
    warnings"

 s390x/Makefile              | 16 ++++++++++------
 s390x/snippets/c/flat.lds.S | 12 +++---------
 2 files changed, 13 insertions(+), 15 deletions(-)


base-commit: 31f2cece1db4175869ca3fe4cbe229c0e15fdaf0
-- 
2.34.1


