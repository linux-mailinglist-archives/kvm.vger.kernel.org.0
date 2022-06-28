Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EFE55E6F4
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346940AbiF1N4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346259AbiF1N4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:56:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E1F3336F;
        Tue, 28 Jun 2022 06:56:30 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDlEe7020719;
        Tue, 28 Jun 2022 13:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9Jy/lxaIMvsbgkqVtkBljfb5OpijIlsVL8zS7JB9Lv0=;
 b=VLRgSaxEVEjnXtKMiR/5dHI7ZINEKiQWHvNzHJjjbkCl6ATBD3ja6u3oyHm0FAHpeyra
 IYh8e3npa9mFEpQjUoXd3PsRqp+p8637vhPTA2ySrIsRRkydpccOK5aMng4RY5xjOfvF
 8NI8Nzfyu3o5L6+ds1CusibdAb4uPr9Iq0qtesB+lyxWQETgmjv5UtB6yOJCdGM0O2mq
 t/VCULPOQliBGCuVcbbeyB9pFKq56g7bUAtnCaMAe2pqnjXc0gmq/74B9zvSAJzyC38M
 k23qcELzjWb+CSKlYxeukHpcudZ2US5vNgIRxUL4Yq7k4nl5vmeVIkmBlxi03/SmfFv0 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02u7raxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDmDqb023838;
        Tue, 28 Jun 2022 13:56:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02u7raww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDoeMB004286;
        Tue, 28 Jun 2022 13:56:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt08vy10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDuVEt33358178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:56:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 557CF4C044;
        Tue, 28 Jun 2022 13:56:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F17684C04E;
        Tue, 28 Jun 2022 13:56:23 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:56:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v12 10/18] s390/mm: KVM: pv: when tearing down, try to destroy protected pages
Date:   Tue, 28 Jun 2022 15:56:11 +0200
Message-Id: <20220628135619.32410-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q9djnWwsuzDtZ7v52vpXUp6y8_A71uNL
X-Proofpoint-ORIG-GUID: u8N4cVuSZ1l9C2r2UYcOZAFobKxnChVJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=862 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When ptep_get_and_clear_full is called for a mm teardown, we will now
attempt to destroy the secure pages. This will be faster than export.

In case it was not a teardown, or if for some reason the destroy page
UVC failed, we try with an export page, like before.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index f16403ba81ec..cf81acf3879c 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1182,9 +1182,22 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
-	/* At this point the reference through the mapping is still present */
-	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	/* Nothing to do */
+	if (!mm_is_protected(mm) || !pte_present(res))
+		return res;
+	/*
+	 * At this point the reference through the mapping is still present.
+	 * The notifier should have destroyed all protected vCPUs at this
+	 * point, so the destroy should be successful.
+	 */
+	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
+		return res;
+	/*
+	 * If something went wrong and the page could not be destroyed, or
+	 * if this is not a mm teardown, the slower export is used as
+	 * fallback instead.
+	 */
+	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
-- 
2.36.1

