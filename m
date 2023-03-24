Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1209B6C7DAD
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCXMGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjCXMGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:06:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEDF99
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:06:03 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBhVoQ012586
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Fkc/GGdNZ2iIcsG4JdFeUCvG515K6qcjueb48TgfQX4=;
 b=X9ayZHl7yH3RTdXq5z9c4uP0Jlz5sphUbWZVikQAoEXqYcJBvTIqV0PuPW/yNvZ8GvMj
 pj2x62wxH+0pmUNuZpwtUhKuzuprjPUi1xZ/Bq8Mz8SZHhCBOo9e5SSDJV7Bd+b909a3
 h2/JDmcT4iyYChSnAa6jj9Fg06n8szDuDuAIB/KzRCUA5pTVQr8wduC4C/jXoOeeL6Up
 Kk9KIRjQcgvI916gfrppoaQ2zoV2Xh/Ph3AEAeocgOSWSjk6k02dHSSUZw7Tyc9norcU
 gVHYOo3f9eGRC7v0uWOt1UUkPo7XqgGeuieTrBMK+utzVZ/aNx7MOucxHRfPGSrTFyIk pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3phb83ggx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:03 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBiiSE017474
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:06:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3phb83ggwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:06:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NM3aaf029070;
        Fri, 24 Mar 2023 12:06:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pgy7f8nj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:06:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OC5uuY65536360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:05:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 400AB2004B;
        Fri, 24 Mar 2023 12:05:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C10120040;
        Fri, 24 Mar 2023 12:05:55 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:05:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/3] lib: s390x: Introduce UV validity function
Date:   Fri, 24 Mar 2023 12:04:29 +0000
Message-Id: <20230324120431.20260-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324120431.20260-1-frankja@linux.ibm.com>
References: <20230324120431.20260-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vScXkabGjFUMxQrevJvyOvH9QnotMa-D
X-Proofpoint-ORIG-GUID: YOR7P7whntbNrYdJCfxUxEKmoqdAK5zZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PV related validities are in the 0x20** range but the last byte might
be implementation specific, so everytime we check for a UV validity we
need to mask the last byte.

Let's add a function that checks for a UV validity and returns a
boolean.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/uv.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 5fe29bda..78b979b7 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -35,4 +35,11 @@ static inline void uv_setup_asces(void)
 	lctlg(13, asce);
 }
 
+static inline bool uv_validity_check(struct vm *vm)
+{
+	uint16_t vir = sie_get_validity(vm);
+
+	return vm->sblk->icptcode == ICPT_VALIDITY && (vir & 0xff00) == 0x2000;
+}
+
 #endif /* UV_H */
-- 
2.34.1

