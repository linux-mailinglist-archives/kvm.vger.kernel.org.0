Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1563D99B
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 16:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiK3Pks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 10:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiK3Pkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 10:40:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B7C46675
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 07:40:45 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUFZ7WR018635
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4TpeuFLpRKUpH+mdUrCxxhylF4GftHQsGTScjnqqZZo=;
 b=NbbDz/eC+qyvgnfnberUg6vk6mM5EII+ivkbbxjLlzL9vwU5bMNtMYWQeGe9WNhIc//J
 kfNODABHFBVVBlq40Z2Kk8J7brK0BfbH9EHmArJqoSS8YHhpwXsfNaGVsASad9kYHF+C
 /Y+soP0jJrRN1h76SHAa2eljx0RqHihA+fWXe5AFUSBsS/mD1yj1cnWfxQhJ2xr/jXBo
 tPtJ/bT7j+FutVeWm4AYwtaVLWnxHfHXj859VP/bn/OQ7rf6LI1+71zQ79l7IsAZwQav
 87X+J80kmksAA1whEEgMqlpLiMARyN/wis/V1lo2LbDufLO157Mu2V5RdJuxv3WtTqvs aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m69xs83n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:44 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUFZn9a020521
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:44 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m69xs83m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 15:40:44 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUFZvrr020027;
        Wed, 30 Nov 2022 15:40:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae94ccs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 15:40:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUFY9LL57934130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 15:34:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BB6A5204F;
        Wed, 30 Nov 2022 15:40:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DE74852054;
        Wed, 30 Nov 2022 15:40:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/2] lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
Date:   Wed, 30 Nov 2022 16:40:37 +0100
Message-Id: <20221130154038.70492-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130154038.70492-1-imbrenda@linux.ibm.com>
References: <20221130154038.70492-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ckvh9PKgppxXl3w7scmQ2ObWTfFyBwZY
X-Proofpoint-GUID: yMyY8q27jd_FOQptKK5ADk3ZLLm-BEE7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since a lot of code starts new CPUs using the current PSW mask, add two
macros to streamline the creation of generic PSWs and PSWs with the
current program mask.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 783a7eaa..bb26e008 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -41,6 +41,8 @@ struct psw {
 	uint64_t	addr;
 };
 
+#define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
+
 struct short_psw {
 	uint32_t	mask;
 	uint32_t	addr;
@@ -321,6 +323,8 @@ static inline uint64_t extract_psw_mask(void)
 	return (uint64_t) mask_upper << 32 | mask_lower;
 }
 
+#define PSW_WITH_CUR_MASK(addr) PSW(extract_psw_mask(), (addr))
+
 static inline void load_psw_mask(uint64_t mask)
 {
 	struct psw psw = {
-- 
2.38.1

