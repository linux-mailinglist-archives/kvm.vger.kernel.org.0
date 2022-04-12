Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C914FDFD9
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352943AbiDLMad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354320AbiDLM23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:28:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95D3CFD0;
        Tue, 12 Apr 2022 04:40:46 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CBNKtQ022048;
        Tue, 12 Apr 2022 11:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dEZMyBG2F5bQs1ea+FT/j7qAWIDOjNDdrP/Rt+mxnHM=;
 b=LStZ87MXJqWJQ1jCogNXx4Ggrw9bzawaozKPksA9JQDiE+AlA97HIVyCb1x0TebiTUl8
 O1s/AfJXTGgeESbmvIu9asUdxHczsF/TQhcuLJ9Dty/hcvB5/ESGAhuVKAn6NdT0Sp0K
 r/lWcX93gNOEdRXEleebS7x0BNOci1925AgwoWQDehG0JM5wRpF4Ds3+Htaw220g3Emu
 VUgt9k39IFxx52TZvPSPDydddSqGWvFs1JM64FCJRCBNLn7V772MtQS3z/X+n5+fgEiR
 jiJ1AuWY2ZGUF2tgyVJIQ0Sh0o1Lh+czInEiZv8MM4AJZOv1Puw5bwnkBKhr5INpgZYD yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd3sjq10e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:40:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CBagjx021177;
        Tue, 12 Apr 2022 11:40:45 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd3sjq0yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:40:45 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CBbri3029479;
        Tue, 12 Apr 2022 11:40:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3fb1s8uvf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:40:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CBedME40174056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 11:40:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A64EA4055;
        Tue, 12 Apr 2022 11:40:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30AF8A4040;
        Tue, 12 Apr 2022 11:40:39 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 11:40:39 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: tprot: use lib include for mmu.h
Date:   Tue, 12 Apr 2022 13:40:39 +0200
Message-Id: <20220412114039.122351-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cb6d8f0b-3fb4-670c-f05e-5755d8352cdf@redhat.com>
References: <cb6d8f0b-3fb4-670c-f05e-5755d8352cdf@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RGiBb7UZOSHYiU_RNjUnss0pUERmJFq4
X-Proofpoint-GUID: l-jIOR5Qi25gNLqdzv60NRgpyvFuQIfZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_03,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=852
 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu.h should come from the library includes

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/tprot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/tprot.c b/s390x/tprot.c
index 460a0db7ffcf..760e7ecdf914 100644
--- a/s390x/tprot.c
+++ b/s390x/tprot.c
@@ -12,7 +12,7 @@
 #include <bitops.h>
 #include <asm/pgtable.h>
 #include <asm/interrupt.h>
-#include "mmu.h"
+#include <mmu.h>
 #include <vmalloc.h>
 #include <sclp.h>
 
-- 
2.31.1

