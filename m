Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C00C74F184
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjGKOQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjGKOQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F3199F
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:30 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEEXXv003988;
        Tue, 11 Jul 2023 14:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1w8oDebDIlf1n3ms42PasCHjBC07q5/awiRBfsM9bz0=;
 b=NjLTGt8pS/KzIHFt64fJVzI/2c0VN8EJIw9UEsEvPuSMczImfS6ZfvhdaXzZSNhvxChi
 WPwnWk2TcbuKu1t5i93QALUY4wmymQhCfLohxeEEcDlNcELwZ28evt+1A76/RvBXOLDS
 M9qSfFnf8m31MIyA2sgCGWPJHvV5miOewnv3vYpXVThTF4c7H64++SxEDqyZgAxKk8ov
 U/s01oT+hMXO7RZFqmn8pSWNVKt94pNxpUbzim1qyn40CyR6PWPqjw1UicBg4xhFpJfA
 eS2H2JZim7EVfty5oH4/p3uOFiyOirvEYj+PTH2VenZCv9t7jbfFMuBaFqOsbw0uYWIV jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr3bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:20 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEFPl4008179;
        Tue, 11 Jul 2023 14:16:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr37y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B4cixi018978;
        Tue, 11 Jul 2023 14:16:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e1u3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGAsu7602708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADC1220040;
        Tue, 11 Jul 2023 14:16:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC52320049;
        Tue, 11 Jul 2023 14:16:09 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:09 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [PATCH 01/22] lib: s390x: mmu: fix conflicting types for get_dat_entry
Date:   Tue, 11 Jul 2023 16:15:34 +0200
Message-ID: <20230711141607.40742-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s5vxgWiCWnm7qb1Mxy5SJ6mTI34w2BsA
X-Proofpoint-GUID: cPGB8k_PgYBjsySAW-LyL_RrW3UYkpsB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=749 adultscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index 15f88e4..dadc2e6 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -93,6 +93,6 @@ static inline void unprotect_page(void *vaddr, unsigned long prot)
 	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
 }
 
-void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
+void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level);
 
 #endif /* _ASMS390X_MMU_H_ */
-- 
2.41.0

