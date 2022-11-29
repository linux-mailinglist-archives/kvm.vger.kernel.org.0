Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E563BD22
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 10:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiK2JmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 04:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiK2Jlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 04:41:50 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA92F5C0E3
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 01:41:49 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AT9XG3v013404
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7V+4AUsjWv3kv42YawF1p/K8pzaflpQfgyYG6nzC/+o=;
 b=bTNO7M9pae2BFp88ekQsgWca2dlvJTq9Knq76RXxIpORQMqDCvtRyS7VmVElp2JrShy0
 5zRvtKUkDE86ufv2EFC8L/AplvXvsLf52HbnAyY+oyQqvHLFcMTV+la/Ukc4d2BlrZr1
 7YnucESRcOPzdXHDu5QF/P7RbcHkMCsP1sxwkZwqBWCAHtfmajtYJ+ctgZo4P2Gd80GN
 wZIl6ZXzTpHAHewLU5quW7tERpO6Wn7hIjsY6nBQ8yf/tRII5DVsqwH3TDmellpJ89Mz
 5w+hpOnhPAS5dll0rvUlBAwN65loJDnsDanOX/eVdYhb8jZ9NQWCDUCqgMVTyq5JU61F 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5fj6g527-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:41:49 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AT9d20H002232
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:41:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5fj6g51u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 09:41:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AT9c4Ag010586;
        Tue, 29 Nov 2022 09:41:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3m3ae8trx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 09:41:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AT9fh0d24773342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 09:41:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFBB74203F;
        Tue, 29 Nov 2022 09:41:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F8ED42042;
        Tue, 29 Nov 2022 09:41:43 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 09:41:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 1/2] lib: s390x: add PSW and PSW_CUR_MASK macros
Date:   Tue, 29 Nov 2022 10:41:41 +0100
Message-Id: <20221129094142.10141-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129094142.10141-1-imbrenda@linux.ibm.com>
References: <20221129094142.10141-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6w8TUSIjEXFrn2xB0_ZKumLuDqUQP3SL
X-Proofpoint-ORIG-GUID: sX5Pc2cjIk1FOa3zi6wIIpwZ2isQgjFx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_06,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=934 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290059
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
---
 lib/s390x/asm/arch_def.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 783a7eaa..43137d5f 100644
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
 
+#define PSW_CUR_MASK(addr) PSW(extract_psw_mask(), (addr))
+
 static inline void load_psw_mask(uint64_t mask)
 {
 	struct psw psw = {
-- 
2.38.1

