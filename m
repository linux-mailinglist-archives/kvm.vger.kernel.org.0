Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFCD6FA6E8
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjEHKZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 06:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbjEHKZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 06:25:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D202E6B4;
        Mon,  8 May 2023 03:24:34 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348ACkr8012339;
        Mon, 8 May 2023 10:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=aBVBk50Fpf9vVbRQUMonGU5PbfH12aLpkiTizF7yfkI=;
 b=n5F5i0B+c/k1ucgnLWz1EWHMR2olobsW9osNXsAQtnCbip79Ohx/FBuq59XZQBJ3T9rw
 3M/DVZkAx7BiFY8V1O5q3O36JL4zg5hV1fIehDrxkQRG6yPtXZAaoHPTMp1ebv27EvAO
 vVeGrk1XyltTePKuxpuY16kMVsT/ZxxKBWN+1XVRIokfI5pdPq4YJCQhhI/F7N9NhfIy
 EiH7ENDLUxzu52HKhjo+THDVOB9NlAOS8eQTScQ4cav/cb96jSsDBMlu0RwFt5TxYBdJ
 gp7ylExMB8z511C1E5wacE8yYrTmElSVsf+HDw153847JsT6ORGhTtBOeBQabJ2oN0oW Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qexeshurv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:24:33 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348ALwGm011558;
        Mon, 8 May 2023 10:24:32 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qexeshur7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:24:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3484lfDb024440;
        Mon, 8 May 2023 10:24:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qdeh6h1ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:24:30 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348AOQAI62193948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 10:24:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB0022004E;
        Mon,  8 May 2023 10:24:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E1242004D;
        Mon,  8 May 2023 10:24:26 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  8 May 2023 10:24:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] lib: s390x: mmu: fix conflicting types for get_dat_entry
Date:   Mon,  8 May 2023 12:24:26 +0200
Message-Id: <20230508102426.130768-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PMmg4EPSSwXW6uBsjtxTiw6t95oEUKmX
X-Proofpoint-GUID: NzmGGZKpWeLUMxrqvoa4Z-rYlHzs93Us
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=793 clxscore=1015
 priorityscore=1501 bulkscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305080068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This causes compilation to fail with GCC 13:

gcc -std=gnu99 -ffreestanding -I/kut/lib -I/kut/lib/s390x -Ilib -O2 -march=zEC12 -mbackchain -fno-delete-null-pointer-checks -g -MMD -MF lib/s390x/.mmu.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Wno-missing-braces -Werror  -fomit-frame-pointer  -fno-stack-protector    -Wno-frame-address   -fno-pic  -no-pie  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -I/kut/lib -I/kut/lib/s390x -Ilib  -c -o lib/s390x/mmu.o lib/s390x/mmu.c
lib/s390x/mmu.c:132:7: error: conflicting types for ‘get_dat_entry’ due to enum/integer mismatch; have ‘void *(pgd_t *, void *, enum pgt_level)’ [-Werror=enum-int-mismatch]
  132 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level)
      |       ^~~~~~~~~~~~~
In file included from lib/s390x/mmu.c:16:
lib/s390x/mmu.h:96:7: note: previous declaration of ‘get_dat_entry’ with type ‘void *(pgd_t *, void *, unsigned int)’
   96 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
      |       ^~~~~~~~~~~~~

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index 15f88e4f424e..dadc2e600f9a 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -93,6 +93,6 @@ static inline void unprotect_page(void *vaddr, unsigned long prot)
 	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
 }
 
-void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
+void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level);
 
 #endif /* _ASMS390X_MMU_H_ */
-- 
2.39.1

