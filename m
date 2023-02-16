Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD958699AE4
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjBPRNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjBPRNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B352A4E5CD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:02 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GFs7da006450
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=PaWAWM9+fPR8oze7+bBM2ZXMLR/yf7n9sRB1PEVsfA0=;
 b=mMWTvE73xe2jzzOriYm5OaszBKzsweyFrvMswmDi8iJFTQKX1EI4evdCKQtxidnwcjhF
 z4Fo2DJOu4nsfwe1mMLuiDvFOJsp2aTxO7CWBr7RKoKb+S7LvmTKcqFrBidQ8SVz5i46
 3bly5nDvmQCLw3ck6bIR4eIBZFaMJFdGhnbNNmPC7ipowQIYFScPbMfAIi9bK5+tcsfj
 SgjWg1ROUejjPrk9A3OFFlMbr0C07j55/+RT5Gdo7zfKNmxAdwC+1rrXULUN5YosSxJw
 gYD032OEAdMop0lxWjQhtQ+Pzd7kWDJgm2Am87zRdb/XF1TKZ9McGliAYbFdyue5vSI8 SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsqhcj0b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GH5kuX028462
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsqhcj0ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G4JYON010684;
        Thu, 16 Feb 2023 17:12:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xyn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCvY735651844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 336CC2005A;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 134B52004D;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 07/10] s390x: snippets: Fix SET_PSW_NEW_ADDR macro
Date:   Thu, 16 Feb 2023 18:12:52 +0100
Message-Id: <20230216171255.48799-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216171255.48799-1-imbrenda@linux.ibm.com>
References: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qiJuXlLIZi8Rb284vTB7DudviYqVrCPO
X-Proofpoint-ORIG-GUID: EHfleHA5Z4xG-JgfWCP8m8rEw05Ask1u
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=934 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's store the psw mask instead of the address of the location where we
should load the mask from.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230112154548.163021-5-frankja@linux.ibm.com
Message-Id: <20230112154548.163021-5-frankja@linux.ibm.com>
---
 s390x/snippets/asm/macros.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/snippets/asm/macros.S b/s390x/snippets/asm/macros.S
index 667fb6dc..09d7f5be 100644
--- a/s390x/snippets/asm/macros.S
+++ b/s390x/snippets/asm/macros.S
@@ -18,7 +18,7 @@
  */
 .macro SET_PSW_NEW_ADDR reg, psw_new_addr, addr_psw
 larl	\reg, psw_mask_64
-stg	\reg, \addr_psw
+mvc	\addr_psw(8,%r0), 0(\reg)
 larl	\reg, \psw_new_addr
 stg	\reg, \addr_psw + 8
 .endm
-- 
2.39.1

