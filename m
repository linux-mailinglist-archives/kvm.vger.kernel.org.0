Return-Path: <kvm+bounces-18760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B98C8FB1A2
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A84DF1F23C9B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FB1145FE1;
	Tue,  4 Jun 2024 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QudvK+LW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F25145A1E;
	Tue,  4 Jun 2024 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502400; cv=none; b=d4yljcds9avuMxuztszfoHWlvLDhSpMHDuZqqvaTLwlKDbyA/838znd56qedrP2pbRMk6FXtKLIe0uCaIm65fayG45zK4uumwIuNABaw88zPoh5hnjftswDJlFScSf1f/UGOoJGrpPX84zPuzI4L9GUEcv+JNDvlriR1yVTFDBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502400; c=relaxed/simple;
	bh=GfX2m8ASdRy0YWeWEMJPLX6EG2NUQlaKFwOgxXPHbYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czown0mIFZ3wLuhJdCnQaKWKBtpL8YeGRZ2neCAWHQk/s+1uiTv9ctInBsy8x2ttV9jBuTJJRXmaN/tx/rf2QOU/1XynKFNcy1CCLPVj1/NL82YX0afcq7yj/TYmHWNynSuAqZeVfuB8EvEqIkNZ6CxAidU6tK6eSheBiRE+iXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QudvK+LW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454BhQr1017359;
	Tue, 4 Jun 2024 11:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=dND1/5Ad8IpqjKN3cHLjsfzaklArkz4Q/Ih4HFELY8s=;
 b=QudvK+LWAJb3P/uzZKXo6hwCPhHfJxGC8jADRwUwQ5YhFagNOrkXtnt7AUrFM+xSzE75
 lvjthgdleXFLkJxZJcydAB4Cn2WuvGkofhUu8xBL5LFXSsXBKMsfWhMwAZhd1ScWl67I
 y1Ym4B1LBj5IK3MWUqOS4jebuWTd7uUqD++Qzk0aA+Mq/iPXn10iy8Lnp6xt5Jxbn7MP
 RCK41SSYmTOsqU0snyLcsKOf5cPZ83sMTcmwqwSF1IHBM//b047BDTZDd/ytALQBVr84
 Jetmqw8Cu5hD18Uo/JdRYYEqW7t2CF20alHmbx8WWh3/0XnTjRRVjtgPEjaD173mtL3g Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj29qg2er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:57 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454BxvhS012491;
	Tue, 4 Jun 2024 11:59:57 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj29qg2em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:57 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4548YBoa008479;
	Tue, 4 Jun 2024 11:59:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0p1qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 454BxoiD43843988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Jun 2024 11:59:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC0252005A;
	Tue,  4 Jun 2024 11:59:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 409602004B;
	Tue,  4 Jun 2024 11:59:50 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.63.147])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Jun 2024 11:59:50 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 2/3] s390x/Makefile: snippets: Avoid creation of .eh_frame and .eh_frame_hdr sections
Date: Tue,  4 Jun 2024 13:59:31 +0200
Message-ID: <20240604115932.86596-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604115932.86596-1-mhartmay@linux.ibm.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n1-vTNWB3kgjKeITrxvoMnPh-cF9oU2c
X-Proofpoint-ORIG-GUID: ukxcMWBes8kqGeklFS9NqhedZG9HwEf_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406040097

Use `-fno-asynchronous-unwind-tables` and `-fno-exceptions` to avoid creating
`.eh_frame` and `.eh_frame_hdr` sections. They are not used by the snippets and
the creation of the sections may result in the creation of an RWX
segment (depending on the toolchain used).

Before this change:

$ make -j s390x/snippets/c/spec_ex.elf >/dev/null && readelf -l s390x/snippets/c/spec_ex.elf
/usr/bin/s390x-linux-gnu-ld: warning: s390x/snippets/c/spec_ex.elf has a LOAD segment with RWX permissions

Elf file type is EXEC (Executable file)
Entry point 0x4000
There are 4 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000001000 0x0000000000000000 0x0000000000000000
                 0x00000000000001b0 0x00000000000001b0  RW     0x1000
  LOAD           0x0000000000002000 0x0000000000004000 0x0000000000004000
                 0x000000000000104c 0x0000000000001060  RWE    0x1000
  GNU_EH_FRAME   0x0000000000003038 0x0000000000005038 0x0000000000005038
                 0x0000000000000014 0x0000000000000014  R      0x4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     0x10

 Section to Segment mapping:
  Segment Sections...
   00     .lowcore
   01     .text .eh_frame .eh_frame_hdr .bss
   02     .eh_frame_hdr
   03

After this change, there is no warning and no RWX ELF segment:

$ make -j s390x/snippets/c/spec_ex.elf >/dev/null && readelf -l s390x/snippets/c/spec_ex.elf
Elf file type is EXEC (Executable file)
Entry point 0x4000
There are 4 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000001000 0x0000000000000000 0x0000000000000000
                 0x00000000000001b0 0x00000000000001b0  RW     0x1000
  LOAD           0x0000000000002000 0x0000000000004000 0x0000000000004000
                 0x00000000000000a8 0x00000000000000a8  R E    0x1000
  LOAD           0x0000000000000000 0x0000000000005000 0x0000000000005000
                 0x0000000000000000 0x0000000000000010  RW     0x1000
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     0x10

 Section to Segment mapping:
  Segment Sections...
   00     .lowcore
   01     .text
   02     .bss
   03

Linker used:

$ s390x-linux-gnu-ld -v
GNU ld version 2.41-1.fc40

Therefore the commit 9801dbbe9ea4 ("s390x: Specify program headers with flags to
avoid linker warnings") can be reverted.
---
Note: we have to double check whether__builtin_frame_address() in s390x/stack.c
needs the .eh_frame or not.
---
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 784818b2883e..f1bbf5e9f457 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -148,10 +148,10 @@ endif
 
 # the asm/c snippets %.o have additional generated files as dependencies
 $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(CC) $(CFLAGS) -c -nostdlib -fno-asynchronous-unwind-tables -fno-exceptions -o $@ $<
 
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(CC) $(CFLAGS) -c -nostdlib -fno-asynchronous-unwind-tables -fno-exceptions -o $@ $<
 
 $(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
 	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
-- 
2.34.1


