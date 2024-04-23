Return-Path: <kvm+bounces-15632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8BF8AE250
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07AED283A95
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E60E626DF;
	Tue, 23 Apr 2024 10:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n7bpQhsf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D9A366;
	Tue, 23 Apr 2024 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713868540; cv=none; b=OWC9WZUMkhTGaStExwwnQDN2LoXe7SHbubJPrNVO3Kg+tcQS/AHTOofHzb8qsBi3g08NctbcoKHQTn9tlTvk3QphjPUgNhuSqJGRHjxSeBA9M5x6Hy/XvxCppVfBdRdCmI9rR7w3adcNvygJvGY98/xYFwtrK0Ynnbt2W3f9cBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713868540; c=relaxed/simple;
	bh=btRVjF9EZJO72pyvfqReK15CD7G/8b0lMxgTKU7v25Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y0Qtv1fvc8rtRtVjaevGlw3B3loB8XnHwYEEhJ1wN5l7qKt2Fn0cBCQ70hQ5Q85j2gyHtZi9cm+vOfQxrTHinmtfVAuXftTQoISREivOgSM14CRRj+uyX/1MbHTjUw4W7/TtrkP/wE2dfCxxuUFlNwI5fOFDgihpF+SfepAHF3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n7bpQhsf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NAVIrG017974;
	Tue, 23 Apr 2024 10:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RLidVQvklFP/Wc6vuXQ/xuFQO3M7Y6qaT9nYLcfp+qg=;
 b=n7bpQhsfyBZReAZDIl5T3sJ1c6+jVw4+mP1eF/JmkPqZ2GaaHdEb6BGCfjPg+DXeFlAs
 9HcBOVZb4WtnqA8Retd8cRq+M55Jj6QTD9sbWAMVdp4j/tb5g0f8YRlwTp4zTZh2Issi
 BadsdLUtBhNDVXzSrJb9WEb2DyPNROpFQL6VnYoS1LA3cO7DMpzg5uBc2Dpl58z1mTkp
 QFYyzPV2hlW1RGd1mxFud4VTXdeXb4XiklBKSH9DHbGWKxBlWXqFW56xYzYkgO2n7MaX
 qbtMhiV5/yZZK+WukdiWl+SlpBtvPs6PSPFwGHX74KHjs4mJCHyXSPrI3HqmgCOmnuZQ uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xp6d10nkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 10:35:37 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43NAZapx026458;
	Tue, 23 Apr 2024 10:35:36 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xp6d10nks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 10:35:36 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43N96GcC028319;
	Tue, 23 Apr 2024 10:35:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmtr2ckkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 10:35:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43NAZULx28639816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 10:35:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 285612004E;
	Tue, 23 Apr 2024 10:35:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB44A2004B;
	Tue, 23 Apr 2024 10:35:29 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Apr 2024 10:35:29 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/1] s390x: cmm: test no-translate bit after reset
Date: Tue, 23 Apr 2024 12:34:58 +0200
Message-ID: <20240423103529.313782-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Dt_qoksTgtvdRRGAl51S44_cYpnme4QK
X-Proofpoint-ORIG-GUID: IHoCCIuMy2z0MN-n-pfNMsXKC_Ijad0T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-23_09,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230028

v3:
---
* fix specification exception when ESSA no-dat is not available

v2:
---
* fix reverse christmas tree



Nico Boehr (1):
  s390x: cmm: test no-translate bit after reset

 s390x/cmm.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

-- 
2.41.0


