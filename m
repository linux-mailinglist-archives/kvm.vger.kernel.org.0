Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790FC775638
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 11:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjHIJRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 05:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjHIJRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 05:17:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BF71FD0;
        Wed,  9 Aug 2023 02:17:22 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3799CwI3021218;
        Wed, 9 Aug 2023 09:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=am02jmb5JtrP+gVCeAiAasMD67ETNoGQKmAu3VFgC70=;
 b=VDLmjwhxjwW+yDp16V9kgiAk+azZl3m9NfRPY6B8jLfdVOC2ALZFfbAfkBmrrHX4YyqC
 nNy3wuYCJJEwEtXsnhR1gTEkpa6pUYl8COkVlyw0dZsPL35nbbiYzODEmevxfbLvZVwV
 pyYgNbst56nz0v2JB1ieMbOuU/w7So0hvxwcX747kxidV7s+tx8/QF2q66/Vc1nnGSo0
 XOuXOzIM5/zrljvRlCKPKw74B0lg1S/D6lIne2epqkBmduvwqKWpQUAw+7zPhIKENnYq
 TTFArQtySR/aKfnaDtPcidNbnClo7fVYVMH1tP3kJYYE2OC35hjrfIlglW1QHCcqx5TY qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc7ycg4fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 09:17:21 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3799DNRr022407;
        Wed, 9 Aug 2023 09:17:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc7ycg4f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 09:17:21 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3797bpMU015347;
        Wed, 9 Aug 2023 09:17:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sb3f30d74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 09:17:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3799HHiN22414044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Aug 2023 09:17:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63A8C20043;
        Wed,  9 Aug 2023 09:17:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3352520049;
        Wed,  9 Aug 2023 09:17:17 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  9 Aug 2023 09:17:17 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: explicitly mark stack as not executable
Date:   Wed,  9 Aug 2023 11:17:08 +0200
Message-ID: <20230809091717.1549-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W8prwpfZXLY7SDXgDBnsAZm4GZnTXeOU
X-Proofpoint-ORIG-GUID: 2CMbyVsgREoP_zKZlFSQZ6YL2wyqHAEX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_07,2023-08-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308090079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With somewhat recent GCC versions, we get this warning on s390x:

  /usr/bin/ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies executable stack
  /usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

We don't really care whether stack is executable or not since we set it
up ourselves and we're running DAT off mostly anyways.

Silence the warning by explicitly marking the stack as not executable.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 706be7920406..afa47ccbeb93 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -79,7 +79,7 @@ CFLAGS += -O2
 CFLAGS += -march=zEC12
 CFLAGS += -mbackchain
 CFLAGS += -fno-delete-null-pointer-checks
-LDFLAGS += -nostdlib -Wl,--build-id=none
+LDFLAGS += -nostdlib -Wl,--build-id=none -z noexecstack
 
 # We want to keep intermediate files
 .PRECIOUS: %.o %.lds
-- 
2.41.0

