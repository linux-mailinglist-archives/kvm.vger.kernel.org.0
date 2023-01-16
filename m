Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3ACF66CE7E
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbjAPSNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbjAPSMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2D41CF53
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:04 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHjsC0012040
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s1TrVxOrbrid4TXXGWiTqe5+QdLgY2mWm1BJPwStbbw=;
 b=L06kbI2r0wWrXlwg9lOIFNJI3xOMXg02341BnVgPUIpn+xeSKb0QCQJW69gT7FqDK9R1
 LBdojxy4bjUcYQbUboJKRosPYQ+k+KHnpUVlih8HLjikm+Hd05BV/Zso68zgTb1z/J4O
 pwP7+WC8E1dCGmEFN+3MFq5+wp26ZcY8PlaLUzgNe6TBebRZI5yX91I7XMEPiVwNDhRa
 K0mQTHpwbqt/qmkpkNwAv13wluGuk3nQsZrWGDotoWAtwnxqU2HOL69WXgJzz/OdOU8p
 08sZXZgTNrjH58F7FCXEtDBB+E8zQbtFsm37tiekRvBPx0pmElwuhgTbjMgzyj1r3C7f vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n584n4vw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:03 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHuGWO026418
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n584n4vvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFebfM023789;
        Mon, 16 Jan 2023 17:59:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16jrt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:01 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHwvkD24314422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:58:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B48C2004F;
        Mon, 16 Jan 2023 17:58:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7DA820040;
        Mon, 16 Jan 2023 17:58:56 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:58:56 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 1/9] .gitignore: ignore `s390x/comm.key` file
Date:   Mon, 16 Jan 2023 18:57:49 +0100
Message-Id: <20230116175757.71059-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O9oWROY5IYAFCwG2DBLmsJNrzfR7oFvi
X-Proofpoint-GUID: bSc2B5m8uxfxGrRi5kiwH5MoN6EUoAtg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 mlxlogscore=989 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore the Secure Execution Customer Communication Key file.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 33529b65a7e3..601822d67325 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,5 +28,6 @@ cscope.*
 /s390x/*.bin
 /s390x/snippets/*/*.gbin
 /efi-tests/*
+/s390x/comm.key
 /s390x/snippets/*/*.hdr
 /s390x/snippets/*/*.*obj
-- 
2.34.1

