Return-Path: <kvm+bounces-18926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3338FD234
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA8D428244B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C5F1494BD;
	Wed,  5 Jun 2024 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bfIlWYIY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7614D2AE
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603117; cv=none; b=rZET+v4ra1Rh195BSNfqOgnRvqgOXBFGhGniD3xmZI6M2pPsjCHiTU4Ewm+ZGkQFS4xki1DnC7+0V0RoqwTBQSWAgZ2gaFwgDIrO5tlN2gO14u7/Bvv2UzewlmALccbLpb4/edRUWEJq7UJDPw9uNZSpvbppiSb5ZohMpl38xPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603117; c=relaxed/simple;
	bh=gXBVoq6Xs7gQ0DJdX1zfdzuLYW3eKW3tWium6g8U0pQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bVeVy4KqAt58qet2yqG+ko7TZUSJTC0iZdlBZ2Huak0FlBkp1QEtjN3jK7cSwKoU31N3HjYbMRQ3chpqYb9eHI/I2jyT/ttqgV5NCMU6YloUc89BsQAz5B6ejU4pppEbQyto6hhL6oPijhdPK1eL5Rh5RLL2YplNQrHyRH9EIAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bfIlWYIY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455FVQMU005873;
	Wed, 5 Jun 2024 15:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=0b0i85d6kI1uu7ZwoBRm+u/PV/OnUj+nyPs8qzet/D0=;
 b=bfIlWYIYVmfy20e4CyQWVzSfP7L+b/JBESeYwhdVry2CVeqihbQoWlKjc/myN8WP9V3m
 sFr0+pwLwWmMXLz9HUn2wIsSQE93BfRNAyMva1/9H81BXx5q/FY2PxClH/iadPD9C7oW
 0Y+Aj1Fr3A16FKEUudfQ2AI2RLAVuN+cP3nFSFQeND1ZWVCVVgzO2sXgxub3pRcrIM9y
 hx8vwQJMFRIt9bia/Ol/u1WVqae7XgIPVvhD64CA/chdf+WwE0L8PTxIqeXb9Tu0d9Fs
 YOYlC7NIloPWPWv66p+pSW/dDU+Kbiiu40+9xdM+a6eF1g/5n6mksKEBFF2NQjS5mNLz 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsta084k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:31 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455FwU7P017530;
	Wed, 5 Jun 2024 15:58:30 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsta084h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:30 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455F12lS026652;
	Wed, 5 Jun 2024 15:58:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yggp34jvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455FwOqB51380720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 15:58:26 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6658E2004F;
	Wed,  5 Jun 2024 15:58:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2C332004D;
	Wed,  5 Jun 2024 15:58:22 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 15:58:22 +0000 (GMT)
Subject: [PATCH v2 4/4] target/ppc/cpu_init: Synchronize HASHPKEYR with KVM
 for migration
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org,
        sbhat@linux.ibm.com, harshpb@linux.ibm.com, vaibhav@linux.ibm.com
Date: Wed, 05 Jun 2024 15:58:22 +0000
Message-ID: <171760309939.1127.5764216864720185982.stgit@ad1b393f0e09>
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
X-Proofpoint-GUID: U1X47I4HOOXKslKVUKzwQID3BTVmx6AX
X-Proofpoint-ORIG-GUID: -f5HJWz56xkbr8ogHkHQKcsFLLtbfLWM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 mlxlogscore=863 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050121

The patch enables HASHPKEYR migration by hooking with the
"KVM one reg" ID KVM_REG_PPC_HASHPKEYR.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 target/ppc/cpu_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index cee0a609eb..e6ebc0cef0 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -5809,11 +5809,11 @@ static void register_power10_hash_sprs(CPUPPCState *env)
             SPR_NOACCESS, SPR_NOACCESS,
             &spr_read_generic, &spr_write_generic,
             KVM_REG_PPC_HASHKEYR, hashkeyr_initial_value);
-    spr_register_hv(env, SPR_HASHPKEYR, "HASHPKEYR",
+    spr_register_kvm_hv(env, SPR_HASHPKEYR, "HASHPKEYR",
             SPR_NOACCESS, SPR_NOACCESS,
             SPR_NOACCESS, SPR_NOACCESS,
             &spr_read_generic, &spr_write_generic,
-            hashpkeyr_initial_value);
+            KVM_REG_PPC_HASHPKEYR, hashpkeyr_initial_value);
 }
 
 static void register_power10_dexcr_sprs(CPUPPCState *env)



