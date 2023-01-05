Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24B265EA82
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 13:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjAEMPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 07:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbjAEMPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 07:15:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB76559DE
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 04:15:46 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305BooMZ011189
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 12:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=tkDnMC00Tn2Q5YFCgM82W0T5/cOUQ2OtxDaLIVkEBvg=;
 b=o5C/OqTVatSyP8PiTNKY8H3VY2reunJfE1zbOr5pH7V9WA+Od8gtvY0Rsbg0nIJy6Htf
 9patrmM84t3XJhzKnaXOOZp3Jt6DM6Uzl42b/pwytZkRiDSmq/uopWdeWnda3kvJy2om
 UfPABtVlz2WqGHsVZNyooc9hMG+AqSwLd+0OC8yIHrZ3KZMiDGQit6l0NBRRaNPsqpRi
 uTT1f6I9Buk7s7Hi71YvEdxi5b1GMt3Rx6Yt/nxgJ1ACkkFBdUGu/kfGnU/HtYLdoSik
 P9uhWQfq1jrzCUdocd5logg38pAeCfM5i75Slht0WoVZNK1IROLcbolSpIZlpBxp9iGq Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwx1kggxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 12:15:46 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305BrFHC019519
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 12:15:45 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwx1kggwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:15:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3050abUj018137;
        Thu, 5 Jan 2023 12:15:43 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6vwxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:15:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305CFdaZ20054348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 12:15:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB12A2004B;
        Thu,  5 Jan 2023 12:15:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6938220040;
        Thu,  5 Jan 2023 12:15:39 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.26.82])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 12:15:39 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 1/4] lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
Date:   Thu,  5 Jan 2023 13:15:35 +0100
Message-Id: <20230105121538.52008-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105121538.52008-1-imbrenda@linux.ibm.com>
References: <20230105121538.52008-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VxLiAJugX7D9l_myOmhjcCBpvqTK08X4
X-Proofpoint-GUID: SDDEUqboc-e9Dtsg5Bdc583TLCB4pi0X
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=985 suspectscore=0 bulkscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since a lot of code starts new CPUs using the current PSW mask, add two
macros to streamline the creation of generic PSWs and PSWs with the
current program mask.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20221130154038.70492-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221130154038.70492-2-imbrenda@linux.ibm.com>
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
2.39.0

