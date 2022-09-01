Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A685A9B4A
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 17:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiIAPKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 11:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiIAPKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 11:10:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D664112636
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 08:10:07 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281Eg2U4025223
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 15:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=P+7r6OGhlZiUeGxkUuzV3W+R8ZTMRGpchyqcOwYAV/M=;
 b=mWCYXub3DS17JR413C4iGDw1f9Ke9ICvOyJfUN8WycUARHKdT97LR/YHwyNYOQUn4DjP
 ccBIIinYg0DwLjlAQKW3ttFzwN77FZoxf9AitDaFaweEFdkVgLUOoKBFscLq0KRSyVZC
 XMlZXKzsG0phNPSn4tJu4E1BAQ2fEvz+M/SpPRFNxXaLCsF/34X0zZsxzEQ2dy4li2NN
 /cM1Wod28Bb90s6krek1J68OBe0euhomMUzm2UQsk7wSknAzNI1nPk3OwZdJZcrGJaNJ
 wiGCbjO6FfDI3GsTEnPv+EL6CqOV6vRA1+R2K3399NszfRya+RQAfV5xJzIGHWyaLhZy TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaxqp99qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 15:10:07 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 281Eq04c024469
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 15:10:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaxqp99jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 15:10:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 281F67kp014247;
        Thu, 1 Sep 2022 15:09:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3j8hkabwyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 15:09:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281F9u0H39846194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 15:09:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3C14AE051;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88AEFAE056;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/2] lib/s390x: time: add wrapper for stckf
Date:   Thu,  1 Sep 2022 17:09:55 +0200
Message-Id: <20220901150956.1075828-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220901150956.1075828-1-nrb@linux.ibm.com>
References: <20220901150956.1075828-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BPJaqCsHacfX3csSXfViBctcrGfNFyzY
X-Proofpoint-ORIG-GUID: d-WWzV4bs3aMQN_I6Gi4tp3eq0KdJYXk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=813 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209010068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will do performance measurements of instructions. Since
stck is designed to return unique values even on concurrent calls, it is
unsuited for performance measurements. stckf should be used in this
case.

While touching that code, also add a missing cc clobber in
get_clock_us() and avoid the memory clobber by moving the clock value to
the output operands.

Hence, add a nice wrapper for stckf to the time library.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/time.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 7652a151e87a..8d2327a40541 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -14,11 +14,20 @@
 #define STCK_SHIFT_US	(63 - 51)
 #define STCK_MAX	((1UL << 52) - 1)
 
+static inline uint64_t get_clock_fast(void)
+{
+	uint64_t clk;
+
+	asm volatile(" stckf %0 " : "=Q"(clk) : : "cc");
+
+	return clk;
+}
+
 static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
 
-	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
+	asm volatile(" stck %0 " : "=Q"(clk) : : "cc");
 
 	return clk >> STCK_SHIFT_US;
 }
-- 
2.36.1

