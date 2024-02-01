Return-Path: <kvm+bounces-7692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4C68454D9
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 11:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CC32B212D6
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A5E15B0FE;
	Thu,  1 Feb 2024 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k+SCy2J1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9074DA1D;
	Thu,  1 Feb 2024 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706782041; cv=none; b=BS9XosvzjcIl5oqip1zDPJsPGznxvOBYZkyyCo0/n2vprU5GhKk7LIOBALDzh2VSHUnK49kJRbtiMZNYdVYId9NgpHxi76fydz6+R6h2sYIkhpDC2mbQ0v9FzdKGvg96miBGU6bIHJ152N7NryJYi+MMkAU5xa/9JW8ZL88TFKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706782041; c=relaxed/simple;
	bh=nNcegXSwW6UKFtduCCYg4voqCfFvyFX+9AKEHwxgUzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PH0UwBlaLsp2W3RzTqx7DeMfXzHpUI+dMASAAzjPwrLKCCn/6yktA2wurCWZcej3X3IpnRVv7LFdYKO43/VSMVs7YUlLsFqlBFOhu0kQ6rQ/5qgGckMyRKuz8jS1ZdEwfGavds03jOrCiAQtyct4vjcVEPYSjXFLMoTbQvUcYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k+SCy2J1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4119KxmZ018497;
	Thu, 1 Feb 2024 10:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=K6zUDQ751WWX1tafHaNS0tK9NuJ5KJR8fw4MJCPB3g0=;
 b=k+SCy2J1OylDGoK4ztjTUjfnohgolLHegyCeGusQjJX6+0P/j1toDdw9A0/IuNdyXkVx
 URm2Vy4U0Sd+Y25s4UkWon1hBK8UBX/wBUYZ9OeuGXH2zWEwbg0oyWyEgi3Rk/aax3NZ
 FrMufQKrDasbJtJxQHf3qW+7RocGuXd/dvmTxSqD/8FxHAn6E/mNgsXQ3IoOXxTOhmjK
 64pNcIBmKXd6A05+ulbGAsSGew9rJOGm+AIL2G/xk2nsPQ7BX6scs27DMS/nfUBxnoIq
 3yV7MBBA/NLMM3OgjCm41jEalDwgqxawqTxm0zQhGDmlDzv9/bZAMsgHdpoGiBBpSC9J HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w083at0xk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 10:07:18 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4119kLIv026850;
	Thu, 1 Feb 2024 10:07:18 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w083at0x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 10:07:17 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4119mOpP017755;
	Thu, 1 Feb 2024 10:07:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj03k28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 10:07:16 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411A7D4o14156290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 10:07:13 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 875F620043;
	Thu,  1 Feb 2024 10:07:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AF5520040;
	Thu,  1 Feb 2024 10:07:13 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Feb 2024 10:07:13 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: add pv-attest to unittests.cfg
Date: Thu,  1 Feb 2024 11:07:10 +0100
Message-ID: <20240201100713.1497439-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AxJ3NXdBDxlLYMgvcwWjj55ACoWxqIY9
X-Proofpoint-ORIG-GUID: gQr5BZAR-XPqJW2poRm_fm4OWJL5WLuj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=952 clxscore=1011 bulkscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 impostorscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010081

There seems to be no obvious reason why it shouldn't be there.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/unittests.cfg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f5024b6eefd9..018e4129ffac 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -383,3 +383,6 @@ extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
 
 [sie-dat]
 file = sie-dat.elf
+
+[pv-attest]
+file = pv-attest.elf
-- 
2.41.0


