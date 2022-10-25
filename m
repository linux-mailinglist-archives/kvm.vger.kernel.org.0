Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94D760CB2E
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJYLob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiJYLn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFD11735BE
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:57 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8aXH036411
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w9ua085AiVut2l8g9IXu0gftjsh5dHR9PaZsLOOP4dE=;
 b=WVxq2NJerI48C6/zOuIluEomJifkQm7b/6hXHGv9yPtP+JnHu1+BImOBJGwVjVSjFAvw
 OBBsD9hXVqNEyfGbJNYUD8872V4tKEOi3nmbyEa3cj3w/jPMroI1XZY/Mfl01IhyG3eS
 JKqUeyuTdk4kqNT9CSU6KboGeluNhhvcrdvaBxTm7Ye6fwSMmWlljVyxizMfdRrIvmDZ
 p3Ck29OimQ9okkf2lmNML44bhSh3kluZ4iRNU1xyjOSFy8vq9awWCKTHwjkibnqpe2yv
 tfXo0Oywky1sJlRd+GNKhMLJrt3U63ECRxeb8FdRsXPL5T6FccU2WBwL849+8uj3FHh4 Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kedduur3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB8xWe037441
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kedduur32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBcLF8027544;
        Tue, 25 Oct 2022 11:43:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3kc859dhpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhpNn2228914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44ADCAE045;
        Tue, 25 Oct 2022 11:43:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12F24AE051;
        Tue, 25 Oct 2022 11:43:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 21/22] lib: s390x: Enable reusability of VMs that were in PV mode
Date:   Tue, 25 Oct 2022 13:43:44 +0200
Message-Id: <20221025114345.28003-22-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -CfPwPvkX-MeBX90CYdc0KO5za6Jq5Gs
X-Proofpoint-ORIG-GUID: 6J2vyT-blop7CIdfa_dKBjmVFBO0EHyA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Convert the sblk to non-PV when the PV guest is destroyed.

Early return in uv_init() instead of running into the assert. This is
necessary since snippet_pv_init() will always call uv_init().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221021063902.10878-6-frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/uv.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index b2a43424..383271a5 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -76,7 +76,8 @@ void uv_init(void)
 	int cc;
 
 	/* Let's not do this twice */
-	assert(!initialized);
+	if (initialized)
+		return;
 	/* Query is done on initialization but let's check anyway */
 	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 
@@ -188,6 +189,14 @@ void uv_destroy_guest(struct vm *vm)
 	free_pages(vm->uv.conf_var_stor);
 
 	free_pages((void *)(vm->uv.asce & PAGE_MASK));
+	memset(&vm->uv, 0, sizeof(vm->uv));
+
+	/* Convert the sblk back to non-PV */
+	vm->save_area.guest.asce = stctg(1);
+	vm->sblk->sdf = 0;
+	vm->sblk->sidad = 0;
+	vm->sblk->pv_handle_cpu = 0;
+	vm->sblk->pv_handle_config = 0;
 }
 
 int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)
-- 
2.37.3

