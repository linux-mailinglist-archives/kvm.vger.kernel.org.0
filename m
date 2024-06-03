Return-Path: <kvm+bounces-18638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A1AA8D819F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35A8C283405
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF1A86249;
	Mon,  3 Jun 2024 11:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SwKhx9wC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7798284D06
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415597; cv=none; b=WBRIz2P00MYFgaBkwQGxY2U23+MJO8+5uCMUCSLez0myQpSmVG3tI0HENngZoraB2c/qHFznpqdC+7em7cBWGE6ZY2XxVk4ZntYKGuxT91cRZGBU1/tSICq9bvB6gQL6aGRKPOJoMMpp668p8619LG5L9xYCqiFjsCbw6cHm5fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415597; c=relaxed/simple;
	bh=nJcqJgvK6cBD5FCHQ76jpWYS/afXjdpRALGWlAmMQOo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+a/m1VNxBIMQAubuVjgPV4B38A7nqPCaRZ8sNDhvyiuzC9erRxF1U1QWsso70gOpJ8YuLHeGuckUbcwsxMTGrFkbWrvoWemzdfNWOYYglEYnYlnDZfcy0r7VjyQCWXESUsz+byPSsq4hWCLJzpUWbrOH+jV9IJb7A2bYtlLOvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SwKhx9wC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453BoiXl015685;
	Mon, 3 Jun 2024 11:53:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=U8grBbLnuptcbkJz/FoIWfmUXYQni3ocYzh7OnET6Yw=;
 b=SwKhx9wCW7oeRUj7EFjoKDtFdwC4m/714xZgnp18xvHdY8l/TfVt+wgDHgV2GB78S0pP
 5HK4a+EmUlPiVNV3IAUCmDXo1NzFTYqwk7cDvAqzQ4FN/kXqyKG/NYWqp7DoK4AF72KC
 ndHqfnxmtzO5ipAeumWrzwNhiWnCC0ywT0AgSv+nxpxuT8f1jnOdLXdJ0lyQQvaFTLYi
 hKnbo/dwlLwn0PMJez2OcxARJz31FpU0Xqe3sCVoEYbu+QrwCKaaUKE5mETLvkfbBBJP
 3pOgbSxYVbG5ne419tBrsaLfm1Na4wgEuqhbx+c4QUpJStz1+5xqoo4IpMkSvUjRZoSc jA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhctt02rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:53:08 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453Br8CE018854;
	Mon, 3 Jun 2024 11:53:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhctt02rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:53:08 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4538ZNAk000815;
	Mon, 3 Jun 2024 11:53:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygdytqvx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:53:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453Br3XQ10748246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:53:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9B6020043;
	Mon,  3 Jun 2024 11:53:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D9E620040;
	Mon,  3 Jun 2024 11:53:02 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:53:02 +0000 (GMT)
Subject: [PATCH 2/2] target/ppc/cpu_init: Synchronize HASHKEYR with KVM for
 migration
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org
Date: Mon, 03 Jun 2024 11:53:01 +0000
Message-ID: <171741557432.11675.11683958406314165970.stgit@c0c876608f2d>
In-Reply-To: <171741555734.11675.17428208097186191736.stgit@c0c876608f2d>
References: <171741555734.11675.17428208097186191736.stgit@c0c876608f2d>
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
X-Proofpoint-ORIG-GUID: zN48z9-Ppsmfr3TuSvnHQcpH0LUSpptu
X-Proofpoint-GUID: VjdGXuh1SRVgSi_bFcGDJCwttgbvKVOP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=874 phishscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030099

The patch enables HASHKEYR migration by hooking with the
"KVM one reg" ID KVM_REG_PPC_HASHKEYR.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 linux-headers/asm-powerpc/kvm.h |    1 +
 target/ppc/cpu_init.c           |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index fcb947f656..23a0af739c 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -646,6 +646,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
 #define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
+#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
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



