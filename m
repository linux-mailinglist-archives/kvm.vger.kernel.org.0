Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D916525D9
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiLTRzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiLTRzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:55:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0748FB1CB
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:55:16 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHg5rx018469
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 17:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KkoRCdWyVUp1AeWd6nlRKkemhtYIrrP3mLYFP10lWJQ=;
 b=lv55tmCeRalrSg8AFqRr6WJxl9Wxz8mVF2pyD9dVsfUGJtHLPUyyAseLZSWRlTuDBOhO
 Or3rVsbJBo/QxTUOfJHm1SGHifYr7YlVqXwSb4b4nMxkKT7dDCkHk0LlOluy35us9yv4
 Rm1tQwhHk57B73QX7uaH5ypHudZ3EaP+h0a8lFxsyetqWfAmHeGect8Q1oLhi3pHYBzN
 41g/qAkz1sS06nHMuxf+xJrbZNh2iunWlb6pII+ZJ4iKiM9l6ADjO5BbC4lhWKGQQxYA
 NVAYemSwd5WVcoeFsa6okcHZ11ZHPwNpqom5L8NoyVLqVGSZmL+qwMAHXWj3/OWLbl+f lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkhp409p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 17:55:16 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKHqBlL019142
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 17:55:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkhp409nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:55:15 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHJmF1015566;
        Tue, 20 Dec 2022 17:55:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3mh6yy3594-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:55:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHt9PY47251848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:55:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA3E420043;
        Tue, 20 Dec 2022 17:55:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 376F22004D;
        Tue, 20 Dec 2022 17:55:09 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.2.112])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 17:55:09 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Date:   Tue, 20 Dec 2022 18:55:08 +0100
Message-Id: <20221220175508.57180-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9N8r4HvJgEhTAp6sHUUzxpBNMQ4_5hp8
X-Proofpoint-ORIG-GUID: ia1pCLeVkys4y1s2JVm957cNrqyOykjc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=624 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A recent patch broke make standalone. The function find_word is not
available when running make standalone, replace it with a simple grep.

Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 scripts/s390x/func.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index 2a941bbb..6c75e89a 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -21,7 +21,7 @@ function arch_cmd_s390x()
 	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 
 	# run PV test case
-	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
+	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
 		return
 	fi
 	kernel=${kernel%.elf}.pv.bin
-- 
2.38.1

