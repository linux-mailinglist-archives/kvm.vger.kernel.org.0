Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356CE667A0F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240634AbjALP5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbjALP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:56:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8575A62CD;
        Thu, 12 Jan 2023 07:47:38 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFafYX009957;
        Thu, 12 Jan 2023 15:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c62SJHG2j4sax8tnzOM4l8DvZUjd1arD3GDQ0uDymE8=;
 b=LLur9RS5vzA9bfrv8KqOJGXSt0KDRce0/SM82RQLMGOWz7+JdMQOgxg/iDqsiBnAwgux
 SFyaO+QKX7a+WQMMpiCqiOVvNi3fqCoB/ZO3D35t4OzQBEcsU+YjjsauX2k2n+ClXZLb
 FQG0NgH2VNBGqDFnz9kW999fE2702j9LKpLaJ+SDSF8Yk1luM9rTK4YonSidmN6CkgCL
 Un2ceGi1i1tNvt6j62OFaEDs7BAK7PHs0+92mF067x/GgKpaTIt3zVA55U8gU2QD1ViH
 2n4LNXVzDBnjNpYk+hlik/bYlnrVhhG1Fql/GRtop5EC/raxtn6Bwes7WFU5TbFcw9/A PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2m01as01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:47:38 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CEUrxa021256;
        Thu, 12 Jan 2023 15:47:37 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2m01arxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:47:37 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CCGGBs003305;
        Thu, 12 Jan 2023 15:46:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n1kmthydr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CFkaZh23658992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 15:46:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9287920040;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 554EF2004D;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/7] s390x: snippets: Fix SET_PSW_NEW_ADDR macro
Date:   Thu, 12 Jan 2023 15:45:45 +0000
Message-Id: <20230112154548.163021-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112154548.163021-1-frankja@linux.ibm.com>
References: <20230112154548.163021-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o0v8SDN6HTgmqJS9nWGtlx659TNuXFrS
X-Proofpoint-GUID: 82JACaKE5f09KwjDK3n2goBEleNL54Ee
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=981 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's store the psw mask instead of the address of the location where we
should load the mask from.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

