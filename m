Return-Path: <kvm+bounces-18925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C328FD232
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E9F628244B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6B53D548;
	Wed,  5 Jun 2024 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o2F2m/TC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5410A0D
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603109; cv=none; b=h4SFlPbqmOXit2YpsUlQNyoNc6dAyXxjm3wk8Wxb7xyf978RVAx62TpJWAyeCntsUgWQJvOiSSsNBJ/yRJj/jiK8vqXhwEIuvDW4tk8ZWwEphUT/S21ymenAsJRMz06ZHp/BFENo/vXT56Tx3eEthyODZEB/FeK5rfIF5/IwPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603109; c=relaxed/simple;
	bh=KcA0+XP5wfh9Ij5C2Uf1n1BFU7gJXrSZK+n6fELB+Ik=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPmBpOcgojP7YE4Plp3/xVrkti/iFdRi7G5fmRl8mjFYJ9v17mUlWz+TZjgMBkmmBWTFe0yPOXZrc3Mz6KosZVBwLrMO+Tqdia+lS8SATLuWUZUhmGLJKxmyJ+1AngHrGH58bhpjR4zQTA7WxT1TvxKkVLNkG623bYSPaEJ7Bw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o2F2m/TC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455Fof9f032079;
	Wed, 5 Jun 2024 15:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=CVwxRreFDvXecgEAPPFNh+yGctWh3epBSsv5oDyXlfk=;
 b=o2F2m/TCJzdQKYVpLpMPEUGEf7k/IVk+X8dv6KkWdi5D0xwim1QmlVkRaqGmLdIWm8/B
 cBi6dcKIqUE2Nwc6Q453RnQ/G6jLkxm9qzakWB7tUKAINTyPYRkBfuPtpz3LAly2xfZz
 EUYDwhcLg/khougeWAmLcPlmlT8BYTPzAnc8oqk964IzXIXWovF2nSQdSMYXlv2lV+hv
 T9Mne/q2h2Uz6Wzn1rvGm4CA/i5CA9zGSDpXxnfSeK0dnR13mvjsP71MyFFI5oPieg14
 Tks1g1WwsjW9ScutCRxgGMt0vM4pf+MQni8fKsx9OJqZzMVpxTjgYhkiD/bHuDeFOrKN +A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjth984ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:22 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455FwLA8013809;
	Wed, 5 Jun 2024 15:58:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjth984ga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455FmKnY031109;
	Wed, 5 Jun 2024 15:58:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypn274-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455FwEoU22872458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 15:58:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5504720043;
	Wed,  5 Jun 2024 15:58:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B512320040;
	Wed,  5 Jun 2024 15:58:12 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 15:58:12 +0000 (GMT)
Subject: [PATCH v2 3/4] target/ppc/cpu_init: Synchronize HASHKEYR with KVM for
 migration
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org,
        sbhat@linux.ibm.com, harshpb@linux.ibm.com, vaibhav@linux.ibm.com
Date: Wed, 05 Jun 2024 15:58:12 +0000
Message-ID: <171760308953.1127.14625001027546560031.stgit@ad1b393f0e09>
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
X-Proofpoint-GUID: bNZhf_IiClzwRLEdOk2DN319dLb1Vvku
X-Proofpoint-ORIG-GUID: SuQrsRYFtLbn50tKa4dcVz7xHeWF-_R_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 mlxlogscore=864
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050121

The patch enables HASHKEYR migration by hooking with the
"KVM one reg" ID KVM_REG_PPC_HASHKEYR.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 target/ppc/cpu_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index b1422c2eab..cee0a609eb 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -5805,10 +5805,10 @@ static void register_power10_hash_sprs(CPUPPCState *env)
         ((uint64_t)g_rand_int(rand) << 32) | (uint64_t)g_rand_int(rand);
     g_rand_free(rand);
 #endif
-    spr_register(env, SPR_HASHKEYR, "HASHKEYR",
+    spr_register_kvm(env, SPR_HASHKEYR, "HASHKEYR",
             SPR_NOACCESS, SPR_NOACCESS,
             &spr_read_generic, &spr_write_generic,
-            hashkeyr_initial_value);
+            KVM_REG_PPC_HASHKEYR, hashkeyr_initial_value);
     spr_register_hv(env, SPR_HASHPKEYR, "HASHPKEYR",
             SPR_NOACCESS, SPR_NOACCESS,
             SPR_NOACCESS, SPR_NOACCESS,



