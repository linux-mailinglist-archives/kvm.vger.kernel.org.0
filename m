Return-Path: <kvm+bounces-18637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F708D819E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72B6A281742
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCECF86244;
	Mon,  3 Jun 2024 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bd4/QvxH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFE585C42
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415585; cv=none; b=PcLtIH+M2ZQiA4GiYAz+ao4hQfNh6P75H/wQ2ERaqBcJKMq3Y2mfQT7kUi6lGGYPKoT4dWoorZtWnGpHjTWICpnmKIkLgfaHyjabv9nrL5qkqaj5XhM+49kgEhO5wXHJVWCN6ZTFupWlEmPP4oImtthV40bJICMsUSXO1BpMEf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415585; c=relaxed/simple;
	bh=6ew74vUjui0/dpqWEYv6mHzfrHunlFWDlFf6or2NMmE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M123umxc4YzBZVJanMSS8tQmYD3M/OxDJJSuplRoGr4Pk3qrZViXjLcWUx7A2c4TSAs1y7JITdiIqSvy63v/jTkGq3bblUDlziLBx3yQIvXf4z0pbkO+znSQNGCkzzRRIf6X0BiL/jvyNw5AbmIUMu3KCJuL3q5P6Oa57AmUWj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bd4/QvxH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453Bq8UG032156;
	Mon, 3 Jun 2024 11:52:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=nHN8pbGL+7S0tw+IWhkjkpDrxoe96dNyMyHn5qj/6mY=;
 b=bd4/QvxHo+72e0S4CndKCGVctJjH0DLddf5FjPI/T9lzfh0yZqLeO6+DH9gkyxrxfyke
 dhuQb4qZmmVXSx4EvXyIe7FohPmWmBzwFu8X8hEYScWUDMZU5wvYR68bR4aPMTxm9Uod
 F+d7ZpJuOP9+hShnc9f2l4F1gu95g/qDNC6WzEdniLEQ1g6ax01tRnO6s144xWE+uJNC
 gq4sUggeX3AI5PR7FngVlbZa7jHUk/YIW80IdvQwGWxZeuPxdy5mBxPkCbK+0z/THCAV
 rrYmwbW+I3JztLtfJvTq50oixmUncUAYx39Ty+PPwSv9D4UQRizBggILBLKkEuK9J9fy vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhdb78015-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:52:55 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BqsY4032518;
	Mon, 3 Jun 2024 11:52:54 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhdb78012-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:52:54 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 453A0FxU026628;
	Mon, 3 Jun 2024 11:52:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffmqgfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:52:53 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453BqnQ421168470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:52:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 262432004B;
	Mon,  3 Jun 2024 11:52:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F255120040;
	Mon,  3 Jun 2024 11:52:47 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:52:47 +0000 (GMT)
Subject: [PATCH 1/2] target/ppc/cpu_init: Synchronize DEXCR with KVM for
 migration
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org
Date: Mon, 03 Jun 2024 11:52:47 +0000
Message-ID: <171741556422.11675.17890249605948158450.stgit@c0c876608f2d>
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
X-Proofpoint-GUID: GfIDvydjSrSK7nT8JOnSnb0b3arF4UlA
X-Proofpoint-ORIG-GUID: hufeLzn_pYLqIPyzWkjiq-QEbS9VPX8m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=907 mlxscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030099

The patch enables DEXCR migration by hooking with the
"KVM one reg" ID KVM_REG_PPC_DEXCR.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 linux-headers/asm-powerpc/kvm.h |    1 +
 target/ppc/cpu_init.c           |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index 1691297a76..fcb947f656 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -645,6 +645,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
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



