Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905BC638A78
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiKYMnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiKYMnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD42D1ADB6;
        Fri, 25 Nov 2022 04:43:08 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCPqh7012686;
        Fri, 25 Nov 2022 12:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=irjOIF8M8yp3sZ3PswIo74jjI9gPXW3VvYUxA64Wrmc=;
 b=o0YKEX3JUhs2O+bRLyjTbx6clpDYmIMntV9Odimcgz97pLKWoDm5Igtc5WcYB5Td3Vwc
 W6j2mwBEdgi7fGCLUVVk4rcZjWYaeq/G+7ZcZC4PeN+0t9eXuMO8vWu/8vEzDCCL8Kx+
 QejEH5dfAw/jDLd65cBzu1kgpUpb+aCOsCx3YQ+jquBOh/kfiIhxhh1guEMfruC0iQJt
 pdlqOMivt0yISY08ExhhITLOuLMwxURwCT6fKPYak5T0b7UIKP/7/QmS3YxoqQxPUdRS
 F/BrA7iPBHDbfONpxrt4bIzcsf3hosdRQYTYGJz6OGRFtdJDXMuiMv3VxHHnspLQZ7uR 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wq1ga61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:07 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCWFGM002595;
        Fri, 25 Nov 2022 12:43:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wq1ga5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZZIV029884;
        Fri, 25 Nov 2022 12:43:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdj1mb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCh2cL60293538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:43:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 141214C050;
        Fri, 25 Nov 2022 12:43:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96B8D4C044;
        Fri, 25 Nov 2022 12:43:01 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:43:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [GIT PULL 11/15] KVM: s390: pv: avoid export before import if possible
Date:   Fri, 25 Nov 2022 13:39:43 +0100
Message-Id: <20221125123947.31047-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ToOC2cojhyUvHnPWTtMWllZ8yiZzeAnZ
X-Proofpoint-ORIG-GUID: D1GNRZneW7Old1UBANVyZbRjONFLveyW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

If the appropriate UV feature bit is set, there is no need to perform
an export before import.

The misc feature indicates, among other things, that importing a shared
page from a different protected VM will automatically also transfer its
ownership.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111170632.77622-5-imbrenda@linux.ibm.com
Message-Id: <20221111170632.77622-5-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

