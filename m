Return-Path: <kvm+bounces-745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B387E2275
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73BF41C20B1E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF7F9250F9;
	Mon,  6 Nov 2023 12:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CWObSI8F"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6638E1EB5A
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:54:09 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E000EA;
	Mon,  6 Nov 2023 04:54:07 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cp8W0025491;
	Mon, 6 Nov 2023 12:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JDnNehiSPJ9/zslCmHgsZcCAHdBShTOf7e8/pnZ9O08=;
 b=CWObSI8F9XmUOBs9Dl0SIyVS8AscbU3yfqXwDvhtrTC3q/r1fBXcMrL1/afBjVQRHCi4
 2OIO6VYgNhXCogx5LLAnhVu1iQPMSqmHo9fSxtOKNfRvJSzeuY5Cr53+OEeZilITNebf
 X3tGdpMALR3xUEwGwQoggCdjusXJx+V6yLsieVUld5jVvpEQ/HZvp5YVaBsehfxMe6i8
 eu2kX9IG9Di3+SPNZWk2EzIXl4HH6K7mW3jItF5PMfk4iNc5o5JwrYp66P6FMieMotbi
 TPotRtUg5u4qCDBzE+Pd59WjRIPF1TpIu4hK/YEj9a8fWdOf7CzYXIHDxSCsJQ3JN3Ww Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6v2cge0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:58 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6CrwLO003348;
	Mon, 6 Nov 2023 12:53:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6v2cge06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:58 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AbsAM007958;
	Mon, 6 Nov 2023 12:53:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u60ny9eb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:53:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6CrrI041616104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:53:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83E8820040;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CCD52004B;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:53:53 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev,
        lvivier@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 03/10] lib: s390x: cpacf: move kernel-doc comment to correct function
Date: Mon,  6 Nov 2023 13:50:59 +0100
Message-ID: <20231106125352.859992-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106125352.859992-1-nrb@linux.ibm.com>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jSlSa3acSNUAB9Sm-MTtejwgVFVUAIeZ
X-Proofpoint-ORIG-GUID: DEokkiLRj_5zXfJNVC9Si2_39HF9ihAj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_11,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060104

The kernel-doc comment seems to describe a different function further at
the bottom of the file; move the comment there and adjust the comment
accordingly.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/cpacf.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index 685262b0ff62..378cd5cffcbf 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -137,16 +137,6 @@
 
 typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
 
-/**
- * cpacf_query() - check if a specific CPACF function is available
- * @opcode: the opcode of the crypto instruction
- * @func: the function code to test for
- *
- * Executes the query function for the given crypto instruction @opcode
- * and checks if @func is available
- *
- * Returns 1 if @func is available for @opcode, 0 otherwise
- */
 static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
 	register unsigned long r0 asm("0") = 0;	/* query function */
@@ -200,6 +190,16 @@ static inline int cpacf_test_func(cpacf_mask_t *mask, unsigned int func)
 	return (mask->bytes[func >> 3] & (0x80 >> (func & 7))) != 0;
 }
 
+/**
+ * cpacf_query_func() - check if a specific CPACF function is available
+ * @opcode: the opcode of the crypto instruction
+ * @func: the function code to test for
+ *
+ * Executes the query function for the given crypto instruction @opcode
+ * and checks if @func is available
+ *
+ * Returns 1 if @func is available for @opcode, 0 otherwise
+ */
 static inline int cpacf_query_func(unsigned int opcode, unsigned int func)
 {
 	cpacf_mask_t mask;
-- 
2.41.0


