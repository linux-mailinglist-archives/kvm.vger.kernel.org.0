Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6074F188
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjGKOQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbjGKOQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1117F199A
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:35 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDusdm002279;
        Tue, 11 Jul 2023 14:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=eMUwnJwLL8O5UnpxdSMWsboh/sMAvjdKnvPZgauyY3s=;
 b=C2ptZGzRCeYlqICv0l9mzGpX8gf/X0aTR6ijp2+2Q7o9NuoEAlrPosyUKXJmMHxjCkIh
 PK9wKaHVSKkmlW6z/eUpcp9ImskS3537xnN2AdmVqehOr/Tgr3UXO9JIjZuK4iCHw6y+
 zsQuuGrv73fGblMZGL89xHfLR5qIHnwCNtfO25ZeMK4SY2TEV1OEM1wU/wGrztjsBG5Q
 OWWfKx+c+rAbeZdAo0l/OBXdsZhnusgyqP2ymSybvShO5EBuZvM8z0b93QrA0VyXJ5Ev
 RSbD0zSZkhmP+yQqn6vUCAQVeWGi+tuEBn2VSbSBMqppkWHlosiRg40LRVn8pB2wRyF/ /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0quh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:26 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE61Rb024289;
        Tue, 11 Jul 2023 14:16:20 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0qre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B5ULdq019711;
        Tue, 11 Jul 2023 14:16:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rpye59c72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGCjP9896496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A40A20049;
        Tue, 11 Jul 2023 14:16:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F39CD20043;
        Tue, 11 Jul 2023 14:16:11 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:11 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 04/22] lib: s390x: uv: Introduce UV validity function
Date:   Tue, 11 Jul 2023 16:15:37 +0200
Message-ID: <20230711141607.40742-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iPsfodWHkUKdGDjzU528_T5FrHXVK3hL
X-Proofpoint-GUID: rWN85C1bv5GukPc__C1jtANHXrnjjU20
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

PV related validities are in the 0x20** range but the last byte might
be implementation specific, so everytime we check for a UV validity we
need to mask the last byte.

Let's add a function that checks for a UV validity and returns a
boolean.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-3-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/uv.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 5fe29bd..78b979b 100644
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
2.41.0

