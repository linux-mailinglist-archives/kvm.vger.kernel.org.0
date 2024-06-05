Return-Path: <kvm+bounces-18924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5988FD230
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A68E41C23372
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A235148FF8;
	Wed,  5 Jun 2024 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D2Bb9Ris"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB210A0D
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603096; cv=none; b=GWfnw3cRw5DP65e2R62WZXjnKvITixePfHdIg0+byvjAPbJGaowR2bTUD6CYQZMSUqlZQeNP+IsBFgBHjwMZFE4bhNrg199TJ8pAulm5zuSNHWI3kwhHgnw70u3EXgLP7VfZ3IYOzhTJ3GwWMAkSSir+SGQ41RvHmGC0rhzGNdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603096; c=relaxed/simple;
	bh=b1Y2UWFmYOgwy2cqLreUgtFcP1iHoprYjbiysb6NTmM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Go6ZS7O4aym7OtW+ToO9BtGmfXNvjOOQJVaZGmAnxhVYapdmUbi3PAgFHY211vJVRVtv29xA8zNxP7af7PU+NkSVKhwHtxNgsYeRggoJbFBXz/vUZj66LCiZcOye0EYhJ2jWQJECbao52mHnRBDcS5RHQzsRG64t3ko/ABFbINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D2Bb9Ris; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455EJl18010620;
	Wed, 5 Jun 2024 15:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=ALgeKuVqFIO9D6RFsSznRhTRJ/tzwMvDqDRx65pA2Fs=;
 b=D2Bb9RisBl6W/mOzdr/VvfNN7aFxmIAuKLkXe5mI5vb1OPr4xYifMIUuUSUqeTu2ncEL
 7AR7xOnVRmHE8M1+yc9RHBBqUNge//t5AQaKTVvKIPlo7Zh0jfMTQAA0NzKKIyKXmMr9
 LemYEDaqk94PQ5CPw+6nGHY797qxSVAjnKV7cCmvwx6e17FnTbo/NsI6aeNsElKO/X4a
 xSAtwpnOO2M5Wkf182U1drXNUsDvCIKElfeEB81X1F21/tvzf//6ZNoeywZwSKn+lOYn
 gN7uLCc+zTvJ62I6uPQTnEfgNH6Fs+v5QHGW3iKsMShd4jtzTobDOt+eoMqBT8LdIisu pA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsnj09t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:11 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455FwBxm003015;
	Wed, 5 Jun 2024 15:58:11 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsnj09sy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:10 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455FQLTZ008463;
	Wed, 5 Jun 2024 15:58:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0w8ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455Fw4lv57016742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 15:58:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 749822004B;
	Wed,  5 Jun 2024 15:58:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1E2520040;
	Wed,  5 Jun 2024 15:58:02 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 15:58:02 +0000 (GMT)
Subject: [PATCH v2 2/4] target/ppc/cpu_init: Synchronize DEXCR with KVM for
 migration
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org,
        sbhat@linux.ibm.com, harshpb@linux.ibm.com, vaibhav@linux.ibm.com
Date: Wed, 05 Jun 2024 15:58:02 +0000
Message-ID: <171760307934.1127.11339021522853395539.stgit@ad1b393f0e09>
In-Reply-To: <171760304518.1127.12881297254648658843.stgit@ad1b393f0e09>
References: <171760304518.1127.12881297254648658843.stgit@ad1b393f0e09>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wSsFJF725h6xPuEn73XWw5zFmnfoXTh1
X-Proofpoint-GUID: slsPbLF23A8pgMZYWB3wuUSU2kctDYMK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=844 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050121

The patch enables DEXCR migration by hooking with the
"KVM one reg" ID KVM_REG_PPC_DEXCR.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 target/ppc/cpu_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index c11a69fd90..b1422c2eab 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -5818,9 +5818,9 @@ static void register_power10_hash_sprs(CPUPPCState *env)
 
 static void register_power10_dexcr_sprs(CPUPPCState *env)
 {
-    spr_register(env, SPR_DEXCR, "DEXCR",
+    spr_register_kvm(env, SPR_DEXCR, "DEXCR",
             SPR_NOACCESS, SPR_NOACCESS,
-            &spr_read_generic, &spr_write_generic,
+            &spr_read_generic, &spr_write_generic, KVM_REG_PPC_DEXCR,
             0);
 
     spr_register(env, SPR_UDEXCR, "UDEXCR",



