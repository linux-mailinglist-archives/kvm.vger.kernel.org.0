Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69AD63A88A
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 13:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiK1Mip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 07:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiK1Mim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 07:38:42 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBC411160
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 04:38:41 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASBkioJ003992
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=DlsCs6yfsVio8du82tni/6OrQ90mw6wN2dhQLiyOMD4=;
 b=b6HgfGkUdKQCAi34ZzkgmysIk169WTJ2tA6Bm8mNAfV2BqsZILHrf/Q4jP7bBNZnGNZX
 YaVSnadprZMzSQ5Neaa+zVS8Ezf706G5aiAagrM91ApgALWoKiQ+795rWGgYinzVxkHQ
 NrFq90qxTuTPtuKT7H/0bkO2OjJkxL4ITlzQUtsdE6xKOKwzbZ07GAgwzTPQp6LzzzJd
 R10IVc3maimLLn/4hjVvzOSjVl2JB7Bv5fA6Ua5auJb8tlkF81AXE4nVe5htx088a0UR
 bKfSSVQz3r2pyaAn6I2eJuvepIyz2jUJKC+X4RUEqRn7mGABApQYHcrbIO3Tvhvvnyc5 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vnp74jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:38:40 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASC95Nx011569
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:38:40 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vnp74jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 12:38:40 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASCbodR014910;
        Mon, 28 Nov 2022 12:38:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae91tf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 12:38:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASCcZOo65077586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 12:38:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A3FF42049;
        Mon, 28 Nov 2022 12:38:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C793A42041;
        Mon, 28 Nov 2022 12:38:34 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 12:38:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v1 1/1] lib: s390x: add smp_cpu_setup_cur_psw_mask
Date:   Mon, 28 Nov 2022 13:38:34 +0100
Message-Id: <20221128123834.21252-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZPbNyYQ9CD59e45vcBKCb0ZOeVv_XKYA
X-Proofpoint-GUID: XKjIlA6XoJ0HCRteItkfQchuVkMnX50p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_09,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since a lot of code starts new CPUs using the current PSW mask, add a
wrapper to streamline the operation and hopefully make the code of the
tests more readable.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/smp.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index f4ae973d..0bcb1999 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -47,4 +47,13 @@ void smp_setup(void);
 int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
 struct lowcore *smp_get_lowcore(uint16_t idx);
 
+static inline void smp_cpu_setup_cur_psw_mask(uint16_t idx, void *addr)
+{
+	struct psw psw = {
+		.mask = extract_psw_mask(),
+		.addr = (unsigned long)addr,
+	};
+	smp_cpu_setup(idx, psw);
+}
+
 #endif
-- 
2.38.1

