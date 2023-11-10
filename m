Return-Path: <kvm+bounces-1486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B43E7E7CC5
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80200B21E12
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FAE3A291;
	Fri, 10 Nov 2023 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XGPoEcjN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EC71CA81
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:49 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A613821E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:48 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADFZq4014119;
	Fri, 10 Nov 2023 13:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=oaWseYGv3XRzIUI4Xfw84IPZQRSJoG1yqWjSNVoIj80=;
 b=XGPoEcjNrcT+nKYvQtpomx54BbsjlHp0wyN03nRlU1ae+1KWVz9BDpZHFz+3nse7Jev6
 +nB4jmUZcSYLXAFgVbk6ofOjH6rMR96pWcS8upNjDMCIbHmlU3lDRhqMJjQLaXC4EEEV
 7kZrAdWilQe896Ya8rO8VSKDDT0bxpcar2eb6cFlIkZuW9DCVTv5k5qEJKb2MVGPTdfK
 +kXsxe/CPLSs8As6BXa7xnb2XfLCqmSJdWJFycAXSbTRd/ENbrUTekMIy+xlIduIJ2ip
 Z4Fo0KCKycgodWqTvw2Lb+RSV5LktVuDzSVaNpHko7xHVztz790vYdjPrnRPCMGlUidR kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n84s9rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:46 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADTRux006124;
	Fri, 10 Nov 2023 13:54:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n84s9ra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:45 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB4RVQ014372;
	Fri, 10 Nov 2023 13:54:45 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:45 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsgQ312780110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D54120040;
	Fri, 10 Nov 2023 13:54:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AB0B20043;
	Fri, 10 Nov 2023 13:54:40 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 26/26] lib: s390x: interrupt: remove TEID_ASCE defines
Date: Fri, 10 Nov 2023 14:52:35 +0100
Message-ID: <20231110135348.245156-27-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vMY11dhR71DMrCi0cEqrq9G966SA3aT-
X-Proofpoint-ORIG-GUID: iLY0VavfMZlZS4RkQ4rhpQxvLdIeAxpv
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
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=777
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1015 mlxscore=0 impostorscore=0 spamscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311100114

These defines were - I can only guess - meant for the asce_id field.
Since print_decode_teid() used AS_PRIM and friends instead, I see little
benefit in keeping these around.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106163738.1116942-9-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 39b43b6..61d156d 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -13,11 +13,6 @@
 #define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
-#define TEID_ASCE_PRIMARY	0
-#define TEID_ASCE_AR		1
-#define TEID_ASCE_SECONDARY	2
-#define TEID_ASCE_HOME		3
-
 union teid {
 	unsigned long val;
 	union {
-- 
2.41.0


