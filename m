Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591C3524F2B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354897AbiELOBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354890AbiELOBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:01:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFED23BFB7;
        Thu, 12 May 2022 07:01:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CDttJ2023341;
        Thu, 12 May 2022 14:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vLZtQIAxb9QVcLSh00U4G/o6leqmwTRJMGnEdMhRFck=;
 b=JQH+tqe/RFW9ei9z50ezccU0PkdG28qZxTIUcLNV/lx5XsmnfxQfmWhwfyofXZoQmxm3
 +eTxozS4fzlNmQ7Lf1vctmwty0lkGb03voKe6fGs9cqhta3XuWA57RT9NiVDz0TIsUEk
 zjvvRsVU7xyufRKh9QS+81Ca+dJsq9coRK5aQfaZ5MtnOFH6VTPU5riwiOgQdx93lNVV
 GXUZak8SmbwJlX3842Vpu0KcAlH7zzt9lTbHTy1mKsju66hm1aGcEiihCCiAAIZL8mqI
 tDIvGu2fWYzy3KRZuZMheCG3+ggLTQg54xw3y9SibH6PUP59QXDtLB/uAb1yJA1/kjuP Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g13ja83xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:01:13 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CDvcVL026425;
        Thu, 12 May 2022 14:01:13 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g13ja83w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:01:13 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CDxQDC030622;
        Thu, 12 May 2022 14:01:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3fwg1hwjg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:01:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CE0k2e23658904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 14:00:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21D9FA4054;
        Thu, 12 May 2022 14:01:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3D24A405F;
        Thu, 12 May 2022 14:01:07 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 14:01:07 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/2] lib: s390x: introduce check_pgm_int_code_xfail()
Date:   Thu, 12 May 2022 16:01:06 +0200
Message-Id: <20220512140107.1432019-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220512140107.1432019-1-nrb@linux.ibm.com>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4-X2gw9o6nCZJrQT8w0jaldv1Z4-ZQY9
X-Proofpoint-ORIG-GUID: YYaIN0diWEJrgwKtvqFta44P0TTs0Xmr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_10,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=860 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, it is not very convenient to have expected failures when checking for
program interrupts. Let's introduce check_pgm_int_code_xfail() with an API
similar to report_xfail() to make the programmer's life easier.

With this, we can express check_pgm_int_code() as a special case of
check_pgm_int_code_xfail() with xfail = false.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 1 +
 lib/s390x/interrupt.c     | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index d9ab0bd781c9..88731da9e341 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -46,6 +46,7 @@ void handle_svc_int(void);
 void expect_pgm_int(void);
 void expect_ext_int(void);
 uint16_t clear_pgm_int(void);
+void check_pgm_int_code_xfail(bool xfail, uint16_t code);
 void check_pgm_int_code(uint16_t code);
 
 /* Activate low-address protection */
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 27d3b767210f..b61f7d588550 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -47,14 +47,19 @@ uint16_t clear_pgm_int(void)
 	return code;
 }
 
-void check_pgm_int_code(uint16_t code)
+void check_pgm_int_code_xfail(bool xfail, uint16_t code)
 {
 	mb();
-	report(code == lc->pgm_int_code,
+	report_xfail(xfail, code == lc->pgm_int_code,
 	       "Program interrupt: expected(%d) == received(%d)", code,
 	       lc->pgm_int_code);
 }
 
+void check_pgm_int_code(uint16_t code)
+{
+	check_pgm_int_code_xfail(false, code);
+}
+
 void register_pgm_cleanup_func(void (*f)(void))
 {
 	pgm_cleanup_func = f;
-- 
2.31.1

