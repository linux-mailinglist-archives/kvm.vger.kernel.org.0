Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D2F63EB8B
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiLAIsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiLAIrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:47:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7108932B
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:46:50 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B18etXd026068
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JkgfLF8oFDY5kHIkU4EbGBISmMhsaXef0e0sBa4rfj4=;
 b=TNm6lKr1FV5ERb3iRx2OwGm8+USqT+kGPAQlZ1HXZmZwN/KWkTsQzl2TduftB9lve2be
 c/ifwkcPV6J++PcHcACqVLG6I68DidjVJT5mclSs7v3MbVu9NhyoSPoMHTqhvDRgeeoy
 D3OOuKec8Z+ALqPb5B21RAMifQqKouabvveB0a7YNO++RbQeWv17Q+NHTeQDz9YO4Mor
 nYTaW/Zg5q+/ifwvOHMRq5NAelNRJvtf10jbwrtKQW29fkLXq3QXNSXZMT+ESSNorV6J
 q0q+E7xyoyKfyDotIOFQ+iT2Abff60vwg+8MRiaJ9Do8Oir+UyoDLD9xPUoG9gg5rMM/ NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6r8bscfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:46:49 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B18knS0019496
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6r8bsces-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B18aJpj018278;
        Thu, 1 Dec 2022 08:46:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2hy2sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B18khEo9175778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 08:46:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C770FAE045;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91C72AE04D;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/3] lib: s390x: skey: add seed value for storage keys
Date:   Thu,  1 Dec 2022 09:46:41 +0100
Message-Id: <20221201084642.3747014-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221201084642.3747014-1-nrb@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gl5NzhpJtcQomgKdpmJxcmvw7jo3QUAP
X-Proofpoint-ORIG-GUID: G8MPOZhJH_uqiqB6A6kOZcDgc4WHWrmf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=807 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will change storage keys in a loop. To make sure each
iteration of the loops sets different keys, add variants of the storage
key library functions which allow to specify a seed.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/skey.c | 12 +++++++-----
 lib/s390x/skey.h | 14 ++++++++++++--
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
index 100f0949a244..4ab0828ee98f 100644
--- a/lib/s390x/skey.c
+++ b/lib/s390x/skey.c
@@ -14,10 +14,11 @@
 #include <skey.h>
 
 /*
- * Set storage keys on pagebuf.
+ * Set storage keys on pagebuf with a seed for the storage keys.
  * pagebuf must point to page_count consecutive pages.
+ * Only the lower seven bits of the seed are considered.
  */
-void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
+void skey_set_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed)
 {
 	unsigned char key_to_set;
 	unsigned long i;
@@ -30,7 +31,7 @@ void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
 		 * protection as well as reference and change indication for
 		 * some keys.
 		 */
-		key_to_set = i * 2;
+		key_to_set = (i ^ seed) * 2;
 		set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
 	}
 }
@@ -38,13 +39,14 @@ void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
 /*
  * Verify storage keys on pagebuf.
  * Storage keys must have been set by skey_set_keys on pagebuf before.
+ * skey_set_keys must have been called with the same seed value.
  *
  * If storage keys match the expected result, will return a skey_verify_result
  * with verify_failed false. All other fields are then invalid.
  * If there is a mismatch, returned struct will have verify_failed true and will
  * be filled with the details on the first mismatch encountered.
  */
-struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count)
+struct skey_verify_result skey_verify_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed)
 {
 	union skey expected_key, actual_key;
 	struct skey_verify_result result = {
@@ -56,7 +58,7 @@ struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_
 	for (i = 0; i < page_count; i++) {
 		cur_page = pagebuf + i * PAGE_SIZE;
 		actual_key.val = get_storage_key(cur_page);
-		expected_key.val = i * 2;
+		expected_key.val = (i ^ seed) * 2;
 
 		/*
 		 * The PoP neither gives a guarantee that the reference bit is
diff --git a/lib/s390x/skey.h b/lib/s390x/skey.h
index a0f8caa1270b..bba1c131276d 100644
--- a/lib/s390x/skey.h
+++ b/lib/s390x/skey.h
@@ -23,9 +23,19 @@ struct skey_verify_result {
 	unsigned long page_mismatch_addr;
 };
 
-void skey_set_keys(uint8_t *pagebuf, unsigned long page_count);
+void skey_set_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed);
 
-struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count);
+static inline void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
+{
+	skey_set_keys_with_seed(pagebuf, page_count, 0);
+}
+
+struct skey_verify_result skey_verify_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed);
+
+static inline struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count)
+{
+	return skey_verify_keys_with_seed(pagebuf, page_count, 0);
+}
 
 void skey_report_verify(struct skey_verify_result * const result);
 
-- 
2.36.1

