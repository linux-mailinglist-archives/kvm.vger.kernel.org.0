Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B062263531B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiKWIrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236674AbiKWIrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:47:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB532BA3;
        Wed, 23 Nov 2022 00:47:17 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN7sLhW029553;
        Wed, 23 Nov 2022 08:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=99tkEHRVz/AHqBjmpUDXhzmGqqsCdJI6AVMCEWISEQo=;
 b=Zn7865xcPHSmAQufiYDS41mM8ZdjgCgvn5Sjk2aZxXpw+5a2GrGlA2ym4ZtE7iQBnYZV
 jcZi5pXXIztfzpU9ke6ME56XlLYHLJdsq/4aSJ1HX5gYs01s1USSERC4LbYy9UjFx9P4
 ouqDj1HqciW+4MTENdrHOw1QhBv5/lRIAO9VWDyd2+1pUOWrzUOO3CvQJDhq+8M73WDX
 sANAA1RniHvsz5fBqsvD18Cibb5Id2UVILWu18nRtmfulEwhEio9iY+osUbI8TgA8x5K
 tH4drwUghJJ336pqM7V1eLG+T9w8d/0enmPn8JBluNtFM+/Slzmmh2s0ZGOy0LfxP7jU EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100sqn0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:17 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN8KaEq003262;
        Wed, 23 Nov 2022 08:47:16 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100sqmyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN8Z2SG009977;
        Wed, 23 Nov 2022 08:47:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3kxps8uxm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN8evBh30540266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 08:40:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9373611C054;
        Wed, 23 Nov 2022 08:47:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C82F811C04A;
        Wed, 23 Nov 2022 08:47:10 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 08:47:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/5] s390x: snippets: Fix SET_PSW_NEW_ADDR macro
Date:   Wed, 23 Nov 2022 08:46:53 +0000
Message-Id: <20221123084656.19864-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123084656.19864-1-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t-zMY1j3fKJSRSlR8yXXJjqRRG2Zkw04
X-Proofpoint-ORIG-GUID: z-dKX-91OJjhW237ZBK_hELbwBcE0y2w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=899 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's store the psw mask instead of the address of the location where we
should load the mask from.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.34.1

