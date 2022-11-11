Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E99626002
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 18:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiKKRGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 12:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbiKKRGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 12:06:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835AB7341F;
        Fri, 11 Nov 2022 09:06:47 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABGpLJ0002480;
        Fri, 11 Nov 2022 17:06:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ygebbGXz0lYqdQJxINUIxigHihkBy49WZx6/0vKY7B0=;
 b=D8HXD7OxUBVx9f1TUQYiKiDNyUEjGONeaqoyV1f/UwuGaOIEvkwuhc/5QG21AjsawSnv
 T8S4HtSh01v/+Uo4eAHpuxiQxluvhwKPNVnwnN3+hD5Pge+p9Cejxh2JFVMHlVOxHFHk
 wh+atUGYrRbykLBbetIaeVD+/AG5Z9zZyPOZUNZ9UPILYgkR9nE8Dcn2p/47ObH0AaAx
 GaN8LtAgVNuSkIyKt5OXDaeGEo8joNNb7AqLvFI2asI1qflR70xC2VGNbJ+59aDa72Js
 xeX36AIUYNcojgpvr8n7rX0aL+Qj8Y90JL90PIpndfD1IBfm8AaRAi/L3227BYYgM6JD IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kst99gdba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:47 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ABGuGDP016479;
        Fri, 11 Nov 2022 17:06:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kst99gd9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:46 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ABH6bbC012876;
        Fri, 11 Nov 2022 17:06:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kngpgpkau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ABH6ebH8651274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 17:06:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF5294C04A;
        Fri, 11 Nov 2022 17:06:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ED1E4C040;
        Fri, 11 Nov 2022 17:06:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.65.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Nov 2022 17:06:40 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v16 4/6] KVM: s390: pv: avoid export before import if possible
Date:   Fri, 11 Nov 2022 18:06:30 +0100
Message-Id: <20221111170632.77622-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111170632.77622-1-imbrenda@linux.ibm.com>
References: <20221111170632.77622-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M7mHJvldDek4Hi-YRVHQf6Ndf67lZed6
X-Proofpoint-GUID: gT1wCSWWM2FwMoWApBrfJ3A_995ThIq_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211110115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the appropriate UV feature bit is set, there is no need to perform
an export before import.

The misc feature indicates, among other things, that importing a shared
page from a different protected VM will automatically also transfer its
ownership.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f9810d2a267c..9f18a4af9c13 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -255,6 +255,13 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
  */
 static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
 {
+	/*
+	 * The misc feature indicates, among other things, that importing a
+	 * shared page from a different protected VM will automatically also
+	 * transfer its ownership.
+	 */
+	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
+		return false;
 	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
 		return false;
 	return atomic_read(&mm->context.protected_count) > 1;
-- 
2.38.1

