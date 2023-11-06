Return-Path: <kvm+bounces-809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 753437E2AAE
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 18:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DF79B21040
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC4229D10;
	Mon,  6 Nov 2023 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DO3j3sS/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA829CEB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 17:08:57 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161E8D6E;
	Mon,  6 Nov 2023 09:08:56 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6H7QQA019153;
	Mon, 6 Nov 2023 17:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Guakuy35nl7NCrslAN/gPPw2BMYsCmMaPWXaK5jtM/s=;
 b=DO3j3sS/KzngdFgn2mhNG+cZrxOcWZsTEQvj5SA1rWz48DLkzt3vpjahJHQjdOjuO8WW
 2IR6WzWnKX/EPXnpe38tZh3tQd2+6IrJaLD8cBxSxTyC0jMLW62GfeVs0DS3KQOjLOht
 BSxwe07E8eN54XTanhAdTMRZXDgy3eXSn0MiX9bWIKAZRlPuzpoLAs0w6By2kdbG+Mqh
 lZPdc2FPoRLoPyTdI/rQBVPGArr5c0fZx9CiZW+h0XpVDKDke7MoS9oKOjCvGrG3VPB5
 Usb0JFByZKmCpONeYebPoc3f7ttWTs/EZHoP8CqAg8OLPwU+CgIqaY19nY337idvu+7m nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u748vr1ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:08:55 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6H824F021168;
	Mon, 6 Nov 2023 17:08:54 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u748vr1vn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:08:54 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6GCPMt025666;
	Mon, 6 Nov 2023 17:08:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u619nauf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:08:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6H8oo819333780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 17:08:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AD2C20043;
	Mon,  6 Nov 2023 17:08:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2824020040;
	Mon,  6 Nov 2023 17:08:50 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 17:08:50 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Align SIE tests to 2GB
Date: Mon,  6 Nov 2023 18:07:59 +0100
Message-ID: <20231106170849.1184162-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TEMpbw-x2qDOyO89EDd8-Epqh-zgjIH2
X-Proofpoint-ORIG-GUID: H_OGndkktcevbv6XE7kO7Gi-sMZFsVwH
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060139

v2:
---
* reverse xmas (thanks Claudio)
* kerneldoc (thanks Claudio)
* fix a virtual-physical confusion in mvpg-sie
* pick up Janoschs r-bs

Some environments on s390x require guests to be aligned to 2GB. This is a
problem when kvm-unit-tests act as a hypervisor, since guests run with MSO/MSL
there and guest memory doesn't satisfy this requirement.

This series ensures kvm-unit-tests fulfills the 2G alignment requirement.

Note that these changes make mvpg-sie test case fail under KVM due to a bug in
prefix handling, a fix is was submitted here:
https://lore.kernel.org/kvm/20231102153549.53984-1-imbrenda@linux.ibm.com/

Nico Boehr (3):
  s390x: spec_ex-sie: refactor to use snippet API
  s390x: sie: ensure guests are aligned to 2GB
  s390x: mvpg-sie: fix virtual-physical address confusion

 lib/s390x/mmu.h     |  2 ++
 lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h     |  2 ++
 lib/s390x/snippet.h |  9 +++------
 s390x/mvpg-sie.c    | 15 +++++++++++----
 s390x/sie.c         |  4 ++--
 s390x/spec_ex-sie.c | 13 ++++++-------
 7 files changed, 68 insertions(+), 19 deletions(-)

-- 
2.41.0


