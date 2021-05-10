Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA25D3791EE
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbhEJPGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:06:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29329 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231168AbhEJPDI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:03:08 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AEcRPN060494;
        Mon, 10 May 2021 11:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XUtLXsdceggkbafQ9KIgtpEUlAgSHZJIwuYsMj2R5/0=;
 b=QGt8506qLMt9viOMpiOCw+dEHp2NCRk98bf6ScZazEYvLNSMiWr4mzyglRvKbGyldVzp
 EJvL1uI/sX1fxuYyiKlJp4bBc65sBZTxvxL6ERMUqIXhKnbvijfGxgmDnqcUGQYeMirl
 /FpwxNEU10Ou3Gt0S1hpApEK0WfIq+qqfW53gV4qKU3EinNS12Q5cVoUBO8c/KqXL8tU
 vhCxBXwLq+MXYYi68G4TcrbInmp9ZzIRjDg9RjkoO7pNnYmjIDo5UwvMCK1t3IbBwlUn
 ewiUfBGM9aFz9LpdlV6RSjz0GoI31AXafImj4+kGfn3BC5Fbf4QEND/WyXQ+HIjAFs1/ Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f21t9m7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:02 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AEco5s063044;
        Mon, 10 May 2021 11:02:02 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f21t9m5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:02 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AEtLdr010361;
        Mon, 10 May 2021 15:01:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 38dhwh0jmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 15:01:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AF1ULF22610254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 15:01:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C625AE053;
        Mon, 10 May 2021 15:01:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA08DAE061;
        Mon, 10 May 2021 15:01:55 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 15:01:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH 1/4] s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
Date:   Mon, 10 May 2021 15:00:12 +0000
Message-Id: <20210510150015.11119-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510150015.11119-1-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bLkBwzht5fgRW-Z3tJOLscCymLBxoN-t
X-Proofpoint-ORIG-GUID: laD1Mo8X8BLZYjn_SlO6cVPRX5kS5AqP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpu offset tells us where the cpu entries are in the sclp read
info structure.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 7a9b2c52..f11c2035 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -138,7 +138,8 @@ void sclp_facilities_setup(void)
 	assert(read_info);
 
 	cpu = sclp_get_cpu_entries();
-	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	if (read_info->offset_cpu > 134)
+		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		/*
 		 * The logic for only reading the facilities from the
-- 
2.30.2

