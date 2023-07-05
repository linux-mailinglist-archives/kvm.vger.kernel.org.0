Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289407482D5
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 13:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjGELTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 07:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjGELTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 07:19:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CCBF2;
        Wed,  5 Jul 2023 04:19:52 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 365BGofM013726;
        Wed, 5 Jul 2023 11:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bulY56Kh2UW/F89JkOHGghWGlnnzm6mxYnoHhlLSkUE=;
 b=E2UbpbOj0XrI07c5gLIdtep+pPdAm/WyaxUHl0Zkq1oHPPifZa4x713GznScCqlc/77t
 nDHS9AJOUvVPb4Tmfed3MgKoVIY2wGFW1IjvhuXWC9K/pWEkPGBFXgUoMBq1g80ZAT6P
 Lvi6yl9u36OI8zhQGcBCfbRaqTIxjJIYcNfcjwekEBReiCAWdbhd5zOK4aOONpLgwlJi
 ZL3LA7aEwQjHZG1l5zx9jrypay5hb+lFX9ZdQgyfJuz0H/8nlUZuE58tqeImhdpZBbEs
 A8QRuxirgpHtzj8elE9Hfxui96HYGhrX/BTg22PlGNIvdUNZUh2VsH3z5+fuLgjIIThC BQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rn7gqg1uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 11:19:52 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3658lBul028370;
        Wed, 5 Jul 2023 11:19:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4sv47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 11:19:49 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 365BJi3S17760926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jul 2023 11:19:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73BDE2004B;
        Wed,  5 Jul 2023 11:19:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7FC820043;
        Wed,  5 Jul 2023 11:19:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.77.114])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jul 2023 11:19:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v2 2/2] KVM: s390: pv: fix index value of replaced ASCE
Date:   Wed,  5 Jul 2023 13:19:37 +0200
Message-ID: <20230705111937.33472-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230705111937.33472-1-imbrenda@linux.ibm.com>
References: <20230705111937.33472-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6gHIxpc747O4KkBKipqEJmK5E5aUuUiU
X-Proofpoint-ORIG-GUID: 6gHIxpc747O4KkBKipqEJmK5E5aUuUiU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_02,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307050097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The index field of the struct page corresponding to a guest ASCE should
be 0. When replacing the ASCE in s390_replace_asce(), the index of the
new ASCE should also be set to 0.

Having the wrong index might lead to the wrong addresses being passed
around when notifying pte invalidations, and eventually to validity
intercepts (VM crash) if the prefix gets unmapped and the notifier gets
called with the wrong address.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f4b6fc746fce..7c77f246e101 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2853,6 +2853,7 @@ int s390_replace_asce(struct gmap *gmap)
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
+	page->index = 0;
 	table = page_to_virt(page);
 	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
 
-- 
2.41.0

