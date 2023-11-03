Return-Path: <kvm+bounces-462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A537DFF39
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 07:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 489EDB214DA
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 06:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8637461;
	Fri,  3 Nov 2023 06:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SpA1pJbD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39112D61B
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 06:41:40 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49891BD;
	Thu,  2 Nov 2023 23:41:38 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A36dxrw010123;
	Fri, 3 Nov 2023 06:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1sO2ax16Yb/93+OdAaMC8HxcpBQcgys6B/ME9a0CQ7c=;
 b=SpA1pJbDv3CKrfEL/YYCM1yhscclQS76PSWMq0O0wsxwO2I+a6SYXiegAP+amXXobv/9
 Hi06LZeUNXEMd8kYS2i3TEipkKnMRF5bSdmYBzhUtkwfYyxLX507KKsr80MIEhSI/rOs
 dGg9T5DOfCHhiyiWybiiWxqXOma0w+QTfSPV81/JiJXkX0kJ39C7xr6aIGc7GwxUc0S+
 FVMA2mc9zRUs5jK1NSgHTpRjgo9xMaNYQLUotPd8ud53VvsNZE0SyFQFmJIyQBN4fqBV
 ZMVHzvXKYDNup78wGwE+Huteng1cXDxxcQz7xLstosv8Whh+96Zdqm9vW74sMAlGUYjy UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4usu81eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:41:37 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A36fbQI015884;
	Fri, 3 Nov 2023 06:41:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4usu81ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:41:37 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A34mAH7019876;
	Fri, 3 Nov 2023 06:41:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1d104bsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:41:36 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A36fXTH12452478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 06:41:33 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 655972004F;
	Fri,  3 Nov 2023 06:41:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2666D2004B;
	Fri,  3 Nov 2023 06:41:33 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 06:41:33 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: Align SIE tests to 2GB
Date: Fri,  3 Nov 2023 07:35:45 +0100
Message-ID: <20231103064132.11358-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gd8iw99YXe8aC0SVZvSdD4wl7KX-7Xa_
X-Proofpoint-GUID: NcM-d4eR2ldaFfWk7fPHPavI8LddE64f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_06,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030053

Some environments on s390x require guests to be aligned to 2GB. This is a
problem when kvm-unit-tests act as a hypervisor, since guests run with MSO/MSL
there and guest memory doesn't satisfy this requirement.

This series ensures kvm-unit-tests fulfills the 2G alignment requirement.

Note that this currently breaks the mvpg-sie test case under KVM due to prefix
issues, a fix is due for upstream submission.

Nico Boehr (2):
  s390x: spec_ex-sie: refactor to use snippet API
  s390x: sie: ensure guests are aligned to 2GB

 lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h     |  2 ++
 lib/s390x/snippet.h |  9 +++------
 s390x/sie.c         |  4 ++--
 s390x/spec_ex-sie.c | 13 ++++++-------
 5 files changed, 55 insertions(+), 15 deletions(-)

-- 
2.41.0


